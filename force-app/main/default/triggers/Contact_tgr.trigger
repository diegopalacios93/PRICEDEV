/*******************************************************************************
 Desarrollado por:
 Autor:
 Proyecto:
 Descripci?n:            Desencadenador sobre el objeto Contact

 Cambios (Versiones)
 -------------------------------------
 No.     Fecha       Autor                       Descripci?n
 ------  ----------  --------------------        ---------------
 1.0                                             Creación de la clase.
 2.0     23/10/2020  Samuel Rodríguez (SR)       INI26058 - C.D. Ajuste Proceso Batch Cargue de Activos Salesforce - MDM
 3.0     03/03/2022  Brisleydi Calderon (BC)     Excluir tipo de registro "Mensajería HSM" al invocar a la integración IntegracionMDMDataServices_cls
                                                 que envía los contactos al sistema MDM
 *******************************************************************************/
trigger Contact_tgr on Contact(after delete, after insert, after undelete, after update, before delete, before insert, before update ){

    if (trigger.isBefore){
        //  Bloque de ejecución Before Insert
        if (trigger.isInsert){

        }

        //  Bloque de ejecución Before Update
        if (trigger.isUpdate){


        }

        //  Bloque de ejecución Before Delete
        if (trigger.isDelete){

        }

    }

    //  Bloque de ejecución After
    if (trigger.isAfter){
        //  Bloque de ejecución After Insert
        if (trigger.isInsert){

            if (!Test.isRunningTest()){
                //MetodosFuturos_cls.contactos(trigger.newMap.keySet(),new list<string>());
            }
            system.debug('--> Contact_tgr > isInsertAfter: ' + Trigger.new);//SR-INI26058
            Id recordTypeIdOutBound = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('DEG_OutboundMessage').getRecordTypeId();
            Id recordTypeIdHSM = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('DEG_MensajeriaHSM').getRecordTypeId();
            
              for (Contact sglContact : Trigger.new){
                if(!(sglContact.RecordTypeId == recordTypeIdOutBound || sglContact.RecordTypeId == recordTypeIdHSM )){
                    IntegracionMDMDataServices_cls MDMDataServicesInsert = new IntegracionMDMDataServices_cls();
                    if (!Test.isRunningTest()){
                        MDMDataServicesInsert.InsertarDatosContacto(sglContact, 'I');
                    }
                    BanderasEjecucion.setEjecucion('InsertContactMDM');
                }
                    
            }
        }

        //  Bloque de ejecución After Update

        /* */

        if (trigger.isUpdate){

            if (!system.isFuture()){
                 //SR-INI26058
                system.debug('--> Contact_tgr > isUpdateAfter: ' + Trigger.new[0]);
                if (!BanderasEjecucion.ValidarEjecucion('UpdateContactMDM') && BanderasEjecucion.ValidarEjecucion('InsertContactMDM')){
                    IntegracionMDMDataServices_cls MDMDataServicesUpdate = new IntegracionMDMDataServices_cls();
                    if (!Test.isRunningTest()){
                        MDMDataServicesUpdate.ObtenerClienteDesdeContacto(Trigger.new[0]);
                    }
                }
            }

            if (!system.isFuture()){
                 //SR-INI26058
                system.debug('--> Contact_tgr > isUpdateAfter: ' + Trigger.new[0]);
                System.debug(!BanderasEjecucion.ValidarEjecucion('UpdateContactMDM'));
                System.debug(!BanderasEjecucion.ValidarEjecucion('InsertContactMDM'));
                if (!BanderasEjecucion.ValidarEjecucion('UpdateContactMDM') && !BanderasEjecucion.ValidarEjecucion('InsertContactMDM')){
                    IntegracionMDMDataServices_cls MDMDataServicesUpdateContact = new IntegracionMDMDataServices_cls();
                    if (!Test.isRunningTest()){
                        MDMDataServicesUpdateContact.InsertarDatosContacto(Trigger.new[0], 'U');
                    }
                    BanderasEjecucion.setEjecucion('UpdateContactMDM');
                }
            }
        }

        //  Bloque de ejecución After Delete
        if (trigger.isDelete){

        }

        //  Bloque de ejecución After Undelete
        if (trigger.isUndelete){

        }

    }
}