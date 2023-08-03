public with sharing class GenerarCSVAnexoColaborador {
	
	public String contractId  					{get; set;}
    public String fileName	  					{get; set;}    
    public List<wrapper> lstwrapper 			{get; set;}  
    public String pageUrlExport					{get; set;}
    public String pageUrlExportObservaciones	{get; set;}
    public String pageUrlExportAdiciones		{get; set;}
    
    public class wrapper{
        public string Anexo_c											{get; set;}
        public string Account											{get; set;}
        public string Aliado_r											{get; set;}
        public string NIT_Aliado_c										{get; set;}
        public string ID_Registro_c										{get; set;}
        public string Consecutivo_c										{get; set;}
        public string Consecutivo_CAD_c									{get; set;}
        public string Supervisor_Administrativo_r						{get; set;}
        public string Fecha_de_suscripcion_c							{get; set;}
        public string Fecha_de_inicio_c									{get; set;}
        public string Fecha_de_terminacion_c							{get; set;}
        public string Tipo_de_contrato_c								{get; set;}
        public string Plazo_de_ejecucion_c								{get; set;}
        public string Tiempo_de_liquidacion_c							{get; set;}
        public string Fecha_maxima_de_liquidacion_c						{get; set;}
        public string Status											{get; set;}
        public string Objeto_c											{get; set;}
        public string Valor_sin_IVA_c									{get; set;}
        public string Porcentaje_IVA_c									{get; set;}
        public string IVA_Contrato_Colaborador_c						{get; set;}
        public string Valor_total_c										{get; set;}
        public string Valor_adiciones_c									{get; set;}        
        public string Valor_sin_IVA_en_dolares_c						{get; set;}
        public string IVA_en_dolares_c									{get; set;}
        public string Valor_total_incluido_IVA_en_dolares_c				{get; set;}        
        public string Numero_de_adiciones_c								{get; set;}
        public string Ejecutado_c										{get; set;}
        public string Facturado_c										{get; set;}
        public string Conciliado_c										{get; set;}
        public string Saldo_c											{get; set;}
        public string Valor_mes_c										{get; set;}
        public string Valor_de_la_deuda_c								{get; set;}
        public string Meses_en_mora_c									{get; set;}
        public string Meses_ejecutados_c								{get; set;}
        public string Valor_fijo_o_variable_c							{get; set;}
        public string Escalamiento_c									{get; set;}
        public string Cuenta_revchain_c									{get; set;}
        public string Observaciones_c									{get; set;}
        public string Categoria_c										{get; set;}		
        public string Multas_o_ANS_c									{get; set;}
        public string Facultado_c										{get; set;}
        public string Supervisor_tecnico_r								{get; set;}
        public string Ultima_facturacion_aprobada_c						{get; set;}
        public string Ultima_conciliacion_c								{get; set;}		
        public string Ultimo_informe_de_supervision_c					{get; set;}
        public string Impuestos_c										{get; set;}
        public string Vigencias_de_polizas_c							{get; set;}
        public string Causal_de_no_pago_c								{get; set;}
        public string Estado_documentacion_c							{get; set;}
        public string Modalidad_de_contratacion_c						{get; set;}            
        public string Valor_adiciones_en_dolares_c						{get; set;}    
        public string Vicepresidencia_c									{get; set;}    
        public string Contrato_compartido_con_vicepresidencia_c			{get; set;}    
        public string Observaciones_o_novedades_c						{get; set;}    
        public string Composicion_del_contrato_c						{get; set;}    
        public string Nombre_del_facultado_actual_de_ETB_c				{get; set;}    
        public string Representante_area_usuaria_c						{get; set;}    
        public string Codigo_ETB_representante_area_usuaria_c			{get; set;}    
        public string Fecha_de_ultima_orden_de_servicio_c				{get; set;}    
        public string Fecha_de_suspension_c								{get; set;}    
        public string Fecha_finalizacion_de_suspension_c				{get; set;}    
        public string Fecha_vencimiento_de_homologacion_c				{get; set;}    
        public string Plazo_de_la_renovacion_c							{get; set;}    
        public string Renovacion_automatica_contrato_c					{get; set;}    
        public string Contratista_con_homologacion_vigente_c			{get; set;}    
        public string Asignacion_recursos_presupuestales_c				{get; set;}    
    }
        
	public GenerarCSVAnexoColaborador() {
        lstwrapper = new List<wrapper>();
		contractId = ApexPages.currentPage().getParameters().get('id');		               
        getIdRegistro();
        fileName       				= 'application/vnd.ms-excel#AnexoColaborador_ID_'+getIdRegistro()+'.xls';
        pageUrlExport 				= '/apex/GenerarCSVAnexoColaborador_pag?id='+contractId;
        pageUrlExportObservaciones 	= '/apex/GenerarCSVAnexo_Observacion_pag?ContractId='+contractId;
        pageUrlExportAdiciones 		= '/apex/GenerarCSVAnexo_Prorroga_pag?ContractId='+contractId+'&source="All"';
	}
    
    public void exportToExcel(){        
        string queryString;        
        queryString =    'Select '
                        +'Anexo__c, Account.Name, Aliado__r.Name, NIT_Aliado__c, ID_Registro__c, Consecutivo__c, Consecutivo_CAD__c, '
                        +'Supervisor_Administrativo__r.Name, Fecha_de_suscripcion__c, Fecha_de_inicio__c, Fecha_de_terminacion__c, Tipo_de_contrato__c, '
                        +'Plazo_de_ejecucion__c, Plazo_de_ejecucion_escritura__c, Tiempo_de_liquidacion__c, Fecha_maxima_de_liquidacion__c, Status, Objeto__c, Valor_sin_IVA__c, '
                        +'Porcentaje_IVA__c, IVA_Contrato_Colaborador__c, Valor_total__c, Valor_adiciones__c, Numero_de_adiciones__c, Ejecutado__c, Valor_ejecutado_calculado_escritura__c, Valor_ejecutado_calculado__c, '
                        +'Facturado__c, Conciliado__c, Saldo__c, Valor_mes__c, Valor_de_la_deuda__c, Valor_de_la_deuda_calculado_escritura__c, Meses_en_mora__c, Meses_en_mora_calculado_escritura__c, Meses_ejecutados_calculado_escritura__c, '
                        +'Valor_fijo_o_variable__c, Escalamiento__c, Cuenta_revchain__c, Observaciones__c, Categoria__c, Multas_o_ANS__c, '
                        +'Facultado__c, Supervisor_tecnico__r.Name, Ultima_facturacion_aprobada__c, Ultima_conciliacion__c, Ultimo_informe_de_supervision__c, '
                        +'Impuestos__c, Vigencias_de_polizas__c, Causal_de_no_pago__c, Estado_documentacion__c, Modalidad_de_contratacion__c, '
            			+'Valor_sin_IVA_en_dolares__c, IVA_en_dolares__c, Valor_total_incluido_IVA_en_dolares__c, Valor_adiciones_en_dolares__c, Vicepresidencia__c, '
            			+'Contrato_compartido_con_vicepresidencia__c, Observaciones_o_novedades__c, Composicion_del_contrato__c, Nombre_del_facultado_actual_de_ETB__c, '
            			+'Representante_area_usuaria__c, Codigo_ETB_representante_area_usuaria__c, Fecha_de_ultima_orden_de_servicio__c, Fecha_de_suspension__c, '
            			+'Fecha_finalizacion_de_suspension__c, Fecha_vencimiento_de_homologacion__c, Plazo_de_la_renovacion__c, Renovacion_automatica_contrato__c, '
            			+'Contratista_con_homologacion_vigente__c, Asignacion_recursos_presupuestales__c, Saldo_calculado_escritura__c '
                        +'FROM Contract '
                        +'WHERE Id =\''+contractId+'\'';                                              
          
        List<Contract> lstAux = DataBase.Query(queryString);        
        if(lstAux.size()>0){            
            for(Contract aux :lstAux){                
                wrapper w 									= new wrapper();                                
                w.Anexo_c									=aux.Anexo__c;
                w.Account									=aux.Account.Name;
                w.Aliado_r									=aux.Aliado__r.Name;
                w.NIT_Aliado_c								=aux.NIT_Aliado__c;
                w.ID_Registro_c								=aux.ID_registro__c;
                w.Consecutivo_c								=string.valueof(aux.Consecutivo__c);
                w.Consecutivo_CAD_c							=string.valueof(aux.Consecutivo_CAD__c);
                w.Supervisor_Administrativo_r				=aux.Supervisor_Administrativo__r.Name;
                w.Fecha_de_suscripcion_c					=string.valueof(aux.Fecha_de_suscripcion__c);
                w.Fecha_de_inicio_c							=string.valueof(aux.Fecha_de_inicio__c);
                w.Fecha_de_terminacion_c					=string.valueof(aux.Fecha_de_terminacion__c);
                w.Tipo_de_contrato_c						=aux.Tipo_de_contrato__c;
                w.Plazo_de_ejecucion_c						=string.valueof(aux.Plazo_de_ejecucion_escritura__c);
                w.Tiempo_de_liquidacion_c					=string.valueof(aux.Tiempo_de_liquidacion__c);
                w.Fecha_maxima_de_liquidacion_c				=string.valueof(aux.Fecha_maxima_de_liquidacion__c);
                w.Status									=aux.Status;
                w.Objeto_c									=aux.Objeto__c;
                w.Valor_sin_IVA_c							=string.valueof(aux.Valor_sin_IVA__c);
                w.Porcentaje_IVA_c							=aux.Porcentaje_IVA__c;
                w.IVA_Contrato_Colaborador_c				=string.valueof(aux.IVA_contrato_colaborador__c);
                w.Valor_total_c								=string.valueof(aux.Valor_total__c);
                w.Valor_adiciones_c							=string.valueof(aux.Valor_adiciones__c);
                w.Numero_de_adiciones_c						=string.valueof(aux.Numero_de_adiciones__c);
                w.Ejecutado_c								=string.valueof(aux.Valor_ejecutado_calculado_escritura__c);
                w.Facturado_c								=string.valueof(aux.Facturado__c);
                w.Conciliado_c								=string.valueof(aux.Conciliado__c);
                w.Saldo_c									=string.valueof(aux.Saldo_calculado_escritura__c);
                w.Valor_mes_c								=string.valueof(aux.Valor_mes__c);
                w.Valor_de_la_deuda_c						=string.valueof(aux.Valor_de_la_deuda_calculado_escritura__c);
                w.Meses_en_mora_c							=string.valueof(aux.Meses_en_mora_calculado_escritura__c);
                w.Meses_ejecutados_c						=string.valueof(aux.Meses_ejecutados_calculado_escritura__c);
                w.Valor_fijo_o_variable_c					=aux.Valor_fijo_o_variable__c;	
                w.Escalamiento_c							=aux.Escalamiento__c;
                w.Cuenta_revchain_c							=aux.Cuenta_revchain__c;
                w.Observaciones_c							=aux.Observaciones__c;
                w.Categoria_c								=aux.Categoria__c;
                w.Multas_o_ANS_c							=aux.Multas_o_ANS__c;
                w.Facultado_c								=aux.Facultado__c;
                w.Supervisor_tecnico_r						=aux.Supervisor_tecnico__r.Name;
                w.Ultima_facturacion_aprobada_c				=string.valueof(aux.Ultima_facturacion_aprobada__c);
                w.Ultima_conciliacion_c						=string.valueof(aux.Ultima_conciliacion__c);
                w.Ultimo_informe_de_supervision_c			=string.valueof(aux.Ultimo_informe_de_supervision__c);
                w.Impuestos_c								=string.valueof(aux.Impuestos__c);
                w.Vigencias_de_polizas_c					=aux.Vigencias_de_polizas__c;
                w.Causal_de_no_pago_c						=aux.Causal_de_no_pago__c;
                w.Estado_documentacion_c					=aux.Estado_documentacion__c;	
                w.Modalidad_de_contratacion_c				=aux.Modalidad_de_contratacion__c;
                //
                w.Valor_sin_IVA_en_dolares_c				=string.valueof(aux.Valor_sin_IVA_en_dolares__c);
                w.IVA_en_dolares_c							=string.valueof(aux.IVA_en_dolares__c);
                w.Valor_total_incluido_IVA_en_dolares_c		=string.valueof(aux.Valor_total_incluido_IVA_en_dolares__c);
                
                w.Valor_adiciones_en_dolares_c				=string.valueof(aux.Valor_adiciones_en_dolares__c);
                w.Vicepresidencia_c							=string.valueof(aux.Vicepresidencia__c);
                w.Contrato_compartido_con_vicepresidencia_c	=string.valueof(aux.Contrato_compartido_con_vicepresidencia__c);
                w.Observaciones_o_novedades_c				=string.valueof(aux.Observaciones_o_novedades__c);
                w.Composicion_del_contrato_c				=string.valueof(aux.Composicion_del_contrato__c);
                w.Nombre_del_facultado_actual_de_ETB_c		=string.valueof(aux.Nombre_del_facultado_actual_de_ETB__c);
                w.Representante_area_usuaria_c				=string.valueof(aux.Representante_area_usuaria__c);
                w.Codigo_ETB_representante_area_usuaria_c	=string.valueof(aux.Codigo_ETB_representante_area_usuaria__c);
                w.Fecha_de_ultima_orden_de_servicio_c		=string.valueof(aux.Fecha_de_ultima_orden_de_servicio__c);
                w.Fecha_de_suspension_c						=string.valueof(aux.Fecha_de_suspension__c);
                w.Fecha_finalizacion_de_suspension_c		=string.valueof(aux.Fecha_finalizacion_de_suspension__c);
                w.Fecha_vencimiento_de_homologacion_c		=string.valueof(aux.Fecha_vencimiento_de_homologacion__c);
                w.Plazo_de_la_renovacion_c					=string.valueof(aux.Plazo_de_la_renovacion__c);
                w.Renovacion_automatica_contrato_c			=string.valueof(aux.Renovacion_automatica_contrato__c);
                w.Contratista_con_homologacion_vigente_c	=string.valueof(aux.Contratista_con_homologacion_vigente__c);
                w.Asignacion_recursos_presupuestales_c		=string.valueof(aux.Asignacion_recursos_presupuestales__c);
                lstwrapper.add(w); 
            }            
        }
    } 
    
    public string getIdRegistro(){
        Contract[] auxObjContrato;
        try{
        	auxObjContrato = [Select ID_Registro__c from Contract where Id =:contractId LIMIT 1];
        	return auxObjContrato[0].ID_Registro__c;
        }catch(exception e){
            return null;
        } 
    }
    public PageReference regresar(){        
		String url;
        url = '/'+contractId;        
		PageReference page = new PageReference(url);
		return page;
	}
}