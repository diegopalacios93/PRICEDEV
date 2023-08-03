/*******************************************************************************
Develope by:            ETB
Author:                 Javier Acero
Project:                ETB-LTE   
Description:            Contiene la logica y estructuras xml para la invocacion
                        de la liberación de recursos
Sprint                  1
Release                 1

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                           Descripción
------  ----------  --------------------            ---------------
1.0     01/08/2018  Javier Acero.                  Class creation.
*******************************************************************************/

public class LTE_Release_Resources_cls {

    /**
    *   @Method: ReleaseResourcesOrder
    *   @param oc: OperacionComercial a procesar.      
    *   @return String: XML de request.
    *   @description: Metodo que crea el request para el consumo del servicio de liberación de recursos. 
    */
    public static string ReleaseResourcesOrder(OperacionComercial__c oc) {

        tramiteLTE tr = new tramiteLTE(Oc);

        string addServiceId='';
        
        if(tr.OrderType=='Venta LTE'){
            addServiceId=oc.Activo__c;      
        }else{
            addServiceId=oc.Activo__c+'-'+oc.Id;
        }


        string xml = '<?xml version="1.0" encoding="utf-8"?>'
                     + '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.etb.com.co/LTE/WS/Provisioning/ReleaseResources/IN/1.0" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:ns1="http://www.etb.com.co/LTE/Provisioning/ReleaseResources/1.0">'
                     + '<soapenv:Header/>'
            		 + '<soapenv:Body>'
                     + '<ns:WSInputReleaseResources>'
                     + '<v1:WSRequestHeader>' 
                         + '<v1:System correlationID="' + oc.Id + '" processingServer="Salesforce">Salesforce</v1:System>' 
                         + '<v1:Property name="?" value="?">?</v1:Property>' 
                     + '</v1:WSRequestHeader>' 
                     + '<ns1:ReleaseResourcesRequest>'
                        + '<ns1:OrderId>' + oc.Id + '</ns1:OrderId>'
                        + '<ns1:ExternalId>' + oc.Id + '</ns1:ExternalId>'
                        + '<ns1:ServiceAccount>' + oc.CuentaCliente__c + '</ns1:ServiceAccount>'
                        + '<ns1:ServiceId>' + addServiceId + '</ns1:ServiceId>'
                        + '<ns1:Tramit>' + tr.OrderSubtype + '</ns1:Tramit>'
                        + '<ns1:Origin>SALESFORCE</ns1:Origin>'
            			+ '<ns1:ICCID>'+ oc.LTE_ICCID__c +'</ns1:ICCID>'            
            			+ '<ns1:MSISDN>'+ oc.NumeroConexion__c +'</ns1:MSISDN>'            
            			+ '<ns1:NewMSISDN></ns1:NewMSISDN>'
                        + '<ns1:Resources>TODO</ns1:Resources>'
                     + '</ns1:ReleaseResourcesRequest>'
                  +'</ns:WSInputReleaseResources>'
               +'</soapenv:Body>'
            +'</soapenv:Envelope>';
            
        return xml.replace('>null<', '><');
    }

    public class tramiteLTE {

        public string OrderType = '';
        public string OrderSubtype = '';
        public string OrderSubtypeAprob = '';
        public string ServiceActionCode = '';
        public string SubOrderType = '';

        public tramiteLTE(OperacionComercial__c oc) {
            system.debug('Procesar Tramite');
            system.debug(oc.TOPP__r);
            system.debug('\n\n================\n'+oc.TOPP__r.TipodeOperacionporplan__c+'\n================\n\n');
            
            OrderSubtypeAprob='NORMAL';

            if (oc.TOPP__r.TipodeOperacionporplan__c == 'Venta') {
                SubOrderType = 'Venta LTE';
                OrderType = 'Venta LTE';
                ServiceActionCode = 'ADD';
                OrderSubtype = 'Venta LTE';
                if (oc.Portacion__c) {
                    OrderSubtype = 'Venta LTE NCP';
                }
            }
            
            if (oc.TOPP__r.TipodeOperacionporplan__c == 'Suspensión') {
                OrderType = 'Tramites LTE';
                ServiceActionCode = 'SUSPEND';
                if (oc.TipoSuspension__c=='Perdida') {
                    OrderSubtype = 'Suspension por Perdida';
                }
                
                if (oc.TipoSuspension__c=='Robo') {
                    OrderSubtype = 'Suspension por Robo';
                }
                
                if (oc.TipoSuspension__c=='Voluntaria') {
                    OrderSubtype = 'Suspension Voluntaria';
                }


            }
            
            if (oc.TOPP__r.TipodeOperacionporplan__c == 'Reconexión') {
                OrderType = 'Tramites LTE';
                ServiceActionCode = 'RESUME';
                if (oc.TipoSuspension__c=='Voluntaria') {
                    OrderSubtype = 'Reconexion Voluntaria';
                } else{
                    OrderSubtype = 'Reconexion por Perdida o Robo';
                }

            }
            
            if (oc.TOPP__r.TipodeOperacionporplan__c == 'Retiro') {
                OrderType = 'Tramites LTE';
                ServiceActionCode = 'DELETE';
                OrderSubtype = 'Cancelacion Voluntaria';

            }
            
            if (oc.TOPP__r.TipodeOperacionporplan__c == 'Renovación') {
                OrderType = 'Tramites LTE';
                ServiceActionCode = 'UPDATE';
                
                if(oc.LTE_TipoTransaccion__c=='Equipo más SIM'){
                    OrderSubtype = 'Renovacion Equipo mas SIM';
                }
                
                if(oc.LTE_TipoTransaccion__c=='SIM'){
                    OrderSubtype = 'Renovacion Sim';
                }

            }
            if (oc.TOPP__r.TipodeOperacionporplan__c == 'Reposición') {
                OrderType = 'Tramites LTE';
                ServiceActionCode = 'UPDATE';
                
                if(oc.LTE_TipoTransaccion__c=='Equipo más SIM'){
                    OrderSubtype = 'Renovacion Equipo mas SIM';
                }
                
                if(oc.LTE_TipoTransaccion__c=='SIM'){
                    OrderSubtype = 'Renovacion Sim';
                }

            }
            
            if (oc.TOPP__r.TipodeOperacionporplan__c == 'Cambio de Plan') {
                OrderType = 'Cambio de Plan';
                OrderSubtype='Cambio de Plan';
            }
            
            if (oc.TOPP__r.TipodeOperacionporplan__c == 'Cambio Número') {
                OrderType = 'Tramites LTE';
                ServiceActionCode = 'UPDATE';
                OrderSubtype = 'Modificacion Cambio Numero LTE';
            }
            
            if (oc.TOPP__r.TipodeOperacionporplan__c == 'Adición SVA') {
                OrderType = 'Tramites LTE';
                ServiceActionCode = 'UPDATE';
                OrderSubtype = 'Adicion SVA';
            }
            
            if (oc.TOPP__r.TipodeOperacionporplan__c == 'Retiro SVA') {
                OrderType = 'Tramites LTE';
                ServiceActionCode = 'UPDATE';
                OrderSubtype = 'Desactivacion SVA';
            }
        }
    }
}