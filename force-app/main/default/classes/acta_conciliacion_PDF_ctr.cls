public class acta_conciliacion_PDF_ctr {
    public String idRecord					{get; set;}  
    public String htmlScript				{get; set;}
    public String htmlScript2				{get; set;}
    public String htmlScriptHeader			{get; set;}
    public String htmlScriptHeader2			{get; set;}
    public String htmlPieDePagina			{get; set;}
    public String htmlPaginaFirmas			{get; set;}
    public String urlLogoETB        		{get; set;} 
    public String urlLogoETB2        		{get; set;} 
    public Actas_de_contrato__c objActa		{get; set;}         
    public decimal creditoConAjustePeso		{get; set;}
    ContratoColaboradorHelper_cls.ConvertirNumeroATexto clsHelper = new ContratoColaboradorHelper_cls.ConvertirNumeroATexto();
    
    public acta_conciliacion_PDF_ctr(ApexPages.StandardController controller){        
        idRecord = ApexPages.currentPage().getParameters().get('id');        
        
        procesarURLFile();
        consultarActa(idRecord);
        Generar_html_encabezado();
        Generar_html_pie_de_pagina();
        generar_html_script();
        generar_html_script_2();
        Generar_html_firmas();
    }
    
    public void procesarURLFile(){          
        string idLogo_ETB;
        List<Document> lstDoc;       
        lstDoc = [Select Id from Document where DeveloperName = 'Logo_ETB' limit 1];        
        if(lstDoc.size() > 0)
            idLogo_ETB = lstDoc[0].Id;        
         
        urlLogoETB  = '/servlet/servlet.FileDownload?file='+idLogo_ETB;            
        urlLogoETB2 = '/servlet/servlet.FileDownload?file='+idLogo_ETB;
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
        	return String.format('0', args);		
        else
            return String.format(valor.format(), args);		
    }
    // :::::::::::::::::::::::::::::::::::::::::: CONSULTA DE DATOS  ::::::::::::::::::::::::::::::::::::::::::::::::::::
    
    public void consultarActa(String idActa){        
        objActa = Database.query('Select Name, Fecha_de_acta__c, Acta_No__c, Periodo_a_conciliar_Desde__c, Participacion__c, '
                                 +'Periodo_a_conciliar_Hasta__c, Codigo_ETB__c, Fecha_de_acta_costo_administrativo__c, Observaciones__c,  '
                                 +'Contrato_relacionado__r.Codigo_acreedor_deudor__c, Dia_de_transferencia__c, Contrato_relacionado__c, Mes_de_consumo__c, '
                                 +'Devolucion_IVA__c, x4x1000_Calculado__c, Retefuente__c, Valor_a_transferir__c, Reteica__c, Cuenta_de_Cobro_CXC__c,  '
                                 +'Redondeo_valor_a_transferir__c, Base_mas_IVA__c, Suma_debito__c, Retenciones__c, Suma_credito__c, RETEICA_Localidad__c, '
                                 +'Base_mas_IVA_menos_retenciones__c, Diferencia__c, Contrato_relacionado__r.Param_Anexo_IVA__c, Param_Anexo_4x1000__c, '
                                 +'Contrato_relacionado__r.Param_Anexo_Retefuente__c, Param_Anexo_4x1000_Div__c, Contrato_relacionado__r.Param_Anexo_Reteica__c, Representante_del_aliado__c, '
                                 +'Contrato_relacionado__r.Aliado__r.Name, Contrato_relacionado__r.Supervisor_Administrativo__r.Name, Anio_de_consumo__c, Cargo_del_representante_legal__c, '
                                 +'Contrato_relacionado__r.NIT_Aliado__c, Contrato_relacionado__r.Anexo__c, Contrato_relacionado__r.Param_Retencion_IVA__c, Retencion_IVA__c, '
                                 +'Contrato_relacionado__r.Supervisor_Administrativo__r.EmployeeNumber, Contrato_relacionado__r.Account.Name,  Actas_de_contrato__c.Param_Anexo_IVA__c, Firma_digital__c, '
                                 +'Contrato_relacionado__r.Aliado__r.AccountNumber, Contrato_relacionado__r.Cuenta_revchain__c '
                                 +'FROM Actas_de_contrato__c where Id=:idActa limit 1');              
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
         '<td style="width: 27%; border: 0.5px solid;" colspan="3" align="center"><span class="contenido_14px_NB">16–16-3- F -003 v.3</span></td>'+
         '<td style="width: 48%; border: 0.5px solid;" rowspan="3" align="center"><p><span class="contenido_16px">ACTA CONCILIACIÓN ALIADO</span></p></td>'+
         '</tr>'+
         '<tr>'+
         '<td style="width: 27%; border: 0.5px solid;" colspan="3" align="center"><span class="contenido_14px">Fecha de emisión</span></td>'+
         '</tr>'+
         '<tr>'+
         '<td style="width: 9%; border: 0.5px solid;" align="center"><span class="contenido_14px_NB">23</span></td>'+
         '<td style="width: 9%; border: 0.5px solid;" align="center"><span class="contenido_14px_NB">09</span></td>'+
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
         '<td style="width: 30%; border: 0.5px solid; vertical-align:top"><span class="contenido_10px">Elaborado por:<br/><br/> _Gerencia Servicios Corporativos<br/><br/></span><span class="contenido_10px_NB">Equipo Supervisores Contratos_CSG</span><br/></td>'+
         '<td style="width: 40%; border: 0.5px solid; vertical-align:top"><span class="contenido_10px">Revisado por:<br/><br/>_Gerencia Servicios Corporativos<br/></span><span class="contenido_10px_NB">Clara Inés Molina Villamarín - Profesional Especializado<br/>Sandra Monje Pérez - Dinamizador GSC</span><span class="contenido_10px">_Gerencia Facturación y Cartera</span><span class="contenido_10px_NB">Manuel Vargas Alfonso – Profesional Especializado III Roberto Carlos Rodríguez Contreras – Profesional II<br/></span><span class="contenido_10px">_Gerencia Contabilidad e Impuestos</span><span class="contenido_10px_NB">Milena de Jesús Posada Ruíz – Profesional Especializado II</span><span class="contenido_10px">_Coordinación Contabilidad General</span><span class="contenido_10px_NB">Luz Amanda Padilla Riveros – Profesional III</span></td>'+
         '<td style="width: 30%; border: 0.5px solid; vertical-align:top"><span class="contenido_10px">Aprobado por:<br/><br/>_Gerencia Servicios Corporativos<br/></span><span class="contenido_10px_NB">William Reinaldo Cabrera Velásquez - <br/>Gerente</span><br/></td>'+
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
    public void generar_html_script(){
        
        htmlScript =       
        '<table style="width: 100%";>'+
          '<tr>'+
            '<td><p align="center"><span class="contenido_12px_NB">ACTA No '+(String.isBlank(objActa.Acta_No__c)?'':objActa.Acta_No__c)+'</span></p></td>'+
          '</tr>'+
          '<tr>'+
            '<td><span class="contenido_12px_NB">CONCILIACION ENTRE EMPRESA DE TELECOMUNICACIONES DE BOGOTA    S.A. ESP - E.T.B. y '+(String.isBlank(objActa.Contrato_relacionado__r.Aliado__r.Name)?'':objActa.Contrato_relacionado__r.Aliado__r.Name)+'</span><br/>'+
            '</p></td>'+
          '</tr>'+
          '<tr>'+
            '<td>&nbsp;</td>'+
          '</tr>'+
          '<tr>'+
            '<td><span class="contenido_12px_NB">FECHA ACTA DE CONCILIACIÓN: '+procesarFecha(objActa.Fecha_de_acta__c,'DD')+' de '+procesarFecha(objActa.Fecha_de_acta__c,'MM_Name')+' de '+procesarFecha(objActa.Fecha_de_acta__c,'AAAA')+'</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td><br/><span class="contenido_12px_NB">LUGAR : Bogot&aacute;, D.C.</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td><br/><span class="contenido_12px_NB">OBJETO : Revisar y aprobar la conciliaci&oacute;n de cuentas correspondiente al o (los) periodo de consumo, de '+objActa.Mes_de_consumo__c+' del año '+objActa.Anio_de_consumo__c+'.</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td><br/><span class="contenido_12px_NB">Las partes manifiestan com&uacute;n acuerdo con    las cifras presentadas en los informes de Facturaci&oacute;n,<br />'+
             'Recaudo, y Formato de Conciliaci&oacute;n con Aliados (anexo), presentando el siguiente resultado:</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td><br/><span class="contenido_12px_NB">SALDO A FAVOR DE: '+(String.isBlank(objActa.Contrato_relacionado__r.Aliado__r.Name)?'':objActa.Contrato_relacionado__r.Aliado__r.Name)+'</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td><br/><span class="contenido_12px_NB">VALOR EN NUMEROS : $ '+formatearCampoMoneda((objActa.Redondeo_valor_a_transferir__c== null?0:objActa.Redondeo_valor_a_transferir__c))+' </span></td>'+
          '</tr>'+
          '<tr>'+
            '<td><br/><span class="contenido_12px_NB">VALOR EN LETRAS: '+clsHelper.getCifraEnTexto(((objActa.Redondeo_valor_a_transferir__c== null?0:objActa.Redondeo_valor_a_transferir__c)).longValue())+' PESOS M/CTE*. </span></td>'+                       
          '</tr>'+
          '<tr>'+
            '<td><br/><span class="contenido_12px_NB">FECHA TRANSFERENCIA : '+(String.isBlank(objActa.Dia_de_transferencia__c)?'':objActa.Dia_de_transferencia__c)+' de&nbsp; '+procesarFecha(objActa.Fecha_de_acta__c,'MM_Name')+' de '+procesarFecha(objActa.Fecha_de_acta__c,'AAAA')+' </span></td>'+
          '</tr>'+
          '<tr>'+
            '<td><br/><span class="contenido_12px_NB">OBSERVACIONES:</span></td>'+
          '</tr>';
          if(objActa.Firma_digital__c){
          htmlScript +=    
          '<tr><td><br/></td></tr>'+
          '<tr>'+
          '<td style="border: 0px;" align="justify"><div class="body"><span class="contenido_11px ">Nota: La aceptación del presente documento se hará mediante el mecanismo de firma electrónica en los términos reconocidos en la Ley 527 de 1999 con el cumplimiento de los requisitos dispuestos en el decreto1074 de 2015 y demás normas que lo modifiquen o complementen, por lo que las partes reconocen que cumplido el procedimiento aquí establecido le otorgará la autenticidad a este documento y se obligan en los mismos términos que aquí se establecen.</span><br/></td>'+
          '</tr>'+
          '<tr><td><br/></td></tr>'+
          '<tr>'+
            '<td style="border: 0px;" align="justify"><div class="body"><span class="contenido_11px">Las hojas de registro de firmas electrónicas y reporte de trazabilidad que se encuentran al final de la presente Acta de Conciliación Aliado y hacen parte integral de la misma.</span></td>'+
          '</tr>';
          }else{
          htmlScript +=
           '<tr>'+
            '<td><br/><span class="contenido_12px_NB">Para constancia se firma en Bogot&aacute;, el '+procesarFecha(objActa.Fecha_de_acta__c,'DD')+' de '+procesarFecha(objActa.Fecha_de_acta__c,'MM_Name')+' de '+procesarFecha(objActa.Fecha_de_acta__c,'AAAA')+', por las personas que intervinieron en esta conciliaci&oacute;n.</span></td>'+              
           '</tr>'+
           '</table>'+
           '<p>&nbsp;</p>'+        
           '<table style="width: 100%";>'+
           '<tr>'+
            '<td style="width: 50%;" align="Center"><span class="contenido_11px">______________________________________</span></td>'+
            '<td style="width: 50%;" align="Center"><span class="contenido_11px">______________________________________</span></td>'+
           '</tr>'+
            '<tr>'+
            '<td style="width: 50%;" align="Center"><span class="contenido_11px">'+((String.isBlank(objActa.Contrato_relacionado__r.Supervisor_Administrativo__r.Name)?'':objActa.Contrato_relacionado__r.Supervisor_Administrativo__r.Name)).toUpperCase()+'</span></td>'+
            '<td style="width: 50%;" align="Center"><span class="contenido_11px">'+((String.isBlank(objActa.Representante_del_aliado__c)?'':objActa.Representante_del_aliado__c)).toUpperCase()+'</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td style="width: 50%;" align="Center"><span class="contenido_11px">SUPERVISOR ADMINISTRATIVO</span></td>'+
            '<td style="width: 50%;" align="Center"><span class="contenido_11px">'+((String.isBlank(objActa.Cargo_del_representante_legal__c)?'REPRESENTANTE LEGAL':objActa.Cargo_del_representante_legal__c)).toUpperCase()+'</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td style="width: 50%;" align="Center"><span class="contenido_11px">E.T.B.</span></td>'+
            '<td style="width: 50%;" align="Center"><span class="contenido_11px">'+(String.isBlank(objActa.Contrato_relacionado__r.Aliado__r.Name)?'':objActa.Contrato_relacionado__r.Aliado__r.Name)+'</span></td>'+
          '</tr>';
          }
        htmlScript +='</table>';
    }
    ///
    ///
    public void generar_html_script_2(){        
      	creditoConAjustePeso = (objActa.Suma_credito__c== null?0:objActa.Suma_credito__c) + (objActa.Diferencia__c== null?0:objActa.Diferencia__c);            
        htmlScript2 =
        '<table style="width: 145%;" border="0.2" align="center">'+
          '<tr>'+
            '<td bgcolor="#E5E5E5" width="50%" align="Left"><span class="contenido_10px">1. FECHA ACTA DE CONCILIACIÓN: '+procesarFecha(objActa.Fecha_de_acta__c,'DD')+' DE '+procesarFecha(objActa.Fecha_de_acta__c,'MM_Name'). toUpperCase()+' DE '+procesarFecha(objActa.Fecha_de_acta__c,'AAAA')+'</span></td>'+
            '<td bgcolor="#E5E5E5" width="50%" align="Left"><span class="contenido_10px">2. ACTA No: '+(String.isBlank(objActa.Acta_No__c)?'':objActa.Acta_No__c)+'</span></td>'+
          '</tr>'+ 
          '<tr>'+
            '<td width="50%" align="Left"><span class="contenido_10px">3. ALIADO: '+(String.isBlank(objActa.Contrato_relacionado__r.Aliado__r.Name)?'':objActa.Contrato_relacionado__r.Aliado__r.Name)+'</span></td>'+
            '<td width="50%" align="Left"><span class="contenido_10px">4. NIT ALIADO: '+(String.isBlank(objActa.Contrato_relacionado__r.Aliado__r.AccountNumber)?'':objActa.Contrato_relacionado__r.Aliado__r.AccountNumber)+'</span></td>'+
          '</tr>'+ 
          '<tr>'+
            '<td width="50%" align="Left"><span class="contenido_10px">5. CLIENTE: '+(String.isBlank(objActa.Contrato_relacionado__r.Account.Name)?'':objActa.Contrato_relacionado__r.Account.Name)+'</span></td>'+
            '<td width="50%" align="Left"><span class="contenido_10px">6. CONTRATO CLIENTE: '+(String.isBlank(objActa.Contrato_relacionado__r.Anexo__c)?'':objActa.Contrato_relacionado__r.Anexo__c)+'</span></td>'+
          '</tr>'+ 
        '</table>'+
         //bloque
        '<table style="width: 145%;" border="0.2" align="center">'+
         '<tr>'+
            '<td bgcolor="#E5E5E5" width="25%" align="center"><span class="contenido_10px">7. CUENTA REVCHAIN O SAP</span></td>'+
            '<td bgcolor="#E5E5E5" width="30%" align="center"><span class="contenido_10px">8. PERIODO A CONCILIAR</span></td>'+
            '<td bgcolor="#E5E5E5" width="45%" align="center"><span class="contenido_10px">9. PARTICIPACIÓN DEL ALIADO</span></td>'+
         '</tr>'+
         '<tr>'+
            '<td width="25%" align="center"><span class="contenido_10px_NB">'+(String.isBlank(objActa.Contrato_relacionado__r.Cuenta_revchain__c) || objActa.Contrato_relacionado__r.Cuenta_revchain__c == 'Pendiente'?'':objActa.Contrato_relacionado__r.Cuenta_revchain__c)+'</span></td>'+
            '<td width="30%" align="center"><span class="contenido_10px_NB">Del '+procesarFecha(objActa.Periodo_a_conciliar_Desde__c,'DD')+' de '+procesarFecha(objActa.Periodo_a_conciliar_Desde__c,'MM_Name')+' al '+procesarFecha(objActa.Periodo_a_conciliar_Hasta__c,'DD')+' de '+procesarFecha(objActa.Periodo_a_conciliar_Hasta__c,'MM_Name')+' de '+procesarFecha(objActa.Periodo_a_conciliar_Hasta__c,'AAAA')+'</span></td>'+
            '<td width="45%" align="center"><span class="contenido_10px_NB">$'+formatearCampoMoneda((objActa.Participacion__c== null?0:objActa.Participacion__c))+'</span></td>'+
         '</tr>'+          
         '<tr>'+
            '<td bgcolor="#E5E5E5" width="55%" colspan="2" width="25%" align="Left"><span class="contenido_10px">10. TOTAL PARTICIPACIÓN ALIADO SIN IVA</span></td>'+
            '<td bgcolor="#E5E5E5" width="45%" align="center"><span class="contenido_10px">$ '+formatearCampoMoneda((objActa.Participacion__c== null?0:objActa.Participacion__c))+'</span></td>'+
         '</tr>'+
        '</table>'+
        '<table style="width: 145%;" border="0.2" align="center">'+
           '<tr>'+
            '<td align="center" colspan="2" bgcolor="#E5E5E5" width="15%"><span class="contenido_10px">11. Código acreedor/deudor NIT generico</span></td>'+
            '<td align="center" colspan="2" bgcolor="#E5E5E5" width="20%"><span class="contenido_10px">12. Cuenta contable (PCCO)</span></td>'+
            '<td align="center" bgcolor="#E5E5E5" width="20%"><span class="contenido_10px">13. Desccripción</span></td>'+
            '<td align="center" bgcolor="#E5E5E5" width="10%"><span class="contenido_10px">14. Unidades</span></td>'+
            '<td align="center" bgcolor="#E5E5E5" width="10%"><span class="contenido_10px">15. Centro Beneficio</span></td>'+
            '<td align="center" bgcolor="#E5E5E5"  width="10%"><span class="contenido_10px">16. Débito</span></td>'+
            '<td align="center" bgcolor="#E5E5E5"  width="10%"><span class="contenido_10px">17. Crédito</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center" colspan="2"><span class="contenido_11px_NB" width="15%">'+(String.isBlank(objActa.Contrato_relacionado__r.Codigo_acreedor_deudor__c)?'':objActa.Contrato_relacionado__r.Codigo_acreedor_deudor__c)+'</span></td>'+
            '<td align="center" width="10%"><span class="contenido_11px_NB">40</span></td>'+
            '<td align="center" width="10%"><span class="contenido_11px_NB">29110392</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">RECAUDO</span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB">&nbsp;</span></td>'+
            '<td align="right"><span class="contenido_11px_NB">$ '+formatearCampoMoneda((objActa.Participacion__c== null?0:objActa.Participacion__c))+'</span></td>'+
            '<td align="right"><span class="contenido_11px_NB"></span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center" colspan="2"><span class="contenido_11px_NB" width="10%">'+(String.isBlank(objActa.Contrato_relacionado__r.Codigo_acreedor_deudor__c)?'0':objActa.Contrato_relacionado__r.Codigo_acreedor_deudor__c)+'</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">40</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">29110208</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">IVA</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">'+(objActa.Param_Anexo_IVA__c==null?0:objActa.Param_Anexo_IVA__c)+'%</span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="right"><span class="contenido_11px_NB">$ '+formatearCampoMoneda((objActa.Devolucion_IVA__c== null?0:objActa.Devolucion_IVA__c))+'</span></td>'+           
            '<td align="right"><span class="contenido_11px_NB"></span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center" colspan="2"><span class="contenido_11px_NB" width="10%"></span>&nbsp;</td>'+
            '<td align="center"><span class="contenido_11px_NB">50</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">24171251</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">RTE IVA</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">'+(objActa.Contrato_relacionado__r.Param_Retencion_IVA__c==null?0:objActa.Contrato_relacionado__r.Param_Retencion_IVA__c)+'%</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">&nbsp;</span></td>'+
            '<td align="right"><span class="contenido_11px_NB"></span></td>'+
            '<td align="right"><span class="contenido_11px_NB">$ '+formatearCampoMoneda((objActa.Retencion_IVA__c== null?0:objActa.Retencion_IVA__c))+'</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center" colspan="2"><span class="contenido_11px_NB" width="10%"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB">50</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">24171251</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">RTE FUENTE</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">'+(objActa.Contrato_relacionado__r.Param_Anexo_Retefuente__c==null?0:objActa.Contrato_relacionado__r.Param_Anexo_Retefuente__c)+'%</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">&nbsp;</span></td>'+
            '<td align="right"><span class="contenido_11px_NB"></span></td>'+
            '<td align="right"><span class="contenido_11px_NB">$ '+formatearCampoMoneda((objActa.Retefuente__c== null?0:objActa.Retefuente__c))+'</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center" colspan="2"><span class="contenido_11px_NB" width="10%"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB">50</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">24172011</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">RTE ICA</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">'+(objActa.Contrato_relacionado__r.Param_Anexo_Reteica__c==null?0:objActa.Contrato_relacionado__r.Param_Anexo_Reteica__c)+'%</span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="right"><span class="contenido_11px_NB"></span></td>'+
            '<td align="right"><span class="contenido_11px_NB">$ '+formatearCampoMoneda((objActa.Reteica__c== null?0:objActa.Reteica__c))+'</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center" colspan="2"><span class="contenido_11px_NB" width="10%">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB">RTE ICA * Localidad</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">0.00%</span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="right"><span class="contenido_11px_NB"></span></td>'+
            '<td align="right"><span class="contenido_11px_NB">$ '+formatearCampoMoneda((objActa.RETEICA_Localidad__c== null?0:objActa.RETEICA_Localidad__c))+'</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center" colspan="2"><span class="contenido_11px_NB" width="10%">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB">TOTAL RETENCIONES</span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="right"><span class="contenido_11px_NB"></span></td>'+
            '<td align="right"><span class="contenido_11px_NB">$ '+formatearCampoMoneda((objActa.Retenciones__c== null?0:objActa.Retenciones__c))+'</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center" colspan="2"><span class="contenido_11px_NB" width="10%">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB">CUENTA DE COBRO (CXC)</span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="right"><span class="contenido_11px_NB"></span></td>'+
            '<td align="right"><span class="contenido_11px_NB">$ '+formatearCampoMoneda((objActa.Cuenta_de_Cobro_CXC__c== null?0:objActa.Cuenta_de_Cobro_CXC__c))+'</span></td>'+
          '</tr>'+     
          '<tr>'+
            '<td align="center" colspan="2"><span class="contenido_11px_NB" width="10%"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB">SUBTOTAL A TRANSFERIR</span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="right"><span class="contenido_11px_NB"></span></td>'+
            '<td align="right"><span class="contenido_11px_NB">$ '+formatearCampoMoneda((objActa.Base_mas_IVA_menos_retenciones__c== null?0:objActa.Base_mas_IVA_menos_retenciones__c))+'</span></td>'+
          '</tr>'+            
          '<tr>'+
            '<td align="center" colspan="2"><span class="contenido_11px_NB" width="10%">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">50</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">24173113</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">4X1000</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">4X1000</span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="right"><span class="contenido_11px_NB"></span></td>'+
            '<td align="right"><span class="contenido_11px_NB">'+formatearCampoMoneda((objActa.x4x1000_Calculado__c== null?0:objActa.x4x1000_Calculado__c))+'</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center" colspan="2"><span class="contenido_11px_NB" width="10%">'+(String.isBlank(objActa.Contrato_relacionado__r.Codigo_acreedor_deudor__c)?'':objActa.Contrato_relacionado__r.Codigo_acreedor_deudor__c)+'</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">31</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">24150818</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">TOTAL A TRANSFERIR</span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="right"><span class="contenido_11px_NB"></span></td>'+
            '<td align="right"><span class="contenido_11px_NB">$ '+formatearCampoMoneda((objActa.Redondeo_valor_a_transferir__c== null?0:objActa.Redondeo_valor_a_transferir__c))+'</span></td>'+
          '</tr>'+         
          '<tr>'+
            '<td align="center" colspan="2"><span class="contenido_11px_NB" width="10%">Ajuste al peso</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">40</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">48219001</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB">YC001</span></td>'+
            '<td align="right"><span class="contenido_11px_NB"></span></td>'+
            '<td align="right"><span class="contenido_11px_NB">$ '+formatearCampoMoneda((objActa.Diferencia__c== null?0:objActa.Diferencia__c))+'</span></td>'+
          '</tr>'+
          '</tr>'+
            '<td align="center" colspan="7"><span class="contenido_11px">18. SUMAS IGUALES</span></td>'+
            '<td align="right"><span class="contenido_11px">$ '+formatearCampoMoneda((objActa.Suma_debito__c== null?0:objActa.Suma_debito__c))+'</span></td>'+
            '<td align="right"><span class="contenido_11px">$ '+formatearCampoMoneda(creditoConAjustePeso)+'</span></td>'+
          '</tr>'+          
          '<tr>'+
            '<td align="Left" colspan="3"><span class="contenido_10px">&nbsp;19. FECHA DE TRANSFERECIA: </span></td>'+
            '<td align="Left" colspan="2"><span class="contenido_10px_NB">&nbsp;'+procesarFecha(objActa.Fecha_de_acta__c,'MM_Name')+' '+objActa.Dia_de_transferencia__c+' de '+procesarFecha(objActa.Fecha_de_acta__c,'AAAA')+'</span></td>'+
            '<td align="Right" colspan="2"><span class="contenido_10px">20. VICEPRESIDENCIA No. 29&nbsp;</span></td>'+
            '<td align="Right" colspan="2"><span class="contenido_10px_NB">$ '+formatearCampoMoneda((objActa.Diferencia__c== null?0:objActa.Diferencia__c))+'</span></td>'+            
          '</tr>'+
          '<tr>'+
            '<td align="Left" colspan="3"><span class="contenido_10px">&nbsp;21. CONCEPTO: </span></td>'+
            '<td align="Left" colspan="6"><span class="contenido_10px_NB">&nbsp;Conciliación Acta No. '+(String.isBlank(objActa.Acta_No__c)?'':objActa.Acta_No__c)+'</span></td>'+
          '</tr>'+
           '<tr>'+
            '<td align="Left" colspan="9"><span class="contenido_10px">&nbsp;22. OBSERVACIONES: '+(String.isBlank(objActa.Observaciones__c)?'':objActa.Observaciones__c)+'</span></td>'+
          '</tr>';
        	if(objActa.Firma_digital__c){
            htmlScript2 +=
           '<tr>'+
           '<td align="left" colspan="9"><div class="body"><span class="contenido_9px" >Nota:<br/>La aceptación del presente documento se hará mediante el mecanismo de firma electrónica en los términos reconocidos en la Ley 527 de 1999 con el cumplimiento de los requisitos dispuestos en el decreto 1074 de 2015 y demás normas que lo modifiquen o complementen, por lo que las partes reconocen que cumplido el procedimiento aquí establecido le otorgará la autenticidad a este documento y se obligan en los mismos términos que aquí se establecen.<br/><br/>Las hojas de registro de firmas electrónicas y reporte de trazabilidad que se encuentran al final de la presente Acta de Conciliación Aliado y hacen parte integral de la misma.</span></td>'+
           '</tr>';
            }else{
            htmlScript2 +=
              '<tr>'+
              '<td colspan="12">'+
              '<table style="width: 100%;" border="0">'+
              '<tr>'+
              '<td align="Left" width="15%"><span class="contenido_10px"></td>'+
              '<td align="center" width="30%"><span class="contenido_10px"><br><br><br>_________________________________________</span></td>'+
              '<td align="center" width="51%"><span class="contenido_10px"><br><br><br>_________________________________________</span></td>'+
              '</tr>'+
              '<tr>'+
              '<td align="Left" width="15%"><span class="contenido_11px">24. AUTORIZADO POR:</td>'+
              '<td align="center" width="30%"><span class="contenido_11px">'+((String.isBlank(objActa.Contrato_relacionado__r.Supervisor_Administrativo__r.Name)?'':objActa.Contrato_relacionado__r.Supervisor_Administrativo__r.Name)).toUpperCase()+'</td>'+
              '<td align="center" width="52%"><span class="contenido_11px">'+((String.isBlank(objActa.Representante_del_aliado__c)?'':objActa.Representante_del_aliado__c)).toUpperCase()+'</td>'+
              '</tr>'+
              '<tr>'+
              '<td align="center" width="15%"><span class="contenido_11px"></td>'+
              '<td align="center" width="30%"><span class="contenido_11px">SUPERVISOR DE CONTRATO</td>'+
              '<td align="center" width="52%"><span class="contenido_11px">'+((String.isBlank(objActa.Cargo_del_representante_legal__c)?'REPRESENTANTE LEGAL':objActa.Cargo_del_representante_legal__c)).toUpperCase()+'</td>'+
              '</tr>'+
              '<tr>'+
              '<td align="center" width="15%"><span class="contenido_11px"></td>'+
              '<td align="center" width="30%"><span class="contenido_11px">ETB '+(String.isBlank(objActa.Contrato_relacionado__r.Supervisor_Administrativo__r.EmployeeNumber)?'':objActa.Contrato_relacionado__r.Supervisor_Administrativo__r.EmployeeNumber)+'</td>'+
              '<td align="center" width="52%"><span class="contenido_11px">'+((String.isBlank(objActa.Contrato_relacionado__r.Aliado__r.Name)?'':objActa.Contrato_relacionado__r.Aliado__r.Name)).toUpperCase()+'</td>'+
              '</tr>'+
              '</table>'+
              '</td>'+
              '</tr>';
            }               
        htmlScript2 +='</table>';        
    }
    public void Generar_html_firmas(){ 
          
      htmlPaginaFirmas =
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
          '<td style="width: 15%; border: 0.3px solid;" align="Left"><span class="contenido_9px_NB_controlversion">1</span></td>'+
          '<td style="width: 55%; border: 0.3px solid;" align="Left"><span class="contenido_9px_NB_controlversion"> Documento Inicial</span></td>'+
          '<td style="width: 30%; border: 0.3px solid;" align="Center"><span class="contenido_9px_NB_controlversion">7 de septiembre 2020</span></td>'+
        '</tr>'+
         '<tr>'+
         '<td style="width: 20%; border: 0.3px solid;" align="Left"><span class="contenido_9px_NB_controlversion">2</span></td>'+
         '<td style="width: 50%; border: 0.3px solid;" align="Left"><span class="contenido_9px_NB_controlversion">Eliminación firmas físicas e integración de la Nota relacionada Firma Electrónica</span></td>'+
         '<td style="width: 30%; border: 0.3px solid;" align="Center"><span class="contenido_9px_NB_controlversion">15 de abril 2021</span></td>'+
        '</tr>'+
          '<tr>'+
          '<td style="width: 20%; border: 0.3px solid;" align="Left"><span class="contenido_9px_NB_controlversion">3</span></td>'+
          '<td style="width: 50%; border: 0.3px solid;" align="Left"><span class="contenido_9px_NB_controlversion">Adición Item 22. Observaciones</span></td>'+
          '<td style="width: 30%; border: 0.3px solid;" align="Center"><span class="contenido_9px_NB_controlversion"></span></td>'+
        '</tr>'+
          '</tbody>'+
          '</table>';
  }
}