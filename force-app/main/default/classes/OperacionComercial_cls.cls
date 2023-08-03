/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Hector Bayona
Proyecto:               ETB - E-Services
Descripción:            Clase OperacionComercial_cls

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     08-09-2014  Hector Bayona (Hbayona)       Creación clase.
*******************************************************************************/
public class OperacionComercial_cls {
    
    public map<id,OperacionComercial__c> ocMap=new map<id,OperacionComercial__c>();
    
    public void obtenerCamposOC(set<id> ocIds){
        if(ocMap.isEmpty()){
            ocMap=new map<id,OperacionComercial__c>([
                select Id,topp__r.AplicaPreventa__c, topp__r.TipodeOperacionporplan__c, topp__r.Name,topp__r.Plan__r.Name,
                TOPP__r.Operacion_Relacionada__c, Plan__r.TipodePlan__c,Legalizacion__r.Contrato__c,Legalizacion__c,
                Legalizacion__r.AnalistaSoporteVentas__c, Operacion_Comercial_Relacionada__c, CreatedBy.Profile.Name, CuentaCliente__r.OwnerId,
                Operacion_Comercial_Relacionada__r.Activo__c,Activo__c,topp__r.Plan__r.NombredelProducto__r.Crear_Linea__c,Plan__r.NombredelProducto__r.Name, CreatedById,
                NumeroConexion__c, Estado__c, TOPP__c, Activo__r.Estado__c, Plan__r.NombredelProducto__r.Catalogo__c, RecordType.Name
                from OperacionComercial__c where id In :ocIds]);
        }
    }
    
    public void identificarCambios(map<Id,OperacionComercial__c> ocNew,map<Id,OperacionComercial__c> ocOld){
        //obtenerCamposOC(ocNew.keySet()); 
        set<Id>cambios=new set<Id>();
        set<Id>montoSuperior;    	
        
        for(Id idoc:ocNew.keySet()){
            System.debug('\n\n\nmontos'+ocNew.get(idoc).Monto_Ejecutado_OC__c+''+ocOld.get(idoc).Monto_Ejecutado_OC__c);
            //si la Legalizacion cambio o el Monto Ejecutado
            if(ocNew.get(idoc).Legalizacion__c!= ocOld.get(idoc).Legalizacion__c || ocNew.get(idoc).Monto_Ejecutado_OC__c!= ocOld.get(idoc).Monto_Ejecutado_OC__c || ocNew.get(idoc).topp__c!= ocOld.get(idoc).topp__c){
                
                if(ocNew.get(idoc).Legalizacion__c!=null){
                    cambios.add(ocNew.get(idoc).Legalizacion__c);
                }
                if(ocOld.get(idoc).Legalizacion__c!=null){
                    cambios.add(ocOld.get(idoc).Legalizacion__c);
                }
                
            }
        }
        if(!cambios.isEmpty())
            montoSuperior=recalculoContrato(cambios);
        
        //for(id mS:ocNew.keySet()){
        //    if(montoSuperior.contains(ocNew.get(mS).Legalizacion__c)){
                //ocNew.get(mS).addError('El valor de las operaciones comerciales es superior al monto del contrato');
        //    }    		    	
        //}
    }
    
    public set<Id> recalculoContrato(set<Id> idLeg){
        //set<string> sumanContrato=new set<string>{'Venta','Prorroga','Ampliación'};
        //    set<Id> contratosP=new set<Id>();
        
        list<Legalizacion__c>datLeg=new list<Legalizacion__c>([select id, Contrato__c from Legalizacion__c where id=:idLeg and Contrato__c!=null]);
        set<Id>contra=new set<Id>();
        
        for(Legalizacion__c c:datLeg){
            contra.add(c.Contrato__c);   	
        }
        
        set<Id>montoSuperior=new set<Id>();
        map<Id,Contract> contratos=new map<Id,Contract>();
        
        //list<OperacionComercial__c> ocLst=new list<OperacionComercial__c>([select id,Monto_Ejecutado_OC__c,topp__r.TipodeOperacionporplan__c, Estado__c,Legalizacion__r.Contrato__c,Legalizacion__c,Legalizacion__r.Contrato__r.monto_ejecutado__c,Legalizacion__r.Contrato__r.Contrato_Relacionado__c,Legalizacion__r.Contrato__r.ValorTotaldelcontrato__c,CreatedById from OperacionComercial__c where Legalizacion__r.Contrato__c In :contra]);
        list<AggregateResult> sumaContrato=new list<AggregateResult>([select Legalizacion__r.Contrato__c id,sum(Monto_Ejecutado_OC__c) sum from OperacionComercial__c where Legalizacion__r.Contrato__c In :contra group by Legalizacion__r.Contrato__c]);
        
        for(AggregateResult ar:sumaContrato){
            contratos.put((id)ar.get('id'),
                          new contract(
                              id=(id)ar.get('id'),
                              monto_ejecutado__c=(double)ar.get('sum')
                          )
                         );  	
        }
        update contratos.values();
        
        //Si son hijos recalcula los padres.
        //system.debug('Padres'+contratosP);
        //if(!contratosP.isEmpty()){
        //    contratos_cls.recalcularContratosPadres(contratosP);
        //}
        
        return montoSuperior;
    }
    
    public void ValidacionesOC(map<Id,OperacionComercial__c> ocNew,map<Id,OperacionComercial__c> ocOld){
        
        //obtenerCamposOC(ocNew.keySet());
        set<Id>requiereViab=new set<Id>();
        
        for(id oid:ocNew.keySet()){
            if(ocMap.get(oid).topp__r.AplicaPreventa__c){
                requiereViab.add(oid);    		
            }    	
        }
        
        map<id,Viabilidad__c> viab=new map<id,Viabilidad__c>();
        
        if(requiereViab.isEmpty()){
            viab=viabilidadesAplicaPreventa(requiereViab);		
        }
        
        map<string,Perfiles_Reglas_OC__c>perfiles=Perfiles_Reglas_OC__c.getAll();
        
        for(id ocid:ocNew.keySet()){
            //Escenario01 si la operación comercial aplica para preventa y no tiene viabilidad
            if(ocMap.get(ocid).topp__r.AplicaPreventa__c && viab.get(ocid)==null && !ValidarPerfil(perfiles,'Escenario01',ocNew.get(ocid).ownerId,ocOld.get(ocid).CreatedById)){
                ocNew.get(ocid).addError(label.ReglaOC001+' 1');
            }
            
            //Escenario02 si la operación comercial no aplica para preventa y no tiene  legalización
            if(!ocMap.get(ocid).topp__r.AplicaPreventa__c && ocOld.get(ocid).Legalizacion__c==null && !ValidarPerfil(perfiles,'Escenario02',ocNew.get(ocid).ownerId,ocOld.get(ocid).CreatedById)){
                ocNew.get(ocid).addError(label.ReglaOC001+' 2');
            }
            
            //Escenario03 si la operación comercial aplica para preventa y tiene viabilidad con estado diferente a cerrada
            if(ocMap.get(ocid).topp__r.AplicaPreventa__c && viab.get(ocid)!=null && viab.get(ocid).EstadoViabilidad__c!='Cerrada' && !ValidarPerfil(perfiles,'Escenario03',ocNew.get(ocid).ownerId,ocOld.get(ocid).CreatedById)){
                ocNew.get(ocid).addError(label.ReglaOC001+' 3');
            }
            
            //Escenario04 si la operación comercial aplica para preventa y tiene viabilidad con estado cerrada y respuesta viable
            if(ocMap.get(ocid).topp__r.AplicaPreventa__c && viab.get(ocid)!=null && viab.get(ocid).EstadoViabilidad__c=='Cerrada' && viab.get(ocid).Respuestadeviabilidad__c=='Viable' && !ValidarPerfil(perfiles,'Escenario04',ocMap.get(ocid).ownerId,ocOld.get(ocid).CreatedById)){
                ocNew.get(ocid).addError(label.ReglaOC001+' 4');
            }
            
            //Escenario05 si la operación comercial aplica para preventa y tiene viabilidad con estado cerrada y respuesta NO viable
            if(ocMap.get(ocid).topp__r.AplicaPreventa__c && viab.get(ocid)!=null && viab.get(ocid).EstadoViabilidad__c=='Cerrada' && viab.get(ocid).Respuestadeviabilidad__c=='No Viable' && !ValidarPerfil(perfiles,'Escenario05',ocMap.get(ocid).ownerId,ocOld.get(ocid).CreatedById)){
                ocNew.get(ocid).addError(label.ReglaOC001+' 5');
            }
            
            //Escenario06 si la OC tiene legalización y diligenciado el campo enviado Soporte a la venta  
            if(ocOld.get(ocid).Legalizacion__c!=null && ocOld.get(ocid).EnvSopVen__c!=null && !ValidarPerfil(perfiles,'Escenario06',ocOld.get(ocid).ownerId,ocOld.get(ocid).CreatedById)){
                ocNew.get(ocid).addError(label.ReglaOC001+' 6');
            }
            
            //Escenario07 si la OC tiene legalización y diligenciado el campo enviado Soporte a la venta y diligenciado el campo Enviado a Gte de proyecto 
            if(ocOld.get(ocid).Legalizacion__c!=null && ocOld.get(ocid).EnvSopVen__c!=null && ocOld.get(ocid).EnvGteProy__c!=null && !ValidarPerfil(perfiles,'Escenario07',ocOld.get(ocid).ownerId,ocOld.get(ocid).CreatedById)){
                ocNew.get(ocid).addError(label.ReglaOC001+' 7');
            }
            
            //Escenario08 en estado activa o declinada 
            if((ocOld.get(ocid).Estado__c=='Declinada' || ocOld.get(ocid).Estado__c=='Activa') && !ValidarPerfil(perfiles,'Escenario08',ocOld.get(ocid).ownerId,ocOld.get(ocid).CreatedById)){
                if(!(ocOld.get(ocid).Estado__c=='Declinada' && ocNew.get(ocid).Estado__c=='Pendiente' && ocMap.get(ocid).Legalizacion__r.AnalistaSoporteVentas__c==Userinfo.getUserId())){
                    ocNew.get(ocid).addError(label.ReglaOC001+' 8');
                }
            }
        }
    }
    
    public Boolean ValidarPerfil(map<string,Perfiles_Reglas_OC__c> p, string  Escenario, id propietario,id creador){
        
        Perfiles_Reglas_OC__c myCS1 = Perfiles_Reglas_OC__c.getValues(Escenario);
        Boolean valor =false;
        set<string> perfil=new set<string>(myCS1.Perfiles__c.split(','));
        
        if(perfil.contains(Userinfo.getProfileId()) || (propietario==Userinfo.getUserId() && myCS1.esPropietario__c) || (creador==Userinfo.getUserId() && myCS1.esCreador__c)){
            valor=true;
        }
        
        //Permite desactivar la regla
        if(myCS1.Desactivar__c==true){
            valor=myCS1.Desactivar__c;
        }
        return valor;
    }
    
    public map<id,Viabilidad__c> viabilidadesAplicaPreventa(set<id>ocIdS){
        list<Viabilidad__c> vib=new list<Viabilidad__c>([select id,name,EstadoViabilidad__c,Respuestadeviabilidad__c,OperacionComercial__c from Viabilidad__c where OperacionComercial__c IN :ocIdS ORDER BY CreatedDate ASC NULLS FIRST]);
        map<id,Viabilidad__c> ocViab =new map<id,Viabilidad__c>();
        for(Viabilidad__c v:vib){
            ocViab.put(v.OperacionComercial__c,v);    	
        }
        return ocViab;
    }
    
    //Analisa el estado de la operacion comercial y procesa segun el tipo de operacion por plan
    public void procesarPlanes(map<Id,OperacionComercial__c> ocNew,map<Id,OperacionComercial__c> ocOld){
        
        //Crea lineas Etb
        List<OperacionComercial__c>crearLineas=new List<OperacionComercial__c>();
        
        //obtenerCamposOC(ocNew.keySet());
        map<string,map<id,SObject>> objetosAdicionales=new map<string,map<id,SObject>>();
        
        //Esta Relacion almacena la informacion de la lineas Basicas Etc que necesito actualizar el plan.
        objetosAdicionales.put('ServiciosActualizar',new map<id,SObject>());
        
        //Almacena la clase que debe ser intanciada y el id para procesar
        Map<string,set<id>> claseId=new Map<string,set<id>>();
        set<Id> paraProcesar=new set<Id>();
        //Set con los IDs de los planes
        //Set<Id> planesIds = new Set<Id>();
        
        for(Id i:ocNew.keySet()){
            system.debug(ocNew.get(i).Estado__c+' '+ocOld.get(i).Estado__c);
            if(ocNew.get(i).Estado__c!=ocOld.get(i).Estado__c){
                string clase=ocMap.get(i).topp__r.Plan__r.Name+'.'+ocMap.get(i).topp__r.TipodeOperacionporplan__c+''+ocNew.get(i).Estado__c;
                clase=LibreriaUtilitaria_cls.quitarCaracteresEsp(clase.deleteWhitespace());
                system.debug(clase);
                paraProcesar.add(i);
                
                if(claseId.get(clase)==null){
                    claseId.put(clase,new set<id>());
                }
                claseId.get(clase).add(i);
                
            }
            
            //Crea lineas Etb
            system.debug(ocMap.get(i).topp__r.Plan__r.NombredelProducto__r.Crear_Linea__c+''+ocMap.get(i).NumeroConexion__c+' '+ocNew.get(i).Estado__c);
            if(ocMap.get(i).topp__r.Plan__r.NombredelProducto__r.Crear_Linea__c==true && ocMap.get(i).NumeroConexion__c!=null && ocNew.get(i).Estado__c=='Activa'){
                crearLineas.add(ocMap.get(i));
            }
            
            //Llenar Set con los Ids de los planes
            //planesIds.add(ocNew.get(i).Plan__c);
        }
        
        if(!paraProcesar.isEmpty()){
            Map<id,Linea__c> lineas=new Map<id,Linea__c>([Select Plan_convenio__c,Plan_convenio_anterior__c,Id,ActivoLargaDistancia__c,Activo__c ,Operacion_Comercial_Actual__c,Operacion_Comercial_Anterior__c/*,planLD_anterior__c,planLD__c*/  from Linea__c where Operacion_Comercial_Actual__c In :paraProcesar]);
            objetosAdicionales.put('linea__c',lineas);
        }
        
        //guardar en objetos adicionales los subplanes
        //if(!planesIds.isEmpty()){
            //Map<id,SubPlanFacturacion__c> mapPlanes =new Map<id,SubPlanFacturacion__c>([SELECT Id,Name,PlanLD__c,ProductoLD__c,Tipo__c FROM SubPlanFacturacion__c where PlanLD__c IN :planesIds]);
            //objetosAdicionales.put('SubPlanFacturacion__c',mapPlanes);
        //}
        
        //invoca la clase apropiada para procesar dinamicamente "Especifico Ejemplo Plan Tramite Estado (PlanLargaDistanciaCoveniodeCupo.VentaActiva)"
        for(string c:claseId.keySet()){
            system.debug(c);
            Type t = Type.forName(c);
            if(t!=null){
                OperacionPorPlan_cls.Step paso =(OperacionPorPlan_cls.Step) t.newInstance();
                paso.camposAdicionales=ocMap;
                paso.ocNew=ocNew;
                paso.ocOld=ocOld;
                paso.objetosAdicionales=objetosAdicionales;
                paso.procesar(claseId.get(c));
            }
            
        }
        
        list<SObject> paraActualizar=new list<SObject>();
        for(string objad:objetosAdicionales.keyset()){
            system.debug(objetosAdicionales.get(objad).values());
            paraActualizar.addAll(objetosAdicionales.get(objad).values());
        }
        
        system.debug(objetosAdicionales.get('ServiciosActualizar'));
        
        update paraActualizar;
        
        if(!crearLineas.isEmpty()){
            crearLineas(crearLineas);
        }
    }
    
    public void crearLineas(list<OperacionComercial__c> lineasParaCrear){
        Map<String,linea__c> nuevasLineas=new Map<String,linea__c>();
        for(OperacionComercial__c oc:lineasParaCrear){
            nuevasLineas.put(oc.NumeroConexion__c,new linea__c(Linea_ETB__c='Si',Tipo__c='E.T.B.',Codigo_de_linea__c=oc.NumeroConexion__c,Activo__c=oc.Activo__c,Name=oc.NumeroConexion__c));
        }
        Upsert nuevasLineas.values() Codigo_de_linea__c;
    }
    
    //metodo que realiza la validacion que si esta diligenciado el campo envio gerente o envio soporte no deben ser modificados los campos en la gestion financiera.
    public void validarGestionFinanciera(map<id,OperacionComercial__c> OCnews,map<Id,OperacionComercial__c> OCold)
    {
        //validar si se ejecuta la regla:
        ReglasDesarrollos__c reglas = ReglasDesarrollos__c.getValues('OC1');
        if(reglas!=null && reglas.Activo__c==true)
        {
            //valida que el perfil del usuario este dentro de los permitidos:
            string perfil = userinfo.getProfileId();
            if(!validacionPerfil(perfil))
            {
                //revisa si la operacion comercial tiene el envio gerente o envio soporte diligenciado
                for(id OCid :OCnews.keyset())
                {
                    if(OCnews.get(OCid).EnvGteProy__c!=null || OCnews.get(OCid).EnvSopVen__c!=null)
                    {
                        OperacionComercial__c OCnueva = OCnews.get(OCid);
                        OperacionComercial__c OCvieja = OCold.get(OCid);
                        //se deben revisar los campos del fieldset de gestion financiera si alguno de esos esta diferente debe generar error
                        for(Schema.FieldSetMember campo : SObjectType.OperacionComercial__c.FieldSets.GestionFinanciera.getFields())
                        {
                            
                            if(OCnueva.get(campo.getFieldPath())!=OCvieja.get(campo.getFieldPath()))
                            {
                                OCnews.get(OCid).addError(label.ErrorGestionFinanciera);
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    public boolean validacionPerfil(string  perfil_usuario)
    {
        Perfiles_Acciones__c perOf = Perfiles_Acciones__c.getValues('ValidacionesOC');
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
    
    /**********************************************************************************
* Metodo encargado de actualizar los SpecificationGroup de los servicios adicionales
**********************************************************************************/
    public void actualizarSASpecificationGroupXAActivoRepoReno(Map<Id, OperacionComercial__c> mapOldOc, Map<Id, OperacionComercial__c> mapNewOc){
        System.debug('actualizarSASpecificationGroupXAActivoRepoReno');
        Set<Id> setIdActivasRepoReno = new Set<Id>();
        List<LTE_SpecificationGroupXA__c> lstSGXAtoUpdate = new List<LTE_SpecificationGroupXA__c>();
        //Map<Id, OperacionComercial__c> mapOc = new Map<Id, OperacionComercial__c>([SELECT Id,Activo__c, Estado__c, TOPP__c, TOPP__r.TipodeOperacionporplan__c  FROM OperacionComercial__c WHERE Id in :mapNewOc.keySet()]);
        
        for(OperacionComercial__c oc : ocMap.values()){
            
            System.debug('oc.Id ' + oc.Id);
            System.debug('oc.Estado__c ' + oc.Estado__c);
            System.debug('oc.TOPP__r.TipodeOperacionporplan__c ' + oc.TOPP__r.TipodeOperacionporplan__c);
            if(oc.Estado__c == 'Activa' &&  
               (oc.TOPP__r.TipodeOperacionporplan__c == 'Reposición' || oc.TOPP__r.TipodeOperacionporplan__c == 'Renovación')
              ){
                  setIdActivasRepoReno.add(oc.Activo__c);
              }
            
        }
        System.debug('setIdActivasRepoReno '  + setIdActivasRepoReno);
        //Se van a procesar las OC en estado Activo
        if(!setIdActivasRepoReno.isEmpty()){
            Map<Id, LTE_Servicios_adicionales__c> mapSA = new Map<Id, LTE_Servicios_adicionales__c>([ SELECT Id,Name,LTE_ServicioETB__r.Id,LTE_ServicioETB__r.IMEI_del_Equipo__c, (SELECT Id, Name, LTE_Value__c From SpecificationGroupXA__r) FROM LTE_Servicios_adicionales__c WHERE  LTE_ServicioETB__r.Id =:setIdActivasRepoReno]);
            System.debug('LTE_Servicios_adicionales__c de OPERACIONES COMERCIALES ACTIVA ' + mapSA);
            for(LTE_Servicios_adicionales__c sa : mapSA.values()){
                System.debug('Proceso sa: ' + sa + ' - LISTA ' + sa.SpecificationGroupXA__r );
                for(LTE_SpecificationGroupXA__c sg: sa.SpecificationGroupXA__r){
                    System.debug('--> sa.Name ' + sa.Name );
                    System.debug('----> sg.Name ' + sg.Name );
                    if(sa.Name == 'EQUIPO PROPIEDAD CLIENTE'){
                        if(sg.Name == 'IMEI'){
                            sg.LTE_Value__c = sa.LTE_ServicioETB__r.IMEI_del_Equipo__c;
                            lstSGXAtoUpdate.add(sg);
                        }
                    }
                }
            }
        }
        
        if(!lstSGXAtoUpdate.isEmpty()){
            update lstSGXAtoUpdate;
        }
        
    }
    
    public void CreacionOC(Map<Id,List <OperacionComercial__c>> mapOCAutomaticas, String sEstado){
        Map<Id, TOPP__c> mapTOPP = new Map<Id, TOPP__c>([SELECT Id, Tipoderegistro__c,TipodeOperacionporplan__c FROM TOPP__c WHERE Id = :mapOCAutomaticas.keySet()]);
        list<OperacionComercial__c> lstnewOC = new list<OperacionComercial__c>();
        system.debug(mapTOPP.size());
        for(TOPP__c sglTOPP:mapTOPP.values()){
            if(Schema.Sobjecttype.OperacionComercial__c.getRecordTypeInfosByName().containskey(sglTOPP.Tipoderegistro__c)){
                for(OperacionComercial__c sglOC:mapOCAutomaticas.get(sglTOPP.Id)){
                    OperacionComercial__c newOC = new OperacionComercial__c();
                    newOC.Activo__c = sglOC.Activo__c;
                    newOC.CuentaCliente__c = sglOC.CuentaCliente__c;
                    newOC.CuentaFacturacion__c = sglOC.CuentaFacturacion__c;
                    newOC.Estado__c = sEstado;
                    newOC.Legalizacion__c = sglOC.Legalizacion__c;
                    newOC.PlanLD__c = sglOC.PlanLD__c;
                    newOC.Plan__c = sglOC.Plan__c;
                    newOC.TOPP__c = sglTOPP.Id;
                    newOC.SucursalOrigen__c = sglOC.SucursalOrigen__c;
                    newOC.Contacto_Administrativo__c = sglOC.Contacto_Administrativo__c;
                    newOC.IDServicio__c = sglOC.IDServicio__c;
                    newOC.NumeroConexion__c = sglOC.NumeroConexion__c;
                    if(sglTOPP.TipodeOperacionporplan__c=='Reconexión'){
                        newOC.FechaInicioReconexion__c = sglOC.FechaFinSuspencion__c;
                        newOC.TipoSuspension__c = sglOC.TipoSuspension__c;
                    }
                    newOC.RecordTypeId = Schema.Sobjecttype.OperacionComercial__c.getRecordTypeInfosByName().get(sglTOPP.Tipoderegistro__c).getRecordTypeId();
                    lstnewOC.add(newOC);
                }
            }
        }
        if(!lstnewOC.isEmpty())
            insert lstnewOC;
    }
    
    public void validacionesExperienciaCliente(map<id,OperacionComercial__c> OCnew){
        obtenerCamposOC(ocNew.keySet()); 
        Id profileId=userinfo.getProfileId();
        for(id ocid:OCnew.keySet()){
            if(ocMap.get(ocid).topp__r.TipodeOperacionporplan__c == 'Venta'){
                if(ocMap.get(ocid).CreatedBy.Profile.Name == 'Agentes de ventas Experiencia' && ocMap.get(ocid).CuentaCliente__r.OwnerId == UserInfo.getUserId()){
                    ocNew.get(ocid).addError('Si la OC de venta fue creada por un usuario del perfil "Agentes de ventas Experiencia", esta no puede ser modificada por el propietario de la cuenta.');
                }
                if(ocMap.get(ocid).CreatedById == ocMap.get(ocid).CuentaCliente__r.OwnerId && profileId == Label.Agentes_de_ventas_Experiencia){
                    ocNew.get(ocid).addError('Si la OC de venta fue creada por el propietario de la cuenta, esta no puede ser modificada por usuarios del perfil "Agentes de ventas Experiencia"');
                }
            }   
        }
    }
    
    public void actualizarCodigoCCE(Map<id,OperacionComercial__c> ocNewMap, Map<String,List<Map<String,String>>> mpListaValores){
        String funcionalidades;
        List<String> lstFuncionalidades = new List<String>();
        String codigoCCE, codigoCCEDefault, unidad, KeyText;
        Integer count;
        Boolean existsCode  = false;
        Boolean DefaultZone = false;
        for(id ocId:ocNewMap.keySet()){
            count = 0;
            codigoCCE = '';
            codigoCCEDefault = '';
            unidad = '';
            if(ocNewMap.get(ocId).Funcionalidades__c != null && ocNewMap.get(ocId).Colombia_Compra_Eficiente__c != 'No Aplica' && mpListaValores.containsKey(ocNewMap.get(ocId).Tipo_de_Plan__c)){
                funcionalidades = ocNewMap.get(ocId).Funcionalidades__c;
                lstFuncionalidades = funcionalidades.split(';');
                unidad = ocNewMap.get(ocId).Unidad__c;  
                
                if(ocNewMap.get(ocId).Zona__c == 'Avanzada' || ocNewMap.get(ocId).Zona__c == 'Básica' || ocNewMap.get(ocId).Zona__c == 'Moderada' || ocNewMap.get(ocId).Zona__c == 'No Aplica')
                    DefaultZone = true;
                
                for(String sglFunc:lstFuncionalidades){
                    count = count+1;
                    codigoCCE = codigoCCE+'CO';                                         
                    for(Map<String,String> sglListaValores:mpListaValores.get(ocNewMap.get(ocId).Tipo_de_Plan__c)){
                        KeyText = '';                        
						if(DefaultZone){
                            KeyText = ocNewMap.get(ocId).Tipo_de_Plan__c+'-'+sglFunc+'-'+ocNewMap.get(ocId).Zona__c+'-'+ocNewMap.get(ocId).Unidad__c;                            
                            if(KeyText == sglListaValores.get('Prefijo__c')){                                
                                codigoCCEDefault = codigoCCEDefault+sglListaValores.get('Codigo__c');                                 
                                break;  
                            }
                        }else{
                            if(sglListaValores.get('Prefijo__c') == 'EX' || sglListaValores.get('Prefijo__c') == 'MI' || sglListaValores.get('Prefijo__c') == 'AD' || sglListaValores.get('Prefijo__c') == 'SL' || sglListaValores.get('Prefijo__c') == 'SO'){
                                if(sglFunc == sglListaValores.get('Funcionalidades__c')){                                
                                    codigoCCE = codigoCCE+'-'+sglListaValores.get('Prefijo__c');
                                    codigoCCE = codigoCCE+'-'+sglListaValores.get('Codigo__c');                            
                                    for(Map<String,String> sglZona:mpListaValores.get('Zona')){
                                        if(ocNewMap.get(ocId).Zona__c == sglZona.get('Funcionalidades__c')){
                                            codigoCCE = codigoCCE+'-'+sglZona.get('Codigo__c');
                                        }
                                    }      
                                    existsCode = true;
                                    break;
                                }
                            }
                        }
                    }                    
                    if(count>0 && lstFuncionalidades.size()>count){
                        codigoCCE = codigoCCE+'; ';
                        if(codigoCCEDefault != '')
                        	codigoCCEDefault = codigoCCEDefault+'; ';
                    }
                }
            }        
            
            if((DefaultZone && codigoCCEDefault == '') || (!DefaultZone && !existsCode))
            	ocNewMap.get(ocId).Identificacion_Colombia_Compra_Eficiente__c = '-';
            else{
               if(codigoCCEDefault != '')
                	ocNewMap.get(ocId).Identificacion_Colombia_Compra_Eficiente__c = codigoCCEDefault;
               else
                    ocNewMap.get(ocId).Identificacion_Colombia_Compra_Eficiente__c = codigoCCE;
            }
        }
    }  
}