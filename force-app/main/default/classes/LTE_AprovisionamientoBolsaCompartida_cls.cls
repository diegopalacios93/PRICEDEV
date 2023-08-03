/*******************************************************************************
Develope by:            ETB
Author:                 Fernando Sarasty
Project:                Bolsas compartidas
Description:            Clase contiene la logica y estructuras xml para la invocacion
                        de los servicios de aprovisionamiento de bolsas compartidas

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                           Descripción
------  ----------  --------------------            ---------------
1.0     13/05/2020  Fernando Sarasty                Class creation.
*******************************************************************************/

public with sharing class LTE_AprovisionamientoBolsaCompartida_cls {

    public class OrdelineBolsaCompartidaXML {                	
        public string								tipoLinea	  = '';
        public string								dirNumParent  = '';        
        public list<LTE_Servicios_adicionales__c> 	sa 			  = new list<LTE_Servicios_adicionales__c>();
        public OperacionComercial__c 				oc 			  = new OperacionComercial__c();                 
        
        public OrdelineBolsaCompartidaXML(list<LTE_Servicios_adicionales__c> sa, OperacionComercial__c oc, String tipoLinea) {            
            this.sa 			= sa;
            this.oc 			= oc;        
            this.tipoLinea		= tipoLinea;
            this.dirNumParent	= '';            
        }
        public string getBodyBolsaCompartida(){
            string xml  = '';           			
            if(tipoLinea == 'Padre'){
				xml = getCreateProviderOP();
            }
            if(tipoLinea == 'Hija'){
                getDirNumParent();
                if(Oc.TOPP__r.TipodeOperacionporplan__c == 'Adición bolsa compartida' || Oc.TOPP__r.TipodeOperacionporplan__c == 'Venta')
                	xml = getAssignConsumersOP();
                if(Oc.TOPP__r.TipodeOperacionporplan__c == 'Reducción bolsa compartida')
                	xml = getDeallocateToProviderOP();
            }
            return xml;
        }
        
        public string getCreateProviderOP() {
            string OfferClassOCS = getSpecificationXABolsaCompartida('OFFER CLASS OCS');
            string xml;         
            xml	= '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.etb.com.co/LTE/LTEServiceManagement/InputCreateProvider/IN/1.0" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:inp="http://www.etb.com.co/LTE/LTEServiceManagement/InputCreateProvider">'
                +' <soapenv:Header/>'
                +'   <soapenv:Body>'
                +'      <ns:WSInputCreateProvider>' 
                +'         <v1:WSRequestHeader>'
                +'            <v1:System correlationID="' + Oc.Id + '" processingServer="Salesforce">Salesforce</v1:System>'
                +'            <v1:Property name="" value=""></v1:Property>'
                +'         </v1:WSRequestHeader>'
                +'         <inp:InputCreateProvider>'
                +'            <inp:contractTemplate>'+getSpecificationXABolsaCompartida('SERVICE CLASSE OCS')+'</inp:contractTemplate>'
                +'            <inp:dirNum>57'+Oc.NumeroConexion__c+'</inp:dirNum>'
                +'            <inp:storMedNum>'+Oc.LTE_ICCID__c+'</inp:storMedNum>'
                +'            <inp:portNum>'+Oc.LTE_IMSI__c+'</inp:portNum>'
                +'            <inp:sdpId>'+oc.SDP__c+'</inp:sdpId>'
                +'            <inp:PAMClassIDMensual>'+getSpecificationXABolsaCompartida('PAM_CLASS_ID')+'</inp:PAMClassIDMensual>'
                +'            <inp:ScheduleIDMensual>'+oc.CuentaFacturacion__r.LTE_CicloFacturacion__c+'</inp:ScheduleIDMensual>'
                +'            <inp:PAMClassIDDiario>'+getSchedulePamClass('PAMClassIDDiario',getSpecificationXABolsaCompartida('PAM_CLASS_ID'))+'</inp:PAMClassIDDiario>'
                +'            <inp:ScheduleIDDiario>'+getSchedulePamClass('ScheduleIDDiario',oc.CuentaFacturacion__r.LTE_CicloFacturacion__c)+'</inp:ScheduleIDDiario>';            	
            if(OfferClassOCS != null && OfferClassOCS != '')
            xml +='			  <inp:OfferClass>'+OfferClassOCS+'</inp:OfferClass>';            
            xml +='         </inp:InputCreateProvider>'
                +'      </ns:WSInputCreateProvider>'
                +'   </soapenv:Body>'
                +' </soapenv:Envelope>';
            return xml;            
        }
        
        public string getAssignConsumersOP() {            
            string xml;
            xml	= '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.etb.com.co/LTE/LTEServiceManagement/InputAssignConsumers/IN/1.0" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:inp="http://www.etb.com.co/LTE/LTEServiceManagement/InputAssignConsumers">'
                +'   <soapenv:Header/>'
                +'   <soapenv:Body>'
                +'      <ns:WSInputAssignConsumers>'
                +'         <v1:WSRequestHeader>'
                +'            <v1:System correlationID="' + Oc.Id + '" processingServer="Salesforce">Salesforce</v1:System>'
                +'            <v1:Property name="" value=""></v1:Property>'
                +'         </v1:WSRequestHeader>'
                +'         <inp:InputAssignConsumers>'
                +'            <inp:contractTemplate>'+getSpecificationXABolsaCompartida('SERVICE CLASSE OCS')+'</inp:contractTemplate>'
                +'            <inp:dirNum>57'+dirNumParent+'</inp:dirNum>'                              
                +'            <inp:dirNum2>57'+Oc.NumeroConexion__c+'</inp:dirNum2>'
                +'            <inp:storMedNum>'+Oc.LTE_ICCID__c+'</inp:storMedNum>'
                +'            <inp:portNum>'+(string.isBlank(Oc.LTE_IMSI__c)?getSpecificationXABolsaCompartida('IMSI'):Oc.LTE_IMSI__c)+'</inp:portNum>'
                +'            <inp:sdpId>'+(string.isBlank(oc.SDP__c)?Label.Param_BolsaCompartida_default_SDP:oc.SDP__c)+'</inp:sdpId>'
                +'            <inp:PAMClassIDMensual>'+getSpecificationXABolsaCompartida('PAM_CLASS_ID')+'</inp:PAMClassIDMensual>'
                +'            <inp:ScheduleIDMensual>'+oc.CuentaFacturacion__r.LTE_CicloFacturacion__c+'</inp:ScheduleIDMensual>'
                +'            <inp:PAMClassIDDiario>'+getSchedulePamClass('PAMClassIDDiario',getSpecificationXABolsaCompartida('PAM_CLASS_ID'))+'</inp:PAMClassIDDiario>'
                +'            <inp:ScheduleIDDiario>'+getSchedulePamClass('ScheduleIDDiario',oc.CuentaFacturacion__r.LTE_CicloFacturacion__c)+'</inp:ScheduleIDDiario>'                
                +'         </inp:InputAssignConsumers>'                
                +'      </ns:WSInputAssignConsumers>'
                +'   </soapenv:Body>'
                +'</soapenv:Envelope>';
            return xml;
        }
        public string getDeallocateToProviderOP(){
            string xml;
            xml	= '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.etb.com.co/LTE/LTEServiceManagement/InputDeallocateToProvider/IN/1.0" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:inp="http://www.etb.com.co/LTE/LTEServiceManagement/InputDeallocateToProvider">'
                +'   <soapenv:Header/>'
                +'   <soapenv:Body>'
                +'      <ns:WSInputDeallocateToProvider>'
                +'         <v1:WSRequestHeader>'
                +'            <v1:System correlationID="' + Oc.Id + '" processingServer="Salesforce">Salesforce</v1:System>'                             
                +'            <v1:Property name="" value=""></v1:Property>'
                +'         </v1:WSRequestHeader>'                
                +'         <inp:InputDeallocateToProvider>'
                +'            <inp:dirNum>57'+dirNumParent+'</inp:dirNum>'                              
                +'            <inp:dirNum2>57'+Oc.NumeroConexion__c+'</inp:dirNum2>'
                +'         </inp:InputDeallocateToProvider>'
                +'      </ns:WSInputDeallocateToProvider>'
                +'   </soapenv:Body>'
                +'</soapenv:Envelope>';
            return xml;
        }
        public string getSpecificationXABolsaCompartida(string parametro) {            
            string valorParametro = '';
            for (LTE_Servicios_adicionales__c servicioAdicional : sa) {
                for(LTE_SpecificationGroupXA__c ServicioAdicionalxa : servicioAdicional.SpecificationGroupXA__r){                    
                    if(ServicioAdicionalxa.Name == parametro){
                   		valorParametro = ServicioAdicionalxa.LTE_Value__c;
                        break;
                    }
                }
            }
            return valorParametro;
        }
        public integer getSchedulePamClass(string parametro, string valorParametro){            
            integer returnParametro;
            if(parametro == 'PAMClassIDDiario')
                returnParametro = integer.valueof(valorParametro) + 10;
            
            if(parametro == 'ScheduleIDDiario')
                returnParametro = integer.valueof(valorParametro) * 10;
            
            return returnParametro;
        }
        public void getDirNumParent(){            
            if(Oc.TOPP__r.TipodeOperacionporplan__c == 'Adición bolsa compartida' || Oc.TOPP__r.TipodeOperacionporplan__c == 'Reducción bolsa compartida')
                dirNumParent = Oc.Activo_Relacionado__r.NumeroConexion__c;
            else if(!String.isBlank(Oc.Oportunidad__r.Servicio_Bolsa_Compartida_Padre__r.NumeroConexion__c))
                dirNumParent = Oc.Oportunidad__r.Servicio_Bolsa_Compartida_Padre__r.NumeroConexion__c;
            else if(!String.isBlank(Oc.Operacion_Comercial_Relacionada__r.NumeroConexion__c))
                dirNumParent = Oc.Operacion_Comercial_Relacionada__r.NumeroConexion__c;        
        }
    }
}