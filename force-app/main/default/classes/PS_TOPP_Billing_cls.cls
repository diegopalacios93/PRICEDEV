/*******************************************************************************
Desarrollado por:       ETB
Autor:                  John Guevara
Proyecto:               Portafolio Superior II
Descripcion:            Clase para el manejo de operaciones RevChain

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripcion
------  ----------  --------------------        ---------------
1.0     29-03-2019  John Guevara (JG)			Clase padre para el proceso de operaciones por plan hacia RevChain   
*******************************************************************************/
public class PS_TOPP_Billing_cls {
    
    public Map<Id,Map<String,Object>> LoadMap(Set<Id> lstOCIds){
        
        Mensaje_Integracion__c lstMensajes = [SELECT Id,Mensaje__c FROM Mensaje_Integracion__c WHERE Name ='Campos Facturacion PS'];
        String sFields = lstMensajes.Mensaje__c;
        Set<String> setFields = new Set<String>();
        setFields.addAll(sFields.split(','));
        
        String sql = 'SELECT '+sFields+' FROM OperacionComercial__c WHERE Id IN :lstOCIds';
        List<OperacionComercial__c> lstOC = Database.query(sql);
        
        
        Set<Id> lstPlanId = new Set<Id>();
        Set<Id> lstOCId = new Set<Id>();
        Set<Id> lstCtaFacturacion = new Set<Id>();
        for(OperacionComercial__c sglOC:lstOC){
            lstPlanId.add(sglOC.Plan__c);
            lstOCId.add(sglOC.Id);
            lstCtaFacturacion.add(sglOC.CuentaFacturacion__c);
        }
        
        Set<String> paramFields = new Set<String>();
        
        map<Id, CuentaFacturacion__c> CtasFacturacion = new map<Id, CuentaFacturacion__c>([select id,Name,LTE_NombreCuentaFacturacion__c,TipoFactura__c,MedioFacturacion__c,LTE_MetodoEnvio__c,
                                                                                           LTE_Email__c,Fin_de_consumo__c,DirCorresp__c,Ciudad__r.CodigoDane__c,
                                                                                           Ciudad__r.Padre__r.CodigoDane__c,Ciudad__r.Name
                                                                                           from CuentaFacturacion__c where Id =: lstCtaFacturacion]);
        
        map<Id, PlanFacturacion__c>PlanFactPrincipal = new map<Id, PlanFacturacion__c>([select id,Plan__r.Name,
                                                                                        CatalogoProductosFacturacion__r.ConnectionID__c,CatalogoProductosFacturacion__r.ConnectionTypeID__c,
                                                                                        CatalogoProductosFacturacion__r.Servicio__c,CatalogoProductosFacturacion__r.Name,Name, 
                                                                                        (select id, name, Campo__c, Obligatorio__c, LTE_ValorDefecto__c, Formato__c from Parametros_de_Facturacion__r)  
                                                                                        from PlanFacturacion__c where Plan__c =: lstPlanId]);
        
        Map<Id,List<Id>> tempMapPlan = new Map<Id,List<Id>>();
        for (Id i : PlanFactPrincipal.keySet()) {
            //Obtener rutas de los parámetros para plan principal de facturación(Cargo fijo)
            for (ParametroFacturacion__c j : PlanFactPrincipal.get(i).Parametros_de_Facturacion__r) {
                if( String.isNotBlank(j.Campo__c) ){
                    paramFields.add(j.Campo__c);
                }
            }
            
            //Relacionar SubPlanes al plan de Facturacion
            if(tempMapPlan.containskey(PlanFactPrincipal.get(i).Plan__c)){
                List<Id> temp = tempMapPlan.get(PlanFactPrincipal.get(i).Plan__c);
                if(temp!=null){
                    temp.Add(i);
                }
            }else{
                tempMapPlan.put(PlanFactPrincipal.get(i).Plan__c,new List<Id>{i});
            }
        }
        
        map<Id, SubPlanFacturacion__c>SubPlanesFact = new map<Id, SubPlanFacturacion__c>([select id,PlanFacturacion__r.Name, PlanFacturacion__c, PS_Tipo__c,
                                                                                          CatalogoProductosFacturacion__r.Name, Name, (select id, name, Campo__c, Obligatorio__c, Formato__c,
                                                                                                                                       LTE_ValorDefecto__c from Parametros_de_Facturacion__r) 
                                                                                          from SubPlanFacturacion__c where PlanFacturacion__c =: PlanFactPrincipal.keySet()]);
        
        
        Map<Id,List<Id>> tempMapPlanFact = new Map<Id,List<Id>>();
        for (Id k : SubPlanesFact.keySet()) {
            //Obtener rutas de los parámetros para subplanes de facturación
            for (ParametroFacturacion__c l : SubPlanesFact.get(k).Parametros_de_Facturacion__r) {
                if( String.isNotBlank(l.Campo__c) ){
                    paramFields.add(l.Campo__c);
                }
            }
            
            //Relacionar SubPlanes al plan de Facturacion
            if(tempMapPlanFact.containskey(SubPlanesFact.get(k).PlanFacturacion__c)){
                List<Id> temp = tempMapPlanFact.get(SubPlanesFact.get(k).PlanFacturacion__c);
                if(temp!=null){
                    temp.Add(k);
                }
            }else{
                tempMapPlanFact.put(SubPlanesFact.get(k).PlanFacturacion__c,new List<Id>{k});
            }
        }
        
        String sParamFields = String.join(new List<String>(paramFields), ',');
        //Obtener valores de los parametros por rutas encontradas        
        String selectParametersQuery = 'SELECT Id' + (String.isEmpty(sParamFields)?'':',' + sParamFields) + ' FROM OperacionComercial__c where Id =:lstOCId';
        list<OperacionComercial__c> OCParametersValues = Database.query(selectParametersQuery);
        Map<Id, OperacionComercial__c> mapOCParametersValues = new Map<Id, OperacionComercial__c>(OCParametersValues);
        
        Date dtFechaActual = Date.today();
        Map<String,Object> mapActualDate = new Map<String,Object>();
        mapActualDate.put('fulldate', String.valueOf(dtFechaActual));
        mapActualDate.put('day', String.valueOf(dtFechaActual.day()).leftpad(2,'0'));
        mapActualDate.put('month', String.valueOf(dtFechaActual.month()).leftpad(2,'0'));
        mapActualDate.put('year', String.valueOf(dtFechaActual.year()));
        
        map<Id, Linea__c> LinesList = new map<Id, Linea__c>([SELECT Id, Name,Codigo_de_linea__c, Estado_Aprovisionamiento__c,OperacionComercialTramite__c FROM Linea__c where OperacionComercialTramite__c =: lstOCId]);
        Map<Id,List<Id>> tempMapLines = new Map<Id,List<Id>>();
        for (Id k : LinesList.keySet()) {
            
            //Relacionar SubPlanes al plan de Facturacion
            if(tempMapLines.containskey(LinesList.get(k).OperacionComercialTramite__c)){
                List<Id> temp = tempMapLines.get(LinesList.get(k).OperacionComercialTramite__c);
                if(temp!=null){
                    temp.Add(k);
                }
            }else{
                tempMapLines.put(LinesList.get(k).OperacionComercialTramite__c,new List<Id>{k});
            }
        }
        
        Map<Id,Map<String,Object>> mapHierarchy = new Map<Id,Map<String,Object>>();
        
        for(OperacionComercial__c sglOC:lstOC){
            
            Map<String,Object> tmpMapHierarchy = new Map<String,Object>();
            
            for(String sglfield:setFields){
                if(sglfield.trim()=='FechadeActivacion__c'){
                    Date dtFecha = (Date)sglOC.get(sglfield.trim());
                    Map<String,Object> mapDate = new Map<String,Object>();
                    mapDate.put('fulldate', String.valueOf(dtFecha));
                    mapDate.put('day', String.valueOf(dtFecha.day()).leftpad(2,'0'));
                    mapDate.put('month', String.valueOf(dtFecha.month()).leftpad(2,'0'));
                    mapDate.put('year', String.valueOf(dtFecha.year()));
                    tmpMapHierarchy.put(sglfield.trim(),mapDate);
                    //End_Date
                    Date dt_EndFecha = dtFecha.addDays(1);
                    Map<String,Object> mapDateEnd = new Map<String,Object>();
                    mapDateEnd.put('fulldate', String.valueOf(dt_EndFecha));
                    mapDateEnd.put('day', String.valueOf(dt_EndFecha.day()).leftpad(2,'0'));
                    mapDateEnd.put('month', String.valueOf(dt_EndFecha.month()).leftpad(2,'0'));
                    mapDateEnd.put('year', String.valueOf(dt_EndFecha.year()));
                    tmpMapHierarchy.put('Post_'+sglfield.trim(),mapDateEnd);
                    
                    Date dtRevFecha = PS_UtilitaryMethodsClass_cls.getStartDate(dtFecha, CtasFacturacion.get(sglOC.CuentaFacturacion__c).Fin_de_consumo__c);
                    Map<String,Object> mapRevDate = new Map<String,Object>();
                    mapRevDate.put('fulldate', String.valueOf(dtRevFecha));
                    mapRevDate.put('day', String.valueOf(dtRevFecha.day()).leftpad(2,'0'));
                    mapRevDate.put('month', String.valueOf(dtRevFecha.month()).leftpad(2,'0'));
                    mapRevDate.put('year', String.valueOf(dtRevFecha.year()));
                    tmpMapHierarchy.put('Fact_'+sglfield.trim(),mapRevDate);
                    //End_Date
                    Date dt_EndRevFecha = dtRevFecha.addDays(1);
                    Map<String,Object> mapRevDateEnd = new Map<String,Object>();
                    mapRevDateEnd.put('fulldate', String.valueOf(dt_EndRevFecha));
                    mapRevDateEnd.put('day', String.valueOf(dt_EndRevFecha.day()).leftpad(2,'0'));
                    mapRevDateEnd.put('month', String.valueOf(dt_EndRevFecha.month()).leftpad(2,'0'));
                    mapRevDateEnd.put('year', String.valueOf(dt_EndRevFecha.year()));
                    tmpMapHierarchy.put('PostFact_'+sglfield.trim(),mapRevDateEnd);
                }else{
                    tmpMapHierarchy.put(sglfield.trim(), LibreriaUtilitaria_cls.recorreCampos(sglOC, sglfield.trim()));
                }
            }
            
            tmpMapHierarchy.put('Fecha_Actual',mapActualDate.Clone());
            
            List<Map<String,Object>> lstPlanFacturacion = new List<Map<String,Object>>();
            Map<String,Object> mapPlanFacturacion = new Map<String,Object>();
            List<Map<String,Object>> lstParametersPlan = new List<Map<String,Object>>();
            Map<String,Object> mapParametersPlan = new Map<String,Object>();
            String parameterValue;
            //Insertar feature plan de facturacion principal
            if(tempMapPlan.containskey(sglOC.Plan__c)){
                for (Id i : tempMapPlan.get(sglOC.Plan__c)) {
                    mapPlanFacturacion.clear();
                    mapPlanFacturacion.put('Action_Code','None');
                    mapPlanFacturacion.put('Name',PlanFactPrincipal.get(i).Name);
                    mapPlanFacturacion.put('CatalogoProductosFacturacion__r.Name',PlanFactPrincipal.get(i).CatalogoProductosFacturacion__r.Name);
                    mapPlanFacturacion.put('CatalogoProductosFacturacion__r.Servicio__c',PlanFactPrincipal.get(i).CatalogoProductosFacturacion__r.Servicio__c);
                    mapPlanFacturacion.put('CatalogoProductosFacturacion__r.ConnectionID__c',PlanFactPrincipal.get(i).CatalogoProductosFacturacion__r.ConnectionID__c);
                    mapPlanFacturacion.put('CatalogoProductosFacturacion__r.ConnectionTypeID__c',PlanFactPrincipal.get(i).CatalogoProductosFacturacion__r.ConnectionTypeID__c);
                    
                    //Insertar parámetros del planes de facturación principal (Cargo Fijo)
                    for (ParametroFacturacion__c j : PlanFactPrincipal.get(i).Parametros_de_Facturacion__r) {
                        mapParametersPlan.clear();
                        mapParametersPlan.put('Action_Code','Add');
                        mapParametersPlan.put('name',j.name);
                        
                        //Si el parametro contiene ruta para obtener el valor
                        if( String.isNotBlank(j.Campo__c) ){
                            parameterValue = LibreriaUtilitaria_cls.recorreCampos(OCParametersValues[0],j.Campo__c);
                            if(String.isEmpty(parameterValue)){
                                parameterValue=String.isEmpty(j.LTE_ValorDefecto__c)?'':j.LTE_ValorDefecto__c;
                            }
                        }else{
                            parameterValue=String.isEmpty(j.LTE_ValorDefecto__c)?'':j.LTE_ValorDefecto__c;
                        }
                        mapParametersPlan.put('value',functionParameter(parameterValue,String.isEmpty(j.Formato__c)?'':j.Formato__c));
                        lstParametersPlan.add(mapParametersPlan.clone());
                    }
                    mapPlanFacturacion.put('Parameters',lstParametersPlan);
                    
                    if(tempMapPlanFact.containskey(i)){
                        List<Map<String,Object>> lstSubPlanFacturacion = new List<Map<String,Object>>();
                        Map<String,Object> mapSubPlanFacturacion = new Map<String,Object>();
                        Map<String,Object> mapParametersSubPlan = new Map<String,Object>();
                        for(Id k:tempMapPlanFact.get(i)){
                            mapSubPlanFacturacion.clear();
                            mapSubPlanFacturacion.put('Action_Code','Add');
                            mapSubPlanFacturacion.put('Name',SubPlanesFact.get(k).Name);
                            mapSubPlanFacturacion.put('PS_Tipo__c',SubPlanesFact.get(k).PS_Tipo__c);
                            mapSubPlanFacturacion.put('CatalogoProductosFacturacion__r.Name',SubPlanesFact.get(k).CatalogoProductosFacturacion__r.Name);
                            
                            //Insertar parámetros de subplanes de facturación
                            List<Map<String,Object>> lstParametersSubPlan = new List<Map<String,Object>>();
                            for (ParametroFacturacion__c l : SubPlanesFact.get(k).Parametros_de_Facturacion__r) {
                                mapParametersSubPlan.clear();
                                mapParametersSubPlan.put('Action_Code','Add');
                                mapParametersSubPlan.put('name',l.name);
                                
                                //Si el parametro contiene ruta para obtener el valor
                                if( String.isNotBlank(l.Campo__c) ){
                                    parameterValue = LibreriaUtilitaria_cls.recorreCampos(OCParametersValues[0],l.Campo__c);
                                    if(String.isEmpty(parameterValue)){
                                        parameterValue=String.isEmpty(l.LTE_ValorDefecto__c)?'':l.LTE_ValorDefecto__c;
                                    }
                                }else{
                                    parameterValue=String.isEmpty(l.LTE_ValorDefecto__c)?'':l.LTE_ValorDefecto__c;
                                }
                                mapParametersSubPlan.put('value',functionParameter(parameterValue,String.isEmpty(l.Formato__c)?'':l.Formato__c));
                                lstParametersSubPlan.add(mapParametersSubPlan.Clone());
                            }
                            mapSubPlanFacturacion.put('Parameters',lstParametersSubPlan);
                            lstSubPlanFacturacion.add(mapSubPlanFacturacion.Clone());
                        }
                        mapPlanFacturacion.put('SubPlanFacturacion',lstSubPlanFacturacion);
                        lstPlanFacturacion.Add(mapPlanFacturacion.Clone());
                    }
                }
            }
            tmpMapHierarchy.put('PlanFacturacion',lstPlanFacturacion);
            
            Map<String,Object> mapLineas = new Map<String,Object>();
            List<Map<String,Object>> lstLineas = new List<Map<String,Object>>();
            if(tempMapLines.containskey(sglOC.Id)){
                for (Id i : tempMapLines.get(sglOC.Id)) {
                    mapLineas.clear();
                    mapLineas.put('Name',LinesList.get(i).Name);
                    mapLineas.put('Estado_Aprovisionamiento__c',LinesList.get(i).Estado_Aprovisionamiento__c);
                    lstLineas.add(mapLineas.clone());
                }
            }
            tmpMapHierarchy.put('Lineas', lstLineas);
            
            Map<String,Object> mapCtaFacturacion = new Map<String,Object>();
            if(CtasFacturacion.containskey(sglOC.CuentaFacturacion__c)){
                mapCtaFacturacion.put('Name',CtasFacturacion.get(sglOC.CuentaFacturacion__c).Name);
                mapCtaFacturacion.put('LTE_NombreCuentaFacturacion__c',CtasFacturacion.get(sglOC.CuentaFacturacion__c).LTE_NombreCuentaFacturacion__c);
                mapCtaFacturacion.put('TipoFactura__c',CtasFacturacion.get(sglOC.CuentaFacturacion__c).TipoFactura__c);
                mapCtaFacturacion.put('MedioFacturacion__c',CtasFacturacion.get(sglOC.CuentaFacturacion__c).MedioFacturacion__c);
                mapCtaFacturacion.put('LTE_MetodoEnvio__c',CtasFacturacion.get(sglOC.CuentaFacturacion__c).LTE_MetodoEnvio__c);
                mapCtaFacturacion.put('LTE_Email__c',CtasFacturacion.get(sglOC.CuentaFacturacion__c).LTE_Email__c);
                mapCtaFacturacion.put('Fin_de_consumo__c',CtasFacturacion.get(sglOC.CuentaFacturacion__c).Fin_de_consumo__c);
                mapCtaFacturacion.put('DirCorresp__c',CtasFacturacion.get(sglOC.CuentaFacturacion__c).DirCorresp__c);
                mapCtaFacturacion.put('Ciudad__r.CodigoDane__c',CtasFacturacion.get(sglOC.CuentaFacturacion__c).Ciudad__r.CodigoDane__c);
                mapCtaFacturacion.put('Ciudad__r.Padre__r.CodigoDane__c',CtasFacturacion.get(sglOC.CuentaFacturacion__c).Ciudad__r.Padre__r.CodigoDane__c.remove('000'));
                mapCtaFacturacion.put('Ciudad__r.Name',CtasFacturacion.get(sglOC.CuentaFacturacion__c).Ciudad__r.Name);
                tmpMapHierarchy.put('CuentaFacturacion', mapCtaFacturacion);
            }
            mapHierarchy.put(sglOC.Id,tmpMapHierarchy.clone());
        }
        
        return mapHierarchy;
    }
    
    public Map<Id,Map<String,Object>> LoadMapLinea(Set<Id> lstLineasOCId){
        Set<String> paramFields = new Set<String>();
        Mensaje_Integracion__c lstMensajes = [SELECT Id,Mensaje__c FROM Mensaje_Integracion__c WHERE Name ='Campos Facturacion Lineas PS'];
        String sFields = lstMensajes.Mensaje__c;
        Set<String> setFields = new Set<String>();
        setFields.addAll(sFields.split(','));
        
        String sql = 'SELECT '+sFields+' FROM Lineas_OC__c WHERE Id IN :lstLineasOCId';
        List<Lineas_OC__c> lstLineasOC = Database.query(sql);
        
        Set<Id> lstPlanId = new Set<Id>();
        Set<Id> lstCtaFacturacion = new Set<Id>();
        for(Lineas_OC__c sglLineasOC:lstLineasOC){
            lstPlanId.add(sglLineasOC.Operacion_Comercial__r.Plan__c);
            lstCtaFacturacion.add(sglLineasOC.Operacion_Comercial__r.CuentaFacturacion__c);
        }
        
        Date dtFechaActual = Date.today();
        Map<String,Object> mapActualDate = new Map<String,Object>();
        mapActualDate.put('fulldate', String.valueOf(dtFechaActual));
        mapActualDate.put('day', String.valueOf(dtFechaActual.day()).leftpad(2,'0'));
        mapActualDate.put('month', String.valueOf(dtFechaActual.month()).leftpad(2,'0'));
        mapActualDate.put('year', String.valueOf(dtFechaActual.year()));
        
        map<Id, CuentaFacturacion__c> CtasFacturacion = new map<Id, CuentaFacturacion__c>([select id,Name,LTE_NombreCuentaFacturacion__c,TipoFactura__c,MedioFacturacion__c,LTE_MetodoEnvio__c,
                                                                                           LTE_Email__c,Fin_de_consumo__c,DirCorresp__c,Ciudad__r.CodigoDane__c,
                                                                                           Ciudad__r.Padre__r.CodigoDane__c,Ciudad__r.Name
                                                                                           from CuentaFacturacion__c where Id =: lstCtaFacturacion]);
        
        map<Id, PlanFacturacion__c>PlanFactPrincipal = new map<Id, PlanFacturacion__c>([select id,Plan__r.Name,
                                                                                        CatalogoProductosFacturacion__r.ConnectionID__c,CatalogoProductosFacturacion__r.ConnectionTypeID__c,
                                                                                        CatalogoProductosFacturacion__r.Servicio__c,CatalogoProductosFacturacion__r.Name,Name, 
                                                                                        (select id, name, Campo__c, Obligatorio__c, LTE_ValorDefecto__c, Formato__c from Parametros_de_Facturacion__r)  
                                                                                        from PlanFacturacion__c where Plan__c =: lstPlanId]);
        
        Map<Id,List<Id>> tempMapPlan = new Map<Id,List<Id>>();
        for (Id i : PlanFactPrincipal.keySet()) {
            //Obtener rutas de los parámetros para plan principal de facturación(Cargo fijo)
            for (ParametroFacturacion__c j : PlanFactPrincipal.get(i).Parametros_de_Facturacion__r) {
                if( String.isNotBlank(j.Campo__c) ){
                    if(!paramFields.contains('Operacion_Comercial__r.'+j.Campo__c))
                        paramFields.add('Operacion_Comercial__r.'+j.Campo__c);
                }
            }
            
            //Relacionar SubPlanes al plan de Facturacion
            if(tempMapPlan.containskey(PlanFactPrincipal.get(i).Plan__c)){
                List<Id> temp = tempMapPlan.get(PlanFactPrincipal.get(i).Plan__c);
                if(temp!=null){
                    temp.Add(i);
                }
            }else{
                tempMapPlan.put(PlanFactPrincipal.get(i).Plan__c,new List<Id>{i});
            }
        }
        
        String sParamFields = String.join(new List<String>(paramFields), ',');
        
        String selectParametersQuery = 'SELECT Id'+(String.isEmpty(sParamFields)?'':',' + sParamFields)+' FROM Lineas_OC__c WHERE Id IN :lstLineasOCId';
        list<Lineas_OC__c> OCParametersValues = Database.query(selectParametersQuery);
        Map<Id, Lineas_OC__c> mapOCParametersValues = new Map<Id, Lineas_OC__c>(OCParametersValues);
        
        Map<Id,Map<String,Object>> mapHierarchy = new Map<Id,Map<String,Object>>();
        
        for(Lineas_OC__c sglLineasOC:lstLineasOC){
            Map<String,Object> tmpMapHierarchy = new Map<String,Object>();
            
            for(String sglfield:setFields){
                if(sglfield.trim()=='FechadeActivacion__c'){
                    Date dtFecha = (Date)sglLineasOC.get(sglfield.trim());
                    Map<String,Object> mapDate = new Map<String,Object>();
                    mapDate.put('fulldate', String.valueOf(dtFecha));
                    mapDate.put('day', String.valueOf(dtFecha.day()).leftpad(2,'0'));
                    mapDate.put('month', String.valueOf(dtFecha.month()).leftpad(2,'0'));
                    mapDate.put('year', String.valueOf(dtFecha.year()));
                    tmpMapHierarchy.put(sglfield.trim(),mapDate);
                    //End_Date
                    Date dt_EndFecha = dtFecha.addDays(1);
                    Map<String,Object> mapDateEnd = new Map<String,Object>();
                    mapDateEnd.put('fulldate', String.valueOf(dt_EndFecha));
                    mapDateEnd.put('day', String.valueOf(dt_EndFecha.day()).leftpad(2,'0'));
                    mapDateEnd.put('month', String.valueOf(dt_EndFecha.month()).leftpad(2,'0'));
                    mapDateEnd.put('year', String.valueOf(dt_EndFecha.year()));
                    tmpMapHierarchy.put('Post_'+sglfield.trim(),mapDateEnd);
                    
                    Date dtRevFecha = PS_UtilitaryMethodsClass_cls.getStartDate(dtFecha, CtasFacturacion.get(sglLineasOC.Operacion_Comercial__r.CuentaFacturacion__c).Fin_de_consumo__c);
                    Map<String,Object> mapRevDate = new Map<String,Object>();
                    mapRevDate.put('fulldate', String.valueOf(dtRevFecha));
                    mapRevDate.put('day', String.valueOf(dtRevFecha.day()).leftpad(2,'0'));
                    mapRevDate.put('month', String.valueOf(dtRevFecha.month()).leftpad(2,'0'));
                    mapRevDate.put('year', String.valueOf(dtRevFecha.year()));
                    tmpMapHierarchy.put('Fact_'+sglfield.trim(),mapRevDate);
                    //End_Date
                    Date dt_EndRevFecha = dtRevFecha.addDays(1);
                    Map<String,Object> mapRevDateEnd = new Map<String,Object>();
                    mapRevDateEnd.put('fulldate', String.valueOf(dt_EndRevFecha));
                    mapRevDateEnd.put('day', String.valueOf(dt_EndRevFecha.day()).leftpad(2,'0'));
                    mapRevDateEnd.put('month', String.valueOf(dt_EndRevFecha.month()).leftpad(2,'0'));
                    mapRevDateEnd.put('year', String.valueOf(dt_EndRevFecha.year()));
                    tmpMapHierarchy.put('PostFact_'+sglfield.trim(),mapRevDateEnd);
                }else{
                    tmpMapHierarchy.put(sglfield.trim(), LibreriaUtilitaria_cls.recorreCampos(sglLineasOC, sglfield.trim()));
                }
            }
            
            tmpMapHierarchy.put('Fecha_Actual',mapActualDate.Clone());
            
            List<Map<String,Object>> lstPlanFacturacion = new List<Map<String,Object>>();
            Map<String,Object> mapPlanFacturacion = new Map<String,Object>();
            List<Map<String,Object>> lstParametersPlan = new List<Map<String,Object>>();
            Map<String,Object> mapParametersPlan = new Map<String,Object>();
            String parameterValue;
            //Insertar feature plan de facturacion principal
            if(tempMapPlan.containskey(sglLineasOC.Operacion_Comercial__r.Plan__c)){
                for (Id i : tempMapPlan.get(sglLineasOC.Operacion_Comercial__r.Plan__c)) {
                    mapPlanFacturacion.clear();
                    mapPlanFacturacion.put('Action_Code','None');
                    mapPlanFacturacion.put('Name',PlanFactPrincipal.get(i).Name);
                    mapPlanFacturacion.put('CatalogoProductosFacturacion__r.Name',PlanFactPrincipal.get(i).CatalogoProductosFacturacion__r.Name);
                    mapPlanFacturacion.put('CatalogoProductosFacturacion__r.Servicio__c',PlanFactPrincipal.get(i).CatalogoProductosFacturacion__r.Servicio__c);
                    mapPlanFacturacion.put('CatalogoProductosFacturacion__r.ConnectionID__c',PlanFactPrincipal.get(i).CatalogoProductosFacturacion__r.ConnectionID__c);
                    mapPlanFacturacion.put('CatalogoProductosFacturacion__r.ConnectionTypeID__c',PlanFactPrincipal.get(i).CatalogoProductosFacturacion__r.ConnectionTypeID__c);
                    
                    //Insertar parámetros del planes de facturación principal (Cargo Fijo)
                    for (ParametroFacturacion__c j : PlanFactPrincipal.get(i).Parametros_de_Facturacion__r) {
                        mapParametersPlan.clear();
                        mapParametersPlan.put('Action_Code','Add');
                        mapParametersPlan.put('name',j.name);
                        
                        //Si el parametro contiene ruta para obtener el valor
                        if( String.isNotBlank(j.Campo__c) ){
                            parameterValue = LibreriaUtilitaria_cls.recorreCampos(OCParametersValues[0],'Operacion_Comercial__r.'+j.Campo__c);
                            if(String.isEmpty(parameterValue)){
                                parameterValue=String.isEmpty(j.LTE_ValorDefecto__c)?'':j.LTE_ValorDefecto__c;
                            }
                        }else{
                            parameterValue=String.isEmpty(j.LTE_ValorDefecto__c)?'':j.LTE_ValorDefecto__c;
                        }
                        mapParametersPlan.put('value',functionParameter(parameterValue,String.isEmpty(j.Formato__c)?'':j.Formato__c));
                        lstParametersPlan.add(mapParametersPlan.clone());
                    }
                    mapPlanFacturacion.put('Parameters',lstParametersPlan);
                    lstPlanFacturacion.Add(mapPlanFacturacion.Clone());
                }
            }
            tmpMapHierarchy.put('PlanFacturacion',lstPlanFacturacion);
            system.debug(lstPlanFacturacion);
            mapHierarchy.put(sglLineasOC.Id,tmpMapHierarchy.clone());
        }
        return mapHierarchy;
    }
    
    public Map<Id,String> TOPPDispatcher(Map<Id,Map<String,Object>> MapHierarchy){
        
        List<OperacionComercial__c> lstOC = [SELECT Id,Name,TOPP__r.TipodeOperacionporplan__c,Detalle_del_tramite__c, (SELECT Id,Name FROM Lineas_OC__r WHERE Estado__c != 'Declinada' AND Estado__c != 'Facturada') FROM OperacionComercial__c WHERE Id IN :MapHierarchy.keyset() AND FechaFacturacion__c = null];
        
        Map<Id,String> mpResultado = new Map<Id,String>();
        Set<String> setTOPPOC = new Set<String>();
        for(OperacionComercial__c sglOC:lstOC){
            setTOPPOC.add('PS_Facturacion_'+LibreriaUtilitaria_cls.quitarCaracteresEsp(sglOC.TOPP__r.TipodeOperacionporplan__c).replaceAll('\\ ', '_'));
            if(String.isNotEmpty(sglOC.Detalle_del_tramite__c)){
                setTOPPOC.add('PS_Facturacion_'+LibreriaUtilitaria_cls.quitarCaracteresEsp(sglOC.TOPP__r.TipodeOperacionporplan__c).replaceAll('\\ ', '_')+'_'+LibreriaUtilitaria_cls.quitarCaracteresEsp(sglOC.Detalle_del_tramite__c).replaceAll('\\ ', '_'));
            }
        }
        Map<String,String> mapMensajesIntegracion = new Map<String,String>();
        List<Mensaje_Integracion__c> lstMensajes = [SELECT Id,Name,Mensaje__c FROM Mensaje_Integracion__c WHERE Name =:setTOPPOC];
        for(Mensaje_Integracion__c sglMensaje:lstMensajes){
            mapMensajesIntegracion.put(sglMensaje.Name.toUppercase(), sglMensaje.Mensaje__c);
        }
        
        List<LogTransacciones__c> lstLog = new List<LogTransacciones__c>();
        List<OperacionComercial__c> lstOCUpdate = new List<OperacionComercial__c>();
        for(OperacionComercial__c sglOC:lstOC){
            try{
                string c ='PS_Tramites_cls.'+LibreriaUtilitaria_cls.quitarCaracteresEsp(sglOC.TOPP__r.TipodeOperacionporplan__c);
                c = c.replaceAll('\\ ', '_');
                system.debug(c);
                Type t = Type.forName(c);
                if(t!=null){
                    PS_Tramites_cls.Step paso =(PS_Tramites_cls.Step) t.newInstance();
                    paso.OC=sglOC;
                    paso.mapHierarchy = MapHierarchy.get(sglOC.Id);
                    system.debug('sglOC.Id-'+sglOC.Id);
                    paso.EnvioFacturacion(mapMensajesIntegracion);
                    //lstLog.add(paso.logServicio);
                    lstOCUpdate.add(paso.OC);
                }else{
                    PS_Tramites_cls.Step paso =new PS_Tramites_cls.Step();
                    paso.OC=sglOC;
                    paso.mapHierarchy = MapHierarchy.get(sglOC.Id);
                    system.debug(sglOC.Id);
                    paso.EnvioFacturacion(mapMensajesIntegracion);
                    //lstLog.add(paso.logServicio);
                    lstOCUpdate.add(paso.OC);
                }
            }catch(Exception e){
                //Insertar log de envió de facturación erróneo
                String Error_Description = 'Message: ' +  e.getMessage() + ', StackTraceString: ' +  e.getStackTraceString() + ', TypeName:' + e.getTypeName();
                system.debug('Error_Description:--->'+ Error_Description);
                LogTransacciones__c logServicio = new LogTransacciones__c();
                logServicio.AC_CorrelationID_Random__c = sglOC.Id;
                logServicio.LTE_Operacion_Comercial__c = sglOC.Id;
                logServicio.Error_Apex__c = Error_Description;
                logServicio.Name = 'No Exitoso Facturación';
                lstLog.add(logServicio);
            }
        }
        if(!lstOCUpdate.isEmpty()){
            update lstOCUpdate;
        }
        if(!lstLog.isEmpty()){
            insert lstLog;
        }
        return mpResultado;
    }
    
    public Map<Id,String> IntegracionLinea(Map<Id,Map<String,Object>> MapHierarchy){
        List<Lineas_OC__c> lstLineasOC = [SELECT Id,Name FROM Lineas_OC__c WHERE Id IN :MapHierarchy.keyset() AND (Estado__c = 'Activa' OR Estado__c = 'No Exitoso Facturacion') AND Operacion_Comercial__r.FechaFacturacion__c != null];
        system.debug(lstLineasOC);
        Map<Id,String> mpResultado = new Map<Id,String>();
        List<LogTransacciones__c> lstLog = new List<LogTransacciones__c>();
        List<Lineas_OC__c> lstLineasOCUpdate = new List<Lineas_OC__c>();
        
        Map<String,String> mapMensajesIntegracion = new Map<String,String>();
        List<Mensaje_Integracion__c> lstMensajes = [SELECT Id,Name,Mensaje__c FROM Mensaje_Integracion__c WHERE Name ='PS_Facturacion_Lineas'];
        for(Mensaje_Integracion__c sglMensaje:lstMensajes){
            mapMensajesIntegracion.put(sglMensaje.Name, sglMensaje.Mensaje__c);
        }
        
        for(Lineas_OC__c sglLineaOC:lstLineasOC){
            PS_Tramites_cls.FacturacionLineas paso = new PS_Tramites_cls.FacturacionLineas();
            paso.init();
            paso.LineaOC = sglLineaOC;
            paso.mapHierarchy = MapHierarchy.get(sglLineaOC.Id);
            String sResultado = paso.EnvioFacturacion(mapMensajesIntegracion);
            lstLog.add(paso.logServicio);
            lstLineasOCUpdate.add(paso.LineaOC);
            mpResultado.put(sglLineaOC.Id,sResultado);
        }
            
        if(!lstLineasOCUpdate.isEmpty()){
            update lstLineasOCUpdate;
        }
        if(!lstLog.isEmpty()){
            insert lstLog;
        }
        return mpResultado;
    }
    
    public String functionParameter(String Value, String strfuncion){
        strfuncion = String.isEmpty(strfuncion)?'':strfuncion.trim();
        Value = String.isEmpty(Value)?'':Value.trim();
        if(strfuncion.contains('NUMBERPAD(')){
            List<String> arrValue = Value.split('\\.');
            String decValue = arrValue.size()==2?arrValue[1]:'';
            String intValue = arrValue.size()<=2 && arrValue.size()>=1?arrValue[0]:'';
            
            Pattern p = Pattern.compile('NUMBERPAD\\(([#\\.]+)\\)');
            Matcher pm = p.matcher( strfuncion );
            if( pm.find() ){
                String sExpr = pm.group(1);
                List<String> arrExpr = sExpr.split('\\.');
                if(arrExpr.size()==2){
                    return intValue.leftPad(arrExpr[0].length(),'0')+'.'+decValue.rightpad(arrExpr[1].length(),'0');
                }else{
                    return intValue.rightpad(arrExpr[0].length(),'0');
                }
            }
        }
        return Value;
    }
}