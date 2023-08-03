/***********************************************************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                          Luis Eduardo Mogoll?n
Proyecto:                       ETB Evolutivos
Descripci?n:            Controlador Pagina Configuraci?n Red inteligente

Cambios (Versiones)
-------------------------------------
No.             Fecha                   Autor                                           Descripci?n
----    ----------              --------------------            ---------------
1.0             2014-10-22              Luis Eduardo Mogollon (LEM)     Creaci?n de la clase.
***********************************************************************************************************************/


public class ConfRedInteligente_ctr {


public ConfRedInteligente__c conf {get;set;}
public OperacionComercial__c OC {get;set;}
public Boolean encLocal {get;set;}
public Boolean encLocal2 {get;set;}
public Contact RepresentanteLegal {get;set;}
public Contact Contacto {get;set;}
public Account cuenta {get;set;}
public Boolean personaNat {get;set;}
public Boolean personaJur {get;set;}
public Boolean tipodocNit {get;set;}
public Boolean tipodocCC {get;set;}
public Boolean tipodocOtro {get;set;}
public Boolean Activacion {get;set;}
public Boolean Modificacion {get;set;}
public Boolean Cancelacion {get;set;}
public Boolean mostrarBoton {get;set;}
public list<DetalleConfRedInteligente__c> origen {get;set;}
public list<DetalleConfRedInteligente__c> horadia {get;set;}
public list<DetalleConfRedInteligente__c> tipodia {get;set;}
public list<DetalleConfRedInteligente__c> menu {get;set;}
public list<DetalleConfRedInteligente__c> porcentaje {get;set;}
public list<DetalleConfRedInteligente__c> reenturamiento {get;set;}
public list<DetalleConfRedInteligente__c> listanegra {get;set;}
public list<DetalleConfRedInteligente__c> CentroRespuesta {get;set;}
public list<DetalleConfRedInteligente__c> prefijos {get;set;}
public list<DetalleConfRedInteligente__c> locuciones {get;set;}
public string numeroRedIn {get;set;}
public Boolean ActivarGuardado {get;set;}
public ConfRedInteligente_ctr()
{
	
        conf = new ConfRedInteligente__c();
        // a?adir a todas las filas las filas por defecto
        encLocal=false;
        encLocal2=false;
        personaNat=false;
        personaJur=false;
        tipodocNit=false;
        tipodocCC=false;
        tipodocOtro=false;
        ActivarGuardado=false;
        representanteLegal = new Contact();
        contacto = new Contact();
        mostrarBoton = false;
        //llamar la conf de los tipos de registro:
        map<string,RecordTypesDetConfRedInteligente__c> mapRecordTypes = 	RecordTypesDetConfRedInteligente__c.getAll();
        origen=new list<DetalleConfRedInteligente__c>();
        horadia=new list<DetalleConfRedInteligente__c>();
        tipodia=new list<DetalleConfRedInteligente__c>();
        menu=new list<DetalleConfRedInteligente__c>();
        porcentaje=new list<DetalleConfRedInteligente__c>();
        reenturamiento=new list<DetalleConfRedInteligente__c>();
        prefijos=new list<DetalleConfRedInteligente__c>();
        locuciones=new list<DetalleConfRedInteligente__c>();
        centrorespuesta=new list<DetalleConfRedInteligente__c>();
        listanegra=new list<DetalleConfRedInteligente__c>();
        Activacion=false;
        Modificacion=false;
        cancelacion=false;
        OC = new OperacionComercial__c();
        //validar si es numero local o numero 018000
       string tipo='';
       tipo= ApexPages.currentPage().getParameters().get('local');
       string idcuenta='';
       string idOC='';
       idcuenta=ApexPages.currentPage().getParameters().get('Acc');
       idOC = ApexPages.currentPage().getParameters().get('OC');
       // validar tipo si red locar o numero unico
       if(tipo.equalsIgnoreCase('1'))
       {
       	 encLocal=true;
       }
       else if(tipo.equalsIgnoreCase('2'))
       {
       	 encLocal2=true;
       }
        //llenar los datos de la cuenta de la persona
        cuenta = new Account();
        
        // de la OC extraer 
        
        
        
        
        //obtener el numero de reservado o numero de la configuracion
        NumeroRedIn = '';
        NumeroRedIn = ApexPages.currentPage().getParameters().get('NumRed');
        //obtener la operacion comercial
        if(idOC!=null && idOC!='')
        {
        	OC = consultaOperacionComercial(idOC);
        	if(OC.Envio_Red_Inteligente__c)
        	{
        		mostrarBoton=true;
        	}
        	
        	CargarInfo(idOC);
        	
        		cuenta =datoscuenta(OC.CuentaCliente__c);
        	if(cuenta!=null)
        	{
        		if(cuenta.TipodeDocumento__c=='NIT')
        		{
        			personaJur=true;
        			tipodocNit=true;
        			
        		}
        		else if(cuenta.TipodeDocumento__c=='Cedula de ciudadania')
        		{
        			personaNat=true;
        			tipodocCC=true;
        		}
        		else
        		{
        			tipodocOtro=true;
        		}
        			
        	}
        	
        }
           if(origen.size()==0)
          origen=iniciarLista(origen,5,mapRecordTypes,'origen');
        if(horadia.size()==0)
        	horadia=iniciarLista(horadia,5,mapRecordTypes,'horadia');
        if(tipodia.size()==0)
        	tipodia=iniciarLista(tipodia,5,mapRecordTypes,'tipodia');
        if(menu.size()==0)
        	menu=iniciarLista(menu,5,mapRecordTypes,'menu');
        if(porcentaje.size()==0)
        	porcentaje=iniciarLista(porcentaje,5,mapRecordTypes,'porcentaje');
        if(reenturamiento.size()==0)
        	reenturamiento=iniciarLista(reenturamiento,5,mapRecordTypes,'reenrutamiento');
        if(prefijos.size()==0)
        	prefijos=iniciarLista(prefijos,1,mapRecordTypes,'prefijos');
        if(locuciones.size()==0)
        	locuciones=iniciarLista(locuciones,3,mapRecordTypes,'locuciones');
        if(centrorespuesta.size()==0)
        	centrorespuesta=iniciarLista(centroRespuesta,1,mapRecordTypes,'CentroRespuesta');
        if(listanegra.size()==0)
        	listanegra=iniciarLista(listanegra,1,mapRecordTypes,'listanegra');
} 

public OperacionComercial__c ConsultaOperacionComercial(string idOC)
{
	list<OperacionComercial__c> listOC = [Select id,Plan__c,Plan__r.Name,Envio_Red_Inteligente__c,CuentaCliente__c from OperacionComercial__c where id=:idOC];
	if(listOC.size()>0)
	return listOC[0];
	else
	return null;
} 
public list<DetalleConfRedInteligente__c> iniciarLista(list<DetalleConfRedInteligente__c> lista,Integer filas,map<string,RecordTypesDetConfRedInteligente__c>mapRecordTypes,string tipo)
{
	// se inicializa la lista
	lista = new list<DetalleConfRedInteligente__c>();
	RecordTypesDetConfRedInteligente__c record = mapRecordtypes.get(tipo);
	string tiporegistro = record.RecordTypeId__c;
	for(integer x=0;x<filas;x++)
	{
		//numero de filas
		DetalleConfRedInteligente__c detalle = new DetalleConfRedInteligente__c();
		detalle.RecordTypeId=tiporegistro;
		lista.add(detalle); 
	}
	return lista;
}

public Account datoscuenta(string idCuenta)
{
	list<Account> cuentas=[select Name,Tipodedocumento__c,AccountNumber,Direccion__c,Lineadecontacto__c from Account where id=:idCuenta];
	if(cuentas.size()>0)
		return cuentas[0];
	else
		return null;
}
public pageReference Guardar()
{
	// guardar o actualizar el registro 
	//primero guardar la configuraci?n
	Savepoint sp = Database.setSavepoint();
	try{
		//guarda registro de configuracion
		conf.OperacionComercial__c=OC.id;
		upsert conf;
		// se crea una gran lista recorriendo cada una de las listas de objetos
		list<DetalleConfRedInteligente__c> todosDetalles = new list<DetalleConfRedInteligente__c>();
todosDetalles.addAll(origen);
todosDetalles.addAll(horadia);
todosDetalles.addAll(tipodia);
todosDetalles.addAll(menu);
todosDetalles.addAll(porcentaje);
todosDetalles.addAll(reenturamiento);
todosDetalles.addAll(listanegra);
todosDetalles.addAll(CentroRespuesta);
todosDetalles.addAll(prefijos);
todosDetalles.addAll(locuciones);

//se recorre toda la lista y se asigna el id de la configuracion
for(DetalleConfRedInteligente__c detalle : todosDetalles)
	{
		detalle.ConfRedInteligente__c=conf.Id;

	}
	//por uno que falle fallan todos
	Database.UpsertResult[] srList=Database.upsert(todosDetalles,true);
	
	//recorrer el resultado y verificar y lanzar excepcion
	for (Database.UpsertResult sr : srList)
	{
			if(!sr.isSuccess())
			{
				//lanza excepcion para que haga el rollback.
				new MyException('error al guardar todos los datos, se hace rollback');
			}
	
	}
		
	}
	catch(System.Exception e)
	{
		Database.rollback(sp);
	}
	PageReference page = new PageReference('/'+OC.id);
	page.setRedirect(true);
	return page;
}


public pageReference Cancelar()
{
	//devolver a la operacion comercial de la pagina
	PageReference page = new PageReference('/'+OC.id);
	page.setRedirect(true);
	return page;
}

// carga los valores de la configuracion
public void CargarInfo(string idOC)
{
	//carga la configuracion y los valores
	if(idOC!=null)
	{
		list<ConfRedInteligente__c> Config = [Select c.AreaRestriccion__c , c.Activacion__c,c.Modificacion__c,c.Cancelacion__c,c.linea9__c, c.linea8__c, c.linea7__c, c.linea6__c, c.linea5__c, c.linea4__c, c.linea3__c, c.linea2__c, c.linea20__c, c.linea1__c, c.linea19__c, c.linea18__c, c.linea17__c, c.linea16__c, c.linea15__c, c.linea14__c, c.linea13__c, c.linea12__c, c.linea11__c, c.linea10__c, c.Tiempolimitellamada__c, c.TiempoMaximo__c, c.SystemModstamp, c.Suscriptor__c, c.ServicioETB__c, c.RepresentanteLegal__c,c.RepresentanteLegal__r.NumerodeIdentificacion__c,c.RepresentanteLegal__r.Phone,c.RepresentanteLegal__r.Cargo__c,c.RepresentanteLegal__r.email,c.RepresentanteLegal__r.fax, c.Reenrutamientos__c, c.PorTipoDia__c, c.PorPorcentaje__c, c.PorOrigen__c, c.PorOrigen2__c, c.PorHoraDia__c, c.PorFecha__c, c.OwnerId, c.Observaciones__c, c.NombreAnuncio__c, c.Name, c.MenusInteractivos__c, c.LocucionCostoLLamada__c, c.LastModifiedDate, c.LastModifiedById, c.IsDeleted, c.Id, c.Financiacion3Meses__c, c.Fecha__c, c.FechaInicio__c, c.FechaFinalizacion__c, c.DeTiempoLlamada__c, c.DeLlamadas__c, c.DeCreditos__c, c.CreatedDate, c.CreatedById, c.Contacto__c,c.Contacto__r.NumerodeIdentificacion__c,c.Contacto__r.Phone,c.Contacto__r.Cargo__c,c.Contacto__r.email,c.Contacto__r.fax, c.ColaLlamadas__c, c.CodigosAutenticacion__c, c.CentroRespuesta__c, c.Cantidad__c, c.AreaEnrutamiento__c, c.AnunciosPersonalizados__c,c.ServicioETB__r.SucursalDestino__c From ConfRedInteligente__c c where c.OperacionComercial__c= :idOC ];
		system.debug('Config: '+config);
		//sacar los detalles e igualar a la conf creada
		if(Config.size()>0)
		{
			//Sacar los contactos Relacionados
			
			Conf=Config[0];
			
			
			list<DetalleConfRedInteligente__c> DetConf =[Select d.restriccion1__c, d.porcentaje__c, d.limiteLLamada__c, d.Tipo__c, d.TipoDia__c, d.TiempoMaximo__c, d.Tarificable__c, d.SystemModstamp, d.Restriccion6__c, d.Restriccion5__c, d.Restriccion4__c, d.Restriccion3__c, d.Restriccion2__c, d.RecordTypeId, d.Prioritario__c, d.Pin__c, d.OwnerId, d.OtraFacilidad__c, d.Origen__c, d.Opcion__c, d.NumeroTelefonico__c, d.NumeroTelefonicoCRta__c, d.NumeroTelefonicoCRta9__c, d.NumeroTelefonicoCRta8__c, d.NumeroTelefonicoCRta7__c, d.NumeroTelefonicoCRta6__c, d.NumeroTelefonicoCRta5__c, d.NumeroTelefonicoCRta4__c, d.NumeroTelefonicoCRta3__c, d.NumeroTelefonicoCRta2__c, d.NoTarificable__c, d.Name, d.LocucionCola__c, d.ListaNegra3__c, d.ListaNegra2__c, d.ListaNegra1__c, d.LimiteLLamadasCrta__c, d.LimiteLLamadasCrta9__c, d.LimiteLLamadasCrta8__c, d.LimiteLLamadasCrta7__c, d.LimiteLLamadasCrta6__c, d.LimiteLLamadasCrta5__c, d.LimiteLLamadasCrta4__c, d.LimiteLLamadasCrta3__c, d.LimiteLLamadasCrta2__c, d.LastModifiedDate, d.LastModifiedById, d.IsDeleted, d.Id, d.HoraDia__c, d.Destino__c, d.CreatedDate, d.CreatedById, d.ContenidoLocucion__c, d.ConfRedInteligente__c, d.Cola__c, d.ColaCrta__c, d.Ciclico__c, d.CentroRTA__c, d.Cantidad__c, d.Anuncio__c From DetalleConfRedInteligente__c d where d.ConfRedInteligente__c=:Conf.id];
			//asignar los detalles a cada uno de los objetos
			AsignarDetalle(DetConf);
		}
	}
}

public Contact getRepresentanteLegal(string idcon)
{
	if(idcon!=null && idcon!='')
	{
		list<Contact> contacto = [select NumerodeIdentificacion__c,Phone,Cargo__c,email,fax from Contact where id=:idcon];
	return contacto[0];
	}
	else
	return null;
}
public void AsignarDetalle(list<DetalleConfRedInteligente__c> lstDetalles)
{
	 map<string,RecordTypesDetConfRedInteligente__c> mapRecordTypes = 	RecordTypesDetConfRedInteligente__c.getAll();
	 for(DetalleConfRedInteligente__c detalle :lstDetalles)
	 {
	 	//validar los tipos de registro y cargar 
	 	if(mapRecordTypes.get('reenrutamiento').RecordTypeid__c==detalle.RecordTypeId)
	 	{
	 		reenturamiento.add(detalle);
	 	}
	 	if(mapRecordTypes.get('origen').RecordTypeid__c==detalle.RecordTypeId)
	 	{
	 		origen.add(detalle);
	 	}
	 	if(mapRecordTypes.get('horadia').RecordTypeid__c==detalle.RecordTypeId)
	 	{
	 		horadia.add(detalle);
	 	}
	 	if(mapRecordTypes.get('tipodia').RecordTypeid__c==detalle.RecordTypeId)
	 	{
	 		tipodia.add(detalle);
	 	}
	 	if(mapRecordTypes.get('CentroRespuesta').RecordTypeid__c==detalle.RecordTypeId)
	 	{
	 		CentroRespuesta.add(detalle);
	 	}
	 	if(mapRecordTypes.get('prefijos').RecordTypeid__c==detalle.RecordTypeId)
	 	{
	 		prefijos.add(detalle);
	 	}
	 	if(mapRecordTypes.get('locuciones').RecordTypeid__c==detalle.RecordTypeId)
	 	{
	 		locuciones.add(detalle);
	 	}
	 	if(mapRecordTypes.get('menu').RecordTypeid__c==detalle.RecordTypeId)
	 	{
	 		menu.add(detalle);
	 	}
	 	if(mapRecordTypes.get('porcentaje').RecordTypeid__c==detalle.RecordTypeId)
	 	{
	 		porcentaje.add(detalle);
	 	}
	 	if(mapRecordTypes.get('listanegra').RecordTypeid__c==detalle.RecordTypeId)
	 	{
	 		listanegra.add(detalle);
	 	}
	 	
	 }
	//recorrer la lista
	
}
public pageReference AgregarCentro()
{
	//recoge el objeto de centros de respuesta.
	DetalleConfRedInteligente__c detalle = new DetalleConfRedInteligente__c();
	//asignar tipo de registro
	RecordTypesDetConfRedInteligente__c Recs = 	RecordTypesDetConfRedInteligente__c.getValues('CentroRespuesta');
	detalle.RecordTypeId=Recs.RecordTypeId__c;
	CentroRespuesta.add(detalle);
	return null;
}
//excepcion para poder ejecutarla si hay un problema con el guardado de alguno de los registros
public class MyException extends Exception{}
}