/**
* Avanxo Colombia
* @author           Manuel Medina href=<mmedina@avanxo.com>
* Project:          ETB
* Description:      Clase encargada de administrar las funcionalidades desencadenadas por el trigger Contract_tgr.
*
* Changes (Version)
* -------------------------------------
*           No.     Date                    Author                  Description
*------------------------------------------------------------------------------------------------------------
* @version  2.0     24/11/2015              Manuel Medina (MM)      Actualizacion del metodo recalcularContratosPadres() para definirlo
*                                                                   como @future con el fin de reducir el limite SOQL por ejecucion ciclica
*                                                                   entre los triggers Contract_tgr y OperacionComercial_tgr.
* @version  2.1     24/11/2015              Manuel Medina (MM)      Se modifica el metodo validarCambios().
* @version  2.2     02/03/2022              Miguel R. Gómez (MG)    Se crea el método actualizar campos Activo
*************************************************************************************************************/
public class contratos_cls {
    
     public static Boolean isFirstTime = true;
    /**
    * @Method:      recalcularContratosPadres
    * @param:       Set<Id> contrLst
    * @Description: Metodo sobre-escrito para soportar compatibilidad con desarrollos dependientes
    * @author       Manuel Medina - 24112015
    */
    public static void recalcularContratosPadres( set<Id> contrLst ){
        Set<String> setIdContratos = new Set<String>();
        for( Id rowId : contrLst ){
            setIdContratos.add( rowId );
        }
        if( !System.isFuture() && !System.isBatch() ){
            recalcularContratosPadres( setIdContratos );
        }
    }
    
    /**
    * @Method:      recalcularContratosPadres
    * @param:       Set<String> contrLst
    * @Description: Metodo @future encargado de actualizar las Contratos (Parent) con los Contratos desencadenantes del trigger Contract_tgr.
    * @author       Manuel Medina - 24112015
    */
    @future
    //public static void recalcularContratosPadres(set<Id> contrLst){
    public static void recalcularContratosPadres( set<String> contrLst ){
        
        list<Contract> cotrHijos=new list<Contract> ([select id,ValorTotaldelcontrato__c,ContractTerm,monto_ejecutado__c,Afecta_Tiempo_Inicial__c,Contrato_Relacionado__c,Contrato_Relacionado__r.Monto_Prima__c,Contrato_Relacionado__r.Fecha_Final_Prima__c,Contrato_Relacionado__r.ContractTerm,EndDate from Contract where Contrato_Relacionado__c IN :contrLst ]);
        map<id,Contract> contrPdr=new map<id,Contract>();
        
        for(Contract ch:cotrHijos){
            
            if(contrPdr.get(ch.Contrato_Relacionado__c)==null){
                contrPdr.put(ch.Contrato_Relacionado__c,ch.Contrato_Relacionado__r);
                contrPdr.get(ch.Contrato_Relacionado__c).Monto_Prima__c=0;
                //contrPdr.get(ch.Contrato_Relacionado__c).Fecha_Final_Prima__c=contrPdr.get(ch.Contrato_Relacionado__c).EndDate;
            }
            //Sumamos los valores de los contratos hijos
            //if(ch.monto_ejecutado__c!=null){
                system.debug('\nMonto_Prima:'+contrPdr.get(ch.Contrato_Relacionado__c).Monto_Prima__c);
                //contrPdr.get(ch.Contrato_Relacionado__c).Monto_Prima__c+=ch.monto_ejecutado__c;
                if(ch.ValorTotaldelcontrato__c!=null){
                contrPdr.get(ch.Contrato_Relacionado__c).Monto_Prima__c+=ch.ValorTotaldelcontrato__c;
                }
            //}
            //Si la fecha de finalizacion es mayor se actualiza el padre
            if(ch.ContractTerm!=null && ch.Afecta_Tiempo_Inicial__c && (contrPdr.get(ch.Contrato_Relacionado__c).Fecha_Final_Prima__c<ch.EndDate || contrPdr.get(ch.Contrato_Relacionado__c).Fecha_Final_Prima__c==null) ){
                contrPdr.get(ch.Contrato_Relacionado__c).Fecha_Final_Prima__c=ch.EndDate;           
            }
            
        
        }
        
        update contrPdr.values();
    }
    
    public void validarCambios(Map<id,Contract> oldMap,Map<id,Contract> newMap){
        
        /* BEGIN - Manuel Medina - Se redefine el tipo de dato del set recalcular de Id a String requerido por el metodo recalcularContratosPadres - 24112015 */
        set<String> recalcular= new set<String>();
        /* END - Manuel Medina - Se redefine el tipo de dato del set recalcular de Id a String requerido por el metodo recalcularContratosPadres - 24112015 */
        
        for(Id ids:newMap.keySet()){
            if(newMap.get(ids).Contrato_Relacionado__c!=null){
                recalcular.add(newMap.get(ids).Contrato_Relacionado__c);
            }
        }
        
        /* BEGIN - Manuel Medina - Se valida que la ejecución del metodo @future no se ejecute desde un hilo de ejecucion FutureHandler - 24112015 */
        if( !System.isFuture() && !System.isBatch() && !recalcular.isEmpty()){
            recalcularContratosPadres(recalcular);
        }
        /* END - Manuel Medina - Se valida que la ejecución del metodo @future no se ejecute desde un hilo de ejecucion FutureHandler - 24112015 */
    }
    
        public void validarCamposContratoActivo(Map<id,Contract> oldMap,Map<id,Contract> newMap)
    {
        ReglasDesarrollos__c reglas = ReglasDesarrollos__c.getValues('Contratos1');
        if(reglas!=null && reglas.Activo__c==true)
        {
        set<id> idContratos = new set<id>();
        for(id idNew :newMap.keySet())
        {
            if(newMap.get(idNew).TipodecontratoETB__c!=Label.TipoContratoETB && newMap.get(idNew).Status=='Vigente' && oldMap.get(idNew).Status!='Vigente' )
            {
                idContratos.add(idNew);
            }
        }
        
        //buscar los contratos
        list<Schema.FieldSetMember> camposContrato = SObjectType.Contract.FieldSets.Validacion.getFields();
        String SQL = 'Select ';
        string mensaje='Los siguientes campos deben ser diligenciados: ';
        for(Schema.FieldSetMember campo : camposContrato)
        {
            SQL+=campo.getFieldPath() + ', ';
            mensaje+=campo.getLabel()+', ';
        }
        SQL += 'Id, Name FROM Contract where id in :idContratos';
        list<Contract> contratos = Database.query(SQL);
        //verificar que los contratos sean validos
        for(Contract contrato:contratos)
        {
            for(Schema.FieldSetMember campo : camposContrato)
            {
                if(contrato.get(campo.getFieldPath())==null)
                {
                    newMap.get(contrato.id).addError(mensaje);
                }
            }
        }
        
        
        }
        
         
    }
    public boolean validacionPerfil(string  perfil_usuario)
    {
        Perfiles_Acciones__c perOf = Perfiles_Acciones__c.getValues('ValidacionesContrato');
        boolean valido=false;
        if(perOf!=null)
        {
            string per=perOf.Usuarios__c;
            for(string valor :per.split(','))
            {
                if(valor==perfil_usuario)
                {
                    valido=true;
                }
            }
        }
        return valido;
    }    
   
    public void procesarContratoColaborador(Contract tmp, Boolean isInsert){
        List<Adiciones_y_prorrogas_contratos__c> lstAdicion_Prorroga = new List<Adiciones_y_prorrogas_contratos__c>();
        list<Conciliaciones_de_contrato__c> 	 lstActas 			 = new list<Conciliaciones_de_contrato__c>();
        decimal	 sumatoriaActasFacturadas 			= 0;
        decimal	 sumatoriaActasNoFacturadas 		= 0;                    
        decimal	 sumatoriaActasNoFacturadasConIva	= 0;
        decimal	 intValorTotal						= 0;
        decimal	 intValorTotalSinIva				= 0;
        decimal	 intSumaValorTotal					= 0;
        decimal  intSumaValorTotalSinIva			= 0;
        decimal	 intSumaValorTotalDolares			= 0;
        Integer  numeroAdiciones	  				= 0;
                     
        if(isInsert){
            // definir supervisor administrativo
            tmp.Supervisor_Administrativo__c = tmp.OwnerId;
        }
        /**************************************************************************************************************/
        //Definir estado del contrato
        if (tmp.Fecha_de_terminacion__c !=null) { 
            if (tmp.Fecha_de_terminacion__c <= DATE.today() && tmp.Status == 'Ejecución')            
                tmp.Status = 'Liquidación';
            else if (tmp.Fecha_de_terminacion__c > DATE.today())
                tmp.Status = 'Ejecución';
        } 
        
        //Obtener las adiciones del contrato
        lstAdicion_Prorroga = consultarAdiciones_prorrogas(tmp.Id);                        
        for(Adiciones_y_prorrogas_contratos__c objAdicionProrroga: lstAdicion_Prorroga){
            intValorTotal 				= (objAdicionProrroga.Valor_total__c==null?0:objAdicionProrroga.Valor_total__c);            
            intValorTotalSinIva			= (objAdicionProrroga.Valor_antes_de_IVA__c==null?0:objAdicionProrroga.Valor_antes_de_IVA__c);
            intSumaValorTotal			= intSumaValorTotal + intValorTotal;
            intSumaValorTotalSinIva		= intSumaValorTotalSinIva + intValorTotalSinIva;
            intSumaValorTotal			= intSumaValorTotal.round();
            intSumaValorTotalSinIva		= intSumaValorTotalSinIva.round();
            intSumaValorTotalDolares	= intSumaValorTotalDolares + (objAdicionProrroga.Valor_sin_IVA_en_dolares__c==null?0:objAdicionProrroga.Valor_sin_IVA_en_dolares__c);
            numeroAdiciones ++;
        }
        // Obtener las actas de pago del contrato
        lstActas = consultarActasContratoColaborador(tmp.Id);
        for(Conciliaciones_de_contrato__c objConciliacion_aux : lstActas){
            if(objConciliacion_aux.Facturado__c  == 'SI'){
                sumatoriaActasFacturadas   		= sumatoriaActasFacturadas   + (objConciliacion_aux.Valor_sin_IVA__c== null?0:objConciliacion_aux.Valor_sin_IVA__c);                                
            }
            if(objConciliacion_aux.Facturado__c == 'NO'){
                sumatoriaActasNoFacturadas 		 = sumatoriaActasNoFacturadas + (objConciliacion_aux.Valor_sin_IVA__c== null?0:objConciliacion_aux.Valor_sin_IVA__c);
                sumatoriaActasNoFacturadasConIva = sumatoriaActasNoFacturadasConIva + (objConciliacion_aux.Valor_total_incluido_IVA__c== null?0:objConciliacion_aux.Valor_total_incluido_IVA__c);
            }
        }
        //-------------------------------------------------------------------------------------------------------------------//
        // Asignar el valor de las adiciones y el valor facturado
        tmp.Valor_adiciones__c     	 	= intSumaValorTotal;
        tmp.Valor_adiciones_sin_iva__c  = intSumaValorTotalSinIva;
        tmp.Numero_de_adiciones__c 	 	= numeroAdiciones;        
        tmp.Facturado__c 				= sumatoriaActasFacturadas;  
        // definir fecha máxima de liquidación
        if(tmp.Fecha_de_terminacion__c != null && tmp.Tiempo_de_liquidacion__c != null){
            tmp.Fecha_maxima_de_liquidacion__c = tmp.Fecha_de_terminacion__c.addMonths(integer.valueof(tmp.Tiempo_de_liquidacion__c));
        }
        // calcular meses ejecutados 
        tmp.Meses_ejecutados_calculado_escritura__c = promediarMeses(tmp.Meses_ejecutados_calculado__c);
        //-------------------------------------------------------------------------------------------------------------------//
        // Fórmulas para tipo de contrato "Fijo"
        if(tmp.Valor_fijo_o_variable__c == 'Fijo'){ 
            tmp.Valor_ejecutado_calculado_escritura__c 	 	 = (tmp.Valor_mes__c==null?0:tmp.Valor_mes__c) * (tmp.Meses_ejecutados_calculado_escritura__c==null?0:(tmp.Meses_ejecutados_calculado_escritura__c).setScale(2));            
            tmp.Valor_total_comprometido__c 				 = (tmp.Valor_ejecutado_calculado_escritura__c==null?0:tmp.Valor_ejecutado_calculado_escritura__c) - (tmp.Facturado__c==null?0:tmp.Facturado__c);
        	tmp.Valor_total_comprometido_conIVA_escritur__c  = (tmp.Valor_total_comprometido__c==null?0:tmp.Valor_total_comprometido__c) + ((tmp.Valor_total_comprometido__c==null?0:tmp.Valor_total_comprometido__c) * integer.valueof(tmp.Porcentaje_IVA__c))/100;
            // Definir meses en mora
            if(tmp.Valor_mes__c != null && tmp.Valor_mes__c != 0)                
                 tmp.Meses_en_mora_calculado_escritura__c = promediarMeses((tmp.Valor_total_comprometido__c==null?0:tmp.Valor_total_comprometido__c) / tmp.Valor_mes__c);
            
            // Definir valor de la deuda
            tmp.Valor_de_la_deuda_calculado_escritura__c 	 = (tmp.Meses_en_mora_calculado_escritura__c==null?0:tmp.Meses_en_mora_calculado_escritura__c)*(tmp.Valor_mes__c==null?0:tmp.Valor_mes__c);
        }
        //-------------------------------------------------------------------------------------------------------------------//
        // Fórmulas para tipo de contrato "Variable"
        if(tmp.Valor_fijo_o_variable__c == 'Variable'){            
           // tmp.Valor_total_comprometido__c 				 = (tmp.Valor_ejecutado_calculado_escritura__c==null?0:tmp.Valor_ejecutado_calculado_escritura__c) - (tmp.Facturado__c==null?0:tmp.Facturado__c);
        	tmp.Valor_total_comprometido_conIVA_escritur__c  = (tmp.Valor_total_comprometido__c==null?0:tmp.Valor_total_comprometido__c) + ((tmp.Valor_total_comprometido__c==null?0:tmp.Valor_total_comprometido__c) * integer.valueof(tmp.Porcentaje_IVA__c))/100;
            // Definir valor de la deuda
            tmp.Valor_de_la_deuda_calculado_escritura__c 	 = (tmp.Valor_total_comprometido__c==null?0:tmp.Valor_total_comprometido__c);
            tmp.Valor_mes__c = null;
        }
        //-------------------------------------------------------------------------------------------------------------------//        
        // definir saldo del contrato sin IVA
        tmp.Saldo_calculado_escritura__c = 	((tmp.Valor_sin_IVA__c==null?0:tmp.Valor_sin_IVA__c) + (tmp.Valor_adiciones_sin_iva__c==null?0:tmp.Valor_adiciones_sin_iva__c)) - (tmp.Valor_ejecutado_calculado_escritura__c==null?0:tmp.Valor_ejecutado_calculado_escritura__c);        
    }
    
    public List<Adiciones_y_prorrogas_contratos__c> consultarAdiciones_prorrogas(String idContrato){        
        List<Adiciones_y_prorrogas_contratos__c> lstAdicion_Prorroga = new List<Adiciones_y_prorrogas_contratos__c>();
        lstAdicion_Prorroga = [
            SELECT Valor_antes_de_IVA__c, Fecha_de_fin__c, Valor_sin_IVA_en_dolares__c, Valor_total__c 
            FROM Adiciones_y_prorrogas_contratos__c
            WHERE Contrato_relacionado__c =: idContrato
            ORDER BY CreatedDate DESC NULLS FIRST
        ];
        return lstAdicion_Prorroga;
    } 
    
    public list<Conciliaciones_de_contrato__c> consultarActasContratoColaborador(String idContrato){   
        list<Conciliaciones_de_contrato__c> lstActas = new list<Conciliaciones_de_contrato__c>();
        lstActas = [Select
                    Name, Descripcion__c, Valor_sin_IVA__c, Porcentaje_IVA__c, IVA__c, Valor_total_incluido_IVA__c,
                    Valor_sin_Iva_en_dolares__c, IVA_en_dolares__c, Valor_total_incluido_IVA_en_dolares__c,
                    Fecha_del_acta__c, Facturado__c, Contrato_relacionado__c, Numero_de_acta__c  
                    from Conciliaciones_de_contrato__c
                    where Contrato_relacionado__c =: idContrato
                    ORDER BY CreatedDate ASC NULLS FIRST
            	   ];
        return lstActas;
    }
    
    public Decimal promediarMeses(Decimal numMesesDif){
        Decimal numMeses = 0;            
        if(numMesesDif > 0){
            numMesesDif = numMesesDif.setScale(2);                              
            Decimal numMesesDecimal = numMesesDif - numMesesDif.round(system.RoundingMode.DOWN);
            Decimal numMesesInteger = numMesesDif - numMesesDecimal;
            
            if(numMesesDecimal<=0.39){
                numMeses = numMesesDif.round(system.RoundingMode.FLOOR);
            }else if(numMesesDecimal>= 0.80){
                numMeses = numMesesDif.round(system.RoundingMode.CEILING);
            }else
                numMeses = numMesesInteger+0.5;
        }    
        return numMeses;
    }

   
    public Class VigenciaContrato{

        public Date fechaInicioContrato {get;set;}       
        public Date fechaFinContrato{get;set;}       
        public Boolean renovacionAutomatica {get;set;}
    }

    /**
    * @description 
    * @author Miguel R. Gómez  miguel.rafael.gomez@accenture.com | 03-02-2022 
    * @param contratosNew 
    * @param contratosOld 
    **/
    public void ActualizarVigenciaActivo(Map<id,Contract>  contratosNew, Map<id,Contract>  contratosOld)
    {
        System.Debug('Entró a ActualizarVigenciaActivo');
        System.Debug('contratosNew '+contratosNew);
        System.Debug('contratosOld '+contratosOld);
        Map<id,VigenciaContrato> datosVigencia = new Map<id,VigenciaContrato>();

        for (id c: contratosNew.keySet())
        {
            if (contratosOld!= null && contratosOld.values().Size()>0 )
            {
                if (contratosNew.get(c).Id == contratosOld.get(c).Id && 
                (contratosNew.get(c).EndDate != contratosOld.get(c).EndDate || contratosNew.get(c).StartDate != contratosOld.get(c).StartDate || 
                contratosNew.get(c).Renovacion_Automatica__c != contratosOld.get(c).Renovacion_Automatica__c   ))
                {
                        VigenciaContrato vigencia = new VigenciaContrato();
                        vigencia.fechaInicioContrato = contratosNew.get(c).StartDate;
                        vigencia.fechaFinContrato = contratosNew.get(c).EndDate;
                        vigencia.renovacionAutomatica = contratosNew.get(c).Renovacion_Automatica__c;
                        datosVigencia.put(c,vigencia);
                }
            }
            else
            {
                VigenciaContrato vigencia = new VigenciaContrato();
                vigencia.fechaInicioContrato = contratosNew.get(c).StartDate;
                vigencia.fechaFinContrato = contratosNew.get(c).EndDate;
                vigencia.renovacionAutomatica = contratosNew.get(c).Renovacion_Automatica__c;
                datosVigencia.put(c,vigencia);
            }
        }

        System.Debug('datosVigencia '+datosVigencia);
      
        if(datosVigencia!=null)
        {
            System.Debug('datosVigencia despues del for de los contratos '+datosVigencia.values().Size());
        }

        List<Legalizacion__c> legalizaciones = [SELECT Id, Name, Contrato__c, Contrato__r.Id FROM Legalizacion__c WHERE Contrato__c IN : datosVigencia.keySet()];

        for (Legalizacion__c leg: legalizaciones)
        {           
            datosVigencia.put(leg.Id,datosVigencia.get(leg.Contrato__r.Id));
        }

        System.Debug('datosVigencia '+datosVigencia);
      
        if(datosVigencia!=null)
        {
            System.Debug('datosVigencia despues de consultar legalizaciones '+datosVigencia.values().Size());
        }

        List<OperacionComercial__c> ocs = [SELECT Id, Name, Activo__c, Activo__r.Id, Legalizacion__c, Legalizacion__r.Id FROM OperacionComercial__c 
                                           WHERE Legalizacion__c IN : datosVigencia.keySet() AND CuentaCliente__r.Segmento__c =: 'MiPymes'];

        for (OperacionComercial__c oc: ocs)
        {           
            datosVigencia.put(oc.Activo__r.Id,datosVigencia.get(oc.Legalizacion__r.Id));
        }

        System.Debug('datosVigencia '+datosVigencia);
      
        if(datosVigencia!=null)
        {
            System.Debug('datosVigencia despues de consultar OC '+datosVigencia.values().Size());
        }


        List<ActivoETB__c> activos = [SELECT Id, Name, RenovacionAutomatica__c, FechaInicioContrato__c, FechaFinalContrato__c FROM ActivoETB__c WHERE Id IN : datosVigencia.keySet()];

        System.Debug('datosVigencia '+datosVigencia);
      
        if(datosVigencia!=null)
        {
            System.Debug('datosVigencia despues de consultar activos '+datosVigencia.values().Size());
        }

        System.Debug('activos antes '+activos);

        for (ActivoETB__c act : activos)
        {
            if (act.FechaInicioContrato__c == null)
            {
                act.FechaInicioContrato__c = datosVigencia.get(act.Id).fechaInicioContrato;
            }

            if (act.FechaFinalContrato__c == null || (act.FechaFinalContrato__c != null && datosVigencia.get(act.Id).fechaFinContrato>act.FechaFinalContrato__c))
            {
                act.FechaFinalContrato__c =datosVigencia.get(act.Id).fechaFinContrato;
            }

            act.RenovacionAutomatica__c = datosVigencia.get(act.Id).renovacionAutomatica;
        }

        System.Debug('activos despues '+activos);
        update activos;
        isFirstTime = false;
    }
}