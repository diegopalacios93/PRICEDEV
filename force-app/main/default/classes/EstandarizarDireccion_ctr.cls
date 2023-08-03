/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Carlos Gonzalez
Proyecto:               ETB - Estandarización de Direcciones
Descripcion:            Clase controlado de la VF de estandarización de direcciones
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     17-05-2016  Carlos Gonzalez (CG)        Creación de la clase
*******************************************************************************/
public class EstandarizarDireccion_ctr
{
    public Integer intNControles {get;set;}
    
    public String strDireccion {get;set;}
    
    public String strDireccionOld {get;set;}
    
    public String dirAbreviada {get;set;}
    
    public String dirCompleta {get;set;}
    
    public String observacion {get;set;}
    
    public String strObjeto;

    public String strId;
    
    public String strCampo;
    
    public sObject objTemp;  
    
    public List<SeccionWraper> lstSecciones {get;set;}  
    
    public Boolean sinObjeto {get;set;}
    
    public Boolean verBotones {get;set;}
    
    public EstandarizarDireccion_ctr()
    {
        verBotones = true;
        sinObjeto = true;
        dirAbreviada  = '';
        dirCompleta  = '';
        observacion = '';
        
        Map<String,EstandarDireccionesReferencia__c> mapReferencias = new Map<String,EstandarDireccionesReferencia__c> ([SELECT ID, NAME, SECCION__C, SUBSECCION__C, TIPOCONTROL__C, ELEMENTO__C, ABREVIATURA__C, LONGITUD__C, AYUDA__C FROM EstandarDireccionesReferencia__c WHERE Name != null ORDER BY orden__c ASC NULLS LAST]);//EstandarDireccionesReferencia__c.getAll();
        
        Map<String, Map<String, List<EstandarDireccionesReferencia__c> >> mapConfiguracion = new Map<String, Map<String,List<EstandarDireccionesReferencia__c> >>();
        for(EstandarDireccionesReferencia__c cpRefrencias : mapReferencias.values())
        {
            if(!mapConfiguracion.containsKey(cpRefrencias.seccion__c)) 
            {
                mapConfiguracion.put(cpRefrencias.seccion__c, new Map<String,List<EstandarDireccionesReferencia__c> >());                
            } 
            
            if(!mapConfiguracion.get(cpRefrencias.seccion__c).containsKey(cpRefrencias.subseccion__c))
            {
                mapConfiguracion.get(cpRefrencias.seccion__c).put(cpRefrencias.subseccion__c, new List<EstandarDireccionesReferencia__c>{cpRefrencias});
            }
            else
            {
                mapConfiguracion.get(cpRefrencias.seccion__c).get(cpRefrencias.subseccion__c).add(cpRefrencias);
            }                             
        }
        
        Integer i = 0;
        lstSecciones =  new List<SeccionWraper>();
        String nombreSeccion = '';
        for(Map<String, List<EstandarDireccionesReferencia__c> > mapSecciones : mapConfiguracion.values())
        {

            List<ControlesWraper> lstCtrls = new List<ControlesWraper>();
            for(List<EstandarDireccionesReferencia__c> lstControles : mapSecciones.values())
            {
                List<SelectOption> lstOpTempo = new List<SelectOption>();
                lstOpTempo.add(new SelectOption('',''));
                for(EstandarDireccionesReferencia__c cpReferencias : lstControles)
                {
                    if(cpReferencias.tipoControl__c == '1')
                    {
                        if(cpReferencias.abreviatura__c != null && cpReferencias.elemento__c != null)                    
                            lstOpTempo.add(new SelectOption(cpReferencias.abreviatura__c,cpReferencias.elemento__c));
                    }                                 
                }
                lstCtrls.add(new ControlesWraper(lstControles[0].subseccion__c,'',lstOpTempo, lstControles[0].tipoControl__c, 'concatenar(this.value,'+i+');', 'Ayuda: ' + lstControles[0].ayuda__c, ''+ lstControles[0].Longitud__c));
                i++;
                nombreSeccion = lstControles[0].seccion__c;
            }
            lstSecciones.add(new SeccionWraper(nombreSeccion ,lstCtrls)); 
        }
        intNControles = i;
     
        Map<String, String> UrlParameterMap = ApexPages.currentPage().getParameters();
        
        if (UrlParameterMap.containsKey('Obj')){
            strObjeto= ApexPages.currentPage().getParameters().get('Obj');
        } 
        if (UrlParameterMap.containsKey('Id')){
            strId= ApexPages.currentPage().getParameters().get('Id');
        }  
        if (UrlParameterMap.containsKey('field')){
            strCampo = ApexPages.currentPage().getParameters().get('field');
        } 
        
        verBotones = ( UrlParameterMap.containsKey('sinBotones') ? false : true );
        sinObjeto = (strCampo!=null && strObjeto!=null && strId!=null ? false : true);
        
        if(!sinObjeto)
        {
        
            Map<String, Schema.SObjectType>     globalDescribe          = Schema.getGlobalDescribe(); 
            Schema.SObjectType                  objectType              = globalDescribe.get(strObjeto);
            Schema.DescribeSObjectResult        objectDescribeResult    = objectType.getDescribe();
            
            Map<String, Schema.SObjectField>    objectFieldMap          = objectDescribeResult.fields.getMap();
            Schema.SObjectField                 objectField             = objectFieldMap.get(strCampo  );
            Schema.DescribeFieldResult          fieldDescription        = objectField.getDescribe();        
        
            objTemp = Database.query('SELECT ' + strCampo  + ' FROM ' + strObjeto + ' WHERE Id = :strId');  
            dirCompleta = (String) objTemp.get(strCampo);                       
        }

        strDireccion = dirCompleta;
        strDireccionOld = strDireccion;
        validarPerfil();
    }
    
    public void validarPerfil()
    {
    
        Profile[] lstURole = [SELECT Description,Name FROM Profile WHERE Id = : UserInfo.getProfileId() ];
        Map<String, EstandarDireccionesPerfiles__c> mapPerfiles = EstandarDireccionesPerfiles__c.getAll();
        
        if(!mapPerfiles.containsKey(lstURole[0].name) && sinObjeto == false)
        {
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.Error,'Su perfil no cuenta con privilegios para guardar!'));                          
            sinObjeto = true;
        }   
    }
    
    public PageReference guardar()
    {
    
        dirAbreviada = '';
        
        for(SeccionWraper s : lstSecciones )
        {
            for(ControlesWraper c : s.lstControl )
            {
                if(c.strValor != null && c.strValor.length() > 0)
                    dirAbreviada = dirAbreviada  + c.strValor + ' ';
            }
        }
        
        if(dirAbreviada.length() > 0)
        {
            strDireccion = dirAbreviada;
        }
        
        if(observacion.length() > 0)
        {
            strDireccion += ' ' + observacion;
        }
        
        if(!sinObjeto)
        {
            objTemp.put(strCampo , strDireccion );            
            Update objTemp;            
        }
        
        PageReference redirectPage= new PageReference('/' + strId);
        redirectPage.setRedirect(true);
        return redirectPage;
       
    }    
    
    public PageReference cancelar()
    {          
        PageReference redirectPage= new PageReference('/' + strId);
        redirectPage.setRedirect(true);
        return redirectPage;       
    } 
    
    public class ControlesWraper
    {    
        public String strIdName {get;set;}
        public String strEtiqueta {get;set;}
        public String strValor {get;set;}
        public List<SelectOption> lstOpciones {get; set;}
        public String strTipoControl {get;set;}  
        public String strPos {get;set;}  
        public String strAyuda {get;set;}  
        public String strLong {get;set;}                               
        
        public ControlesWraper(String  strLbl, String strVal, List<SelectOption> lstOp, String strTipo, String strPos, String strAyuda, String strLong )
        {   
            this.strEtiqueta = strLbl;
            this.strValor = strVal;
            this.lstOpciones = lstOp; 
            this.strTipoControl = strTipo;  
            this.strPos = strPos ;                                                  
            this.strAyuda = strAyuda;
            this.strLong = strLong;
        }            
    }

    public class SeccionWraper
    {
        public String strNomSeccion {get;set;}
        public List<ControlesWraper> lstControl {get;set;}
        
        public SeccionWraper(String strNombre, List<ControlesWraper> lstCW)
        {
            strNomSeccion = strNombre;
            lstControl = lstCW;
        }
    }
}