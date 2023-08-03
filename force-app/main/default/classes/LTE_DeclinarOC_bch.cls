/***************************************************************************************************************************
*** Desarrollado por:     Avanxo Colombia                                                                                ***
*** Autor:                Andrés Oliva (AO)                                                                              ***
*** Proyecto:             ETB - LTE                                                                                      ***
*** Descripcion:          Clase Batch para declinar las operaciones comerciales que cumpan con:                          ***
***                       1. Su fecha de creación sea hace 7 días habiles o más    y no se halla legalizado              ***
***                       2. En el detalle de la Oferta debe tener un equipo diferente a traido                          ***                                                                            ***
***                       3. El Tipo de Operación por plan sea: Venta                                                    ***
***                                                                                                                      ***
*** User history:                                                                                                        ***
*** Sprint:                                                                                                              ***
*** Release:                                                                                                             ***
***                                                                                                                      ***  
*** Cambios (Versiones)                                                                                                  ***
*** -------------------------------------                                                                                ***
***            No.      Fecha              Autor         Descripción                                                     ***  
***           -----    ----------    --------------------  ---------------                                               ***
*** @version   1.0     2015-08-12    Andrés Oliva (AO)      Class created                                                ***
***************************************************************************************************************************/


global class LTE_DeclinarOC_bch implements Database.Batchable<sObject>
{

       global final String Query;
       global final String Entity;
       global final String Field;
       global final String Value;
       global final String declinada;
       global String myQuery;
       Datetime fechaConsulta = System.Today();   
      

       global LTE_DeclinarOC_bch()
       {
        

        Map<string,VariablesGlobales__c> vGlobal = VariablesGlobales__c.getAll();
        String producto=vGlobal.get('NombreComercialLTE').valor__c;
               declinada=VariablesGlobales__c.getInstance('EstadoDeclinadoOC').Valor__c;
        String renovacion =VariablesGlobales__c.getInstance('ToppRenovacion').Valor__c; 
        String reposicion =VariablesGlobales__c.getInstance('ToppReposicion').Valor__c; 
        String ventas =VariablesGlobales__c.getInstance('ToppVentas').Valor__c; 
        String diasDeclinarOC = VariablesGlobales__c.getInstance('DiasDeclinacionOC').Valor__c;
        integer i=integer.valueof(diasDeclinarOC);
        system.debug('\n Declianar OCs creadas hace \n'+diasDeclinarOC);
        system.debug('\n Declianar OCs creadas hace Formato entero \n'+i);

        Long milisegundosTranscurridos = milisegundosDiasHabiles(i);
        System.debug('\nMilisegundos Trasnscurridos\n'+milisegundosTranscurridos);
        Datetime fechaCierre = BusinessHours.add(objBH.id, system.today(), milisegundosTranscurridos);
        System.debug('\nfechaCierre: \n'+fechaCierre);     
      
      
        myQuery = 'SELECT LTE_OperacionComercial__r.Id,LTE_OperacionComercial__r.CreatedDate,LTE_OperacionComercial__r.Estado__c,LTE_OperacionComercial__r.Legalizacion__c FROM LTE_DetalleOferta__c  WHERE  (((LTE_OperacionComercial__r.TOPP__r.TipodeOperacionporplan__c=\''+ventas+'\')AND LTE_OperacionComercial__r.Legalizacion__c = null  ))  AND  (LTE_OperacionComercial__r.Estado__c = \'Pendiente\' OR LTE_OperacionComercial__r.Estado__c = \'En Curso\') AND LTE_Sucursal__c != NULL AND LTE_OperacionComercial__r.CreatedDate <= '  +
        fechaCierre.format('yyyy-MM-dd')+'T'+
        fechaCierre.format('HH:mm')+':00.000Z '+'AND LTE_OperacionComercial__r.Plan__r.NombredelProducto__r.Name=\''+producto+'\'  AND LTE_ReferenciaEquipo__r.Name !=\'Equipo Traido\'';
      

        String e;
        String f = 'LTE_OperacionComercial__r.Estado__c';
        String v = declinada;   //
        
        Entity=e; Field=f;Value=v;
       } 


      

       public static BusinessHours objBH
        {
            get
            {
                if(objBH == null)
                {
                    objBH =
                    [
                        select id, Name, MondayStartTime, MondayEndTime, TuesdayStartTime, TuesdayEndTime, 
                                WednesdayStartTime, WednesdayEndTime, ThursdayStartTime, ThursdayEndTime, 
                                FridayStartTime, FridayEndTime, SaturdayStartTime, SaturdayEndTime
                        from BusinessHours
                        where Name = :'Horario ETB'
                    ];
                }
                return objBH;
            }
            set;
        }
        public static Long milisegundosDiasHabiles(long dias)
        {
            System.debug('dias --> ' + dias);
            long horas = dias* 10;
            System.debug('horas --> ' + horas);
            Long minutos = horas* 60;
            System.debug('minutos --> ' + minutos);
            Long segundos = minutos * 60;
            System.debug('horas --> ' + horas);
            long milisegundos = segundos * 1000;
            System.debug('milisegundos --> ' + milisegundos);
            return milisegundos*(-1);
        }
         

       global Database.QueryLocator start(Database.BatchableContext BC)
       {
          System.debug('\n Query utilizado\n'+myQuery);
          return Database.getQueryLocator(myQuery);
       }

     
 
       global void execute(Database.BatchableContext BC,List<LTE_DetalleOferta__c> scope)
       {
        list<OperacionComercial__c> listOc = new list<OperacionComercial__c>();


          for(LTE_DetalleOferta__c s : scope)
          {      
            
            OperacionComercial__c objOpCom = new OperacionComercial__c(id= s.LTE_OperacionComercial__c);
            objOpCom.Estado__c =declinada;
            listOc.add(objOpCom);        
          }    
            system.debug('/ Registros a actualizar /n'+listOc);
            update listOc;
            system.debug('/ Registros actualizados /n'+listOc);

       }

       global void finish(Database.BatchableContext BC)
       {

     
       }

}