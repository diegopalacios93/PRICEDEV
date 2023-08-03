/*******************************************************************************
Desarrollado por:		Avanxo Colombia
Autor:					Hector Bayona
Proyecto:				ETB - Integraciones Clientes CUN
Descripción:			Clase de prueba para el controlador ConsultaCun_ctr
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0		12-03-2014	Hector Bayona (HB)		Creación de la clase
*******************************************************************************/

@isTest
private class ConsultaCun_tst {

    static testMethod void ConsultaCun() {
    	
    	List<sObject> ls = Test.loadData(CUN_Center_Abajo__c.sObjectType, 'ConfCUN');
    	List<sObject> ls2 = Test.loadData(ServiciosWeb__c.sObjectType, 'ServiciosWeb');
    	    	
    	GeneraData_cls.generarData();
    	
    	Legalizacion__c Legalizacion=GeneraData_cls.generarLegalizacion2();
    	
		Legalizacion__c Legalizacion2=GeneraData_cls.generarLegalizacion2();
    	Legalizacion2.CodigouniconumericoCUN__c='0123456789012345';
    	
    	Legalizacion__c Legalizacion3=GeneraData_cls.generarLegalizacion2();
    	Legalizacion3.CodigouniconumericoCUN__c='0123456789012345';
    	Legalizacion3.Estado__c='Gestionado';
    	
    	insert new list<Legalizacion__c>{Legalizacion,Legalizacion2,Legalizacion3};
    	
    	PageReference pageRef0 = Page.ConsultaCun_pag;
    	Test.setCurrentPage(pageRef0);
        ApexPages.currentPage().getParameters().put('id', Legalizacion.id);
        
        ConsultaCun_ctr Cun = new ConsultaCun_ctr();
        Cun.ObtenerConf();
        Cun.tipo='manual';
        Cun.ConsultarCun();
        Cun.cunManual='1234567890123456';
        Cun.ConsultarManual();
        
        //Guarda cola nuevo
        Cun.cunFallido(true);
        //Guarda cola rastro cun
        Cun.cunFallido(false);
        
        Test.setMock(HttpCalloutMock.class, new MockServiciosWeb.MockHttpResponseCun());
        test.startTest();
		
		//Heredado rastro cun
        Cun.ws.add(new ConsultaCun_ctr.wrapperSelect(true,Cun.cunManual));
        Cun.guardarHeredado();
		
        Cun.cunManual='012345678901234';
        Cun.buscar();
        Cun.Cancelar();
        
        LibreriaUtilitaria_cls.ErrorExcepcionTest=true;
        Cun.ws.clear();
        Cun.ws.add(new ConsultaCun_ctr.wrapperSelect(true,Cun.cunManual));
        Cun.continuar();
        System.debug('AQUI'+LibreriaUtilitaria_cls.ErrorExcepcionTest);

		test.stopTest();

    }
    
    
    static testMethod void ConsultaCunNuevo() {
    	
		List<sObject> ls = Test.loadData(CUN_Center_Abajo__c.sObjectType, 'ConfCUN');
    	List<sObject> ls2 = Test.loadData(ServiciosWeb__c.sObjectType, 'ServiciosWeb');
    	    	
    	GeneraData_cls.generarData();
    	
    	Legalizacion__c Legalizacion=GeneraData_cls.generarLegalizacion2();
    	
		Legalizacion__c Legalizacion2=GeneraData_cls.generarLegalizacion2();
    	Legalizacion2.CodigouniconumericoCUN__c='0123456789012345';
    	
    	Legalizacion__c Legalizacion3=GeneraData_cls.generarLegalizacion2();
    	Legalizacion3.CodigouniconumericoCUN__c='0123456789012345';
    	Legalizacion3.Estado__c='Gestionado';
    	
    	insert new list<Legalizacion__c>{Legalizacion,Legalizacion2,Legalizacion3};
    	
    	PageReference pageRef0 = Page.ConsultaCun_pag;
    	Test.setCurrentPage(pageRef0);
        ApexPages.currentPage().getParameters().put('id', Legalizacion.id);
        
        ConsultaCun_ctr Cun = new ConsultaCun_ctr();
        Cun.ObtenerConf();
    	
    	Test.setMock(HttpCalloutMock.class, new MockServiciosWeb.MockHttpResponseCun());
        test.startTest();
    	//Nuevo cun
    	Cun.tipo='nuevo';
		Cun.ConsultarCun();
		Cun.ws.clear();
    }
    
    static testMethod void BatchCunExitoso() {
       	dataBatchCun();    	
        objPruebas_tst.confPersonalizadas();        
        CUN_Center_Abajo__c objCun = new CUN_Center_Abajo__c();
        objCun.Esta_Abajo__c=false;
        objCun.NumOrden__c='4347150';
        objCun.TipoIdentificacion__c='NIT';
        objCun.TipoPQR__c='PQR';
        objCun.Campo__c='Campo__c';
        objCun.Name='Consulta Saaw';
        insert objCun;
        LibreriaUtilitariaJobs_cls.ErrorExcepcionTest=true;
        try {
            
            Database.BatchableContext BC;
 
            BatchColaCun_sch objBatch = new BatchColaCun_sch();         
            BatchColaCun_sch.ProgramarJob();            
            
            //String jobId = System.schedule('BatchColaCun_sch','0 0 0 * * ? *',new BatchColaCun_sch());
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
    }
    
    static testMethod void BatchCunFallido() {

        dataBatchCun();
        LibreriaUtilitariaJobs_cls.ErrorExcepcionTest=true;
        try {

            BatchColaCun_bch objBatch = new BatchColaCun_bch();   
            Database.BatchableContext BC;
            string strBaseQuery='';
                        
            Test.startTest();
            strBaseQuery='SELECT Cod_Error_Cun__c,Estado_Envio__c,FechaPQR__c,Id,Identificacion__c,Id_Registro__c,Name,NumOrden__c,Objeto__c,TipoIdentificacion__c,TipoPQR__c,esRastrocun__c FROM Cola_CUN__c WHERE Estado_Envio__c = \'Pendiente\'';
            
            List<SObject> lstColaCun = Database.query(strBaseQuery); 
            BatchColaCun_sch.ProgramarJob(); 
            objBatch.start(BC);
            objBatch.execute(BC,lstColaCun);
            BatchColaCun_sch.ProgramarJob(); 
            objBatch.finish(BC);

            Test.stopTest(); 
            
        } catch(Exception e) {
            System.debug(e.getMessage());
        }		

    }
    
    public static void dataBatchCun(){
    
        List<sObject> ls = Test.loadData(CUN_Center_Abajo__c.sObjectType, 'ConfCUN');
    	List<sObject> ls2 = Test.loadData(ServiciosWeb__c.sObjectType, 'ServiciosWeb');
    	
    	GeneraData_cls.generarData();
    	Legalizacion__c L1=GeneraData_cls.generarLegalizacion2();
    	
    	Legalizacion__c L2=GeneraData_cls.generarLegalizacion2();
    	insert new list<sobject>{L1,L2};
    	
		//Fallido error por regla
        Cola_CUN__c cCun=new Cola_CUN__c();
		cCun.Estado_Envio__c='Pendiente';
		cCun.Cod_Error_Cun__c='500';
		cCun.Identificacion__c='00000000';
		cCun.TipoIdentificacion__c='Nit';
		cCun.NumOrden__c='ccc';
		cCun.FechaPQR__c=Datetime.now();
		cCun.TipoPQR__c='Venta';
		cCun.Objeto__c='Legalizacion__c';
		cCun.Id_Registro__c=L1.id;
		cCun.esRastrocun__c=true;
		
        Cola_CUN__c cCun2=new Cola_CUN__c();
		cCun2.Estado_Envio__c='Pendiente';
		cCun2.Cod_Error_Cun__c='500';
		cCun2.Identificacion__c='00000000';
		cCun2.TipoIdentificacion__c='Nit';
		cCun2.NumOrden__c='ccc';
		cCun2.FechaPQR__c=Datetime.now();
		cCun2.TipoPQR__c='Venta';
		cCun2.Objeto__c='Legalizacion__c';
		cCun2.Id_Registro__c=L2.id;
		cCun2.esRastrocun__c=false;
		
		insert new list<Cola_CUN__c>{cCun,cCun2};
    
    }

    
}