public class Vista_Cliente_ctr{

	public boolean continuar{get;set;}
	public boolean mostrar{get;set;}
	public Account cliente{get;set;}
	public Manejo_de_ofertas__c ingr{get;set;}
	public boolean caip{get;set;}
	public boolean local{get;set;}
	public boolean ld{get;set;}
    public Oferta__c ofC {get;set;}
    public boolean mostrarGuardar {get;set;}
    public Account elCliente {get;set;}
    //public Opportunity op {get;set;}
    public map<string,string> conDecimal{get;set;}
    
    public void definirDecimal(){
        conDecimal=new  map<string,string>();
        string simbolo='$';

        conDecimal.put('Ingresos_de_Internet_Dedicado__c',simbolo+LibreriaUtilitaria_cls.formatCurrency(ingr.Ingresos_de_Internet_Dedicado__c));
       	conDecimal.put('Ingresos_de_CAIP__c',simbolo+LibreriaUtilitaria_cls.formatCurrency(ingr.Ingresos_de_CAIP__c));
        

        conDecimal.put('Ingresos_de_CAIP_e_INTERNET_DEDICADO_ETB',simbolo+LibreriaUtilitaria_cls.formatCurrency(ingr.Ingresos_de_CAIP_e_INTERNET_DEDICADO_ETB__c));
        conDecimal.put('Facturacion_actual_LD_Nacional_mes',simbolo+LibreriaUtilitaria_cls.formatCurrency(ingr.Facturacion_actual_LD_Nacional_mes__c));
		conDecimal.put('Facturacion_actual_Valor_unico_mes',simbolo+LibreriaUtilitaria_cls.formatCurrency(ingr.Facturacion_actual_Valor_unico_mes__c));
		conDecimal.put('Facturacion_actual_LD_Internacional_mes',simbolo+LibreriaUtilitaria_cls.formatCurrency(ingr.Facturacion_actual_LD_Internacional_mes__c));
		conDecimal.put('Facturacion_actual_RI_mes',simbolo+LibreriaUtilitaria_cls.formatCurrency(ingr.Facturacion_actual_RI_mes__c));
		conDecimal.put('Total_LD_y_RI',simbolo+LibreriaUtilitaria_cls.formatCurrency(ingr.Total_LD_y_RI__c));
		conDecimal.put('Rentabilidad_LD_y_RI',simbolo+LibreriaUtilitaria_cls.formatCurrency(ingr.Rentabilidad_LD_y_RI__c));

		conDecimal.put('Facturacion_actual_enlaces_de_voz_mes',simbolo+LibreriaUtilitaria_cls.formatCurrency(ingr.Facturacion_actual_enlaces_de_voz_mes__c));
		conDecimal.put('Rentabilidad_actual_enlaces_de_voz',simbolo+LibreriaUtilitaria_cls.formatCurrency(ingr.Rentabilidad_actual_enlaces_de_voz__c));


        conDecimal.put('G1_LD__c',LibreriaUtilitaria_cls.formatCurrency(ingr.G1_LD__c));
		conDecimal.put('G118000__c',LibreriaUtilitaria_cls.formatCurrency(ingr.G118000__c));
		conDecimal.put('G2_LD__c',LibreriaUtilitaria_cls.formatCurrency(ingr.G2_LD__c));
		conDecimal.put('G218000__c',LibreriaUtilitaria_cls.formatCurrency(ingr.G218000__c));
		conDecimal.put('G3_LD__c',LibreriaUtilitaria_cls.formatCurrency(ingr.G3_LD__c));
		conDecimal.put('G318000__c',LibreriaUtilitaria_cls.formatCurrency(ingr.G318000__c));
        
    }

	public Attachment attachment {
	get {
		if (attachment == null)
			attachment = new Attachment();
		return attachment;
    }
  	set;
	}

	public Vista_Cliente_ctr(){
		mostrarGuardar=false;
		ld=local=caip=mostrar=continuar=false;

		ofC=new Oferta__c();
		

		string id = ApexPages.currentPage().getParameters().get('id');
		//string ido = ApexPages.currentPage().getParameters().get('ido');

		//op=new Opportunity(id=ido);

		List<Account> clientes=new List<Account>([Select Id,Name,ValordeCliente__c,AccountNumber,Segmento__c,SubSegmento__c,OwnerId,Actividad_Economica__c From Account where AccountNumber=:id and RecordType.Name='Cliente Principal' and AccountNumber!=null]);


		system.debug(clientes);
        
        /*
        if(ofertasPendientes()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Existe ofertas En curso o aprobadas')); 
            return;
        }
        */
        

		if(clientes.isEmpty()){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'No se encontro informacion del cliente'));
		}else if(clientes.size()!=1){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Este cliente no se puede procesar'));
		}else{
			elCliente=clientes[0];

system.debug(clientes[0].id+' '+clientes[0].OwnerId+' '+UserInfo.getUserId());

Perfiles_Acciones__c perOf = Perfiles_Acciones__c.getValues('accesoVistaCliente');
set<string> acceso=new set<string>(perOf.Usuarios__c.split(','));

			if(clientes[0].OwnerId==UserInfo.getUserId() || acceso.contains(UserInfo.getProfileId())){
				cliente=clientes[0];
				ingr=obtenerIngresos();
				if(ingr!=null){
					definirDecimal();
					mostrar=true;
				}else{
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'No se encontro informacion de ingresos'));
				}
			}else{
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'No es propietario de este cliente'));
			}
		}


	}
    
    /*
	public boolean ofertasPendientes(){

		integer hasOfert=[Select Count() from Oferta__c where Estado__c!='Rechazada' and oportunidad__c=:op.id];
        system.debug(hasOfert);

		return (hasOfert==0?false:true);
	}
	*/

	public PageReference Ver(){
		mostrarGuardar=true;

		return null;
	}

	public PageReference Guardar(){


		ofC.Ingresos_de_CAIP_e_INTERNET_DEDICADO_ETB__c=ingr.Ingresos_de_CAIP_e_INTERNET_DEDICADO_ETB__c;
		ofC.Facturacion_actual_LD_Nacional_mes__c=ingr.Facturacion_actual_LD_Nacional_mes__c;
		ofC.Facturacion_actual_Valor_unico_mes__c=ingr.Facturacion_actual_Valor_unico_mes__c;
		ofC.Facturacion_actual_LD_Internacional_mes__c=ingr.Facturacion_actual_LD_Internacional_mes__c;
		ofC.Facturacion_actual_RI_mes__c=ingr.Facturacion_actual_RI_mes__c;
		ofC.Total_LD_y_RI__c=ingr.Total_LD_y_RI__c;
		ofC.Rentabilidad_LD_y_RI__c=ingr.Rentabilidad_LD_y_RI__c;


		ofC.Ingresos_de_Internet_Dedicado__c=ingr.Ingresos_de_Internet_Dedicado__c;
		ofC.Ingresos_de_CAIP__c=ingr.Ingresos_de_CAIP__c;

		ofC.G1_LD__c=ingr.G1_LD__c;
		ofC.G118000__c=ingr.G118000__c;
		ofC.G2_LD__c=ingr.G2_LD__c;
		ofC.G218000__c=ingr.G218000__c;
		ofC.G3_LD__c=ingr.G3_LD__c;
		ofC.G318000__c=ingr.G318000__c;
		ofc.Cuenta__c=elCliente.id;

		ofC.Periodo_Inicio__c=ingr.Periodo_Inicio__c;
		ofC.Periodo_Fin__c=ingr.Periodo_Fin__c;

		ofC.Facturacion_actual_enlaces_de_voz_mes__c=ingr.Facturacion_actual_enlaces_de_voz_mes__c;
		ofC.E1__c=ingr.E1__c;
		ofC.E1PABX__c=ingr.E1PABX__c;
		ofC.Rentabilidad_actual_enlaces_de_voz__c=ingr.Rentabilidad_actual_enlaces_de_voz__c;
		ofC.Asesor__c=UserInfo.getUserId();

		ofC.LD__c=ld;
		ofC.Caip__c=caip;
		//ofC.Oportunidad__c=op.id;

		ofC.RA_Larga_Distancia_y_Red_Inteligente__c=ingr.Rentabilidad_LD_y_RI__c;
		ofC.RA_Enlaces_de_voz__c=ingr.Rentabilidad_actual_enlaces_de_voz__c;
		
			// se añaden los nuevos campos de información.
		
		ofC.Maximotrimestreanoactual__c=ingr.Maximotrimestreanoactual__c;
		ofC.Maximotrimestreanoanterior__c=ingr.Maximotrimestreanoanterior__c;
		ofC.Minimotrimestreanoactual__c=ingr.Minimotrimestreanoactual__c;
		ofC.Minimotrimestreanoanterior__c=ingr.Minimotrimestreanoanterior__c;
		ofC.Promediotrimestreanoactual__c=ingr.Promediotrimestreanoactual__c;
		ofC.Promediotrimestreanoanterior__c=ingr.Promediotrimestreanoanterior__c;
		ofC.Variacionestrimestreanoanterioract__c=ingr.Variacionestrimestreanoanterioract__c;
		
		ofC.PeridoanoAnterior__c=ingr.PeridoanoAnterior__c;
		ofC.Peridoanoactual__c=ingr.Peridoanoactual__c;

		//if(caip){
			//apruebaGerenteDeSegmento(ofC);
		//}



		ofC.Local__c=local;

        /*
		if(attachment.Body==null){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Por favor adjuntar el configurador'));
			return null;
		}
*/


		
		try{
			insert ofC;

			//if(!caip){
			//apuebaDirector(ofC);
			//}
			
			/*
			if(attachment.Body != null){
				attachment.OwnerId = UserInfo.getUserId();
		    	attachment.ParentId = ofC.id; // the record the file is attached to
		    	insert attachment;
	    	}
	    	*/

			PageReference p =new PageReference('/'+ofC.id);
			p.setRedirect(true);
			return p;
		}
		catch(exception e){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getmessage()));
		}


		return null;
	}

	/*
	public void apruebaGerenteDeSegmento(Oferta__c ofd){

		Perfiles_Acciones__c perOf = Perfiles_Acciones__c.getValues('Oferta_Gerente_de_Segmento');
		ofd.OwnerId=perOf.Usuarios__c;
		ofd.Estado__c='Enviado a Gerente de Segmento';
	}

	public static void apuebaDirector(Oferta__c ofd){

		Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('Presentado para su aprobación.');
        req.setObjectId(ofd.Id);
        Approval.ProcessResult result = Approval.process(req);


		
	}
	*/

	public PageReference Aceptar(){
		continuar=true;


		return null;
	}


	public Manejo_de_ofertas__c obtenerIngresos(){

			list<Manejo_de_ofertas__c> ingresos=new list<Manejo_de_ofertas__c>([SELECT  Alianzas__c,Arrendamiento_de_Equipos__c,Arrendamiento_de_Infraestructura__c,Banda_Ancha_Fibra__c,Banda_Ancha__c,Centrex__c,Cobro_Revertido_Automatico__c,Colaborador__c,Conectividad__c,CreatedById,CreatedDate,Data_Center__c,DirectorioTelefonico__c,E1PABX__c,E1__c,Facturacion_actual_enlaces_de_voz_mes__c,Facturacion_actual_LD_Internacional_mes__c,Facturacion_actual_LD_Nacional_mes__c,Facturacion_actual_RI_mes__c,Facturacion_actual_Valor_unico_mes__c,G1_LD__c,G2_LD__c,G3_LD__c,G118000__c,G218000__c,G318000__c,Id,Ingresos_de_CAIP_e_INTERNET_DEDICADO_ETB__c,Interconexion__c,Internet_Dedicado__c,Internet_Movil__c,IsDeleted,Larga_Distancia_Internacional_Entrante__c,Larga_Distancia_Internacional__c,Larga_Distancia_Nacional__c,Larga_Distancia_Valor_Unico__c,LastModifiedById,LastModifiedDate,Linea_Telefonica_Fibra__c,Linea_Telefonica__c,Meses__c,Mezcla_de_Productos__c,Mezcla_Tacticos__c,Name,Networking__c,Numero_de_Identificacion__c,Otros_Productos_Datos__c,Otros_Productos_Internet__c,Otros_Productos_Larga_Distancia__c,Otros_Productos_Local__c,OwnerId,Periodo_Fin__c,Periodo_Inicio__c,Portador_Capacidad_Transporte__c,Portador__c,Productivizacion__c,RDSI_Basico__c,RDSI_Primario__c,RDSI_PRI__c,Red_de_Victimas__c,Rentabilidad_actual_enlaces_de_voz__c,Rentabilidad_LD_y_RI__c,Reventa_Equipos__c,Semaforizacion__c,Servicios_de_facturacion__c,Servicios_Linea_Telefonica__c,Sin_Producto__c,SystemModstamp,Tarjeta_Internacional__c,Television__c,Total_Cliente__c,Total_Datos__c,Total_Internet__c,Total_Larga_Distancia__c,Total_LD_y_RI__c,Total_Local__c,Total_Negocios_Especiales__c,Total_Sin_Linea__c,Total_Television__c,
			TUN_Total_G1__c,TUN_Diferenciado_G1__c,TUN_Total_G118000__c,TUN_Diferenciado_G118000__c,TUN_Diferenciado_G3__c,TUN_Diferenciado_G318000__c,
			Ingresos_de_Internet_Dedicado__c,Ingresos_de_CAIP__c,Maximotrimestreanoactual__c,Maximotrimestreanoanterior__c,Minimotrimestreanoactual__c,Minimotrimestreanoanterior__c,Promediotrimestreanoactual__c,Promediotrimestreanoanterior__c,Variacionestrimestreanoanterioract__c,PeridoanoAnterior__c,Peridoanoactual__c
			FROM Manejo_de_ofertas__c
			where Numero_de_Identificacion__c=:cliente.AccountNumber and Numero_de_Identificacion__c!=null Limit 1]);
	
	return (ingresos.size()==1?ingresos[0]:null);
	}
    
    
}