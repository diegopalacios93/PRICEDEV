/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  luis Eduardo Mogollon
Proyecto:               Integracion SFDC - RevChain Larga Distancia
Descripci?n:            clase que contiene los metodos para realizar los tramites y envio a facturación
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripci?n
------  ----------  --------------------        ---------------
1.0     26-05-2015  Luis E Mogollon (LEM)       Creacion de la clase..
*******************************************************************************/
public class TramitesLargaDistancia_cls {



/**************************Tramites Cupo***********************************/

public list<string> VentaCupo(OperacionComercial__c OC, PlanLD__c plan,Account cuenta, Boolean blnRequiereCambioPlan, String strCuentaFacturacion, map<string,list<ParametroFacturacion__c>> mapSubPlanesfac)
{
    
    list<string> listcanonicos = new list<string>();
    
    OperacionesLargaDistancia_cls operacion = new OperacionesLargaDistancia_cls();
     
    listcanonicos.add('1.Venta Cupo@**Separator**@'+operacion.creacioncupo(OC, plan, cuenta, strCuentaFacturacion, mapSubPlanesfac));
    listcanonicos.add('2.Cambio Plan lineas@**Separator**@'+operacion.cambiodeplanlinea(OC, plan, cuenta, strCuentaFacturacion, mapSubPlanesfac));
    
    List<string> lstcanonicosCancelarLsp = operacion.cancelarLSP(OC, plan, cuenta, strCuentaFacturacion, mapSubPlanesfac);
    for(string strCanonicoCancelarLsp : lstcanonicosCancelarLsp){
       if(String.isNotBlank(strCanonicoCancelarLsp)){
           listcanonicos.add('3.Cancelar Lineas LSP@**Separator**@'+strCanonicoCancelarLsp);
       }
    }
    
    listcanonicos.add('4.Transferencia Servicios@**Separator**@'+operacion.TransferenciadeServicios(OC, plan, cuenta, strCuentaFacturacion, mapSubPlanesfac));
    listcanonicos.add('5.Venta LSP@**Separator**@'+operacion.VentadeServiciosLSP(OC, plan, cuenta, strCuentaFacturacion, mapSubPlanesfac));
    return listcanonicos;
}


public list<string> RetiroCupo(OperacionComercial__c OC, PlanLD__c plan,Account cuenta, String strCuentaFacturacion, map<string,list<ParametroFacturacion__c>> mapSubPlanesfac)
{

    list<string> listcanonicos = new list<string>();
    OperacionesLargaDistancia_cls operacion = new OperacionesLargaDistancia_cls();
    
    listcanonicos.add('1.Cancelar Cupo@**Separator**@'+operacion.cancelarCupo(OC, plan, cuenta, strCuentaFacturacion, mapSubPlanesfac));
    listcanonicos.add('2.Cambio Plan Lineas@**Separator**@'+operacion.cambiodeplanlinea(OC, plan, cuenta, strCuentaFacturacion, mapSubPlanesfac));
    
    List<string> lstcanonicosCancelarLsp = operacion.cancelarLSP(OC, plan, cuenta, strCuentaFacturacion, mapSubPlanesfac);
    for(string strCanonicoCancelarLsp : lstcanonicosCancelarLsp){
       if(String.isNotBlank(strCanonicoCancelarLsp)){
           listcanonicos.add('3.Cancelar Lineas LSP@**Separator**@'+strCanonicoCancelarLsp);
       }
    }
    
    return listcanonicos;
}

public list<string> RetiroLineasCupo(OperacionComercial__c OC, PlanLD__c plan,Account cuenta, String strCuentaFacturacion, map<string,list<ParametroFacturacion__c>> mapSubPlanesfac)
{
    list<string> listcanonicos = new list<string>();
     OperacionesLargaDistancia_cls operacion = new OperacionesLargaDistancia_cls(); 
     
     listcanonicos.add('1.Cambio Plan Lineas@**Separator**@'+operacion.cambiodeplanlinea(OC, plan, cuenta, strCuentaFacturacion, mapSubPlanesfac));
     //listcanonicos.add(operacion.TransferenciadeServicios(OC, plan, cuenta, strCuentaFacturacion, mapSubPlanesfac));
     
    List<string> lstcanonicosCancelarLsp = operacion.cancelarLSP(OC, plan, cuenta, strCuentaFacturacion, mapSubPlanesfac);
    for(string strCanonicoCancelarLsp : lstcanonicosCancelarLsp){
       if(String.isNotBlank(strCanonicoCancelarLsp)){
           listcanonicos.add('3.Cancelar Lineas LSP@**Separator**@'+strCanonicoCancelarLsp);
       }
    }
    
    return listcanonicos;
}
public list<string> AdicionLineasCupo(OperacionComercial__c OC, PlanLD__c plan,Account cuenta, String strCuentaFacturacion, map<string,list<ParametroFacturacion__c>> mapSubPlanesfac)
{
    
    list<string> listcanonicos = new list<string>();
    
    OperacionesLargaDistancia_cls operacion = new OperacionesLargaDistancia_cls();
     
    listcanonicos.add('1.Cambio Plan Lineas@**Separator**@'+operacion.cambiodeplanlinea(OC, plan, cuenta, strCuentaFacturacion, mapSubPlanesfac));
    
    List<string> lstcanonicosCancelarLsp = operacion.cancelarLSP(OC, plan, cuenta, strCuentaFacturacion, mapSubPlanesfac);
    for(string strCanonicoCancelarLsp : lstcanonicosCancelarLsp){
       if(String.isNotBlank(strCanonicoCancelarLsp)){
           listcanonicos.add('2.Cancelar Lineas LSP@**Separator**@'+strCanonicoCancelarLsp);
       }
    }
    
    listcanonicos.add('3.Transferencia Servicios@**Separator**@'+operacion.TransferenciadeServicios(OC, plan, cuenta, strCuentaFacturacion, mapSubPlanesfac));
    listcanonicos.add('4.Venta LSP@**Separator**@'+operacion.VentadeServiciosLSP(OC, plan, cuenta, strCuentaFacturacion, mapSubPlanesfac));
     
    return listcanonicos;
}
public list<string> cambioplanCupo(OperacionComercial__c OC, PlanLD__c plan, PlanLD__c planAnterior, Account cuenta, String strCuentaFacturacion, map<string,list<ParametroFacturacion__c>> mapSubPlanesfac)
{
    
    list<string> listcanonicos = new list<string>();
    
    OperacionesLargaDistancia_cls operacion = new OperacionesLargaDistancia_cls();
    
    listcanonicos.add('1.Cambio Plan Cupo@**Separator**@'+operacion.cambioPlanCupo(OC, plan, planAnterior, cuenta, strCuentaFacturacion, mapSubPlanesfac));
    listcanonicos.add('2.Cambio Plan Lineas@**Separator**@'+operacion.cambiodeplanlinea(OC, plan, cuenta, strCuentaFacturacion, mapSubPlanesfac));    
    
    /* BEGIN - Manuel Medina - Proceso de cancelacion y venta del cupo para lineas LSP - 30102015 */
    List<string> lstcanonicosCancelarLsp = operacion.cancelarLSP(OC, planAnterior, cuenta, strCuentaFacturacion, mapSubPlanesfac);
    for(string strCanonicoCancelarLsp : lstcanonicosCancelarLsp){
       if(String.isNotBlank(strCanonicoCancelarLsp)){
           listcanonicos.add('3.Cancelar Lineas LSP@**Separator**@'+strCanonicoCancelarLsp);
       }
    }
    listcanonicos.add('4.Venta LSP@**Separator**@'+operacion.VentadeServiciosLSP(OC, plan, cuenta, strCuentaFacturacion, mapSubPlanesfac));
    /* END - Manuel Medina - Proceso de cancelacion y venta del cupo para lineas LSP - 30102015 */
    
    return listcanonicos;
}



/**************************Tramites Convenio Voz***********************************/

public list<string> VentaConvenio(OperacionComercial__c OC, PlanLD__c plan,Account cuenta, String strCuentaFacturacion, map<string,list<ParametroFacturacion__c>> mapSubPlanesfac)
{
    list<string> listcanonicos = new list<string>();
     OperacionesLargaDistancia_cls operacion = new OperacionesLargaDistancia_cls();
    listcanonicos.add('1.Cambio Plan Lineas@**Separator**@'+operacion.cambiodeplanlinea(OC, plan, cuenta, strCuentaFacturacion, mapSubPlanesfac));
    
    /* BEGIN - Manuel Medina - Implementacion de la creacion de una cuenta de facturacion para la venta de convenios de voz a lineas LSP - 03112015 */
    List<string> lstcanonicosCancelarLsp = operacion.cancelarLSP(OC, plan, cuenta, strCuentaFacturacion, mapSubPlanesfac);
    for(string strCanonicoCancelarLsp : lstcanonicosCancelarLsp){
       if(String.isNotBlank(strCanonicoCancelarLsp)){
           listcanonicos.add('2.Cancelar Lineas LSP@**Separator**@'+strCanonicoCancelarLsp);
       }
    }
    /* END - Manuel Medina - Implementacion de la creacion de una cuenta de facturacion para la venta de convenios de voz a lineas LSP - 03112015 */
    
    List<string> lstcanonicosVentaLsp = operacion.VentadeServiciosLSPVoz(OC, plan, cuenta, strCuentaFacturacion, mapSubPlanesfac);
    for(string strCanonicoVentaLsp : lstcanonicosVentaLsp){
       if(String.isNotBlank(strCanonicoVentaLsp)){
           listcanonicos.add('3.Venta LSP@**Separator**@'+strCanonicoVentaLsp);
       }
    }
    return listcanonicos;
}

public list<string> cambioplanconvenio(OperacionComercial__c OC, PlanLD__c plan,Account cuenta, String strCuentaFacturacion, map<string,list<ParametroFacturacion__c>> mapSubPlanesfac)
{
    list<string> listcanonicos = new list<string>();
    OperacionesLargaDistancia_cls operacion = new OperacionesLargaDistancia_cls();
    listcanonicos.add('1.Cambio Plan Lineas@**Separator**@'+operacion.cambiodeplanlinea(OC, plan, cuenta, strCuentaFacturacion, mapSubPlanesfac));
    
    /* BEGIN - Manuel Medina - Cancelacion y venta de Convenio de Voz para lineas LSP - 11112015 */
    List<string> lstcanonicosCancelarLsp = operacion.cancelarLSP(OC, plan, cuenta, strCuentaFacturacion, mapSubPlanesfac);
    for(string strCanonicoCancelarLsp : lstcanonicosCancelarLsp){
       if(String.isNotBlank(strCanonicoCancelarLsp)){
           listcanonicos.add('2.Cancelar Lineas LSP@**Separator**@'+strCanonicoCancelarLsp);
       }
    }
    
    List<string> lstcanonicosVentaLsp = operacion.VentadeServiciosLSPVoz(OC, plan, cuenta, strCuentaFacturacion, mapSubPlanesfac);
    for(string strCanonicoVentaLsp : lstcanonicosVentaLsp){
       if(String.isNotBlank(strCanonicoVentaLsp)){
           listcanonicos.add('3.Venta LSP@**Separator**@'+strCanonicoVentaLsp);
       }
    }
    /* END - Manuel Medina - Cancelacion y venta de Convenio de Voz para lineas LSP - 11112015 */
    
    return listcanonicos;
}

public list<string> RetiroConvenio(OperacionComercial__c OC, PlanLD__c plan,Account cuenta, String strCuentaFacturacion, map<string,list<ParametroFacturacion__c>> mapSubPlanesfac)
{
    list<string> listcanonicos = new list<string>();
     OperacionesLargaDistancia_cls operacion = new OperacionesLargaDistancia_cls();

     listcanonicos.add('1.Cambio Plan Lineas@**Separator**@'+operacion.cambiodeplanlinea(OC, plan, cuenta, strCuentaFacturacion, mapSubPlanesfac));
     
    List<string> lstcanonicosCancelarLsp = operacion.cancelarLSP(OC, plan, cuenta, strCuentaFacturacion, mapSubPlanesfac);
    for(string strCanonicoCancelarLsp : lstcanonicosCancelarLsp){
       if(String.isNotBlank(strCanonicoCancelarLsp)){
           listcanonicos.add('2.Cancelar Lineas LSP@**Separator**@'+strCanonicoCancelarLsp);
       }
    }
    
    return listcanonicos;
}

public list<string> RetiroLineasConvenio(OperacionComercial__c OC, PlanLD__c plan,Account cuenta, String strCuentaFacturacion, map<string,list<ParametroFacturacion__c>> mapSubPlanesfac)
{
    list<string> listcanonicos = new list<string>();
     OperacionesLargaDistancia_cls operacion = new OperacionesLargaDistancia_cls(); 
     
     listcanonicos.add('1.Cambio Plan Lineas@**Separator**@'+operacion.cambiodeplanlinea(OC, plan, cuenta, strCuentaFacturacion, mapSubPlanesfac));

    List<string> lstcanonicosCancelarLsp = operacion.cancelarLSP(OC, plan, cuenta, strCuentaFacturacion, mapSubPlanesfac);
    for(string strCanonicoCancelarLsp : lstcanonicosCancelarLsp){
       if(String.isNotBlank(strCanonicoCancelarLsp)){
           listcanonicos.add('2.Cancelar Lineas LSP@**Separator**@'+strCanonicoCancelarLsp);
       }
    }
    
    return listcanonicos;
}
public list<string> AdicionLineasConvenio(OperacionComercial__c OC, PlanLD__c plan,Account cuenta, String strCuentaFacturacion, map<string,list<ParametroFacturacion__c>> mapSubPlanesfac)
{
    
    list<string> listcanonicos = new list<string>();
    
    OperacionesLargaDistancia_cls operacion = new OperacionesLargaDistancia_cls();
     
    listcanonicos.add('1.Cambio Plan Lineas@**Separator**@'+operacion.cambiodeplanlinea(OC, plan, cuenta, strCuentaFacturacion, mapSubPlanesfac));
    List<string> lstcanonicosCancelarLsp = operacion.cancelarLSP(OC, plan, cuenta, strCuentaFacturacion, mapSubPlanesfac);
    for(string strCanonicoCancelarLsp : lstcanonicosCancelarLsp){
       if(String.isNotBlank(strCanonicoCancelarLsp)){
           listcanonicos.add('2.Cancelar Lineas LSP@**Separator**@'+strCanonicoCancelarLsp);
       }
    }
    
    List<string> lstcanonicosVentaLsp = operacion.VentadeServiciosLSPVoz(OC, plan, cuenta, strCuentaFacturacion, mapSubPlanesfac);
    for(string strCanonicoVentaLsp : lstcanonicosVentaLsp){
       if(String.isNotBlank(strCanonicoVentaLsp)){
           listcanonicos.add('3.Venta LSP@**Separator**@'+strCanonicoVentaLsp);
       }
    }
     
    return listcanonicos;
}


}