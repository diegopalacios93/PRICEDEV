@isTest
public class etb_ProvisioningRequestTest {

    
    @isTest
    private static void callOMProvisioning() {
        String methodName = 'ProvisioningReq';
        Map<String, Object>inputMap = new Map<String, Object>();
        Map<String, Object>outMap = new Map<String, Object>(); 
        Map<String, Object>options = new Map<String, Object>();
        String Respuesta = '{'+
      '"cliente": {'+
        '"contactos": ['+
          '{'+
            '"tipoContacto": "Tecnico y comercial"'+
          '}'+
        ']'+
      '},'+
      '"items": ['+
        '{'+
          '"accion": "Add"'+
        '}'+
      '],'+
      '"direcciones": ['+
        '{'+
          '"codigoPais": "COLOMBIA",'+
          '"tipoDireccion": "Service",'+
          '"nombreDireccion": "AU 56 H BIS K SUR 90 M BIS L 85467 ESTE CD PARUQE ET CENTRO ET JHGFD AL GFDS B, EL ENCANTO - SUCURSAL ORIGIN 2",'+
          '"idDireccion": "00178000009UH3fAAG"'+
        '}'+
      '],'+
      '"cuentasFacturacion": ['+
        '{'+
          '"correoElectronico": "mjofre@labsxd.com",'+
          '"idDireccionFacturacion": "00178000009UrAkAAK",'+
          '"tipoFactura": "OpenFlex",'+
          '"cuentaPadreFacturacion": "Fernando Valdez",'+
          '"nombreCuentaFacturacion": "avellaneda 1645, EL ENCANTO",'+
          '"idCuentaFacturacion": "00178000009UrAkAAK"'+
        '}'+
      '],'+
      '"datosAdicionales": {'+
        '"oportunidad": "testVenta",'+
        '"valorTotalETB": 22,'+
        '"valorTotalAliado": 0,'+
        '"lineaNegocioPrincipal": "DATOS",'+
        '"duracionMeses": 12,'+
        '"duracionDias": 30,'+
        '"fechaCierre": "2022-04-15"'+
      '},'+
      '"fecha": "2022-04-22T18:34:19.244Z",'+
      '"subTipoTramite": "Oportunidad Especial",'+
     '"tipoSolicitud": "Viabilidad Consultiva",'+
     ' "canal": "Illuminate"'+
   ' }';
        inputMap.put('request',Respuesta);
         inputMap.put('request',Respuesta);
        etb_ProvisioningRequest provi = new etb_ProvisioningRequest();
        provi.invokeMethod(methodName, inputMap, outMap, options);
    }
    
}