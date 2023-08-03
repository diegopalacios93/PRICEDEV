/******************************************************************************* 
Desarrollado por:		Avanxo Colombia
Autor:					Luis Rafael penaranda
Proyecto:				ETB - Integracion RevChain
Descripcion:			Clase que arma el Canonico de RevChain
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripci?n
------  ----------  --------------------        ---------------
2.0     25-11-2014  Luis Penaranda (LRP)       Creacion de la clase
1.1     26-11-2015  Luis Penaranda (LRP)       Adición de lógica para Cambio de Plan
1.2     09-02-2016  Andrés Garrido (AG)        Adición de lógica para los nuevos tramites Fase II
3.0     09-08-2018  Javier Acero   (JA)        Adición de lógica para INI9685
****************************************************************************/

public  class LTE_ConstruccionCanonico_cls {


public set<id> planes;
public Contact repLegal;
public set<String> setIdServAdic = new set<String>();
public list<LTE_NivelesDescuento__c> listNivDescDetOferta = null; 
public map<string,LTE_DetalleOferta__c> mapDetOfertas;

    public LTE_ConstruccionCanonico_cls(){
        BanderasEjecucion.setEjecucion('ValidarPerfilesReglasOC');
    }
    
// ----------------------------------------------------------
// Facturar las OC de Cambio de Número PVTA AG - 2016-02-03 
// ----------------------------------------------------------
public string SalesOrderLineCambioNumero(OperacionComercial__c OC, ActivoETB__c objServicios, list<LTE_SpecificationGroupXA__c> lstXas, ActivoETB__c detServicio, LTE_DetalleOferta__c objDetOferta)
{

	//es un string
	String IdSalesorderLine;
	LTE_Servicios_adicionales__c objSalesORderLine;
	string xml='';
	string nombreplan='';

	system.debug('Oc.Id.size-->'+Oc.Id);
	system.debug('objServicios-->'+objServicios);

	
    if(objServicios!=null){
		system.debug('objServicios-Entro->'+objServicios); 
				
		//Generar el regsitro de SalesOrderLine.
		for(LTE_Servicios_adicionales__c objServAdic: 	objServicios.Servicios_adicionales__r){
			if(objServAdic.Name.equals(VariablesGlobales__c.getInstance('NombreComercialLTE').Valor__c)){
				xml+=LTE_RevchainXML_cls.SalesOrderLine(OC,objServAdic);
				objSalesORderLine=objServAdic;
			}		
		}
		
		system.debug('objServicios-Entro-1->'+objServicios);
		//  Generar los Suplementary Info.
		for(LTE_Servicios_adicionales__c objServAdic: 	objServicios.Servicios_adicionales__r){
			nombreplan='';
			if(!objServAdic.Name.equals(VariablesGlobales__c.getInstance('NombreComercialLTE').Valor__c)){
				system.debug('objServAdic-Entro-2->'+objServAdic);
				system.debug('objSalesORderLine-Entro-2->'+objSalesORderLine);
				system.debug('objServicios-Entro-2->'+objServicios);
				system.debug('OC-Entro-2->'+OC);
				
				//armar los suplementaryInfo
				xml+=LTE_RevchainXML_cls.SupplementaryInfo(OC,objServAdic,lstXas,objSalesORderLine.Id);							
				for(LTE_SpecificationGroupXA__c objXas: lstXas){
					if(objXas.LTE_ServiciosAdicionales__c==objServAdic.Id){
						if(objXas.Name.Contains('RVC PARM')){ // solo se tienen en cuenta los parametros de facturacion cuyo Name contema la cadena RVC PARM
							xml+=parametro(objXas);
						}
						if(objXas.Name.Contains('RVC PLN')){ // solo se tienen en cuenta los parametros de facturacion cuyo Name contema la cadena RVC PARM
							if(objServAdic.LTE_PrimaryClassificationCode__c	!=	'LTE Number Class' 	&&
							   objServAdic.LTE_PrimaryClassificationCode__c	!=	'LTE Simcard Class' &&
							   objServAdic.LTE_PrimaryClassificationCode__c	!=	'CLASE RVC LTE 1' 	&&
							   objServAdic.LTE_PrimaryClassificationCode__c	!=	'CLASE RVC LTE 2' 	&&
							   objServAdic.LTE_PrimaryClassificationCode__c	!=	'LTE Customer Equipment Class'  ){
							   	system.debug('objServAdic.LTE_PrimaryClassificationCode__c-->'+objServAdic.LTE_PrimaryClassificationCode__c);
							   	system.debug('Entre-Nombre-Plan-->'+objXas.LTE_Value__c);
								nombreplan=objXas.LTE_Value__c;
							}
							
						}
					}
					
				}
	
				system.debug('Nombre-Plan-->'+nombreplan);
				xml+=LTE_RevchainXML_cls.rateplan(nombreplan);
				xml+='</SupplementaryInfo>';
					
			}
		}
		//anadir connection
		xml+=LTE_RevchainXML_cls.Connection(OC); 
		
		//agregar discounts
		xml+='<Discounts>';
		//xml+=LTE_RevchainXML_cls.Discounts(lstXas,objSalesORderLine,objDetOferta); 
		xml+='</Discounts>';
		
		//agregar specificationgroupXA
		xml+=LTE_RevchainXML_cls.getAllSpecificationGroupXA(OC,null,lstXas,objServicios,objSalesORderLine.id); 

		//agregar Cusston2
		xml+=LTE_RevchainXML_cls.Custom2(OC);
				 
		//agregar Altkeyscimal valorEquiposFinanciados,ActivoETB__c  	objServicios)
		xml+=LTE_RevchainXML_cls.AltKey(OC,lstXas,objSalesORderLine.id,0, detServicio,null);

		
		//agregar Cusston2 
		//xml+=LTE_RevchainXML_cls.Billing();
		
		xml+='</SalesOrderLine>';
    }
	return xml;
	
}

// ----------------------------------------------------------
// Facturar las OC de Suspensión y Reconexión Voluntaria AG - 2016-02-03 
// ----------------------------------------------------------
public string SalesOrderLineSuspRecoVol(OperacionComercial__c OC, ActivoETB__c objServicios, list<LTE_SpecificationGroupXA__c> lstXas, ActivoETB__c detServicio, LTE_DetalleOferta__c objDetOferta)
{

	//es un string
	String IdSalesorderLine;
	LTE_Servicios_adicionales__c objSalesORderLine;
	string xml='';
	string nombreplan='';

	system.debug('Oc.Id.size-->'+Oc.Id);
	system.debug('objServicios-->'+objServicios);

	
    if(objServicios!=null){
		system.debug('objServicios-Entro->'+objServicios); 
				
		//Generar el regsitro de SalesOrderLine.
		for(LTE_Servicios_adicionales__c objServAdic: 	objServicios.Servicios_adicionales__r){
			if(objServAdic.Name.equals(VariablesGlobales__c.getInstance('NombreComercialLTE').Valor__c)){
				xml+=LTE_RevchainXML_cls.SalesOrderLine(OC,objServAdic);
				objSalesORderLine=objServAdic;
			}		
		}
		
		system.debug('objServicios-Entro-1->'+objServicios);
		//  Generar los Suplementary Info.
		for(LTE_Servicios_adicionales__c objServAdic: 	objServicios.Servicios_adicionales__r){
			nombreplan='';
			if(!objServAdic.Name.equals(VariablesGlobales__c.getInstance('NombreComercialLTE').Valor__c)){
				system.debug('objServAdic-Entro-2->'+objServAdic);
				system.debug('objSalesORderLine-Entro-2->'+objSalesORderLine);
				system.debug('objServicios-Entro-2->'+objServicios);
				system.debug('OC-Entro-2->'+OC);
				
				//armar los suplementaryInfo
				xml+=LTE_RevchainXML_cls.SupplementaryInfo(OC,objServAdic,lstXas,objSalesORderLine.Id);							
				for(LTE_SpecificationGroupXA__c objXas: lstXas){
					if(objXas.LTE_ServiciosAdicionales__c==objServAdic.Id){
						if(objXas.Name.Contains('RVC PARM')){ // solo se tienen en cuenta los parametros de facturacion cuyo Name contema la cadena RVC PARM
							xml+=parametro(objXas);
						}
						if(objXas.Name.Contains('RVC PLN')){ // solo se tienen en cuenta los parametros de facturacion cuyo Name contema la cadena RVC PARM
							if(objServAdic.LTE_PrimaryClassificationCode__c	!=	'LTE Number Class' 	&&
							   objServAdic.LTE_PrimaryClassificationCode__c	!=	'LTE Simcard Class' &&
							   objServAdic.LTE_PrimaryClassificationCode__c	!=	'CLASE RVC LTE 1' 	&&
							   objServAdic.LTE_PrimaryClassificationCode__c	!=	'CLASE RVC LTE 2' 	&&
							   objServAdic.LTE_PrimaryClassificationCode__c	!=	'LTE Customer Equipment Class'  ){
							   	system.debug('objServAdic.LTE_PrimaryClassificationCode__c-->'+objServAdic.LTE_PrimaryClassificationCode__c);
							   	system.debug('Entre-Nombre-Plan-->'+objXas.LTE_Value__c);
								nombreplan=objXas.LTE_Value__c;
							}
							
						}
					}
					
				}
	
				system.debug('Nombre-Plan-->'+nombreplan);
				xml+=LTE_RevchainXML_cls.rateplan(nombreplan);
				xml+='</SupplementaryInfo>';
					
			}
		}
		//anadir connection
		xml+=LTE_RevchainXML_cls.Connection(OC); 
		
		//agregar discounts
		xml+='<Discounts>';
		xml+=LTE_RevchainXML_cls.DiscountsRetiro(lstXas,objSalesORderLine,objServicios);
		xml+='</Discounts>';
		
		//agregar specificationgroupXA
		xml+=LTE_RevchainXML_cls.getAllSpecificationGroupXA(OC,null,lstXas,objServicios,objSalesORderLine.id); 

		//agregar Cusston2
		xml+=LTE_RevchainXML_cls.Custom2(OC);
				 
		//agregar Altkeyscimal valorEquiposFinanciados,ActivoETB__c  	objServicios)
		xml+=LTE_RevchainXML_cls.AltKey(OC,lstXas,objSalesORderLine.id,0, detServicio,null);

		
		//agregar Cusston2 
		//xml+=LTE_RevchainXML_cls.Billing();
		
		xml+='</SalesOrderLine>';
    }
	return xml;
	
}

// ----------------------------------------------------------
// Facturar las OC de Adición y Retiro de SVAs AG - 2016-02-03 
// ----------------------------------------------------------
public string SalesOrderLineAdicionRetiroSVA(OperacionComercial__c OC, ActivoETB__c objServicios, list<LTE_SpecificationGroupXA__c> lstXas, ActivoETB__c detServicio, LTE_DetalleOferta__c objDetOferta)
{

	//es un string
	String IdSalesorderLine;
	LTE_Servicios_adicionales__c objSalesORderLine;
	string xml='';
	string nombreplan='';

	system.debug('Oc.Id.size-->'+Oc.Id);
	system.debug('objServicios-->'+objServicios);

	
    if(objServicios!=null){
		system.debug('objServicios-Entro->'+objServicios); 
				
		//Generar el regsitro de SalesOrderLine.
		for(LTE_Servicios_adicionales__c objServAdic: 	objServicios.Servicios_adicionales__r){
			if(objServAdic.Name.equals(VariablesGlobales__c.getInstance('NombreComercialLTE').Valor__c)){
				xml+=LTE_RevchainXML_cls.SalesOrderLine(OC,objServAdic);
				objSalesORderLine=objServAdic;
			}		
		}
		
		system.debug('objServicios-Entro-1->'+objServicios);
		//  Generar los Suplementary Info.
		for(LTE_Servicios_adicionales__c objServAdic: 	objServicios.Servicios_adicionales__r){
			nombreplan='';
			if(!objServAdic.Name.equals(VariablesGlobales__c.getInstance('NombreComercialLTE').Valor__c)){
				system.debug('objServAdic-Entro-2->'+objServAdic);
				system.debug('objSalesORderLine-Entro-2->'+objSalesORderLine);
				system.debug('objServicios-Entro-2->'+objServicios);
				system.debug('OC-Entro-2->'+OC);
				
				//armar los suplementaryInfo
				xml+=LTE_RevchainXML_cls.SupplementaryInfo(OC,objServAdic,lstXas,objSalesORderLine.Id);							
				for(LTE_SpecificationGroupXA__c objXas: lstXas){
					if(objXas.LTE_ServiciosAdicionales__c==objServAdic.Id){
						if(objXas.Name.Contains('RVC PARM')){ // solo se tienen en cuenta los parametros de facturacion cuyo Name contema la cadena RVC PARM
							xml+=parametro(objXas);
						}
						if(objXas.Name.Contains('RVC PLN')){ // solo se tienen en cuenta los parametros de facturacion cuyo Name contema la cadena RVC PARM
							if(objServAdic.LTE_PrimaryClassificationCode__c	!=	'LTE Number Class' 	&&
							   objServAdic.LTE_PrimaryClassificationCode__c	!=	'LTE Simcard Class' &&
							   objServAdic.LTE_PrimaryClassificationCode__c	!=	'CLASE RVC LTE 1' 	&&
							   objServAdic.LTE_PrimaryClassificationCode__c	!=	'CLASE RVC LTE 2' 	&&
							   objServAdic.LTE_PrimaryClassificationCode__c	!=	'LTE Customer Equipment Class'  ){
							   	system.debug('objServAdic.LTE_PrimaryClassificationCode__c-->'+objServAdic.LTE_PrimaryClassificationCode__c);
							   	system.debug('Entre-Nombre-Plan-->'+objXas.LTE_Value__c);
								nombreplan=objXas.LTE_Value__c;
							}
							
						}
					}
					
				}
	
				system.debug('Nombre-Plan-->'+nombreplan);
				xml+=LTE_RevchainXML_cls.rateplan(nombreplan);
				xml+='</SupplementaryInfo>';
					
			}
		}
		//anadir connection
		xml+=LTE_RevchainXML_cls.Connection(OC); 
		
		//agregar discounts
		xml+='<Discounts>';
        if(oc.TOPP__r.TipodeOperacionporplan__c   ==  'Adición SVA')
			xml+=LTE_RevchainXML_cls.DiscountsAdicionSVA(lstXas,objSalesORderLine,oc);
        else
            xml+=LTE_RevchainXML_cls.DiscountsRetiro(lstXas,objSalesORderLine,objServicios);
		xml+='</Discounts>';
		
		//agregar specificationgroupXA
		xml+=LTE_RevchainXML_cls.getAllSpecificationGroupXA(OC,null,lstXas,objServicios,objSalesORderLine.id); 

		//agregar Cusston2
		xml+=LTE_RevchainXML_cls.Custom2(OC);
				 
		//agregar Altkeyscimal valorEquiposFinanciados,ActivoETB__c  	objServicios)
		xml+=LTE_RevchainXML_cls.AltKey(OC,lstXas,objSalesORderLine.id,0, detServicio,null);

		
		//agregar Cusston2 
		//xml+=LTE_RevchainXML_cls.Billing();
		
		xml+='</SalesOrderLine>';
    }
	return xml;
	
}

// ----------------------------------------------------------
// Facturar las OC de Modificacion Servicio JG - 2020-03-16 
// ----------------------------------------------------------
public string SalesOrderLineModificacionServicio(OperacionComercial__c OC, ActivoETB__c objServicios, list<LTE_SpecificationGroupXA__c> lstXas, ActivoETB__c detServicio, LTE_DetalleOferta__c objDetOferta)
{

	//es un string
	String IdSalesorderLine;
	LTE_Servicios_adicionales__c objSalesORderLine;
	string xml='';
	string nombreplan='';

	system.debug('Oc.Id.size-->'+Oc.Id);
	system.debug('objServicios-->'+objServicios);

	
    if(objServicios!=null){
		system.debug('objServicios-Entro->'+objServicios);
				
		//Generar el regsitro de SalesOrderLine.
		for(LTE_Servicios_adicionales__c objServAdic: 	objServicios.Servicios_adicionales__r){
			if(objServAdic.Name.equals(VariablesGlobales__c.getInstance('NombreComercialLTE').Valor__c)){
				xml+=LTE_RevchainXML_cls.SalesOrderLine(OC,objServAdic);
				objSalesORderLine=objServAdic;
			}		
		}
		
		system.debug('objServicios-Entro-1->'+objServicios);
		//  Generar los Suplementary Info.
		for(LTE_Servicios_adicionales__c objServAdic: 	objServicios.Servicios_adicionales__r){
			nombreplan='';
			if(!objServAdic.Name.equals(VariablesGlobales__c.getInstance('NombreComercialLTE').Valor__c)){
				system.debug('objServAdic-Entro-2->'+objServAdic);
				system.debug('objSalesORderLine-Entro-2->'+objSalesORderLine);
				system.debug('objServicios-Entro-2->'+objServicios);
				system.debug('OC-Entro-2->'+OC);
				
				//armar los suplementaryInfo
				xml+=LTE_RevchainXML_cls.SupplementaryInfo(OC,objServAdic,lstXas,objSalesORderLine.Id);							
				for(LTE_SpecificationGroupXA__c objXas: lstXas){
					if(objXas.LTE_ServiciosAdicionales__c==objServAdic.Id){
						if(objXas.Name.Contains('RVC PARM')){ // solo se tienen en cuenta los parametros de facturacion cuyo Name contema la cadena RVC PARM
							xml+=parametro(objXas);
						}
						if(objXas.Name.Contains('RVC PLN')){ // solo se tienen en cuenta los parametros de facturacion cuyo Name contema la cadena RVC PARM
							if(objServAdic.LTE_PrimaryClassificationCode__c	!=	'LTE Number Class' 	&&
							   objServAdic.LTE_PrimaryClassificationCode__c	!=	'LTE Simcard Class' &&
							   objServAdic.LTE_PrimaryClassificationCode__c	!=	'CLASE RVC LTE 1' 	&&
							   objServAdic.LTE_PrimaryClassificationCode__c	!=	'CLASE RVC LTE 2' 	&&
							   objServAdic.LTE_PrimaryClassificationCode__c	!=	'LTE Customer Equipment Class'  ){
							   	system.debug('objServAdic.LTE_PrimaryClassificationCode__c-->'+objServAdic.LTE_PrimaryClassificationCode__c);
							   	system.debug('Entre-Nombre-Plan-->'+objXas.LTE_Value__c);
								nombreplan=objXas.LTE_Value__c;
							}
							
						}
					}
					
				}
	
				system.debug('Nombre-Plan-->'+nombreplan);
				xml+=LTE_RevchainXML_cls.rateplan(nombreplan);
				xml+='</SupplementaryInfo>';
					
			}
		}
		//anadir connection
		xml+=LTE_RevchainXML_cls.Connection(OC); 
		
		//agregar discounts
		xml+='<Discounts>';
		xml+=LTE_RevchainXML_cls.DiscountsRetiro(lstXas,objSalesORderLine,objServicios);
		xml+='</Discounts>';
		
		//agregar specificationgroupXA
		xml+=LTE_RevchainXML_cls.getAllSpecificationGroupXA(OC,null,lstXas,objServicios,objSalesORderLine.id); 

		//agregar Cusston2
		xml+=LTE_RevchainXML_cls.Custom2(OC);
				 
		//agregar Altkeyscimal valorEquiposFinanciados,ActivoETB__c  	objServicios)
		xml+=LTE_RevchainXML_cls.AltKey(OC,lstXas,objSalesORderLine.id,0, detServicio,null);

		
		//agregar Cusston2 
		//xml+=LTE_RevchainXML_cls.Billing();
		
		xml+='</SalesOrderLine>';
    }
	return xml;
	
}


// ----------------------------------------------------------
// Facturar las OC de Cambio de Plan PVTA LRPA - 26-11-2015 
// ----------------------------------------------------------
public string SalesOrderCambioPlan(OperacionComercial__c OC,ActivoETB__c  	objServicios,list<LTE_SpecificationGroupXA__c> lstXas, ActivoETB__c detServicio,LTE_DetalleOferta__c 	objDetOferta)
{
	
	//es un string
	String IdSalesorderLine;
	LTE_Servicios_adicionales__c objSalesORderLine;
	string xml='';
	string nombreplan='';

	system.debug('Oc.Id.size-->'+Oc.Id);
	system.debug('objServicios-->'+objServicios);

	
    if(objServicios!=null){
		system.debug('objServicios-Entro->'+objServicios); 
				
		//Generar el regsitro de SalesOrderLine.
		for(LTE_Servicios_adicionales__c objServAdic: 	objServicios.Servicios_adicionales__r)
		{
			if(objServAdic.Name.equals(VariablesGlobales__c.getInstance('NombreComercialLTE').Valor__c)){
				xml+=LTE_RevchainXML_cls.SalesOrderLine(OC,objServAdic);
				objSalesORderLine=objServAdic;
			}		
		}
		
		system.debug('objServicios-Entro-1->'+objServicios);
		//  Generar los Suplementary Info.
		for(LTE_Servicios_adicionales__c objServAdic: 	objServicios.Servicios_adicionales__r)
		{
			nombreplan='';
			if(!objServAdic.Name.equals(VariablesGlobales__c.getInstance('NombreComercialLTE').Valor__c))
			{
				system.debug('objServAdic-Entro-2->'+objServAdic);
				system.debug('objSalesORderLine-Entro-2->'+objSalesORderLine);
				system.debug('objServicios-Entro-2->'+objServicios);
				system.debug('OC-Entro-2->'+OC);
				
				//armar los suplementaryInfo
				xml+=LTE_RevchainXML_cls.SupplementaryInfo(OC,objServAdic,lstXas,objSalesORderLine.Id);							
				for(LTE_SpecificationGroupXA__c objXas: lstXas)
					{
						if(objXas.LTE_ServiciosAdicionales__c==objServAdic.Id){
							if(objXas.Name.Contains('RVC PARM')){ // solo se tienen en cuenta los parametros de facturacion cuyo Name contema la cadena RVC PARM
								xml+=parametro(objXas);
							}
							if(objXas.Name.Contains('RVC PLN')){ // solo se tienen en cuenta los parametros de facturacion cuyo Name contema la cadena RVC PARM
								if(objServAdic.LTE_PrimaryClassificationCode__c	!=	'LTE Number Class' 	&&
								   objServAdic.LTE_PrimaryClassificationCode__c	!=	'LTE Simcard Class' &&
								   objServAdic.LTE_PrimaryClassificationCode__c	!=	'CLASE RVC LTE 1' 	&&
								   objServAdic.LTE_PrimaryClassificationCode__c	!=	'CLASE RVC LTE 2' 	&&
								   objServAdic.LTE_PrimaryClassificationCode__c	!=	'LTE Customer Equipment Class'  ){
								   	system.debug('objServAdic.LTE_PrimaryClassificationCode__c-->'+objServAdic.LTE_PrimaryClassificationCode__c);
								   	system.debug('Entre-Nombre-Plan-->'+objXas.LTE_Value__c);
									nombreplan=objXas.LTE_Value__c;
								}
								
							}
						}
						
					}
	
					system.debug('Nombre-Plan-->'+nombreplan);
					xml+=LTE_RevchainXML_cls.rateplan(nombreplan);
					xml+='</SupplementaryInfo>';
					
			}
		}
		//anadir connection
		xml+=LTE_RevchainXML_cls.Connection(OC); 
		
		//agregar discounts
		xml+='<Discounts>';
		xml+=LTE_RevchainXML_cls.Discounts(lstXas,objSalesORderLine,objDetOferta); 
		xml+='</Discounts>';
		
		//agregar specificationgroupXA
		xml+=LTE_RevchainXML_cls.getAllSpecificationGroupXA(OC,null,lstXas,objServicios,objSalesORderLine.id); 

		//agregar Cusston2
		xml+=LTE_RevchainXML_cls.Custom2(OC);
				 
		//agregar Altkeyscimal valorEquiposFinanciados,ActivoETB__c  	objServicios)
		xml+=LTE_RevchainXML_cls.AltKey(OC,lstXas,objSalesORderLine.id,0, detServicio,null);

		
		//agregar Cusston2 
		//xml+=LTE_RevchainXML_cls.Billing();
		
		xml+='</SalesOrderLine>';
    }
	return xml;
	
}


public string SalesOrderLineRetiro(OperacionComercial__c OC,ActivoETB__c  	objServicios,list<LTE_SpecificationGroupXA__c> lstXas, ActivoETB__c detServicio,LTE_DetalleOferta__c 	objDetOferta)
{

	//es un string
	String IdSalesorderLine;
	LTE_Servicios_adicionales__c objSalesORderLine;
	string xml='';
	string nombreplan='';

	system.debug('Oc.Id.size-->'+Oc.Id);
	system.debug('objServicios-->'+objServicios);

	
    if(objServicios!=null){
		system.debug('objServicios-Entro->'+objServicios); 
				
		//Generar el regsitro de SalesOrderLine.
		for(LTE_Servicios_adicionales__c objServAdic: 	objServicios.Servicios_adicionales__r)
		{
			if(objServAdic.Name.equals(VariablesGlobales__c.getInstance('NombreComercialLTE').Valor__c)){
				xml+=LTE_RevchainXML_cls.SalesOrderLine(OC,objServAdic);
				objSalesORderLine=objServAdic;
			}		
		}
		
		system.debug('objServicios-Entro-1->'+objServicios);
		//  Generar los Suplementary Info.
		for(LTE_Servicios_adicionales__c objServAdic: 	objServicios.Servicios_adicionales__r)
		{
			nombreplan='';
			if(!objServAdic.Name.equals(VariablesGlobales__c.getInstance('NombreComercialLTE').Valor__c))
			{
				system.debug('objServicios-Entro-2->'+objServicios);
				
				//armar los suplementaryInfo
				xml+=LTE_RevchainXML_cls.SupplementaryInfo(OC,objServAdic,lstXas,objSalesORderLine.Id);							
				for(LTE_SpecificationGroupXA__c objXas: lstXas)
					{
						if(objXas.LTE_ServiciosAdicionales__c==objServAdic.Id){
							if(objXas.Name.Contains('RVC PARM')){ // solo se tienen en cuenta los parametros de facturacion cuyo Name contema la cadena RVC PARM
								xml+=parametro(objXas);
							}
							if(objXas.Name.Contains('RVC PLN')){ // solo se tienen en cuenta los parametros de facturacion cuyo Name contema la cadena RVC PARM
								if(objServAdic.LTE_PrimaryClassificationCode__c	!=	'LTE Number Class' 	&&
								   objServAdic.LTE_PrimaryClassificationCode__c	!=	'LTE Simcard Class' &&
								   objServAdic.LTE_PrimaryClassificationCode__c	!=	'CLASE RVC LTE 1' 	&&
								   objServAdic.LTE_PrimaryClassificationCode__c	!=	'CLASE RVC LTE 2' 	&&
								   objServAdic.LTE_PrimaryClassificationCode__c	!=	'LTE Customer Equipment Class'  ){
								   	system.debug('objServAdic.LTE_PrimaryClassificationCode__c-->'+objServAdic.LTE_PrimaryClassificationCode__c);
								   	system.debug('Entre-Nombre-Plan-->'+objXas.LTE_Value__c);
									nombreplan=objXas.LTE_Value__c;
								}
								
							}
						}
						
					}
	
					system.debug('Nombre-Plan-->'+nombreplan);
					xml+=LTE_RevchainXML_cls.rateplan(nombreplan);
					xml+='</SupplementaryInfo>';
					
			}
		}
		//anadir connection
		xml+=LTE_RevchainXML_cls.Connection(OC); 
		
		//agregar discounts
		xml+='<Discounts>';
		//xml+=LTE_RevchainXML_cls.DiscountsRetiro(lstXas,objSalesORderLine,objServicios); 
		xml+='</Discounts>';
		
		//agregar specificationgroupXA
		xml+=LTE_RevchainXML_cls.getAllSpecificationGroupXA(OC,null,lstXas,objServicios,objSalesORderLine.id); 

		//agregar Cusston2
		xml+=LTE_RevchainXML_cls.Custom2(OC);
				 
		//agregar Altkeyscimal valorEquiposFinanciados,ActivoETB__c  	objServicios)
		xml+=LTE_RevchainXML_cls.AltKey(OC,lstXas,objSalesORderLine.id,0, detServicio,null);

		
		//agregar Cusston2 
		//xml+=LTE_RevchainXML_cls.Billing();
		
		xml+='</SalesOrderLine>';
    }
	return xml;
	
}


public string SalesOrderLineEquipos(OperacionComercial__c OC,ActivoETB__c  	objServicios,list<LTE_SpecificationGroupXA__c> lstXas,Decimal valorEquiposFinanciados, ActivoETB__c detServicio)
{
	//es un string
	system.debug('valorEquiposFinanciados-3->'+valorEquiposFinanciados);
	String IdSalesorderLine;
	LTE_Servicios_adicionales__c objSalesORderLine;
	string xml='';
	string nombreplan='';

	system.debug('Oc.Id.size-->'+Oc.Id);
	system.debug('objServicios-->'+objServicios);

    if(objServicios!=null){
		system.debug('objServicios-Entro->'+objServicios); 
				
		//Generar el regsitro de SalesOrderLine.
		for(LTE_Servicios_adicionales__c objServAdic: 	objServicios.Servicios_adicionales__r)
		{
			if(objServAdic.Name.equals(VariablesGlobales__c.getInstance('NombreComercialLTE').Valor__c)){
				xml+=LTE_RevchainXML_cls.SalesOrderLine(OC,objServAdic);
				objSalesORderLine=objServAdic;
			}		
		}
		
		system.debug('objServicios-Entro-1->'+objServicios);
		//  Generar los Suplementary Info.
		for(LTE_Servicios_adicionales__c objServAdic: 	objServicios.Servicios_adicionales__r)
		{
			if(!objServAdic.Name.equals(VariablesGlobales__c.getInstance('NombreComercialLTE').Valor__c))
			{
				system.debug('objServicios-Entro-2->'+objServicios);
				
				//armar los suplementaryInfo
				xml+=LTE_RevchainXML_cls.SupplementaryInfo(OC,objServAdic,lstXas,objSalesORderLine.Id);
				nombreplan='';							
				for(LTE_SpecificationGroupXA__c objXas: lstXas)
					{
						if(objXas.LTE_ServiciosAdicionales__c==objServAdic.Id){
							if(objXas.Name.Contains('RVC PARM')){ // solo se tienen en cuenta los parametros de facturacion cuyo Name contema la cadena RVC PARM
								if(objXas.Name=='RVC PARM LTE Contract ID'){
									objXas.LTE_Value__c='$IDSIEBEL'; // en este caso, cuando es financiacioin de eqiupos 
								}
								xml+=parametro(objXas);
							}
							if(objXas.Name.Contains('RVC PLN')){ // solo se tienen en cuenta los parametros de facturacion cuyo Name contema la cadena RVC PARM
								if(objServAdic.LTE_PrimaryClassificationCode__c	==	'CLASE FINANCIAMIENTO LTE'){
								   	system.debug('objServAdic.LTE_PrimaryClassificationCode__c-->'+objServAdic.LTE_PrimaryClassificationCode__c);
								   	system.debug('Entre-Nombre-Plan-->'+objXas.LTE_Value__c);
									nombreplan=objXas.LTE_Value__c;
								}
								
							}
						}
						
					}
	
					system.debug('Nombre-Plan-->'+nombreplan);
					xml+=LTE_RevchainXML_cls.rateplan(nombreplan);
					xml+='</SupplementaryInfo>';
					
			}
		}
		//anadir connection
		xml+=LTE_RevchainXML_cls.Connection(OC); 
		
		//agregar discounts
		xml+='<Discounts>';
		//xml+=LTE_RevchainXML_cls.Discounts(lstXas,objSalesORderLine,null); 
		xml+='</Discounts>';
		
		//agregar specificationgroupXA
		xml+=LTE_RevchainXML_cls.getAllSpecificationGroupXA(OC,null,lstXas,objServicios,objSalesORderLine.id); 

		//agregar Cusston2
		xml+=LTE_RevchainXML_cls.Custom2(OC);
				 
		//agregar Altkeys
		//string valorciclo = CalculoCodigoFacturacion(OC);
		xml+=LTE_RevchainXML_cls.AltKey(OC,lstXas,objSalesORderLine.id,valorEquiposFinanciados, detServicio,null);

		
		//agregar Cusston2 
		//xml+=LTE_RevchainXML_cls.Billing();
		
		xml+='</SalesOrderLine>';
    }
	return xml;
}

public string SalesOrderLine(OperacionComercial__c OC,LTE_DetalleOferta__c 	objDetOferta,list<LTE_SpecificationGroupXA__c> lstXas)
{
	//es un string
	String IdSalesorderLine;
	LTE_Servicios_adicionales__c objSalesORderLine;
	string xml='';
	string nombreplan='';

	system.debug('Oc.Id.size-->'+Oc.Id);
	system.debug('objDetOferta-->'+objDetOferta);

    if(objDetOferta!=null){
		system.debug('objDetOferta-Entro->'+objDetOferta);
				
		//Generar el regsitro de SalesOrderLine.
		for(LTE_Servicios_adicionales__c objServAdic: 	objDetOferta.LTE_Servicios_adicionales__r)
		{
			if(objServAdic.Name.equals(VariablesGlobales__c.getInstance('NombreComercialLTE').Valor__c)){
				xml+=LTE_RevchainXML_cls.SalesOrderLine(OC,objServAdic);
				objSalesORderLine=objServAdic;
			}		
		}
		
		system.debug('objDetOferta-Entro-1->'+objDetOferta);
		//  Generar los Suplementary Info.
		for(LTE_Servicios_adicionales__c objServAdic: 	objDetOferta.LTE_Servicios_adicionales__r)
		{
			nombreplan='';
			if(!objServAdic.Name.equals(VariablesGlobales__c.getInstance('NombreComercialLTE').Valor__c))
			{
				system.debug('OC-3->'+OC);
				system.debug('objServAdic-3->'+objServAdic);
				system.debug('lstXas-3->'+lstXas); 
				system.debug('objSalesORderLine-3->'+objSalesORderLine);
				
				//armar los suplementaryInfo
				xml+=LTE_RevchainXML_cls.SupplementaryInfo(OC,objServAdic,lstXas,objSalesORderLine.Id);
				system.debug('objSalesORderLine-4->'+objSalesORderLine);
				for(LTE_SpecificationGroupXA__c objXas: lstXas)
				{
					if(objXas.LTE_ServiciosAdicionales__c==objServAdic.Id){
						if(objXas.Name.Contains('RVC PARM')){ // solo se tienen en cuenta los parametros de facturacion cuyo Name contema la cadena RVC PARM
							xml+=parametro(objXas);
						}
						if(objXas.Name.Contains('RVC PLN')){ // solo se tienen en cuenta los parametros de facturacion cuyo Name contema la cadena RVC PARM
							if(objServAdic.LTE_PrimaryClassificationCode__c	!=	'LTE Number Class' 	&&
							   objServAdic.LTE_PrimaryClassificationCode__c	!=	'LTE Simcard Class' &&
							   objServAdic.LTE_PrimaryClassificationCode__c	!=	'CLASE RVC LTE 1' 	&&
							   objServAdic.LTE_PrimaryClassificationCode__c	!=	'CLASE RVC LTE 2' 	&&
							   objServAdic.LTE_PrimaryClassificationCode__c	!=	'LTE Customer Equipment Class'  ){
							   	system.debug('objServAdic.LTE_PrimaryClassificationCode__c-->'+objServAdic.LTE_PrimaryClassificationCode__c);
							   	system.debug('Entre-Nombre-Plan-->'+objXas.LTE_Value__c);
								nombreplan=objXas.LTE_Value__c;
							}
                            
                            if(objXas.LTE_Value__c.Contains('SVA APN')){
                                nombreplan=objXas.LTE_Value__c;
                            }
							
						}
					}
					
				}
				system.debug('objSalesORderLine-5->'+objSalesORderLine);
				system.debug('Nombre-Plan-->'+nombreplan);
				xml+=LTE_RevchainXML_cls.rateplan(nombreplan);
				xml+='</SupplementaryInfo>';					
			}
		}
		system.debug('objSalesORderLine-->'+objSalesORderLine);
		//anadir connection
		xml+=LTE_RevchainXML_cls.Connection(OC); 
		
		//agregar discounts
		xml+='<Discounts>';
		xml+=LTE_RevchainXML_cls.Discounts(lstXas,objSalesORderLine,objDetOferta); 
		xml+='</Discounts>';
		
		//agregar specificationgroupXA
		system.debug('lstXas-size-3->'+lstXas.size());
		system.debug('objSalesORderLine.Id-size->'+objSalesORderLine.Id);
		xml+=LTE_RevchainXML_cls.getAllSpecificationGroupXA(OC,objDetOferta,lstXas,null,objSalesORderLine.Id); 

		
		//agregar Cusston2
		xml+=LTE_RevchainXML_cls.Custom2(OC);
				
		//agregar Altkeys
		//string valorciclo = CalculoCodigoFacturacion(OC);
		xml+=LTE_RevchainXML_cls.AltKey(OC,lstXas,objSalesORderLine.Id,0,null,objDetOferta);

		
		//agregar Cusston2 
		//xml+=LTE_RevchainXML_cls.Billing();
		
		xml+='</SalesOrderLine>';
    }
	return xml;
}



public string SalesOrderLineRepoReno(OperacionComercial__c OC,LTE_DetalleOferta__c 	objDetOferta,list<LTE_SpecificationGroupXA__c> lstXas)
{
	//es un string
	String IdSalesorderLine;
	LTE_Servicios_adicionales__c objSalesORderLine;
	string xml='';
	string nombreplan='';

	system.debug('Oc.Id.size-->'+Oc.Id);
	system.debug('objDetOferta-->'+objDetOferta);

    if(objDetOferta!=null){
		system.debug('objDetOferta-Entro->'+objDetOferta);
				
		//Generar el regsitro de SalesOrderLine.
		for(LTE_Servicios_adicionales__c objServAdic: 	objDetOferta.LTE_Servicios_adicionales__r)
		{
			if(objServAdic.Name.equals(VariablesGlobales__c.getInstance('NombreComercialLTE').Valor__c)){
				xml+=LTE_RevchainXML_cls.SalesOrderLine(OC,objServAdic);
				objSalesORderLine=objServAdic;
			}		
		}
		
		system.debug('objDetOferta-Entro-1->'+objDetOferta);
		//  Generar los Suplementary Info.
		for(LTE_Servicios_adicionales__c objServAdic: 	objDetOferta.LTE_Servicios_adicionales__r)
		{
			nombreplan='';
			if(!objServAdic.Name.equals(VariablesGlobales__c.getInstance('NombreComercialLTE').Valor__c))
			{
				system.debug('OC-3->'+OC);
				system.debug('objServAdic-3->'+objServAdic);
				system.debug('lstXas-3->'+lstXas); 
				system.debug('objSalesORderLine-3->'+objSalesORderLine);
				
				//armar los suplementaryInfo
				xml+=LTE_RevchainXML_cls.SupplementaryInfo(OC,objServAdic,lstXas,objSalesORderLine.Id);
				system.debug('objSalesORderLine-4->'+objSalesORderLine);
				for(LTE_SpecificationGroupXA__c objXas: lstXas)
				{
						if(objXas.LTE_ServiciosAdicionales__c==objServAdic.Id){
							if(objXas.Name.Contains('RVC PARM')){ // solo se tienen en cuenta los parametros de facturacion cuyo Name contema la cadena RVC PARM
								if(objXas.Name=='RVC PARM LTE Contract ID'){
									objXas.LTE_Value__c='$IDSIEBEL'; // en este caso, cuando es financiacioin de eqiupos 
								}
								xml+=parametro(objXas);
							}
							if(objXas.Name.Contains('RVC PLN')){ // solo se tienen en cuenta los parametros de facturacion cuyo Name contema la cadena RVC PARM
								if(objServAdic.LTE_PrimaryClassificationCode__c	==	'CLASE FINANCIAMIENTO LTE'){
								   	system.debug('objServAdic.LTE_PrimaryClassificationCode__c-->'+objServAdic.LTE_PrimaryClassificationCode__c);
								   	system.debug('Entre-Nombre-Plan-->'+objXas.LTE_Value__c);
									nombreplan=objXas.LTE_Value__c;
								}
								
							}
						}
						
					}
				system.debug('objSalesORderLine-5->'+objSalesORderLine);
				system.debug('Nombre-Plan-->'+nombreplan);
				xml+=LTE_RevchainXML_cls.rateplan(nombreplan);
				xml+='</SupplementaryInfo>';					
			}
		}
		system.debug('objSalesORderLine-->'+objSalesORderLine);
		//anadir connection
		xml+=LTE_RevchainXML_cls.Connection(OC); 
		
		//agregar discounts
		xml+='<Discounts>';
		//xml+=LTE_RevchainXML_cls.Discounts(lstXas,objSalesORderLine,objDetOferta); 
		xml+='</Discounts>';
		
		//agregar specificationgroupXA
		system.debug('lstXas-size-3->'+lstXas.size());
		//system.debug('objSalesORderLine.Id-size->'+objSalesORderLine.Id);
		xml+=LTE_RevchainXML_cls.getAllSpecificationGroupXA(OC,objDetOferta,lstXas,null,objSalesORderLine.Id); 

		
		//agregar Cusston2
		xml+=LTE_RevchainXML_cls.Custom2(OC);
				
		//agregar Altkeys
		//string valorciclo = CalculoCodigoFacturacion(OC);
		xml+=LTE_RevchainXML_cls.AltKey(OC,lstXas,objSalesORderLine.Id,0,null,objDetOferta);

		
		//agregar Cusston2 
		//xml+=LTE_RevchainXML_cls.Billing();
		
		xml+='</SalesOrderLine>';
    }
	return xml;
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------
public String parametro(LTE_SpecificationGroupXA__c objXas)
{
	string parametro = ''; 
	string nombre = objXas.Name.replace('RVC PARM ','');
	system.debug('objXas.Name-->'+objXas.Name);
	parametro= LTE_RevchainXML_cls.Parameter(nombre,objXas.LTE_Value__c);	
	return parametro;
}

 
//metodo que arma el canonico con cada uno de las partes del canonico

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------
public void CrearFacturacion(list<OperacionComercial__c> lstOC)
{
	
	map<string,LTE_DetalleOferta__c> mapIdOCDetOfertaUpdate = new map<string,LTE_DetalleOferta__c>();
	map<string,ActivoETB__c> mapIdOCServicioUpdate = new map<string,ActivoETB__c>();
	
	system.debug('CANTIDAD DE OCS  a procesar-->'+lstOC.size());
	list<Contact> lstContactos;
	map<String,Contact> mapContactos = new map<String,Contact>();
	LTE_DetalleOferta__c detOferta;
	ActivoETB__c detServAdic;
	set<String> setIdServAdic = new set<String>() ;
	set<String> setIdServAdicVentaEquipos = new set<String>() ;
	CuentaFacturacion__c objCuentaFacturacion;
	Decimal valorEquiposFinanciados=0;
	String IdServicioAdicionalPrincipal='';
	Boolean senalSeguirProcesoOC = false;
    String producto = VariablesGlobales__c.getAll().get('NombreComercialLTE').valor__c;
	
	string xml='';	
	
	//Obtenber los Ids de las operaciones comerciales
	set<string> idOC = new set<string>();
	set<string> idCtaCont = new set<string>();
	set<string> idServ = new set<string>();
	for(OperacionComercial__c opc : lstOC)
	{
		idOC.add(opc.id);
		idCtaCont.add(opc.CuentaCliente__c);
		system.debug('OC A PRocesar-->'+opc.id);
	}
	
	
	
	// Obtener el detalle de las operaciones comericales
	map<string,OperacionComercial__c> listOCs = OperacionesComerciales(idOC);
	system.debug('listOCs-->'+listOCs);
	
	// Obtener los registros de Detalle de Oferta para las Operaciones Comerciales
	map<String,LTE_DetalleOferta__c> mapDetalleOferta = ConsultaDetalleOferta(idOC);
	system.debug('mapDetalleOferta-->'+mapDetalleOferta);
		
	// Obtener los Ids de los servicios adicionales asociados a los Detalles de la Oferta
	for(LTE_DetalleOferta__c objDetOf:mapDetalleOferta.values()){
		for(LTE_Servicios_adicionales__c objServAdic: 	objDetOf.LTE_Servicios_adicionales__r)
			{
				setIdServAdic.add(objServAdic.Id);	
				if(objServAdic.Name.equals(VariablesGlobales__c.getInstance('NombreComercialLTE').Valor__c)){
					IdServicioAdicionalPrincipal=objServAdic.Id;
				}	
			}
	}
	
	system.debug('IdServicioAdicionalPrincipal-->'+IdServicioAdicionalPrincipal);
	// Obtener los XAS asociados a los Detalles de la Oferta.
	list<LTE_SpecificationGroupXA__c> lstXas = ConsultaXAS(setIdServAdic);
	system.debug('lstXas-->'+lstXas);
	
	//mapa que guarda operacion comercial y canonico
	map<string,string> mapCanonicos = new map<string,string>();	
	//mapa para guardar el activo con el Random asignado --//--SAO

	// Armar mapas de los Contactos de las cuentas
    lstContactos = LTE_RevchainXML_cls.getRepresentanteLegal(idCtaCont); 
    for(Contact ct: lstContactos){
    	mapContactos.put(ct.AccountId,ct);
    }

	 
	for(OperacionComercial__c oc :lstOC)
	{

		//por cada una buscar la correspondencia en el id 
		system.debug('oc.id-->'+oc.id);
		if(listOCs.containsKey(oc.id)) 
		{
			system.debug('oc.id-2->'+oc.id);
			OperacionComercial__c OpCom = listOCs.get(oc.id);
			detOferta = mapDetalleOferta.get(OpCom.Id);
			system.debug('detOferta-2->'+detOferta);
			system.debug('oc.TOPP__r.TipodeOperacionporplan__c-2->'+oc.TOPP__r.TipodeOperacionporplan__c);

			// 1. Facturar Lineas
			// ---------------------------------------------
			if(oc.TOPP__r.TipodeOperacionporplan__c	=='Venta' 			// Tipo de Operacion es Venta
				&& detOferta 						!= null 
				&& detOferta.LTE_Servicios_adicionales__r.size()>0 )   // Debe tener creados los servicios adicionales
			{ 
				system.debug('oc.id-3->'+oc.id);
				
				if(OC.TOPP__r.TipodeOperacionporplan__c!='Venta Equipos'){ // Tipo de operacion diferente a Venta de Equipos
					system.debug('detServAdic-->'+detServAdic);
					string canonico = ArmarCanonico(OpCom,detOferta,null,lstXas,mapContactos.get(OpCom.CuentaCliente__c),0);
					system.debug('canonico-->'+canonico);
					mapCanonicos.put(oc.id,canonico);
					
				}	
			}	
				
			// 2. Facturar Venta de Equipos
			// ---------------------------------------------	
			else if(OC.TOPP__r.TipodeOperacionporplan__c	==	'Venta Equipos' // Si tipo  operacion es venta de equipos
					&& OpCom.EnviadaFacturacionEquipo__c	== 	false 			// y si  no se ha facturado los equipos en Revchain
			        &&  OpCom.Legalizacion__r.Estado__c 	==	'Gestionado'    // y la legalicion esta Gestionado
			        &&  OpCom.Legalizacion__r.Cuotas__c 	!= 0)				//y La legalizacion tiene financiamiento				
			{																							

				system.debug('OC.Activo__c-->'+OC.Activo__c);
							
				// Obtener Detalle de Servicios ETB, esto para cuando la operacion comercuial es Venta de Equipos
				map<String,ActivoETB__c> mapDetalleServicio= ConsultaDetalleServicioETB(OC.Activo__c);
				system.debug('mapDetalleServicio-->'+mapDetalleServicio);

				// Obtener los Ids de los servicios adicionales asociados al Activo ETB(Servicios) para cuano es venta de equipos
				for(ActivoETB__c objSertivioEtb:mapDetalleServicio.values()){
					for(LTE_Servicios_adicionales__c objServAdic: 	objSertivioEtb.Servicios_adicionales__r)
						{
							setIdServAdicVentaEquipos.add(objServAdic.Id);		
						}
				}			
				

				list<OperacionComercial__c> listOpComXLEgalizacion = OperacionesComercialesLegalizacion(OC.Legalizacion__c);
				// Obtener los registros de Detalle de Oferta para las Operaciones Comerciales
				set<string> setOCEq = new set<string>();
				for(OperacionComercial__c oc1 :listOpComXLEgalizacion){
					setOCEq.add(oc1.id);
				}
				map<String,LTE_DetalleOferta__c> mapDetalleOfertaEq = ConsultaDetalleOferta(setOCEq);
	
				for(OperacionComercial__c oc1 :listOpComXLEgalizacion){
					system.debug('Sumar-1-oc1->'+oc1);
					if(oc1.TOPP__r.TipodeOperacionporplan__c!='Venta Equipos' ){
						system.debug('Sumar-2-oc1->'+oc1);
						LTE_DetalleOferta__c detOfertaEq = mapDetalleOfertaEq.get(oc1.Id);
						system.debug('detOfertaEq.id->'+detOfertaEq.id);
						system.debug('LTEValorEquipoDescuento__c->'+detOfertaEq.LTEValorEquipoDescuento__c);
						if(detOfertaEq.LTE_EquipoTraido__c!=null && detOfertaEq.LTE_EquipoTraido__c==false && detOfertaEq.LTEValorEquipoDescuento__c!= null)
						{
							system.debug('Sumar-3-detOfertaEq.LTEValorEquipoDescuento__c->'+detOfertaEq.LTEValorEquipoDescuento__c);
							valorEquiposFinanciados+= detOfertaEq.LTEValorEquipoDescuento__c;// poner campo valor equipo del detalle de la oferta
						}						
					}
				}
								
				system.debug('valorEquiposFinanciados-1->'+valorEquiposFinanciados);
				// Obtener los XAS asociados a los Detalles de la Oferta.
				system.debug('setIdServAdicVentaEquipos-->'+setIdServAdicVentaEquipos);
				
				if(valorEquiposFinanciados>0){ // si valor de financaimiento de equipos es diferente de cero, envio la facturacion de financiamiento
					list<LTE_SpecificationGroupXA__c> lstXasVentaEquipos = ConsultaXAS(setIdServAdicVentaEquipos);	
					system.debug('lstXasVentaEquipos-->'+lstXasVentaEquipos);						
								
					ActivoETB__c detServAdicEq = mapDetalleServicio.get(OpCom.Activo__c);
					system.debug('detServAdic-FactEquipos->'+detServAdic);
					string canonico = ArmarCanonico(OpCom,detOferta,detServAdicEq,lstXasVentaEquipos,mapContactos.get(OpCom.CuentaCliente__c),valorEquiposFinanciados);
					system.debug('canonico-->'+canonico);
					mapCanonicos.put(oc.id,canonico);	
				}
				
									
			}	
			
			// 3. Facturar Retiros
			// ---------------------------------------------
			else if(OC.TOPP__r.TipodeOperacionporplan__c=='Retiro')  // Si tipo  operacion es Retiro 
			{	
				system.debug('OC.Activo__c-->'+OC.Activo__c);					
				// Obtener Detalle de Servicios ETB, esto para cuando la operacion comercuial es Venta de Equipos
				map<String,ActivoETB__c> mapDetalleServicio= ConsultaDetalleServicioETB(OC.Activo__c);
				system.debug('mapDetalleServicio-->'+mapDetalleServicio);

				// Obtener los Ids de los servicios adicionales asociados al Activo ETB(Servicios) para cuano es venta de equipos
				for(ActivoETB__c objSertivioEtb:mapDetalleServicio.values()){
					for(LTE_Servicios_adicionales__c objServAdic: 	objSertivioEtb.Servicios_adicionales__r)
						{
							setIdServAdicVentaEquipos.add(objServAdic.Id);		
						}
				}					
				// Obtener los XAS asociados a los Detalles de la Oferta.
				system.debug('setIdServAdicVentaEquipos-->'+setIdServAdicVentaEquipos);
				list<LTE_SpecificationGroupXA__c> lstXasVentaEquipos = ConsultaXAS(setIdServAdicVentaEquipos);	
				system.debug('lstXasVentaEquipos-->'+lstXasVentaEquipos);						
							
				ActivoETB__c detServAdicEq = mapDetalleServicio.get(OpCom.Activo__c);
				system.debug('detServAdic-FactEquipos->'+detServAdic);
				string canonico = ArmarCanonico(OpCom,detOferta,detServAdicEq,lstXasVentaEquipos,mapContactos.get(OpCom.CuentaCliente__c),valorEquiposFinanciados);
				system.debug('canonico-->'+canonico);
				mapCanonicos.put(oc.id,canonico);
				
				// guardar mapas con los servicios adicionales de cada Oc, por detalle de oferta y servicio adicional
				//mapIdOCDetOfertaUpdate.put(oc.id,mapDetalleOferta.values());
				mapIdOCServicioUpdate.put(oc.id,mapDetalleServicio.values());					
			}
			else if((OC.TOPP__r.TipodeOperacionporplan__c	==	'Renovación' || OC.TOPP__r.TipodeOperacionporplan__c	==	'Reposición'  )
					&& 	OC.EnviadaFacturacionEquipo__c	== 	false 			// y si  no se ha facturado los equipos en Revchain
			        //&&  OC.Legalizacion__r.Estado__c 	==	'Gestionado'    // y la legalicion esta Gestionado
			        &&  OC.Legalizacion__r.Cuotas__c 	!= 0)				//y La legalizacion tiene financiamiento
			{
					system.debug('REPORENO-->'+detServAdic);
					map<String,ActivoETB__c> mapDetalleServicio= ConsultaDetalleServicioETB(OC.Activo__c);
					string canonico = ArmarCanonico(OpCom,detOferta,null,lstXas,mapContactos.get(OpCom.CuentaCliente__c),0);
					system.debug('canonico-->'+canonico);
					mapCanonicos.put(oc.id,canonico);		
					// guardar mapas con los servicios adicionales de cada Oc, por detalle de oferta y servicio adicional
					//mapIdOCDetOfertaUpdate.put(oc.id,mapDetalleOferta.values());
					mapIdOCServicioUpdate.put(oc.id,mapDetalleServicio.values());		
			}
			
			// 5. Facturar Cambio Plan   PVTA LRPA - 26-11-2015
			// ---------------------------------------------
			else if(OC.TOPP__r.TipodeOperacionporplan__c=='Cambio de Plan')  // Si tipo  operacion es Cambio Plan 
			{	
				system.debug('OC.Activo__c-->'+OC.Activo__c);					
				// Obtener Detalle de Servicios ETB, esto para cuando la operacion comercuial es Venta de Equipos
				map<String,ActivoETB__c> mapDetalleServicio= ConsultaDetalleServicioETB(OC.Activo__c);
				system.debug('mapDetalleServicio-->'+mapDetalleServicio);

				// Obtener los Ids de los servicios adicionales asociados al Activo ETB(Servicios) para cuano es venta de equipos
				for(ActivoETB__c objSertivioEtb:mapDetalleServicio.values()){
					for(LTE_Servicios_adicionales__c objServAdic: 	objSertivioEtb.Servicios_adicionales__r)
						{
							setIdServAdicVentaEquipos.add(objServAdic.Id);		
						}
				}					
				// Obtener los XAS asociados a los Detalles de la Oferta.
				system.debug('setIdServAdicVentaEquipos-->'+setIdServAdicVentaEquipos);
				list<LTE_SpecificationGroupXA__c> lstXasVentaEquipos = ConsultaXAS(setIdServAdicVentaEquipos);	
				system.debug('lstXasVentaEquipos-->'+lstXasVentaEquipos);						
							
				ActivoETB__c detServAdicEq = mapDetalleServicio.get(OpCom.Activo__c);
				system.debug('detServAdic-FactEquipos->'+detServAdic);
				string canonico = ArmarCanonico(OpCom,detOferta,detServAdicEq,lstXasVentaEquipos,mapContactos.get(OpCom.CuentaCliente__c),valorEquiposFinanciados);
				system.debug('canonico-->'+canonico);
				mapCanonicos.put(oc.id,canonico);	
				
				// guardar mapas con los servicios adicionales de cada Oc, por detalle de oferta y servicio adicional
				//mapIdOCDetOfertaUpdate.put(oc.id,mapDetalleOferta.values());
				mapIdOCServicioUpdate.put(oc.id,mapDetalleServicio.values());				
			}
			// 6. Facturar Cambio Número   PVTA AG - 03-02-2016
			// ---------------------------------------------
			else if(OC.TOPP__r.TipodeOperacionporplan__c=='Cambio Número')  // Si tipo  operacion es Cambio Plan 
			{	
				system.debug('OC.Activo__c-->'+OC.Activo__c);					
				// Obtener Detalle de Servicios ETB, esto para cuando la operacion comercuial es Venta de Equipos
				map<String,ActivoETB__c> mapDetalleServicio= ConsultaDetalleServicioETB(OC.Activo__c);
				system.debug('mapDetalleServicio-->'+mapDetalleServicio);

				// Obtener los Ids de los servicios adicionales asociados al Activo ETB(Servicios) para cuano es venta de equipos
				for(ActivoETB__c objSertivioEtb:mapDetalleServicio.values()){
					for(LTE_Servicios_adicionales__c objServAdic: 	objSertivioEtb.Servicios_adicionales__r)
						{
							setIdServAdicVentaEquipos.add(objServAdic.Id);		
						}
				}					
				// Obtener los XAS asociados a los Detalles de la Oferta.
				system.debug('setIdServAdicVentaEquipos-->'+setIdServAdicVentaEquipos);
				list<LTE_SpecificationGroupXA__c> lstXasVentaEquipos = ConsultaXAS(setIdServAdicVentaEquipos);	
				system.debug('lstXasVentaEquipos-->'+lstXasVentaEquipos);						
							
				ActivoETB__c detServAdicEq = mapDetalleServicio.get(OpCom.Activo__c);
				system.debug('detServAdic-FactEquipos->'+detServAdic);
				string canonico = ArmarCanonico(OpCom,detOferta,detServAdicEq,lstXasVentaEquipos,mapContactos.get(OpCom.CuentaCliente__c),valorEquiposFinanciados);
				system.debug('canonico-->'+canonico);
				mapCanonicos.put(oc.id,canonico);	
				// guardar mapas con los servicios adicionales de cada Oc, por detalle de oferta y servicio adicional
				//mapIdOCDetOfertaUpdate.put(oc.id,mapDetalleOferta.values());
				mapIdOCServicioUpdate.put(oc.id,mapDetalleServicio.values());
				
			}
			// 7. Facturar Suspensión, Reconexión Voluntaria   PVTA AG - 03-02-2016
			// ---------------------------------------------
			else if(OC.TOPP__r.TipodeOperacionporplan__c=='Suspensión' || OC.TOPP__r.TipodeOperacionporplan__c=='Reconexión')  // Si tipo  operacion es Suspensión o Reconexion 
			{	
				system.debug('OC.Activo__c-->'+OC.Activo__c);					
				// Obtener Detalle de Servicios ETB, esto para cuando la operacion comercuial es Venta de Equipos
				map<String,ActivoETB__c> mapDetalleServicio= ConsultaDetalleServicioETB(OC.Activo__c);
				system.debug('mapDetalleServicio-->'+mapDetalleServicio);

				// Obtener los Ids de los servicios adicionales asociados al Activo ETB(Servicios) para cuano es venta de equipos
				for(ActivoETB__c objSertivioEtb:mapDetalleServicio.values()){
					for(LTE_Servicios_adicionales__c objServAdic: 	objSertivioEtb.Servicios_adicionales__r)
						{
							setIdServAdicVentaEquipos.add(objServAdic.Id);		
						}
				}					
				// Obtener los XAS asociados a los Detalles de la Oferta.
				system.debug('setIdServAdicVentaEquipos-->'+setIdServAdicVentaEquipos);
				list<LTE_SpecificationGroupXA__c> lstXasVentaEquipos = ConsultaXAS(setIdServAdicVentaEquipos);	
				system.debug('lstXasVentaEquipos-->'+lstXasVentaEquipos);						
							
				ActivoETB__c detServAdicEq = mapDetalleServicio.get(OpCom.Activo__c);
				system.debug('detServAdic-FactEquipos->'+detServAdic);
				string canonico = ArmarCanonico(OpCom,detOferta,detServAdicEq,lstXasVentaEquipos,mapContactos.get(OpCom.CuentaCliente__c),valorEquiposFinanciados);
				system.debug('canonico-->'+canonico);
				mapCanonicos.put(oc.id,canonico);	
				
				// guardar mapas con los servicios adicionales de cada Oc, por detalle de oferta y servicio adicional
				//mapIdOCDetOfertaUpdate.put(oc.id,mapDetalleOferta.values());
				mapIdOCServicioUpdate.put(oc.id,mapDetalleServicio.values());
				
			}
			// 8. Adición y Retiro de SVAs   PVTA AG - 03-02-2016
			// ---------------------------------------------
			else if(OC.TOPP__r.TipodeOperacionporplan__c=='Adición SVA' || OC.TOPP__r.TipodeOperacionporplan__c=='Retiro SVA')  // Si tipo  operacion es Adición o Retiro de SVA 
			{	
				system.debug('OC.Activo__c-->'+OC.Activo__c);					
				// Obtener Detalle de Servicios ETB, esto para cuando la operacion comercuial es Venta de Equipos
				map<String,ActivoETB__c> mapDetalleServicio= ConsultaDetalleServicioETB(OC.Activo__c);
				system.debug('mapDetalleServicio-->'+mapDetalleServicio);

				// Obtener los Ids de los servicios adicionales asociados al Activo ETB(Servicios) para cuano es venta de equipos
				for(ActivoETB__c objSertivioEtb:mapDetalleServicio.values()){
					for(LTE_Servicios_adicionales__c objServAdic: 	objSertivioEtb.Servicios_adicionales__r)
						{
							setIdServAdicVentaEquipos.add(objServAdic.Id);		
						}
				}					
				// Obtener los XAS asociados a los Detalles de la Oferta.
				system.debug('setIdServAdicVentaEquipos-->'+setIdServAdicVentaEquipos);
				list<LTE_SpecificationGroupXA__c> lstXasVentaEquipos = ConsultaXAS(setIdServAdicVentaEquipos);	
				system.debug('lstXasVentaEquipos-->'+lstXasVentaEquipos);						
							
				ActivoETB__c detServAdicEq = mapDetalleServicio.get(OpCom.Activo__c);
				system.debug('detServAdic-FactEquipos->'+detServAdic);
				string canonico = ArmarCanonico(OpCom,detOferta,detServAdicEq,lstXasVentaEquipos,mapContactos.get(OpCom.CuentaCliente__c),valorEquiposFinanciados);
				system.debug('canonico-->'+canonico);
				mapCanonicos.put(oc.id,canonico);	
				
				
				// guardar mapas con los servicios adicionales de cada Oc, por detalle de oferta y servicio adicional
				//mapIdOCDetOfertaUpdate.put(oc.id,mapDetalleOferta.values());
				mapIdOCServicioUpdate.put(oc.id,mapDetalleServicio.values());
				
			}
			// 9. Modificacion de Servicio TSIP   PS JG - 16-03-2020 // FSARASTY - 02/09/2020
			// ---------------------------------------------
            else if(OC.TOPP__r.TipodeOperacionporplan__c=='Modificación Servicio' || OC.TOPP__r.TipodeOperacionporplan__c=='Modificación Estándar')
            {
                set<String> setIdServMod = new set<String>();
				system.debug('OC.Activo__c-->'+OC.Activo__c);
                
                // Obtener Detalle de Servicios ETB, esto para cuando la operacion comercuial es Venta de Equipos
				map<String,ActivoETB__c> mapDetalleServicio= ConsultaDetalleServicioETB(OC.Activo__c);
				system.debug('mapDetalleServicio-->'+mapDetalleServicio);

				// Obtener los Ids de los servicios adicionales asociados al Activo ETB(Servicios) para cuano es venta de equipos
				for(ActivoETB__c objSertivioEtb:mapDetalleServicio.values()){
					for(LTE_Servicios_adicionales__c objServAdic: 	objSertivioEtb.Servicios_adicionales__r)
						{
                            if(objServAdic.Name == producto){
                                objServAdic.LTE_ServiceActionCode__c = 'UPDATE';
                            }
                            if(Oc.NumeroCanales__c!=null && Oc.Valor__c!=null && Oc.Tarifa_mensual_Bolsa_de_Moviles__c!=null && Oc.Tarifa_mensual_Troncales_SIP__c!=null){
                                if(Oc.NumeroCanales__c>0 && Oc.Valor__c>0 && Oc.Tarifa_mensual_Bolsa_de_Moviles__c>0 && Oc.Tarifa_mensual_Troncales_SIP__c>0){
                                    if(objServAdic.Name == Oc.Plan__r.Name || objServAdic.LTE_PlanFacturacion__c != null || objServAdic.LTE_SubPlaFacturacion__c != null){
                                        objServAdic.LTE_ServiceActionCode__c = 'ADD';
                                        setIdServMod.add(objServAdic.Id);
                                    }
                                }
                            }
                            if(Oc.Valorunicavez__c!=null){
                                if(Oc.Valorunicavez__c>0){
                                    if(objServAdic.Name == 'COBRO UNICA VEZ LTE'){
                                        objServAdic.LTE_ServiceActionCode__c = 'ADD';
                                        setIdServMod.add(objServAdic.Id);
                                    }
                                }
                            }
							setIdServAdicVentaEquipos.add(objServAdic.Id);		
						}
				}					
				// Obtener los XAS asociados a los Detalles de la Oferta.
				system.debug('setIdServAdicVentaEquipos-->'+setIdServAdicVentaEquipos);
				list<LTE_SpecificationGroupXA__c> lstXasVentaEquipos = ConsultaXAS(setIdServAdicVentaEquipos);	
				system.debug('lstXasVentaEquipos-->'+lstXasVentaEquipos);						
				
                for(LTE_SpecificationGroupXA__c sglXasVentaEquipos: lstXasVentaEquipos){
                    String camposSVA = '';
                    if(setIdServMod.contains(sglXasVentaEquipos.LTE_ServiciosAdicionales__c)){
                        if(sglXasVentaEquipos.Name.contains('RVC PARM') && sglXasVentaEquipos.LTE_ParametroFacturacion__r.Objeto__c != null && sglXasVentaEquipos.LTE_ParametroFacturacion__r.Campo__c != null){
                            if(sglXasVentaEquipos.LTE_ParametroFacturacion__r.Objeto__c == 'LTE_DetalleOferta__c'){
                                camposSVA = sglXasVentaEquipos.LTE_ParametroFacturacion__r.Campo__c;
                                camposSVA = camposSVA.replace('LTE_OperacionComercial__r', 'LTE_ServiciosAdicionales__r.LTE_OC_Tramite__r');
                                sglXasVentaEquipos.LTE_Value__c = LibreriaUtilitaria_cls.recorreCampos((sObject)sglXasVentaEquipos,camposSVA);
                                if(sglXasVentaEquipos.LTE_ServiciosAdicionales__r.Name=='COBRO UNICA VEZ LTE'){
                                    sglXasVentaEquipos.LTE_Value__c = sglXasVentaEquipos.LTE_Value__c.replace('.00','');
                                }
                            }
                        }
                    }
                }
                
				ActivoETB__c detServAdicEq = mapDetalleServicio.get(OpCom.Activo__c);
				system.debug('detServAdic-FactEquipos->'+detServAdic);
				string canonico = ArmarCanonico(OpCom,detOferta,detServAdicEq,lstXasVentaEquipos,mapContactos.get(OpCom.CuentaCliente__c),valorEquiposFinanciados);
				system.debug('canonico-->'+canonico);
				mapCanonicos.put(oc.id,canonico);	
				
                
                for(ActivoETB__c objSertivioEtb:mapDetalleServicio.values()){
                    for(LTE_Servicios_adicionales__c objServAdic: 	objSertivioEtb.Servicios_adicionales__r)
                    {
                        if(objServAdic.Name == 'COBRO UNICA VEZ LTE'){
                            objServAdic.LTE_ServiceActionCode__c = 'DELETE';
                        }
                    }
				}
				// guardar mapas con los servicios adicionales de cada Oc, por detalle de oferta y servicio adicional
				//mapIdOCDetOfertaUpdate.put(oc.id,mapDetalleOferta.values());
				mapIdOCServicioUpdate.put(oc.id,mapDetalleServicio.values());
            }
		}
	}
	
	
	// Procesar respuestas de Facturación
	system.debug('mapCanonicos-->'+mapCanonicos.keySet());
	//por cada canonico hacer el llamado del servicio
	ServiciosWeb__c sw = ServiciosWeb__c.getValues('RevChain');
	tibcoXml_cls tXml=new tibcoXml_cls();
	system.debug('Vovli de TIBCO-->'+mapCanonicos.keySet());
	list<LogTransacciones__c> logs = new list<LogTransacciones__c>();
	//mapa que ayuda a indentificar cuenta de facturacion y ciclo asignado.
	map<string,string> ciclos = new map<string,string>();
	//mapa que identifica numero de cuenta y objeto cuenta de facturacion para posterior insercion y relacionamiento con la OC
	map<string,CuentaFacturacion__c> mapcuentasFac = new map<string,CuentaFacturacion__c>();
	map<string,CuentaFacturacion__c> mapcuentasFacIns = new map<string,CuentaFacturacion__c>();
	//mapa que identifica la OC con cual numero de OC.
	map<string,string> mapOCFac = new map<string,string>();
	map<string,OperacionComercial__c> mapFacOC = new map<string,OperacionComercial__c>(); 
	map<string,OperacionComercial__c> mapActOC = new map<string,OperacionComercial__c>(); 
	map<string,string> OCcontratos = new map<string,string>();
	List<CuentaFacturacion__c>fallidasConCuentas=new List<CuentaFacturacion__c>();
	map<string,string>mapRespuestas;
	
	for(string ocId :mapCanonicos.keySet())
	{
		system.debug('mapCanonicos-Entro al FOR->'+ocId);
		
		//obtiene la OC y valida que el tipo de operacion por plan sea facturable
		OperacionComercial__c OCtopp = listOCs.get(ocId);
		system.debug('OCtopp.TOPP__r.Facturable__c->'+OCtopp.TOPP__r.Facturable__c);
		if(OCtopp.TOPP__r.Facturable__c)
		{
		string request= mapCanonicos.get(ocId);
		system.debug('llamar servicio');
		string response;
		response=LibreriaUtilitariaJobs_cls.consultarServicio(request,sw.Action__c,sw.EndPoint__c);
		system.debug('llamar servicio-response-->'+response);
		string estado='';		
		string resultadoRevChain='';
			system.debug(response);
			//tibcoXml_cls.xmlMap proReq=new tibcoXml_cls.xmlMap();
			try{
				Dom.Document doc = new Dom.Document();
				doc.load(response);
				mapRespuestas =recuperarRespuestaXML(doc);
			//revisar si el estado es bien y no hay error en RevChain
			system.debug('mapa respuestas:: '+mapRespuestas);
			system.debug('Respuesta-Estado-Boolean->'+mapRespuestas.get('Estado').equals('PASS'));
			system.debug('Respuesta-Estado-->'+mapRespuestas.get('Estado'));
			system.debug('Respuesta-BillingResponse-->'+mapRespuestas.get('RespuestaRevChain'));
			if(mapRespuestas.get('Estado').equals('PASS') && mapRespuestas.get('RespuestaRevChain').equals('Y'))
			{
				system.debug('LA FACTURACION FUE EXITOSA-idOpCom->'+ocId);
				//guardar el Id para dejar Activa la Operacion Comercial
				OperacionComercial__c OC = listOCs.get(ocId);
				OC.Estado__c='Facturado';
				if(OC.TOPP__r.TipodeOperacionporplan__c=='Venta Equipos'){  // marcar la operacion comercial de venta e equipos como ya enviada
					OC.EnviadaFacturacionEquipo__c=true;
				}
				//OC.fechadeActivacion__c=system.today();
				OC.EnvioFacturacion__c=false;
				OC.FechaFacturacion__c=system.now();
				mapActOC.put(OC.id,OC);
				//revisar la cuenta de facturacion
				string cuentaFac = mapRespuestas.get('CuentaFacturacion');
				//arma el mapa de las cuentas
				string ciclo = mapRespuestas.get('ciclo');
				ciclos.put(cuentaFac,ciclo);
				mapcuentasFac.put(cuentaFac,null);
				mapOCFac.put(OC.id,cuentaFac);
				mapFacOC.put(cuentaFac,OC);
				OCContratos.put(OC.id,OC.Legalizacion__r.Contrato__c);
				actualizaServAdicELIMINADO(mapIdOCServicioUpdate.get(OC.id),mapIdOCDetOfertaUpdate.get(OC.id)); // Marcar Ser Adic como elimiados cuando vienen como delete
				system.debug('##-mapIdOCServicioUpdate-idOpCom->'+mapIdOCServicioUpdate.get(ocId));
				system.debug('##-mapIdOCDetOfertaUpdate-idOpCom->'+mapIdOCDetOfertaUpdate.get(ocId));
				
				
			}
			else //if(mapRespuestas.get('Estado').equals('FAIL') || mapRespuestas.get('RespuestaRevChain').equals('N'))
			{			
				system.debug('LA FACTURACION FALLO-idOpCom->'+ocId);
				//dejar el activo En Facturacion
				OperacionComercial__c OC = listOCs.get(ocId);
				OC.Estado__c='No Exitoso Facturacion';
				OC.EnvioFacturacion__c=false;
				OC.FechaFacturacion__c=system.now();
				mapActOC.put(OC.id,OC);
				
				system.debug(OC.CuentaFacturacion__c +' '+mapRespuestas.get('CuentaFacturacion'));
				
				if(OC.CuentaFacturacion__c!=null && mapRespuestas.get('CuentaFacturacion')!=null )
				{
					string cuentaFac = mapRespuestas.get('CuentaFacturacion');
					OC.CuentaFacturacion__r.Name=mapRespuestas.get('CuentaFacturacion');
					OC.CuentaFacturacion__r.IdUnico__c=mapRespuestas.get('CuentaFacturacion');
					OC.CuentaFacturacion__r.Fue_creada_en_revchain__c=true;
					OC.CuentaFacturacion__r.CodCicloFac__c=mapRespuestas.get('ciclo');
					//fallidasConCuentas.add(OC.CuentaFacturacion__r);
					
				}	
			}

			}
			catch(system.Exception e)
			{
				system.debug('fallo:: '+e.getMessage());
				OperacionComercial__c OC = listOCs.get(ocId);
				OC.Estado__c='No Exitoso Facturacion';
				OC.EnvioFacturacion__c=false;
				mapActOC.put(OC.id,OC);
			}
			system.debug('ocId-->'+ocId);
			if(mapRespuestas!=null){
				logs.add(generarLog(ocId,request,response,mapRespuestas.get('RespuestaRevChain'),resultadoRevChain)); 
			} else{
				logs.add(generarLog(ocId,request,response,'Fallo',resultadoRevChain)); 
			}
		}
	}
	//Actualiza cuando el servicio responde como fallido pero crea la cuenta
	//update fallidasConCuentas;

	
	
	guardar(logs,mapActOC.values());
	
	// Actualizar los estados  de los servicios adicionales
	// poniendo el estado ELIMIADO cando están en DELETE// PVTA LRPA - 26-11-2015
	// ---------------------------------------------------------------------------
	try{
		system.debug('##-mapIdOCServicioUpdate-->'+mapIdOCServicioUpdate.size());
		system.debug('##-mapIdOCDetOfertaUpdate-->'+mapIdOCDetOfertaUpdate.size());
		system.debug('##-mapIdOCServicioUpdate-->'+mapIdOCServicioUpdate.values());
		system.debug('##-mapIdOCDetOfertaUpdate-->'+mapIdOCDetOfertaUpdate.values());
        
        
		update mapIdOCServicioUpdate.values().Servicios_adicionales__r;
		//update mapIdOCDetOfertaUpdate.values().Servicios_adicionales__r;
	}catch(system.Exception e)
	{
		
	}
	/*if(mapActOC.values().size()>0)
	{
		Database.Update(mapActOC.values(),false);
	}
	if(logs.size()>0){
		insert logs; //??
	}*/
}

//---PONER EL ESTADO ELIMIADO A LOS SERVICIOS ADICIONALES QUE VIENE CON ESTADO DELETE----// PVTA LRPA - 26-11-2015
 public void actualizaServAdicELIMINADO(ActivoETB__c objActivo,LTE_DetalleOferta__c objDetoferta){
 	
 	system.debug('##-objActivo-->'+objActivo);
 	system.debug('##-objDetoferta-->'+objDetoferta);
	if(objDetoferta!=null){
		system.debug('##-objDetoferta-1->'+objDetoferta);
		for(LTE_Servicios_adicionales__c objServAdic: 	objDetoferta.LTE_Servicios_adicionales__r)
			{
				system.debug('##-objDetoferta-objServAdic->'+objServAdic);
				if(objServAdic.LTE_ServiceActionCode__c=='DELETE'){
					system.debug('##-objDetoferta-objServAdic-2->'+objServAdic);
					objServAdic.LTE_ServiceActionCode__c='ELIMINADO';
				}
			}
	}		
	
	if(objActivo!=null){
		system.debug('##-objActivo-6->'+objActivo);
		for(LTE_Servicios_adicionales__c objServAdic: 	objActivo.Servicios_adicionales__r)
			{
				system.debug('##-objActivo-1->'+objServAdic);
				system.debug('##-objDetoferta-objServAdic-3->'+objServAdic);
				if(objServAdic.LTE_ServiceActionCode__c=='DELETE'){
					system.debug('##-objDetoferta-objServAdic-4->'+objServAdic);
					objServAdic.LTE_ServiceActionCode__c='ELIMINADO';
				}					
			}

	}			

}
	

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 public LogTransacciones__c generarLog(string idOC,string request,string response, string estado, string CodigoRespuesta){
		
		LogTransacciones__c lt =new LogTransacciones__c(LTE_Operacion_Comercial__c=idOC,Informacion_Enviada__c=request.Abbreviate(99999),Informacion_Recibida__c=response.Abbreviate(99999),Estado__c=estado,Name='Proceso Facturación',CodigoRespuesta__c=CodigoRespuesta);
		
		return lt;
	
	
	}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------
public string ArmarCanonico(OperacionComercial__c OC,LTE_DetalleOferta__c detOferta, ActivoETB__c detServicio,list<LTE_SpecificationGroupXA__c> lstXas,Contact repLegal,Decimal valorEquiposFinanciados)
{
	system.debug('ARMA-CANONICO-REPORENO-detServicio-2->'+detServicio);
	system.debug('valorEquiposFinanciados-2->'+valorEquiposFinanciados);
	string correlationId = '';
	string xml='';
	
	//comenzar a armar las etiquetas iniciales
	xml+='';
	xml+='<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns=\"http://www.etb.com.co/LTE/WS/ETB.LTE.WS.SalesForce/WSRequestSalesForceIN/1.0\" xmlns:v1=\"http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0\" xmlns:v11=\"http://www.etb.com.co/NPlay/canonical/CanonicalMessage/v1.0\">';
  	xml+='<soapenv:Header/>';
    xml+='<soapenv:Body>';
    xml+='<ns:WSRequestSFRevChain>';
    xml+=' <v1:WSRequestHeader>';
    xml+='<v1:System correlationID=\"'+OC.Id+'\" processingServer="Test">SALESFORCE</v1:System>'; //?? obtener CorrelationId
    //xml+='<v1:Property name="?" value="?">?</v1:Property>';
    xml+='</v1:WSRequestHeader>';
    xml+='<v11:CanonicalMessage>';
    xml+='<v11:OrderFulfilment>';
    
    system.debug('detOferta-->'+detOferta); 
    //RequestHeader
    //xml+=LTE_RevchainXML_cls.RequestHeader(OC); 
    //sender
    xml+=LTE_RevchainXML_cls.sender(OC);
    //Identification
    xml+=LTE_RevchainXML_cls.Identification(OC);
    //SalesOrder
    xml+=LTE_RevchainXML_cls.SalesOrder(OC);
    //BusinessReference
    xml+=LTE_RevchainXML_cls.BusinessReference(OC);
    //CustomerPartyAcount
    xml+=LTE_RevchainXML_cls.CustomerPartyAccount(OC,repLegal);
    //Custom
    xml+=LTE_RevchainXML_cls.Custom(OC);
    //SalesOrderLine 1 por cada producto
    xml+=LTE_RevchainXML_cls.PartyIdentification(OC);
	// SalesOrderLine y SupplementaryInfo
	if(OC.TOPP__r.TipodeOperacionporplan__c=='Venta Equipos' ){
    	xml+=SalesOrderLineEquipos(OC,detServicio,lstXas,valorEquiposFinanciados,detServicio);
	}else if(OC.TOPP__r.TipodeOperacionporplan__c=='Retiro'){
		system.debug('lstXas-size->'+lstXas.size());
		xml+=SalesOrderLineRetiro(OC,detServicio,lstXas,detServicio,detOferta);
	}else if(OC.TOPP__r.TipodeOperacionporplan__c	==	'Renovación' || OC.TOPP__r.TipodeOperacionporplan__c	==	'Reposición' ){
		system.debug('REPORENO-lstXas-size->'+lstXas.size());
		xml+=SalesOrderLineReporeno(OC,detOferta,lstXas);	
	}else if(oc.TOPP__r.TipodeOperacionporplan__c	=='Venta' ){
		system.debug('lstXas-size->'+lstXas.size());
		xml+=SalesOrderLine(OC,detOferta,lstXas);		
	}else if(oc.TOPP__r.TipodeOperacionporplan__c	=='Cambio de Plan' ){ // PVTA LRPA - 26-11-2015
		system.debug('lstXas-size->'+lstXas.size());
		xml+=SalesOrderCambioPlan(OC,detServicio,lstXas,detServicio,detOferta);		
	}else if(oc.TOPP__r.TipodeOperacionporplan__c	=='Cambio Número' ){ // PVTA AG - 2016-02-03
		system.debug('lstXas-size->'+lstXas.size());
		xml+=SalesOrderLineCambioNumero(OC,detServicio,lstXas,detServicio,detOferta);		
	}else if(oc.TOPP__r.TipodeOperacionporplan__c   ==  'Suspensión' ||  OC.TOPP__r.TipodeOperacionporplan__c   ==  'Reconexión'){ // AG 2016-02-09
    	xml+=SalesOrderLineSuspRecoVol(OC,detServicio,lstXas,detServicio,detOferta);
    }else if(oc.TOPP__r.TipodeOperacionporplan__c   ==  'Adición SVA' ||  OC.TOPP__r.TipodeOperacionporplan__c   ==  'Retiro SVA'){ // AG 2016-02-09
    	xml+=SalesOrderLineAdicionRetiroSVA(OC,detServicio,lstXas,detServicio,detOferta);
    }else if(oc.TOPP__r.TipodeOperacionporplan__c   ==  'Modificación Servicio' || oc.TOPP__r.TipodeOperacionporplan__c   ==  'Modificación Estándar'){ // JG 2020-03-16 //FSARASTY 2020-09-01
    	xml+=SalesOrderLineModificacionServicio(OC,detServicio,lstXas,detServicio,detOferta);
    }
    

    xml+='<ProvisioningResponse>Y</ProvisioningResponse>';
    if(oc.TOPP__r.TipodeOperacionporplan__c   ==  'Modificación Servicio' || oc.TOPP__r.TipodeOperacionporplan__c   ==  'Modificación Estándar'){ // JG 2020-03-16 //FSARASTY 2020-09-01
    	xml+='<AltKey><AltKeyName>Source</AltKeyName><AltKeyValue>Salesforce</AltKeyValue></AltKey>';
    	xml+='<AltKey><AltKeyName>AddRecurrentProduct</AltKeyName><AltKeyValue>Y</AltKeyValue></AltKey>';
    }
    xml+='</v11:OrderFulfilment>';       
    xml+='<v11:BillingProcess>';
    //customer
    xml+=LTE_RevchainXML_cls.Customer(OC,repLegal);
    //customerBill
    xml+=LTE_RevchainXML_cls.CustomerBill(OC);
    xml+='<Tax>';
    xml+='<TaxAmount>0</TaxAmount>';
    xml+='</Tax>';
    xml+='</v11:BillingProcess>';
    xml+='</v11:CanonicalMessage>';
    xml+='</ns:WSRequestSFRevChain>';
    xml+='</soapenv:Body>';
    xml+='</soapenv:Envelope>';
    
    xml=xml.replace('>null<', '><');
	return xml;
}

// Leer el servicio relacionado a la Operacion comercial, trayendo sus Servicios adicioinales
public map<String,ActivoETB__c> ConsultaDetalleServicioETB( String IdServicio)
{
		 map<String,ActivoETB__c> mapServicios = new map<String,ActivoETB__c> ([Select a.Id, a.Plan__c,a.Plan__r.LTE_TipoControl__c,a.PlanReferenciaAnterior__c,a.Fecha_Activacion__c, a.Estado__c, a.CuentaFacturacion__c, (Select Id, Name, CreatedDate, LTE_CatalogoProducto__c, LTE_PlanFacturacion__c,
		 LTE_SubPlaFacturacion__c, LTE_Estado__c, LTE_DetalleOfertaEReservadoRegContable__c, LTE_ServicioETB__c, LTE_ServiceIndicator__c, LTE_TypeCode__c, 
		 LTE_NetworkIndicator__c, LTE_PrimaryClassificationCode__c, LTE_ItemIdentification__c, LTE_ParentId__c, LTE_ServiceActionCode__c, LTE_NivelDescuento__c, 
		 Legalizacion__c From Servicios_adicionales__r where LTE_ServiceActionCode__c != 'ELIMINADO')  // PVTA LRPA - 26-11-2015
		 From ActivoETB__c a
		 where id =:IdServicio]);
		 
		 return mapServicios;
}

public map<String,LTE_DetalleOferta__c> ConsultaDetalleOferta(set<String> setidOperacionComercial)
{
	    system.debug('idOperacionComercial-->'+setidOperacionComercial);
	    
		map<String,LTE_DetalleOferta__c> mapDetalleOferta = new map<String,LTE_DetalleOferta__c>();
		
		list<LTE_DetalleOferta__c> lstDetOferta = [Select l.Plan__c, l.Name, l.LTE_ValorAntesImpuestosparaServicio__c, l.LTE_ValorAntesImpuestosparaEquipo__c, l.LTE_TipoTransaccion__c,
		l.LTE_Texto__c, l.LTE_Sucursal__c, l.LTE_SolicitadoPorTercero__c, l.LTE_Sociedad__c, l.LTE_SVA_s__c, l.LTE_RequierePortacion__c, l.LTE_ReferenciaEquipo__c, 
		l.LTE_OperacionComercial__c, l.LTE_Oferta_Economica__c, l.LTE_MinutoVoz__c, l.LTE_IMEI__c, l.LTE_ICCID__c, l.LTE_Estado__c,l.LTEValorEquipoDescuento__c, 
		l.LTE_EquipoTraido__c, l.LTE_Donante__c, l.LTE_DescuentoVoz__c, l.LTE_DescuentoSobreBolsaRecurrenteVoz__c, l.LTE_DescuentoSobreBolsaRecurrenteDatos__c,
		LTE_ReferenciaEquipo__r.LTE_ModeloComercial__c,LTE_ReferenciaEquipo__r.LTE_PartNumber__c,LTE_ReferenciaEquipo__r.LTE_Marca__c, 
		l.LTE_DescuentoPlan__c, l.LTE_DescuentoEquipos__c, l.LTE_DescuentoDatos__c, l.LTE_DatosNavegacion__c, l.LTE_CantidadEquipoOrdenar__c, l.LTE_BolsaRecurrenteVoz__c,
		l.LTE_BolsaRecurrenteDatos__c, l.Id, l.CreatedDate, (Select Id, Name, CreatedDate, LTE_CatalogoProducto__c, LTE_PlanFacturacion__c, LTE_SubPlaFacturacion__c, 
		LTE_Estado__c,  LTE_ServicioETB__c, LTE_ServiceIndicator__c, LTE_TypeCode__c, LTE_NetworkIndicator__c,
		LTE_PrimaryClassificationCode__c, LTE_ItemIdentification__c, LTE_ParentId__c, LTE_ServiceActionCode__c, LTE_NivelDescuento__c 
		From LTE_Servicios_adicionales__r where LTE_ServiceActionCode__c != 'ELIMINADO')  // PVTA LRPA - 26-11-2015
		From LTE_DetalleOferta__c l
		Where l.LTE_OperacionComercial__c =:setidOperacionComercial];
		
		for(LTE_DetalleOferta__c objDetOderta:lstDetOferta){
			mapDetalleOferta.put(objDetOderta.LTE_OperacionComercial__c,objDetOderta);
		}
		
	return mapDetalleOferta;
}

public list<LTE_SpecificationGroupXA__c> ConsultaXAS(set<String> listIdServAdic)
{
		//[AG 2016-02-18] Se incluye condicion para no tomar los XAs cuyo servicio adicional esté eliminado
	    system.debug('listIdServAdic-->'+listIdServAdic);
		list<LTE_SpecificationGroupXA__c> listaXas = [Select l.Name, l.LTE_Value__c, l.LTE_ServiciosAdicionales__c,l.LTE_ServiciosAdicionales__r.LTE_ServicioETB__c,
		 											  l.LTE_ActionCode__c, l.Id, l.CreatedDate,l.LTE_ServiciosAdicionales__r.LTE_DetalleOfertaEReservadoRegContable__c,
		 											  l.LTE_ParametroFacturacion__r.Objeto__c,l.LTE_ParametroFacturacion__r.Campo__c,
		 											  LTE_ServiciosAdicionales__r.LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__c,
                                                      LTE_ServiciosAdicionales__r.LTE_OC_Tramite__r.NumeroCanales__c,
                                                      LTE_ServiciosAdicionales__r.LTE_OC_Tramite__r.Tarifa_mensual_Bolsa_de_Moviles__c,
                                                      LTE_ServiciosAdicionales__r.LTE_OC_Tramite__r.Tarifa_mensual_Troncales_SIP__c,
                                                      LTE_ServiciosAdicionales__r.LTE_OC_Tramite__r.Valorunicavez__c,
                                                      LTE_ServiciosAdicionales__r.LTE_OC_Tramite__r.Valor__c,LTE_ServiciosAdicionales__r.Name,
                                                      LTE_ServiciosAdicionales__r.LTE_Operacion_Comercial_SVA__c
		 											  From LTE_SpecificationGroupXA__c l 
		 											  Where l.LTE_ServiciosAdicionales__c in:listIdServAdic And LTE_ServiciosAdicionales__r.LTE_ServiceActionCode__c != 'ELIMINADO'];
		
	return listaXas;
}


			
// Ibtener las opereaciones comerciales 
public map<string,OperacionComercial__c> OperacionesComerciales(set<string> idsOC)
{
	//llama los datos de la cuenta dentro del activo,y planes
	//[AG:2016-02-15 Se quitó el campo LTE_DireccionFacturacion__c]
	map<string,OperacionComercial__c> listOC =new map<string,OperacionComercial__c>([Select o.IDservicio__c,o.numeroConexion__c,createddate,	

			o.Legalizacion__r.LTE_CuentaFacturacion__c, o.FechaInicioReconexion__c,o.Legalizacion__r.LTE_CuentaFacturacion__r.Name, o.Legalizacion__r.LTE_CuentaFacturacion__r.DirCorresp__c, o.Legalizacion__r.LTE_CuentaFacturacion__r.CodCicloFac__c,
			o.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.Name,o.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.Padre__r.Name,o.Legalizacion__r.Estado__c,
			o.Legalizacion__r.LTE_CuentaFacturacion__r.TaxPlan__c,o.Legalizacion__r.LTE_CuentaFacturacion__r.Fue_creada_en_revchain__c,o.Legalizacion__r.LTE_CuentaFacturacion__r.Facturable__c,
			o.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.CodigoDane__c,CuentaCliente__r.Ciudad__r.Padre__r.CodigoDane__c,LTE_TipoTransaccion__c,
			o.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.Padre__r.CodigoDane__c,		
			o.ValorEquipos2__c,o.FechaFacturacion__c,o.FechaPendienteFacturacion__c,o.ValorObraCivil__c,o.ValorCargoInstalacion__c,Legalizacion__r.LTE_CuentaFacturacion__r.LTE_CicloFacturacion__c,
			o.Financiador__c,o.TipoFacturacion__c,o.TipoVenta__c,o.PlanSolucionTI__c,o.AliadoColaborador__c,o.Portacion__c,o.LTE_PIN__c,o.SDP__c,o.LTE_PUK__c,CuentaFacturacion__r.LTE_CicloFacturacion__c,
			o.Plan__r.NombrePlanSolucionTI__c,o.plan__r.Name,o.plan__r.NombredelProducto__c,o.Plan__r.NombredelProducto__r.Familia__c,o.LTE_IMSI__c,
			o.Plan__r.NombredelProducto__r.LineaNegocio__c,o.DescuentoPorc__c,o.CompensacionDatos__r.Name,o.LTE_ICCID__c,
			o.CuentaFacturacion__r.Tipo_Facturacion__c,o.CuentaFacturacion__r.Ciudad__r.Name,TOPP__r.Name,IMEI_del_Equipo__c,
			o.CuentaFacturacion__r.Ciudad__r.Indicativo__c,o.CuentaFacturacion__r.Ciudad__r.CodigoDane__c,o.Legalizacion__r.LTE_NFacturaVenta__c,
			o.CuentaFacturacion__r.DirCorresp__c,o.CuentaFacturacion__r.Fin_de_consumo__c,o.Oportunidad__r.CreatedDate,
			o.Moneda__c,o.Tipo_de_Conectividad__c,o.RangosDisponibilidad__c,Identificaci_n_del_Valor_NO_Recurente__c,
			o.CuentaCliente__c,o.Legalizacion__r.Contrato__r.Forma_de_Pago__c,o.fechadeActivacion__c,o.id,o.Capacidad__c,o.PlanAnterior__c,
			o.Valor_Recurrente_Aliado__c,o.CuentaFacturacion__c,o.CuentaFacturacion__r.Name,o.CuentaFacturacion__r.Ciudad__r.Padre__r.Name,
			o.CuentaFacturacion__r.Ciudad__r.Padre__r.CodigoDane__c,
			o.CuentaFacturacion__r.TaxPlan__c,o.CuentaFacturacion__r.Facturable__c,o.CuentaFacturacion__r.LTE_MetodoEnvio__c,
			o.CuentaFacturacion__r.Fue_creada_en_revchain__c,o.CuentaFacturacion__r.CodCicloFac__c,o.Legalizacion__r.Contrato__c,
			o.Legalizacion__r.Contrato__r.PlazoPago__c, o.Legalizacion__r.Contrato__r.CuentaFacturacion__r.Name,o.EnviadaFacturacionEquipo__c,
			o.Legalizacion__r.Contrato__r.SpecialTerms,o.Plan__c,o.TOPP__r.TipodeOperacionporplan__c,o.TOPP__r.Facturable__c,
			o.Valorunicavez__c, o.ValorTarifaPlan__c, o.Tarifa__c, o.Activo__r.Valorunicavez__c,o.Activo__r.IDservicio__c, 
			o.Activo__r.ValorTarifaPlan__c,o.Activo__r.AnchoBanda__r.Name,o.Activo__r.AnchoBanda__r.Numero__c,
			o.Activo__r.Plan__r.LTE_TipoControl__c,o.Activo__r.PlanReferenciaAnterior__c,
			o.Activo__r.AnchoBanda__r.Unidaddemedida__c,o.Activo__r.MedioUM__c,o.Activo__r.Equipo__c, o.Activo__r.SucursalOrigen__c,
			o.Activo__r.SucursalOrigen__r.Ciudad__r.Name,o.Activo__r.SucursalOrigen__r.Ciudad__r.CodigoDane__c,
			o.Activo__r.SucursalOrigen__r.Direccion__c, o.Activo__r.SucursalDestino__c,o.Activo__r.SucursalDestino__r.Direccion__c,
			o.Activo__r.SucursalDestino__r.Ciudad__r.Name,o.Activo__r.SucursalDestino__r.Ciudad__r.CodigoDane__c, Legalizacion__r.Cuotas__c,
			o.Activo__r.Plan__c,o.Activo__r.NombredelProducto__r.CodigoFacturacion__c,o.Activo__r.NombredelProducto__r.PremisasFacturacion__c,
			o.Activo__r.CuentaFacturacion__r.Name ,o.Activo__r.NumeroConexion__c,o.Activo__r.Nombredelcliente__c, 
			o.Activo__r.NombredelaCuenta__c, o.Activo__r.NombredelProducto__c, o.Activo__r.Name,o.Activo__r.Esmigrado__c, o.Activo__r.LTE_IdSiebel__c,o.Activo__r.LIneadeNegocio__c, 
			o.Activo__r.Familia__c, o.Activo__c,o.CuentaCliente__r.Departamento__c,o.CuentaCliente__r.Ciudad__r.Name,o.CuentaCliente__r.Ciudad__r.Indicativo__c,
			o.CuentaCliente__r.Ciudad__r.CodigoDane__c,o.CuentaCliente__r.AccountNumber,o.CuentaCliente__r.Tipodedocumento__c, 
			o.CuentaCliente__r.SubSegmento__c, o.CuentaCliente__r.Segmento__c, o.CuentaCliente__r.RazonSocial__c, o.CuentaCliente__r.Phone, 
			o.CuentaCliente__r.Name, o.CuentaCliente__r.Direccion__c, o.CuentaCliente__r.DigitodeVerificacion__c, o.CuentaCliente__r.Ciudad__c,
			Valor_Equipos__c,Valor_unica_Vez_Aliado__c,Tarifa_mensual_Bolsa_de_Moviles__c,Plan__r.LTE_MetodoDePago__c,NumeroCanales__c//,(Select Aliado__c, Tipo_de_Aliado__c From Viabilidades__r
			//where 	Respuestadeviabilidad__c='Viable') 
	From OperacionComercial__c o where o.id in :idsOC]);
	//llena el mapa de los planes
	return listOC;
}


//Obtener las operaciones comerciales relacionados con la Legelaizacion
public list<OperacionComercial__c> OperacionesComercialesLegalizacion(String idLegalizacion)
{
	//llama los datos de la cuenta dentro del activo,y planes
	//[AG:2016-02-15 Se cambio el campo LTE_DireccionFacturacion__c por DirCorresp__c]
	list<OperacionComercial__c> listOC =[Select o.IDservicio__c,o.numeroConexion__c,createddate,	

			o.Legalizacion__r.LTE_CuentaFacturacion__c, o.FechaInicioReconexion__c,o.Legalizacion__r.LTE_CuentaFacturacion__r.Name, o.Legalizacion__r.LTE_CuentaFacturacion__r.CodCicloFac__c,
			o.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.Name,o.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.Padre__r.Name,o.Legalizacion__r.Estado__c,
			o.Legalizacion__r.LTE_CuentaFacturacion__r.TaxPlan__c,o.Legalizacion__r.LTE_CuentaFacturacion__r.Fue_creada_en_revchain__c,o.Legalizacion__r.LTE_CuentaFacturacion__r.Facturable__c,
			o.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.CodigoDane__c,CuentaCliente__r.Ciudad__r.Padre__r.CodigoDane__c,LTE_TipoTransaccion__c,CuentaFacturacion__r.LTE_CicloFacturacion__c,
			o.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.Padre__r.CodigoDane__c,o.Legalizacion__r.LTE_CuentaFacturacion__r.DirCorresp__c,				
			o.ValorEquipos2__c,o.FechaFacturacion__c,o.FechaPendienteFacturacion__c,o.ValorObraCivil__c,o.ValorCargoInstalacion__c,Legalizacion__r.LTE_CuentaFacturacion__r.LTE_CicloFacturacion__c,
			o.Financiador__c,o.TipoFacturacion__c,o.TipoVenta__c,o.PlanSolucionTI__c,o.AliadoColaborador__c,o.Portacion__c,o.LTE_PIN__c,o.SDP__c,o.LTE_PUK__c,
			o.Plan__r.NombrePlanSolucionTI__c,o.plan__r.Name,o.plan__r.NombredelProducto__c,o.Plan__r.NombredelProducto__r.Familia__c,o.LTE_IMSI__c,
			o.Plan__r.NombredelProducto__r.LineaNegocio__c,o.DescuentoPorc__c,o.CompensacionDatos__r.Name,o.LTE_ICCID__c,
			o.CuentaFacturacion__r.Tipo_Facturacion__c,o.CuentaFacturacion__r.Ciudad__r.Name,TOPP__r.Name,IMEI_del_Equipo__c,
			o.CuentaFacturacion__r.Ciudad__r.Indicativo__c,o.CuentaFacturacion__r.Ciudad__r.CodigoDane__c,o.Legalizacion__r.LTE_NFacturaVenta__c,
			o.CuentaFacturacion__r.DirCorresp__c,o.CuentaFacturacion__r.Fin_de_consumo__c,o.Oportunidad__r.CreatedDate,
			o.Moneda__c,o.Tipo_de_Conectividad__c,o.RangosDisponibilidad__c,Identificaci_n_del_Valor_NO_Recurente__c,
			o.CuentaCliente__c,o.Legalizacion__r.Contrato__r.Forma_de_Pago__c,o.fechadeActivacion__c,o.id,o.Capacidad__c,
			o.Valor_Recurrente_Aliado__c,o.CuentaFacturacion__c,o.CuentaFacturacion__r.Name,o.CuentaFacturacion__r.Ciudad__r.Padre__r.Name,
			o.CuentaFacturacion__r.Ciudad__r.Padre__r.CodigoDane__c,
			o.CuentaFacturacion__r.TaxPlan__c,o.CuentaFacturacion__r.Facturable__c,o.CuentaFacturacion__r.LTE_MetodoEnvio__c,
			o.CuentaFacturacion__r.Fue_creada_en_revchain__c,o.CuentaFacturacion__r.CodCicloFac__c,o.Legalizacion__r.Contrato__c,
			o.Legalizacion__r.Contrato__r.PlazoPago__c, o.Legalizacion__r.Contrato__r.CuentaFacturacion__r.Name,o.EnviadaFacturacionEquipo__c,
			o.Legalizacion__r.Contrato__r.SpecialTerms,o.Plan__c,o.TOPP__r.TipodeOperacionporplan__c,o.TOPP__r.Facturable__c,
			o.Valorunicavez__c, o.ValorTarifaPlan__c, o.Tarifa__c, o.Activo__r.Valorunicavez__c,o.Activo__r.IDservicio__c, 
			o.Activo__r.ValorTarifaPlan__c,o.Activo__r.AnchoBanda__r.Name,o.Activo__r.AnchoBanda__r.Numero__c,
			o.Activo__r.AnchoBanda__r.Unidaddemedida__c,o.Activo__r.MedioUM__c,o.Activo__r.Equipo__c, o.Activo__r.SucursalOrigen__c,
			o.Activo__r.SucursalOrigen__r.Ciudad__r.Name,o.Activo__r.SucursalOrigen__r.Ciudad__r.CodigoDane__c,
			o.Activo__r.SucursalOrigen__r.Direccion__c, o.Activo__r.SucursalDestino__c,o.Activo__r.SucursalDestino__r.Direccion__c,
			o.Activo__r.SucursalDestino__r.Ciudad__r.Name,o.Activo__r.SucursalDestino__r.Ciudad__r.CodigoDane__c, Legalizacion__r.Cuotas__c,
			o.Activo__r.Plan__r.LTE_TipoControl__c,o.Activo__r.PlanReferenciaAnterior__c,
			o.Activo__r.Plan__c,o.Activo__r.NombredelProducto__r.CodigoFacturacion__c,o.Activo__r.NombredelProducto__r.PremisasFacturacion__c,
			o.Activo__r.CuentaFacturacion__r.Name ,o.Activo__r.NumeroConexion__c,o.Activo__r.Nombredelcliente__c, 
			o.Activo__r.NombredelaCuenta__c, o.Activo__r.NombredelProducto__c, o.Activo__r.Name,o.Activo__r.Esmigrado__c,o.Activo__r.LTE_IdSiebel__c, o.Activo__r.LIneadeNegocio__c, 
			o.Activo__r.Familia__c, o.Activo__c,o.CuentaCliente__r.Departamento__c,o.CuentaCliente__r.Ciudad__r.Name,o.CuentaCliente__r.Ciudad__r.Indicativo__c,
			o.CuentaCliente__r.Ciudad__r.CodigoDane__c,o.CuentaCliente__r.AccountNumber,o.CuentaCliente__r.Tipodedocumento__c, 
			o.CuentaCliente__r.SubSegmento__c, o.CuentaCliente__r.Segmento__c, o.CuentaCliente__r.RazonSocial__c, o.CuentaCliente__r.Phone, 
			o.CuentaCliente__r.Name, o.CuentaCliente__r.Direccion__c, o.CuentaCliente__r.DigitodeVerificacion__c, o.CuentaCliente__r.Ciudad__c,
			Valor_Equipos__c,Valor_unica_Vez_Aliado__c,Plan__r.LTE_MetodoDePago__c	
			From OperacionComercial__c o  
			where 	o.Legalizacion__r.id=:idLegalizacion
			and Estado__c !='Declinada' //?? activar esta liena
			]; 
	return listOC;
}

//metodo que arma la respuesta dependiendo del response
public map<string,string> recuperarRespuestaXML(Dom.Document doc)
{
	//Dom.Document doc = new Dom.Document();
	//doc.load(respuestaXML);//Here xmlstring data is from the above XML shown above
	//Retrieve the root element for this document.
	Dom.XMLNode env= doc.getRootElement();
	//system.debug('****'+env);
	//list<Dom.XmlNode> Body=env.getChildren();
	system.debug(env.getNamespace());
	string namespace = env.getNamespace();
	//system.debug('&&&&'+Body);
	//mapa que almacena todas las respuestas en strings: estado PASS o FAIL
	//respuesta Revchain
	map<string,string> mapRespuestas= new map<string,string>();
	 Dom.XMLNode Body=env.getChildElement('Body',namespace);
	 Dom.XMLNode ResponseRevChain;
	for(Dom.XmlNode nodo : Body.getChildren())
	{
		system.debug('nombre: '+nodo.getName());
		if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('WSResponseSFRevchain'))
			ResponseRevChain=nodo;
	}
	Dom.XMLNode CanonicalMessage;
	Dom.XMLNode WSResponseHeader;
	//agarro la respuesta y el canonico
	for(Dom.XmlNode nodo : ResponseRevChain.getChildren())
	{
		system.debug('nombre: '+nodo.getName());
		if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('CanonicalMessage'))
			CanonicalMessage=nodo;
		else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('WSResponseHeader'))
			WSResponseHeader=nodo;
	}
	system.debug('Canonico::'+CanonicalMessage.getNameSpace());
	
	system.debug('WSHeaderResponse'+WSResponseHeader.getNameSpace());
	Dom.XMLNode Service = WSResponseHeader.getChildElement('Service',WSResponseHeader.getNameSpace());
	system.debug(service);
	//Obtener del servicio status y fecha
	Dom.XMLNode Status = service.getChildElement('status',Service.getNameSpace());
	system.debug(Status.GetText());
	//recorrer el response y obtener la respuesta
	mapRespuestas.put('Estado',Status.GetText());
	//recorrer el canonico y buscar respuesta revchain, numeros de cuenta de facturacion
	Dom.XMLNode OrderFulfilment = CanonicalMessage.getChildElement('OrderFulfilment',CanonicalMessage.getNameSpace());
	Dom.XMLNode Sender;
	for(Dom.XmlNode nodo : OrderFulfilment.getChildren())
	{
		system.debug('nombre: '+nodo.getName());
		if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('Sender'))
			Sender=nodo;
		
	}
	
	system.debug('sentder '+Sender);
	/*Dom.XMLNode Description = Sender.getChildElement('Description',Sender.getNameSpace());
		if(Description!=null)
		{
			mapRespuestas.put('RespuestaRevChain',Description.getText());
		}*/
	Dom.XMLNode BillingProcess;
	for(Dom.XmlNode nodo : CanonicalMessage.getChildren())
	{
		system.debug('nombre: '+nodo.getName());
		if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('BillingProcess'))
			BillingProcess=nodo;
		
	}
	Dom.XMLNode BillingResponse;
	Dom.XMLNode CustomerBill;
	for(Dom.XmlNode nodo : BillingProcess.getChildren())
	{
		system.debug('nombre: '+nodo.getName());
		if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('BillingResponse'))
			BillingResponse=nodo;
		else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('CustomerBill'))
			CustomerBill=nodo;
		
	}
	
	
	system.debug('respuesta servicio:: '+BillingResponse);
	if(BillingResponse!=null)
	{
		mapRespuestas.put('RespuestaRevChain',BillingResponse.getText());
	}
	//extraer del CustomerBill los valores de la cuenta de facturacion
	Dom.XMLNode SuscriberId = CustomerBill.getChildElement('SuscriberId',CustomerBill.getNameSpace());
	if(SuscriberId!=null)
	{
		mapRespuestas.put('CuentaFacturacion',SuscriberId.getText());
	}
	Dom.XMLNode InvoicingCycle = CustomerBill.getChildElement('InvoicingCycle',CustomerBill.getNameSpace());
	if(InvoicingCycle!=null)
	{
		mapRespuestas.put('ciclo',InvoicingCycle.getText());
	}
	//enviar como texto el nodo customerBill para crear la cuenta de facturaci?n
	//mapRespuestas.put('cuentaFac',CustomerBill.toXmlString());
	return mapRespuestas;
}


	public  void guardar(list<LogTransacciones__c> logLst,list<OperacionComercial__c> lstOpeCom){
		
		Database.SaveResult[] lstOpeComResult =Database.update(lstOpeCom,false);
		//atabase.SaveResult[] logLstResult =Database.update(logLst,false);
		
		for(Integer i=0;i<lstOpeComResult.size();i++){
		    
		    if (lstOpeComResult[i].isSuccess()) {
		    }
		    else {
		        for(Database.Error err : lstOpeComResult[i].getErrors()) {
		            logLst[i].Error_Apex__c=err.getStatusCode() + ': ' + err.getMessage();
		        }
		    }
		}
		
		insert logLst;
		
	}
	
}