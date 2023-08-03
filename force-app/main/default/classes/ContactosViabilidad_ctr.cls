/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Jorge Ramos
Proyecto:               ETB - CRM etapa 1
Descripción:            Controlador encargado de consultar los contactos relacionados a la cuenta que contiene la viabilidad

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     02-01-2014  Jorge Ramos (JR)       Creación de la clase..
*******************************************************************************/
public class ContactosViabilidad_ctr {

public List<Contact> lstContacts {get;set;}
public String idContacto {get;set;}
public Boolean noResults {get;set;}

    /*
    *@Description: Constructor. Consulta los contactos y llena la lista que usa la VF incrutada en le formato de página de viabilidad.
    */
	public ContactosViabilidad_ctr(ApexPages.StandardController controller){

		noResults = true;
	    String idViabilidad = '';
	    idViabilidad = Apexpages.currentPage().getParameters().get('id');

	    if(String.isNotBlank(idViabilidad)){

		    List<OperacionComercial__c> lstOpComercial = [Select Activo__c 
													     From OperacionComercial__c 
													     Where id in (Select OperacionComercial__c 
													                  From viabilidad__c 
													                  Where id =: idViabilidad)];

            if(!lstOpComercial.isEmpty()){

				lstContacts = [Select id, Name, Rol__c, Area__c, Phone, MobilePhone, Email 
				               From Contact 
				               Where AccountId in (Select nombredelacuenta__c 
				                                   From ActivoETB__c 
				                                   Where id =: lstOpComercial[0].Activo__c)];

				noResults = lstContacts.Size()>1?false:true;

            }
	    }
	}
    /*
    *@Description: Método que recibe el id del contacto desde la VF y redirecciona a la pagina standard del contacto.
    */
	public Pagereference paginaContactoRedirect(){

	    if(String.isNotBlank(idContacto)){
	        PageReference redireccionContacto = new Pagereference('/'+idContacto);
            redireccionContacto.setRedirect(true);

            return redireccionContacto;
	    }
	    
	    return null;
	}
}