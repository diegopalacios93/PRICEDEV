Public class RetiroLD_ctr{

	public id idCuenta;
	public id topp;
	public id oc;
	public TOPP__c toppr{get;set;}



	public RetiroLD_ctr(){

		idCuenta=ApexPages.currentPage().getParameters().get('id');
		topp=ApexPages.currentPage().getParameters().get('topp');
		oc=ApexPages.currentPage().getParameters().get('newid');
		toppr=planToop(topp);


	}

	public String getConf(){

		Map<String,String> conf=new Map<String,String>();
		conf.put('cuenta',idCuenta);
		conf.put('topp',topp);
		conf.put('oc',oc);
		
		system.debug(toppr);
		system.debug(toppr.TipodeOperacionporplan__c);
		if(toppr.TipodeOperacionporplan__c=='Retiro Lineas de LD'){
			conf.put('t','True');
		}
		else if(toppr.TipodeOperacionporplan__c=='Retiro'){
			conf.put('t','False');
		}

		return JSON.serialize(conf);
	}

	public static TOPP__c planToop(id t){

		Set<string>planes=new Set<string>{'Convenio de voz','Convenio de cupo'};
		Set<string>operaciones=new Set<string>{'Retiro Lineas de LD','Retiro'};


		List<TOPP__c> tipoDeOperacion = new List<TOPP__c>([Select id,name,Plan__c,TipodeOperacionporplan__c from TOPP__c 
			where Plan__r.NombredelProducto__r.Name IN :planes and TipodeOperacionporplan__c IN :operaciones and Id=:t]);

		return (tipoDeOperacion.isEmpty()? new TOPP__c():tipoDeOperacion[0]);

	}


	public String getLineas(){


		OperacionComercial__c oper=obtenerOC(oc);
		
		List<Linea__c> Lineas=obtenerLineas(oper.Activo__c);

		Map<String,List<lineaJson>> lasLineas=new Map<String,List<lineaJson>>();

		lasLineas.put('correcto',New List<lineaJson>());
		lasLineas.put('conErrores',New List<lineaJson>());

		integer i=0;

		Set<String> validas =new Set<String>{'Activa','Declinada'};

		for(Linea__c l :Lineas){
			
			if(l.Operacion_Comercial_Actual__c==null || validas.contains(l.Operacion_Comercial_Actual__r.Estado__c)){
				lasLineas.get('correcto').add(new lineaJson(l,False,'form'+i,''));
			}else{
				lasLineas.get('conErrores').add(new lineaJson(l,False,'form'+i,''));
			}
			i++;
		}



		return JSON.serialize(lasLineas);

	}

	public static List<Linea__c> obtenerLineas(id act){


		return new List<Linea__c>([select Id,Codigo_de_linea__c,Linea_ETB__c,Name,Cuenta_suscriptora__r.name,Cuenta_suscriptora__c,Tipo__c,Activo__c,Activo__r.NombredelaCuenta__c,ActivoLargaDistancia__r.Name,ActivoLargaDistancia__r.Estado__c,Operacion_Comercial_Actual__c,Operacion_Comercial_Actual__r.Estado__c,Operacion_Comercial_Actual__r.Name from Linea__c where ActivoLargaDistancia__c =:act]);

	}

	public static OperacionComercial__c obtenerOC(Id oc){

		List<OperacionComercial__c> ocr= new List<OperacionComercial__c>([select id,name,Activo__c from OperacionComercial__c where id =:oc]);

		return ocr[0];

	}

	@RemoteAction
	public static string guardarLineas(string lineasParaGuardar,string conf){
		system.debug(lineasParaGuardar);
		system.debug(conf);

		List<lineaJson> data =(List<lineaJson>)JSON.deserialize(lineasParaGuardar, List<lineaJson>.class);
		//conf=conf.Replace('{','{"').Replace('}','"}').replaceAll(', ','","').replaceAll('=','":"');
		//system.debug(conf);
		Map<string,string> configuracion =(Map<string,string>)JSON.deserialize(conf, Map<string,string>.class);
		system.debug(data);

		List<Linea__c> paraActualizar =new List<Linea__c>();



		for(lineaJson lj:data){

			if(configuracion.get('t')!='True' || lj.existe==true){
			lj.Linea.Operacion_Comercial_Anterior__c=lj.Linea.Operacion_Comercial_Actual__c;
			lj.Linea.Operacion_Comercial_Actual__c=configuracion.get('oc');
			paraActualizar.add(lj.Linea);
			}

		}

		Database.UpsertResult[] results = Database.upsert(paraActualizar, Schema.Linea__c.Codigo_de_linea__c, true);

		respuestalineaJson rj=new respuestalineaJson();
		integer it=0;
		boolean hasError=false;

		
		for (Database.UpsertResult r : results) {
			if (r.isSuccess()) {
				rj.lineas.get('correcto').add(new lineaJson(paraActualizar[it],true,'form'+it,''));
			}
			else{
				rj.lineas.get('conErrores').add(new lineaJson(paraActualizar[it],true,'form'+it,r.getErrors()+''));
				hasError=true;
			}
			it++;
		}
		rj.datos.put('hasError','False');
		rj.datos.put('Redirect',configuracion.get('oc'));

		if(hasError){
			rj.datos.put('hasError','True');
		}




		return JSON.serialize(rj);
	}

	public class respuestalineaJson{
		public Map<string,List<lineaJson>> lineas=New Map<string,List<lineaJson>>();
		public Map<string,string> datos=New Map<string,string>();

		public respuestalineaJson(){
			
			this.Lineas.put('correcto',New List<lineaJson>());
			this.Lineas.put('conErrores',New List<lineaJson>());
		}
	}




	public class lineaJson{
		public Linea__c Linea;
		public boolean existe;
        public String nameF;
        public boolean error;
        public String status;
		
		public lineaJson(Linea__c Linea,Boolean existe,String nameF,String status){
			this.Linea=Linea;
			this.existe=existe;
			this.nameF=nameF;
			this.status=status;
			this.error=false;
		}
	}



}