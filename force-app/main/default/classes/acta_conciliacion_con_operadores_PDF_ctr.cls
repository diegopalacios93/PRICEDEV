public class acta_conciliacion_con_operadores_PDF_ctr {
	public String idRecord;  
    public String htmlScript				{get; set;} 
    public String urlLogoETB        		{get; set;} 
    public Actas_de_contrato__c objActa		{get; set;} 
    public decimal debitos					{get; set;}
    public decimal creditos					{get; set;}
    public decimal creditoConAjustePeso		{get; set;}
    
    
    public acta_conciliacion_con_operadores_PDF_ctr(ApexPages.StandardController controller){
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
                                 +'Contrato_relacionado__r.Supervisor_Administrativo__r.EmployeeNumber, Contrato_relacionado__r.Supervisor_tecnico__r.EmployeeNumber, Contrato_relacionado__r.Account.Name '
                                 +'FROM Actas_de_contrato__c where Id=:idActa limit 1');       
    }
    
    // :::::::::::::::::::::::::::::::::::::::::: GENERACIÓN DE HTML ::::::::::::::::::::::::::::::::::::::::::::::::::::
    
    public void generar_html_script(){ 
        creditoConAjustePeso = (objActa.Suma_credito__c== null?0:objActa.Suma_credito__c) + (objActa.Diferencia__c== null?0:objActa.Diferencia__c);            
        htmlScript =
        '<table style="width: 100%;" border="0.5" align="center">'+
          '<tr>'+
            '<td colspan="9"><table style="width: 100%;" border="0">'+
              '<tr>'+
                '<td align="left" width="20%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="'+urlLogoETB+'" style="width:30%;height:40%;"/></td>'+
                '<td align="center" width="80%"><span class="contenido_18px">Formato de Conciliaci&oacute;n Con Aliados </span></td>'+
              '</tr>'+
              '<tr>'+
                '<td><strong>Nit 899999115-8 </strong></td>'+
                '<td><div align="right"><span class="contenido_12px_NB"></span></div></td>'+
              '</tr>'+              
            '</table></td>'+
          '</tr>'+
          '<tr>'+
            '<td width="9%" bgcolor="#E5E5E5">'+
            	'<table style="width: 100%;">'+
                     '<tbody>'+
                         '<tr>'+                             
                             '<td align="Left"><span class="contenido_12px">DIA:</span></td>'+
                             '<td align="left">'+procesarFecha(objActa.Fecha_de_acta__c,'DD')+'</td>'+
                         '</tr>'+
                     '</tbody>'+
                '</table>'+
            '</td>'+
            '<td width="9%" bgcolor="#E5E5E5">'+
            	'<table style="width: 100%;">'+
                     '<tbody>'+
                         '<tr>'+                             
                             '<td align="Left"><span class="contenido_12px">Mes:</span></td>'+
                             '<td align="left">'+procesarFecha(objActa.Fecha_de_acta__c,'MM_Name')+'</td>'+
                         '</tr>'+
                     '</tbody>'+
                '</table>'+
            '</td>'+
            '<td width="10%" bgcolor="#E5E5E5">'+
            	'<table style="width: 100%;">'+
                     '<tbody>'+
                         '<tr>'+                             
                             '<td align="Left"><span class="contenido_12px">A&ntilde;o:</span></td>'+
                             '<td align="left">'+procesarFecha(objActa.Fecha_de_acta__c,'AAAA')+'</td>'+
                         '</tr>'+
                     '</tbody>'+
                '</table>'+
            '</td>'+            
            '<td colspan="6" bgcolor="#E5E5E5">'+
            	'<table style="width: 100%;">'+
                     '<tbody>'+
                         '<tr>'+                             
                             '<td align="Left"><span class="contenido_12px">Operador: &nbsp;&nbsp;&nbsp;</span>'+(String.isBlank(objActa.Contrato_relacionado__r.Aliado__r.Name)?'':objActa.Contrato_relacionado__r.Aliado__r.Name)+'</td>'+
                         '</tr>'+
                     '</tbody>'+
                '</table>'+
            '</td>'+ 
          '</tr>'+
          '<tr>'+
            '<td colspan="2" bgcolor="#E5E5E5">'+
            	'<table style="width: 100%;">'+
                     '<tbody>'+
                         '<tr>'+                             
                             '<td align="Left"><span class="contenido_12px">Sociedad:</span></td>'+
                             '<td align="left">PRIVADA</td>'+
                         '</tr>'+
                     '</tbody>'+
                '</table>'+
            '</td>'+ 
            '<td colspan="7" bgcolor="#E5E5E5"><span class="contenido_12px">Nombre del cliente:&nbsp;&nbsp;&nbsp;</span>'+(String.isBlank(objActa.Contrato_relacionado__r.Account.Name)?'':objActa.Contrato_relacionado__r.Account.Name)+            
            '</td>'+            
          '</tr>'+
          '<tr>'+
            '<td colspan="9">'+
            	'<table style="width: 100%;">'+
                     '<tbody>'+
                         '<tr>'+                             
                             '<td colspan="6" align="Center"><span class="contenido_12px">&nbsp;</span></td>'+
                             '<td align="Right"><span class="contenido_12px"></span></td>'+
            				 '<td align="left"><span class="contenido_12px"></span></td>'+
                         '</tr>'+
                     '</tbody>'+
                '</table>'+
            '</td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center" colspan="2" bgcolor="#E5E5E5"><span class="contenido_12px">Codigo acreedor/deudor</span></td>'+
            '<td align="center" bgcolor="#E5E5E5"><span class="contenido_12px">Cuenta contable (PCCO)</span></td>'+
            '<td align="center" bgcolor="#E5E5E5"><span class="contenido_12px">CONTRATO</span></td>'+
            '<td align="center" bgcolor="#E5E5E5"><span class="contenido_12px">DOCUMENTO SAP</span></td>'+
            '<td align="center" bgcolor="#E5E5E5"><span class="contenido_12px">Asignaci&oacute;n</span></td>'+
            '<td align="center" bgcolor="#E5E5E5"><span class="contenido_12px">Centro división</span></td>'+
            '<td align="center" bgcolor="#E5E5E5"><span class="contenido_12px">D&eacute;bito</span></td>'+
            '<td align="center" bgcolor="#E5E5E5"><span class="contenido_12px">Cr&eacute;dito</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center" colspan="2"><span class="contenido_13px_NB">'+(String.isBlank(objActa.Contrato_relacionado__r.Codigo_acreedor_deudor__c)?'':objActa.Contrato_relacionado__r.Codigo_acreedor_deudor__c)+'</span></td>'+
            '<td align="Right" colspan="1"><span class="contenido_13px_NB">31&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;24150818</span></td>'+                        
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">RMCA</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">0,00</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">'+formatearCampoMoneda((objActa.Redondeo_valor_a_transferir__c== null?0:objActa.Redondeo_valor_a_transferir__c))+'</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center" colspan="2"><span class="contenido_13px_NB">'+(String.isBlank(objActa.Contrato_relacionado__r.Codigo_acreedor_deudor__c)?'0':objActa.Contrato_relacionado__r.Codigo_acreedor_deudor__c)+'</span></td>'+
            '<td align="Right"><span class="contenido_13px_NB">40&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;29110392</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">SICO</span></td>'+
            '<td align="center"><span class="contenido_13px_NB"></span></td>'+
            '<td align="center"><span class="contenido_13px_NB"></span></td>'+
            '<td align="center"><span class="contenido_13px_NB">'+formatearCampoMoneda((objActa.Participacion__c== null?0:objActa.Participacion__c))+'</span></td>'+            
            '<td align="center"><span class="contenido_13px_NB">0,00</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center" colspan="2"><span class="contenido_13px_NB">'+(String.isBlank(objActa.Contrato_relacionado__r.Codigo_acreedor_deudor__c)?'':objActa.Contrato_relacionado__r.Codigo_acreedor_deudor__c)+'</span></td>'+
            '<td align="Right"><span class="contenido_13px_NB">40&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;29110208</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">IVA</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">'+formatearCampoMoneda((objActa.Devolucion_IVA__c== null?0:objActa.Devolucion_IVA__c))+'</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">0,0</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center" colspan="2"><span class="contenido_13px_NB"></span></td>'+
            '<td align="Right"><span class="contenido_13px_NB">50&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;24171251</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">RTE IVA</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">0,00</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">'+formatearCampoMoneda((objActa.Retencion_IVA__c== null?0:objActa.Retencion_IVA__c))+'</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center" colspan="2"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="Right"><span class="contenido_13px_NB">50&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;24171051</span></td>'+
            '<td align="center"><span class="contenido_12px_NB">RTE FUENTE</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_13px_NB"></span></td>'+
            '<td align="center"><span class="contenido_13px_NB">0,00</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">'+formatearCampoMoneda((objActa.Retefuente__c== null?0:objActa.Retefuente__c))+'</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center" colspan="2"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="Right"><span class="contenido_13px_NB">50&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;24173113</span></td>'+
            '<td align="center"><span class="contenido_12px_NB">4X1000</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">'+(String.isBlank(objActa.Contrato_relacionado__r.NIT_Aliado__c)?'':objActa.Contrato_relacionado__r.NIT_Aliado__c)+'</span></td>'+
            '<td align="center"><span class="contenido_13px_NB"></span></td>'+
            '<td align="center"><span class="contenido_13px_NB">0,00</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">'+formatearCampoMoneda((objActa.x4x1000_Calculado__c== null?0:objActa.x4x1000_Calculado__c))+'</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center" colspan="2"><span class="contenido_13px_NB"></span></td>'+
            '<td align="Right"><span class="contenido_13px_NB">50&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;24172011</span></td>'+
            '<td align="center"><span class="contenido_12px_NB">RTE ICA</span></td>'+
            '<td align="center"><span class="contenido_13px_NB"></span></td>'+
            '<td align="center"><span class="contenido_13px_NB">'+(String.isBlank(objActa.Contrato_relacionado__r.NIT_Aliado__c)?'':objActa.Contrato_relacionado__r.NIT_Aliado__c)+'</span></td>'+
            '<td align="center"><span class="contenido_13px_NB"></span></td>'+
            '<td align="center"><span class="contenido_13px_NB">0,00</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">'+formatearCampoMoneda((objActa.Reteica__c== null?0:objActa.Reteica__c))+'</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center" colspan="2"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="Right"><span class="contenido_13px_NB">40&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;48219001</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">L@001</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">'+(String.isBlank(objActa.Contrato_relacionado__r.NIT_Aliado__c)?'':objActa.Contrato_relacionado__r.NIT_Aliado__c)+'</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">YL001</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">0,00</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">0,00</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center" colspan="2"><span class="contenido_13px_NB">Ajuste al peso</span></td>'+
            '<td align="Right"><span class="contenido_13px_NB">40&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;48219001</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">L@001</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">LOC</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">0,00</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">'+formatearCampoMoneda((objActa.Diferencia__c== null?0:objActa.Diferencia__c))+'</span></td>'+
          '</tr>'+           
            '<td align="Right" colspan="7">'+
              '<span class="contenido_13px">SUMAS IGUALES&nbsp;&nbsp;&nbsp;</span>'+
             '</td>'+
            '<td align="center"><span class="contenido_13px">'+formatearCampoMoneda((objActa.Suma_debito__c== null?0:objActa.Suma_debito__c))+'</span></td>'+
            '<td align="center"><span class="contenido_13px">'+formatearCampoMoneda(creditoConAjustePeso)+'</span></td>'+
          '</tr>'+          
          '<tr>'+
            '<td align="Left" colspan="3"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="Right" colspan="4"></td>'+
            '<td align="Right"><span class="contenido_13px_NB">Recibido AP :</span></td>'+
            '<td align="Right"></td>'+
          '</tr>'+
           '<tr>'+
            '<td colspan="9">'+
            	'<table style="width: 100%;">'+
                     '<tbody>'+
                         '<tr>'+                             
                             '<td align="left"><span class="contenido_12px_NB">FECHA DE VENCIMIENTO:</span></td>'+
                             '<td align="left"><span class="contenido_12px_NB">&nbsp;'+procesarFecha(objActa.Fecha_de_acta__c,'MM_Name')+' '+objActa.Dia_de_transferencia__c+' de '+procesarFecha(objActa.Fecha_de_acta__c,'AAAA')+'</span></td>'+
            				 '<td align="left"><span class="contenido_12px_NB">VICEPRESIDENCIA No. 26</span></td>'+
            				 '<td align="left"><span class="contenido_12px_NB">0,00</span></td>'+
                         '</tr>'+
            			 '<tr>'+                             
                             '<td align="left"><span class="contenido_12px_NB">CONCEPTO:</span></td>'+
                             '<td align="left"><span class="contenido_12px_NB">&nbsp;Conciliación Acta No.'+(String.isBlank(objActa.Acta_No__c)?'':objActa.Acta_No__c)+'</span></td>'+
            				 '<td align="left"><span class="contenido_12px_NB"></span></td>'+
            				 '<td align="left"><span class="contenido_12px_NB"></span></td>'+
                         '</tr>'+
            			 '<tr colspan="9"><td>&nbsp;</td></tr>'+
            			 '<tr>'+                             
                             '<td align="left"><span class="contenido_12px_NB">AUTORIZADO POR: </span></td>'+                             
            				 '<td align="left"><span class="contenido_12px_NB">'+
            				 '<table style="width: 100%;">'+
                                '<tr>'+
                                '<td align="Left"><span class="contenido_12px">'+((String.isBlank(objActa.Contrato_relacionado__r.Supervisor_Administrativo__r.Name)?'':objActa.Contrato_relacionado__r.Supervisor_Administrativo__r.Name)).toUpperCase()+'</span></td>'+
                                '</tr>'+
                                '<tr>'+
                                '<td align="Left"><span class="contenido_12px">SUPERVISOR DE CONTRATO</span></td>'+
                                '</tr>'+
                                '<tr>'+
                                '<td align="Left"><span class="contenido_12px">ETB '+(String.isBlank(objActa.Contrato_relacionado__r.Supervisor_Administrativo__r.EmployeeNumber)?'':objActa.Contrato_relacionado__r.Supervisor_Administrativo__r.EmployeeNumber)+'</span></td>'+
                                '</tr>'+
                                '</table>'+
            				 '</span></td>'+
            				 '<td align="left"><span class="contenido_12px_NB"></span></td>'+
            				 '<td align="left"><span class="contenido_12px_NB"></span></td>'+
                         '</tr>'+
                     '</tbody>'+
                '</table>'+
            '</td>'+
          '</tr>'+
        '</table>';
    }    
}