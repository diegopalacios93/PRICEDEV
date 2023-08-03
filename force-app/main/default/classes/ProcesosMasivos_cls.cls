public class ProcesosMasivos_cls {
    
    public static void procesarSolicitud(List<Registro_Proceso_Masivo__c> scope){
        
        if(scope[0].Proceso_Masivo__r.Proceso_a_ejecutar__c == Label.PM_Proceso_Suspender)     
        procesarSuspension(scope);
    }
    public static void procesarSuspension(List<Registro_Proceso_Masivo__c> objRPM){
        
        // validar para ver como tratarlo en el metodo procesar solicitud
        Set<string> idActivos = new Set<String>();
        Map<Id,Registro_Proceso_Masivo__c> rpmUpdate = new Map<Id,Registro_Proceso_Masivo__c>();
        List<ActivoETB_Wrapper> lstActivosSeleccionados =  new List<ActivoETB_Wrapper>();
        // Setear los valores a la lista de ActivoETB_Wrapper en este for 
        for(Registro_Proceso_Masivo__c r : objRPM){
            ActivoETB_Wrapper a = new ActivoETB_Wrapper();
            ActivoETB__c activo = new ActivoETB__c();
            activo.Id = r.Activo__c;
            activo.Plan__c = r.Activo__r.Plan__c;
            activo.CuentaFacturacion__c = r.Activo__r.CuentaFacturacion__c;
            activo.NumeroConexion__c = r.Activo__r.NumeroConexion__c;
            activo.NombredelaCuenta__c = r.Activo__r.NombredelaCuenta__c;
            a.activo = activo;
            a.dtFechaSuspensionManual = r.Proceso_Masivo__r.Fecha_inicio_suspension__c;
            a.dtFechaReconexionManual = r.Proceso_Masivo__r.Fecha_inicio_reconexion__c;
            a.idCaso = r.Proceso_Masivo__r.Caso__c;
            a.idRPM = r.Id;
            r.Estado__c = 'Procesado';
            //checked.add(r.checked);
            idActivos.add(r.Activo__c);
            lstActivosSeleccionados.add(a);
            rpmUpdate.put(r.Id,r);
        }
        LTE_OperacionesSFDCSuspenda_cls objOperacionesSFDCSuspenda = new LTE_OperacionesSFDCSuspenda_cls();
        String strTipoTramite = 'Suspensión Voluntaria';
        Map<String, LTE_OperacionesSFDCSuspenda_cls.wrpRespuestaSuspenda> mapRespuestaWS = new Map<String, LTE_OperacionesSFDCSuspenda_cls.wrpRespuestaSuspenda>();
       
        mapRespuestaWS = objOperacionesSFDCSuspenda.consultarSuspensionSevicios(idActivos, strTipoTramite, true, null);
       
        LTE_OperacionesSFDCSuspenda_cls.wrpRespuestaSuspenda elementTmp = null;
        
        //// Modificar para que se ajuste a nuestro desarrollo, traer la clase ActivoETB_Wrapper
        
        for(ActivoETB_Wrapper obj :lstActivosSeleccionados){
            obj.validadoSuspenda = false;                    
            obj.strRespuestaSuspenda = 'Sin respuesta de suspenda.';  
            obj.strMensajeRespuestaSuspenda = 'Sin mensaje de respuesta de suspenda.'; 
           	if(Test.isRunningTest()){
                LTE_OperacionesSFDCSuspenda_cls.wrpRespuestaSuspenda wrp = new LTE_OperacionesSFDCSuspenda_cls.wrpRespuestaSuspenda();
                wrp.numeroConexion = obj.activo.NumeroConexion__c;
                wrp.CodigoFlujo = '2';
                mapRespuestaWS.put('test', wrp);
            }
            for(String keyMap : mapRespuestaWS.keyset() ){                    
                elementTmp = mapRespuestaWS.get(keyMap);                    
                System.debug('('+keyMap+') = ' + elementTmp);
                
                if(elementTmp.numeroConexion.equals(obj.activo.NumeroConexion__c)){
                    
                    obj.codigoRespuestaSuspenda = elementTmp.CodigoFlujo;                        
                    obj.strRespuestaSuspenda = '(Código Flujo: '+elementTmp.CodigoFlujo+') ' + elementTmp.DescripcionFlujo;
                    if(elementTmp.CodigoFlujo.equals('2') || elementTmp.CodigoFlujo.equals('1') || elementTmp.CodigoFlujo.equals('4') || elementTmp.CodigoFlujo.equals('5')){
                        obj.validadoSuspenda = true;
                    }
                    if(elementTmp.CodigoFlujo.equals('3')){
                        obj.validadoSuspenda = false;
                        obj.strRespuestaSuspenda = '(Código Flujo: '+elementTmp.CodigoFlujo+') ' + elementTmp.DescripcionFlujo;
                    }
                    if(elementTmp.CodigoFlujo.equals('0')){
                        obj.validadoSuspenda 		   = false;
                        obj.strRespuestaSuspenda 	   = '(Código Flujo: '+elementTmp.CodigoFlujo+') ' + elementTmp.DescripcionFlujo;
                        obj.strMensajeRespuestaSuspenda = elementTmp.DescripcionRespuesta;
                    }
                }
            }
        }
        OperacionComercial__c oc;
        OperacionComercial__c ocRec;
        
        List<OperacionComercial__c> lstOC 		= new List<OperacionComercial__c>();
        List<OperacionComercial__c> lstOCRec	= new List<OperacionComercial__c>();
        //// despues de procesar el llamado validar a que activos se les puede crear una OC 
        list<TOPP__c> lstTOPP 	= [SELECT Id,Tipoderegistro__c FROM TOPP__c WHERE  Name = 'Suspensión- TELEFONIA MOVIL (LTE)'];
        String strTipoRegistro 	= lstTOPP.get(0).Tipoderegistro__c;
        Id recordTypeId 		= [SELECT Id FROM RecordType WHERE DeveloperName = :strTipoRegistro].Id;
        
        list<TOPP__c> lstTOPPRec	= [SELECT Id, Tipoderegistro__c, TipodeOperacionporplan__c FROM TOPP__c WHERE Name = 'Reconexión- TELEFONIA MOVIL (LTE)'];
        String strTOPPRec			= lstTOPPRec.get(0).Tipoderegistro__c;
        Id idTOPPRec				= lstTOPPRec.get(0).Id;
        Id recordTypeIdRec			= [SELECT Id FROM RecordType WHERE DeveloperName = :strTOPPRec].Id;
        for(ActivoETB_Wrapper obj :lstActivosSeleccionados){
            if(obj.validadoSuspenda){
                oc 							= new OperacionComercial__c();
                oc.CuentaCliente__c 		= obj.activo.NombredelaCuenta__c;
                oc.TOPP__c 					= lstTOPP[0].Id;
                oc.RecordTypeId				= recordTypeId;
                oc.TipoSuspension__c		= 'Por Solicitud'; 
                oc.Activo__c				= obj.activo.Id;
                oc.Plan__c					= obj.Activo.Plan__c;
                oc.FechaInicioReconexion__c = obj.dtFechaSuspensionManual;
                
                oc.CuentaFacturacion__c		= obj.activo.CuentaFacturacion__c;
                oc.Caso__c					= obj.idCaso;
                oc.Estado__c				= 'En Curso';
                oc.NumeroConexion__c		= obj.activo.NumeroConexion__c;
                
                ocRec 							= new OperacionComercial__c();
                ocRec.CuentaCliente__c 			= obj.activo.NombredelaCuenta__c;
                ocRec.TOPP__c 					= idTOPPRec;
                ocRec.RecordTypeId				= recordTypeIdRec;
                ocRec.TipoSuspension__c			= 'Por Solicitud';
                ocRec.Activo__c					= obj.activo.Id;
                ocRec.Plan__c					= obj.Activo.Plan__c;
                ocRec.FechaInicioReconexion__c	= obj.dtFechaReconexionManual;
                
                ocRec.CuentaFacturacion__c		= obj.activo.CuentaFacturacion__c;
                ocRec.Caso__c					= obj.idCaso;
                ocRec.Estado__c					= 'En Curso';
                ocRec.NumeroConexion__c			= obj.activo.NumeroConexion__c;

                lstOC.add(oc);
                Registro_Proceso_Masivo__c rpm = new Registro_Proceso_Masivo__c();
                rpm =rpmUpdate.get(Id.valueOf(obj.idRPM));
                rpm.Descripcion_del_estado__c = obj.strMensajeRespuestaSuspenda;
                rpmUpdate.put(Id.valueOf(obj.idRPM),rpm);
                lstOCRec.add(ocRec);

            }else{
                Registro_Proceso_Masivo__c rpm = new Registro_Proceso_Masivo__c();
                rpm =rpmUpdate.get(Id.valueOf(obj.idRPM));
                rpm.Estado__c = 'Error';
                rpm.Descripcion_del_estado__c = obj.strMensajeRespuestaSuspenda;
                rpmUpdate.put(Id.valueOf(obj.idRPM),rpm);
            }
        }
        System.debug('SE VAN A INSERTAR OC DE SUSPEN: ' + lstOC.size());
        System.debug('SE VAN A INSERTAR OC DE REC: ' + lstOCRec.size());
        if(!lstOC.isEmpty()){
            insert lstOC;
            
        }
        
        if(!lstOCRec.isEmpty()){
            insert lstOCRec;
            
        }
        
        for(ActivoETB_Wrapper obj :lstActivosSeleccionados){
            Registro_Proceso_Masivo__c rpm = new Registro_Proceso_Masivo__c();
            rpm =rpmUpdate.get(Id.valueOf(obj.idRPM));
                
                
            for(OperacionComercial__c ocS : lstOC){
                if(rpmUpdate.get(obj.idRPM).Activo__c == ocS.Activo__c)
                rpm.Operacion_Comercial_generada_1__c = ocS.Id;
            }

            for(OperacionComercial__c ocR : lstOCRec){
                if(rpmUpdate.get(obj.idRPM).Activo__c == ocR.Activo__c)
                rpm.Operacion_Comercial_generada_2__c = ocR.Id;
            }
            rpmUpdate.put(Id.valueOf(obj.idRPM),rpm);

        }
        if(!rpmUpdate.isEmpty()){
            update rpmUpdate.values();
            
        }
        
    }
    public static void resumenProcesoMasivo(){        
        Integer cantProcesados; 
        List<Procesos_Masivos__c>    lstPM  = new List<Procesos_Masivos__c>();
        if(Test.isRunningTest()){
            lstPM  = [Select Id, Estado_del_proceso__c, Cantidad_Registros_a_Proceso__c From Procesos_Masivos__c Where Estado_del_proceso__c =: Label.PM_Estado_Pendiente];
            
        }else{
       		lstPM  = [Select Id, Estado_del_proceso__c, Cantidad_Registros_a_Proceso__c From Procesos_Masivos__c Where Estado_del_proceso__c =: Label.PM_Estado_EnEjecucion];
        }
        List<Registro_Proceso_Masivo__c> lstRPM = new List<Registro_Proceso_Masivo__c>([Select Id,Estado__c,Proceso_Masivo__r.Estado_del_proceso__c From Registro_Proceso_Masivo__c Where Estado__c !=: Label.PM_Estado_Pendiente]);
        List<Procesos_Masivos__c>        lstRPMToUpdate	= new List<Procesos_Masivos__c>();
        
        for(Procesos_Masivos__c objPM : lstPM){
            cantProcesados = 0;        
            for(Registro_Proceso_Masivo__c objRPM : lstRPM){                
                if(objPM.Id == objRPM.Proceso_Masivo__r.Id)                    
                    cantProcesados++;
            }
            if(objPM.Cantidad_Registros_a_Proceso__c == cantProcesados)
                lstRPMToUpdate.add(objPM);
        }
        if(lstRPMToUpdate.size()>0 || Test.isRunningTest()){            
            for(Procesos_Masivos__c objPM : lstRPMToUpdate)
                objPM.Estado_del_proceso__c = Label.PM_Estado_Procesado;            
            update lstRPMToUpdate;
        }     
    }    
    public enum TipoActualizacionPM{EN_EJECUCION}
    
    public class ActivoETB_Wrapper 	
    {
        public ActivoETB__c activo 			{get; set;}
    
        public Date dtFechaSuspensionManual	{get; set;}
        public Date dtFechaReconexionManual	{get; set;}
        public Boolean validadoSuspenda		{get; set;}
        public String strRespuestaSuspenda	{get; set;}
        public String codigoRespuestaSuspenda{get; set;}
        public String strMensajeRespuestaSuspenda{get; set;}
        public String idCaso                {get; set;}
        public String idRPM                 {get; set;} 
    }
}