public class acta_costo_administrativo_PDF_ctr {
	public String idRecord;  
    public String htmlScript				{get; set;} 
    public String urlLogoETB        		{get; set;} 
    public Actas_de_contrato__c objActa		{get; set;} 
    
    public acta_costo_administrativo_PDF_ctr(ApexPages.StandardController controller){
        idRecord = ApexPages.currentPage().getParameters().get('id');        
        procesarURLFile();
        consultarActa(idRecord);
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
           /* else if (DMY == 'MM_Name')
            	return obtenerNombreMes(String.valueOf(fecha.month()));*/
            else if (DMY == 'AAAA')
            	return String.valueOf(fecha.year());
            else
                return '';
        }else
            return '';    
    }
    
   /* public string obtenerNombreMes(string numeroMes){
        if(numeroMes == '1')
            return 'Enero';
		else if(numeroMes == '2')
            return 'Febrero';
        else if(numeroMes == '3')
            return 'Marza';
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
    }*/
    
    public string formatearCampoMoneda(Decimal valor){
        List<String> args = new String[]{'0','number','###,###,##0.00'};
        if(valor == null)            
        	return String.format('0', args);		
        else
            return String.format(valor.format(), args);		
    }
    
    // :::::::::::::::::::::::::::::::::::::::::: CONSULTA DE DATOS  ::::::::::::::::::::::::::::::::::::::::::::::::::::
    public void consultarActa(String idActa){
        objActa = Database.query('Select Name, Fecha_de_acta__c, Acta_No__c, Periodo_a_conciliar_Desde__c, Participacion__c, Param_Anexo_IVA__c, '
                                 +'Periodo_a_conciliar_Hasta__c, Codigo_ETB__c, Fecha_de_acta_costo_administrativo__c, '
                                 +'Contrato_relacionado__r.Codigo_acreedor_deudor__c, Dia_de_transferencia__c, Contrato_relacionado__c, Mes_de_consumo__c, '
                                 +'Devolucion_IVA__c, x4x1000_Calculado__c, Retefuente__c, Valor_a_transferir__c, Reteica__c, '
                                 +'Redondeo_valor_a_transferir__c, Base_mas_IVA__c, Suma_debito__c, Retenciones__c, Suma_credito__c, '
                                 +'Base_mas_IVA_menos_retenciones__c, Diferencia__c, Contrato_relacionado__r.Param_Anexo_IVA__c, Param_Anexo_4x1000__c, '
                                 +'Contrato_relacionado__r.Param_Anexo_Retefuente__c, Param_Anexo_4x1000_Div__c, Contrato_relacionado__r.Param_Anexo_Reteica__c, Representante_del_aliado__c, '
                                 +'Contrato_relacionado__r.Aliado__r.Name, Contrato_relacionado__r.Supervisor_Administrativo__r.Name, Contrato_relacionado__r.Account.Name, '
                                 +'Contrato_relacionado__r.NIT_Aliado__c, Contrato_relacionado__r.Anexo__c, Contrato_relacionado__r.Param_Retencion_IVA__c, Retencion_IVA__c, '
                                 +'Contrato_relacionado__r.Supervisor_Administrativo__r.EmployeeNumber, Cargo_del_representante_legal__c '
                                 +'FROM Actas_de_contrato__c where Id=:idActa limit 1');       
    }
    
    // :::::::::::::::::::::::::::::::::::::::::: GENERACIÓN DE HTML ::::::::::::::::::::::::::::::::::::::::::::::::::::
    
    public void generar_html_script(){        
        htmlScript =
        '<table style="width: 100%;" border="0.5" align="center">'+
          '<tr>'+
            '<td style="width: 20%;" align="center"><img src="'+urlLogoETB+'" style="width:65%;height:75%;"/></td>'+
            '<td style="width: 80%;" colspan="5" bgcolor="#E5E5E5"></td>'+
          '</tr>'+
          '<tr>'+
            '<td colspan="6" bgcolor="#E5E5E5"><div align="center"><span class="contenido_13px">COSTOS ADMINISTRATIVOS Y DE INTERCONEXION </span></div></td>'+
          '</tr>'+
          '<tr>'+
            '<td colspan="3">'+
            	'<table style="width: 100%;">'+
                     '<tbody>'+
                         '<tr>'+
                             '<td align="Center"><span class="contenido_13px_NB">Nit.</span></td>'+                     
                             '<td align="left"><span class="contenido_13px_NB">899999115-8</span></td>'+                             
                         '</tr>'+
                     '</tbody>'+
                '</table>'+
            '</td>'+
            '<td colspan="3">'+
            	'<table style="width: 100%;">'+
                     '<tbody>'+
                         '<tr>'+
                             '<td align="Left"><span class="contenido_13px_NB">Fecha de conciliación:&nbsp;&nbsp;&nbsp;'+procesarFecha(date.today(),'DD')+'/'+procesarFecha(date.today(),'MM')+'/'+procesarFecha(date.today(),'AAAA')+'</span></td>'+
                         '</tr>'+
                     '</tbody>'+
                '</table>'+
            '</td>'+
          '</tr>'+            
          '<tr>'+
            '<td colspan="3">'+
            	'<table style="width: 100%;">'+
                     '<tbody>'+
                         '<tr>'+
                             '<td align="Left"><span class="contenido_13px">ALIADO: </span></td>'+                     
                             '<td align="left"><span class="contenido_13px">'+(String.isBlank(objActa.Contrato_relacionado__r.Aliado__r.Name)?'':objActa.Contrato_relacionado__r.Aliado__r.Name)+'</span></td>'+                             
                         '</tr>'+
                     '</tbody>'+
                '</table>'+
            '</td>'+
            '<td colspan="3">'+
            	'<table style="width: 100%;">'+
                     '<tbody>'+
                         '<tr>'+
                             '<td align="Left"><span class="contenido_13px">Nit:&nbsp;&nbsp;&nbsp;'+(String.isBlank(objActa.Contrato_relacionado__r.NIT_Aliado__c)?'':objActa.Contrato_relacionado__r.NIT_Aliado__c)+'</span></td>'+            
                         '</tr>'+
                     '</tbody>'+
                '</table>'+
            '</td>'+
          '</tr>'+
          '<tr>'+
            '<td colspan="3">'+
            	'<table style="width: 100%;">'+
                     '<tbody>'+
                         '<tr>'+
                             '<td align="Left"><span class="contenido_13px_NB">CLIENTE:</span></td>'+                     
                             '<td align="left"><span class="contenido_13px_NB">'+(String.isBlank(objActa.Contrato_relacionado__r.Account.Name)?'':objActa.Contrato_relacionado__r.Account.Name)+'</span></td>'+                             
                         '</tr>'+
                     '</tbody>'+
                '</table>'+
            '</td>'+
            '<td colspan="3">'+
            	'<table style="width: 100%;">'+
                     '<tbody>'+
                         '<tr>'+
                             '<td align="Left"><span class="contenido_13px_NB">CONTRATO:</span></td>'+                     
                             '<td align="left"><span class="contenido_13px_NB">'+(String.isBlank(objActa.Contrato_relacionado__r.Anexo__c)?'':objActa.Contrato_relacionado__r.Anexo__c)+'</span></td>'+                             
                         '</tr>'+
                     '</tbody>'+
                '</table>'+
            '</td>'+
          '</tr>'+
          '<tr>'+
            '<td width="278" bgcolor="#E5E5E5"><span class="contenido_13px_NB">PERIODO A CONCILIAR:</span></td>'+
            '<td width="154" bgcolor="#E5E5E5"><div align="center"><span class="contenido_13px_NB"></span></div></td>'+
            '<td width="113" bgcolor="#E5E5E5"><div align="center"><span class="contenido_13px_NB">Consumo(s)</span></div></td>'+
            '<td width="160" bgcolor="#E5E5E5"><div align="center"><span class="contenido_13px_NB">'+procesarFecha(objActa.Periodo_a_conciliar_Desde__c,'DD')+'/'+procesarFecha(objActa.Periodo_a_conciliar_Desde__c,'MM')+'/'+procesarFecha(objActa.Periodo_a_conciliar_Desde__c,'AAAA')+'</span></div></td>'+
            '<td width="160" bgcolor="#E5E5E5"><div align="center"><span class="contenido_13px_NB">al</span></div></td>'+
            '<td width="160" bgcolor="#E5E5E5"><div align="center"><span class="contenido_13px_NB">'+procesarFecha(objActa.Periodo_a_conciliar_Hasta__c,'DD')+'/'+procesarFecha(objActa.Periodo_a_conciliar_Hasta__c,'MM')+'/'+procesarFecha(objActa.Periodo_a_conciliar_Hasta__c,'AAAA')+'</span></div></td>'+
          '</tr>'+
          '<tr>'+
            '<td colspan="6">'+
            	'<table style="width: 100%;">'+
                     '<tbody>'+
                         '<tr>'+                             
                             '<td align="left"><span class="contenido_13px_NB">Acta No: '+objActa.Acta_No__c+'</span></td>'+
                             '<td align="left"><span class="contenido_13px_NB"></span></td>'+
                         '</tr>'+
                     '</tbody>'+
                '</table>'+
            '</td>'+
          '</tr>'+          
          '<tr>'+
            '<td bgcolor="#E5E5E5"><div align="center"><span class="contenido_13px">Descripción </span></div></td>'+
            '<td bgcolor="#E5E5E5"><div align="center"><span class="contenido_13px">Detalle</span></div></td>'+
            '<td bgcolor="#E5E5E5"><div align="center"><span class="contenido_13px"></span></div></td>'+
            '<td bgcolor="#E5E5E5"><div align="center"><span class="contenido_13px">Valor Und </span></div></td>'+
            '<td bgcolor="#E5E5E5"><div align="center"><span class="contenido_13px">Valor</span></div></td>'+
            '<td bgcolor="#E5E5E5"><div align="center"><span class="contenido_13px">Valor</span></div></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center"><span class="contenido_13px_NB">TOTAL RECAUDO A TRANSFERIR</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_13px_NB"><span class="contenido_13px_NB"></span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">$ '+formatearCampoMoneda((objActa.Participacion__c== null?0:objActa.Participacion__c))+'</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center"><span class="contenido_13px_NB">Devolución IVA sobre Recaudo</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_13px_NB"><span class="contenido_13px_NB"></span></td>'+
            '<td align="center"><span class="contenido_13px_NB">'+(objActa.Param_Anexo_IVA__c==null?0:objActa.Param_Anexo_IVA__c)+'%</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">$ '+formatearCampoMoneda((objActa.Devolucion_IVA__c== null?0:objActa.Devolucion_IVA__c))+'</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center"><span class="contenido_13px_NB">Retefuente</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_13px_NB"><span class="contenido_13px_NB"></span></td>'+
            '<td align="center"><span class="contenido_13px_NB">'+formatearCampoMoneda((objActa.Contrato_relacionado__r.Param_Anexo_Retefuente__c== null?0:objActa.Contrato_relacionado__r.Param_Anexo_Retefuente__c))+'%</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">$ '+formatearCampoMoneda((objActa.Retefuente__c== null?0:objActa.Retefuente__c))+'</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center"><span class="contenido_13px_NB">Retención ICA</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_13px_NB"><span class="contenido_13px_NB"></span></td>'+
            '<td align="center"><span class="contenido_13px_NB">'+(objActa.Contrato_relacionado__r.Param_Anexo_Reteica__c== null?0:objActa.Contrato_relacionado__r.Param_Anexo_Reteica__c)+'</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">$ '+formatearCampoMoneda((objActa.Reteica__c== null?0:objActa.Reteica__c))+'</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center"><span class="contenido_13px_NB">Retención de IVA</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_13px_NB"><span class="contenido_13px_NB"></span></td>'+
            '<td align="center"><span class="contenido_13px_NB">'+(objActa.Contrato_relacionado__r.Param_Retencion_IVA__c== null?0:objActa.Contrato_relacionado__r.Param_Retencion_IVA__c)+' %</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">$ '+formatearCampoMoneda((objActa.Retencion_IVA__c== null?0:objActa.Retencion_IVA__c))+'</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center"><span class="contenido_13px_NB">Valor Base + IVA</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_13px_NB"><span class="contenido_13px_NB"></span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">$ '+formatearCampoMoneda((objActa.Base_mas_IVA__c== null?0:objActa.Base_mas_IVA__c))+'</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center"><span class="contenido_13px_NB">Valor Retenciones</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_13px_NB"><span class="contenido_13px_NB"></span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">$ '+formatearCampoMoneda((objActa.Retenciones__c== null?0:objActa.Retenciones__c))+'</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center"><span class="contenido_13px_NB">Total Base + IVA - Retenciones</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_13px_NB"><span class="contenido_13px_NB"></span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">$ '+formatearCampoMoneda((objActa.Base_mas_IVA_menos_retenciones__c== null?0:objActa.Base_mas_IVA_menos_retenciones__c))+'</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center"><span class="contenido_13px_NB">Cuatro por mil</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_13px_NB"><span class="contenido_13px_NB"></span></td>'+
            '<td align="center"><span class="contenido_13px_NB">4*1000</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">&nbsp;</span></td>'+
            '<td align="center"><span class="contenido_13px_NB">$ '+formatearCampoMoneda((objActa.x4x1000_Calculado__c== null?0:objActa.x4x1000_Calculado__c))+'</span></td>'+
          '</tr>'+
          '<tr>'+
            '<td align="center"><span class="contenido_13px_NB">Valor total a transferir </span></td>'+            
            '<td colspan="5" align="Right"><span class="contenido_13px_NB">$ '+formatearCampoMoneda((objActa.Redondeo_valor_a_transferir__c== null?0:objActa.Redondeo_valor_a_transferir__c))+'</span></td>'+            
          '</tr>'+             
          '<tr>'+
            '<td colspan="4">'+
              '<table style="width: 100%;">'+
            	'<tr><td>&nbsp</td></tr>'+            	
            	'<tr>'+
            	 '<tr>'+
                	'<td style="width: 50%;" align="Center"><span class="contenido_14px">______________________________________</span></td>'+
            	'</tr>'+
            	'<tr>'+
                  '<td align="center"><span class="contenido_14px">'+((String.isBlank(objActa.Contrato_relacionado__r.Supervisor_Administrativo__r.Name)?'':objActa.Contrato_relacionado__r.Supervisor_Administrativo__r.Name)).toUpperCase()+'</span></td>'+
                
                '<tr>'+
                  '<td align="center"><span class="contenido_14px">SUPERVISOR ADMINISTRATIVO</span></td>'+
                '</tr>'+
                '<tr>'+
                  '<td align="center"><span class="contenido_14px">ETB '+(String.isBlank(objActa.Contrato_relacionado__r.Supervisor_Administrativo__r.EmployeeNumber)?'':objActa.Contrato_relacionado__r.Supervisor_Administrativo__r.EmployeeNumber)+'</span></td>'+
                '</tr>'+
              '</table>'+
              '</td>'+
            '<td colspan="2">'+
            '<table style="width: 100%;">'+
            	'<tr><td>&nbsp</td></tr>'+            	
            	'<tr>'+
            	 '<tr>'+
                	'<td style="width: 50%;" align="Center"><span class="contenido_14px">______________________________________</span></td>'+
            	'</tr>'+
            	'<tr>'+
                '<tr>'+
                  '<td align="center"><span class="contenido_14px">'+((String.isBlank(objActa.Representante_del_aliado__c)?'':objActa.Representante_del_aliado__c)).toUpperCase()+'</span></td>'+
                '</tr>'+
                '<tr>'+
                  '<td align="center"><span class="contenido_14px">'+((String.isBlank(objActa.Cargo_del_representante_legal__c)?'REPRESENTANTE LEGAL':objActa.Cargo_del_representante_legal__c)).toUpperCase()+'</span></td>'+
                '</tr>'+
                '<tr>'+
                  '<td align="center"><span class="contenido_14px">'+((String.isBlank(objActa.Contrato_relacionado__r.Aliado__r.Name)?'':objActa.Contrato_relacionado__r.Aliado__r.Name)).toUpperCase()+'</span></td>'+
                '</tr>'+
              '</table>'+
            '</td>'+
          '</tr>'+
        '</table>';
    }    
}