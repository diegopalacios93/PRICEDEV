public with sharing class Acta_certificado_aliado_PDF_ctr {
    public String idRecord					{get; set;}  
    public String urlLogoETB        		{get; set;} 
    public String pageUrlExport			    {get; set;}
    public String htmlScriptHeader          {get; set;}
    public String htmlPieDePagina			{get; set;}
    public String htmlPagina_1	   		    {get; set;}      
    public Acta_de_Certificado__c objActa	{get; set;}
    public list<Adiciones_y_prorrogas_contratos__c> lstAdicionesProrrogas = new  list<Adiciones_y_prorrogas_contratos__c>();    
    ContratoColaboradorHelper_cls.ConvertirNumeroATexto clsHelper = new ContratoColaboradorHelper_cls.ConvertirNumeroATexto();
    
    public Acta_certificado_aliado_PDF_ctr(ApexPages.StandardController controller){        
        idRecord = ApexPages.currentPage().getParameters().get('id');        
        pageUrlExport = '/apex/Acta_cetificado_aliado_PDF_pag?id='+idRecord;
        consultarActa(idRecord);
        ConsultarAdicionProrroga(objActa.Contrato_relacionado__r.Id);
        procesarURLFile('Logo_ETB');
        Generar_html_encabezado();
        procesarURLFile('Logo_ETB_pie_de_pagina');
        Generar_html_pie_de_pagina();
        Generar_html_Pagina_1();
    }
    public PageReference regresar(){        
		String url;
        url = '/'+idRecord;
		PageReference page = new PageReference(url);
		return page;
    }
    public void procesarURLFile(string idLogo){          
        string idLogo_ETB;
        List<Document> lstDoc;       
        lstDoc = [Select Id from Document where DeveloperName = :idLogo limit 1];        
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
            return '0';    
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
    
    public void ConsultarAdicionProrroga (String idContrato){
       lstAdicionesProrrogas = [  SELECT Id, Fecha_de_inicio__c, Fecha_de_fin__c, Prorroga_o_adicion__c, Objeto__c FROM Adiciones_y_prorrogas_contratos__c WHERE Contrato_relacionado__r.Id =: idContrato ORDER BY Fecha_de_inicio__c ASC];
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
        system.debug('IdActa: ' + idActa);
        objActa = Database.query('Select Id, CSG__c, Tratamiento__c, Nombre_del_representante_del_aliado__c, Apellido_del_representante_del_aliado__c, '
                                 +'Cargo_del_representante_del_aliado__c, Contrato_relacionado__r.Aliado__r.Direccion__c, Cargo_del_apoderado__c, Firma_del_apoderado__c, '
                                 +'Contrato_relacionado__r.Aliado__r.Name, Contrato_relacionado__r.Aliado__r.Ciudad__r.Name, Contrato_relacionado__r.Aliado__r.Phone, '
                                 +'Contrato_relacionado__r.Anexo__c, Contrato_relacionado__r.Supervisor_Administrativo__r.Name, Facultado_1__c, Facultado_2__c, Tratamiento_del_apoderado__c, ' 
                                 +'Vicepresidencia_Facultado_1__c, Vicepresidencia_Facultado_2__c, Contrato_relacionado__r.NIT_Aliado__c, Contrato_relacionado__r.Objeto__c,'
                    			 +'Contrato_relacionado__r.Valor_sin_IVA__c, Contrato_relacionado__r.Valor_adiciones_sin_iva__c, Contrato_relacionado__r.Plazo_de_ejecucion_escritura__c,'
                                 +'Contrato_relacionado__r.Status, Contrato_relacionado__r.Fecha_de_terminacion__c, Fecha_de_liquidacion__c, Contrato_relacionado__r.Fecha_de_suscripcion__c, Suscripcion_de_acuerdos__c, '
                                 +'Contrato_relacionado__r.Facturado__c, Contrato_relacionado__r.Supervisor_Administrativo__r.vicepresidencia__c, Contrato_relacionado__r.Supervisor_Administrativo__r.EmployeeNumber, Fecha_de_elaboracion__c, Contrato_relacionado__r.Valor_mas_adiciones_sin_IVA__c, Contrato_relacionado__r.Valor_ejecutado_calculado_escritura__c '
                                 +'FROM Acta_de_Certificado__c where Id=:idActa limit 1');   
    }  
        
    // :::::::::::::::::::::::::::::::::::::::::: GENERACIÓN DE HTML ::::::::::::::::::::::::::::::::::::::::::::::::::::
    
    public void Generar_html_encabezado(){
         htmlScriptHeader  =
            '<table style="width: 100%;">'+
            '<tbody>'+
            '<tr>'+
            '<td style="border: 0px solid; color:#c0c0c0;" align="Left" ><span class="contenido_8px_NB">Carrera 8 No 20 – 70 Piso 1 Oficina de Correspondencia ETB</span><br><span class="contenido_8px_NB">Código Postal: 110311</span><br><span class="contenido_8px_NB">Conmutador: 242 2000</span></td>'+
            '<td style="border: 0px solid;" align="right" width: 30%; ><img src="'+urlLogoETB+'" width="120" height="90" /></td>'+
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
            '<td style="border: 0px;" align="Left"><span class="contenido_9px_NB_footer">07-07.7-F-024-v.2</span><br><span class="contenido_9px_Italic_NB_footer">“Una vez impreso este documento, se considerará</span><span class="contenido_9px_Italic_footer"> documento no controlado”.</span></td>'+
            '<td style="border: 0px;" align="Center"><span class="contenido_9px_NB_footer">22/08/2018</span><br><span class="contenido_9px_footer">Pág. </span><span class="pagenumber"/></td>'+
            '<td style="border: 0px solid;" align="right" ><img src="'+urlLogoETB+'" width="60" height="15" /></td>'+
            '</tr>'+            		
            '</tbody>'+
            '</table>';
    }
    public void Generar_html_Pagina_1(){
        integer sumaAdicionesSinIVA = Integer.valueOf(objActa.Contrato_relacionado__r.Valor_sin_IVA__c) + Integer.valueOf(objActa.Contrato_relacionado__r.Valor_adiciones_sin_iva__c);
        htmlPagina_1 = 
            '<br/>'+
            '<table style="width: 100%;">'+
            '<tbody>'+
             '<tr>'+
            '<td align="Left" ><span class="contenido_14px">Bogota D.C., '+procesarFecha(objActa.Fecha_de_elaboracion__c,'DD')+' de '+procesarFecha(objActa.Fecha_de_elaboracion__c,'MM_Name')+' de '+procesarFecha(objActa.Fecha_de_elaboracion__c,'AAAA')+ '</span></td>'+ 
            '</tr>'+
            '<tr>'+
            '<td style="width: 85%;" align="Center" ></td>'+ 
            '<td style="width: 15%; color:#a6a6a6;" align="Jusfity"  ><span class="contenido_8px">Al responder, por favor cite este número consecutivo GSC-' + Integer.valueOf(objActa.CSG__c== null?0:objActa.CSG__c) + '-2021 CECO: VO01</span></td>'+ 
            '</tr>'+
            '<tr><td>&nbsp;</td></tr>'+
            '</tbody>'+
            '</table>'+
            '<table style="width: 100%;">'+
            '<tr>'+
            '<td style="border: 0px ;" align="Left"><span class="contenido_11px_NB">' + (String.isBlank(objActa.Tratamiento__c)?'':objActa.Tratamiento__c) + '</span></td>'+ 
            '</tr>'+
            '<tr>'+
            '<td style="border: 0px;" align="Left"><span class="contenido_14px">' + (String.isBlank(objActa.Nombre_del_representante_del_aliado__c)?'':objActa.Nombre_del_representante_del_aliado__c).toUpperCase() + ' ' + (String.isBlank(objActa.Apellido_del_representante_del_aliado__c)?'':objActa.Apellido_del_representante_del_aliado__c).toUpperCase() + '</span></td>'+
            '</tr>'+
            '<tr>'+
            '<td style="border: 0px ;" align="Left"><span class="contenido_10px_NB">' + (String.isBlank(objActa.Cargo_del_representante_del_aliado__c)?'':objActa.Cargo_del_representante_del_aliado__c) + '</span></td>'+ 
          	'</tr>'+
            '<tr>'+
            '<td style="border: 0px;" align="Left"><span class="contenido_14px">' + (String.isBlank(objActa.Contrato_relacionado__r.Aliado__r.Name)?'':objActa.Contrato_relacionado__r.Aliado__r.Name) + '</span></td>'+
            '</tr>'+
            '<tr>'+
            '<td style="border: 0px ;" align="Left"><span class="contenido_10px_NB">' + (String.isBlank(objActa.Contrato_relacionado__r.Aliado__r.Direccion__c)?'':objActa.Contrato_relacionado__r.Aliado__r.Direccion__c) + '</span></td>'+ 
          	'</tr>'+
            '<tr>'+
            '<td style="border: 0px ;" align="Left"><span class="contenido_10px_NB">' + (String.isBlank(objActa.Contrato_relacionado__r.Aliado__r.Phone)?'':objActa.Contrato_relacionado__r.Aliado__r.Phone) + '</span></td>'+ 
          	'</tr>'+
            '<tr>'+
            '<td style="border: 0px ;" align="Left"><span class="contenido_10px_NB">' + (String.isBlank(objActa.Contrato_relacionado__r.Aliado__r.Ciudad__r.Name)?'':objActa.Contrato_relacionado__r.Aliado__r.Ciudad__r.Name) + '</span></td>'+ 
          	'</tr>'+ 
            '<td>&nbsp;</td>'+
            '<tr>'+
            '<td style="border: 0px ;" align="Left"><span class="contenido_14px_NB">Asunto: </span><span class="contenido_14px" > Constancia y/ o certificación Anexo Colaborador</span></td>'+
          	'</tr>'+
            '<td>&nbsp;</td><td>&nbsp;</td>';
        	if(objActa.Tratamiento__c == 'Señora'){
            	htmlPagina_1+=
                '<tr>'+
            	'<td style="border: 0px ;" align="Left"><span class="contenido_14px_NB">Respetada ' + (String.isBlank(objActa.Tratamiento__c)?'':objActa.Tratamiento__c) + ' </span><span class="contenido_14px" >' + (String.isBlank(objActa.Nombre_del_representante_del_aliado__c)?'':objActa.Nombre_del_representante_del_aliado__c) + '</span></td>'+
          	    '</tr>';
            }else{
                htmlPagina_1+=
                '<tr>'+
                '<td style="border: 0px ;" align="Left"><span class="contenido_14px_NB">Respetado ' + (String.isBlank(objActa.Tratamiento__c)?'':objActa.Tratamiento__c) + ' </span><span class="contenido_14px" >' + (String.isBlank(objActa.Apellido_del_representante_del_aliado__c)?'':objActa.Apellido_del_representante_del_aliado__c) + '</span></td>'+
          	    '</tr>';                    
            }
            htmlPagina_1+=  
            '<tr><td>&nbsp;</td></tr>'+
            '<tr>'+
            '<td align="justify">Se hace constar que el ' + (String.isBlank(objActa.Contrato_relacionado__r.Anexo__c)?'':objActa.Contrato_relacionado__r.Anexo__c) + ' supervisado por ' + (String.isBlank(objActa.Contrato_relacionado__r.Supervisor_Administrativo__r.Name)?'':objActa.Contrato_relacionado__r.Supervisor_Administrativo__r.Name) + ' , suscrito por ' + (String.isBlank(objActa.Facultado_1__c)?'':objActa.Facultado_1__c) + ' de la ' +(String.isBlank(objActa.Vicepresidencia_Facultado_1__c)?'':objActa.Vicepresidencia_Facultado_1__c) + ' y ' + (String.isBlank(objActa.Facultado_2__c)?'':objActa.Facultado_2__c) + ' de la ' +(String.isBlank(objActa.Vicepresidencia_Facultado_2__c)?'':objActa.Vicepresidencia_Facultado_2__c) + ' y el COLABORADOR EMPRESARIO ' + (String.isBlank(objActa.Contrato_relacionado__r.Aliado__r.Name)?'':objActa.Contrato_relacionado__r.Aliado__r.Name) + ' identificado con el NIT ' + (String.isBlank(objActa.Contrato_relacionado__r.NIT_Aliado__c)?'':objActa.Contrato_relacionado__r.NIT_Aliado__c)  + ', anexo celebrado con la <span class="contenido_14px">EMPRESA DE TELECOMUNICACIONES DE BOGOTA S.A. ESP</span>, identificada con el NIT. 899.999.115-8, en cuyo desarrollo se resaltan los siguientes aspectos :</td>'+
            '</tr>'+
            '<tr><td>&nbsp;</td></tr>'+
            '<tr>'+
            '<td align="justify">a)<span class="contenido_14px" style="margin-left: 0.5cm;">Objeto: </span>'+(String.isBlank(objActa.Contrato_relacionado__r.Objeto__c)?'':objActa.Contrato_relacionado__r.Objeto__c)+'</td>'+
          	'</tr>'+
            '<td>&nbsp;</td>'+
          	'<tr>'+
            '<td align="justify">b)<span class="contenido_14px" style="margin-left: 0.5cm;">Fecha de suscripción del Anexo: </span>'+procesarFecha(objActa.Contrato_relacionado__r.Fecha_de_suscripcion__c,'DD')+' de '+procesarFecha(objActa.Contrato_relacionado__r.Fecha_de_suscripcion__c,'MM_Name')+' de '+procesarFecha(objActa.Contrato_relacionado__r.Fecha_de_suscripcion__c,'AAAA')+'</td>'+
          	'</tr>'+
          	'<td>&nbsp;</td>'+    
          	'<tr>'+
            '<td align="justify">c)<span class="contenido_14px" style="margin-left: 0.5cm;">Valor total del Anexo: </span>La suma de hasta '+clsHelper.getCifraEnTexto(((objActa.Contrato_relacionado__r.Valor_mas_adiciones_sin_IVA__c == null?0:objActa.Contrato_relacionado__r.Valor_mas_adiciones_sin_IVA__c)).longValue())+' PESOS M/CTE ('+ formatearCampoMoneda(objActa.Contrato_relacionado__r.Valor_mas_adiciones_sin_IVA__c) +') antes de IVA.</td>'+
          	'</tr>'+
          	'<td>&nbsp;</td>'+
          	 '<tr>'+
            '<td align="justify">d)<span class="contenido_14px" style="margin-left: 0.5cm;">Plazo de Ejecución: </span>' + (String.isBlank(objActa.Contrato_relacionado__r.Plazo_de_ejecucion_escritura__c)?'':objActa.Contrato_relacionado__r.Plazo_de_ejecucion_escritura__c) +'</td>'+
          	'</tr>';
          	// :::::::::::::::: GENERACIÓN Tabla de Adiciones y Prorrogas ::::::::::::::::::::::::
        	if(objActa.Suscripcion_de_acuerdos__c == TRUE && lstAdicionesProrrogas.size() > 0){
                if(lstAdicionesProrrogas.size() > 0){
                    htmlPagina_1 +=
                	'<table style="width: 100%;">'+
                    '<tbody>';                    
                    for (integer i = 0; i<lstAdicionesProrrogas.size(); i++){
                        htmlPagina_1 += 
                            
                        '<tr>'+
                        '<td align="justify"><span class="contenido_14px" style="margin-left: 0.8cm;">Otrosí No.' + formatearCampoNumero(i+1) + ': </span>'+(lstAdicionesProrrogas[i].Objeto__c)+'.</td>'+
                        '</tr>';
                    }
                    htmlPagina_1 +=     
                    '</tbody>'+
                    '</table>';
                }
            }
        	// Fin Tabla de Adiciones y Prorrogas
        	htmlPagina_1+='<td>&nbsp;</td>'+
          	'<tr>'+
            '<td align="justify">e)<span class="contenido_14px" style="margin-left: 0.5cm;">Fecha de orden de inicio: </span>N/A</td>'+
          	'</tr>'+
            '<td>&nbsp;</td>'+
          	'<tr>'+
            '<td align="justify">f)<span class="contenido_14px" style="margin-left: 0.5cm;">Estado del Anexo: </span>' + (String.isBlank(objActa.Contrato_relacionado__r.Status)?'':objActa.Contrato_relacionado__r.Status) +'</td>'+
          	'</tr>'+
          	'<td>&nbsp;</td>'+
            '<tr>'+
            '<td align="justify">g)<span class="contenido_14px" style="margin-left: 0.5cm;">Fecha de terminación: </span>'+procesarFecha(objActa.Contrato_relacionado__r.Fecha_de_terminacion__c,'DD')+' de '+procesarFecha(objActa.Contrato_relacionado__r.Fecha_de_terminacion__c,'MM_Name')+' de '+procesarFecha(objActa.Contrato_relacionado__r.Fecha_de_terminacion__c,'AAAA')+'</td>'+
          	'</tr>'+
          	'<td>&nbsp;</td>'+
            '<tr>'+
            '<td align="justify">h)<span class="contenido_14px" style="margin-left: 0.5cm;">Fecha de liquidación: </span>N/A</td>'+ //+ procesarFecha(objActa.Fecha_de_liquidacion__c,'DD') + ' de '+procesarFecha(objActa.Fecha_de_liquidacion__c,'MM_Name')+' de '+procesarFecha(objActa.Fecha_de_liquidacion__c,'AAAA')+'</td>'+
          	'</tr>'+
          	'<td>&nbsp;</td>'+
            '<tr>'+
            '<td align="justify">i)<span class="contenido_14px" style="margin-left: 0.5cm;">Cumplimiento de las obligaciones: </span>El aliado ha cumplido con las obligaciones establecidas en los anexos y registra un valor ejecutado de '+clsHelper.getCifraEnTexto(((objActa.Contrato_relacionado__r.Valor_ejecutado_calculado_escritura__c == null?0:objActa.Contrato_relacionado__r.Valor_ejecutado_calculado_escritura__c)).longValue())+' PESOS M/CTE ('+ formatearCampoMoneda(objActa.Contrato_relacionado__r.Valor_ejecutado_calculado_escritura__c) +') antes de IVA.</td>'+
          	'</tr>'+
           	'<td>&nbsp;</td><td>&nbsp;</td>'+
            '<tr>'+
            '<td align="justify">La suscrita Vicepresidente de Experiencia, suscribe el presente documento en calidad de apoderada.</td>'+
            '</tr>'+
          	'<td>&nbsp;</td><td>&nbsp;</td>'+
            '<tr>'+
            '<td align="justify">La presente Certificación se expide en Bogotá D.C, a solicitud del interesado a los ' + clsHelper.getCifraEnTexto(Integer.valueOf(procesarFecha(objActa.Fecha_de_elaboracion__c,'DD'))).toLowerCase() + '  (' + procesarFecha(objActa.Fecha_de_elaboracion__c,'DD') + ') dia/s del mes de '+procesarFecha(objActa.Fecha_de_elaboracion__c,'MM_Name')+' del año '+procesarFecha(objActa.Fecha_de_elaboracion__c,'AAAA')+'.</td>'+
            '</tr>'+
            '<td>&nbsp;</td>'+
            '<tr>'+
            '<td align="justify">Cordialmente, </td>'+
            '</tbody>'+
            '</table>'+
            '</tr>'+            
            '<table style="width: 100%;">'+
            '<tbody>'+                       
            '<tr>'+
            '<td style="width: 50%; border: 0px solid;" align="Left"><div class="body"><span class="contenido_11px">[Firma]</span></div></td>'+
            '<td style="width: 50%; border: 0px solid;" align="Left"><div class="body"><span class="contenido_11px">[VoBo.]</span></div></td>'+            
            '</tr>'+  
            '<tr>'+
            '<td><br><br><br><br><br><br></td>'+    
            '</tr>'+ 
            '<tr>'+
            '<td style="width: 50%; border: 0px solid;" align="Left"><div class="body"><span class="contenido_14px">'+(String.isBlank(objActa.Firma_del_apoderado__c)?'':objActa.Firma_del_apoderado__c)+'</span></div></td>'+
            '<td style="width: 50%; border: 0px solid;" align="Left"><div class="body"><span class="contenido_14px">'+(String.isBlank(objActa.Contrato_relacionado__r.Supervisor_Administrativo__r.Name)?'':objActa.Contrato_relacionado__r.Supervisor_Administrativo__r.Name)+'</span></div></td>'+            
            '</tr>'+
            '<tr>'+
            '<td style="width: 50%; border: 0px solid; vertical-align:top;" align="Left"><div class="body"><span class="contenido_13_px_NB">'+(String.isBlank(objActa.Cargo_del_apoderado__c)?'':objActa.Cargo_del_apoderado__c)+'<br>'+(String.isBlank(objActa.Tratamiento_del_apoderado__c)?'':objActa.Tratamiento_del_apoderado__c)+' </span></div></td>'+
            '<td style="width: 50%; border: 0px solid; vertical-align:top;" align="Left"><div class="body"><span class="contenido_13_px_NB">Supervisor Administrativo del Contrato<br>'+(String.isBlank(objActa.Contrato_relacionado__r.Supervisor_Administrativo__r.EmployeeNumber)?'Nro_Empleado_No_Existente': 'No ETB ' + objActa.Contrato_relacionado__r.Supervisor_Administrativo__r.EmployeeNumber)+'<br>Gerencia de Servicios Corporativos</span></div></td>'+
            '</tr>'+
            '<td>&nbsp;</td>'+    
            '</body>'+    
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