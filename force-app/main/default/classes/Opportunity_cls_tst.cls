/*******************************************************************************
Desarrollado por:       Accenture
Autor:                  Luisina Platino
Proyecto:               ETB
Descripcion:            Clase de test de todos los metodos necesarios para 
                        asegurar el proceso de las Oportunidades

Cambios (Versiones)
--------------------------------------------------------------------------------
No.     Fecha       Autor                   Descripcion
------  ----------  --------------------    ---------------
1.0     16-06-2021  Luisina Platino (LP)    Creacion de la clase. Unificacion de tests
*******************************************************************************/

@IsTest
public class Opportunity_cls_tst {

    @TestSetup
    static void makeData(){

        Id clientePrincipalRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();

        Account acc = new Account();
        acc.Name = 'cuentacuentacuenta123';
        acc.recordTypeId = clientePrincipalRecordTypeId;
        acc.Type = 'Prospecto';
        acc.AccountNumber='240324';
        acc.Segmento__c='Empresas';
        acc.SubSegmento__c='Grandes';
        acc.Tipodedocumento__c='NIT';
        acc.Estado_Cuenta__c='Activo';
        acc.Phone='3054658978';
        insert acc;

        Id opEspecialRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Oportunidad Especial').getRecordTypeId();

        ComponentePromocion__c compania = new ComponentePromocion__c();
        compania.Name = 'Nueva Campaña';
        insert compania;
  
        Opportunity opp = new Opportunity();
        opp.recordTypeId = opEspecialRecordTypeId;
        opp.Name = 'Test';
        opp.AccountId = acc.Id;
        opp.StageName = 'Negociación Cerrada';
        opp.PDC__c = '80% - Probabilidad de Éxito';
        opp.CloseDate = Date.today()+5;
        opp.ComponenteDeLaPromocion__c = compania.Id;

        insert opp;

        Oferta_Op__c oferta = new Oferta_Op__c();
        oferta.RecordTypeId = Schema.SObjectType.Oferta_Op__c.getRecordTypeInfosByName().get('Gestionado').getRecordTypeId();
        oferta.Nombre_de_la_cuenta__c = 'Donec risus';
        oferta.Oportunidad__c = opp.Id;
        oferta.Concepto__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
        oferta.Fecha_Presentacion_Oferta__c = Date.today();
        oferta.Estado_Oferta__c = 'En Proceso';

        insert oferta;
        
        ACO__c aco = new ACO__c();
        aco.Actividad__c = 'Evaluación de áreas';
        aco.Estado_Actividad__c = 'Pendiente';
        aco.Nombre_del_Cliente__c = acc.Id;
        aco.Identificador_Oferta_OP__c = oferta.Id;
        aco.Nombre_de_la_Oportunidad__c = opp.Id;

        insert aco;
        
        CatalogoProductos__c objProducto = new CatalogoProductos__c();
        objProducto.Name = 'TELEFONIA MOVIL (LTE) a';
        objProducto.Familia__c = 'LTE';
        objProducto.LineaNegocio__c = 'Redes Móviles';
        objProducto.CodigoProducto__c = '7635736';
        objProducto.Estado__c = 'Activo';
        objProducto.Descripcion__c = 'Teste';
        objProducto.AtributosEstandar__c = 'Teste';
        objProducto.Crear_Linea__c=true;
        insert objProducto;
        
        Planes__c objPlan = new Planes__c ();
        objPlan.Name = 'PLAN NEGOCIOS POSPAGO M';
        objPlan.NombredelProducto__c = objProducto.Id;
        objPlan.TipodePlan__c = 'Principal';
        objPlan.Tarifa__c = 96000;
        objPlan.Estado__c = 'Activo';
        objPlan.Descripcion__c = 'La tarifa es todo destino Moviles y Fijos Nacionales ';
        objPlan.CondicionesComerciales__c = 'Tarificacion por segundo';
        objPlan.LTE_PlanEstructurados__c = true;
        objPlan.LTE_TipoControl__c = 'Control';
        insert objPlan;
        
        TOPP__c objTOPP = new TOPP__c();
        objTOPP.Name = 'Venta- TELEFONIA MOVIL (LTE)';
        objTOPP.TipodeOperacionporplan__c = 'Venta';
        objTOPP.Tipoderegistro__c = 'Venta_LTE';
        objTOPP.AplicaPreventa__c=false;
        objTOPP.DisponibleVentainicial__c = false;
        objTOPP.Facturable__c = false;
      //  objTOPP.LTE_Catalogo_de_Producto__c = objProducto.Id;
        insert objTOPP;
        
        List<VariablesGlobales__c> lstVariablesGlobales = new List<VariablesGlobales__c>();
        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE) aa';
        vGlobal.Name = 'NombreComercialLTE';
        lstVariablesGlobales.add(vGlobal);
        insert lstVariablesGlobales;
        
        OperacionComercial__c objOpComercial = new OperacionComercial__c();
        objOpComercial.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('Venta LTE').getRecordTypeId();
        objOpComercial.CuentaCliente__c = acc.Id;
        //objOpComercial.Activo__c = objServicio.Id;
        objOpComercial.Plan__c = objPlan.Id;
        objOpComercial.TOPP__c = objTOPP.Id;
        objOpComercial.Oportunidad__c = opp.Id;
        objOpComercial.Estado__c = 'En Curso';
        objOpComercial.ComponenteCampana__c = compania.Id;
        objOpComercial.Tecnologia_servicio_SDWAN__c = 'ghg';
        insert objOpComercial;
        
          List<OperacionComercial__c> listOC = [SELECT Id, Name, Plan__c, Plan__r.Name, 
                                               Plan__r.NombredelProducto__r.Name, ComponenteCampana__c FROM OperacionComercial__c];
        system.debug('OC 111----------------------->>>>>: ' + listOC);
    }

    @IsTest
    static void test90Probability_sendBellNotification(){

        Opportunity opp = [SELECT PDC__c FROM Opportunity LIMIT 1];
        
        opp.PDC__c = '90% - Probabilidad de Éxito';

        Test.startTest();
        update opp;
        Test.stopTest();

        Opportunity result = [SELECT PDC__c FROM Opportunity LIMIT 1];

        System.assertEquals(opp.PDC__c, result.PDC__c, '[!] Las probabilidades no coinciden');
    }

	@isTest static void TestAsignarAprobadores() {
		User u = new User(Id = Userinfo.getUserId());
		u.EsAsesor__c = true;
		update u;
		Account a = new Account( Name = 'Test Account', OwnerId = u.id, Phone='3054658978');
		insert a;
		System.debug('Name:' + [Select Owner.Username from Account Where Id =: a.id].Owner.UserName);
		Opportunity opp = new Opportunity( AccountId = a.id, Name = 'Test Opp', StageName ='En Estudio', CloseDate = System.today() + 7);
		insert opp;
	}
    
    @isTest static void TestActualizarPromocionOC(){
         Opportunity opp = [SELECT Id, ComponenteDeLaPromocion__c FROM Opportunity LIMIT 1];
         List<OperacionComercial__c> listOC = [SELECT Id, ComponenteCampana__c FROM OperacionComercial__c];
         Test.startTest();
             BanderasEjecucion.setEjecucion('OperacionComercialisAfterUpdate');
             ComponentePromocion__c compania = new ComponentePromocion__c();
             compania.Name = 'Nueva Campaña 2';
             insert compania;
               
             opp.ComponenteDeLaPromocion__c = compania.Id;
               
             Opportunity_cls claseOpp = new Opportunity_cls(); 
             claseOpp.actualizarPromocionOC(opp, listOC);
 	    Test.stopTest();
    }
}