public class Acta_de_proveedor_PDF_ctr {
	// listas 
	public list<Bienes_y_servicios_Acta_de_proveedor__c> ListBienesYServicios = new  list<Bienes_y_servicios_Acta_de_proveedor__c>();
    // variables generales
    public String 	 			  idRecord							  {get; set;}
    public Actas_de_proveedor__c  objActaProveedor	 				  {get; set;}           
    public String 	 			  pageUrlExport			 			  {get; set;} 
    public String    			  urlLogoETB				 		  {get; set;} 
    public String				  tipoDePresupuestoOPEX				  {get; set;}
    public String				  tipoDePresupuestoCAPEX			  {get; set;}
    
    // variables que contienen las secciones del acta
    public String 	 			  htmlScriptHeader		 			  {get; set;}
    public String 	 			  htmlScriptHeader2		 			  {get; set;}
    public String 	 			  htmlPagina_1				 		  {get; set;}      
    public String 	 			  htmlPagina_2				 		  {get; set;}    
    public String 	 			  htmlPieDePagina			 		  {get; set;}
    public String 	 			  htmlBienesYServicios		 		  {get; set;}
    public String 	 			  htmlPaginaFirmas			 		  {get; set;}
    
    // variables para fórmulas    
    public decimal  			  valorResumenValoresConDescuento	  {get; set;}
    public decimal  			  IVA_ResumenValores  				  {get; set;}
    public decimal  			  ValorAPagarResumenValores			  {get; set;}
    public decimal				  sumatoriaValorTotal				  {get; set;}
    public decimal				  sumatoriaValorTotalSinCambioMoneda  {get; set;}
    public string				  ValorAPagarEnLetras				  {get; set;}	
    public string				  strMoneda;	
    ContratoColaboradorHelper_cls.ConvertirNumeroATexto clsHelper = new ContratoColaboradorHelper_cls.ConvertirNumeroATexto();
           
    public Acta_de_proveedor_PDF_ctr(ApexPages.StandardController controller){        
        idRecord = ApexPages.currentPage().getParameters().get('id');        
        pageUrlExport = '/apex/Acta_de_proveedor_PDF_pag?id='+idRecord;
        consultarActaProveedor();
        consultarBienesYServicios();
        procesarURLFile(); 
        procesarVariables();
        calcularCamposResumenDeValores();
        Generar_html_encabezado();
        Generar_html_pie_de_pagina();
        Generar_html_Pagina_1();
        Generar_html_Pagina_2();
        Generar_html_tabla_bienes_y_servicios();
        Generar_html_firmas();
    }
    public PageReference regresar(){        
		String url;
        url = '/'+idRecord;
		PageReference page = new PageReference(url);
		return page;
    }
    public void procesarURLFile(){
        string 		   idLogo_ETB;
        List<Document> lstDoc;
        lstDoc = [Select Id from Document where DeveloperName = 'Logo_ETB' limit 1];        
        if(lstDoc.size() > 0)
            idLogo_ETB = lstDoc[0].Id;  
        
        urlLogoETB = '/servlet/servlet.FileDownload?file='+idLogo_ETB;
    }
    
    public void procesarVariables(){
        if(objActaProveedor.Tipo_de_presupuesto__c == ''){
            tipoDePresupuestoOPEX  = '';
            tipoDePresupuestoCAPEX = '';
        }
        if(objActaProveedor.Tipo_de_presupuesto__c == 'OPEX'){
            tipoDePresupuestoOPEX  = 'X';
            tipoDePresupuestoCAPEX = '';
        }
        if(objActaProveedor.Tipo_de_presupuesto__c == 'CAPEX'){
            tipoDePresupuestoOPEX  = '';
            tipoDePresupuestoCAPEX = 'X';
        }  
        if(objActaProveedor.Moneda__c == 'Dólares')
            strMoneda = 'USD';
        
        if(objActaProveedor.Moneda__c == 'Pesos')
            strMoneda = '$';
    }
    public string procesarFecha(date fecha, string DMY){
        if(fecha != null){
            if(DMY == 'DD')
                return String.valueOf(fecha.day()); 
            else if (DMY == 'MM')
            	return String.valueOf(fecha.month());
            else if (DMY == 'AAAA')
            	return String.valueOf(fecha.year());
            else                
                return '';
        }else
            return '';  
    }
    public string obtenerNombreMes(string numeroMes){
        if(numeroMes == '1')
            return 'Enero';
		else if(numeroMes == '2')
            return 'Febrero';
        else if(numeroMes == '3')
            return 'Marzo';
        else if(numeroMes == '4')
            return 'Abril';
        else if(numeroMes == '5')
            return 'Mayo';
        else if(numeroMes == '6')
            return 'Junio';
        else if(numeroMes == '7')
            return 'Julio';
        else if(numeroMes == '8')
            return 'Agosto';
        else if(numeroMes == '9')
            return 'Septiembre';
        else if(numeroMes == '10')
            return 'Octubre';
        else if(numeroMes == '11')
            return 'Noviembre';
        else if(numeroMes == '12')
            return 'Diciembre';
        else
        	return null;
    }
    public void calcularCamposResumenDeValores(){        
        string valorAPagarEntero;
        string valorAPagarDecimal;
        string valorAPagarDecimalTemp;
        String ValorAPagarString;  
        
        // Calcular valor total
        sumatoriaValorTotal = 0;
        for(Bienes_y_servicios_Acta_de_proveedor__c objAux : ListBienesYServicios){
            sumatoriaValorTotal = sumatoriaValorTotal + (objAux.Valor_total__c==null?0:objAux.Valor_total__c);
        }
        sumatoriaValorTotalSinCambioMoneda = sumatoriaValorTotal;
        if(objActaProveedor.Moneda__c == 'Dólares' && objActaProveedor.Pagadero_en_dolares__c=='No')
            sumatoriaValorTotal = (sumatoriaValorTotal * objActaProveedor.TRM__c).setScale(2);
        
        valorResumenValoresConDescuento = (sumatoriaValorTotal - (objActaProveedor.Descuento_ANS__c== null?0:objActaProveedor.Descuento_ANS__c)).setScale(2);
        if (objActaProveedor.Valor_de_IVA_predefinido__c == null){
            IVA_ResumenValores = ((valorResumenValoresConDescuento * (objActaProveedor.IVA__c== null?0:objActaProveedor.IVA__c))/100).setScale(2);
        	ValorAPagarResumenValores = (valorResumenValoresConDescuento + IVA_ResumenValores).setScale(2);
        }else{
            IVA_ResumenValores = objActaProveedor.Valor_de_IVA_predefinido__c.setScale(2);
        	ValorAPagarResumenValores = (valorResumenValoresConDescuento + objActaProveedor.Valor_de_IVA_predefinido__c).setScale(2);
        } 
        
                
        
        // ------------------------------ calcular valor a pagar en cifras ----------------------------------------------------
        ValorAPagarString   	= String.valueOf(ValorAPagarResumenValores);
        valorAPagarDecimalTemp  = ValorAPagarString.substringAfter('.');   
        valorAPagarEntero   	= clsHelper.getCifraEnTexto((ValorAPagarResumenValores== null?0:ValorAPagarResumenValores).longValue());
        if(valorAPagarDecimalTemp != '' && Integer.valueOf(valorAPagarDecimalTemp) > 0){
            valorAPagarDecimal  = clsHelper.getCifraEnTexto(Integer.valueOf(valorAPagarDecimalTemp));
            ValorAPagarEnLetras = valorAPagarEntero+' '+(objActaProveedor.Pagadero_en_dolares__c=='Si'?'DÓLARES':'PESOS')+' CON '+valorAPagarDecimal+' CENTAVOS'+(objActaProveedor.Pagadero_en_dolares__c=='Si'?'.':' M/CTE.');
        }else{
            ValorAPagarEnLetras = valorAPagarEntero+' '+(objActaProveedor.Pagadero_en_dolares__c=='Si'?'DÓLARES':'PESOS')+''+(objActaProveedor.Pagadero_en_dolares__c=='Si'?'.':' M/CTE.');
        }        
        // ------------------------------ Fin calcular valor a pagar en cifras -----------------------------------------------                    
               
    }
    
    public string formatearCampoMoneda(Decimal valor){
        List<String> args = new String[]{'0','number','###,###,##0.00'};
        if(valor == null)            
        	return String.format('0', args);		
        else
            return String.format(valor.format(), args);		
    }
    // -------------------- Fin Métodos para convertir cifras en letras --------------------------------------------------//
       
    public void consultarActaProveedor(){
        objActaProveedor = 
            Database.query(' Select Id, Contrato_relacionado__r.Vicepresidencia__c, Area__c, Contrato_relacionado__r.Consecutivo__c, '
                          +' Contrato_relacionado__r.Aliado__r.Name, Acta_No__c, Tipo_de_servicio__c, Proyecto__c, Tipo_de_presupuesto__c, Valor_de_IVA_predefinido__c, '
                          +' Posicion_presupuestaria__c, Codigo_CAPEX__c, No_pedido_SAP__c, Hoja_de_entrada__c, Fecha_de_recepcion_del_bien_o_servicio__c,'
						  +' Registro_presupuestal__c, Contrato_relacionado__r.Supervisor_Administrativo__r.Name, Contrato_relacionado__r.Supervisor_Administrativo__r.Division,'
                          +' Cargo_del_representante_del_aliado__c, Representante_del_aliado__c, Anio_de_consumo__c, Mes_de_consumo__c, Soportes_entrega_bienes_y_servicios__c,'
                          +' Descripcion_resumen_de_valores__c, Descuento_ANS__c, IVA__c, Dias_calendario_a_pagar__c, Centro_gestor__c, Cantidad__c, Moneda__c, TRM__c, Pagadero_en_dolares__c,'
                          +' Numeral_ANS__c, Descripcion_de_ANS__c, Documento_soporte_1__c, Documento_soporte_2__c, Documento_soporte_3__c, Documento_soporte_4__c,'
                          +' Ciudad_expedicion_acta__r.Name, Contrato_relacionado__r.Supervisor_Administrativo__r.Title, Contrato_relacionado__r.Anexo__c, '
                          +' Tratamiento_representante_de_ETB__c, Tratamiento_representante_del_aliado__c, Fecha_de_acta__c, Firma_digital__c,PedidoOrdenServicio__c,NotasActa__c '
                          +' From Actas_de_proveedor__c '
                          +' Where Id=:idRecord');    
    }
     public void consultarBienesYServicios(){
        ListBienesYServicios = [Select Descripcion__c, Valor_unitario_del_contrato__c, Cantidad__c, Valor_total__c
                                From Bienes_y_servicios_Acta_de_proveedor__c
                                Where Acta_de_proveedor__c =: objActaProveedor.Id];
    }
    
    // :::::::::::::::::::::::::::::::::::::::::: GENERACIÓN DE HTML ::::::::::::::::::::::::::::::::::::::::::::::::::::
    public void Generar_html_encabezado(){
         htmlScriptHeader  =
            '<table style="width: 100%;">'+
            '<tbody>'+
            '<tr>'+
            '<td style="width: 27%; border: 0.5px solid;" colspan="3" align="center"><span class="contenido_16px">Código</span></td>'+
            '<td style="width: 48%; border: 0.5px solid;" align="center" ><span class="contenido_16px">Formato</span></td>'+
            '<td style="width: 25%; border: 0.5px solid;" rowspan="6" align="center"><img src="'+urlLogoETB+'" width="120" height="90" /></td>'+
            '</tr>'+
            '<tr>'+
            '<td style="width: 27%; border: 0.5px solid;" colspan="3" align="center"><span class="contenido_14px_NB">05–05.1.4- F -091 v.1</span></td>'+
            '<td style="width: 48%; border: 0.5px solid;" rowspan="3" align="center"><p><span class="contenido_16px">Acta de Recibo y/o Autorización de pago Vp Experiencia</span></p></td>'+
            '</tr>'+
            '<tr>'+
            '<td style="width: 27%; border: 0.5px solid;" colspan="3" align="center"><span class="contenido_14px">Fecha de emisión</span></td>'+
            '</tr>'+
            '<tr>'+
            '<td style="width: 9%; border: 0.5px solid;" align="center"><span class="contenido_14px_NB">15</span></td>'+
            '<td style="width: 9%; border: 0.5px solid;" align="center"><span class="contenido_14px_NB">04</span></td>'+
            '<td style="width: 9%; border: 0.5px solid;" align="center"><span class="contenido_14px_NB">2021</span></td>'+
            '</tr>'+           
            '<tr>'+
            '<td style="width: 27%; border: 0.5px solid;" colspan="3" align="center"><span class="contenido_16px">Confidencialidad</span></td>'+
            '<td style="width: 48%; border: 0.5px solid;" align="Left"><span class="contenido_16px">&nbsp;Interna</span></td>'+
            '</tr>'+
            '</tbody>'+
            '</table>';
        
        htmlScriptHeader2 =
            '<table style="width: 100%;">'+
            '<tbody>'+
            '<tr>'+
            '<td style="width: 30%; border: 0.5px solid; vertical-align:top"><span class="contenido_10px">Elaborado por:<br/><br/> _Gerencia Servicios Corporativos<br/><br/></span><span class="contenido_10px_NB">Equipo Supervisores Contrato</span><br/></td>'+
            '<td style="width: 39%; border: 0.5px solid; vertical-align:top"><span class="contenido_10px">Revisado por:<br/><br/>_Gerencia Servicios Corporativos<br/></span><span class="contenido_10px_NB">Clara Inés Molina Villamarín - Profesional Especializado<br/>Sandra Monje Pérez - Dinamizador GSC</span><br/></td>'+
            '<td style="width: 30%; border: 0.5px solid; vertical-align:top"><span class="contenido_10px">Aprobado por:<br/><br/>_Gerencia Servicios Corporativos<br/></span><span class="contenido_10px_NB">William Cabrera Velásquez - <br/>Gerente</span><br/></td>'+
            '</tr>'+
            '</tbody>'+
            '</table>';
    }
    public void Generar_html_pie_de_pagina(){
        htmlPieDePagina = 
            '<table style="width: 100%;" >'+
            '<tbody>'+	
            '<tr>'+
            '<td style="border: 0px;" align="Left"><span class="contenido_9px_NB_footer">07-07.7-F-024-v.3</span><br><span class="contenido_9px_Italic_NB_footer">“Una vez impreso este documento, se considerará</span><span class="contenido_9px_Italic_footer"> documento no controlado”.</span></td>'+
            '<td style="border: 0px;" align="Right"><span class="contenido_9px_NB_footer">02/03/2021</span><br><span class="contenido_9px_footer">Pág. </span><span class="pagenumber"/></td>'+
            '</tr>'+            		
            '</tbody>'+
            '</table>';
    }
    public void Generar_html_Pagina_1(){
        htmlPagina_1 = 
            '<br/>'+
            '<table style="width: 100%;">'+
            '<tbody>'+
            '<tr>'+
            '<td style="border: 0px solid;" align="Center"><span class="contenido_14px">EMPRESA DE TELECOMUNICACIONES DE BOGOTA S.A. ESP<br/>NIT No. 899.999.115-8</span></td>'+                        
            '</tr>'+
            '<tr>'+
            '<td></td>'+            				 
            '</tr>'+
            '<tr>'+
            '<td style="border: 0px;" align="Center"><span class="contenido_12px">VICEPRESIDENCIA DE '+(String.isBlank(objActaProveedor.Contrato_relacionado__r.Vicepresidencia__c)?'':objActaProveedor.Contrato_relacionado__r.Vicepresidencia__c)+'</span></td>'+
            '</tr>'+            			 
            '<tr>'+
            '<td style="border: 0px;" align="Center"><span class="contenido_12px">AREA: '+(String.isBlank(objActaProveedor.Area__c)?'':objActaProveedor.Area__c)+'</span></td>'+
            '</tr>'+
            '<tr>'+
            '<td style="border: 0px;" align="Center"><span class="contenido_12px">CONTRATO No. '+(String.isBlank(objActaProveedor.Contrato_relacionado__r.Anexo__c)?'':objActaProveedor.Contrato_relacionado__r.Anexo__c)+'</span></td>'+
            '</tr>'+
            '<tr>'+
            '<td style="border: 0px;" align="Center"><span class="contenido_12px">'+(String.isBlank(objActaProveedor.Contrato_relacionado__r.Aliado__r.Name)?'':objActaProveedor.Contrato_relacionado__r.Aliado__r.Name)+'</span></td>'+
            '</tr>'+
            '<tr>'+
            '<td style="border: 0px;" align="Center"><span class="contenido_12px">ACTA No. '+(String.isBlank(objActaProveedor.Acta_No__c)?'':objActaProveedor.Acta_No__c)+(String.isBlank(objActaProveedor.PedidoOrdenServicio__c)?'':' - PEDIDO U ORDEN DE SERVICIO No. '+objActaProveedor.PedidoOrdenServicio__c)+'<br><br>'+(String.isBlank(objActaProveedor.Tipo_de_servicio__c)?'':objActaProveedor.Tipo_de_servicio__c)+'</span></td>'+
            '</tr>'+
            '<tr>'+
            '<td style="border: 0px;" align="Center"><span class="contenido_12px">'+(String.isBlank(objActaProveedor.Proyecto__c)?'':'PROYECTO: '+objActaProveedor.Proyecto__c)+'</span></td>'+
            '</tr>'+
            '<tr>'+
            '<td style="border: 0px;" align="Left"><br/><span class="contenido_11px">Tipo Presupuesto: </span><span class="contenido_12px_NB">__</span><span class="contenido_11px">'+tipoDePresupuestoOPEX+'</span><span class="contenido_11px_NB">__OPEX__</span><span class="contenido_12px">'+tipoDePresupuestoCAPEX+'</span><span class="contenido_11px_NB">__CAPEX.</span></td>'+
            '</tr>'+
            '<tr>'+
            '<td style="border: 0px;" align="Left"><span class="contenido_11px">Posición presupuestaria: </span><span class="contenido_11px_NB">'+(String.isBlank(objActaProveedor.Posicion_presupuestaria__c)?'':objActaProveedor.Posicion_presupuestaria__c)+'</span></td>'+
            '</tr>'+
            '<tr>'+
            '<td style="border: 0px;" align="Left"><span class="contenido_11px_NB">Código CAPEX: '+(String.isBlank(objActaProveedor.Codigo_CAPEX__c)?'':objActaProveedor.Codigo_CAPEX__c)+'</span></td>'+
            '</tr>'+
            '<tr>'+
            '<td style="border: 0px;" align="Left"><span class="contenido_11px_NB">N° de pedido SAP: '+(String.isBlank(objActaProveedor.No_pedido_SAP__c)?'____________':objActaProveedor.No_pedido_SAP__c)+'<br>Hoja de entrada bienes/servicios N°: '+(String.isBlank(objActaProveedor.Hoja_de_entrada__c)?'____________':objActaProveedor.Hoja_de_entrada__c)+'</span></td>'+
            '</tr>'+
            '<tr>'+
            '<td style="border: 0px;" align="Left"><span class="contenido_11px_NB">Fecha de recepción del bien o servicio:  '+(String.isBlank(objActaProveedor.Fecha_de_recepcion_del_bien_o_servicio__c)?'':objActaProveedor.Fecha_de_recepcion_del_bien_o_servicio__c)+'</span></td>'+
            '</tr>'+
            '<tr>'+
            '<td style="border: 0px;" align="Left"><span class="contenido_11px_NB">Registro Presupuestal: '+(String.isBlank(objActaProveedor.Registro_presupuestal__c)?'':objActaProveedor.Registro_presupuestal__c)+'</span></td>'+
            '</tr>'+                       
            '</tbody>'+
            '</table>';                  	  
    }
    public void Generar_html_Pagina_2(){
        // Generación del valor a pagar en letras
        htmlPagina_2 = 
            '<table style="width: 100%;">'+
            '<tbody>'+
            '<tr>'+
            '<tr><td><br/></td></tr>'+
            '<td style="border: 0px;" align="Left"><div class="body"><span class="contenido_11px_NB">Mediante el presente documento, los representantes de la </span><span class="contenido_11px">EMPRESA DE TELECOMUNICACIONES DE BOGOTÁ S.A. E.S.P.,</span><span class="contenido_11px_NB"> '+(objActaProveedor.Tratamiento_representante_de_ETB__c == 'Señor'?'el señor':'la señora')+' '+(String.isBlank(objActaProveedor.Contrato_relacionado__r.Supervisor_Administrativo__r.Name)?'':objActaProveedor.Contrato_relacionado__r.Supervisor_Administrativo__r.Name)+', '+(String.isBlank(objActaProveedor.Contrato_relacionado__r.Supervisor_Administrativo__r.Division)?'':objActaProveedor.Contrato_relacionado__r.Supervisor_Administrativo__r.Division)+', supervisor del contrato por una parte, y '+(objActaProveedor.Tratamiento_representante_del_aliado__c == 'Señor'?'el señor':'la señora')+' '+(String.isBlank(objActaProveedor.Representante_del_aliado__c)?'':objActaProveedor.Representante_del_aliado__c)+' por la otra, quien actúa en su condición de Representante Legal (o su delegado según corresponda) de la  compañía '+(String.isBlank(objActaProveedor.Contrato_relacionado__r.Aliado__r.Name)?'':objActaProveedor.Contrato_relacionado__r.Aliado__r.Name)+', formalizan y protocolizan el recibo de '+(String.isBlank(objActaProveedor.Descripcion_resumen_de_valores__c)?'':objActaProveedor.Descripcion_resumen_de_valores__c)+' del periodo de '+(String.isBlank(objActaProveedor.Mes_de_consumo__c)?'':objActaProveedor.Mes_de_consumo__c)+' del CONTRATO '+(String.isBlank(objActaProveedor.Contrato_relacionado__r.Consecutivo__c)?'':objActaProveedor.Contrato_relacionado__r.Consecutivo__c)+'.</span></div></td>'+
            '</tr>'+   
            '<tr>'+
            '<td style="border: 0px;" align="Left"><div class="body"><span class="contenido_11px_NB"><br>Los soportes relacionados con la entrega de bienes y/o prestación de estos servicios son:</span></div></td>'+
            '</tr>'+
            '<tr>'+
            '<td style="border: 0px;" align="Left"><div class="body"><span class="contenido_11px_NB">'+(String.isBlank(objActaProveedor.Soportes_entrega_bienes_y_servicios__c)?'':objActaProveedor.Soportes_entrega_bienes_y_servicios__c)+' y reposarán en el archivo del Centro de Administración Documental de ETB. </span></div></td>'+
            '</tr>'+  
            //Generación de tabla de resumen de valores
            '<table style="width: 100%;">'+
            '<tbody>'+
            '<tr><td><br/></td></tr>'+
            '<tr>'+
            '<td style="border: 0px;" align="Left"><div class="body"><span class="contenido_11px_NB">El resumen de valores es:</span></div></td>'+
            '</tr>'+
            '<tr>'+
            '<td style="width: 31%; border: 0.3px solid;" align="Center"><span class="contenido_9px">DESCRIPCIÓN</span></td>'+
            '<td style="width: 15%; border: 0.3px solid;" align="Center"><span class="contenido_9px">VALOR</span></td>'+
            '<td style="width: 12%; border: 0.3px solid;" align="Center"><span class="contenido_9px">DESCUENTO ANS</span></td>'+
            '<td style="width: 15%; border: 0.3px solid;" align="Center"><span class="contenido_9px">VALOR CON DTO</span></td>'+
            '<td style="width: 12%; border: 0.3px solid;" align="Center"><span class="contenido_9px">IVA</span></td>'+
            '<td style="width: 15%; border: 0.3px solid;" align="Center"><span class="contenido_9px">VALOR A PAGAR</span></td>'+
            '</tr>'+
            '<tr>'+
            '<td style="width: 31%; border: 0.3px solid;" align="Center"><span class="contenido_9px_NB">'+(String.isBlank(objActaProveedor.Descripcion_resumen_de_valores__c)?'':objActaProveedor.Descripcion_resumen_de_valores__c)+'</span></td>'+
            '<td style="width: 15%; border: 0.3px solid;" align="Center"><span class="contenido_9px_NB">'+strMoneda+' '+formatearCampoMoneda(sumatoriaValorTotal)+'</span></td>'+
            '<td style="width: 12%; border: 0.3px solid;" align="Center"><span class="contenido_9px_NB">'+strMoneda+' '+formatearCampoMoneda((objActaProveedor.Descuento_ANS__c== null?0:objActaProveedor.Descuento_ANS__c))+'</span></td>'+
            '<td style="width: 15%; border: 0.3px solid;" align="Center"><span class="contenido_9px_NB">'+strMoneda+' '+formatearCampoMoneda(valorResumenValoresConDescuento)+'</span></td>'+
            '<td style="width: 12%; border: 0.3px solid;" align="Center"><span class="contenido_9px_NB">'+strMoneda+' '+formatearCampoMoneda(IVA_ResumenValores)+'</span></td>'+
            '<td style="width: 15%; border: 0.3px solid;" align="Center"><span class="contenido_10px_NB">'+strMoneda+' '+formatearCampoMoneda(ValorAPagarResumenValores)+'</span></td>'+
            '</tr>'+
            '</tbody>'+
            '</table>'+
            '<tr>'+
            '<td style="width: 100%; border: 0px ;"><span class="contenido_10px">TOTAL A PAGAR: '+ValorAPagarEnLetras+'</span></td>'+
            '</tr>'+
            '</tbody>'+
            '</table>'+       
            '<table style="width: 100%;">'+
            '<tbody>'+
            '<tr>'+
            '<td style="border: 0px;" align="Left"><div class="body"><span class="contenido_11px_NB"><br><br>Se pagará a los '+clsHelper.getCifraEnTexto(Integer.valueOf((objActaProveedor.Dias_calendario_a_pagar__c==null?0:objActaProveedor.Dias_calendario_a_pagar__c))).toLowercase()+' ('+(objActaProveedor.Dias_calendario_a_pagar__c==null?0:objActaProveedor.Dias_calendario_a_pagar__c)+') días calendario siguientes a la radicación de la factura, en el Equipo de Cuentas por Pagar de ETB, acompañada del acta de recibo a satisfacción del servicio, la cual debe estar suscrita por el supervisor del contrato y el contratista.</span></div></td>'+
            '</tr>'+
            '<tr>'+
            '<td style="border: 0px;" align="Left"><div class="body"><span class="contenido_11px_NB"><br>Para distribuir así:</span></div></td>'+
            '</tr>'+
            '</tbody>'+
            '</table>'; 
        // Tabla de distribución
        htmlPagina_2 += 
            '<table style="width: 100%;">'+
            '<tbody>'+
            '<tr>'+            				
            '<td style="width: 6%; border: 0.3px solid;" align="Center"><span class="contenido_8px">CENTRO GESTOR</span></td>'+
            '<td style="width: 14%; border: 0.3px solid;" align="Center"><span class="contenido_8px">TIPO DE PRESUPUESTO</span></td>'+
            '<td style="width: 13%; border: 0.3px solid;" align="Center"><span class="contenido_8px">PRECIO</span></td>'+
            '<td style="width: 6%; border: 0.3px solid;" align="Center"><span class="contenido_8px">CANTIDAD</span></td>'+
            '<td style="width: 12%; border: 0.3px solid;" align="Center"><span class="contenido_8px">VALOR NETO</span></td>'+
            '<td style="width: 12%; border: 0.3px solid;" align="Center"><span class="contenido_8px">IVA</span></td>'+
            '<td style="width: 13%; border: 0.3px solid;" align="Center"><span class="contenido_8px">VALOR TOTAL</span></td>'+
            '<td style="width: 6%; border: 0.3px solid;" align="Center"><span class="contenido_8px">MONEDA</span></td>'+
            '<td style="width: 8%; border: 0.3px solid;" align="Center"><span class="contenido_8px">TRM</span></td>'+
            '<td style="width: 10%; border: 0.3px solid;" align="Center"><span class="contenido_8px">PAGADEROS EN DOLARES</span></td>'+
            '</tr>'+ 
            '<tr>'+                            
            '<td style="width: 6%; border: 0.3px solid;" align="Center"><span class="contenido_9px_NB">'+(String.isBlank(objActaProveedor.Centro_gestor__c)?'':objActaProveedor.Centro_gestor__c)+'</span></td>'+
            '<td style="width: 14%; border: 0.3px solid;" align="Center"><span class="contenido_9px_NB">'+(String.isBlank(objActaProveedor.Tipo_de_presupuesto__c)?'':objActaProveedor.Tipo_de_presupuesto__c)+'</span></td>'+
            '<td style="width: 13%; border: 0.3px solid;" align="Center"><span class="contenido_9px_NB">'+strMoneda+' '+formatearCampoMoneda(sumatoriaValorTotal)+'</span></td>'+
            '<td style="width: 6%; border: 0.3px solid;" align="Center"><span class="contenido_9px_NB">'+(objActaProveedor.Cantidad__c==null?0:objActaProveedor.Cantidad__c)+'</span></td>'+
            '<td style="width: 12%; border: 0.3px solid;" align="Center"><span class="contenido_9px_NB">'+strMoneda+' '+formatearCampoMoneda(valorResumenValoresConDescuento)+'</span></td>'+
            '<td style="width: 12%; border: 0.3px solid;" align="Center"><span class="contenido_9px_NB">'+strMoneda+' '+formatearCampoMoneda(IVA_ResumenValores)+'</span></td>'+
            '<td style="width: 13%; border: 0.3px solid;" align="Center"><span class="contenido_9px_NB">'+strMoneda+' '+formatearCampoMoneda(ValorAPagarResumenValores)+'</span></td>'+
            '<td style="width: 6%; border: 0.3px solid;" align="Center"><span class="contenido_9px_NB">'+(String.isBlank(objActaProveedor.Moneda__c)?'':objActaProveedor.Moneda__c)+'</span></td>'+
            '<td style="width: 8%; border: 0.3px solid;" align="Center"><span class="contenido_9px_NB">'+strMoneda+' '+(objActaProveedor.TRM__c==null?0:objActaProveedor.TRM__c)+'</span></td>'+
            '<td style="width: 10%; border: 0.3px solid;" align="Center"><span class="contenido_9px_NB">'+(String.isBlank(objActaProveedor.Pagadero_en_dolares__c)?'':objActaProveedor.Pagadero_en_dolares__c)+'</span></td>'+
            '</tr>'+ 
            '</tbody>'+
            '</table>';            
    }
    public void Generar_html_tabla_bienes_y_servicios(){
        htmlBienesYServicios = 
            '<table style="width: 100%;">'+
            '<tbody>'+
            '<tr>'+
            '<td style="border: 0px;" align="Left"><div class="body"><span class="contenido_11px_NB">El detalle de cada bien/ servicio corresponde a:</span></div></td>'+
            '</tr>'+            
            '<tr>'+            				
            '<td style="width: 63%; border: 0.3px solid;" align="Center"><span class="contenido_9px">Descripción</span></td>'+
            '<td style="width: 17%; border: 0.3px solid;" align="Center"><span class="contenido_9px">Valor unitario del contrato</span></td>'+
            '<td style="width: 7%; border: 0.3px solid;" align="Center"><span class="contenido_9px">Cantidad</span></td>'+
            '<td style="width: 13%; border: 0.3px solid;" align="Center"><span class="contenido_9px">Valor total</span></td>'+
            '</tr>';
        for(Bienes_y_servicios_Acta_de_proveedor__c objAux : ListBienesYServicios)
        {
            htmlBienesYServicios +=
                '<tr>'+            				
                '<td style="width: 63%; border: 0.3px solid;" align="Left"><span class="contenido_9px_NB">'+(String.isBlank(objAux.Descripcion__c)?'':objAux.Descripcion__c)+'</span></td>'+
                '<td style="width: 17%; border: 0.3px solid;" align="Center"><span class="contenido_9px_NB">'+strMoneda+' '+formatearCampoMoneda((objAux.Valor_unitario_del_contrato__c==null?0:objAux.Valor_unitario_del_contrato__c))+'</span></td>'+
                '<td style="width: 7%; border: 0.3px solid;" align="Center"><span class="contenido_9px_NB">'+(objAux.Cantidad__c==null?0:objAux.Cantidad__c)+'</span></td>'+
                '<td style="width: 13%; border: 0.3px solid;" align="Right"><span class="contenido_9px_NB">'+strMoneda+' '+formatearCampoMoneda((objAux.Valor_total__c==null?0:objAux.Valor_total__c))+'</span></td>'+
                '</tr>';
        }
        htmlBienesYServicios +=
            '<tr>'+            				
            '<td colspan="4" style="width: 100%; border: 0.3px solid;" align="Right"><span class="contenido_10px">'+formatearCampoMoneda(sumatoriaValorTotalSinCambioMoneda)+'</span></td>'+
            '</tr>'+
            '</tbody>'+
            '</table>'+
            '<table style="width: 100%;">'+
            '<tbody>'+
            '<tr>'+
            '<td style="border: 0px;" align="Left"><div class="body"><span class="contenido_11px_NB">Atendiendo lo expresado en el numeral '+(String.isBlank(objActaProveedor.Numeral_ANS__c)?'':objActaProveedor.Numeral_ANS__c)+' de Nivel de Servicio de los términos de referencia, una vez validados los acuerdos de Nivel de servicios, para el período '+(objActaProveedor.Descuento_ANS__c > 0?'si':'no')+' generan descuentos en los bienes/ servicios, ';
        if(objActaProveedor.Descuento_ANS__c > 0){
            htmlBienesYServicios += 
                'conforme el siguiente detalle: </span></div></td>'+
                '</tr>'+
                '<tr>'+
                '<td style="border: 0px;" align="Left"><div class="body"><span class="contenido_11px">Descripción de ANS: </span><span class="contenido_11px_NB">'+(String.isBlank(objActaProveedor.Descripcion_de_ANS__c)?'':objActaProveedor.Descripcion_de_ANS__c)+'</span></div></td>'+
                '</tr>'+
                '<tr>'+
                '<td style="border: 0px;" align="Left"><div class="body"><span class="contenido_11px">Valor de descuento ANS: </span><span class="contenido_11px_NB">'+strMoneda+' '+formatearCampoMoneda((objActaProveedor.Descuento_ANS__c==null?0:objActaProveedor.Descuento_ANS__c))+'</span></div></td>'+
                '</tr>'+
                '</tbody>'+
                '</table>'; 
        }else{
            htmlBienesYServicios += 
                '</tr>'+            			 
                '</tbody>'+
                '</table>';     	
        }
        htmlBienesYServicios += 
            '<table style="width: 100%;">'+
            '<tbody>'+
            '<tr>'+
            '<td style="border: 0px;" align="Left"><div class="body"><span class="contenido_11px_NB">Como evidencia del cumplimiento de los hitos de pago, se anexan los siguientes documentos o soportes: </span></div></td>'+
            '</tr>'+
            '<tr>'+
            '<td>'+
            '<table style="width: 100%;">'+
            '<tbody>'+
            '<tr>'+
            '<td style="width: 50%; border: 0px;" align="Left"><div class="body"><span class="contenido_11px_NB">'+(String.isBlank(objActaProveedor.Documento_soporte_1__c)?'':'- '+objActaProveedor.Documento_soporte_1__c)+'</span></div></td>'+
            '<td style="width: 50%; border: 0px;" align="Left"><div class="body"><span class="contenido_11px_NB">'+(String.isBlank(objActaProveedor.Documento_soporte_2__c)?'':'- '+objActaProveedor.Documento_soporte_2__c)+'</span></div></td>'+
            '</tr>'+
            '<tr>'+
            '<td style="width: 50%; border: 0px;" align="Left"><div class="body"><span class="contenido_11px_NB">'+(String.isBlank(objActaProveedor.Documento_soporte_3__c)?'':'- '+objActaProveedor.Documento_soporte_3__c)+'</span></div></td>'+
            '<td style="width: 50%; border: 0px;" align="Left"><div class="body"><span class="contenido_11px_NB">'+(String.isBlank(objActaProveedor.Documento_soporte_4__c)?'':'- '+objActaProveedor.Documento_soporte_4__c)+'</span></div></td>'+
            '</tr>'+
            '</tbody>'+
            '</table>'+
            '</td>'+
            '</tr>'+
            '</tbody>'+
            '</table>'; 
    }
    public void Generar_html_firmas(){
        htmlPaginaFirmas = 
            '<br>'+
            '<table style="width: 100%;">'+
            '<tbody>'+
            '<tr>'+
            '<td style="border: 0px;" align="Left"><div class="body"><span class="contenido_11px_NB">Expedida en '+(String.isBlank(objActaProveedor.Ciudad_expedicion_acta__r.Name)?'':objActaProveedor.Ciudad_expedicion_acta__r.Name)+' a los '+clsHelper.getCifraEnTexto(Integer.valueOf(procesarFecha(objActaProveedor.Fecha_de_acta__c,'DD'))).toLowercase()+' ('+procesarFecha(objActaProveedor.Fecha_de_acta__c,'DD')+') días del mes de '+obtenerNombreMes(procesarFecha(objActaProveedor.Fecha_de_acta__c,'MM')).toLowercase()+' de '+procesarFecha(objActaProveedor.Fecha_de_acta__c,'AAAA')+'.</span></div></td>'+
            '</tr>'+            
            '</tbody>'+
            '</table>'+
            '<br>';
            if(objActaProveedor.Firma_digital__c){
                htmlPaginaFirmas+=
                '<table style="width: 100%;">'+
                '<tbody>'+
                '<tr>'+
                '<td style="border: 0px;" align="justify"><div class="body"><span class="contenido_11px" >Nota: La aceptación del presente documento se hará mediante el mecanismo de firma electrónica en los términos reconocidos en la Ley 527 de 1999 con el cumplimiento de los requisitos dispuestos en el decreto1074 de 2015 y demás normas que lo modifiquen o complementen, por lo que las partes reconocen que cumplido el procedimiento aquí establecido le otorgará la autenticidad a este documento y se obligan en los mismos términos que aquí se establecen.</span><br/></td>'+
                '</tr>'+
                '<tr><td><br/></td></tr>'+
                '<tr>'+
                '<td style="border: 0px;" align="justify"><div class="body"><span class="contenido_11px">Las hojas de registro de firmas electrónicas y reporte de trazabilidad que se encuentran al final de la presente Acta de Recibo y/o Autorización de pago Vp. Experiencia, hacen parte integral de la misma.</span></td>'+
                '</tr>'+
                (String.isBlank(objActaProveedor.NotasActa__c)?'':'<tr><td><br/></td></tr>'+
                '<tr>'+
                '<td style="border: 0px;" align="Left"><div class="body"><span class="contenido_11px_NB"><i>Nota: '+objActaProveedor.NotasActa__c+'</i></span></td></tr>')+
                '</tbody>'+
                '</table>';
            }else{
                htmlPaginaFirmas+=                
                '<table style="width: 100%;">'+
                '<tbody>'+
                '<tr>'+
                '<td style="width: 50%; border: 0px solid;" align="Left"><div class="body"><span class="contenido_11px">ETB S.A. ESP:</span></div></td>'+
                '<td style="width: 50%; border: 0px solid;" align="Left"><div class="body"><span class="contenido_11px">'+(String.isBlank(objActaProveedor.Contrato_relacionado__r.Aliado__r.Name)?'':objActaProveedor.Contrato_relacionado__r.Aliado__r.Name)+'</span></div></td>'+
                '</tr>'+
                '<tr>'+                  
            	'<td><br></td>'+            		
            	'</tr>'+
                '<tr>'+
                '<td style="width: 50%; border: 0px solid;" align="Left"><div class="body"><span class="contenido_11px_NB">_________________________________________</span></div></td>'+
                '<td style="width: 50%; border: 0px solid;" align="Left"><div class="body"><span class="contenido_11px_NB">_________________________________________</span></div></td>'+
                '</tr>'+
                '<tr>'+
                '<td style="width: 50%; border: 0px solid;" align="Left"><div class="body"><span class="contenido_11px">'+(String.isBlank(objActaProveedor.Contrato_relacionado__r.Supervisor_Administrativo__r.Name)?'':objActaProveedor.Contrato_relacionado__r.Supervisor_Administrativo__r.Name)+'</span></div></td>'+
                '<td style="width: 50%; border: 0px solid;" align="Left"><div class="body"><span class="contenido_11px">'+(String.isBlank(objActaProveedor.Representante_del_aliado__c)?'':objActaProveedor.Representante_del_aliado__c)+'</span></div></td>'+
                '</tr>'+
                '<tr>'+
                '<td style="width: 50%; border: 0px solid;" align="Left"><div class="body"><span class="contenido_11px">'+(String.isBlank(objActaProveedor.Contrato_relacionado__r.Supervisor_Administrativo__r.Title)?'':objActaProveedor.Contrato_relacionado__r.Supervisor_Administrativo__r.Title)+'</span></div></td>'+
                '<td style="width: 50%; border: 0px solid;" align="Left"><div class="body"><span class="contenido_11px">'+(String.isBlank(objActaProveedor.Cargo_del_representante_del_aliado__c)?'':objActaProveedor.Cargo_del_representante_del_aliado__c)+'</span></div></td>'+
                '</tr>'+
                '<tr>'+
                '<td style="width: 50%; border: 0px solid;" align="Left"><div class="body"><span class="contenido_11px">ETB</span></div></td>'+
                '<td style="width: 50%; border: 0px solid;" align="Left"><div class="body"><span class="contenido_11px"></span></div></td>'+
                '</tr>'+
                '</tbody>'+
                '</table>'+
                '</td>'+
                '</tr>'+
                '</tbody>'+
                '</table>';                
            }                        
        htmlPaginaFirmas +=
            '<br>'+
            '<br>'+
            '<table style="width: 100%;">'+
            '<tbody>'+            
            '<tr>'+
            '<td style="border: 0px;" align="Left"><div class="body"><span class="contenido_10px">Control de Cambios:</span></div></td>'+
        	'</tr>'+
            '</tbody>'+
            '</table>'+
            
            '<table style="width: 90%;" align="Center">'+
            '<tbody>'+
            '<tr>'+
            '<td style="width: 20%; border: 0.3px solid;" align="Center"><span class="contenido_10px">Version</span></td>'+
            '<td style="width: 50%; border: 0.3px solid;" align="Center"><span class="contenido_10px">Descripción del Cambio</span></td>'+
            '<td style="width: 30%; border: 0.3px solid;" align="Center"><span class="contenido_10px">Fecha del Cambio</span></td>'+
        	'</tr>'+
            '<tr>'+
            '<td style="width: 20%; border: 0.3px solid;" align="Left"><span class="contenido_9px_NB_controlversion">&nbsp;&nbsp;v.1</span></td>'+
            '<td style="width: 50%; border: 0.3px solid;" align="Left"><span class="contenido_9px_NB_controlversion"> Documento origen</span></td>'+
            '<td style="width: 30%; border: 0.3px solid;" align="Center"><span class="contenido_9px_NB_controlversion"></span></td>'+
        	'</tr>'+
            '</tbody>'+
            '</table>';
    }
}