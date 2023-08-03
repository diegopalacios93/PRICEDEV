/************************************************************************************
Desarrollado por:        Avanxo Colombia
Autor:                   Sergio Ortiz
Proyecto:                ETB
Descripción:             Clase con la logica para la creacion del XML para consumir
                         los metodos del WSDL para larga distancia.
                         
Cambios (Versiones)
-------------------------------------
No.        Fecha        Autor                         Descripción
------  ----------  --------------------            ---------------
1.0     12-08-2015   Sergio Ortiz                   Creación de la clase.
**************************************************************************************/


public with sharing class LargaDistanciaXML_cls {

    //Metodo con el request del consumo del servicio web para consultar lineas de larga distancia a RevChain mediante el numero de conexion.
    public static string ConexionNumber(map<string,string> values){
        String xml='';

        xml='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.etb.com.co/LTE/WS/SisExt/ConnectionNumber/IN/1.0" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:ld="http://WSSalesForceLD.etb.com/LD">'
            +' <soapenv:Header/>'
            +'  <soapenv:Body>'
            +'      <ns:WSConnectionNumberRequest>'
            +'          <v1:WSRequestHeader>'
            +'              <v1:System correlationID="'+values.get('correlationID')+'" processingServer=""></v1:System>'        
            +'              <v1:Property name="" value=""></v1:Property>'
            +'          </v1:WSRequestHeader>'
            +'          <ld:ConexionNumber>'
            +'              <arg0>'+values.get('NumerosConsulta')+'</arg0>'
            +'          </ld:ConexionNumber>'
            +'      </ns:WSConnectionNumberRequest>'
            +'  </soapenv:Body>'
            +'</soapenv:Envelope>';

        System.debug('@@-xml ConexionNumber->'+xml);
        return xml;     
    }

    //Metodo con el request del consumo del servicio web para consultar lineas de larga distancia a RevChain mediante el numero de la cuenta.
    public static string ConexionCuenta(map<string,string> values){
        String xml='';

        xml='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.etb.com.co/LTE/WS/SisExt/AccountId/IN/1.0" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:ld="http://WSSalesForceLD.etb.com/LD">'
            +' <soapenv:Header/>'
            +'  <soapenv:Body>'
            +'      <ns:WSAccountIdRequest>'
            +'          <v1:WSRequestHeader>'
            +'              <v1:System correlationID="'+values.get('correlationID')+'" processingServer=""></v1:System>'
            +'              <v1:Property name="" value=""></v1:Property>'
            +'          </v1:WSRequestHeader>'
            +'          <ld:AcountId>'
            +'              <arg0>'+values.get('NumerosConsulta')+'</arg0>'
            +'          </ld:AcountId>'
            +'      </ns:WSAccountIdRequest>'
            +'  </soapenv:Body>'
            +'</soapenv:Envelope>';

        System.debug('@@-xml ConexionNumber->'+xml);
        return xml;     
    }

    
}