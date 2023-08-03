/*******************************************************************************
Develope by:            Avanxo Colombia
Author:                 Carlos A. Rodriguez B. 
Project:                ETB-LTE   
Description:            VisualForce encargada de la información y el consumo del sistema legado Plib.                          
Sprint                  1
Release                 1

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                           Descripción
------  ----------  --------------------            ---------------
1.0     14/08/2015  Carlos A. Rodriguez B.          Class creation.
*******************************************************************************/
public class LTE_Plib_ctr 
{
    public Case objCase {get;set;}
    public String strGarantiaSelec {set;get;}
    public String strRequest = '';
    public String strResponse = '';
    public LogTransacciones__c objLog = new LogTransacciones__c();

    //Clase que contiene los datos requeridos por el servicio web de plib y que necesitan algun tratamiento.
    public class DatosPlib
    {
        public String strCorrelationId  = '';
        public String strFechaCompra    = '';
        public String strFalla          = '';
        public String strGarantia       = '';
    }

    public list<SelectOption> lstOpcionesGarantia
    {
        get 
        {
            list<SelectOption> lstGarantia = new list<SelectOption>();
            Schema.DescribeFieldResult fieldResult = Case.LTE_Garantia__c.getDescribe();
            list<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();
            lstGarantia.add(new SelectOption('', label.LTE_OpcionListaNinguno));
            for(Schema.PicklistEntry entry : picklistEntries)
                lstGarantia.add(new SelectOption(entry.getValue(), entry.getLabel()));
            return lstGarantia;
        }
        set;
    }

    /**
    *   @Method:  LTE_Plib_ctr
    *   @param  
    *   @return
    *   @description: Constructor encargado de cargar datos en la visualforce. 
    */
    public LTE_Plib_ctr() 
    {
        if (ApexPages.currentPage().getParameters().get('Id') != null)
        {
            list<Case> lstCase  =   [SELECT Id, CaseNumber, LTE_Origen__c, LTE_Marca__c, Tipologia__c, LTE_ModeloComercial__c, LTE_Garantia__c, LTE_IMEI__c,
                                            LTE_FechaCompra__c, NumeroConexion__c,  Account.Name, Contact.Name, Contact.Phone, LTE_Servicio__c, 
                                            LTE_EstEnvioSistLegado__c, LTE_IntentosSistemaLegado__c, Plan__c
                                     FROM   Case
                                     WHERE  Id =: ApexPages.currentPage().getParameters().get('id')];

            if(!lstCase.isEmpty())
                objCase = lstCase.get(0);

            strGarantiaSelec            = objCase.LTE_Garantia__c;
            objCase.LTE_Origen__c       = label.LTE_PlibCAC;
            objCase.LTE_Comentarios__c  = objCase.Account.Name + '\n' + objCase.Contact.Name + '\n' + objCase.Contact.Phone;
        }
    }

    /**
    *   @Method: guardar       
    *   @return Pagereference: redirecciona al caso despues de consumir el servicio web de plib.
    *   @description: Se encarga de obtener la información necesaria para la construcción del request en invocar el servicio web de plib.
    */ 
    public PageReference guardar()
    {
        PageReference returnPage;
        //si la URL tiene id como parametro, se actualizará dicho registro.
        if ( ApexPages.currentPage().getParameters().get('Id') != null)
        {
            if(strGarantiaSelec == null || strGarantiaSelec == '')
            {
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Garantía: Debe seleccionar un valor'));
                return null;
            }

            DatosPlib objDatosPlib          = new DatosPlib();
            Datetime datToday               = system.now();
            LTE_FallasPlib__c objFallas     = LTE_FallasPlib__c.getValues(objCase.Tipologia__c);
            objDatosPlib.strCorrelationId   = objCase.Id + String.valueOf(datToday.day()) + String.valueOf(datToday.month()) + String.valueOf(datToday.year()) 
                                            + String.valueOf(datToday.hour()) + String.valueOf(datToday.minute()) + String.valueOf(datToday.second());
            objDatosPlib.strFechaCompra     = objCase.LTE_FechaCompra__c != null ? objCase.LTE_FechaCompra__c.format('MM/dd/yyyy hh:mm:ss') : '';
            objDatosPlib.strFalla           = objFallas.LTE_Codigo__c;
            objDatosPlib.strGarantia        = strGarantiaSelec != null ? strGarantiaSelec : '';
            objCase.Id                      = ApexPages.currentPage().getParameters().get('Id');
            objCase.LTE_Garantia__c         = strGarantiaSelec;
            // Llama la clase LTE_Aseguramiento_cls para crear el XML request.
            strRequest                      = LTE_Aseguramiento_cls.Plib(objCase, objDatosPlib);
            system.debug('REQUEST----------->' + strRequest);
            invocarServicioPlib(strRequest);

            system.debug('CASOOOOO--------' + objCase);
            system.debug('LOG TRANSACCION------' + objLog);
            update objCase;
            insert objLog;
            returnPage = new PageReference('/' + objCase.Id);
            returnPage.setRedirect(true);
        }
        return returnPage;
    }

    /**
    *   @Method: invocarServicioPlib.
    *   @param strRequest: XML request.
    *   @description: Se encarga de invocar el servicio web y leer la respuesta para crear el log de transacción. 
    */
    public void invocarServicioPlib(String strRequest)
    {
        map<string,string> values = new map<string,string>();

        ServiciosWeb__c sw = ServiciosWeb__c.getValues('Plib');
        strResponse = LibreriaUtilitariaJobs_cls.consultarServicio(strRequest,sw.Action__c,sw.EndPoint__c);
        System.debug('Response----------->' + strResponse);

        tibcoXml_cls.xmlMap proReq = new tibcoXml_cls.xmlMap();            
        values = proReq.getMap(strResponse);
  
        if(values.get('status') == 'PASS' && values.get('errorCode') == '0')
        {
            objLog.Estado__c = 'Exitoso';
            objCase.LTE_EstEnvioSistLegado__c = 'Exitoso';
            objCase.LTE_IntentosSistemaLegado__c = 0;
        }
        else
        {
            objLog.Estado__c = 'Fallido';
            objCase.LTE_EstEnvioSistLegado__c = 'Fallido';
            objCase.LTE_IntentosSistemaLegado__c = objCase.LTE_IntentosSistemaLegado__c != null ? objCase.LTE_IntentosSistemaLegado__c + 1 : 1;
        }
           
        objLog.Informacion_Enviada__c = strRequest;
        objLog.Informacion_Recibida__c = strResponse;
        objLog.Caso__c = objCase.Id;
        objLog.Name = 'PLIB ' + objCase.CaseNumber;
        objLog.CodigoRespuesta__c = values.get('errorCode');
    }

    /**
    *   @Method: actualizarInfoEquipo       
    *   @return Pagereference.
    *   @description: Se encarga de actualizar la información del equipo cuando en la visualforce  el usuario cambia o selecciona el servicio.
    */ 
    public PageReference actualizarInfoEquipo()
    {
        list<LTE_Servicios_adicionales__c> lstServAdicional = new list<LTE_Servicios_adicionales__c>();
        list<ActivoETB__c> lstServicio = new list<ActivoETB__c>();
        LTE_Servicios_adicionales__c objServAdicional = new LTE_Servicios_adicionales__c();
        ActivoETB__c objServicio = new ActivoETB__c();
        objCase.LTE_Marca__c = '';
        objCase.LTE_ModeloComercial__c = '';
        objCase.LTE_IMEI__c = '';
        objCase.NumeroConexion__c = '';
        objCase.LTE_FechaCompra__c = null;

        // Se busca el servicio adicional 'EQUIPO PROPIEDAD CLIENTE' del servicio seleccionado en la visualforce.
        if (objCase.LTE_Servicio__c != null)
        {
            lstServAdicional = [SELECT  Id, Name, LTE_ServicioETB__c, (SELECT Id, Name, LTE_Value__c FROM SpecificationGroupXA__r WHERE LTE_ActionCode__c != 'DELETE')
                                FROM    LTE_Servicios_adicionales__c
                                WHERE   LTE_ServicioETB__c =: objCase.LTE_Servicio__c
                                AND     Name = 'EQUIPO PROPIEDAD CLIENTE'];

            if(!lstServAdicional.isEmpty())
            {
                objServAdicional = lstServAdicional.get(0);
                //Se obtiene la marca y el modelo del equipo.
                if(!objServAdicional.SpecificationGroupXA__r.isEmpty())
                {
                    for(LTE_SpecificationGroupXA__c objSpecification : objServAdicional.SpecificationGroupXA__r)
                    {
                        if (objSpecification.Name == 'MARCA')
                            objCase.LTE_Marca__c = objSpecification.LTE_Value__c;
                        if (objSpecification.Name == 'MODELO')
                            objCase.LTE_ModeloComercial__c = objSpecification.LTE_Value__c;
                    }
                }
            }

            //Se obtiene el imei, el número de conexión y la fecha de activación del servicio seleccionado en la visualforce.
            lstServicio =   [SELECT Id, Name, IMEI_del_Equipo__c, NumeroConexion__c, Fecha_Activacion__c, Plan__c
                            FROM    ActivoETB__c
                            WHERE   Id =: objCase.LTE_Servicio__c];

            if(!lstServicio.isEmpty())
            {
                objServicio = lstServicio.get(0);
                objCase.Plan__c = objServicio.Plan__c;
                objCase.LTE_IMEI__c = objServicio.IMEI_del_Equipo__c;
                objCase.NumeroConexion__c = objServicio.NumeroConexion__c;
                if(objServicio.Fecha_Activacion__c != null)
                    objCase.LTE_FechaCompra__c = objServicio.Fecha_Activacion__c;
            }
        }
        return null;
    }
}