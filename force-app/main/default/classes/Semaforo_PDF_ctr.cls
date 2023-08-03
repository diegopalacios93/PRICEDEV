public class Semaforo_PDF_ctr {
    transient public list<Contract> lstContrato = new list<Contract>();
    transient public list<Observacion_contrato__c> lstHechoRelevante = new list<Observacion_contrato__c>();    
    transient public Contract objContrato 		{get; set;}
    transient public String htmlScript			{get; set;}     
    transient public String urlLogoETB			{get; set;}         
    transient public String urlSemaforo			{get; set;} 
    transient public String idSemaforoVerde		{get; set;} 	    
    transient public String idSemaforoNaranja		{get; set;} 
    transient public String idSemaforoRojo		{get; set;} 
    public String id					{get; set;} 
    
    
    public Semaforo_PDF_ctr(ApexPages.StandardController controller){
        map<string,string> mapParameters = new map<string,string>();        
        mapParameters = ApexPages.currentPage().getParameters();         
        id = mapParameters.get('id');
        consultarContratos();         
        obtenerIdImgSemaforo();
        consultaObservacionesContrato();
        generar_html_script();             
    } 
    
    public void consultaObservacionesContrato(){
        lstHechoRelevante = [SELECT Descripcion__c, Contrato_relacionado__c                             
                             FROM Observacion_contrato__c                             
                             ORDER BY Contrato_relacionado__c, CreatedDate DESC];
    }
    
    public void obtenerIdImgSemaforo(){
        List<Document> lstDoc;         
        lstDoc = [Select Id from Document where DeveloperName = 'Semaforo_Rojo' limit 1];        
        if(lstDoc.size() > 0)
          idSemaforoRojo = lstDoc[0].Id;    
        
        lstDoc = [Select Id from Document where DeveloperName = 'Semaforo_Naranja' limit 1];        
        if(lstDoc.size() > 0)
          idSemaforoNaranja = lstDoc[0].Id;    
        
        lstDoc = [Select Id from Document where DeveloperName = 'Semaforo_Verde' limit 1];        
        if(lstDoc.size() > 0)
          idSemaforoVerde = lstDoc[0].Id;         
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
    
    public string procesarURLFile(Decimal mesesMora){  		
        string idSemaforo;
        List<Document> lstDoc;
        
        if(mesesMora > 3)
            urlSemaforo = '/servlet/servlet.FileDownload?file='+idSemaforoRojo;
        
        if(mesesMora == 3)            
            urlSemaforo = '/servlet/servlet.FileDownload?file='+idSemaforoNaranja;
        
        if(mesesMora < 3 || mesesMora == null)
            urlSemaforo = '/servlet/servlet.FileDownload?file='+idSemaforoVerde; 
                
        return urlSemaforo;
    }
    
    // :::::::::::::::::::::::::::::::::::::::::: CONSULTA DE DATOS  ::::::::::::::::::::::::::::::::::::::::::::::::::::
    
    public void consultarContratos(){
        Id UserId = UserInfo.getUserId();
        List<GroupMember> lstGrupo = New List<GroupMember>(
                          [Select GroupId,Id,SystemModstamp,UserOrGroupId From GroupMember
                           Where
                           GroupId In (Select Id From Group Where DeveloperName = 'Administradores_Contrato_Colaborador') AND
                           UserOrGroupId =: UserId]);        
        
        if(lstGrupo.size() > 0){
            lstContrato = [SELECT Anexo__c, Aliado__r.Name, Account.Name, Fecha_de_inicio__c, Fecha_de_terminacion__c,
                           Valor_sin_IVA__c, Valor_total__c, IVA_Contrato_Colaborador__c, Ejecutado__c, Valor_ejecutado_calculado_escritura__c, Valor_ejecutado_calculado__c, Saldo__c, 
                           Facturado__c, Conciliado__c, Valor_mes__c, Valor_de_la_deuda__c, Valor_de_la_deuda_calculado_escritura__c, Meses_en_mora__c, Meses_en_mora_calculado_escritura__c,
                           Status, Objeto__c, Fecha_de_suscripcion__c, Supervisor_Administrativo__r.Name, Tipo_de_contrato__c,
                           Valor_adiciones__c, Escalamiento__c, Cuenta_revchain__c, Saldo_calculado_escritura__c, Valor_adiciones_sin_iva__c, Facturado_Exp_Cliente__c
                           FROM Contract  
                           //WHERE RecordType.Name = 'Anexo Colaborador' AND (Status = 'Ejecución' OR Status = 'Liquidación' OR Status = 'Liquidado')
                           WHERE RecordType.Name = 'Anexo Colaborador' AND (Status = 'Ejecución')
                           ORDER BY Meses_en_mora_calculado_escritura__c DESC NULLS LAST]; 
            
        }else{
            lstContrato = [SELECT Anexo__c, Aliado__r.Name, Account.Name, Fecha_de_inicio__c, Fecha_de_terminacion__c,
                           Valor_sin_IVA__c, Valor_total__c, IVA_Contrato_Colaborador__c, Ejecutado__c, Valor_ejecutado_calculado_escritura__c, Valor_ejecutado_calculado__c, Saldo__c, 
                           Facturado__c, Conciliado__c, Valor_mes__c, Valor_de_la_deuda__c, Valor_de_la_deuda_calculado_escritura__c, Meses_en_mora__c, Meses_en_mora_calculado_escritura__c,
                           Status, Objeto__c, Fecha_de_suscripcion__c, Supervisor_Administrativo__r.Name, Tipo_de_contrato__c,
                           Valor_adiciones__c, Escalamiento__c, Cuenta_revchain__c, Saldo_calculado_escritura__c, Valor_adiciones_sin_iva__c, Facturado_Exp_Cliente__c
                           FROM Contract  
                           //WHERE RecordType.Name = 'Anexo Colaborador' AND (Status = 'Ejecución' OR Status = 'Liquidación' OR Status = 'Liquidado') AND
                           WHERE RecordType.Name = 'Anexo Colaborador' AND (Status = 'Ejecución') AND
                           Supervisor_Administrativo__c =: UserId
                           ORDER BY Meses_en_mora_calculado_escritura__c DESC NULLS LAST]; 
        }             
    } 
    
    public string consultarUltimoHechoRelevante(String idContrato){ 
        String hechoRelevante = '';
        for(Observacion_contrato__c observacionAux : lstHechoRelevante){
            if(observacionAux.Contrato_relacionado__c == idContrato){
               hechoRelevante = String.isBlank(observacionAux.Descripcion__c)?'':observacionAux.Descripcion__c;
               break;
            }
        }
        return hechoRelevante;		
    }    
    // :::::::::::::::::::::::::::::::::::::::::: GENERACIÓN DE HTML ::::::::::::::::::::::::::::::::::::::::::::::::::::
    public void generar_html_script(){  
        String urlSemaforo;        
        htmlScript = 
            '<table style="width: 100%;">'+
                     '<tbody>'+
                     '<tr>'+
                     '<td style="border: 0.5px solid;" align="center" bgcolor="#1F4E78"><span class="contenido_9px_white">ESTADO CONTRATO/ANEXO</span></td>'+
                     '<td style="border: 0.5px solid;" align="center" bgcolor="#1F4E78"><span class="contenido_9px_white">ALIADO/PROVEEDOR</span></td>'+
            		 '<td style="border: 0.5px solid;" align="center" bgcolor="#1F4E78"><span class="contenido_9px_white">CLIENTE</span></td>'+            		 
            		 '<td style="border: 0.5px solid;" align="center" bgcolor="#1F4E78"><span class="contenido_9px_white">OBJETO</span></td>'+
                 	 '<td style="border: 0.5px solid;" align="center" bgcolor="#1F4E78"><span class="contenido_9px_white">N° DE CONTRATO</span></td>'+
					 '<td style="border: 0.5px solid;" align="center" bgcolor="#1F4E78"><span class="contenido_9px_white">FECHA DE INICIO</span></td>'+
                     '<td style="border: 0.5px solid;" align="center" bgcolor="#1F4E78"><span class="contenido_9px_white">FECHA SUSCRIPCIÓN</span></td>'+
            		 '<td style="border: 0.5px solid;" align="center" bgcolor="#1F4E78"><span class="contenido_9px_white">FECHA TERMINACIÓN</span></td>'+
            		 '<td style="border: 0.5px solid;" align="center" bgcolor="#1F4E78"><span class="contenido_9px_white">SUPERVISOR</span></td>'+
            		 '<td style="border: 0.5px solid;" align="center" bgcolor="#1F4E78"><span class="contenido_9px_white">TIPO DE CONTRATO</span></td>'+            
            		 '<td style="border: 0.5px solid;" align="center" bgcolor="#1F4E78"><span class="contenido_9px_white">VALOR DEL CONTRATO</span></td>'+
            		 '<td style="border: 0.5px solid;" align="center" bgcolor="#1F4E78"><span class="contenido_9px_white">VALOR DE ADICIONES</span></td>'+
            		 '<td style="border: 0.5px solid;" align="center" bgcolor="#1F4E78"><span class="contenido_9px_white">VALOR DE CONTRATO + ADICIONES</span></td>'+
            		 '<td style="border: 0.5px solid;" align="center" bgcolor="#1F4E78"><span class="contenido_9px_white">VALOR EJECUTADO</span></td>'+            
            		 '<td style="border: 0.5px solid;" align="center" bgcolor="#1F4E78"><span class="contenido_9px_white">VALOR FACTURADO (CONCILIADO)</span></td>'+
            		 '<td style="border: 0.5px solid;" align="center" bgcolor="#1F4E78"><span class="contenido_9px_white">SALDO</span></td>'+            
            		 '<td style="border: 0.5px solid;" align="center" bgcolor="#1F4E78"><span class="contenido_9px_white">FACTURADO EXP. CLIENTE</span></td>'+
            		 '<td style="border: 0.5px solid;" align="center" bgcolor="#1F4E78"><span class="contenido_9px_white">HECHOS RELEVANTES</span></td>'+
            		 '<td style="border: 0.5px solid;" align="center" bgcolor="#1F4E78"><span class="contenido_9px_white">ESCALAMIENTO RESPONSABLE</span></td>'+            
            		 '<td style="border: 0.5px solid;" align="center" bgcolor="#1F4E78"><span class="contenido_9px_white">MESES EN MORA</span></td>'+            		 
            		 '<td style="border: 0.5px solid;" align="center" bgcolor="#1F4E78"><span class="contenido_9px_white">SEMÁFORO</span></td>'+            
                     '</tr>';
            		for(Contract objContract_aux : lstContrato){                    
            			htmlScript +=
                        '<tr>'+
                         '<td style="border: 0.5px solid;" align="center"><span class="contenido_8px_NB">'+(String.isBlank(objContract_aux.Status)?'':objContract_aux.Status)+'</span></td>'+
                         '<td style="border: 0.5px solid;" align="center"><span class="contenido_8px_NB">'+(String.isBlank(objContract_aux.Aliado__r.Name)?'':objContract_aux.Aliado__r.Name)+'</span></td>'+
                         '<td style="border: 0.5px solid;" align="center"><span class="contenido_8px_NB">'+(String.isBlank(objContract_aux.Account.Name)?'':objContract_aux.Account.Name)+'</span></td>'+                         
                         '<td style="border: 0.5px solid;" align="center"><span class="contenido_8px_NB"></span>'+(String.isBlank(objContract_aux.Objeto__c)?'':objContract_aux.Objeto__c)+'</td>'+
                         '<td style="border: 0.5px solid;" align="center"><span class="contenido_8px_NB"></span>'+(String.isBlank(objContract_aux.Anexo__c)?'':objContract_aux.Anexo__c)+'</td>'+
                         '<td style="border: 0.5px solid;" align="center"><span class="contenido_9px_NB">'+procesarFecha(objContract_aux.Fecha_de_inicio__c,'DD')+'/'+procesarFecha(objContract_aux.Fecha_de_inicio__c,'MM')+'/'+procesarFecha(objContract_aux.Fecha_de_inicio__c,'AAAA')+'</span></td>'+
                         '<td style="border: 0.5px solid;" align="center"><span class="contenido_9px_NB">'+procesarFecha(objContract_aux.Fecha_de_suscripcion__c,'DD')+'/'+procesarFecha(objContract_aux.Fecha_de_suscripcion__c,'MM')+'/'+procesarFecha(objContract_aux.Fecha_de_suscripcion__c,'AAAA')+'</span></td>'+
                         '<td style="border: 0.5px solid;" align="center"><span class="contenido_9px_NB">'+procesarFecha(objContract_aux.Fecha_de_terminacion__c,'DD')+'/'+procesarFecha(objContract_aux.Fecha_de_terminacion__c,'MM')+'/'+procesarFecha(objContract_aux.Fecha_de_terminacion__c,'AAAA')+'</span></td>'+
                         '<td style="border: 0.5px solid;" align="center"><span class="contenido_8px_NB">'+(String.isBlank(objContract_aux.Supervisor_Administrativo__r.Name)?'':objContract_aux.Supervisor_Administrativo__r.Name)+'</span></td>'+
                         '<td style="border: 0.5px solid;" align="center"><span class="contenido_8px_NB">'+(String.isBlank(objContract_aux.Tipo_de_contrato__c)?'':objContract_aux.Tipo_de_contrato__c)+'</span></td>'+                                                  
                         '<td style="border: 0.5px solid;" align="center"><span class="contenido_9px_NB">$'+formatearCampoMoneda(((objContract_aux.Valor_sin_IVA__c== null) ? 0 : objContract_aux.Valor_sin_IVA__c))+'</span></td>'+
						 '<td style="border: 0.5px solid;" align="center"><span class="contenido_9px_NB">$'+formatearCampoMoneda(((objContract_aux.Valor_adiciones_sin_iva__c== null) ? 0 : objContract_aux.Valor_adiciones_sin_iva__c))+'</span></td>'+
                         '<td style="border: 0.5px solid;" align="center"><span class="contenido_9px_NB">$'+formatearCampoMoneda(((objContract_aux.Valor_sin_IVA__c== null) ? 0 : objContract_aux.Valor_sin_IVA__c)+((objContract_aux.Valor_adiciones_sin_iva__c== null) ? 0 : objContract_aux.Valor_adiciones_sin_iva__c))+'</span></td>'+
						 '<td style="border: 0.5px solid;" align="center"><span class="contenido_9px_NB">$'+formatearCampoMoneda(((objContract_aux.Valor_ejecutado_calculado_escritura__c== null) ? 0 : objContract_aux.Valor_ejecutado_calculado_escritura__c))+'</span></td>'+                            
                         '<td style="border: 0.5px solid;" align="center"><span class="contenido_9px_NB">$'+formatearCampoMoneda((objContract_aux.Facturado__c== null) ? 0 : objContract_aux.Facturado__c)+'</span></td>'+
                         '<td style="border: 0.5px solid;" align="center"><span class="contenido_9px_NB">$'+formatearCampoMoneda((objContract_aux.Saldo_calculado_escritura__c))+'</span></td>'+                               
                         '<td style="border: 0.5px solid;" align="center"><span class="contenido_9px_NB">$'+formatearCampoMoneda(((objContract_aux.Facturado_Exp_Cliente__c== null) ? 0 : objContract_aux.Facturado_Exp_Cliente__c))+'</span></td>'+
                         '<td style="border: 0.5px solid;" align="center"><span class="contenido_8px_NB">'+consultarUltimoHechoRelevante(objContract_aux.Id)+'</span></td>'+
 						 '<td style="border: 0.5px solid;" align="center"><span class="contenido_8px_NB">'+(String.isBlank(objContract_aux.Escalamiento__c)?'':objContract_aux.Escalamiento__c)+'</span></td>'+                            
						 '<td style="border: 0.5px solid;" align="center"><span class="contenido_8px_NB">'+(objContract_aux.Meses_en_mora_calculado_escritura__c== null?0:objContract_aux.Meses_en_mora_calculado_escritura__c).setScale(0)+'</span></td>'+						 
                         '<td style="border: 0.5px solid;" align="center"><img src="'+procesarURLFile(objContract_aux.Meses_en_mora_calculado_escritura__c)+'" style="width:50%;height:60%;"/></td>'+                                                 
                         '</tr>';                               
			        }
        			htmlScript +=
                     '</tbody>'+
             '</table>';
    }
    
    public PageReference generarInforme(){            
        String url;        
        url = '/apex/GenerarCSV_IframeSemaforoContrato_pag?id='+id;
        PageReference newPage = new PageReference(url);        
		return newPage;
    }   
    
    public PageReference cerrarPagina(){        
		String url;
        url = '/'+id;        
		PageReference page = new PageReference(url);
		return page;
	} 
}