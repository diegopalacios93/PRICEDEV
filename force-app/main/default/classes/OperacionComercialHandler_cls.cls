/**
 * @description       : Clase Handler del trigger del objeto Operación Comercial
 * @author            : Miguel R. Gómez  miguel.rafael.gomez@accenture.com
 * @group             : 
 * @last modified on  : 03-03-2022
 * @last modified by  : Miguel R. Gómez  miguel.rafael.gomez@accenture.com
**/
public without sharing class OperacionComercialHandler_cls {
   
    public static Boolean isFirstTime = true;

    /**
    * @description Metodo que 
    * @author Miguel R. Gómez  miguel.rafael.gomez@accenture.com | 12-27-2021 
    * @param operacionesComerciales 
    **/
    public static void ActualizarServicioEnrutamiento(List<OperacionComercial__c> operacionesComercialesNuevas, List<OperacionComercial__c> operacionesComercialesViejas)
    {
        //Se buscan los XA donde el nombre sea tipo de cabecera y los valores distintos a Línea tradicional y Otro operador, que pertenezcan
        // a la operación comercial creada o modificada.        

        List<LTE_SpecificationGroupXA__c> sGXA = [SELECT Id, Name, LTE_Value__c, LTE_ServiciosAdicionales__r.LTE_OC_Tramite__r.Id 
                                              FROM LTE_SpecificationGroupXA__c 
                                              WHERE Name = 'Tipo de Cabecera' AND  LTE_Value__c NOT IN ('Línea tradicional','Otro operador' )
                                              AND LTE_ServiciosAdicionales__r.LTE_OC_Tramite__r.Id  IN  :operacionesComercialesNuevas];                                                           

        if (sGXA!=null && sGXA.Size()>0)
        {
            System.Debug('sGXA '+ sGXA);
        }

        // Se crea una lista y se pobla con los ids de las operaciones comerciales que estaban en el SELECT Anterior.                                                           
        List<String> idOperacionesAptas = new List<String>();
        
        for(LTE_SpecificationGroupXA__c sg : sGXA)
        {
            if (sg.Name == 'Tipo de Cabecera' && sg.LTE_Value__c != 'Línea tradicional' && sg.LTE_Value__c !='Otro operador'  )
            {
                idOperacionesAptas.add(sg.LTE_ServiciosAdicionales__r.LTE_OC_Tramite__r.Id);
            }
        }

        if (idOperacionesAptas.Size()>0)
        {

            //System.debug('operacionesComercialesNuevas '+operacionesComercialesNuevas[0].CuentaCliente__c);
            // List<String> IdsOperacionesComerciales = new List<String>();
            Map<String, String> IdsOperacionesComerciales = new  Map<String, String>();
            // List<String> IdsOperacionesComerciales = new List<String>();
            Map<Id, OperacionComercial__c> viejasMap = new Map<Id, OperacionComercial__c>();
            System.Debug('Antes del if '+ viejasMap);
            if(operacionesComercialesViejas!=null && operacionesComercialesViejas.Size()>0)
            {
                viejasMap = new Map<Id, OperacionComercial__c>(operacionesComercialesViejas);
            
        
                for(OperacionComercial__c ocv : operacionesComercialesViejas)
                {
                    for(OperacionComercial__c ocn : operacionesComercialesNuevas)
                    {
                        if((ocv.Id == ocn.Id && ocv.Enrutamientos__c != ocn.Enrutamientos__c && idOperacionesAptas.contains(ocn.Id)) || !viejasMap.containsKey(ocn.Id))
                        {
                            IdsOperacionesComerciales.put(ocn.Id, ocn.CuentaCliente__c);
                        }
                    
                    }
                }
            }
            else
            {
                for(OperacionComercial__c ocn : operacionesComercialesNuevas)
                    {
                        if(!String.IsBlank(ocn.Enrutamientos__c) && idOperacionesAptas.contains(ocn.Id) )
                        {
                            IdsOperacionesComerciales.put(ocn.Id, ocn.CuentaCliente__c);
                        }
                    
                    }
            }
            System.Debug('Despues del for anidado '+ viejasMap);
            // System.debug('IdsOperacionesComerciales.keySet() '+IdsOperacionesComerciales.keySet());
            // System.debug('IdsOperacionesComerciales.values() '+IdsOperacionesComerciales.values());

            
            
            //No está funcionando, ya que no todos los Activos ETB, no tienen asociada una operación comercial.
            List<OperacionComercial__c> operacionesAux = [SELECT Id, Enrutamientos__c, Activo_Relacionado__c,  Activo__r.Id, Activo__r.NumeroConexion__c,
                                                        Activo__r.NombredelProducto__r.Familia__c, Activo__r.NombredelProducto__r.LineaNegocio__c, CuentaCliente__c
                                                        FROM OperacionComercial__c 
                                                        WHERE Id IN:IdsOperacionesComerciales.keySet() 
                                                        AND Activo__r.NombredelaCuenta__r.Id IN :IdsOperacionesComerciales.values() 
                                                        AND Plan__r.NombredelProducto__r.Name = 'Cobro revertido automatico'
                                                        //   AND Activo__r.NombredelProducto__r.Familia__c = 'ENLACES DE VOZ' 
                                                        //   AND Activo__r.NombredelProducto__r.LineaNegocio__c = 'LOCAL'
                                                        ];



            if (operacionesAux!=null && operacionesAux.Size()>0)                  
            {  
                System.debug('operacionesAux '+operacionesAux); 
            }
            // for(OperacionComercial__c oc : operacionesAux)
            // { 
            //     System.debug('oc.Enrutamientos__c '+oc.Enrutamientos__c);  
            //     System.debug('oc.Activo__r.NumeroConexion__c '+oc.Activo__r.NumeroConexion__c);  
            //     if (oc.Enrutamientos__c.contains(oc.Activo__r.NumeroConexion__c))
            //     {
            //         oc.Activo_Relacionado__c = oc.Activo__r.Id;
            //     }
            // }
            
            List<ActivoETB__c> activos = [ SELECT Id, NumeroConexion__c,  NombredelaCuenta__r.Id, NombredelaCuenta__c FROM ActivoETB__c
                                        WHERE NombredelaCuenta__r.Id IN :IdsOperacionesComerciales.values() 
                                        AND NombredelProducto__r.Familia__c = 'ENLACES DE VOZ' 
                                        AND NombredelProducto__r.LineaNegocio__c = 'LOCAL' AND NumeroConexion__c!= NULL AND NumeroConexion__c!= ''
                                        ];


            if (operacionesAux!=null && operacionesAux.Size()>0 && activos!=null && activos.size()>0)    
            { 
                System.debug('activos '+activos); 
                for(OperacionComercial__c ocn : operacionesAux)
                {
                    for(ActivoETB__c act : activos)
                    {
                        if(!String.IsBlank(ocn.Enrutamientos__c) && !String.IsBlank(act.NumeroConexion__c) && ocn.Enrutamientos__c.contains(act.NumeroConexion__c) && ocn.CuentaCliente__c == act.NombredelaCuenta__c)
                        {
                            ocn.Activo_Relacionado__c = act.Id;
                        }
                    }
                }
            

                
                update operacionesAux;
                isFirstTime = false;
            }
        }
    }

    public Class VigenciaContrato{

        public Date fechaInicioContrato {get;set;}       
        public Date fechaFinContrato{get;set;}       
        public Boolean renovacionAutomatica {get;set;}
    }

   
    public static void ActualizarVigenciaActivo(List<OperacionComercial__c>  operacionesNew)
    {
        System.Debug('Entró a ActualizarVigenciaActivo');
        System.Debug('operacionesNew '+operacionesNew);        
        Map<id,VigenciaContrato> datosVigencia = new Map<id,VigenciaContrato>();       

        List<OperacionComercial__c> ocs = [SELECT Id, Name, Activo__c, Activo__r.Id, Legalizacion__c, Legalizacion__r.Id,
                                           Legalizacion__r.Contrato__r.StartDate, Legalizacion__r.Contrato__r.Renovacion_Automatica__c,
                                           Legalizacion__r.Contrato__r.EndDate 
                                           FROM OperacionComercial__c 
                                           WHERE Id IN : operacionesNew AND CuentaCliente__r.Segmento__c =: 'MiPymes'];

        for (OperacionComercial__c oc: ocs)
        {   
            VigenciaContrato vigencia = new VigenciaContrato();
			vigencia.fechaInicioContrato = oc.Legalizacion__r.Contrato__r.StartDate;
			vigencia.fechaFinContrato = oc.Legalizacion__r.Contrato__r.EndDate;
			vigencia.renovacionAutomatica = oc.Legalizacion__r.Contrato__r.Renovacion_Automatica__c;			
            datosVigencia.put(oc.Activo__r.Id,vigencia);                  
        }

        System.Debug('datosVigencia '+datosVigencia);
      
        if(datosVigencia!=null)
        {
            System.Debug('datosVigencia despues de consultar OC '+datosVigencia.values().Size());
        }


        List<ActivoETB__c> activos = [SELECT Id, Name, RenovacionAutomatica__c, FechaInicioContrato__c, FechaFinalContrato__c FROM ActivoETB__c WHERE Id IN : datosVigencia.keySet()];

        System.Debug('datosVigencia '+datosVigencia);
      
        if(datosVigencia!=null)
        {
            System.Debug('datosVigencia despues de consultar activos '+datosVigencia.values().Size());
        }

        System.Debug('activos antes '+activos);

        for (ActivoETB__c act : activos)
        {
            if (act.FechaInicioContrato__c == null)
            {
                act.FechaInicioContrato__c = datosVigencia.get(act.Id).fechaInicioContrato;
            }

            if (act.FechaFinalContrato__c == null || (act.FechaFinalContrato__c != null && datosVigencia.get(act.Id).fechaFinContrato>act.FechaFinalContrato__c))
            {
                act.FechaFinalContrato__c =datosVigencia.get(act.Id).fechaFinContrato;
            }

            act.RenovacionAutomatica__c = datosVigencia.get(act.Id).renovacionAutomatica;
        }

        System.Debug('activos despues '+activos);
        update activos;
    }
}