public class Acta_de_conciliacion_con_aliados_PDF_ctr {
	public String idRecord;  
    public String htmlScript				{get; set;} 
    public String urlLogoETB        		{get; set;} 
    public Actas_de_contrato__c objActa		{get; set;} 
    public decimal debitos					{get; set;}
    public decimal creditos					{get; set;}
    public decimal creditoConAjustePeso		{get; set;}
    
    
    public Acta_de_conciliacion_con_aliados_PDF_ctr(ApexPages.StandardController controller){
        idRecord = ApexPages.currentPage().getParameters().get('id');        
        procesarURLFile();
        consultarActa(idRecord);
        calcularDebitosCreditos();
        generar_html_script();
    }
    
    public void procesarURLFile(){          
        string idLogo_ETB;
        List<Document> lstDoc;       
        lstDoc = [Select Id from Document where DeveloperName = 'Logo_ETB' limit 1];        
        if(lstDoc.size() > 0)
            idLogo_ETB = lstDoc[0].Id;        
         
        urlLogoETB = '/servlet/servlet.FileDownload?file='+idLogo_ETB;            
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
    
    public void calcularDebitosCreditos(){
        debitos  = 0;
        creditos = 0;
        debitos  = (objActa.Participacion__c== null?0:objActa.Participacion__c) + (objActa.Devolucion_IVA__c== null?0:objActa.Devolucion_IVA__c);
        creditos = (objActa.Valor_a_transferir__c== null?0:objActa.Valor_a_transferir__c) + (objActa.Reteica__c== null?0:objActa.Reteica__c) + (objActa.x4x1000_Calculado__c== null?0:objActa.x4x1000_Calculado__c) + (objActa.Retefuente__c== null?0:objActa.Retefuente__c) + (objActa.Diferencia__c== null?0:objActa.Diferencia__c) + (objActa.Retencion_IVA__c== null?0:objActa.Retencion_IVA__c);
    }
    
    // :::::::::::::::::::::::::::::::::::::::::: CONSULTA DE DATOS  ::::::::::::::::::::::::::::::::::::::::::::::::::::
    
    public void consultarActa(String idActa){
        objActa = Database.query('Select Name, Fecha_de_acta__c, Acta_No__c, Periodo_a_conciliar_Desde__c, Participacion__c, '
                                 +'Periodo_a_conciliar_Hasta__c, Codigo_ETB__c, Fecha_de_acta_costo_administrativo__c, '
                                 +'Contrato_relacionado__r.Codigo_acreedor_deudor__c, Dia_de_transferencia__c, Contrato_relacionado__c, Mes_de_consumo__c, '
                                 +'Devolucion_IVA__c, x4x1000_Calculado__c, Retefuente__c, Valor_a_transferir__c, Reteica__c, '
                                 +'Redondeo_valor_a_transferir__c, Base_mas_IVA__c, Suma_debito__c, Retenciones__c, Suma_credito__c, '
                                 +'Base_mas_IVA_menos_retenciones__c, Diferencia__c, Contrato_relacionado__r.Param_Anexo_IVA__c, Param_Anexo_4x1000__c, '
                                 +'Contrato_relacionado__r.Param_Anexo_Retefuente__c, Param_Anexo_4x1000_Div__c, Contrato_relacionado__r.Param_Anexo_Reteica__c, Representante_del_aliado__c, '
                                 +'Contrato_relacionado__r.Aliado__r.Name, Contrato_relacionado__r.Supervisor_Administrativo__c, Contrato_relacionado__r.Supervisor_Administrativo__r.Name, '
                                 +'Contrato_relacionado__r.NIT_Aliado__c, Contrato_relacionado__r.Param_Retencion_IVA__c, Retencion_IVA__c, Contrato_relacionado__r.Aliado__r.AccountNumber, '
                                 +'Contrato_relacionado__r.Supervisor_Administrativo__r.EmployeeNumber, Contrato_relacionado__r.Supervisor_tecnico__r.EmployeeNumber, Contrato_relacionado__r.Account.Name, '
                                 +'Contrato_relacionado__r.Anexo__c, Contrato_relacionado__r.Cuenta_revchain__c, Firma_digital__c '
                                 +'FROM Actas_de_contrato__c where Id=:idActa limit 1');       
    }
    
    // :::::::::::::::::::::::::::::::::::::::::: GENERACIÓN DE HTML ::::::::::::::::::::::::::::::::::::::::::::::::::::
    
    public void generar_html_script(){ 
        creditoConAjustePeso = (objActa.Suma_credito__c== null?0:objActa.Suma_credito__c) + (objActa.Diferencia__c== null?0:objActa.Diferencia__c);            
        htmlScript =
        '<table style="width: 100%;" border="0.2" align="center">'+
          '<tr>'+
            '<td colspan="2">'+
            	'<table style="width: 100%;" border="0">'+
              		'<tr>'+
                        '<td align="left" width="32%">&nbsp;<img src="'+urlLogoETB+'" style="width:13%;height:18%;"/></td>'+
                        '<td align="left" width="68%"><span class="contenido_15px_TNR">FORMATO DE CONCILIACIÓN CON ALIADOS </span></td>'+
                    '</tr>'+                    
            	'</table>'+
            '</td>'+
          '</tr>'+ 
          '<tr>'+
            '<td bgcolor="#E5E5E5" width="50%" align="center"><span class="contenido_10px">1. FECHA DE CONCILIACIÓN: '+procesarFecha(objActa.Fecha_de_acta__c,'DD')+' DE '+procesarFecha(objActa.Fecha_de_acta__c,'MM_Name'). toUpperCase()+' DE '+procesarFecha(objActa.Fecha_de_acta__c,'AAAA')+'</span></td>'+
            '<td bgcolor="#E5E5E5" width="50%" align="center"><span class="contenido_10px">2. ACTA No: '+(String.isBlank(objActa.Acta_No__c)?'':objActa.Acta_No__c)+'</span></td>'+
          '</tr>'+ 
          '<tr>'+
            '<td width="50%" align="center"><span class="contenido_10px">3. ALIADO: '+(String.isBlank(objActa.Contrato_relacionado__r.Aliado__r.Name)?'':objActa.Contrato_relacionado__r.Aliado__r.Name)+'</span></td>'+
            '<td width="50%" align="center"><span class="contenido_10px">4. Nit: '+(String.isBlank(objActa.Contrato_relacionado__r.Aliado__r.AccountNumber)?'':objActa.Contrato_relacionado__r.Aliado__r.AccountNumber)+'</span></td>'+
          '</tr>'+ 
          '<tr>'+
            '<td width="50%" align="center"><span class="contenido_10px">5. CLIENTE: '+(String.isBlank(objActa.Contrato_relacionado__r.Account.Name)?'':objActa.Contrato_relacionado__r.Account.Name)+'</span></td>'+
            '<td width="50%" align="center"><span class="contenido_10px">6. CONTRATO: '+(String.isBlank(objActa.Contrato_relacionado__r.Anexo__c)?'':objActa.Contrato_relacionado__r.Anexo__c)+'</span></td>'+
          '</tr>'+ 
        '</table>'+
         //bloque
        '<table style="width: 100%;" border="0.2" align="center">'+
         '<tr>'+
            '<td bgcolor="#E5E5E5" width="25%" align="center"><span class="contenido_10px">7. CUENTA REVCHAIN</span></td>'+
            '<td bgcolor="#E5E5E5" width="30%" align="center"><span class="contenido_10px">8. PERIODO A CONCILIAR</span></td>'+
            '<td bgcolor="#E5E5E5" width="45%" align="center"><span class="contenido_10px">9. PARTICIPACIÓN DEL ALIADO</span></td>'+
         '</tr>'+
         '<tr>'+
            '<td width="25%" align="center"><span class="contenido_10px_NB">'+(String.isBlank(objActa.Contrato_relacionado__r.Cuenta_revchain__c) || objActa.Contrato_relacionado__r.Cuenta_revchain__c == 'Pendiente'?'':objActa.Contrato_relacionado__r.Cuenta_revchain__c)+'</span></td>'+
            '<td width="30%" align="center"><span class="contenido_10px_NB">Del '+procesarFecha(objActa.Periodo_a_conciliar_Desde__c,'DD')+' de '+procesarFecha(objActa.Periodo_a_conciliar_Desde__c,'MM_Name')+' al '+procesarFecha(objActa.Periodo_a_conciliar_Hasta__c,'DD')+' de '+procesarFecha(objActa.Periodo_a_conciliar_Hasta__c,'MM_Name')+' de '+procesarFecha(objActa.Periodo_a_conciliar_Hasta__c,'AAAA')+'</span></td>'+
            '<td width="45%" align="center"><span class="contenido_10px_NB">$'+formatearCampoMoneda((objActa.Participacion__c== null?0:objActa.Participacion__c))+'</span></td>'+
         '</tr>'+          
         '<tr>'+
            '<td bgcolor="#E5E5E5" width="55%" colspan="2" width="25%" align="center"><span class="contenido_10px">10. TOTAL, PARTICIPACION '+(String.isBlank(objActa.Contrato_relacionado__r.Aliado__r.Name)?'':objActa.Contrato_relacionado__r.Aliado__r.Name).toUpperCase()+'</span></td>'+
            '<td bgcolor="#E5E5E5" width="45%" align="center"><span class="contenido_10px">$ '+formatearCampoMoneda((objActa.Participacion__c== null?0:objActa.Participacion__c))+'</span></td>'+
         '</tr>'+
        '</table>'+
        '<table style="width: 100%;" border="0.2" align="center">'+
           '<tr>'+
            '<td align="center" colspan="2" bgcolor="#E5E5E5" width="10%"><span class="contenido_10px">11. Codigo acreedor/deudor</span></td>'+
            '<td align="center" colspan="3" bgcolor="#E5E5E5" width="15%"><span class="contenido_10px">12. Cuenta contable (PCCO)</span></td>'+
            '<td align="center" bgcolor="#E5E5E5" width="12%"><span class="contenido_10px">13. Contrato</span></td>'+
            '<td align="center" bgcolor="#E5E5E5" width="8%"><span class="contenido_10px">14. Unidades</span></td>'+
            '<td align="center" bgcolor="#E5E5E5" width="10%"><span class="contenido_10px">15. Documento SAP</span></td>'+
            '<td align="center" bgcolor="#E5E5E5" width="10%"><span class="contenido_10px">16. Asignación</span></td>'+
            '<td align="center" bgcolor="#E5E5E5" width="8%"><span class="contenido_10px">17. Centro división</span></td>'+
            '<td align="center" bgcolor="#E5E5E5"><span class="contenido_10px">18. Débito</span></td>'+
            '<td align="center" bgcolor="#E5E5E5"><span class="contenido_10px">19. Crédito</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center" colspan="2"><span class="contenido_11px_NB" width="10%">'+(String.isBlank(objActa.Contrato_relacionado__r.Codigo_acreedor_deudor__c)?'':objActa.Contrato_relacionado__r.Codigo_acreedor_deudor__c)+'</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">31</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">&nbsp;|&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">24150818</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB">RMCA</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">0,00</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">'+formatearCampoMoneda((objActa.Redondeo_valor_a_transferir__c== null?0:objActa.Redondeo_valor_a_transferir__c))+'</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center" colspan="2"><span class="contenido_11px_NB" width="10%">'+(String.isBlank(objActa.Contrato_relacionado__r.Codigo_acreedor_deudor__c)?'0':objActa.Contrato_relacionado__r.Codigo_acreedor_deudor__c)+'</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">40</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">&nbsp;|&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">29110392</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB">SICO</span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB">'+formatearCampoMoneda((objActa.Participacion__c== null?0:objActa.Participacion__c))+'</span></td>'+            
            '<td align="center"><span class="contenido_11px_NB">0,00</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center" colspan="2"><span class="contenido_11px_NB" width="10%">'+(String.isBlank(objActa.Contrato_relacionado__r.Codigo_acreedor_deudor__c)?'':objActa.Contrato_relacionado__r.Codigo_acreedor_deudor__c)+'</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">40</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">&nbsp;|&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">29110208</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">IVA</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">19%</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">'+formatearCampoMoneda((objActa.Devolucion_IVA__c== null?0:objActa.Devolucion_IVA__c))+'</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">0,0</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center" colspan="2"><span class="contenido_11px_NB" width="10%"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB">50</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">&nbsp;|&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">24171251</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">RTE IVA</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">0.00 %</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">0,00</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">'+formatearCampoMoneda((objActa.Retencion_IVA__c== null?0:objActa.Retencion_IVA__c))+'</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center" colspan="2"><span class="contenido_11px_NB" width="10%">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">50</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">&nbsp;|&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">24171051</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">RTE FUENTE</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">11%</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB">0,00</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">'+formatearCampoMoneda((objActa.Retefuente__c== null?0:objActa.Retefuente__c))+'</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center" colspan="2"><span class="contenido_11px_NB" width="10%">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">50</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">&nbsp;|&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">24173113</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">4X1000</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">4X1000</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">'+(String.isBlank(objActa.Contrato_relacionado__r.NIT_Aliado__c)?'':objActa.Contrato_relacionado__r.NIT_Aliado__c)+'</span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB">0,00</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">'+formatearCampoMoneda((objActa.x4x1000_Calculado__c== null?0:objActa.x4x1000_Calculado__c))+'</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center" colspan="2"><span class="contenido_11px_NB" width="10%"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB">50</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">&nbsp;|&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">24172011</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">RTE ICA</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">0.69000</span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB">'+(String.isBlank(objActa.Contrato_relacionado__r.NIT_Aliado__c)?'':objActa.Contrato_relacionado__r.NIT_Aliado__c)+'</span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB">0,00</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">'+formatearCampoMoneda((objActa.Reteica__c== null?0:objActa.Reteica__c))+'</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center" colspan="2"><span class="contenido_11px_NB" width="10%">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB">RTE ICA * Localidad</span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center" colspan="2"><span class="contenido_11px_NB" width="10%"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB">40</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">&nbsp;|&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">48219001</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">L@001</span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB">'+(String.isBlank(objActa.Contrato_relacionado__r.NIT_Aliado__c)?'':objActa.Contrato_relacionado__r.NIT_Aliado__c)+'</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">YL001</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">0,00</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">'+formatearCampoMoneda((objActa.Diferencia__c== null?0:objActa.Diferencia__c))+'</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center" colspan="2"><span class="contenido_11px_NB" width="10%">Ajuste al peso</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">40</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">&nbsp;|&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">48219001</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_11px_NB"></span></td>'+
            '<td align="center"><span class="contenido_11px_NB">L@001</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">LOC</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">0,00</span></td>'+
            '<td align="center"><span class="contenido_11px_NB">'+formatearCampoMoneda((objActa.Diferencia__c== null?0:objActa.Diferencia__c))+'</span></td>'+
          '</tr>'+
            '<td align="center" colspan="10"><span class="contenido_11px">20.SUMAS IGUALES</span></td>'+
            '<td align="center"><span class="contenido_11px">'+formatearCampoMoneda((objActa.Suma_debito__c== null?0:objActa.Suma_debito__c))+'</span></td>'+
            '<td align="center"><span class="contenido_11px">'+formatearCampoMoneda(creditoConAjustePeso)+'</span></td>'+
          '</tr>'+          
          '<tr>'+
            '<td align="center" colspan="10"><span class="contenido_10px"></span></td>'+
            '<td align="center"><span class="contenido_10px_NB">Recibido AP :</span></td>'+
            '<td align="Right"></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="Left" colspan="5"><span class="contenido_10px">&nbsp;21. FECHA DE TRANSFERECIA: </span></td>'+
            '<td align="Left" colspan="2"><span class="contenido_10px_NB">&nbsp;'+procesarFecha(objActa.Fecha_de_acta__c,'MM_Name')+' '+objActa.Dia_de_transferencia__c+' de '+procesarFecha(objActa.Fecha_de_acta__c,'AAAA')+'</span></td>'+
            '<td align="Right" colspan="3"><span class="contenido_10px">22. VICEPRESIDENCIA No. 26&nbsp;</span></td>'+
            '<td align="Right" colspan="2"><span class="contenido_10px_NB">0</span></td>'+            
          '</tr>'+
          '<tr>'+
            '<td align="Left" colspan="5"><span class="contenido_10px">&nbsp;23. CONCEPTO: </span></td>'+
            '<td align="Left" colspan="7"><span class="contenido_10px_NB">&nbsp;Conciliación Acta No.232-S</span></td>'+            
          '</tr>'+
           '<tr>'+
            '<td colspan="12">'+
            	'<table style="width: 100%;" border="0">';
        		if(objActa.Firma_digital__c){
                    htmlScript +=
            		'<tr>'+
            			'<td align="Left" width="15%"><span class="contenido_11px"></td>'+
            			'<td align="center" width="30%"><span class="contenido_11px"><span class="contenido_55px">{{</span><span class="contenido_9px_TNR">Sig_es_:signer2:signature</span><span class="contenido_55px">}}</span></td>'+
            			'<td align="center" width="52%"><span class="contenido_11px"><span class="contenido_55px">{{</span><span class="contenido_9px_TNR">Sig_es_:signer1:signature</span><span class="contenido_55px">}}</span></td>'+
            		'</tr>';
                }else{
                    htmlScript +=
            		'<tr>'+
            			'<td align="Left" width="15%"><span class="contenido_10px"></td>'+
            			'<td align="center" width="30%"><span class="contenido_10px"><br><br><br>_________________________________________</span></td>'+
            			'<td align="center" width="51%"><span class="contenido_10px"><br><br><br>_________________________________________</span></td>'+
            		'</tr>';
                }
            		htmlScript +=
                    '<tr>'+
            			'<td align="Left" width="15%"><span class="contenido_11px">24. AUTORIZADO POR:</td>'+
            			'<td align="center" width="30%"><span class="contenido_11px">'+((String.isBlank(objActa.Contrato_relacionado__r.Supervisor_Administrativo__r.Name)?'':objActa.Contrato_relacionado__r.Supervisor_Administrativo__r.Name)).toUpperCase()+'</td>'+
            			'<td align="center" width="52%"><span class="contenido_11px">'+((String.isBlank(objActa.Representante_del_aliado__c)?'':objActa.Representante_del_aliado__c)).toUpperCase()+'</td>'+
            		'</tr>'+
            		'<tr>'+
            			'<td align="center" width="15%"><span class="contenido_11px"></td>'+
            			'<td align="center" width="30%"><span class="contenido_11px">SUPERVISOR DE CONTRATO</td>'+
            			'<td align="center" width="52%"><span class="contenido_11px">REPRESENTANTE LEGAL</td>'+
            		'</tr>'+
            		'<tr>'+
            			'<td align="center" width="15%"><span class="contenido_11px"></td>'+
            			'<td align="center" width="30%"><span class="contenido_11px">ETB '+(String.isBlank(objActa.Contrato_relacionado__r.Supervisor_Administrativo__r.EmployeeNumber)?'':objActa.Contrato_relacionado__r.Supervisor_Administrativo__r.EmployeeNumber)+'</td>'+
            			'<td align="center" width="52%"><span class="contenido_11px">'+((String.isBlank(objActa.Contrato_relacionado__r.Aliado__r.Name)?'':objActa.Contrato_relacionado__r.Aliado__r.Name)).toUpperCase()+'</td>'+
            		'</tr>'+
            	'</table>'+
            '</td>'+
          '</tr>'+
        '</table>';        
    }    
}