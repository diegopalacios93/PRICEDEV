/*******************************************************************************
Desarrollado por:		Avanxo Colombia
Autor:					Hector Bayona
Proyecto:				ETB - Servicios Saaw
Descripción:			Servicios Saaw
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0		15-04-2015	Hector Bayona (HB)		Creación de la clase
*******************************************************************************/

global with sharing class ServiciosSAAW {


	global class caso{
		webservice Date fechaReclamo;
		webservice String estadoDelReclamo;
		webservice String cuentaContrato;
		webservice String nombreDelCliente;
		webservice String identificacionCliente;
		webservice String segmentoDelCliente;
		webservice decimal valorDelReclamado;
		webservice String nombreDelReclamante;
        webservice String numeroCun;
        webservice String error;
	}
    
	global class infoAjuste{
        webservice decimal valorAjustado;
        webservice string noDelAjuste;
        webservice date fechaDelAjuste;
        webservice string numeroCaso;

	}

	static webservice caso consulta_saaw (string numeroCaso){

		caso servCasos=new caso();
        
        List<case> elCaso=new List<case>([select id,Valorreclamadoporelcliente__c,Contact.Name,CodigouniconumericoCUN__c,Account.Name,Account.Segmento__c,Account.AccountNumber,Fechaderadicacion__c,Cuenta_de_Facturacion__r.Name,Status,RecordType.Name from case where CaseNumber=:numeroCaso]);
        
        if(elCaso.isEmpty()){
            servCasos.error='No existe el No. En Salesforce';
            ServiciosSAAW.generarLog(NUll,numeroCaso,servCasos.error,'Realizado','Consulta Saaw');
            return servCasos;
        }
        if(elCaso[0].RecordType.Name!='CASO PQR'){
            servCasos.error='El tipo de caso no es de PQR';
            ServiciosSAAW.generarLog(elCaso[0].Id,numeroCaso,servCasos.error,'Realizado','Consulta Saaw');
            return servCasos;
        }

        if(elCaso[0].Status=='Cerrado'){
            servCasos.error='No se puede generar un ajuste sobre un caso cerrado';
            ServiciosSAAW.generarLog(elCaso[0].Id,numeroCaso,servCasos.error,'Realizado','Consulta Saaw');
            return servCasos;
        }
        
        string response='';
        
        
        try{
        	LibreriaUtilitaria_cls.GenerarExcepcionTest();
            servCasos.fechaReclamo=elCaso[0].Fechaderadicacion__c;
            servCasos.estadoDelReclamo=elCaso[0].Status;
            servCasos.cuentaContrato=elCaso[0].Cuenta_de_Facturacion__r.Name;
            servCasos.nombreDelCliente=elCaso[0].Account.Name;
            servCasos.identificacionCliente=elCaso[0].Account.AccountNumber;
            servCasos.segmentoDelCliente=elCaso[0].Account.Segmento__c;
            servCasos.nombreDelReclamante=elCaso[0].Contact.Name;
            servCasos.numeroCun=(elCaso[0].CodigouniconumericoCUN__c==null?'':elCaso[0].CodigouniconumericoCUN__c);
            servCasos.valorDelReclamado=elCaso[0].Valorreclamadoporelcliente__c;
        }catch(exception e){
            servCasos.error=e.getMessage();
                     
        }
        
        ServiciosSAAW.generarLog(elCaso[0].Id,numeroCaso,string.valueOf(servCasos),'Realizado','Consulta Saaw');        
        
        
		return servCasos;
	}
    
    static webservice string ajuste_saaw(infoAjuste ajuste){
        
        string respuesta='';      
        string strAjuste=''; 
        List<case> elCaso=new List<case>([select id,RecordType.Name,Ajuste__c from case where CaseNumber=:ajuste.numeroCaso]);

        string response='';
        
        if(elCaso.isEmpty()){
        	ServiciosSAAW.generarLog(Null,String.valueOf(ajuste),respuesta,'Realizado','Ajuste Saaw');
            return 'El caso no existe';
        }

        if(elCaso[0].RecordType.Name!='CASO PQR'){
            respuesta='El tipo de caso no es de PQR';
            ServiciosSAAW.generarLog(elCaso[0].Id,String.valueOf(ajuste),respuesta,'Realizado','Ajuste Saaw');
            return respuesta;
        }
        
        if(elCaso[0].Ajuste__c==null){
            elCaso[0].Ajuste__c=ajuste.valorAjustado;
        }else{
            elCaso[0].Ajuste__c=ajuste.valorAjustado+elCaso[0].Ajuste__c;
        }

        
        elCaso[0].No_del_ajuste__c=ajuste.noDelAjuste;
        elCaso[0].Fecha_del_ajuste__c=ajuste.fechaDelAjuste;
        
        try{
            update elCaso;
            LibreriaUtilitaria_cls.GenerarExcepcionTest();
            response='Exitoso';
        }catch(exception e){
            response=e.getMessage();
            ServiciosSAAW.generarLog(elCaso[0].Id,String.valueOf(ajuste),response,'Realizado','Ajuste Saaw');
            return e.getMessage();            
        }

        ServiciosSAAW.generarLog(elCaso[0].Id,String.valueOf(ajuste),response,'Realizado','Ajuste Saaw');


        

        
        return 'Exitoso';
    }

    static void generarLog(id idc,string request,string response, string estado, string nombre){
        
        LogTransacciones__c lt =new LogTransacciones__c(Caso__c=idc,Informacion_Enviada__c=request,Informacion_Recibida__c=response,Estado__c=estado,Name=nombre);
        
        insert lt;
    
    
    }

}