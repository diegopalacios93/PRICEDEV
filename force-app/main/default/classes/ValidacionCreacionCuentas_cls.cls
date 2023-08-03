/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Jorge Ramos
Proyecto:               ETB - CRM etapa 1
Descripci?n:            Clase encargada de la validaci?n de cuentas al momento de la creaci?n

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripci?n
------  ----------  --------------------        ---------------
1.0     30-12-2013  Jorge Ramos (JR)       Creaci?n de la clase..
*******************************************************************************/
public class ValidacionCreacionCuentas_cls {
    
    private static boolean isRunningTriggerAccount = false;
    
    /**
        @Description: Indica si se ha ejecutado el trigger 
     **/
    public static boolean hasAlreadyRunningTriggerAccount() {
        return isRunningTriggerAccount;
    }
    
    /**
        @Description: Establece que ya se ejecut? el trigger
     **/
    public static void setAlreadyDoneRunningTriggerAccount() {
        isRunningTriggerAccount = true;
    }
    /**
        @Description: Establece que ya se finaliz? la ejecuci?n del trigger. Usado solo en clase de prueba
     **/
    public static void setFinishedRunningTriggerAccount() {
        isRunningTriggerAccount = false;
    }

    /*
    *@Description: M?todo que valida en tipo y n?mero de documento de la cuenta y no permite la creaci?n/actualizaci?n del registro si ya existe en SFDC
    */
    public void ValidarCuenta(Account cuenta){
        String usrProfileName = [Select u.Profile.Name 
                                 From User u 
                                 Where u.id =: Userinfo.getUserId()].Profile.Name;
        
        map<String,PerfilesCreacionCuentas__c> perfilesMap = PerfilesCreacionCuentas__c.getAll();

       if(String.isNotBlank(cuenta.AccountNumber) && String.isNotBlank(cuenta.Tipodedocumento__c) && !perfilesMap.containsKey(usrProfileName)){
        
            List<Account> lstCuentas = [Select id, Name, Tipodedocumento__c, AccountNumber 
                                         From Account 
                                         Where AccountNumber =: cuenta.AccountNumber 
                                         And AccountNumberIndex__c =: cuenta.AccountNumber 
                                         And Tipodedocumento__c =: cuenta.Tipodedocumento__c
                                         And RecordType.DeveloperName!='Sucursales'
                                         ];
                                         
		Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sucursales').getRecordTypeId();
                                         
           if(lstCuentas.Size() > 0 && cuenta.RecordTypeId!=devRecordTypeId){
                cuenta.AccountNumber.addError(Label.ErrorCreacionCuenta+' '+cuenta.Tipodedocumento__c+' '+cuenta.AccountNumber);
                cuenta.addError(Label.ErrorCreacionCuenta+' '+cuenta.Tipodedocumento__c+' '+cuenta.AccountNumber);
           }
        }
    }
    /*
    *@Description:
    */
    /*public void insertaCuentaenDirectorio(List<Account> lstAccount){
 
    	List<DirectorioDeCuenta__c> lstDirectorio = new List<DirectorioDeCuenta__c>();
    	DirectorioDeCuenta__c objDirectorio;
    	RecordType objRT = [select id from RecordType where DeveloperName = 'Cliente_Principal'];
    	for( Account objAccount : lstAccount ){
    		if(objAccount.RecordTypeId == objRT.Id){
	    		objDirectorio = new DirectorioDeCuenta__c();
	    		if( objAccount.Name.length() > 80)
	    			objDirectorio.Name = objAccount.Name.substring( 0 , 80 );
	    		else
	    			objDirectorio.Name = objAccount.Name;
	    		
	    		objDirectorio.AccountNumber__c = objAccount.AccountNumber;
	    		objDirectorio.Razonsocial__c = objAccount.RazonSocial__c;    		
	    		objDirectorio.Actividad_Economica__c = objAccount.Actividad_Economica__c;
				objDirectorio.Cuenta_Principal__c = objAccount.ID;
				objDirectorio.Rentabilidad__c = objAccount.Rentabilidad__c;
				objDirectorio.Segmento__c = objAccount.Segmento__c;
				objDirectorio.SubSegmento__c = objAccount.SubSegmento__c;
				objDirectorio.TipodeAtencion__c = objAccount.TipodeAtencion__c;
				objDirectorio.Tipodedocumento__c = objAccount.Tipodedocumento__c;
				objDirectorio.Propietariodelacuenta__c = objAccount.ownerid;
				objDirectorio.ValordeCliente__c = objAccount.ValordeCliente__c;
				objDirectorio.ValorFacturacionETB__c = objAccount.ValorFacturacionETB__c;
				objDirectorio.ValorPotencial__c = objAccount.ValorPotencial__c;
				
				objDirectorio.Estado_Cuenta__c = objAccount.Estado_Cuenta__c;
				objDirectorio.Causal_Inactivacion__c = objAccount.Causal_Inactivacion__c;
				objDirectorio.Fecha_Inactivacion__c = objAccount.Fecha_Inactivacion__c;
				
				lstDirectorio.add(objDirectorio);
    		}
    	}
	system.debug('\n\n lstDirectorio.size()==>'+lstDirectorio);
	if( lstDirectorio.size() > 0)
		insert lstDirectorio;
	
    }
    /*
    *@Description:
    */
    /*public void actualizaCuentaenDirectorio(List<Account> lstAccountNew){
 
    	system.debug('\n\n lstAccountNew.size() ==>'+lstAccountNew.size());
    	Map<String,Account> mapAccount = new Map<String,Account>();
    	RecordType objRT = [select id from RecordType where DeveloperName = 'Cliente_Principal'];
    	for( Account tmp : lstAccountNew ){
    		if(tmp.RecordTypeId == objRT.Id){
    			mapAccount.put( tmp.Id , tmp );
    		}
    	}
    	system.debug('\n\n mapAccount '+mapAccount);
    	List<DirectorioDeCuenta__c> lstDirectorio = [SELECT 
							    	id,
							    	Name,
							    	AccountNumber__c,
							    	Razonsocial__c,
							    	Cuenta_Cliente_Unico__c,
							    	Actividad_Economica__c,
							    	Cuenta_Principal__c,
							    	Rentabilidad__c,
							    	Segmento__c,	
							    	SubSegmento__c,
							    	TipodeAtencion__c,
							    	Tipodedocumento__c,
							    	ownerid,
							    	ValordeCliente__c,
							    	ValorPotencial__c,
							    	ValorFacturacionETB__c
							    		FROM DirectorioDeCuenta__c WHERE Cuenta_Principal__c in : mapAccount.keySet()];
		
		system.debug('\n\n lstDirectorio.size()'+lstDirectorio.size());	
		if( lstDirectorio.size() > 0){		    		
    	for ( DirectorioDeCuenta__c objDirectorio : lstDirectorio ){
    		system.debug('\n\n objDirectorio.Id '+objDirectorio.Id);
    		
    		if( mapAccount.get(objDirectorio.Cuenta_Principal__c).Name.length() > 80)
	    		objDirectorio.Name = mapAccount.get(objDirectorio.Cuenta_Principal__c).Name.substring( 0 , 80 );
    		else
    			objDirectorio.Name = mapAccount.get(objDirectorio.Cuenta_Principal__c).Name;
    				
    		
    		objDirectorio.AccountNumber__c = mapAccount.get(objDirectorio.Cuenta_Principal__c).AccountNumber;
    		objDirectorio.Razonsocial__c = mapAccount.get(objDirectorio.Cuenta_Principal__c).RazonSocial__c;
    		objDirectorio.Actividad_Economica__c = mapAccount.get(objDirectorio.Cuenta_Principal__c).Actividad_Economica__c;
			objDirectorio.Rentabilidad__c = mapAccount.get(objDirectorio.Cuenta_Principal__c).Rentabilidad__c;
			objDirectorio.Segmento__c = mapAccount.get(objDirectorio.Cuenta_Principal__c).Segmento__c;
			objDirectorio.SubSegmento__c = mapAccount.get(objDirectorio.Cuenta_Principal__c).SubSegmento__c;
			objDirectorio.TipodeAtencion__c = mapAccount.get(objDirectorio.Cuenta_Principal__c).TipodeAtencion__c;
			objDirectorio.Tipodedocumento__c = mapAccount.get(objDirectorio.Cuenta_Principal__c).Tipodedocumento__c;
			objDirectorio.Propietariodelacuenta__c = mapAccount.get(objDirectorio.Cuenta_Principal__c).ownerid;
			objDirectorio.ValordeCliente__c = mapAccount.get(objDirectorio.Cuenta_Principal__c).ValordeCliente__c;
			objDirectorio.ValorFacturacionETB__c = mapAccount.get(objDirectorio.Cuenta_Principal__c).ValorFacturacionETB__c;
			objDirectorio.ValorPotencial__c = mapAccount.get(objDirectorio.Cuenta_Principal__c).ValorPotencial__c;
			
			objDirectorio.Estado_Cuenta__c = mapAccount.get(objDirectorio.Cuenta_Principal__c).Estado_Cuenta__c;
			objDirectorio.Causal_Inactivacion__c = mapAccount.get(objDirectorio.Cuenta_Principal__c).Causal_Inactivacion__c;
			objDirectorio.Fecha_Inactivacion__c = mapAccount.get(objDirectorio.Cuenta_Principal__c).Fecha_Inactivacion__c;
    	}	
    	update lstDirectorio;
		}
		
		List<Account> lstAcc2 = [select
									id,
									Name,
									RecordTypeId,
									AccountNumber,
									RazonSocial__c,
									Actividad_Economica__c,
									Rentabilidad__c,
									Segmento__c,
									SubSegmento__c,
									TipodeAtencion__c,
									Tipodedocumento__c,
									ownerid,
									ValordeCliente__c,
									ValorFacturacionETB__c,
									ValorPotencial__c,
									Causal_Inactivacion__c,
									Fecha_Inactivacion__c
							 from Account where id not in 
							          			(select Cuenta_Principal__c from DirectorioDeCuenta__c) 
							          			and id in : mapAccount.keySet()];
		system.debug('\n\n lstAcc2.size()==> '+lstAcc2.size());          			
         insertaCuentaenDirectorio(lstAcc2);
    }
    /*
    *@Description: M?todo masivo que valida en tipo y n?mero de documento de la cuenta y no permite la creaci?n/actualizaci?n del registro si ya existe en SFDC
    */
    public void ValidarCuentaMasivo(List<Account> lstCuentas){
        
        String usrProfileName = [Select u.Profile.Name 
                                 From User u 
                                 Where u.id =: Userinfo.getUserId()].Profile.Name;
        
        map<String,PerfilesCreacionCuentas__c> perfilesMap = PerfilesCreacionCuentas__c.getAll();

       if(!perfilesMap.containsKey(usrProfileName)){
           
        	List<String> lstAccountNumber = new List<String>();
            for(Account acc : lstCuentas){
                lstAccountNumber.add(acc.AccountNumber);
           } 
           
           List<Account> lstAccounts = [Select id, Name, Tipodedocumento__c, AccountNumber 
           									From Account
           										where RecordType.DeveloperName <> 'Sucursales' and AccountNumberIndex__c = :lstAccountNumber];
           	/*
           	 Angel Soto - 25/11/2014
           	 Se a?ade el filtro de sucursales dado que para el caso de carga masiva de sucursales no es necesario aplicar
           	 las validaciones de cuentas duplicadas.
           	*/
           Map<String, Account> mapAccounts = new Map<String, Account>();
           
           Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sucursales').getRecordTypeId();
            
           for(Account acc : lstAccounts){
               mapAccounts.put(acc.Tipodedocumento__c+'--'+acc.AccountNumber, acc);
           }
           for(Account acc : lstCuentas){
           	
           	if(devRecordTypeId==acc.RecordTypeId){
           		continue;           		           	
           	}
            
               //Insert
                if(mapAccounts.containsKey(acc.Tipodedocumento__c+'--'+acc.AccountNumber) && acc.Id == null){
                    
                    acc.addError(Label.ErrorCreacionCuentaMasivo);
                } 
                //Update
                if(mapAccounts.containsKey(acc.Tipodedocumento__c+'--'+acc.AccountNumber) 
                   && acc.Id != null 
                   && acc.id != mapAccounts.get(acc.Tipodedocumento__c+'--'+acc.AccountNumber).id){
                    
                    acc.addError(Label.ErrorCreacionCuentaMasivo);
                } 
           }
       }
    }

    public void asignarPropietarioSucursal(list<Account> cuentas){

      list <Id>acc=new list <Id>();
      list<Account> sucusales =new list<Account>();
      
      Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sucursales').getRecordTypeId();


      for(account c:cuentas){
        if(c.Cuenta__c!=null && c.RecordTypeId==devRecordTypeId){
          acc.add(c.Cuenta__c);
          sucusales.add(c);
        }
      }

      if(!acc.isEmpty()){

        Map<Id, Account> propietarios = new Map<Id, Account>([Select id, ownerId from Account where id In :acc]);

        for(Account s:sucusales){

          //s.OwnerId=propietarios.get(s.Cuenta__c).ownerId;

        }
      }


    }

    //Valida los cambios en la cuenta para que se ejecute un inico metodo futuro
    public void cambios(map<Id,Account> oldMap ,map <Id,Account> newMap){

      map<Id,RecordTypeInfo> registros= Schema.SObjectType.Account.getRecordTypeInfosByID();

      set<id>cambioPropietario=new set<id>();

      //Contiene las tareas que debe realizar el metodo futuro
      set<string> tareasFuturo=new set<string>();

      for(Id idC:oldMap.keySet()){

        //Si es Cliente Principal y cambia el propietario
        if(registros.get(oldMap.get(idC).RecordTypeId).getName()=='Cliente Principal' &&
          oldMap.get(idC).ownerid!=newMap.get(idC).ownerid){
          cambioPropietario.add(idC);
        }

      }

      if(!cambioPropietario.isEmpty()){
        MetodosFuturos_cls.dataFuturo df= New MetodosFuturos_cls.dataFuturo('actualizarSucursales',cambioPropietario);
        //Convierte en json para que un objeto complejo pueda ser enviado a un metodo futuro
        tareasFuturo.add(JSON.serialize(df));
      }


      if(!tareasFuturo.isEmpty()){
        MetodosFuturos_cls.MetodosFuturosCuenta(tareasFuturo);
      }


    }

}