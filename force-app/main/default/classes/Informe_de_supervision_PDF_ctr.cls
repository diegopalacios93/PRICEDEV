public class Informe_de_supervision_PDF_ctr {
    
    public String 	 idRecord;  
    public Contract  objContract 		 				  {get; set;}           
    public String 	 htmlScript			 				  {get; set;} 
    public String 	 htmlScriptHeader		 			  {get; set;}
    public String 	 htmlScriptHeader2		 			  {get; set;}
    public String 	 htmlScriptModificacion				  {get; set;}
    public String 	 htmlScriptOrdenServicio			  {get; set;}
    public String 	 htmlScriptEjecucionContrato		  {get; set;}
    public String 	 htmlScriptSanciones				  {get; set;}
    public String 	 htmlScriptPagos					  {get; set;}
    public String 	 htmlScriptFirmas					  {get; set;}
    public String 	 htmlScriptControlCambio			  {get; set;}
    public String 	 htmlScriptInfoGeneral				  {get; set;}    
    public String 	 diaMaxLiquidacion		 			  {get; set;}
    public String 	 mesMaxLiquidacion		 			  {get; set;}
    public String 	 anioMaxLiquidacion	 				  {get; set;}   
    public String    chkBoxContHomologVig_SI   			  {get; set;}
    public String    chkBoxContHomologVig_NO    		  {get; set;}
    public String    chkBoxAsigRecursosPres_SI 			  {get; set;}
    public String    chkBoxAsigRecursosPres_NO 			  {get; set;}    
    public String    chkBoxAsigRecursosPres_NA 			  {get; set;}
    public String    chkBoxRenovacionAutom	 			  {get; set;}
    public String    urlLogoETB				 			  {get; set;}  
	public String 	 pageUrlExport						  {get; set;}    
    public decimal   valorInicialContrato				  {get; set;}
    public decimal   valorInicialContratoDolares		  {get; set;}
    public decimal   valorTotalSinIvaAdicion			  {get; set;}
    public decimal   valorTotalIvaAdicion				  {get; set;}
    public decimal   valorTotalConIvaAdicion			  {get; set;}
    public decimal   valorTotalSinIvaAdicionDolares		  {get; set;}
    public decimal   valorTotalIvaAdicionDolares		  {get; set;}
    public decimal   valorTotalConIvaAdicionDolares		  {get; set;}
    public decimal   valorTotalconAdSinIvaAdicion		  {get; set;}
    public decimal   valorTotalconAdIvaAdicion			  {get; set;}
    public decimal   valorTotalconAdConIvaAdicion		  {get; set;}    
    public decimal   valorTotalconAdSinIvaAdicionDolares  {get; set;}
    public decimal   valorTotalconAdIvaAdicionDolares	  {get; set;}
    public decimal   valorTotalconAdConIvaAdicionDolares  {get; set;}
	public decimal   valorTotalRelacionPedido			  {get; set;}
	public decimal   valorTotalIvaRelacionPedido		  {get; set;}
	public decimal   valorTotalConIvaRelacionPedido		  {get; set;}
	public decimal   valorTotalRelacionPedidoDolares	  {get; set;}
	public decimal   valorTotalIvaRelacionPedidoDolares	  {get; set;}
	public decimal   valorTotalConIvaRelacionPedidoDolares{get; set;}    
    public decimal   valorTotalSancionMulta				  {get; set;}    
    public decimal	 totalComprometidoSinIVA_SI			  {get; set;}
    public decimal	 totalComprometidoSinIva_NO			  {get; set;}
    public decimal	 totalComprometidoIVA_SI			  {get; set;}
    public decimal	 totalComprometidoIva_NO			  {get; set;}
    public decimal	 totalComprometidoconIVA_SI			  {get; set;}
    public decimal	 totalComprometidoconIva_NO			  {get; set;}
    public decimal	 totalComprometidoSinIVA_SIDolares	  {get; set;}
	public decimal	 totalComprometidoIVA_SIDolares		  {get; set;}
	public decimal	 totalComprometidoconIVA_SIDolares	  {get; set;}
	public decimal	 totalComprometidoSinIVA_NODolares	  {get; set;}
	public decimal	 totalComprometidoIVA_NODolares		  {get; set;}
	public decimal	 totalComprometidoconIVA_NODolares	  {get; set;}
    public decimal	 saldoDisponible					  {get; set;}
    public decimal	 saldoDisponibleDolares				  {get; set;}
    public date 	 fechaInforme						  {get; set;}	
    // listas
    public list<Adiciones_y_prorrogas_contratos__c>    lstProrroga 		 = new list<Adiciones_y_prorrogas_contratos__c>();
    public list<Conciliaciones_de_contrato__c> 		   lstActas 		 = new list<Conciliaciones_de_contrato__c>();
    public list<Relacion_pedido_orden_servicio__c>	   lstRelacionPedido = new list<Relacion_pedido_orden_servicio__c>();
    public list<Sanciones_Multas_Incumplimientos__c>   lstMultas	     = new list<Sanciones_Multas_Incumplimientos__c>();
    
    
    public Informe_de_supervision_PDF_ctr(ApexPages.StandardController controller){
        idRecord = ApexPages.currentPage().getParameters().get('id');        
        pageUrlExport = '/apex/Informe_de_supervision_PDF_pag?id='+idRecord;
        consultarContrato(idRecord);        
        procesarURLFile(objContract.Status);        
        consultarProrrogas(idRecord);        
        consultarActas(idRecord);        
        counsultarPedidos_OC(idRecord);        
        counsultarMultas(idRecord);        
        calcularCamposReporte();        
        Generar_html_encabezado();
        Generar_html_info_general();
        Generar_html_modificaciones();
        Generar_html_orden_servicio();
        Generar_html_pagos();
    	Generar_html_ejecucion_contrato();  
  	    Generar_html_sanciones();
        Generar_html_firmas();
        Generar_html_control_cambio();
    }     
    public void procesarURLFile(String Status){        
        string idCheck_ok_1, idCheck_nok_1, idCheck_ok_2, idCheck_nok_2, idLogo_ETB;
        List<Document> lstDoc;
        lstDoc = [Select Id from Document where DeveloperName = 'check_ok_1' limit 1];        
        if(lstDoc.size() > 0)
            idCheck_ok_1 = lstDoc[0].Id;
        
        lstDoc = [Select Id from Document where DeveloperName = 'check_ok_2' limit 1];        
        if(lstDoc.size() > 0)
            idCheck_ok_2 = lstDoc[0].Id;
        
        lstDoc = [Select Id from Document where DeveloperName = 'check_nok_1' limit 1];        
        if(lstDoc.size() > 0)
            idCheck_nok_1 = lstDoc[0].Id;
        
        lstDoc = [Select Id from Document where DeveloperName = 'check_nok_2' limit 1];        
        if(lstDoc.size() > 0)
            idCheck_nok_2 = lstDoc[0].Id;
        
        lstDoc = [Select Id from Document where DeveloperName = 'Logo_ETB' limit 1];        
        if(lstDoc.size() > 0)
            idLogo_ETB = lstDoc[0].Id;        
        
        if(objContract.Contratista_con_homologacion_vigente__c){
            chkBoxContHomologVig_SI = '/servlet/servlet.FileDownload?file='+idCheck_ok_1;                       
            chkBoxContHomologVig_NO = '/servlet/servlet.FileDownload?file='+idCheck_nok_1;                
        }else{
        	chkBoxContHomologVig_SI = '/servlet/servlet.FileDownload?file='+idCheck_nok_1;                       
            chkBoxContHomologVig_NO = '/servlet/servlet.FileDownload?file='+idCheck_ok_1; 
        }
        
        if(objContract.Renovacion_automatica_contrato__c)
            chkBoxRenovacionAutom = '/servlet/servlet.FileDownload?file='+idCheck_ok_1; 
        else
            chkBoxRenovacionAutom = '/servlet/servlet.FileDownload?file='+idCheck_nok_1;             
		
		if(objContract.Asignacion_recursos_presupuestales__c){
            chkBoxAsigRecursosPres_SI = '/servlet/servlet.FileDownload?file='+idCheck_ok_1;                       
            chkBoxAsigRecursosPres_NO = '/servlet/servlet.FileDownload?file='+idCheck_nok_1;                
        }else{
        	chkBoxAsigRecursosPres_SI = '/servlet/servlet.FileDownload?file='+idCheck_nok_1;                       
            chkBoxAsigRecursosPres_NO = '/servlet/servlet.FileDownload?file='+idCheck_ok_1; 
        }                         
        chkBoxAsigRecursosPres_NA = '/servlet/servlet.FileDownload?file='+idCheck_nok_1;
        urlLogoETB = '/servlet/servlet.FileDownload?file='+idLogo_ETB;            
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
    
    public string formatearCampoMoneda(Decimal valor){
        List<String> args = new String[]{'0','number','###,###,##0.00'};
        if(valor == null)            
        	return String.format('0', args);		
        else
            return String.format(valor.format(), args);		
    }
    
    public void calcularCamposReporte(){
        valorInicialContrato = (objContract.Valor_total__c== null?0:objContract.Valor_total__c) - (objContract.Valor_adiciones__c== null?0:objContract.Valor_adiciones__c);
        valorInicialContratoDolares = (objContract.Valor_total_incluido_IVA_en_dolares__c== null?0:objContract.Valor_total_incluido_IVA_en_dolares__c) - (objContract.Valor_adiciones_en_dolares__c== null?0:objContract.Valor_adiciones_en_dolares__c);
        valorTotalSinIvaAdicion 				= 0;
        valorTotalIvaAdicion					= 0;
        valorTotalConIvaAdicion 				= 0;
        valorTotalconAdSinIvaAdicion			= 0;
		valorTotalconAdIvaAdicion				= 0;
		valorTotalconAdConIvaAdicion			= 0;
        totalComprometidoSinIVA_SI				= 0;
        totalComprometidoSinIva_NO				= 0;
        totalComprometidoIVA_SI					= 0;
        totalComprometidoIva_NO    				= 0;
        totalComprometidoconIVA_SI				= 0;
        totalComprometidoconIva_NO    			= 0;
        saldoDisponible							= 0;
        saldoDisponibleDolares					= 0;
        valorTotalSinIvaAdicionDolares			= 0;
		valorTotalIvaAdicionDolares				= 0;
		valorTotalConIvaAdicionDolares			= 0;
        valorTotalconAdSinIvaAdicionDolares		= 0;
		valorTotalconAdIvaAdicionDolares		= 0;
		valorTotalconAdConIvaAdicionDolares 	= 0;
        valorTotalRelacionPedido				= 0;
		valorTotalIvaRelacionPedido				= 0;
		valorTotalConIvaRelacionPedido			= 0;
		valorTotalRelacionPedidoDolares			= 0;
		valorTotalIvaRelacionPedidoDolares		= 0;
		valorTotalConIvaRelacionPedidoDolares	= 0;
        totalComprometidoSinIVA_SIDolares		= 0;
		totalComprometidoIVA_SIDolares			= 0;
		totalComprometidoconIVA_SIDolares		= 0;
		totalComprometidoSinIVA_NODolares		= 0;
		totalComprometidoIVA_NODolares			= 0;
		totalComprometidoconIVA_NODolares		= 0;
        valorTotalSancionMulta					= 0;
        
        for(Adiciones_y_prorrogas_contratos__c objProrroga_aux : lstProrroga){            
            valorTotalSinIvaAdicion = valorTotalSinIvaAdicion + (objProrroga_aux.Valor_antes_de_IVA__c== null?0:objProrroga_aux.Valor_antes_de_IVA__c);
            valorTotalIvaAdicion	= valorTotalIvaAdicion    + (objProrroga_aux.IVA__c== null?0:objProrroga_aux.IVA__c);
            valorTotalConIvaAdicion = valorTotalConIvaAdicion + (objProrroga_aux.Valor_total__c== null?0:objProrroga_aux.Valor_total__c);           
            
            valorTotalSinIvaAdicionDolares  = valorTotalSinIvaAdicionDolares + (objProrroga_aux.Valor_sin_IVA_en_dolares__c== null?0:objProrroga_aux.Valor_sin_IVA_en_dolares__c);
            valorTotalIvaAdicionDolares		= valorTotalIvaAdicionDolares    + (objProrroga_aux.IVA_en_dolares__c== null?0:objProrroga_aux.IVA_en_dolares__c);
            valorTotalConIvaAdicionDolares  = valorTotalConIvaAdicionDolares + (objProrroga_aux.Valor_total_incluido_IVA_en_dolares__c== null?0:objProrroga_aux.Valor_total_incluido_IVA_en_dolares__c); 
            
        }        
        valorTotalconAdSinIvaAdicion 		= (objContract.Valor_sin_IVA__c== null?0:objContract.Valor_sin_IVA__c) +  valorTotalSinIvaAdicion;
        valorTotalconAdIvaAdicion	 		= (objContract.IVA_Contrato_Colaborador__c== null?0:objContract.IVA_Contrato_Colaborador__c) + valorTotalIvaAdicion;
        valorTotalconAdConIvaAdicion 		= valorTotalconAdSinIvaAdicion + valorTotalconAdIvaAdicion;
        
        valorTotalconAdSinIvaAdicionDolares	= (objContract.Valor_sin_IVA_en_dolares__c== null?0:objContract.Valor_sin_IVA_en_dolares__c) +  valorTotalSinIvaAdicionDolares;
        valorTotalconAdIvaAdicionDolares	= (objContract.IVA_en_dolares__c== null?0:objContract.IVA_en_dolares__c) + valorTotalIvaAdicionDolares;
        valorTotalconAdConIvaAdicionDolares	= valorTotalconAdSinIvaAdicionDolares + valorTotalconAdIvaAdicionDolares;
        //--------------------------------------------------------------------------------------------------//
        
        for(Conciliaciones_de_contrato__c objConciliacion_aux : lstActas){
            if(objConciliacion_aux.Facturado__c == 'SI'){
                totalComprometidoSinIVA_SI 		   = totalComprometidoSinIVA_SI + (objConciliacion_aux.Valor_sin_IVA__c== null?0:objConciliacion_aux.Valor_sin_IVA__c);
                totalComprometidoIVA_SI	   		   = totalComprometidoIVA_SI    + (objConciliacion_aux.IVA__c== null?0:objConciliacion_aux.IVA__c);
                totalComprometidoconIVA_SI 		   = totalComprometidoconIVA_SI + (objConciliacion_aux.Valor_total_incluido_IVA__c== null?0:objConciliacion_aux.Valor_total_incluido_IVA__c);
                
                totalComprometidoSinIVA_SIDolares  = totalComprometidoSinIVA_SIDolares + (objConciliacion_aux.Valor_sin_Iva_en_dolares__c== null?0:objConciliacion_aux.Valor_sin_Iva_en_dolares__c);
                totalComprometidoIVA_SIDolares	   = totalComprometidoIVA_SIDolares    + (objConciliacion_aux.IVA_en_dolares__c== null?0:objConciliacion_aux.IVA_en_dolares__c);
                totalComprometidoconIVA_SIDolares  = totalComprometidoconIVA_SIDolares + (objConciliacion_aux.Valor_total_incluido_IVA_en_dolares__c== null?0:objConciliacion_aux.Valor_total_incluido_IVA_en_dolares__c);
            }
            if(objConciliacion_aux.Facturado__c == 'NO'){
                totalComprometidoSinIVA_NO 		   = totalComprometidoSinIVA_NO + (objConciliacion_aux.Valor_sin_IVA__c== null?0:objConciliacion_aux.Valor_sin_IVA__c);
                totalComprometidoIVA_NO	   		   = totalComprometidoIVA_NO    + (objConciliacion_aux.IVA__c== null?0:objConciliacion_aux.IVA__c);
                totalComprometidoconIVA_NO 		   = totalComprometidoconIVA_NO + (objConciliacion_aux.Valor_total_incluido_IVA__c== null?0:objConciliacion_aux.Valor_total_incluido_IVA__c);
                
                totalComprometidoSinIVA_NODolares  = totalComprometidoSinIVA_NODolares + (objConciliacion_aux.Valor_sin_Iva_en_dolares__c== null?0:objConciliacion_aux.Valor_sin_Iva_en_dolares__c);
                totalComprometidoIVA_NODolares	   = totalComprometidoIVA_NODolares    + (objConciliacion_aux.IVA_en_dolares__c== null?0:objConciliacion_aux.IVA_en_dolares__c);
                totalComprometidoconIVA_NODolares  = totalComprometidoconIVA_NODolares + (objConciliacion_aux.Valor_total_incluido_IVA_en_dolares__c== null?0:objConciliacion_aux.Valor_total_incluido_IVA_en_dolares__c);
            }
        }
        //--------------------------------------------------------------------------------------------------//
        for(Relacion_pedido_orden_servicio__c objRelacionPedido_aux : lstRelacionPedido){            
            valorTotalRelacionPedido 			   = valorTotalRelacionPedido + (objRelacionPedido_aux.Valor_sin_IVA__c== null?0:objRelacionPedido_aux.Valor_sin_IVA__c);
            valorTotalIvaRelacionPedido			   = valorTotalIvaRelacionPedido    + (objRelacionPedido_aux.IVA__c== null?0:objRelacionPedido_aux.IVA__c);
            valorTotalConIvaRelacionPedido  	   = valorTotalConIvaRelacionPedido + (objRelacionPedido_aux.Valor_total_incluido_IVA__c== null?0:objRelacionPedido_aux.Valor_total_incluido_IVA__c);           
            
            valorTotalRelacionPedidoDolares 	   = valorTotalRelacionPedidoDolares + (objRelacionPedido_aux.Valor_sin_IVA_en_dolares__c== null?0:objRelacionPedido_aux.Valor_sin_IVA_en_dolares__c);
            valorTotalIvaRelacionPedidoDolares	   = valorTotalIvaRelacionPedidoDolares    + (objRelacionPedido_aux.IVA_en_dolares__c== null?0:objRelacionPedido_aux.IVA_en_dolares__c);
            valorTotalConIvaRelacionPedidoDolares  = valorTotalConIvaRelacionPedidoDolares + (objRelacionPedido_aux.Valor_total_incluido_IVA_en_dolares__c== null?0:objRelacionPedido_aux.Valor_total_incluido_IVA_en_dolares__c);           
        }
		//--------------------------------------------------------------------------------------------------//
		for(Sanciones_Multas_Incumplimientos__c objMulta_aux : lstMultas)            
        	valorTotalSancionMulta = valorTotalSancionMulta + (objMulta_aux.Valor__c== null?0:objMulta_aux.Valor__c);
		//--------------------------------------------------------------------------------------------------//		
		saldoDisponible 	   = (valorInicialContrato + valorTotalConIvaAdicion)-totalComprometidoconIva_SI-(objContract.Valor_total_comprometido_conIVA_escritur__c==null?0:objContract.Valor_total_comprometido_conIVA_escritur__c);        
        saldoDisponibleDolares = (valorInicialContratoDolares + valorTotalConIvaAdicionDolares)-totalComprometidoconIVA_SIDolares-totalComprometidoconIVA_NODolares;
        //--------------------------------------------------------------------------------------------------//
        if(objContract.Fecha_elaboracion_de_informe_supervision__c == null){
            fechaInforme = system.today();
        }else{
            fechaInforme = objContract.Fecha_elaboracion_de_informe_supervision__c;
        }     
    }
    // :::::::::::::::::::::::::::::::::::::::::: CONSULTA DE DATOS  ::::::::::::::::::::::::::::::::::::::::::::::::::::
    
    public void consultarContrato(String idContrato){
        objContract = Database.query('Select Anexo__c, Account.Name, Aliado__r.Name, NIT_Aliado__c, Fecha_elaboracion_de_informe_supervision__c, '
                                     +'ID_Registro__c, Consecutivo__c, Consecutivo_CAD__c, Supervisor_Administrativo__r.Name, '
                                     +'Fecha_de_suscripcion__c, Fecha_de_inicio__c, Fecha_de_terminacion__c, Tipo_de_contrato__c, '
                                     +'Plazo_de_ejecucion__c, Plazo_de_ejecucion_escritura__c, Tiempo_de_liquidacion__c, Fecha_maxima_de_liquidacion__c, Status, '
                                     +'Objeto__c, Valor_sin_IVA__c, Porcentaje_IVA__c, IVA_Contrato_Colaborador__c, Valor_total__c, '
                                     +'Valor_adiciones__c, Numero_de_adiciones__c, Ejecutado__c, Valor_ejecutado_calculado_escritura__c, Valor_ejecutado_calculado__c, Facturado__c, Conciliado__c, '
                                     +'Saldo__c, Valor_mes__c, Valor_de_la_deuda__c, Valor_de_la_deuda_calculado_escritura__c, Meses_en_mora__c, Meses_en_mora_calculado_escritura__c, Meses_ejecutados_calculado_escritura__c, '
                                     +'Valor_fijo_o_variable__c, Escalamiento__c, Cuenta_revchain__c, Observaciones__c, Categoria__c, '
                                     +'Multas_o_ANS__c, Facultado__c, Supervisor_tecnico__r.Name, Ultima_facturacion_aprobada__c, '
                                     +'Ultima_conciliacion__c, Ultimo_informe_de_supervision__c, Impuestos__c, Vigencias_de_polizas__c, '
                                     +'Causal_de_no_pago__c, Estado_documentacion__c, Modalidad_de_contratacion__c, Vicepresidencia__c, '
                                     +'Contrato_compartido_con_vicepresidencia__c, Fecha_de_ultima_orden_de_servicio__c, Contratista_con_homologacion_vigente__c, '
                                     +'Composicion_del_contrato__c, Fecha_vencimiento_de_homologacion__c, Fecha_de_suspension__c, Fecha_finalizacion_de_suspension__c, '
                                     +'Renovacion_automatica_contrato__c, Plazo_de_la_renovacion__c, Asignacion_recursos_presupuestales__c, Observaciones_o_novedades__c, '
                                     +'Valor_sin_IVA_en_dolares__c, IVA_en_dolares__c, Valor_total_incluido_IVA_en_dolares__c, Valor_adiciones_en_dolares__c, 	Nombre_del_facultado_actual_de_ETB__c, '
                                     +'Representante_area_usuaria__c, Codigo_ETB_representante_area_usuaria__c, Supervisor_Administrativo__r.EmployeeNumber, Supervisor_tecnico__r.EmployeeNumber, '
                                     +'Valor_total_comprometido__c, Valor_total_comprometido_incluido_IVA__c, Valor_total_comprometido_conIVA_escritur__c, '
                                     +'Fecha_maxima_para_adelantar_pedidos__c, Estado_de_homologacion__c, Saldo_calculado_escritura__c '
                                     +'FROM Contract where Id=:idContrato limit 1');          
    } 
    
    public void consultarProrrogas(String idContrato){       
        lstProrroga = [Select 
                       Acuerdo_No__c, Prorroga_o_adicion__c, Fecha_de_inicio__c, Objeto__c, Fecha_de_fin__c,
                       Valor_antes_de_IVA__c, Name, Contrato_relacionado__c, Porcentaje_IVA__c, IVA__c, Valor_total__c,
                       Valor_sin_IVA_en_dolares__c, IVA_en_dolares__c, Valor_total_incluido_IVA_en_dolares__c 
                       from Adiciones_y_prorrogas_contratos__c 
                       where Contrato_relacionado__c =: idContrato
                       ORDER BY CreatedDate ASC NULLS FIRST
                       ];
    }
    
    public void consultarActas(String idContrato){       
        lstActas = [Select
                    Name, Descripcion__c, Valor_sin_IVA__c, Porcentaje_IVA__c, IVA__c, Valor_total_incluido_IVA__c,
                    Valor_sin_Iva_en_dolares__c, IVA_en_dolares__c, Valor_total_incluido_IVA_en_dolares__c,
                    Fecha_del_acta__c, Facturado__c, Contrato_relacionado__c, Numero_de_acta__c  
                    from Conciliaciones_de_contrato__c
                    where Contrato_relacionado__c =: idContrato
                    ORDER BY Fecha_del_acta__c ASC NULLS FIRST
            	   ];
    }
    
    public void counsultarPedidos_OC(String idContrato){
        lstRelacionPedido = [Select
                             Numero_de_pedido__c, Breve_descripcion_pedido__c, Valor_sin_IVA__c, 
                             Fecha_solicitud_pedido_contratista__c, Porcentaje_IVA__c, IVA__c,
                             Valor_total_incluido_IVA__c, Valor_sin_IVA_en_dolares__c, 
                             IVA_en_dolares__c, Valor_total_incluido_IVA_en_dolares__c
                             From Relacion_pedido_orden_servicio__c
                             Where Contrato_relacionado__c =: idContrato
                             ORDER BY CreatedDate ASC NULLS FIRST
                            ];
    }

	public void counsultarMultas(String idContrato){
        lstMultas		  = [Select
                             No_Acta__c, Conciliada__c, Valor__c, Causa_de_la_penalizacion__c,
                             Descripcion_del_acuerdo__c, Fecha_documento__c
                             From Sanciones_Multas_Incumplimientos__c
                             Where Contrato_relacionado__c =: idContrato
                             ORDER BY CreatedDate ASC NULLS FIRST
                            ];
    }    
        
    // :::::::::::::::::::::::::::::::::::::::::: GENERACIÓN DE HTML ::::::::::::::::::::::::::::::::::::::::::::::::::::
    
    public void Generar_html_encabezado(){
         htmlScriptHeader  =
            '<table style="width: 100%;">'+
            '<tbody>'+
            '<tr>'+
            '<td style="width: 26%; border: 0.5px solid;" colspan="3" align="center"><span class="contenido_13px">Código</span></td>'+
            '<td style="width: 50%; border: 0.5px solid;" align="center" ><span class="contenido_13px">FORMATO</span></td>'+
            '<td style="width: 18%; border: 0.5px solid;" rowspan="5" align="center"><img src="'+urlLogoETB+'" style="width:70%;height:80%;"/></td>'+
            '</tr>'+
            '<tr>'+
            '<td style="width: 32%; border: 0.5px solid;" colspan="3" align="center"><span class="contenido_13px_NB">10-10.2-F-064-v2</span></td>'+
            '<td style="width: 50%; border: 0.5px solid;" rowspan="4" align="center"><p><span class="contenido_14px_NB">Informe de Supervisión - Estado del Contrato</span></p></td>'+
            '</tr>'+
            '<tr>'+
            '<td style="width: 26%; border: 0.5px solid;" colspan="3" align="center"><span class="contenido_13px">Fecha de emisión</span></td>'+
            '</tr>'+
            '<tr>'+
            '<td style="width: 8%; border: 0.5px solid;" align="center"><span class="contenido_13px_NB">Día</span></td>'+
            '<td style="width: 8%; border: 0.5px solid;" align="center"><span class="contenido_13px_NB">Mes</span></td>'+
            '<td style="width: 10%; border: 0.5px solid;" align="center"><span class="contenido_13px_NB">Año</span></td>'+
            '</tr>'+
            '<tr>'+
            '<td style="width: 8%; border: 0.5px solid;" align="center"><span class="contenido_13px_NB">26</span></td>'+
            '<td style="width: 8%; border: 0.5px solid;" align="center"><span class="contenido_13px_NB">6</span></td>'+
            '<td style="width: 10%; border: 0.5px solid;" align="center"><span class="contenido_13px_NB">2019</span></td>'+
            '</tr>'+
            '</tbody>'+
            '</table>';
        
        htmlScriptHeader2 =
            '<table style="width: 100%;">'+
            '<tbody>'+
            '<tr>'+
            '<td style="width: 35%; border: 0.5px solid;">'+
                '<table style="width: 100%;">'+
                     '<tbody>'+
                         '<tr>'+
                             '<td style="width: 35%; border: 0px solid;" align="left"><span class="contenido_10px">Elaborado por:<br/>Diana P. Escobar.</span><span class="contenido_10px_NB"> Aux XII, Dirección Planeación y Control Operacional.<br/></span><span class="contenido_10px">Mauricio Acero,</span><span class="contenido_10px_NB"> Profesional especializado y <span class="contenido_10px">Jorge Hernández</span>, Profesional especializado de la Dirección supervisión y provisión de recursos técnicos.<br/></span><span class="contenido_10px">Oswaldo Barón, </span><span class="contenido_10px_NB">Profesional V, y Diana Arciniegas, Técnico jefe, de la Gerencia Servicios Corporativos.<br/><span class="contenido_10px">Mónica Edith González, </span><span class="contenido_10px_NB">Profesional especializado II, Gerencia de Abastecimiento</span></td>'+
                         '</tr>'+
                     '</tbody>'+
                '</table>'+
            '</td>'+
            '<td style="width: 35%; border: 0.5px solid;">'+
            	'<table style="width: 100%;">'+
                     '<tbody>'+
                         '<tr>'+
                             '<td style="width: 35%; border: 0px solid;" align="left"><span class="contenido_10px">Revisado por:<br/>Sandra Elizabeth Fonseca, </span><span class="contenido_10px_NB">Profesional Especializado II, Dirección Planeación y Control Operacional.<br/></span><span class="contenido_10px">Wilson Yair Chavez, </span><span class="contenido_10px_NB"> Profesional Especializado II, Dirección Planeación y Control Operacional.<br/></span><span class="contenido_10px">Maria Victoria Zambrano, </span><span class="contenido_10px_NB">Profesional Especializado II, Gerencia Abastecimiento de Bienes<br/><br/></span></td>'+
                         '</tr>'+
                     '</tbody>'+
                '</table>'+
            '</td>'+
            '<td style="width: 50%; border: 0.5px solid;">'+
            	'<table style="width: 100%;">'+
                     '<tbody>'+
                         '<tr>'+
                             '<td style="width: 50%; border: 0px solid;" align="left"><span class="contenido_10px"><br>Aprobado por:<br/>Ingrid Tatiana Montealegre, </span><span class="contenido_10px_NB">Gerente, Gerencia de Abastecimiento.<br/></span><span class="contenido_10px">Raquel Sotelo, </span><span class="contenido_10px_NB">Directora Supervisión y Provisión de Recursos Técnicos<p>&nbsp;</p><br/><br/></span></td>'+                        
                         '</tr>'+
                     '</tbody>'+
                '</table>'+
            '</td>'+
            '</tr>'+
            '</tbody>'+
            '</table>';
    }

	// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::  
	public void Generar_html_info_general(){
        
        htmlScriptInfoGeneral =                   
       '<table style="width: 100%;">'+
          '<tr>'+
            '<td style="width: 35%; border: 0.5px solid;" colspan="3">1.Vicepresidencia</td>'+
            '<td style="border: 0.5px solid;" colspan="4" align="Center">'+(String.isBlank(objContract.Vicepresidencia__c)?'':objContract.Vicepresidencia__c)+'</td>'+
            '<td style="width: 20%; border: 0.5px solid;" colspan="3" align = "Center">2.Modalidad de contratación:</td>'+
            '<td style="border: 0.5px solid;" colspan="3" align="Center">'+(String.isBlank(objContract.Modalidad_de_contratacion__c)?'':objContract.Modalidad_de_contratacion__c)+'</td>'+
          '</tr>'+
          '<tr>'+            
            '<td style="border: 0.5px solid;" colspan="3">3. Contrato compartido con la vicepresidencia (si aplica)</td>'+
            '<td style="border: 0.5px solid;" colspan="4" align="Center">'+(String.isBlank(objContract.Contrato_compartido_con_vicepresidencia__c)?'':objContract.Contrato_compartido_con_vicepresidencia__c)+'</td>'+
            '<td style="border: 0.5px solid;" >&nbsp;</td>'+
            '<td style="width: 5%; border: 0.5px solid;" >&nbsp;</td>'+
            '<td style="width: 7%; border: 0.5px solid;" >&nbsp;</td>'+
            '<td colspan="3" rowspan="4" style="border: 0.5px solid;" >&nbsp;</td>'+
          '</tr>'+
          '<tr>'+
            '<td style="width: 17%; border: 0.5px solid;"  colspan="2" rowspan="5">4. Número de Contrato</td>'+
            '<td style="width: 18%; border: 0.5px solid;"  rowspan="5">'+(String.isBlank(objContract.Anexo__c)?'':objContract.Anexo__c)+'</td>'+            
            '<td style="border: 0.5px solid;"  colspan="4">5. Fecha de firma del contrato:</td>'+
            '<td style="border: 0.5px solid;" align="Center">'+procesarFecha(objContract.Fecha_de_suscripcion__c,'DD')+'</td>'+
            '<td style="width: 5%; border: 0.5px solid;" align="Center">'+procesarFecha(objContract.Fecha_de_suscripcion__c,'MM')+'</td>'+
            '<td style="width: 7%; border: 0.5px solid;" align="Center">'+procesarFecha(objContract.Fecha_de_suscripcion__c,'AAAA')+'</td>'+
          '</tr>'+
          '<tr>'+
            '<td style="border: 0.5px solid;"  colspan="4">6. Fecha de orden de inicio: </td>'+
            '<td style="border: 0.5px solid;" align="center">'+procesarFecha(objContract.Fecha_de_inicio__c,'DD')+'</td>'+
            '<td style="width: 5%; border: 0.5px solid;" align="center">'+procesarFecha(objContract.Fecha_de_inicio__c,'MM')+'</td>'+
            '<td style="width: 7%; border: 0.5px solid;" align="center">'+procesarFecha(objContract.Fecha_de_inicio__c,'AAAA')+'</td>'+
          '</tr>'+
          '<tr>'+
            '<td style="border: 0.5px solid;"  colspan="4">7. Fecha finalización contrato (incluidas prórrogas o vigencias de Ordenes de Servicio)</td>'+
            '<td style="border: 0.5px solid;" align="center">'+procesarFecha(objContract.Fecha_de_terminacion__c,'DD')+'</td>'+
            '<td style="width: 5%; border: 0.5px solid;" align="center">'+procesarFecha(objContract.Fecha_de_terminacion__c,'MM')+'</td>'+
            '<td style="width: 7%; border: 0.5px solid;" align="center">'+procesarFecha(objContract.Fecha_de_terminacion__c,'AAAA')+'</td>'+
          '</tr>'+
          '<tr>'+
            '<td style="border: 0.5px solid;" >Fecha de la ultima orden de servicio</td>'+
            '<td style="width: 5%; border: 0.5px solid;" align="center">'+procesarFecha(objContract.Fecha_de_ultima_orden_de_servicio__c,'DD')+'</td>'+
            '<td style="width: 5%; border: 0.5px solid;" align="center">'+procesarFecha(objContract.Fecha_de_ultima_orden_de_servicio__c,'MM')+'</td>'+
            '<td style="width: 5%; border: 0.5px solid;" align="center">'+procesarFecha(objContract.Fecha_de_ultima_orden_de_servicio__c,'AAAA')+'</td>'+
            '<td style="width: 12%; border: 0.5px solid;" align="Left">Fecha máxima para adelantar pedidos (Cuando lo contemple el contrato)</td>'+
            '<td style="width: 5%; border: 0.5px solid;" align="center">'+procesarFecha(objContract.Fecha_maxima_para_adelantar_pedidos__c,'DD')+'</td>'+
            '<td style="width: 5%; border: 0.5px solid;" align="center">'+procesarFecha(objContract.Fecha_maxima_para_adelantar_pedidos__c,'MM')+'</td>'+
            '<td style="width: 5%; border: 0.5px solid;" align="center">'+procesarFecha(objContract.Fecha_maxima_para_adelantar_pedidos__c,'AAAA')+'</td>'+
            '<td style="width: 5%; border: 0.5px solid;" align="center"></td>'+
            '<td style="width: 5%; border: 0.5px solid;" align="center"></td>'+
          '</tr>'+
          '<tr>'+
            '<td style="border: 0.5px solid;"  colspan="4">8.Plazo máximo para liquidación (plazo en meses)</td>'+
            '<td style="border: 0.5px solid;" align="center">'+(objContract.Tiempo_de_liquidacion__c== null?0:objContract.Tiempo_de_liquidacion__c)+'</td>'+
            '<td style="border: 0.5px solid;"  colspan="2">9. Fecha máxima de liquidación</td>'+
              '<td style="border: 0.5px solid;" align="center">'+procesarFecha(objContract.Fecha_maxima_de_liquidacion__c,'DD')+'</td>'+
            '<td style="width: 5%; border: 0.5px solid;" align="center">'+procesarFecha(objContract.Fecha_maxima_de_liquidacion__c,'MM')+'</td>'+
            '<td style="width: 7%; border: 0.5px solid;" align="center">'+procesarFecha(objContract.Fecha_maxima_de_liquidacion__c,'AAAA')+'</td>'+
          '</tr>'+
          '<tr>'+
            '<td style="border: 0.5px solid;"  colspan="3">10. Tipo de Contrato </td>'+
            '<td style="border: 0.5px solid;"  colspan="4" align="center">'+(String.isBlank(objContract.Valor_fijo_o_variable__c)?'':objContract.Valor_fijo_o_variable__c)+'</td>'+
            '<td style="border: 0.5px solid;" >Otro, cuál?</td>'+
            '<td style="border: 0.5px solid;" colspan="5"></td>'+                        
          '</tr>'+
          '<tr>'+
            '<td style="border: 0.5px solid;"  colspan="3">11. Nombre o Razón Social del Contratista</td>'+
            '<td style="border: 0.5px solid;"  colspan="4" align="Center">'+(String.isBlank(objContract.Aliado__r.Name)?'':objContract.Aliado__r.Name)+'</td>'+
            '<td style="border: 0.5px solid;"  colspan="2" align="Left">12. Estado de homologación reportado por abastecimiento?</td>'+
            '<td style="border: 0.5px solid;"  colspan = "4">'+
                 '<table style="width: 100%;">'+
                     '<tbody>'+
                         '<tr>'+
                             '<td align="Left">'+(String.isBlank(objContract.Estado_de_homologacion__c)?'':objContract.Estado_de_homologacion__c)+'</td>'+                             
                         '</tr>'+
                     '</tbody>'+
                '</table>'+  
            '</td>'+    
          '</tr>'+
          '<tr>'+
            '<td style="border: 0.5px solid;"  colspan="3">13. Composición del Contrato</td>'+
            '<td style="border: 0.5px solid;"  colspan="4" align="Center">'+(String.isBlank(objContract.Composicion_del_contrato__c)?'':objContract.Composicion_del_contrato__c)+'</td>'+
            '<td style="border: 0.5px solid;"  colspan="3">14. Fecha vencimiento de homologación</td>'+
            '<td style="border: 0.5px solid;" align="center">'+procesarFecha(objContract.Fecha_vencimiento_de_homologacion__c,'DD')+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+procesarFecha(objContract.Fecha_vencimiento_de_homologacion__c,'MM')+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+procesarFecha(objContract.Fecha_vencimiento_de_homologacion__c,'AAAA')+'</td>'+
          '</tr>'+
          '<tr>'+
            '<td style="border: 0.5px solid;"  colspan="3" rowspan="2">15. Estado actual del contrato</td>'+
            '<td style="border: 0.5px solid;"  colspan="4" align="Center">'+(String.isBlank(objContract.Status)?'':objContract.Status)+'</td>'+
            '<td style="border: 0.5px solid;"  colspan="3">'+
                '<table style="width: 100%;">'+
                     '<tbody>'+
                         '<tr>'+
                             '<td style="width: 10%; " align="Right">Otro, ¿Cuál?</td>'+
                             '<td style="width: 35%; " align="Right">&nbsp;</td>'+                      
                         '</tr>'+
                     '</tbody>'+
                '</table>'+ 
            '</td>'+      
            '<td style="border: 0.5px solid;"  colspan="3">'+
                '<table style="width: 100%;">'+
                     '<tbody>'+
                         '<tr>'+
                             '<td style="width: 10%; " align="Left">Motivo: </td>'+
                             '<td style="width: 35%; " align="Right">&nbsp;</td>'+                      
                         '</tr>'+
                     '</tbody>'+
                '</table>'+ 
            '</td>'+    
          '</tr>'+
          '<tr>'+
            '<td style="border: 0.5px solid;" >Fecha de suspensión: </td>'+
            '<td style="border: 0.5px solid;" align="center">'+(String.isBlank(procesarFecha(objContract.Fecha_de_suspension__c,'DD'))?'':procesarFecha(objContract.Fecha_de_suspension__c,'DD'))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+(String.isBlank(procesarFecha(objContract.Fecha_de_suspension__c,'MM'))?'':procesarFecha(objContract.Fecha_de_suspension__c,'MM'))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+(String.isBlank(procesarFecha(objContract.Fecha_de_suspension__c,'AAAA'))?'':procesarFecha(objContract.Fecha_de_suspension__c,'AAAA'))+'</td>'+
            '<td style="border: 0.5px solid;"  colspan="3">Fecha de finalización de la suspensión:</td>'+
            '<td style="border: 0.5px solid;" align="center">'+procesarFecha(objContract.Fecha_finalizacion_de_suspension__c,'DD')+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+procesarFecha(objContract.Fecha_finalizacion_de_suspension__c,'MM')+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+procesarFecha(objContract.Fecha_finalizacion_de_suspension__c,'AAAA')+'</td>'+
          '</tr>'+
          '<tr>'+
          '<tr>'+
            '<td><div class="saltoDePagina"></div></td>'+
          '</tr>'+
            '<td style="border: 0.5px solid;"  colspan="3">16. Plazo inicial:</td>'+
           	'<td style="border: 0.5px solid;"  colspan="4" align="center">'+(String.isBlank(objContract.Plazo_de_ejecucion_escritura__c)?'':objContract.Plazo_de_ejecucion_escritura__c)+'</td>'+                
            '<td style="border: 0.5px solid;"  colspan="3">'+
                '<table style="width: 100%;">'+
                     '<tbody>'+
                         '<tr>'+
                             '<td style="width: 40%; " align="Left">17. Renovación Automática</td>'+
                             '<td style="width: 60%; " align="Center"><img src="'+chkBoxRenovacionAutom+'"/></td>'+
                         '</tr>'+
                     '</tbody>'+
                '</table>'+
            '</td>'+    
            '<td style="border: 0.5px solid;"  colspan="3">&nbsp;'+
                '<table style="width: 100%;">'+
                     '<tbody>'+
                         '<tr>'+
                             '<td style="width: 40%; " align="Left">18. Plazo de la renovación:</td>'+
                             '<td style="width: 60%; " align="Center">'+(String.isBlank(procesarFecha(objContract.Plazo_de_la_renovacion__c,'DD'))?'':procesarFecha(objContract.Plazo_de_la_renovacion__c,'DD')+'/'+procesarFecha(objContract.Plazo_de_la_renovacion__c,'MM')+'/'+procesarFecha(objContract.Plazo_de_la_renovacion__c,'AAAA'))+'</td>'+
                         '</tr>'+
                     '</tbody>'+
                '</table>'+
            '</td>'+
          '</tr>'+
          '<tr>'+
            '<td style="border: 0.5px solid;"  colspan="3">19. Objeto</td>'+
            '<td style="border: 0.5px solid;"  colspan="10" align = "Left">'+(String.isBlank(objContract.Objeto__c)?'':objContract.Objeto__c)+'</td>'+
          '</tr>'+
          '<tr>'+
            '<td style="border: 0.5px solid;"  colspan="3">20. Objeto (resumen)</td>'+
            '<td style="border: 0.5px solid;"  colspan="4">&nbsp;</td>'+
            '<td style="border: 0.5px solid;"  colspan="6">'+
                '<table style="width: 100%;">'+
                     '<tbody>'+
                         '<tr>'+
                             '<td style="width: 40%; " align="Left">Otro, ¿Cuál?</td>'+                     
                             '<td style="width: 60%; " align="Left">&nbsp;</td>'+                      
                         '</tr>'+
                     '</tbody>'+
                '</table>'+
            '</td>'+    
          '</tr>'+
          '<tr>'+
            '<td style="border: 0.5px solid;"  colspan="3">21. Nombre del  facultado de ETB que suscribió el contrato</td>'+
            '<td style="border: 0.5px solid;"  colspan="4">'+(String.isBlank(objContract.Facultado__c)?'':objContract.Facultado__c)+'</td>'+
            '<td style="border: 0.5px solid;"  colspan="3">22. Nombre del Facultado actual de ETB</td>'+
            '<td style="border: 0.5px solid;"  colspan="3">'+(String.isBlank(objContract.Nombre_del_facultado_actual_de_ETB__c)?'':objContract.Nombre_del_facultado_actual_de_ETB__c)+'</td>'+
          '</tr>'+
          '<tr>'+
            '<td style="border: 0.5px solid;"  colspan="3">23. Valor Inicial del Contrato</td>'+
            '<td style="border: 0.5px solid;"  colspan="4">'+
                '<table style="width: 100%;">'+
                     '<tbody>'+
                         '<tr>'+
                             '<td style="width: 60%; " align="Left">24. Asignación de recursos presupuestales</td>'+                     
                             '<td align="right">SI</td>'+
                             '<td align="left"><img src="'+chkBoxAsigRecursosPres_SI+'" /></td>'+
                         '</tr>'+
                     '</tbody>'+
                '</table>'+
            '</td>'+
            '<td style="border: 0.5px solid;"  colspan="3">'+
                '<table style="width: 100%;">'+
                     '<tbody>'+
                         '<tr>'+                     
                             '<td align="right">NO</td>'+
                             '<td align="left"><p><img src="'+chkBoxAsigRecursosPres_NO+'" /></p></td>'+  
            				 '<td align="right">N/A</td>'+
                             '<td align="left"><p><img src="'+chkBoxAsigRecursosPres_NA+'" /></p></td>'+ 
                         '</tr>'+
                     '</tbody>'+
                '</table>'+
            '</td>'+    
            '<td style="border: 0.5px solid;" >&nbsp;</td>'+
            '<td style="border: 0.5px solid;"  colspan="2">&nbsp;</td>'+
          '</tr>'+
          '<tr>'+
            '<td style="width: 10%; border: 0.5px solid;" align="Center">Valor Inicial sin IVA (en Pesos)</td>'+
            '<td style="width: 10%; border: 0.5px solid;" align="Center">IVA (en Pesos)</td>'+
            '<td style="width: 5%; border: 0.5px solid;" align="Center">Valor inicial incluido IVA (en Pesos)</td>'+
            '<td style="border: 0.5px solid;" align="Center">Valor inicial sin IVA (en dólares)</td>'+
            '<td style="border: 0.5px solid;" align="Center" colspan="2">IVA (en dólares)</td>'+
            '<td style="border: 0.5px solid;" align="Center" colspan="4">Valor Inicial incluido IVA (en dólares)</td>'+
            '<td style="border: 0.5px solid;"  colspan="3" rowspan="2">&nbsp;</td>'+
          '</tr>'+
          '<tr>'+            
            '<td style="border: 0.5px solid;" align="Center">'+formatearCampoMoneda((objContract.Valor_sin_IVA__c== null?0:objContract.Valor_sin_IVA__c))+'</td>'+
            '<td style="border: 0.5px solid;" align="Center">'+formatearCampoMoneda((objContract.IVA_Contrato_Colaborador__c== null?0:objContract.IVA_Contrato_Colaborador__c))+'</td>'+
            '<td style="border: 0.5px solid;" align="Center">'+formatearCampoMoneda((valorInicialContrato== null?0:valorInicialContrato))+'</td>'+            
            '<td style="border: 0.5px solid;" align="Center">'+formatearCampoMoneda((objContract.Valor_sin_IVA_en_dolares__c== null?0:objContract.Valor_sin_IVA_en_dolares__c))+'</td>'+
            '<td style="border: 0.5px solid;" colspan="2" align="Center">'+formatearCampoMoneda((objContract.IVA_en_dolares__c== null?0:objContract.IVA_en_dolares__c))+'</td>'+
            '<td style="border: 0.5px solid;" colspan="4" align="Center">'+formatearCampoMoneda((objContract.Valor_total_incluido_IVA_en_dolares__c== null?0:objContract.Valor_total_incluido_IVA_en_dolares__c))+'</td>'+
          '</tr>'+
        '</table>';
        
    }     
	// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	  
	public void Generar_html_modificaciones(){
        integer cant = 1;
        htmlScriptModificacion =
            '<table style="width: 100%;">'+
            '<tr>'+
            '<td rowspan="2" style="border: 0.5px solid;" align="center">25. Número del acuerdo modificatorio</td>'+
            '<td rowspan="2" style="border: 0.5px solid;" align="center">26. Fecha de acuerdo Modificatorio</td>'+
            '<td rowspan="2" style="border: 0.5px solid;" align="center">27. Prórroga, <br/>Adición, Acuerdo o Cambio de <br/>condiciones,<br/>Incorporación de recursos.</td>'+
            '<td rowspan="2" style="border: 0.5px solid;" align="center">28. Objeto(<br/>describir la<br/>finalidad de<br/>cada documento<br/>suscrito)</td>'+
            '<td colspan="6" style="border: 0.5px solid;" align="center">29. Valor adición o modificación<br/>(Diligencie N/A si fue cambio de condiciones)</td>'+
            '<td style="border: 0.5px solid;" align="center">30. Prórroga hasta</td>'+
          	'</tr>'+
          	'<tr>'+                        
            '<td style="border: 0.5px solid;" align="center">Valor sin IVA (en Pesos)</td>'+
            '<td style="border: 0.5px solid;" align="center">IVA (en Pesos)</td>'+
            '<td style="border: 0.5px solid;" align="center">Valor total incluido IVA (en Pesos)</td>'+
            '<td style="border: 0.5px solid;" align="center">Valor sin IVA (en dólares)</td>'+
            '<td style="border: 0.5px solid;" align="center">IVA (en dólares)</td>'+
            '<td style="border: 0.5px solid;" align="center">Valor total incluido IVA (en dólares)</td>'+
            '<td style="border: 0.5px solid;">dd/mm/aaaa</td>'+
          	'</tr>';
        for(Adiciones_y_prorrogas_contratos__c objProrroga_aux : lstProrroga){
            htmlScriptModificacion +=
                '<tr>'+
                '<td style="border: 0.5px solid;" align = "center">'+cant+'</td>'+
                '<td style="border: 0.5px solid;" align = "center">'+procesarFecha(objProrroga_aux.Fecha_de_inicio__c,'DD')+'/'+procesarFecha(objProrroga_aux.Fecha_de_inicio__c,'MM')+'/'+procesarFecha(objProrroga_aux.Fecha_de_inicio__c,'AAAA')+'</td>'+                
                '<td style="border: 0.5px solid;" align = "center">'+(String.isBlank(objProrroga_aux.Prorroga_o_adicion__c)?'':objProrroga_aux.Prorroga_o_adicion__c)+'</td>'+
                '<td style="border: 0.5px solid;" align = "center">'+(String.isBlank(objProrroga_aux.Objeto__c)?'':objProrroga_aux.Objeto__c)+'</td>'+
                '<td style="border: 0.5px solid;" align = "center">'+formatearCampoMoneda((objProrroga_aux.Valor_antes_de_IVA__c== null?0:objProrroga_aux.Valor_antes_de_IVA__c))+'</td>'+
                '<td style="border: 0.5px solid;" align = "center">'+formatearCampoMoneda((objProrroga_aux.IVA__c== null?0:objProrroga_aux.IVA__c))+'</td>'+
                '<td style="border: 0.5px solid;" align = "center">'+formatearCampoMoneda((objProrroga_aux.Valor_total__c== null?0:objProrroga_aux.Valor_total__c))+'</td>'+
                '<td style="border: 0.5px solid;" align = "center">'+formatearCampoMoneda((objProrroga_aux.Valor_sin_IVA_en_dolares__c== null?0:objProrroga_aux.Valor_sin_IVA_en_dolares__c))+'</td>'+
                '<td style="border: 0.5px solid;" align = "center">'+formatearCampoMoneda((objProrroga_aux.IVA_en_dolares__c== null?0:objProrroga_aux.IVA_en_dolares__c))+'</td>'+
                '<td style="border: 0.5px solid;" align = "center">'+formatearCampoMoneda((objProrroga_aux.Valor_total_incluido_IVA_en_dolares__c== null?0:objProrroga_aux.Valor_total_incluido_IVA_en_dolares__c))+'</td>'+                
                '<td style="border: 0.5px solid;" align = "center">'+procesarFecha(objProrroga_aux.Fecha_de_fin__c,'DD')+'/'+procesarFecha(objProrroga_aux.Fecha_de_fin__c,'MM')+'/'+procesarFecha(objProrroga_aux.Fecha_de_fin__c,'AAAA')+'</td>'+
                '</tr>';
            	cant++;
        }
        htmlScriptModificacion +=
          	'<tr>'+
            '<td colspan="4" style="border: 0.5px solid;" align="center">TOTAL</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((valorTotalSinIvaAdicion== null?0:valorTotalSinIvaAdicion))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((valorTotalIvaAdicion== null?0:valorTotalIvaAdicion))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((valorTotalConIvaAdicion== null?0:valorTotalConIvaAdicion))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((valorTotalSinIvaAdicionDolares== null?0:valorTotalSinIvaAdicionDolares))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((valorTotalIvaAdicionDolares== null?0:valorTotalIvaAdicionDolares))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((valorTotalConIvaAdicionDolares== null?0:valorTotalConIvaAdicionDolares))+'</td>'+
            '<td style="border: 0.5px solid;">&nbsp;</td>'+
          	'</tr>'+
            '<tr>'+
            '<td colspan ="7" style="border: 0.5px solid;" align = "left">31. Valor total incluidas Adiciones</td>'+
            '<td colspan ="4" rowspan = "3" style="border: 0.5px solid;" align = "center"></td>'+          
            '</tr>'+            
            '<tr>'+            
            '<td style="border: 0.5px solid;" align="center">Valor Total sin IVA (en Pesos)</td>'+
            '<td style="border: 0.5px solid;" align="center">IVA Total (en Pesos)</td>'+
            '<td style="border: 0.5px solid;" align="center">Valor Total inicial incluido IVA (en Pesos)</td>'+
            '<td style="border: 0.5px solid;" align="center">Valor Total sin IVA (en dólares)</td>'+
            '<td style="border: 0.5px solid;" align="center">IVA Total (en dólares)</td>'+
            '<td colspan ="2" style="border: 0.5px solid;" align = "center">Valor total inicial incluido IVA (en dólares)</td>'+            
          	'</tr>'+
            '<tr>'+            
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((valorTotalconAdSinIvaAdicion== null?0:valorTotalconAdSinIvaAdicion))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((valorTotalconAdIvaAdicion== null?0:valorTotalconAdIvaAdicion))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((valorTotalconAdConIvaAdicion== null?0:valorTotalconAdConIvaAdicion))+'</td>'+            
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((valorTotalconAdSinIvaAdicionDolares== null?0:valorTotalconAdSinIvaAdicionDolares))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((valorTotalconAdIvaAdicionDolares== null?0:valorTotalconAdIvaAdicionDolares))+'</td>'+                     
            '<td colspan ="2" style="border: 0.5px solid;" align = "center">'+formatearCampoMoneda((valorTotalconAdConIvaAdicionDolares== null?0:valorTotalconAdConIvaAdicionDolares))+'</td>'+
          	'</tr>'+            
        	'</table>';
    }
    
    // :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::  
	  
	public void Generar_html_orden_servicio(){
        integer cant = 1;
        htmlScriptOrdenServicio =
            '<table style="width: 100%;">'+
            '<tr>'+
            '<td rowspan="2" style="border: 0.5px solid;" align="center">32. Número del Pedido / O.S.</td>'+
            '<td rowspan="2" style="border: 0.5px solid;" align="center">33. Fecha de solicitud<br/>del pedido /<br/>O.S. al contratista.</td>'+
            '<td rowspan="2" colspan="2" style="border: 0.5px solid;" align="center">34. Breve descripción del pedido / O.S.</td>'+
            '<td colspan="6" style="border: 0.5px solid;" align="center">35. Valor del pedido / O.S.</td>'+            
          	'</tr>'+
            '<tr>'+            
            '<td style="border: 0.5px solid;" align="center">Valor sin IVA (en Pesos)</td>'+
            '<td style="border: 0.5px solid;" align="center">IVA (en Pesos)</td>'+
            '<td style="border: 0.5px solid;" align="center">Valor total incluido IVA (en Pesos)</td>'+
            '<td style="border: 0.5px solid;" align="center">Valor sin IVA (en dólares)</td>'+
            '<td style="border: 0.5px solid;" align="center">IVA (en dólares)</td>'+
            '<td style="border: 0.5px solid;" align="center">Valor total incluido IVA (en dólares)</td>'+
          	'</tr>';
          for(Relacion_pedido_orden_servicio__c objRelacionPedido : lstRelacionPedido){          
        	htmlScriptOrdenServicio +=            
            '<tr>'+            
            '<td style="border: 0.5px solid;" align="center">'+(String.isBlank(objRelacionPedido.Numero_de_pedido__c)?'':objRelacionPedido.Numero_de_pedido__c)+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+procesarFecha(objRelacionPedido.Fecha_solicitud_pedido_contratista__c,'DD')+'/'+procesarFecha(objRelacionPedido.Fecha_solicitud_pedido_contratista__c,'MM')+'/'+procesarFecha(objRelacionPedido.Fecha_solicitud_pedido_contratista__c,'AAAA')+'</td>'+
            '<td colspan="2" style="border: 0.5px solid;" align="center">'+(String.isBlank(objRelacionPedido.Breve_descripcion_pedido__c)?'':objRelacionPedido.Breve_descripcion_pedido__c)+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((objRelacionPedido.Valor_sin_IVA__c== null?0:objRelacionPedido.Valor_sin_IVA__c))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((objRelacionPedido.IVA__c== null?0:objRelacionPedido.IVA__c))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((objRelacionPedido.Valor_total_incluido_IVA__c== null?0:objRelacionPedido.Valor_total_incluido_IVA__c))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((objRelacionPedido.Valor_sin_IVA_en_dolares__c== null?0:objRelacionPedido.Valor_sin_IVA_en_dolares__c))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((objRelacionPedido.IVA_en_dolares__c== null?0:objRelacionPedido.IVA_en_dolares__c))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((objRelacionPedido.Valor_total_incluido_IVA_en_dolares__c== null?0:objRelacionPedido.Valor_total_incluido_IVA_en_dolares__c))+'</td>'+
          	'</tr>';
            cant++;
        }
        	htmlScriptOrdenServicio +=
            '<tr>'+            
            '<td colspan="4" style="border: 0.5px solid;" align="center">TOTAL</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((valorTotalRelacionPedido== null?0:valorTotalRelacionPedido))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((valorTotalIvaRelacionPedido== null?0:valorTotalIvaRelacionPedido))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((valorTotalConIvaRelacionPedido== null?0:valorTotalConIvaRelacionPedido))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((valorTotalRelacionPedidoDolares== null?0:valorTotalRelacionPedidoDolares))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((valorTotalIvaRelacionPedidoDolares== null?0:valorTotalIvaRelacionPedidoDolares))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((valorTotalConIvaRelacionPedidoDolares== null?0:valorTotalConIvaRelacionPedidoDolares))+'</td>'+
          	'</tr>'+              
        	'</table>';
    }
    
    // :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::  
	  
	public void Generar_html_pagos(){
        integer cant = 1;
        htmlScriptPagos =
            '<table style="width: 100%;">'+
            '<tr>'+
            '<td rowspan="2" style="border: 0.5px solid;" align="center">36. Número de acta</td>'+
            '<td rowspan="2" style="border: 0.5px solid;" align="center">37. Concepto<br/>(Pedido de servicio o de<br/>bienes)</td>'+            
            '<td colspan="6" style="border: 0.5px solid;" align="center">38. Valor acta de recibo y pago</td>'+            
            '<td rowspan="2" style="border: 0.5px solid;" align="center">39. Fecha del Acta</td>'+            
            '<td rowspan="2" style="border: 0.5px solid;" align="center">40. Acta de pago genera factura? (SI/NO)</td>'+            
          	'</tr>'+
            '<tr>'+            
            '<td style="border: 0.5px solid;" align="center">Valor sin IVA (en Pesos)</td>'+
            '<td style="border: 0.5px solid;" align="center">IVA (en Pesos)</td>'+
            '<td style="border: 0.5px solid;" align="center">Valor total incluido IVA (en Pesos)</td>'+
            '<td style="border: 0.5px solid;" align="center">Valor sin IVA (en dólares)</td>'+
            '<td style="border: 0.5px solid;" align="center">IVA (en dólares)</td>'+
            '<td style="border: 0.5px solid;" align="center">Valor total incluido IVA (en dólares)</td>'+
          	'</tr>';
        for(Conciliaciones_de_contrato__c objActa_aux : lstActas){
        	htmlScriptPagos +=
            '<tr>'+            
            '<td style="border: 0.5px solid;" align="center">'+(String.isBlank(objActa_aux.Numero_de_acta__c)?'':objActa_aux.Numero_de_acta__c)+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+(String.isBlank(objActa_aux.Descripcion__c)?'':objActa_aux.Descripcion__c)+'</td>'+            
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((objActa_aux.Valor_sin_IVA__c== null?0:objActa_aux.Valor_sin_IVA__c))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((objActa_aux.IVA__c== null?0:objActa_aux.IVA__c))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((objActa_aux.Valor_total_incluido_IVA__c== null?0:objActa_aux.Valor_total_incluido_IVA__c))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((objActa_aux.Valor_sin_Iva_en_dolares__c== null?0:objActa_aux.Valor_sin_Iva_en_dolares__c))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((objActa_aux.IVA_en_dolares__c== null?0:objActa_aux.IVA_en_dolares__c))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((objActa_aux.Valor_total_incluido_IVA_en_dolares__c== null?0:objActa_aux.Valor_total_incluido_IVA_en_dolares__c))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+procesarFecha(objActa_aux.Fecha_del_acta__c,'DD')+'/'+procesarFecha(objActa_aux.Fecha_del_acta__c,'MM')+'/'+procesarFecha(objActa_aux.Fecha_del_acta__c,'AAAA')+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+(String.isBlank(objActa_aux.Facturado__c)?'':objActa_aux.Facturado__c)+'</td>'+
          	'</tr>';
            cant++;
        }
        	htmlScriptPagos +=
            '<tr>'+            
            '<td colspan="2" style="border: 0.5px solid;" align="Left">41. TOTAL COMPROMETIDO (realizar la sumatoria de los ítems que NO tienen acta de pago suscrita.)</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((totalComprometidoSinIva_NO== null?0:totalComprometidoSinIva_NO))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((totalComprometidoIva_NO== null?0:totalComprometidoIva_NO))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((totalComprometidoconIva_NO== null?0:totalComprometidoconIva_NO))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((totalComprometidoSinIVA_NODolares== null?0:totalComprometidoSinIVA_NODolares))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((totalComprometidoIVA_NODolares== null?0:totalComprometidoIVA_NODolares))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((totalComprometidoconIVA_NODolares== null?0:totalComprometidoconIVA_NODolares))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">&nbsp;</td>'+
            '<td style="border: 0.5px solid;" align="center">&nbsp;</td>'+
          	'</tr>'+  
            '<tr>'+            
            '<td colspan="2" style="border: 0.5px solid;" align="Left">42.  TOTAL REGISTRADO CON ACTAS (Si aplica, realizar la sumatoria de los ítems que tienen acta de pago suscrita)</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((totalComprometidoSinIva_SI== null?0:totalComprometidoSinIva_SI))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((totalComprometidoIva_SI== null?0:totalComprometidoIva_SI))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((totalComprometidoconIva_SI== null?0:totalComprometidoconIva_SI))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((totalComprometidoSinIVA_SIDolares== null?0:totalComprometidoSinIVA_SIDolares))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((totalComprometidoIVA_SIDolares== null?0:totalComprometidoIVA_SIDolares))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((totalComprometidoconIVA_SIDolares== null?0:totalComprometidoconIVA_SIDolares))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">&nbsp;</td>'+
            '<td style="border: 0.5px solid;" align="center">&nbsp;</td>'+
          	'</tr>'+ 
        	'</table>';
    }
    
    // :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::  
	  
	public void Generar_html_ejecucion_contrato(){
        htmlScriptEjecucionContrato =
            '<table style="width: 100%;">'+
            '<tr>'+
            '<td colspan="3" style="border: 0.5px solid;" align="left">43. TOTAL VALOR INICIAL DEL CONTRATO</td>'+
            '<td style="border: 0.5px solid;" align="center">En pesos  $</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((valorInicialContrato== null?0:valorInicialContrato))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">En dólares US</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((valorInicialContratoDolares== null?0:valorInicialContratoDolares))+'</td>'+
          	'</tr>'+
            '<tr>'+
            '<td colspan="3" style="border: 0.5px solid;" align="left">44. TOTAL VALOR PRORROGAS, ADICION, ACUERDO O CAMBIO DE<br/>CONDICIONES, INCORPORACION DE RECURSOS.</td>'+
            '<td style="border: 0.5px solid;" align="center">En pesos  $</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((valorTotalConIvaAdicion== null?0:valorTotalConIvaAdicion))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">En dólares US</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((valorTotalconAdConIvaAdicionDolares== null?0:valorTotalconAdConIvaAdicionDolares))+'</td>'+
          	'</tr>'+ 
            '<tr>'+
            '<td colspan="3" style="border: 0.5px solid;" align="left">45.TOTAL VALOR FACTURADO</td>'+
            '<td style="border: 0.5px solid;" align="center">En pesos  $</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((totalComprometidoconIva_SI== null?0:totalComprometidoconIva_SI))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">En dólares US</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((totalComprometidoconIva_SIDolares== null?0:totalComprometidoconIva_SIDolares))+'</td>'+
          	'</tr>'+ 
            '<tr>'+
            '<td colspan="3" style="border: 0.5px solid;" align="left">46. TOTAL VALOR COMPROMETIDO (VALORES PENDIENTES DE FACTURAR)</td>'+
            '<td style="border: 0.5px solid;" align="center">En pesos  $</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((objContract.Valor_total_comprometido_conIVA_escritur__c== null?0:objContract.Valor_total_comprometido_conIVA_escritur__c))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">En dólares US</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((totalComprometidoconIva_NODolares== null?0:totalComprometidoconIva_NODolares))+'</td>'+
          	'</tr>'+ 
            '<tr>'+
            '<td colspan="3" style="border: 0.5px solid;" align="left">47. SALDO DISPONIBLE</td>'+
            '<td style="border: 0.5px solid;" align="center">En pesos  $</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((saldoDisponible== null?0:saldoDisponible))+'</td>'+
            '<td style="border: 0.5px solid;" align="center">En dólares US</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((saldoDisponibleDolares== null?0:saldoDisponibleDolares))+'</td>'+
          	'</tr>'+ 
        	'</table>';
    } 
    
    // :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::  
	  
	public void Generar_html_sanciones(){
        integer cant = 1;
        htmlScriptSanciones =
            '<table style="width: 100%;">'+
            '<tr>'+
            '<td style="border: 0.5px solid;" align="center">Ítem</td>'+
            '<td colspan="2" style="border: 0.5px solid;" align="center">48. No. Acta</td>'+            
            '<td style="border: 0.5px solid;" align="center">49. Causa de la penalización</td>'+
			'<td colspan="3" style="border: 0.5px solid;" align="center">50. Descripción del Acuerdo (Describa<br/>si el descuento se aplica en acta de<br/>recibo parcial o definitiva o cuenta de cobro)</td>'+                        
            '<td style="border: 0.5px solid;" align="center">51. Fecha Documento (dd/mm/aa)</td>'+
            '<td style="border: 0.5px solid;" align="center">52. Conciliada Si / No</td>'+
            '<td style="border: 0.5px solid;" align="center">53. Valor</td>'+                     
          	'</tr>';            
            for(Sanciones_Multas_Incumplimientos__c objMulta_aux : lstMultas){
                htmlScriptSanciones +=
                '<tr>'+
                '<td style="border: 0.5px solid;" align="center">'+cant+'</td>'+
                '<td colspan="2" style="border: 0.5px solid;" align="center">'+(String.isBlank(objMulta_aux.No_Acta__c)?'':objMulta_aux.No_Acta__c)+'</td>'+            
                '<td style="border: 0.5px solid;" align="center">'+(String.isBlank(objMulta_aux.Causa_de_la_penalizacion__c)?'':objMulta_aux.Causa_de_la_penalizacion__c)+'</td>'+            
                '<td colspan="3" style="border: 0.5px solid;" align="center">'+(String.isBlank(objMulta_aux.Descripcion_del_acuerdo__c)?'':objMulta_aux.Descripcion_del_acuerdo__c)+'</td>'+            
                '<td style="border: 0.5px solid;" align="center">'+procesarFecha(objMulta_aux.Fecha_documento__c,'DD')+'/'+procesarFecha(objMulta_aux.Fecha_documento__c,'MM')+'/'+procesarFecha(objMulta_aux.Fecha_documento__c,'AAAA')+'</td>'+
                '<td style="border: 0.5px solid;" align="center">'+(String.isBlank(objMulta_aux.Conciliada__c)?'':objMulta_aux.Conciliada__c)+'</td>'+          
                '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((objMulta_aux.Valor__c== null?0:objMulta_aux.Valor__c))+'</td>'+
                '</tr>';
                cant++;
            }
        	htmlScriptSanciones +=
            '<tr>'+            
            '<td colspan="9" style="border: 0.5px solid;" align="Left">54. Valor Total Sanciones, Multas e Incumplimientos</td>'+
            '<td style="border: 0.5px solid;" align="center">'+formatearCampoMoneda((valorTotalSancionMulta== null?0:valorTotalSancionMulta))+'</td>'+
          	'</tr>'+  
            '<tr>'+            
            '<td colspan="3" style="border: 0.5px solid;" align="Left">55. Observaciones o Novedades</td>'+
            '<td colspan="7" style="border: 0.5px solid;" align="Left">&nbsp;&nbsp;&nbsp;'+(String.isBlank(objContract.Observaciones_o_novedades__c)?'':objContract.Observaciones_o_novedades__c)+'</td>'+
          	'</tr>'+  
        	'</table>';
    }
    
    // :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::  
	  
	public void Generar_html_firmas(){
        htmlScriptFirmas =
            '<table style="width: 100%;">'+
            '<tr>'+
            '<td colspan="2" style="border: 0.5px solid;" align="left">56. Fecha elaboración:</td>'+
            '<td style="border: 0.5px solid;" align="center">'+procesarFecha(fechaInforme,'DD')+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+procesarFecha(fechaInforme,'MM')+'</td>'+
            '<td style="border: 0.5px solid;" align="center">'+procesarFecha(fechaInforme,'AAAA')+'</td>'+
            '<td style="border: 0.5px solid;" align="center">&nbsp;</td>'+
            '<td style="border: 0.5px solid;" align="center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>'+
            '<td style="border: 0.5px solid;" align="center">&nbsp;</td>'+
            '<td style="border: 0.5px solid;" align="center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>'+
            '<td colspan="2" style="border: 0.5px solid;" align="center">&nbsp;</td>'+            
            '<td style="border: 0.5px solid;" align="center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>'+                    
          	'</tr>'+
            '<tr>'+
            '<td colspan="2" style="border: 0.5px solid;" align="left">57. Nombre del supervisor del contrato:</td>'+
            '<td colspan="3" style="border: 0.5px solid;" align="center">'+(String.isBlank(objContract.Supervisor_Administrativo__r.Name)?'':objContract.Supervisor_Administrativo__r.Name)+'</td>'+            
            '<td style="border: 0.5px solid;" align="center">Número de ETB:</td>'+
            '<td style="border: 0.5px solid;" align="center">'+(String.isBlank(objContract.Supervisor_Administrativo__r.EmployeeNumber)?'':objContract.Supervisor_Administrativo__r.EmployeeNumber)+'</td>'+
            '<td style="border: 0.5px solid;" align="center">Firma:</td>'+
            '<td colspan="2" style="border: 0.5px solid;" align="center">&nbsp;</td>'+            
            '<td style="border: 0.5px solid;" align="center">Tel/contacto:</td>'+
            '<td style="border: 0.5px solid;" align="center">&nbsp;</td>'+                    
          	'</tr>'+
            '<tr>'+
            '<td colspan="2" style="border: 0.5px solid;" align="left">58. Nombre del supervisor técnico (SI APLICA):</td>'+
            '<td colspan="3" style="border: 0.5px solid;" align="center">'+(String.isBlank(objContract.Supervisor_tecnico__r.Name)?'':objContract.Supervisor_tecnico__r.Name)+'</td>'+                        
            '<td style="border: 0.5px solid;" align="center">Número de ETB:</td>'+
            '<td style="border: 0.5px solid;" align="center">'+(String.isBlank(objContract.Supervisor_tecnico__r.EmployeeNumber)?'':objContract.Supervisor_tecnico__r.EmployeeNumber)+'</td>'+
            '<td style="border: 0.5px solid;" align="center">Firma:</td>'+
            '<td colspan="2" style="border: 0.5px solid;" align="center">&nbsp;</td>'+            
            '<td style="border: 0.5px solid;" align="center">Tel/contacto:</td>'+
            '<td style="border: 0.5px solid;" align="center">&nbsp;</td>'+                     
          	'</tr>'+
            '<tr>'+
            '<td colspan="2" style="border: 0.5px solid;" align="left">59. Representante del área usuaria (SI APLICA):</td>'+
            '<td colspan="3" style="border: 0.5px solid;" align="center">'+(String.isBlank(objContract.Representante_area_usuaria__c)?'':objContract.Representante_area_usuaria__c)+'</td>'+                        
            '<td style="border: 0.5px solid;" align="center">Número de ETB:</td>'+            
            '<td style="border: 0.5px solid;" align="center">'+(String.isBlank(objContract.Codigo_ETB_representante_area_usuaria__c)?'':objContract.Codigo_ETB_representante_area_usuaria__c)+'</td>'+                        
            '<td style="border: 0.5px solid;" align="center">Firma:</td>'+
            '<td colspan="2" style="border: 0.5px solid;" align="center">&nbsp;</td>'+            
            '<td style="border: 0.5px solid;" align="center">Tel/contacto:</td>'+
            '<td style="border: 0.5px solid;" align="center">&nbsp;</td>'+                    
          	'</tr>'+
        	'</table>';
    } 
    // :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::  
	  
	public void Generar_html_control_cambio(){
        htmlScriptControlCambio =
            '<table style="width: 100%;">'+
            '<tr>'+            
            '<td style="border: 0.5px solid;" align="center">Versión</td>'+
            '<td colspan="9" style="border: 0.5px solid;" align="center">Descripción del Cambio</td>'+
            '<td colspan="3" style="border: 0.5px solid;" align="center">Fecha</td>'+                              
          	'</tr>'+
            '<tr>'+            
            '<td style="border: 0.5px solid;" align="center">1.0</td>'+
            '<td colspan="9" style="border: 0.5px solid;" align="Left">Creación del formato "Informe de Supervisión – Estado del Contrato"</td>'+
            '<td colspan="3" style="border: 0.5px solid;" align="center">22/08/2018</td>'+                              
          	'</tr>'+
            '<tr>'+            
            '<td style="border: 0.5px solid;" align="center">2.0</td>'+
            '<td colspan="9" style="border: 0.5px solid;" align="Left">Se incluye la fecha máxima para pedidos; se modifica la redacción del campo 12; se aclara en el instructivo del formato: el campo de 23, la información que se debe colocar en tipo de contrato, el proceso de consulta de homologación de proveedores y la información que debe ir en descripcion de actas; se incluye y / O  a los literales III y IV, se incluye ( SI APLICA ) al numeral 59, se amplia la explicación en el instructivo del detalle del saldo en la numeral 47.</td>'+
            '<td colspan="3" style="border: 0.5px solid;" align="center">26/06/2019</td>'+                              
          	'</tr>'+            
        	'</table>';
    }    
    public PageReference regresar(){        
		String url;
        url = '/'+idRecord;
		PageReference page = new PageReference(url);
		return page;
    }
}