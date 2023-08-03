/*******************************************************************************
Desarrollado por:       ETB
Autor:                  Fernando Sarasty
Proyecto:               ETB - Gestor portafolio superior.
Descripción:            Valida si los campos dinámicos del TOPP definidos en la integración entre SalesForce y Gestor, pueden ser
						actualizados en la OC.

Cambios (Versiones)
-------------------------------------
No.       Fecha                 Autor                 Descripción
------  ----------      --------------------        ---------------
1.0     10-07-2018      Fernando Sarasty (FS)       Creación de la clase
*******************************************************************************/

public class PS_Valida_Actualizacion_OC_cls {
    

    public String obtenerPerfilUsuario(){
        
        id idProfile = userinfo.getProfileId();
        system.debug('id1 : ' + idProfile );
        List<Profile> Profile = [Select Name from Profile where Id =: idProfile];
        String profileName = Profile[0].Name;
        system.debug('profileName : ' + profileName );
        return profileName;
    }
            
    public void validaActualizacionOC(OperacionComercial__c newOC, OperacionComercial__c oldOC, String tipoIntegracion, String objetoBase){
        //List<ParametroIntegracion__c> lstParametrosIntegracion = new List<ParametroIntegracion__c>();
        //List<Viabilidad__c> lstVia = [select id from Viabilidad__c where OperacionComercial__c= :oldOC.Id and EstadoViabilidad__c = 'Cerrada' and Respuestadeviabilidad__c = 'Viable'];
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(objetoBase);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap(); 
        //String perfil = obtenerPerfilUsuario();
        
        if(newOC.OC_Principal_Empaquetamiento__c != null){            
            if(oldOC.get('ValorTarifaPlan__c') != newOC.get('ValorTarifaPlan__c'))
                newOC.addError(Label.CampoSoloLecturaNIP.replace('%campo%',fieldMap.get('ValorTarifaPlan__c').getDescribe().getLabel()));                    
            
            if(oldOC.get('Valorunicavez__c') != newOC.get('Valorunicavez__c'))
                newOC.addError(Label.CampoSoloLecturaNIP.replace('%campo%',fieldMap.get('Valorunicavez__c').getDescribe().getLabel()));                                 
        }
            
  		/**
        if(lstVia!=null && lstVia.size()>0){
        	lstParametrosIntegracion = [Select Name, Objeto_base__c, Campo__c, Objeto_destino__c, Campo_destino__c, Valor_por_defecto__c, Region_de_la_etiqueta__c
            	From ParametroIntegracion__c
                Where Tipo_Operacion_por_Plan__c=:oldOC.TOPP__c and Activo__c = true
                and TipoIntegracion__c=: tipoIntegracion and Objeto_base__c=:objetoBase
                Order By Name ASC];
                
            if(!lstParametrosIntegracion.isEmpty()){
            	for(ParametroIntegracion__c objParamInteg: lstParametrosIntegracion){                
                	if(oldOC.get(objParamInteg.Campo__c) != newOC.get(objParamInteg.Campo__c))
                    	newOC.addError(Label.CampoSoloLectura.replace('%campo%',fieldMap.get(objParamInteg.Campo__c).getDescribe().getLabel()));                    
                    }          
                }
            if(oldOC.get('SucursalOrigen__c') != newOC.get('SucursalOrigen__c'))
            	newOC.addError(Label.CampoSoloLectura.replace('%campo%',fieldMap.get('SucursalOrigen__c').getDescribe().getLabel()));
            if(oldOC.get('Duracion_Dias__c') != newOC.get('Duracion_Dias__c'))
            	newOC.addError(Label.CampoSoloLectura.replace('%campo%',fieldMap.get('Duracion_Dias__c').getDescribe().getLabel()));
            if(oldOC.get('Duracion_Meses__c') != newOC.get('Duracion_Meses__c'))
            	newOC.addError(Label.CampoSoloLectura.replace('%campo%',fieldMap.get('Duracion_Meses__c').getDescribe().getLabel()));
                
        }**/
    }
    public void ActualizaOCRelacionadas(OperacionComercial__c newOC, OperacionComercial__c oldOC){
        Boolean updateFlg;
        set<String> fieldSet = new Set<String>();
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('OperacionComercial__c');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        List<OperacionComercial__c> lstOCEmpaquetadas = new List<OperacionComercial__c>();
        lstOCEmpaquetadas = [Select Id, Name From OperacionComercial__c
                             Where OC_Principal_Empaquetamiento__c=:oldOC.Id];        
        if(!lstOCEmpaquetadas.isEmpty()){
            for(OperacionComercial__c objOC: lstOCEmpaquetadas){
                updateFlg = false;
                for(String strfieldName: fieldMap.keySet()){
                    try{
                        if(oldOC.get(strfieldName) != newOC.get(strfieldName)){
                            if((strfieldName == 'Estado__c' && newOC.get(strfieldName) == 'Activa') || strfieldName == 'lastmodifieddate' || strfieldName == 'systemmodstamp' || strfieldName == 'IDServicio__c' || strfieldName == 'nombre_cuenta__c' || strfieldName == 'destinatario_notificacion_cambio_estados__c' || 
                                strfieldName == 'fecha_final_estado__c' || strfieldName == 'ValorTarifaPlan__c' || strfieldName == 'Valorunicavez__c'){
                            	updateFlg = false;
                            }                            
                            else{                                
                                objOC.put(strfieldName, newOC.get(strfieldName));  
                            	updateFlg = true;       
                                
                            }
                        }
                    }catch(Exception e){}
            	}
                try{
                	if(updateFlg == true)                        
                		update objOC;
                }catch(Exception e){}
            }          
        }     
    }
}