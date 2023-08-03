public with sharing class Filtro_cls {


	private static Map<String,Schema.SObjectType> gd;  
	private static Map<String, String> keyPrefixMap;  
	private static Set<String> keyPrefixSet;

	private string query='';
	private Integer limite=40000;
	private string f='';
	private list<string> campos=new list<string>();

	public list<Sobject> info{get;set;}
	public string labelObj{get;set;}
	public string abuscar{get;set;}
	public string infoParam{get;set;}
	public list<string> columna=new list<string>();
	


	private static void init() {  
		gd = Schema.getGlobalDescribe();  

		keyPrefixMap = new Map<String, String>{};  

		keyPrefixSet = gd.keySet();  

		for(String sObj : keyPrefixSet)  
		{  
			Schema.DescribeSObjectResult r =  gd.get(sObj).getDescribe();  
			String tempName = r.getName();  
			String tempPrefix = r.getKeyPrefix();  
			keyPrefixMap.put(tempPrefix, tempName);  
		}  
	}

	public Filtro_cls(){

		try{
//Identificador del objeto
			string obj=ApexPages.currentPage().getParameters().get('id');
//Consulta codificada
			string c=ApexPages.currentPage().getParameters().get('c');
//Campos Codificados
			f=ApexPages.currentPage().getParameters().get('f');
			
			string nomCol=ApexPages.currentPage().getParameters().get('nom');
			system.debug(nomCol);
			
			infoParam=ApexPages.currentPage().getParameters().get('infoParam');

			c=decodificar(c);
			f=decodificar(f);
			
			
			if(nomCol!='' && nomCol!=null){
				columna=decodificar(nomCol).split(',');
				system.debug(columna);			
			}

			string objeto=GetKeyPrefix(obj);

			labelObj=gd.get(objeto).getDescribe().getLabel();

			query='Select id'+f+' From '+objeto+' '+c;
			System.debug(query);

			info=Database.query(query+' Limit 100');

		}catch(exception e){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
		}


	}


	public static String GetKeyPrefix(String ObjId)  
	{  
		init() ;  
		String tPrefix = ObjId;  
		tPrefix = tPrefix.subString(0,3);  

		String objectType = keyPrefixMap.get(tPrefix);  
		return objectType;  
	}

	public static string codificar (string condicion){
		Blob beforeblob = Blob.valueOf(condicion);
		string paramvalue = EncodingUtil.base64Encode(beforeblob);	

		return paramvalue;
	}


	public static string decodificar (string condicion){
		Blob afterblob = EncodingUtil.base64Decode(condicion);

		return afterblob.toString();
	}

	public Pagereference buscar(){
		
		

		if(abuscar!=null && abuscar!=''){
			system.debug(query+qLikeM());
			info=Database.query(query+qLikeM()+' Limit 100');
		}else{
			Database.query(query+' Limit 100');	
		}
		return null;
	}

	public Component.Apex.pageBlockTable getDynamicTable() {
		Component.Apex.pageBlockTable pTable = new Component.Apex.pageBlockTable();
		pTable.expressions.value='{!info}';
		pTable.first=0;
		pTable.rows=500;
		pTable.var='item';

		string camposD=f.removeStart(',');


		campos=camposD.split(',');
		integer Icol=0;

		for(string cf:campos){
			
			Component.Apex.column pColumna = new Component.Apex.column();
			string nombreColumna='';
			
			system.debug(columna.isEmpty()+' '+Icol+' '+columna.size());
			if(!columna.isEmpty() && Icol<columna.size()){
				nombreColumna=columna[Icol];
				system.debug(nombreColumna);
			}
			
			pColumna.headerValue=nombreColumna;
			
			
			Component.Apex.outputLink pLink = new Component.Apex.outputLink();
			pLink.value='#';
			pLink.expressions.rel='{!item[\'id\']}';
			pLink.expressions.title='{!item[\''+cf+'\']}';
			pLink.onclick='cerrarA(this)';
			
			Component.Apex.outputField out = new Component.Apex.outputField();
			out.Expressions.value='{!item[\''+cf+'\']}';
			
			pLink.childComponents.add(out);

			pColumna.childComponents.add(pLink);

			pTable.childComponents.add(pColumna);
			Icol++;
		}

		return pTable;
	}

	private string qLikeM(){

		string qlike='';

		for (string fc:campos) {
			qlike+=' or '+fc+' Like \'%'+abuscar+'%\'';

		}

		if(!query.containsIgnoreCase(' where ')){
			qLike=qLike.removeStart(' or');
			qLike=' where '+ qLike;
		}else{
			qLike=qLike.removeStart(' or');
			qLike=' and ('+qLike+')';
		}


		return qLike;

	}




}