@isTest
private class CambioSuscriptor_tst {
    /*
    static testMethod void myUnitTest() {
        Document document = new Document();
        document.Body = Blob.valueOf('Some Text');
        document.ContentType = 'application/pdf';
        document.DeveloperName = 'search4';
        document.IsPublic = true;
        document.Name = 'search';
        document.FolderId = [SELECT Id FROM Folder where Type = 'Document' LIMIT 1].id;
        insert document;
        
        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        insert vGlobal;
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();
        Id devRecordTypeIdSucursal = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sucursales').getRecordTypeId();
        objPruebas_tst obj =new objPruebas_tst();
        
        Account cliente=obj.ObjAccount();
        cliente.RecordTypeId =devRecordTypeId;
        cliente.AccountNumber='1234567890';
        cliente.Tipodedocumento__c='Cédula de ciudadanía';
        cliente.Autoriza_Tratamiento_de_Datos_Personales__c='Si';
        System.debug(devRecordTypeId);
        insert cliente;
        
        Account clienteDestino=obj.ObjAccount();
        clienteDestino.RecordTypeId =devRecordTypeId;
        clienteDestino.AccountNumber='22222';
        clienteDestino.Tipodedocumento__c='Cédula de ciudadanía';
        clienteDestino.Autoriza_Tratamiento_de_Datos_Personales__c='Si';
        insert clienteDestino;
        
        Poblacion__c objDepto = new Poblacion__c();
        objDepto.Name = 'BOGOTA D.C.';
        objDepto.CodigoDane__c = '11000';
        objDepto.EsDepartamento__c = true;
        insert objDepto;
        
        Poblacion__c objMunicipio = new Poblacion__c();
        objMunicipio.Name = 'BOGOTA D.C.';
        objMunicipio.CodigoDane__c = '11001';
        objMunicipio.EsMunicipio__c = true;
        objMunicipio.Padre__c = objDepto.Id;
        insert objMunicipio;
        
        CuentaFacturacion__c objFac = new CuentaFacturacion__c();
        objFac.Cliente__c = clienteDestino.Id;
        objFac.Estado__c ='Activo';
        objFac.Ciudad__c = objMunicipio.Id;
        objFac.DirCorresp__c = 'Test DirCorresp';
        insert objFac;
        
        ActivoETB__c objAct = new ActivoETB__c();
        objAct.NombredelaCuenta__c = cliente.id;
        objAct.Estado__c = 'Activo';
        insert objAct;
        
        objAct = new ActivoETB__c();
        objAct.NombredelaCuenta__c = cliente.id;
        objAct.Estado__c = 'Activo';
        insert objAct;
        
        Contact objCon = new Contact(IsTEST__c = true);
        objCon.LastName = 'Apellido 1';
        insert objCon;
        
        PageReference pageRef0 = Page.CambioSuscriptor_pag;
        Test.setCurrentPage(pageRef0);
        ApexPages.currentPage().getParameters().put('idCuenta', cliente.id);
        CambioSuscriptor_ctr cs=new CambioSuscriptor_ctr();
        
        cs.iLupas.cuentaCliente = clienteDestino.id;
        cs.iLupas.cuentaFacturacion =objFac.id;
        
        cs.getContactoInfo();
        cs.getCuentaInfo();
        cs.getCuentaFacturacionInfo();
        cs.habilitarCuentaFact();
        cs.getSeleccion();
        
        cs.wActivosTodos[0].blnChecked = true;
        
        cs.cambiarSuscriptor();
        cs.iLupas.contactoAdm = objCon.id;
        cs.cambiarSuscriptor();
        cs.iLupas.contactoTec = objCon.id;
        cs.cambiarSuscriptor();
        cs.cerrarPagina();
    }*/
    
    
    static testMethod void myUnitTest2() {
        
        Document document = new Document();
        document.Body = Blob.valueOf('Some Text');
        document.ContentType = 'application/pdf';
        document.DeveloperName = 'search4';
        document.IsPublic = true;
        document.Name = 'search';
        document.FolderId = [SELECT Id FROM Folder where Type = 'Document' LIMIT 1].id;
        insert document;
        
        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        insert vGlobal;
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();
        Id devRecordTypeIdSucursal = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sucursales').getRecordTypeId();
        
        objPruebas_tst obj =new objPruebas_tst();
        
        Account cliente=obj.ObjAccount();
        cliente.RecordTypeId =devRecordTypeId;
        cliente.AccountNumber='1234567890';
        cliente.Tipodedocumento__c='Cédula de ciudadanía';
        cliente.Autoriza_Tratamiento_de_Datos_Personales__c='Si';
        System.debug(devRecordTypeId);
        insert cliente;
        
        Account clienteDestino=obj.ObjAccount();
        clienteDestino.RecordTypeId =devRecordTypeId;
        clienteDestino.AccountNumber='22222';
        clienteDestino.Tipodedocumento__c='Cédula de ciudadanía';
        clienteDestino.Autoriza_Tratamiento_de_Datos_Personales__c='Si';
        insert clienteDestino;
        
        Account sucursal=obj.ObjAccount();
        sucursal.RecordTypeId =devRecordTypeIdSucursal;
        sucursal.AccountNumber='1234567890';
        sucursal.Tipodedocumento__c='Cédula de ciudadanía';
        sucursal.Cuenta__c = cliente.Id;
        sucursal.Autoriza_Tratamiento_de_Datos_Personales__c='No';
        insert sucursal;
        
        Account sucursalDestino=obj.ObjAccount();
        sucursalDestino.RecordTypeId =devRecordTypeIdSucursal;
        sucursalDestino.AccountNumber='22222';
        sucursalDestino.Tipodedocumento__c='Cédula de ciudadanía';
        sucursalDestino.Cuenta__c = clienteDestino.Id;
        sucursalDestino.Autoriza_Tratamiento_de_Datos_Personales__c='No';
        insert sucursalDestino;
        
        Poblacion__c objDepto2 = new Poblacion__c();
        objDepto2.Name = 'BOGOTA D.C.';
        objDepto2.CodigoDane__c = '11000';
        objDepto2.EsDepartamento__c = true;
        insert objDepto2;
        
        Poblacion__c objMunicipio2 = new Poblacion__c();
        objMunicipio2.Name = 'BOGOTA D.C.';
        objMunicipio2.CodigoDane__c = '11001';
        objMunicipio2.EsMunicipio__c = true;
        objMunicipio2.Padre__c = objDepto2.Id;
        insert objMunicipio2;
        
        CuentaFacturacion__c objFac = new CuentaFacturacion__c();
        objFac.Cliente__c = clienteDestino.Id;
        objFac.Estado__c ='Activo';
        objFac.Ciudad__c = objMunicipio2.Id;
        objFac.DirCorresp__c = 'Test DirCorresp';
        insert objFac;
        
        ActivoETB__c objAct = new ActivoETB__c();
        objAct.NombredelaCuenta__c = cliente.id;
        objAct.Estado__c = 'Activo';
        objAct.SucursalOrigen__c = sucursal.Id;
        insert objAct;
        /*
        objAct = new ActivoETB__c();
        objAct.NombredelaCuenta__c = cliente.id;
        objAct.Estado__c = 'Activo';
        insert objAct;*/
        
        Contact objCon = new Contact(IsTEST__c = true);
        objCon.LastName = 'Apellido 1';
        insert objCon;
        
        PageReference pageRef0 = Page.CambioSuscriptor_pag;
        Test.setCurrentPage(pageRef0);
        ApexPages.currentPage().getParameters().put('idCuenta', cliente.id);
        CambioSuscriptor_ctr cs=new CambioSuscriptor_ctr();
        cs.cuenta = clienteDestino.Id;
        cs.iLupas.contactoAdm = '';
        cs.iLupas.contactoTec = '';
        cs.iLupas.cuentaCliente = '';
        cs.iLupas.cuentaFacturacion =objFac.id;
        cs.cambiarSuscriptor();
        cs.iLupas.contactoAdm = objCon.id;
        cs.cambiarSuscriptor();
        cs.iLupas.contactoTec = objCon.id;
        cs.cambiarSuscriptor();
        cs.iLupas.cuentaCliente = clienteDestino.id;
        cs.cambiarSuscriptor();
        cs.getContactoInfo();
        cs.getCuentaInfo();
        cs.getCuentaFacturacionInfo();
        cs.habilitarCuentaFact();
        cs.getSeleccion();
        
        cs.wActivosTodos[0].blnChecked = true;
        cs.cambiarSuscriptor();
        cs.cerrarPagina();
        cs.checkAll();
        try {
            CambioSuscriptor_ctr.getCreatableFieldsSOQL('Account','');
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
        try {
            CambioSuscriptor_ctr.getCreatableFieldsSOQL('Account','ID in ('+cliente.id+')');
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
    }
    
}