global  with sharing class AsignarOC_SDWAN_ctr implements ObjectPaginatorListener {
    private Apexpages.Standardcontroller stdController;    
    Public List<wrpOCs>                  wOCs                   {get; set;}
    Public List<wrpOCs>                  wOCsTodos              {get; set;}
    public String                        objectId               {get; set;}   
    public string                        stringBusqueda         {get; set;}
    public boolean                       showOCs                {get; set;}
    public boolean                       showBtnAsignar         {get; set;}
    public boolean                       blncheckedAll          {get; set;}    
    public OperacionComercial__c         objOC                  {get; set;}
    global ObjectPaginator               paginator              {get;private set;}
    
    
    public AsignarOC_SDWAN_ctr(){         
        objectId                = ApexPages.currentPage().getParameters().get('objectId');
        showOCs                 = false;
        showBtnAsignar          = false;
        wOCs                    = new List<wrpOCs>();
        wOCsTodos               = new List<wrpOCs>();
        consultarOC();
        obtenerOCs();                
    }
   
    global void handlePageChange(List<Object> newPage){
        wOCs.clear();
        if(newPage != null){
            for(Object acct : newPage){
                wOCs.add((wrpOCs)acct);
            }
        }
    }   
    public void obtenerOCs(){
        showBtnAsignar  = false;
        if(objOC.Plan__r.NombredelProducto__r.Name != Label.SDWAN_Nombre_Producto){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,(Label.SDWAN_ValidacionAsignacionEnlace)));            
        }else{            
            showOCs     = true;            
            List<OperacionComercial__c> lstOCs;
            List<OperacionComercial__c> lstOCsAux;
            List<String> lstProductos = Label.SDWAN_Productos_relacionados.split(',');            
            lstOCs = 
                [SELECT Id, Name, Activo__r.Name, Activo__r.Plan__r.Name, Activo__r.Plan__r.NombredelProducto__r.Name, 
                 TOPP__r.Name, Estado__c, Oportunidad__r.Name, Activo__r.Estado__c, Activo__r.IDservicio__c
                 FROM OperacionComercial__c 
                 WHERE 
                 Id !=: objectId AND 
                 CuentaCliente__r.Id =: objOC.CuentaCliente__r.Id AND
                 (TOPP__r.Name like 'Venta%' OR TOPP__r.Name like 'venta%') AND
                 Estado__c != 'Declinada' AND
                 Activo__r.Plan__r.NombredelProducto__r.Name IN: lstProductos AND
                 //Activo__r.Estado__c = 'Activo' AND
                 Operacion_Comercial_Relacionada__c = NULL
                 order by Activo__r.Plan__r.NombredelProducto__r.Name
                ];             	
            
            if(lstOCs.size()>0){                            
                for(OperacionComercial__c tmp : lstOCs){            
                    wOCsTodos.add(new wrpOCs(tmp,false));
                }                    
                paginator = new ObjectPaginator(15,this);
                paginator.setRecords(wOCsTodos); 
                showBtnAsignar  = true;
            }
            else{
                showBtnAsignar = false;                
                showOCs		   = false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,label.SDWAN_Msj_Validacion_Sin_Enlaces));                
            }
        }        
    }
    public void filtrarOCs(){
        showBtnAsignar  = false;        
        showOCs     = true;            
        List<OperacionComercial__c> lstOCsFiltro;
        List<OperacionComercial__c> lstOCsAux;
        List<String>       lstProductos = Label.SDWAN_Productos_relacionados.split(',');
        if(stringBusqueda == null || stringBusqueda == ''){            
            lstOCsFiltro = 
                [SELECT Id, Name, Activo__r.Name, Activo__r.Plan__r.Name, Activo__r.Plan__r.NombredelProducto__r.Name, 
                 TOPP__r.Name, Estado__c, Oportunidad__r.Name, Activo__r.Estado__c, Activo__r.IDservicio__c
                 FROM OperacionComercial__c 
                 WHERE 
                 CuentaCliente__r.Id =: objOC.CuentaCliente__r.Id AND
                 (TOPP__r.Name like 'Venta%' OR TOPP__r.Name like 'venta%') AND
                 Estado__c != 'Declinada' AND
                 Activo__r.Plan__r.NombredelProducto__r.Name IN: lstProductos  AND
                 //Activo__r.Estado__c = 'Activo' AND
                 Operacion_Comercial_Relacionada__c = NULL
                 order by Activo__r.Plan__r.NombredelProducto__r.Name
                ];            
        }else{                            
            lstOCsFiltro = 
                [SELECT Id, Name, Activo__r.Name, Activo__r.Plan__r.Name, Activo__r.Plan__r.NombredelProducto__r.Name, 
                 TOPP__r.Name, Estado__c, Oportunidad__r.Name, Activo__r.Estado__c, Activo__r.IDservicio__c
                 FROM OperacionComercial__c
                 WHERE 
                 CuentaCliente__r.Id =: objOC.CuentaCliente__r.Id AND
                 (TOPP__r.Name like 'Venta%' OR TOPP__r.Name like 'venta%') AND
                 Estado__c != 'Declinada' AND
                 Activo__r.Plan__r.NombredelProducto__r.Name IN: lstProductos AND
                 //Activo__r.Estado__c = 'Activo' AND
                 Operacion_Comercial_Relacionada__c = NULL AND
                 (Name LIKE :('%' + stringBusqueda + '%') OR
                  Activo__r.Plan__r.NombredelProducto__r.Name LIKE :('%' + stringBusqueda + '%') OR
                  Activo__r.Plan__r.Name LIKE :('%' + stringBusqueda + '%') OR
                  TOPP__r.Name LIKE :('%' + stringBusqueda + '%') OR
                  Oportunidad__r.Name LIKE :('%' + stringBusqueda + '%') OR
                  Estado__c LIKE :('%' + stringBusqueda + '%') OR
                  Activo__r.Estado__c LIKE :('%' + stringBusqueda + '%') OR
                  Activo__r.Name LIKE :('%' + stringBusqueda + '%') OR
                  Activo__r.IDservicio__c LIKE :('%' + stringBusqueda + '%'))
                 order by Activo__r.Plan__r.NombredelProducto__r.Name
                ];
        }         
        if(lstOCsFiltro.size()>0){                        
            wOCsTodos.clear();
            wOCs.clear();
            for(OperacionComercial__c tmp : lstOCsFiltro){            
                wOCsTodos.add(new wrpOCs(tmp,false));
            }
            paginator = new ObjectPaginator(15,this);
            paginator.setRecords(wOCsTodos); 
            showBtnAsignar  = true;
        }
        else{
            wOCsTodos.clear();
            wOCs.clear(); 
        }
    }
    public void checkAll(){
        for (wrpOCs tmp : wOCsTodos)
            tmp.blnChecked = blncheckedAll; 
    }    
     public class wrpOCs{    
        public OperacionComercial__c oc {get;set;}
        public boolean blnChecked {get;set;}
        public wrpOCs(OperacionComercial__c ocAux, Boolean bln)
        {
            oc=ocAux;
            blnChecked=bln;            
        }        
    }     
    public pageReference asignarOCs(){
        List<OperacionComercial__c> OCAuxList = new List<OperacionComercial__c>();
        OperacionComercial__c OCAuxObject;   
        boolean hasRecords   = false;
        for (wrpOCs tmp : wOCsTodos){
            if(tmp.blnChecked){
                hasRecords = true;
                OCAuxObject = new OperacionComercial__c(Id=tmp.oc.Id);                
                OCAuxObject.Operacion_Comercial_Relacionada__c = objectId;
                OCAuxList.Add(OCAuxObject);
            }            
        }
        if (!hasRecords){               
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,label.SDWAN_Msj_Validacion_Seleccionar_OC));
            return null;
        }else{
            update OCAuxList;
            showBtnAsignar = false;
            showOCs		   = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,label.SDWAN_Msj_Validacion_OK));
        }
        
        return null;
    }
    public Pagereference regresar(){
        PageReference paginaInicio= new PageReference('/'+ObjectId);
        paginaInicio.setRedirect(true);
        return paginaInicio;        
    }
    public Pagereference buscarServicio(){          
        wOCs.clear();      
        wOCsTodos.clear();
        obtenerOCs();        
        return null;  
    }
    
    public void consultarOC(){
        objOC = [SELECT Plan__r.NombredelProducto__r.Name, CuentaCliente__r.Id 
                 FROM OperacionComercial__c WHERE Id =: objectId];
    }
}