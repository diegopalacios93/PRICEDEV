/*******************************************************************************
Desarrollado por:		Avanxo Colombia
Autor:					Jorge Grimaldos
Proyecto:				ETB - CRM Evolutivos
Descripción:			Controlador de la página SeleccionarActivoExistente_pag,
						permite crear Operaciones Comerciles desde una 
						Oportunidad, que afecten Activos ya existentes.

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0		23-01-2014	Jorge Grimaldos (JG)		Creación de la clase
*******************************************************************************/
public with sharing class SeleccionarActivoExistente_ctr {	
	//	Variables privadas
	private Id idOportunidad;
	private ApexPages.StandardSetController sscActivos;
	private Integer intActivosPagina = 20;
	private Id idCuentaConsulta;
	//	Variables públicas
	public List<ActivoETB__c> lstActivos{
		get {
			if (sscActivos != null) {
				return sscActivos.getRecords();
			} else {
				System.debug('Lista Vacia');
				return null;
			}
		}
	}
	public Boolean blnOportunidad {
		get { return idOportunidad != null; }
	}
	public Boolean blnActivos {
		get { return lstActivos != null ; }
	}
	public Boolean blnSiguiente {
		get { return (sscActivos != null? sscActivos.getHasNext() : null);}
	}
	public Boolean blnAnterior {
		get { return (sscActivos != null? sscActivos.getHasPrevious() : null);
		}
	}
	public Integer intTotalActivos {
		get { return sscActivos.getResultSize(); }
	}
	public Integer intInicioPagina {
		get { return ((intActivosPagina * sscActivos.getPageNumber())+1 - intActivosPagina); }
	}
	public Integer intFinPagina {
		get {
			if (intActivosPagina * sscActivos.getPageNumber() > intTotalActivos) {
				return intTotalActivos;
			} else {
				return intActivosPagina * sscActivos.getPageNumber();
			}
		}
	}
	public Id idActivo {get;set;}
	public Boolean blnFiltro {get; set;}
	public String strParametro {get; set;}
	public VariablesGlobales__c vGlobal; //-SAO

	//	Constructor
	public SeleccionarActivoExistente_ctr() {
		if (ApexPages.currentPage().getParameters().get('Id') != null) {
			idOportunidad = ApexPages.currentPage().getParameters().get('Id');
			blnFiltro = false;
		}
		vGlobal = VariablesGlobales__c.getValues('NombreComercialLTE'); //-SAO
	}
	//	Redirige a la VF de creación de OC a partir del activo seleccionado
	public PageReference ElegirActivo() {
		if (idActivo != null) {
			PageReference prActivoSeleccionado = Page.SeleccionProductoCatalogo_pag;
			prActivoSeleccionado.getParameters().put('id', idActivo);
			prActivoSeleccionado.getParameters().put('idOp', idOportunidad);
			prActivoSeleccionado.setRedirect(true);
			return prActivoSeleccionado;
		} else { 	
			return null;
		}
	}
	//	Función principal
	public PageReference TraerActivos() {
		if (blnOportunidad) {
			Id idCuenta = ExtrarIdCuenta();
			if (idCuenta != null) {
				idCuentaConsulta = idCuenta;
				TraerActivosElegibles(idCuenta);
			}
		}
		return null;
	}
	//	Obtiene el Id de la cuenta relacionada a la Oportunidad
	public Id ExtrarIdCuenta() {
		List<Opportunity> lstOportunidad = [ select AccountId  from Opportunity  where Id = :idOportunidad  limit 1 ];
		if (lstOportunidad.size() > 0) {
			return lstOportunidad[0].AccountId;
		} else {
			return null;
		}
	}
	//	Trae los Activos en estado activo que pertenezcan a la cuenta y NO sean
	//	miembros de la misma oportunidad
	public void TraerActivosElegibles(Id idCuenta) {
		System.debug('@@-vGlobal->'+vGlobal); 
		List<ActivoETB__c> lstActivosElegibles = [
			select Name, Oportunidad__r.Name, CreatedDate, 
			Estado__c, NombredelProducto__r.Name, IDservicio__c,
			NumeroConexion__c, SucursalDestino__c, Nombredelcliente__c, 
			ValorTarifaPlan__c, SucursalOrigen__r.Name, Owner.Name,
			MedioUM__c, Plan__r.Name, AnchoBanda__r.Name
			from ActivoETB__c 
			where Nombredelacuenta__c = :idCuenta
			and Estado__c = 'Activo'
			and Oportunidad__c != :idOportunidad
			and Plan__r.NombredelProducto__r.Name != : vGlobal.Valor__c
			order by Name];
		if (lstActivosElegibles.size() > 0) {
			sscActivos = new ApexPages.Standardsetcontroller(lstActivosElegibles);
			sscActivos.setPageSize(intActivosPagina);
		} else {
			sscActivos = null;
		}
	}

	public void FiltrarActivos() {
		System.debug('@@-vGlobal->'+vGlobal); 
		System.debug('strParametro:' + strParametro);
		if (String.isNotEmpty(strParametro)) {
			List<ActivoETB__c> lstActivosElegibles = [
			select Name, Oportunidad__r.Name, CreatedDate, 
			Estado__c, NombredelProducto__r.Name, IDservicio__c,
			NumeroConexion__c, SucursalDestino__c, Nombredelcliente__c, 
			ValorTarifaPlan__c, SucursalOrigen__r.Name, Owner.Name,
			MedioUM__c, Plan__r.Name, AnchoBanda__r.Name
			from ActivoETB__c 
			where Nombredelacuenta__c = :idCuentaConsulta
			and Estado__c = 'Activo'
			and ( NumeroConexion__c like :strParametro OR IDservicio__c like :strParametro )
			and Oportunidad__c != :idOportunidad
			and Plan__r.NombredelProducto__r.Name != : vGlobal.Valor__c
			order by Name];
			sscActivos = new ApexPages.Standardsetcontroller(lstActivosElegibles);
			sscActivos.setPageSize(intActivosPagina);
		} else {
			TraerActivosElegibles(idCuentaConsulta);
		}
	}

	//	Envía al StandarSetControlle a su primera página
	public void IrPrimeraPagina() { sscActivos.first(); }
	//	Envía al StandarSetControlle a su última página  
	public void IrUltimaPagina() { sscActivos.last();}
	//	Envía al StandarSetControlle a su anterior página
	public void IrAnteriorPagina() { sscActivos.previous(); }
	//	Envía al StandarSetControlle a su siguiente página
	public void IrSiguientePagina() { sscActivos.next();}
}