/*******************************************************************************
Desarrollado por:		Avanxo Colombia
Autor:					Hector Bayona
Proyecto:				ETB - Grupo 7 Checklist
Descripción:			Checklist para la aprobacion de la Legalización.
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0		06-11-2014	Hector Bayona (HB)		Creación de la clase
*******************************************************************************/

public class CheckList_ctr {
    
    public Legalizacion__c leg{get;set;}
    public list<OperacionComercial__c> ocLst{get;set;}
    public list<Viabilidad__c> ocViab{get;set;}
    public map<string,set<string>> viabData{get;set;}
    public Checklist__c ch{get;set;}
    private string idl=null;
    public string valortotalconiva {get;set;}
    public string valortotalcon {get;set;}
    public string totalcargofijo {get;set;}
    public string valornuevorecurrente {get;set;}
    public string incidenciaingresos {get;set;}
    public string valoranteriordatos {get;set;}
    public string valornuevonetworking {get;set;}
    public CheckList_ctr(){
    	valortotalconiva='';
    	valortotalcon='';
    	totalcargofijo='';
    	valornuevorecurrente='';
    	incidenciaingresos='';
    	valoranteriordatos='';
    	valornuevonetworking='';
        idl = ApexPages.currentPage().getParameters().get('id');
        renderPdf();
        FormatValores(leg);
    }
    
    public void renderPdf(){
        System.debug(idl);
        leg=[select id, name, Contrato__r.Account.Name,
                Contrato__r.Account.AccountNumber,
                Contrato__r.ContractNumber,
                Contrato__r.Duracion__c,
                Contrato__r.NumeroContratoSGC__c,
                Contrato__r.Contrato_Relacionado__c,
                Contrato__r.Contrato_Relacionado__r.name,
                Contrato__r.TipodecontratoETB__c,
                Contrato__r.NoModificacion__c,
                Contrato__r.ContractTerm,
                Contrato__r.Valor_Total_contrato_con_Iva__c,
                Contrato__r.ValorTotaldelcontrato__c,
                Contrato__r.Total_Cargo_fijo_Mensual_Nuevo__c,
                Contrato__r.ValorNuevoInt__c,
                Contrato__r.ValorNuevoNoRecurrente__c,
                Contrato__r.ValorNuevoSolTIAliado__c,
                Contrato__r.ValorNuevoNetworking__c,
                Contrato__r.ValorAnteriorDatos__c,
                Contrato__r.Incidencia_ingresos__c,
                Contrato__r.Forma_de_Pago__c,
                Contrato__r.Account.owner.Manager.Manager.name,
                Contrato__r.Account.owner.Manager.name,
                Contrato__r.Account.owner.name,
                Contrato__r.Account.owner.Division,
                Contacto_para_legalizacion__r.name,
                Contacto_para_legalizacion__r.Direccion__c,
                Contacto_para_legalizacion__r.Email,
                Contacto_para_legalizacion__r.Title,
                Contacto_para_legalizacion__r.Phone,
                Contacto_para_legalizacion__r.MobilePhone
                from Legalizacion__c where id=:idl];
        
        ocLst=new list<OperacionComercial__c>([select id,Name,Plan__r.NombredelProducto__r.LineaNegocio__c,
                                              
                                               (select id,Name,Aliado__c,Aliado__r.name,Tipo_de_Aliado__c,EstadoViabilidad__c
                                                from Viabilidades__r ORDER BY LastModifiedDate DESC NULLS FIRST limit 1)

                                               from OperacionComercial__c where Legalizacion__c=:idl]);
        ocViab=new list<Viabilidad__c>();
        viabData=new map<string,set<string>>();
        viabData.put('aliado',new set<string>());
        viabData.put('tipoAliado',new set<string>());
        viabData.put('lineaNegocio',new set<string>());
        viabData.put('viabilidades',new set<string>());
        
        
        
        for(OperacionComercial__c oc:ocLst){
            if(!oc.Viabilidades__r.isEmpty()){
                ocViab.addAll(oc.Viabilidades__r);
            }
            if(oc.Plan__r!=null){
                viabData.get('lineaNegocio').add(oc.Plan__r.NombredelProducto__r.LineaNegocio__c);                
            }
        }
        
        for(Viabilidad__c vi: ocViab){
            viabData.get('aliado').add(vi.Aliado__r.Name);
            viabData.get('tipoAliado').add(vi.Tipo_de_Aliado__c);
            viabData.get('viabilidades').add(vi.name);
        }
        
    }
    
    public string getViab(){
    
    	return convertirString('viabilidades');
    }
    
    public string getLineaNeg(){
        
        return convertirString('lineaNegocio');
    }
    
    public string getAliado(){
        
        return convertirString('aliado');
    }
    
    public string getTipoAliado(){
        
        return convertirString('tipoAliado');
    }
    
   public string convertirString(string campo){
            string data='';
            
            for(string s:viabData.get(campo)){
                if(s!=null){
                    data+=s+',';
                    system.debug(campo+' '+s);
                }
            }
       data=data.removeEnd(',');
                        
       return data;
   }
    
    public Component.Apex.pageBlockSection getCheckLeg(){
        
        Schema.DescribeSObjectResult r = Checklist__c.sObjectType.getDescribe();
        string campos='';
        map<string,string> cChecks=new map<string,string>();
        
        map<string,string> cText=new map<string,string>();
        
      	Map<String, Schema.SObjectField> fieldMap = r.fields.getmap();
		//for(SObjectField  campo : fieldMap.values()){ //fieldMap.get(campo)
		for(string  campo : fieldMap.keySet()){
			Schema.DescribeFieldResult fd = fieldMap.get(campo).getDescribe();
			if(fd.isCreateable() && fd.isCustom()){
				campos+=campo+',';
				
				if(fd.type==Schema.DisplayType.Reference){
					string ref=campo+'';
					ref=ref.removeEnd('__c')+'__r';
					campos+=ref+'.Name,';				
				}
				
                if(fd.type==Schema.DisplayType.BOOLEAN){
                   cChecks.put(fd.getName(), fd.getLabel().toUpperCase());                 
                }
                if(fd.type==Schema.DisplayType.String && !fd.getName().startsWith('NO_')){
                	cText.put(fd.getName(), fd.getLabel().toUpperCase());                 
                }
			}
		}
		
		campos+='NO_gestor_ing_TI__c,NO_Contacto_para_legalizacion__r.Direccion__c,NO_Contacto_para_legalizacion__r.Email,NO_Contacto_para_legalizacion__r.Title,NO_Contacto_para_legalizacion__r.Phone,NO_Contacto_para_legalizacion__r.MobilePhone ';
		
		System.debug('Select '+campos+' from Checklist__c where id=:idl');
        
        ch=Database.query('Select '+campos.removeEnd(',')+' from Checklist__c where NO_Legalizacion__c=:idl limit 1');
        
        Component.Apex.pageBlockSection ab=new Component.Apex.pageBlockSection();
        ab.columns=3;
        
        
        
        if(ch!=null){
        	system.debug('\nCampos: '+cChecks.keySet()+'');
        	
        	map<string,componente> comp=new map<string,componente>();
        	
	        for(string c:cChecks.keySet()){
	            //ab.childComponents.add(getCreateCheck(c,cChecks.get(c),(Boolean)ch.get(c)));
	            comp.put(c,new componente((object)ch.get(c),cChecks.get(c),'check'));
	        }
	        
	        for(string c:cText.keySet()){
	            //ab.childComponents.add(getCreateText(c,cText.get(c),(String)ch.get(c)));
	            comp.put(c,new componente((object)ch.get(c),cText.get(c),'text'));
	        }
	        
	        list<string> orden=new list<string>(comp.keySet());
	        orden.sort();
	        
	        for(string sf:orden){
	        	ab.childComponents.add(comp.get(sf).getComponent());	        
	        }
	        
	        
	        
        }
        
        system.debug(ab);
        
        return ab;
    }
    
    /*
    public Component.Apex.pageBlockSectionItem getCreateText(string campo,string label, string valor){
        if(valor==null){
            valor='';
        }
        
        Component.Apex.pageBlockSectionItem pbs=new Component.Apex.pageBlockSectionItem();
        Component.Apex.OutputText ol= new Component.Apex.OutputText();
        ol.value=label.toUpperCase() +': '+valor.toUpperCase();
        pbs.childComponents.add(ol);
        
        
        return pbs;
        
    }
    */
    
    /*
    public Component.Apex.pageBlockSectionItem getCreateCheck(string campo,string label, boolean valor){
        
        Component.Apex.pageBlockSectionItem pbs=new Component.Apex.pageBlockSectionItem();
        
        Component.Apex.image chkBox = new Component.Apex.image();
        
        if(valor){
        	chkBox.expressions.value='{!URLFOR($Resource.img, "checkTrue.png")}';
        }else{
            chkBox.expressions.value='{!URLFOR($Resource.img, "checkFalse.png")}';
        }
        
        
        Component.Apex.OutputText ol= new Component.Apex.OutputText();
        ol.value=label;
        
        pbs.childComponents.add(ol);
        pbs.childComponents.add(chkBox);
        
        
        return pbs;
        
    }
    */
    
    // funcion que llama el objeto del checklist y convierte los valores a string
    public void FormatValores(Legalizacion__c leg)
    {
    	
    		valortotalconiva=formatCurrency(leg.Contrato__r.Valor_Total_contrato_con_Iva__c);
    		valortotalcon=formatCurrency(leg.Contrato__r.ValorTotaldelcontrato__c);
    		totalcargofijo=formatCurrency(leg.Contrato__r.Total_Cargo_fijo_Mensual_Nuevo__c);
    		valornuevorecurrente=formatCurrency(leg.Contrato__r.ValorNuevoNoRecurrente__c);
    		incidenciaingresos=formatCurrency(leg.Contrato__r.Incidencia_ingresos__c);
    		valoranteriordatos=formatCurrency(leg.Contrato__r.ValorAnteriorDatos__c);
    		valornuevonetworking=formatCurrency(leg.Contrato__r.ValorNuevoNetworking__c);
    }
    
    private String formatCurrency(Decimal i) {
    if (i == null) return '0.00';
    i = Decimal.valueOf(Math.roundToLong(i * 100)) / 100;
    String s = (i.setScale(2) + (i >= 0 ? 0.001 : -0.001)).format();
    return s.substring(0, s.length() - 1);
}
    public class componente{
    	public object valor;
    	public string etiqueta;
    	public string tipo;
    	
    	public componente(object valor,string etiqueta,string tipo){
    		this.valor=valor;
    		this.etiqueta=etiqueta;
    		this.tipo=tipo;
    	}
    	
    	public Component.Apex.pageBlockSectionItem getComponent(){
    		
    		Component.Apex.pageBlockSectionItem pbs=new Component.Apex.pageBlockSectionItem();
    		if(tipo=='check'){    			
		    	
		    	Component.Apex.image chkBox = new Component.Apex.image();
		        if(Boolean.valueOf(valor)){
		        	chkBox.expressions.value='{!URLFOR($Resource.img, "checkTrue.png")}';
		        }else{
		            chkBox.expressions.value='{!URLFOR($Resource.img, "checkFalse.png")}';
		        }
		        Component.Apex.OutputText ol= new Component.Apex.OutputText();
		        ol.value=etiqueta;
		        pbs.childComponents.add(ol);
		        pbs.childComponents.add(chkBox);
    		}else if(tipo=='text'){
    			
    			string valorS='';
    			
    			if(valor==null){

		        }else{
		        	valorS=String.valueOf(valor);		        
		        }
		        Component.Apex.OutputText ol= new Component.Apex.OutputText();
		        ol.value=etiqueta+': '+valorS.toUpperCase();
		        pbs.childComponents.add(ol);
    		
    		
    		}
    		
    		
	   		return pbs;
    	
    	}
    	
    		    
    
    }
    

}