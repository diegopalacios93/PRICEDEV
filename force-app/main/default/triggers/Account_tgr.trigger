/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Jorge Ramos
Proyecto:               ETB - CRM etapa 1
Descripci?n:            Desencadenador sobre el objeto Account 

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripci?n
------  ----------  --------------------        ---------------
1.0     30-12-2013  Jorge Ramos (JR)       Creaci?n de la clase..
2.0 	05/06/2017  Mauricio Farias (MF)   Comento las lineas 65 y 77 para que no se ejecuten la accion sobre directorio de cuantas, Objeto que se elimino.
3.0 	23/10/2020  Samuel Rodríguez (SR)  INI26058 - C.D. Ajuste Proceso Batch Cargue de Activos Salesforce - MDM
*******************************************************************************/
trigger Account_tgr on Account (before insert, before update,after insert, after update) {
    
    //Bloque Before
    if (trigger.isBefore)
    {
        if(trigger.isInsert || trigger.isUpdate)
        {
            for(Account sglAccount:Trigger.new)
            {
                sglAccount.AccountNumberIndex__c = sglAccount.AccountNumber;
            }
        }
        //Bloque BeforeInsert
        if (trigger.isInsert)
        {
        	ValidacionCreacionCuentas_cls validar = new ValidacionCreacionCuentas_cls(); 
            
            if(Trigger.new.Size() == 1 && !ValidacionCreacionCuentas_cls.hasAlreadyRunningTriggerAccount()){
            	ValidacionCreacionCuentas_cls.setAlreadyDoneRunningTriggerAccount();
                validar.ValidarCuenta(Trigger.new[0]); 
            }

            if(Trigger.new.Size() > 1 && !ValidacionCreacionCuentas_cls.hasAlreadyRunningTriggerAccount()){
            	ValidacionCreacionCuentas_cls.setAlreadyDoneRunningTriggerAccount();
                validar.ValidarCuentaMasivo(Trigger.new); 
            }
            validar.asignarPropietarioSucursal(Trigger.new);
        }
        
        //Bloque BeforeUpdate
        else if(trigger.isUpdate)
        {
        	ValidacionCreacionCuentas_cls validar = new ValidacionCreacionCuentas_cls(); 
        	
        	if(Trigger.new.Size() == 1 
        	&& !ValidacionCreacionCuentas_cls.hasAlreadyRunningTriggerAccount() 
        	&& (Trigger.new[0].AccountNumber != Trigger.old[0].AccountNumber 
        	   || Trigger.new[0].Tipodedocumento__c != Trigger.old[0].Tipodedocumento__c) ){
        	   	
        		ValidacionCreacionCuentas_cls.setAlreadyDoneRunningTriggerAccount();
                validar.ValidarCuenta(Trigger.new[0]); 
            }

            if(Trigger.new.Size() > 1 && !ValidacionCreacionCuentas_cls.hasAlreadyRunningTriggerAccount()){
            	ValidacionCreacionCuentas_cls.setAlreadyDoneRunningTriggerAccount();
                validar.ValidarCuentaMasivo(Trigger.new); 
                
            }
            validar.asignarPropietarioSucursal(Trigger.new);
        }
    }

    //Bloque After
    else if(Trigger.isAfter)
    { 
    	ValidacionCreacionCuentas_cls validar = new ValidacionCreacionCuentas_cls();
        //Bloque AfterInsert
        if (trigger.isInsert)
        {
        	//validar.insertaCuentaenDirectorio(Trigger.New); MF: se comenta para que no se porcesen las acciones de directorio de cuentas
        	system.debug('--> Account_tgr > isInsert: '+ Trigger.new);//SR-INI26058
        	for(Account sglAccount:Trigger.new)//SR-INI26058
            {
                IntegracionMDMDataServices_cls MDMDataServicesInsert = new IntegracionMDMDataServices_cls();
                if(!Test.isRunningTest()){
                	MDMDataServicesInsert.InsertarDatosCuenta(sglAccount,'I');
                }
                BanderasEjecucion.setEjecucion('InsertAccountMDM');
            }
        }
        
        //Bloque AfterUpdate
        if (trigger.isUpdate)
        {
            //Valida Cambios que se deban ejecutar en metodos Futuros
            if(!system.isFuture()){
               validar.cambios(trigger.oldMap,trigger.newMap);
            }
    
            //validar.actualizaCuentaenDirectorio(Trigger.New); MF: se comenta para que no se porcesen las acciones de directorio de cuentas
            if(!system.isFuture()){ //SR-INI26058   
                system.debug('--> Account_tgr > isUpdate: '+ Trigger.new[0]);
                if (!BanderasEjecucion.ValidarEjecucion('UpdateAccountMDM') && BanderasEjecucion.ValidarEjecucion('InsertAccountMDM')){//SR-INI26058
                    
                    IntegracionMDMDataServices_cls MDMDataServicesUpdate = new IntegracionMDMDataServices_cls();
                    if(!Test.isRunningTest()){
                    	MDMDataServicesUpdate.ObtenerCliente(Trigger.new[0]);
                    }
                }
            }
            if(!system.isFuture()){ //SR-INI26058     
                system.debug('--> Account_tgr > isUpdate: '+ Trigger.new[0]);
                if (!BanderasEjecucion.ValidarEjecucion('UpdateAccountMDM') && !BanderasEjecucion.ValidarEjecucion('InsertAccountMDM')){
                    IntegracionMDMDataServices_cls MDMDataServicesUpdate = new IntegracionMDMDataServices_cls();
                    if(!Test.isRunningTest()){
                    	MDMDataServicesUpdate.InsertarDatosCuenta(Trigger.new[0],'U');
                    }
                    BanderasEjecucion.setEjecucion('UpdateAccountMDM');
                }
            }
        }
    }

}