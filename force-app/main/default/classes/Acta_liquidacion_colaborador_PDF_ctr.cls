public class Acta_liquidacion_colaborador_PDF_ctr {
    public list<Aprobacion_de_garantias_del_contrato__c> lstGarantias = new  list<Aprobacion_de_garantias_del_contrato__c>();
    public list<Adiciones_y_prorrogas_contratos__c> lstAdicionesProrrogas = new  list<Adiciones_y_prorrogas_contratos__c>();
    public list<Conciliaciones_de_contrato__c> lstConciliaciones = new  list<Conciliaciones_de_contrato__c>();
    public String idRecord					{get; set;}  
    public String urlLogoETB        		{get; set;} 
    public String pageUrlExport			    {get; set;}
    public String htmlScriptHeader          {get; set;}
    public String htmlPieDePagina			{get; set;}
    public String htmlPagina_1	   		    {get; set;}      
    public Acta_de_liquidaci_n__c objActa	{get; set;}         
    ContratoColaboradorHelper_cls.ConvertirNumeroATexto clsHelper = new ContratoColaboradorHelper_cls.ConvertirNumeroATexto();
        
    public Acta_liquidacion_colaborador_PDF_ctr(ApexPages.StandardController controller){        
        idRecord = ApexPages.currentPage().getParameters().get('id');        
        pageUrlExport = '/apex/Acta_liquidacion_colaborador_PDF_pag?id='+idRecord;
        procesarURLFile();
        consultarActa(idRecord);
        ConsultarGarantia(idRecord);
        ConsultarAdicionProrroga(objActa.Contrato_relacionado__r.Id);
        ConsultarConciliacion (objActa.Contrato_relacionado__r.Id);
        Generar_html_encabezado();
        Generar_html_pie_de_pagina();
        Generar_html_Pagina_1();
    }
    public PageReference regresar(){        
		String url;
        url = '/'+idRecord;
		PageReference page = new PageReference(url);
		return page;
    }
    public void procesarURLFile(){          
        string idLogo_ETB;
        List<Document> lstDoc;       
        lstDoc = [Select Id from Document where DeveloperName = 'Logo_ETB' limit 1];        
        if(lstDoc.size() > 0)
            idLogo_ETB = lstDoc[0].Id;        
         
        urlLogoETB  = '/servlet/servlet.FileDownload?file='+idLogo_ETB;            
    }

    
    public string procesarFecha(date fecha, string DMY){        
        if(fecha != null){
            if(DMY == 'DD')
                return String.valueOf(fecha.day());
            else if (DMY == 'MM')
            	return String.valueOf(fecha.month());
            else if (DMY == 'MM_Name')
            	return obtenerNombreMes(String.valueOf(fecha.month()));
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
    
    public string formatearCampoMoneda(Decimal valor){
        List<String> args = new String[]{'0','number','###,###,##0.00'};
        if(valor == null)            
        	return '$'+String.format('0', args);		
        else
            return '$'+String.format(valor.format(), args);		
    }
    
    public string formatearCampoNumero(integer numero){
        string valor = string.valueOf(numero);
        switch on valor.length() {
           when 1 {valor = '00' + valor;}
           when 2 {valor = '0' + valor;}
           when else {valor=valor;}
       }        
       return valor; 
    } 
    // :::::::::::::::::::::::::::::::::::::::::: CONSULTA DE DATOS  ::::::::::::::::::::::::::::::::::::::::::::::::::::
    
    public void consultarActa(String idActa){ 

        objActa = Database.query('Select Id, Fecha_de_aprobaci_n_de_garant_as__c, Fecha_de_liquidaci_n__c, Fecha_de_validaci_n_financiera__c, Vicepresidente_de_experiencia__c, Cantidad_de_meses_liquidacion__c, '
                                 +'Subscripcion_de_acuerdos__c, nombre_del_representate_legal__c, Cargo_del_representante_legal__c, Vicepresidente_de_empresa__c, Aseguradora__c, Cargo_firmante_de_experiencia__c, Cargo_firmante_de_empresa__c, '
                                 +'Contrato_relacionado__r.Objeto__c, Contrato_relacionado__r.Fecha_de_suscripcion__c,  Contrato_relacionado__r.Plazo_de_ejecucion_escritura__c, '
                                 +'Contrato_relacionado__r.Aliado__r.Name, Contrato_relacionado__r.ContractNumber, Contrato_relacionado__r.Account.Name, '
                                 +'Contrato_relacionado__r.Fecha_de_inicio__c, Contrato_relacionado__r.Valor_sin_IVA__c,Contrato_relacionado__r.IVA_Contrato_Colaborador__c,'
                                 +'Contrato_relacionado__r.Valor_adiciones_sin_iva__c, Contrato_relacionado__r.Valor_adiciones__c, Contrato_relacionado__r.Fecha_de_terminacion__c,'
                                 +'Contrato_relacionado__r.Facturado__c, Contrato_relacionado__r.Saldo_calculado_escritura__c, Contrato_relacionado__r.Supervisor_Administrativo__r.Title,'
                                 +'Contrato_relacionado__r.Fecha_maxima_de_liquidacion__c, Contrato_relacionado__r.Id, Contrato_relacionado__r.Supervisor_Administrativo__r.Name, Contrato_relacionado__r.Vicepresidencia__c, '
                                 +'Contrato_relacionado__r.Supervisor_Administrativo__r.vicepresidencia__c, Contrato_relacionado__r.Anexo__c, '
                                 +'Contrato_relacionado__r.Supervisor_Administrativo__r.EmployeeNumber, Clausula__c '
                                 +'FROM Acta_de_liquidaci_n__c where Id=:idActa limit 1');   
    }  
    
    public void ConsultarGarantia (String idActa){
        lstGarantias = [ SELECT Id, Amparo__c, Aseguradora__c, N_mero_de_P_liza__c, Valor_Asegurado__c, Vigencia__c  FROM Aprobacion_de_garantias_del_contrato__c WHERE Contrato__r.Id =: objActa.Contrato_relacionado__r.Id AND Vigencia__c > :date.today() ORDER BY Vigencia__c ASC];
    }
    
    public void ConsultarAdicionProrroga (String idContrato){
       lstAdicionesProrrogas = [  SELECT Id, Fecha_de_inicio__c, Prorroga_o_adicion__c, Objeto__c FROM Adiciones_y_prorrogas_contratos__c WHERE Contrato_relacionado__r.Id =: idContrato ORDER BY Fecha_de_inicio__c ASC];
    }
    public void ConsultarConciliacion (String idContrato){
       lstConciliaciones = [  SELECT Id, Numero_de_acta__c, Descripcion__c, Valor_sin_IVA__c, IVA__c, Valor_total_incluido_IVA__c FROM Conciliaciones_de_contrato__c WHERE Contrato_relacionado__r.Id =: idContrato ORDER BY Fecha_del_acta__c ASC];
    }
    
    // :::::::::::::::::::::::::::::::::::::::::: GENERACIÓN DE HTML ::::::::::::::::::::::::::::::::::::::::::::::::::::
    
    public void Generar_html_encabezado(){
         htmlScriptHeader  =
            '<table style="width: 100%;">'+
            '<tbody>'+
            '<tr>'+
            '<td style="border: 0px solid;" align="right"><img src="'+urlLogoETB+'" width="120" height="90" /></td>'+
            '</tr>'+
            '<td>&nbsp;</td>'+
            '</tbody>'+
            '</table>';
    }
    
    public void Generar_html_pie_de_pagina(){
        htmlPieDePagina = 
            '<table style="width: 100%;" >'+
            '<tbody>'+	
            '<tr>'+
            '<td style="border: 0px;" align="Left"><span class="contenido_9px_NB_footer">10-10.2-F-077-v.1</span><br><span class="contenido_9px_Italic_NB_footer">“Una vez impreso este documento, se considerará</span><span class="contenido_9px_Italic_footer"> documento no controlado”.</span></td>'+
            '<td style="border: 0px;" align="Center"><span class="contenido_9px_NB_footer">21/04/2021</span><br><span class="contenido_9px_footer">Pág. </span><span class="pagenumber"/></td>'+
            '</tr>'+            		
            '</tbody>'+
            '</table>';
    }
    
    public String toTitleCase(String phrase){
        String titlePhrase = '';    
        if(phrase != null && phrase.length() > 0){
            String[] splitPhrase = phrase.trim().split(' ');
            
            for(integer i = 0; i < splitPhrase.size(); i++){
                //  if(i == 0 || i == (splitPhrase.size()-1) ){
                titlePhrase += (splitPhrase[i].substring(0,1).toUpperCase())+(splitPhrase[i].substring(1).toLowerCase())+' ';
                //  }else{
                //    titlePhrase += splitPhrase[i].toLowerCase()+' ';
                //  }
            }
        }
        return titlePhrase.trim();
	}
    
    public void Generar_html_Pagina_1(){
        long valorInicialConIVA = (objActa.Contrato_relacionado__r.Valor_sin_IVA__c).longValue() + (objActa.Contrato_relacionado__r.IVA_Contrato_Colaborador__c).longValue();
        long sumaAdicionesSinIVA = (objActa.Contrato_relacionado__r.Valor_sin_IVA__c).longValue() + (objActa.Contrato_relacionado__r.Valor_adiciones_sin_iva__c).longValue();
        Long sumaValoresIVA = (objActa.Contrato_relacionado__r.IVA_Contrato_Colaborador__c).longValue() + ((objActa.Contrato_relacionado__r.Valor_adiciones__c).longValue() - (objActa.Contrato_relacionado__r.Valor_adiciones_sin_iva__c).longValue());
        Long sumaValoresConIVA =valorInicialConIVA + (objActa.Contrato_relacionado__r.Valor_adiciones__c).longValue();
        htmlPagina_1 = 
            '<br/>'+
            '<table style="width: 100%;">'+
            '<tbody>'+
            '<tr>'+
            '<td style="border: 0px solid;" align="Center"><span class="contenido_14px">EMPRESA DE TELECOMUNICACIONES DE BOGOTA S. A E.S.P</span></td>'+ 
            '</tr>'+
            '<tr>'+
            '<td style="border: 0px solid;" align="Center"><span class="contenido_14px">VICEPRESIDENCIA DE EMPRESAS Y CIUDADES INTELIGENTES</span></td>'+ 
            '</tr>'+
            '<tr>'+
            '<td style="border: 0px solid;" align="Center"><span class="contenido_14px">VICEPRESIDENCIA DE EXPERIENCIA</span></td>'+ 
            '</tr>'+
            '<tr><td>&nbsp;</td></tr>'+
            '<tr><td>&nbsp;</td></tr>'+
            '<tr>'+
            '<td style="border: 0px;" align="justify"><span class="contenido_12px">ACTA DE LIQUIDACIÓN DEL ' + (String.isBlank(objActa.Contrato_relacionado__r.Anexo__c)?'':objActa.Contrato_relacionado__r.Anexo__c) + '</span></td>'+
            '</tr>'+
            '<tr><td>&nbsp;</td></tr>'+
            '<tr>'+
            '<td align="justify">1.<span class="contenido_14px" style="margin-left: 0.5cm;">Objeto: </span>'+(String.isBlank(objActa.Contrato_relacionado__r.Objeto__c)?'':objActa.Contrato_relacionado__r.Objeto__c)+'</td>'+
          	'</tr>'+
            '<td>&nbsp;</td>'+
          	'<tr>'+
            '<td align="justify">2.<span class="contenido_14px" style="margin-left: 0.5cm;">Fecha de suscripción: </span>'+procesarFecha(objActa.Contrato_relacionado__r.Fecha_de_suscripcion__c,'DD')+' de '+procesarFecha(objActa.Contrato_relacionado__r.Fecha_de_suscripcion__c,'MM_Name')+' de '+procesarFecha(objActa.Contrato_relacionado__r.Fecha_de_suscripcion__c,'AAAA')+'</td>'+
          	'</tr>'+
          	'<td>&nbsp;</td>'+
          	'<tr>'+
            '<td align="justify">3.<span class="contenido_14px" style="margin-left: 0.5cm;">Plazo inicial: </span>'+(String.isBlank(objActa.Contrato_relacionado__r.Plazo_de_ejecucion_escritura__c)?'':objActa.Contrato_relacionado__r.Plazo_de_ejecucion_escritura__c)+'</td>'+
          	'</tr>'+
          	'<td>&nbsp;</td>'+
          	'<tr>'+
            '<td align="justify">4.<span class="contenido_14px" style="margin-left: 0.5cm;">Orden de inicio: </span>N/A</td>'+
          	'</tr>'+
          	'<td>&nbsp;</td>'+
          	'<tr>'+
            '<td align="justify">5.<span class="contenido_14px" style="margin-left: 0.5cm;">Precio inicial: </span>El valor de la participación del COLABORADOR EMPRESARIO corresponderá a la suma de hasta '+clsHelper.getCifraEnTexto(((objActa.Contrato_relacionado__r.Valor_sin_IVA__c== null?0:objActa.Contrato_relacionado__r.Valor_sin_IVA__c)).longValue())+' PESOS M/CTE ('+formatearCampoMoneda(Integer.valueOf((objActa.Contrato_relacionado__r.Valor_sin_IVA__c== null?0:objActa.Contrato_relacionado__r.Valor_sin_IVA__c)))+') con un IVA de '+clsHelper.getCifraEnTexto(((objActa.Contrato_relacionado__r.IVA_Contrato_Colaborador__c== null?0:objActa.Contrato_relacionado__r.IVA_Contrato_Colaborador__c)).longValue())+' PESOS M/CTE ('+formatearCampoMoneda(Integer.valueOf((objActa.Contrato_relacionado__r.IVA_Contrato_Colaborador__c== null?0:objActa.Contrato_relacionado__r.IVA_Contrato_Colaborador__c)))+') para un total de la participación del COLABORADOR EMPRESARIO de hasta '+clsHelper.getCifraEnTexto(valorInicialConIVA)+' PESOS M/CTE ('+formatearCampoMoneda(valorInicialConIVA)+').</td>'+
          	'</tr>'+
            '<td>&nbsp;</td>';
            if(objActa.Clausula__c != null){
                htmlPagina_1 +=
                '<tr>'+
                '<td align="justify">6.<span class="contenido_14px" style="margin-left: 0.5cm;">Conciliación de Cuentas y Transferencias de los valores recaudados (participaciones): </span>ETB realizó conciliaciones y transferencias, con sujeción a lo previsto en la cláusula ' + objActa.Clausula__c + ' del anexo financiero-comercial.</td>';    
             }else {
                    htmlPagina_1 +=
                    '<tr>'+
                    '<td align="justify">6.<span class="contenido_14px" style="margin-left: 0.5cm;">Conciliación de Cuentas y Transferencias de los valores recaudados (participaciones): </span>ETB realizó conciliaciones y transferencias, con sujeción a lo previsto en la cláusula segunda, tercera y quinta del anexo financiero-comercial.</td>';
             }
             htmlPagina_1 +=	
             '</tr>'+
          	 '<td>&nbsp;</td>';
        // :::::::::::::::: GENERACIÓN Tabla de Adiciones y Prorrogas ::::::::::::::::::::::::
        	if(objActa.Subscripcion_de_acuerdos__c == TRUE && lstAdicionesProrrogas.size() > 0){
                htmlPagina_1 +=
                '<tr>'+
                '<td align="justify">7.<span class="contenido_14px" style="margin-left: 0.5cm;">Desarrollo del anexo: </span>Durante la ejecución del anexo se suscribieron los siguientes otrosíes.</td>'+
          	    '</tr>';    
                if(lstAdicionesProrrogas.size() > 0){
                    htmlPagina_1 +=
                	'<table style="width: 100%;">'+
                    '<tbody>';                      
                    for (integer i = 0; i<lstAdicionesProrrogas.size(); i++){
                        htmlPagina_1 += 
                        '<tr>'+
                        '<td align="justify"><span class="contenido_14px" style="margin-left: 0.8cm;">Otrosí No.' + formatearCampoNumero(i+1) + ', </span>suscrito el '+procesarFecha(lstAdicionesProrrogas[i].Fecha_de_inicio__c ,'DD')+' de '+procesarFecha(lstAdicionesProrrogas[i].Fecha_de_inicio__c,'MM_Name')+' de '+procesarFecha(lstAdicionesProrrogas[i].Fecha_de_inicio__c,'AAAA')+', mediante el cual se genera una '+(String.isBlank(lstAdicionesProrrogas[i].Prorroga_o_adicion__c)?'':lstAdicionesProrrogas[i].Prorroga_o_adicion__c)+' y '+(String.isBlank(lstAdicionesProrrogas[i].Objeto__c)?'':lstAdicionesProrrogas[i].Objeto__c)+'.</td>'+
                        '</tr>';
                    }
                    htmlPagina_1 +=     
                    '</tbody>'+
                    '</table>';
                }
            } else{
                htmlPagina_1 +=
                '<tr>'+
                '<td align="justify">7.<span class="contenido_14px" style="margin-left: 0.5cm;">Desarrollo del anexo: </span>Durante la ejecución del anexo no se suscribió otrosíes.</td>'+
          	    '</tr>'; 
            }
            htmlPagina_1 += 
          	'<td>&nbsp;</td>'+           
          	'<tr>'+
            '<td align="justify">8.<span class="contenido_14px" style="margin-left: 0.5cm;">Precio del Anexo incluidas adiciones: </span>El valor corresponde a la suma de hasta '+clsHelper.getCifraEnTexto(sumaAdicionesSinIVA)+' PESOS M/CTE ('+formatearCampoMoneda(sumaAdicionesSinIVA)+') con un IVA de '+clsHelper.getCifraEnTexto(sumaValoresIVA)+' PESOS M/CTE ('+formatearCampoMoneda(sumaValoresIVA)+') para un total de la participación del COLABORADOR EMPRESARIO de hasta '+clsHelper.getCifraEnTexto(sumaValoresConIVA)+' PESOS M/CTE ('+formatearCampoMoneda(sumaValoresConIVA)+')</td>'+
          	'</tr>'+
          	'<td>&nbsp;</td>'+
            '<tr>'+
            '<td align="justify">9.<span class="contenido_14px" style="margin-left: 0.5cm;">Pedidos: </span>El anexo no dispone de desarrollo por pedidos.</td>'+
            '</tr>'+
            '<td>&nbsp;</td>'+
            '<tr>'+
            '<td align="justify">10.<span class="contenido_14px" style="margin-left: 0.5cm;">Sanciones impuestas: </span>El supervisor administrativo, manifiesta que de conformidad con lo previsto en el anexo y de acuerdo a la documentación existente, el colaborador empresario no se hizo acreedor a la aplicación de sanciones.</td>'+
            '</tr>'+
            '<td>&nbsp;</td>'+
            '</table>'+
            '<table style="width: 100%";>'+
            '<tr>'+
            '<td align="justify">11.<span class="contenido_14px" style="margin-left: 0.5cm;">Actas de recibo y pagos según la complejidad del anexo: </span>Actas de conciliación y transferencia:</td>'+
            '</tr>'+
            '<td>&nbsp;</td>'+   
        // :::::::::::::::: GENERACIÓN Tabla de Conciliacion y pagos ::::::::::::::::::::::::    
            '<table style="width: 100%;">'+
			'<tbody>'+
            '<tr>'+       				
            '<td style="width: 10%; border: 0.3px solid;" align="Center "rowspan="2"><span class="contenido_8px">NÚMERO DE ACTA</span></td>'+
            '<td style="width: 40; border: 0.3px solid;" align="Center" rowspan="2"><span class="contenido_8px">CONCEPTO</span></td>'+
            '<td style="width: 50%; border: 0.3px solid;" align="Center" colspan="3"><span class="contenido_8px">VALOR ACTA DE RECIBO Y PAGO </span></td>'+
            '</tr>'+
            '<tr>'+
            '<td style="width: 15%; border: 0.3px solid;" align="Center"><span class="contenido_8px">VALOR SIN IVA </span></td>'+
            '<td style="width:10%; border: 0.3px solid;" align="Center"><span class="contenido_8px">IVA </span></td>'+
            '<td style="width: 15%; border: 0.3px solid;" align="Center"><span class="contenido_8px">VALOR TOTALINCLUIDO IVA </span></td>'+
            '</tr> ';
        	if(lstConciliaciones.size()>0){
                Decimal valorSinIva=0; 
                Decimal totalIva=0;
                Decimal valorConIva=0;
                for(integer i = 0; i<lstConciliaciones.size(); i++){
                    valorSinIva += lstConciliaciones[i].Valor_sin_IVA__c==null?0:lstConciliaciones[i].Valor_sin_IVA__c;        
                    totalIva +=  lstConciliaciones[i].IVA__c==null?0:lstConciliaciones[i].IVA__c;     
                    valorConIva += lstConciliaciones[i].Valor_total_incluido_IVA__c==null?0:lstConciliaciones[i].Valor_total_incluido_IVA__c;
                    htmlPagina_1 += 
                    '<tr>'+                        
                    '<td style="width: 10%; border: 0.3px solid;" align="Center"><span class="contenido_9px_NB">'+ lstConciliaciones[i].Numero_de_acta__c + '</span></td>'+
                    '<td style="width: 40%; border: 0.3px solid;" align="Center"><span class="contenido_9px_NB">'+(String.isBlank(lstConciliaciones[i].Descripcion__c)?'':lstConciliaciones[i].Descripcion__c)+'</span></td>'+
                    '<td style="width: 15%; border: 0.3px solid;" align="Center"><span class="contenido_9px_NB">'+formatearCampoMoneda(lstConciliaciones[i].Valor_sin_IVA__c==null?0:lstConciliaciones[i].Valor_sin_IVA__c)+'</span></td>'+
                    '<td style="width: 10%; border: 0.3px solid;" align="Center"><span class="contenido_9px_NB">'+formatearCampoMoneda(lstConciliaciones[i].IVA__c==null?0:lstConciliaciones[i].IVA__c)+'</span></td>'+
                    '<td style="width: 15%; border: 0.3px solid;" align="Center"><span class="contenido_9px_NB">'+formatearCampoMoneda(lstConciliaciones[i].Valor_total_incluido_IVA__c==null?0:lstConciliaciones[i].Valor_total_incluido_IVA__c)+'</span></td>'+
                    '</tr>';
                 }
                htmlPagina_1 +=
                '<tr>'+                         
                '<td style="width: 10%;" align="Center"><span class="contenido_9px_NB"></span></td>'+
                '<td style="width: 40%; border: 0.3px solid;" align="Center"><span class="contenido_9px_NB">Total</span></td>'+
                '<td style="width: 15%; border: 0.3px solid;" align="Center"><span class="contenido_9px_NB">'+formatearCampoMoneda(valorSinIva==null?0:valorSinIva)+'</span></td>'+
                '<td style="width: 15%; border: 0.3px solid;" align="Center"><span class="contenido_9px_NB">'+formatearCampoMoneda(totalIva==null?0:totalIva)+'</span></td>'+
                '<td style="width: 20%; border: 0.3px solid;" align="Center"><span class="contenido_9px_NB">'+formatearCampoMoneda(valorConIva==null?0:valorConIva)+'</span></td>'+
                '</tr>';
            }
        	htmlPagina_1 += 
            '</tbody>'+
            '</table>'+ 
            '<td>&nbsp;</td>'+
            //if(objActa.Contrato_relacionado__r.Saldo_calculado_escritura__c == null){
                //htmlPagina_1 += 
                '<tr>'+
            	'<td align="justify">12.<span class="contenido_14px" style="margin-left: 0.5cm;">Total pagos efectuados: </span>De acuerdo al aval financiero remitido por el área de facturación y cartera de ETB, el valor conciliado corresponde a ' + clsHelper.getCifraEnTexto(((objActa.Contrato_relacionado__r.Facturado__c== null?0:objActa.Contrato_relacionado__r.Facturado__c)).longValue()) + ' PESOS M/CTE (' + formatearCampoMoneda(objActa.Contrato_relacionado__r.Facturado__c) + '), según lo recaudado por ETB y reconocido por el cliente, se declaran a paz y salvo por todo concepto, por lo anterior se procede a la liquidación del presente anexo.</td>'+            	
            	'</tr>'+
            /*}else{
                htmlPagina_1 += 
                '<tr>'+            	
              if(Integer.valueOf(objActa.Contrato_relacionado__r.Saldo_calculado_escritura__c) > 0){
                
              }
            	htmlPagina_1 += '.</td></tr>';
            }
            htmlPagina_1 +=*/
            '<td>&nbsp;</td>'+
            '<tr>'+
            '<td align="justify">13.<span class="contenido_14px" style="margin-left: 0.5cm;">Terminación: </span>El contrato finalizó el '+procesarFecha(objActa.Contrato_relacionado__r.Fecha_de_terminacion__c,'DD')+' / '+procesarFecha(objActa.Contrato_relacionado__r.Fecha_de_terminacion__c,'MM_Name')+' / '+procesarFecha(objActa.Contrato_relacionado__r.Fecha_de_terminacion__c,'AAAA')+'</td>'+
            '</tr>'+
            '<td>&nbsp;</td>'+
            '<tr>'+  
            '<td align="justify">14.<span class="contenido_14px" style="margin-left: 0.5cm;">Plazo de liquidación:</span> La cláusula TRIGÉSIMA CUARTA TERMINACIÓN Y LIQUIDACIÓN del contrato establece que el contrato o los respectivos anexos se liquidarán por las partes dentro de los '+(String.isBlank(objActa.Cantidad_de_meses_liquidacion__c)?'':objActa.Cantidad_de_meses_liquidacion__c)+' meses siguientes a su terminación.</td>'+
            //'<td align="justify">14.<span class="contenido_14px" style="margin-left: 0.5cm;">Plazo de liquidación: </span>El plazo es hasta el '+procesarFecha(objActa.Contrato_relacionado__r.Fecha_maxima_de_liquidacion__c,'DD')+' de '+procesarFecha(objActa.Contrato_relacionado__r.Fecha_maxima_de_liquidacion__c,'MM_Name')+' de '+procesarFecha(objActa.Contrato_relacionado__r.Fecha_maxima_de_liquidacion__c,'AAAA')+'</td>'+
            '</tr>'+
            '<td>&nbsp;</td>'+
            '<tr>'+  
            '<td align="justify">15.<span class="contenido_14px" style="margin-left: 0.5cm;">Garantías: </span>De acuerdo con lo previsto en la cláusula SEXTA - GARANTÍAS del Anexo Financiero-Comercial, a la firma de la presente acta queda vigente el siguiente amparo:<></td>'+
            '</tr>'+
            '<td>&nbsp;</td>';
        // :::::::::::::::: GENERACIÓN Tabla de Garantias ::::::::::::::::::::::::	
            if(lstGarantias.size()>0){
                 htmlPagina_1 +=
                '<table style="width: 100%;">'+
                '<tbody>'+
                '<tr>'+
                '<td style="border: 0.3px solid; background-color: #44546a; color: white;" align="Center" colspan="4"><span class="contenido_8px">ASEGURADORA:'+(String.isBlank(objActa.Aseguradora__c)?'':objActa.Aseguradora__c)+'</span></td>'+
                '</tr>'+
                '<tr>'+
                '<td style="width: 30%; border: 0.3px solid; background-color: #44546a; color: white;" align="Center"><span class="contenido_8px">AMPARO</span></td>'+
                '<td style="width: 20%; border: 0.3px solid; background-color: #44546a; color: white;" align="Center"><span class="contenido_8px">NÚMERO DE PÓLIZA</span></td>'+
                '<td style="width: 20%; border: 0.3px solid; background-color: #44546a; color: white;" align="Center"><span class="contenido_8px">VALOR ASEGURADO</span></td>'+
                '<td style="width: 10%; border: 0.3px solid; background-color: #44546a; color: white;" align="Center"><span class="contenido_8px">VIGENCIA</span></td>'+
                '</tr>';
                for(Aprobacion_de_garantias_del_contrato__c itemGarantia :lstGarantias){
                    string poliza = String.valueOf(itemGarantia.N_mero_de_P_liza__c);
                    String vigencia = String.valueOf(itemGarantia.Vigencia__c);
                     htmlPagina_1 +=
                    '<tr>'+                           
                    '<td style="width: 30%; border: 0.3px solid;" align="Center"><span class="contenido_9px_NB">'+(String.isBlank(itemGarantia.Amparo__c)?'':itemGarantia.Amparo__c)+'</span></td>'+
                    '<td style="width: 20%; border: 0.3px solid;" align="Center"><span class="contenido_9px_NB">'+(String.isBlank(poliza)?'':poliza)+'</span></td>'+
                    '<td style="width: 20%; border: 0.3px solid;" align="Center"><span class="contenido_9px_NB">'+formatearCampoMoneda(itemGarantia.Valor_Asegurado__c)+'</span></td>'+
                    '<td style="width: 10%; border: 0.3px solid;" align="Center"><span class="contenido_9px_NB">'+(String.isBlank(vigencia)?'':vigencia)+'</span></td>'+
                    '</tr>';              
                }      
            }
            htmlPagina_1 += 
            '</tbody>'+
            '</table>'+
            '<td>&nbsp;</td>'+           
            '<tr>'+
            '<td align="justify">16.<span class="contenido_14px" style="margin-left: 0.5cm;">Documentos: </span>Para el levantamiento de la presente Acta de Liquidación, se han tenido en cuenta los siguientes documentos:<br><ul><li><pre><li>Contrato / Anexo Financiero-Comercial, al acuerdo de colaboración empresarial suscrito entre las partes.</li><li>Las actas de recibo relacionadas en el numeral 11.</li><li>Aval financiero facturación y cartera ETB.</li><li>La aprobación de las garantías por parte del Equipo Gestión de Seguros de ETB, tal como consta en el estudio realizado el '+procesarFecha(objActa.Fecha_de_aprobaci_n_de_garant_as__c,'DD')+' de '+procesarFecha(objActa.Fecha_de_aprobaci_n_de_garant_as__c,'MM_Name')+' de '+procesarFecha(objActa.Fecha_de_aprobaci_n_de_garant_as__c,'AAAA')+'.</li></pre></ul></td>'+
            '</tr>'+
            '<td>&nbsp;</td>'+
            '<tr>'+
            '<td align="justify"><span class="contenido_14px"/>Por medio del presente documento,las partes se declaran a paz y salvo por todo concepto relacionado con el Anexo Financiero-Comercial.</td>'+
            '</tr>'+
            '<td>&nbsp;</td>'+
            '<tr>'+
            '<td align="justify"><span class="contenido_14px"/>Respecto a las obligaciones relacionadas con el con el cumplimiento del contrato, y del pago de salarios, prestaciones sociales e indemnizaciones laborales del personal que ocupó para el cumplimiento del contrato, cabe resaltar que las mismas se encuentran amparadas por el valor y término de vigencia establecido en las pólizas contractuales ya constituidas por el contratista.</td>'+
            '</tr>'+
            '<td>&nbsp;</td>'+
            '<tr>'+
            '<td><span class="contenido_14px"/>El suscrito Vicepresidente de Empresas y Ciudades Inteligentes, suscribe el presente documento en calidad de Apoderado, la liquidación del anexo está en cabeza de la Vicepresidencia de Experiencia.</td>'+
            '</tr>'+  
            '<td>&nbsp;</td>'+
            '<tr>'+
            '<td><span class="contenido_14px"/>La presente acta se suscribe en original (1) de un mismo tenor, el '+(clsHelper.getCifraEnTexto(Integer.valueOf(procesarFecha(objActa.Fecha_de_liquidaci_n__c,'DD')))).toLowerCase()+' ('+procesarFecha(objActa.Fecha_de_liquidaci_n__c,'DD')+') de '+procesarFecha(objActa.Fecha_de_liquidaci_n__c,'MM_Name')+' de '+procesarFecha(objActa.Fecha_de_liquidaci_n__c,'AAAA')+'.</td>'+
            '</tr>'+  
            '</tbody>'+
            '</table>'+
            '<br>'+
            '<table style="width: 100%;">'+
            '<tbody>'+
            '<tr>'+
            '<td style="border: 0px;" align="Left"><div class="body"><span class="contenido_9px_NB">Por:</span></div></td>'+
            '</tr>'+
            '<tr>'+
            '<td style="border: 0px;" align="Left"><div class="body"><span class="contenido_11px">EMPRESA DE TELECOMUNICACIONES DE BOGOTÁ S.A. E.S.P.</span></div></td>'+
            '</tr>'+   
            '<td>&nbsp;</td>'+
            '</tbody>'+
            '</table>'+
            '<br>'+
            '<table style="width: 100%;">'+
            '<tbody>'+
            '<td>&nbsp;</td>'+    
            '<tr>'+
            '<td style="width: 50%; border: 0px solid;" align="Left"><div class="body"><span class="contenido_11px">'+(String.isBlank(objActa.Vicepresidente_de_empresa__c)?'LIGIA ROCIO ORTIZ VILLAMIZAR':objActa.Vicepresidente_de_empresa__c)+'</span></div></td>'+
            '<td style="width: 50%; border: 0px solid;" align="Left"><div class="body"><span class="contenido_11px">'+(String.isBlank(objActa.Vicepresidente_de_experiencia__c)?'':objActa.Vicepresidente_de_experiencia__c)+'</span></div></td>'+            
            '</tr>'+
            '<tr>'+
            '<td style="width: 50%; border: 0px solid;" align="Left"><div class="body"><span class="contenido_9px">'+(String.isBlank(objActa.Cargo_firmante_de_empresa__c)?'Vicepresidente de Experiencia':objActa.Cargo_firmante_de_empresa__c)+'<br>Apoderado/a</span></div></td>'+
            '<td style="width: 50%; border: 0px solid;" align="Left"><div class="body"><span class="contenido_9px">'+(String.isBlank(objActa.Cargo_firmante_de_experiencia__c)?'':objActa.Cargo_firmante_de_experiencia__c)+'</span></div></td>'+            
            '</tr>'+
            '<td>&nbsp;</td>'+
            '<tr>'+
            '<td style="width: 50%; border: 0px solid;" align="Left"><div class="body"><span class="contenido_9px_NB">VoBo.</span></div></td>'+
            '</tr>'+             
            '</tr>'+
            '<td>&nbsp;</td>'+
            '<tr>'+
            '<td style="width: 50%; border: 0px solid;" align="Left"><div class="body"><span class="contenido_11px">'+((String.isBlank(objActa.Contrato_relacionado__r.Supervisor_Administrativo__r.Name)?'':objActa.Contrato_relacionado__r.Supervisor_Administrativo__r.Name)).toUpperCase() + ' </span></div></td>'+
            '</tr>'+            
            '<tr>'+
            '<td style="width: 50%; border: 0px solid;" align="Left"><div class="body"><span class="contenido_10px">Supervisor Administrativo del Anexo</span></div></td>'+
            '</tr>'+
            '<tr>'+
            '<td style="width: 50%; border: 0px solid;" align="Left"><div class="body"><span class="contenido_10px">No ETB '+((String.isBlank(objActa.Contrato_relacionado__r.Supervisor_Administrativo__r.EmployeeNumber)?'':objActa.Contrato_relacionado__r.Supervisor_Administrativo__r.EmployeeNumber))+'</span></div></td>'+
            '</tr>'+
            '<tr>'+
            '<td style="width: 50%; border: 0px solid;" align="Left"><div class="body"><span class="contenido_10px">Gerencia de Servicios Corporativos</span></div></td>'+
            '</tr>'+
            '<td>&nbsp;</td>'+
            '<tr>'+
            '</tr>'+
            '<td>&nbsp;</td>'+
            '<tr>'+
            '<td style="width: 50%; border: 0px solid;" align="Left"><div class="body"><span class="contenido_9px_NB">Por: </span></div></td>'+
            '</tr>'+
            '<tr>'+
            '<td style="width: 50%; border: 0px solid;" align="Left"><div class="body"><span class="contenido_10px">'+(String.isBlank(objActa.Contrato_relacionado__r.Aliado__r.Name)?'':objActa.Contrato_relacionado__r.Aliado__r.Name)+'</span></div></td>'+
            '</tr>'+
            '<td>&nbsp;</td>'+
            '<tr>'+
            '<td style="width: 50%; border: 0px solid;" align="Left"><div class="body"><span class="contenido_10px">'+(String.isBlank(objActa.nombre_del_representate_legal__c)?'':objActa.nombre_del_representate_legal__c)+'</span></div></td>'+
            '</tr>'+
            '<tr>'+
            '<td style="width: 50%; border: 0px solid;" align="Left"><div class="body"><span class="contenido_9px_NB">'+(String.isBlank(objActa.Cargo_del_representante_legal__c)?'':objActa.Cargo_del_representante_legal__c)+'</span></div></td>'+
            '</tr>'+
            '</tbody>'+
            '</table>'+
        '<table style="width: 100%;">'+
            '<tbody>'+ 
            '<td>&nbsp;&nbsp;</td>'+ 
            '<tr>'+
            '<td style="width: 5%; border: 0px solid;" align="Left"><div class="body"><span class="contenido_9px_NB_controlversion">Elaboró: </span></div></td>'+
            '<td style="width: 95%; border: 0px solid;" align="Left"><div class="body"><span class="contenido_9px_NB_controlversion"> '+(String.isBlank(objActa.Contrato_relacionado__r.Supervisor_Administrativo__r.Name)?'':toTitleCase(objActa.Contrato_relacionado__r.Supervisor_Administrativo__r.Name))+' - Supervisor Administrativo - Gerencia de servicios corporativos.</span></div></td>'+ 
            '</tr>'+    
            '<tr>'+
            '<td style="width: 5%; border: 0px solid;" align="Left"><div class="body"><span class="contenido_9px_NB_controlversion">Revisó: </span></div></td>'+
            '<td style="width: 95%; border: 0px solid;" align="Left"><div class="body"><span class="contenido_9px_NB_controlversion">Clara Inés Molina Villamarin-Profesional Especializada - Gerencia de servicios corporativos.</span></div></td>'+   
            '</tr>'+    
            '<tr>'+
            '<td style="width: 5%; border: 0px solid;" align="Left"><div class="body"><span class="contenido_9px_NB_controlversion">Aprobó: </span></div></td>'+
            '<td style="width: 95%; border: 0px solid;" align="Left"><div class="body"><span class="contenido_9px_NB_controlversion">William Reinaldo Cabrera Velásquez - Gerencia Servicios Corporativos.</span></div></td>'+   
            '</tr>'+
            '<td>&nbsp;</td>'+    
            '</tbody>'+
            '</table>';   
    }
}