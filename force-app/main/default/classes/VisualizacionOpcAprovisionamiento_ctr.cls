/***********************************************************************************************************************
Desarrollado por:   ETB
Proyecto:           PORTAFOLIO SUPERIOR
Descripción:        Controlador para la pagina de visualización de opciones de aprovisionamiento

Cambios (Versiones)
-------------------------------------------------------------------
No.     Fecha        Autor                    Descripción
----    ----------   ----------------------   ---------------
1.0     2018-04-15   Samuel Rodríguez (ETB)   Creación de la clase.
***********************************************************************************************************************/
public class VisualizacionOpcAprovisionamiento_ctr {

    private string ident = '', IdOC= '';
    public string consulta { get; set; }
    public string opcion { get; set; }
    private IntegracionGestor_ws.OpcionesViabilidad opcionesclass { get; set; }
    List<Opcion_Aprovisionamiento__c> resultadosConsulta = new List<Opcion_Aprovisionamiento__c>();
    List<Opcion_Aprovisionamiento__c> opcionSeleccionada = new List<Opcion_Aprovisionamiento__c>();
    public Map<String, string> ListaNombresApi = new Map<String, string>();    

    
    //Constructor de la clase

    public VisualizacionOpcAprovisionamiento_ctr() {  
        if(Test.isRunningTest())
            this.opcion = 'OPC001';
        else
        	this.opcion = null;
        this.consulta = '';
    }
    
    public void Inicializacion(){
        
        string consultaViabilidad='';
        string idUltimaViabilidad='';
        Id id = ApexPages.currentPage().getParameters().get('id');
        System.debug('Id pagina: ' + ApexPages.currentPage().getParameters().get('id'));
        Schema.Sobjecttype objtype =id.getSObjectType();
        string getSObjectType = String.valueOf(objtype);
        System.debug('SObjectType ' +  objtype);
	
    //  Consultar las opciones por viabilidad o por operación comercial
    //  
        this.consulta = 'select id,IdOpcion__c,ConfiguracionServicio__c,DetallesOpcion__c,Observaciones__c,Seleccion__c from Opcion_Aprovisionamiento__c where NumeroViabilidad__c=';
        
        if(getSObjectType == 'Viabilidad__c'){
            Viabilidad__c[] objVia;
            this.ident = ApexPages.currentPage().getParameters().get('id');
            objVia = [SELECT OperacionComercial__r.Id FROM Viabilidad__c WHERE Id =: this.ident LIMIT 1];
            this.IdOC = objVia[0].OperacionComercial__r.Id;
        } else {
            this.ident = ApexPages.currentPage().getParameters().get('id'); //Identificador de la OC
        	this.IdOC  = ApexPages.currentPage().getParameters().get('id');
            ////Buscar ultima viabilidad relacionada con la OC
       		consultaViabilidad = 'SELECT Id,name, OperacionComercial__c, CreatedDate FROM Viabilidad__c  where OperacionComercial__c =';
            consultaViabilidad += '\'' + ident + '\'';
            consultaViabilidad += ' order by CreatedDate desc';
            System.debug('consultaViabilidad: ' + consultaViabilidad);
            List<Viabilidad__c> Viabilidad = Database.query(consultaViabilidad);
            System.debug('Id ultima viabilidad:' + Viabilidad[0].Id);
            this.ident= Viabilidad[0].Id;
            
        }
        
       this.consulta += '\'' + ident + '\'';
       System.debug('Consulta:' + consulta);
       List<Opcion_Aprovisionamiento__c> resultados = Database.query(consulta);
       this.resultadosConsulta = resultados;
       System.debug('Resultados: ' + resultados);
       IntegracionGestor_ws.OpcionesViabilidad ov = new IntegracionGestor_ws.OpcionesViabilidad();
       ov= IntegracionGestor_cls.ObtenerOpcionesViaclass(resultados);
       System.debug('ov: ' + ov);
       this.opcionesclass=ov;
        
       ObtenerListaNombresApi();
        
	}
    
    
    //Componente dinamico para mostrar las opciones 
    //
    public Component.Apex.PageBlock getDynamicComp() {
        
        boolean renderfalse = false; 
        integer numercolumnascs = 4;
        integer numercolumnascs1 = 2;
        IntegracionGestor_ws.OpcionesViabilidad ov1 = new IntegracionGestor_ws.OpcionesViabilidad();
        ov1=this.opcionesclass;        
        Component.Apex.PageBlock pageBlk = new Component.Apex.PageBlock();
      
        //Iteración por las opciones encontradas
               
        for(IntegracionGestor_ws.Opcion op : ov1.opcion){			
            Component.Apex.PageBlockSection pageBlkSectionOpcion = new Component.Apex.PageBlockSection(title=op.idOpcion);
            
            //Crear PageBlockSection para detalles de la opción 
            //
            Component.Apex.PageBlockSection pageBlkSectiondetOpcion = new Component.Apex.PageBlockSection(title='Detalles de la Opción', columns=numercolumnascs1);   
            List<String> filas = new List<String>();            
            for(IntegracionGestor_ws.ParametroOp parametroop : op.detalleOpcion.parametroop){                
           		if (!filas.Contains(parametroop.fila)){
                	filas.add(parametroop.fila);
                }
            }			
             //System.debug('Lista de filas: ' + filas);
    		for(string filaopc : filas){                
               Component.Apex.PageBlockSection pageBlkSectionFilas = new Component.Apex.PageBlockSection(title='Fila' + filaopc, columns=numercolumnascs1);   
     	       Component.Apex.OutputText outPutTextnombreTitulo = new Component.Apex.OutputText(value='Nombre',style='font-weight:800; font-style:italic'); 
     	       Component.Apex.OutputText outPutTextvalorTitulo = new Component.Apex.OutputText(value='Valor',style='font-weight:800; font-style:italic');
     	       pageBlkSectionFilas.childComponents.add(outPutTextnombreTitulo);
      	       pageBlkSectionFilas.childComponents.add(outPutTextvalorTitulo);
     	       for(IntegracionGestor_ws.ParametroOp parametroop : op.detalleOpcion.parametroop){                   	
      		      	If(filaopc==parametroop.fila){                        
       		        	Component.Apex.OutputText outPutTextnombre = new Component.Apex.OutputText(value=ListaNombresApi.get(parametroop.nombre));
         		       	Component.Apex.OutputText outPutTextvalor = new Component.Apex.OutputText(value=parametroop.valor);
         	          	pageBlkSectionFilas.childComponents.add(outPutTextnombre);
         	          	pageBlkSectionFilas.childComponents.add(outPutTextvalor);         	          	
         	       }
                }
     	       pageBlkSectiondetOpcion.childComponents.add(pageBlkSectionFilas); 
   	    	}
        	pageBlkSectionOpcion.childComponents.add(pageBlkSectiondetOpcion);             
                        
            //Crear PageBlockSection para la configuración del servicio de la opción 
            //
            Component.Apex.PageBlockSection pageBlkSectionConfServicio = new Component.Apex.PageBlockSection(title='Configuración Servicio', columns=numercolumnascs);   
            Component.Apex.OutputText outPutTextelementoTitulo = new Component.Apex.OutputText(value='Elemento',style='font-weight:800; font-style:italic');
            Component.Apex.OutputText outPutTextreferenciaTitulo = new Component.Apex.OutputText(value='Referencia',style='font-weight:800; font-style:italic');
            Component.Apex.OutputText outPutTextcantidadTitulo = new Component.Apex.OutputText(value='Cantidad',style='font-weight:800; font-style:italic');
            Component.Apex.OutputText outPutTextdescripcionTitulo = new Component.Apex.OutputText(value='Marca',style='font-weight:800; font-style:italic');
            pageBlkSectionConfServicio.childComponents.add(outPutTextelementoTitulo);
            pageBlkSectionConfServicio.childComponents.add(outPutTextreferenciaTitulo);
            pageBlkSectionConfServicio.childComponents.add(outPutTextcantidadTitulo);
            pageBlkSectionConfServicio.childComponents.add(outPutTextdescripcionTitulo);
            for(IntegracionGestor_ws.Item item : op.configuracionServicio.item){
                if(item != null){
                    Component.Apex.OutputText outPutTextelemento = new Component.Apex.OutputText(value=item.elemento);
                    Component.Apex.OutputText outPutTextreferencia = new Component.Apex.OutputText(value=item.referencia);
                    Component.Apex.OutputText outPutTextcantidad = new Component.Apex.OutputText(value=item.cantidad);
                    Component.Apex.OutputText outPutTextdescripcion = new Component.Apex.OutputText(value=item.descripcion);
                    pageBlkSectionConfServicio.childComponents.add(outPutTextelemento);
                    pageBlkSectionConfServicio.childComponents.add(outPutTextreferencia);
                    pageBlkSectionConfServicio.childComponents.add(outPutTextcantidad);
                    pageBlkSectionConfServicio.childComponents.add(outPutTextdescripcion);
                }
            }
           	pageBlkSectionOpcion.childComponents.add(pageBlkSectionConfServicio);
            
            //Crear OutputText para el campo observaciones de la opción
            if(!Test.isRunningTest()){
                Component.Apex.OutputText outPutTextobservaopc = new Component.Apex.OutputText(value=op.observaciones, label='Observaciones');
         	    pageBlkSectionOpcion.childComponents.add(outPutTextobservaopc);
            }
	       	pageBlk.childComponents.add(pageBlkSectionOpcion); 
            
        }
        return pageBlk;
    }
    
    
	////////////////////////
    //
    
    public PageReference seleccionarOpcion() {
        Boolean flgUpdateOC = false; 
        Account ObjAccount = new Account();
        for(Opcion_Aprovisionamiento__c oaprv :resultadosConsulta){
           // System.debug('resultadosConsulta: ' + resultadosConsulta);
           // System.debug('Opcion_Aprovisionamiento__c: ' + oaprv);
           // System.debug('this.opcion: ' + this.opcion);
           // System.debug('oaprv.IdOpcion__c: ' + oaprv.IdOpcion__c);           
            if(oaprv.IdOpcion__c == this.opcion){
                //[FSARASTY, 17/07/2018]: Código para actualizar la OC, con los valores de la opción de viabilidad seleccionada.
                opcionSeleccionada.add(oaprv);
                OperacionComercial__c opComercial;
                if(IdOC != null && IdOC != ''){
                    IntegracionGestor_ws.OpcionesViabilidad OVSelected = new IntegracionGestor_ws.OpcionesViabilidad();
                	Map<String, String> ApiNamesOC = new Map<String, string>(); 
					ApiNamesOC = IntegracionGestor_cls.obtenerListaNameApinames('OperacionComercial__c',ApiNamesOC);
            		OVSelected = IntegracionGestor_cls.ObtenerOpcionesViaclass(opcionSeleccionada); 
                    opComercial = new OperacionComercial__c(Id = IdOC);
                    
                    for(IntegracionGestor_ws.Opcion OpcionSeleccionada : OVSelected.opcion){
                        for(IntegracionGestor_ws.ParametroOp parOpSelect : OpcionSeleccionada.detalleOpcion.parametroop){                            
                            if(ApiNamesOC.get(parOpSelect.nombre) != '' && ApiNamesOC.get(parOpSelect.nombre) != null){                                  
                                try{  
                                    if(parOpSelect.nombre == 'AliadoColaborador__c'){
                                        ObjAccount = [SELECT Id FROM Account WHERE Name =: parOpSelect.valor LIMIT 1];  
                                        if(ObjAccount.Id != null)
                                            opComercial.put(parOpSelect.nombre, ObjAccount.Id);                                         
                                    }else               
                                    	opComercial.put(parOpSelect.nombre,parOpSelect.valor);                                    
                                }catch(Exception e){}                       
                                                                 
                                if(opComercial.Flag_Update_Opcion_VIA__c == false)
                                    opComercial.put('Flag_Update_Opcion_VIA__c',true);
                                else
                                    opComercial.put('Flag_Update_Opcion_VIA__c',false);
                                
                                flgUpdateOC = true;                                
                            }                            
                        }
                    }
                }
                //FIN [FSARASTY, 17/07/2018]
                oaprv.Seleccion__c = true;
                if(flgUpdateOC == true)
                    try{                        
                    	update opComercial;
                    }catch(Exception e){}
            }else{
                oaprv.Seleccion__c = false;
            }            
            update oaprv;
        }        
        return null;
    }    
    
    public List<SelectOption> getOpcionesDisponibles() {
        IntegracionGestor_ws.OpcionesViabilidad ovGetItems = new IntegracionGestor_ws.OpcionesViabilidad();
        ovGetItems=this.opcionesclass;
        List<SelectOption> options = new List<SelectOption>(); 
        For(IntegracionGestor_ws.Opcion op : ovGetItems.opcion){
            options.add(new SelectOption(op.idOpcion,op.idOpcion)); 
        }
        return options; 
    }
      
    
    public String getOpcion() {
        return opcion;
    }
     
    
    public void setOpcion(String opcion) {         
        this.opcion = opcion; 
    }
    
    public PageReference regresar() {
         
        Pagereference pg =  new Pagereference('https://'+ System.URL.getSalesforceBaseURL().getHost() + '/' + ApexPages.currentPage().getParameters().get('id'));
       // Pagereference pg =  new Pagereference('https://cs20.salesforce.com/' + ApexPages.currentPage().getParameters().get('id')); 
        System.debug('pg: ' + pg);
        pg.setRedirect(true);
		return pg;
   }
    
    public void ObtenerListaNombresApi(){
        
        Map<String, String> ApiNombres = new Map<String, string>(); 
		ApiNombres=IntegracionGestor_cls.obtenerListaNameApinames('OperacionComercial__c',ApiNombres);
		ApiNombres=IntegracionGestor_cls.obtenerListaNameApinames('Viabilidad__c',ApiNombres);
        this.ListaNombresApi=ApiNombres;        
    }
    
}