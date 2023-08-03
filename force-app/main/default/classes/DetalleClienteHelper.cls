/**
 * @description       : 
 * @author            : Miguel R. Gómez  miguel.rafael.gomez@accenture.com
 * @group             : 
 * @last modified on  : 01-26-2022
 * @last modified by  : Miguel R. Gómez  miguel.rafael.gomez@accenture.com
**/
public with sharing class DetalleClienteHelper {
    
    @AuraEnabled(cacheable=true)
    public static List<Contract> traerListaContratoETB(String cuentaId){
        
        list<String> lstModalidades = new List <String>{'Licitación pública','Concurso de méritos','Selección abreviada','Mínima cuantía','Selección directa'};
        
        List<Contract> lstContratosETB = [SELECT Id, ContractNumber, Name, NumeroContratoSGC__c, Modalidad_de_contratacion__c, StartDate, fecha_final_contrato__c, 
                                        ValorTotaldelcontrato__c, TipodecontratoETB__c, Fecha_Final_Prima__c, Fecha_de_Venta__c,
                                        Monto_Prima__c, Monto_Prima_Total__c, Contrato_relacionado_Formula__c FROM Contract WHERE AccountId =:cuentaId AND Status = 'Activo' AND RecordType.Name = 'Clientes'];

        return lstContratosETB;
    }
 
    @AuraEnabled(cacheable=true)
    public static List<LineaNegocio> traerListaLineaNegocioXContrato(String cuentaId){

        list<String> lstModalidades = new List<String>{'Licitación pública','Concurso de méritos','Selección abreviada','Mínima cuantía','Selección directa'};

        list<AggregateResult> lstlineasNegocio  = [SELECT Legalizacion__r.Contrato__r.Name Nombre, Plan__r.NombredelProducto__r.LineaNegocio__c LineaNegocio, Plan__r.NombredelProducto__r.Name Producto FROM OperacionComercial__c 
                                                   WHERE CuentaCliente__c =:cuentaId AND Legalizacion__r.Contrato__r.AccountId=:cuentaId AND Legalizacion__r.Contrato__r.RecordType.Name = 'Clientes'
                                                   AND Legalizacion__r.Contrato__r.Status = 'Activo' GROUP BY Legalizacion__r.Contrato__r.Name, Plan__r.NombredelProducto__r.LineaNegocio__c,Plan__r.NombredelProducto__r.Name];
        

        list<LineaNegocio> lstLNegocio = new List<LineaNegocio>();

        for (AggregateResult item : lstlineasNegocio){
           lineaNegocio itemLN = new LineaNegocio();
            itemLN.nombre = ((string) item.get('Nombre'));
            itemLN.lineaNegocio = ((string) item.get('LineaNegocio'));
            itemLN.producto =((string) item.get('Producto'));
            lstLNegocio.add(itemLN);
        }

        return lstLNegocio;
    }

    @AuraEnabled(cacheable=true)
    public static List<Contratos_Vigentes_Competencia__c> traerListaContratoCompetencia(String cuentaId){
        List<Contratos_Vigentes_Competencia__c> lstContratosCompetencia = [SELECT Id, Name, Proveedor__c, Modalidad_de_contratacion__c, Productos_y_servicios__c, Fecha_Inicio_contrato__c,
                                                                          Fecha_final_contrato__c, Valor__c FROM Contratos_Vigentes_Competencia__c  WHERE Account__c =:cuentaId]; 
        
        return lstContratosCompetencia;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<datoContactoClientetWrapper> getTreeData(String cuentaId){
        string contactoClaveComercial = 'Contacto Clave Comercial';
        List<Dato_Contacto_Cliente__c> dccs = [SELECT Id, Nombre_empleado_ETB__c, Cargo_empleado_ETB__c, Contacto_del_cliente__r.Name, Contacto_del_cliente__r.Rol__c,
                                              Cargo_del_cliente__c, Email_cliente__c, Numero_telefono_cliente__c, Contacto_del_cliente__r.id, Numero_celular_cliente__c,
                                              Owner.Name, Nombre_de_la_cuenta__r.Administrador_Experiencia_al_Cliente__c, Ing_Factibilidad__c 
                                              FROM Dato_Contacto_Cliente__c WHERE Nombre_de_la_cuenta__r.Id =:cuentaId AND Contacto_del_cliente__r.Estado__c = 'Activo' 
                                              AND Contacto_del_cliente__r.RecordType.Name = :contactoClaveComercial];

        List<Viabilidad__c> lstViabilidad = [SELECT id, Ing_Factibilidad__c, Aliado__c FROM Viabilidad__c WHERE Aliado__c = :cuentaId];
        
        Map<Id,Viabilidad__c> mapViabilidad = new Map<Id, Viabilidad__c>();
        if (!lstViabilidad.isEmpty()) {
                for (Viabilidad__c Viabilidad: lstViabilidad) {
                    mapViabilidad.put(Viabilidad.Aliado__c, Viabilidad);
                }
        }                                      
                                              
        List<datoContactoClientetWrapper> aooo = new List<datoContactoClientetWrapper>();
        List<String> lstdatoclientes = new List<String>();
        for(Dato_Contacto_Cliente__c a : dccs){
      
            if (!lstViabilidad.isEmpty()) {
                for (Viabilidad__c Viabilidad: lstViabilidad) {
                    mapViabilidad.put(Viabilidad.Aliado__c, Viabilidad);
                }
            }
            datoContactoClientetWrapper aWraper = new datoContactoClientetWrapper() ; 
            aWraper.name = a.Id;
            aWraper.label = a.Cargo_empleado_ETB__c== null ?'Empleado de ETB: ' + a.Nombre_empleado_ETB__c :'Empleado de ETB: ' + a.Nombre_empleado_ETB__c +', Cargo: '+ a.Cargo_empleado_ETB__c ;            
            aWraper.expanded = false;
            lstdatoclientes = cargarDatosContacto(a);
            List<Items> co = new List<Items>();
            for (string dc : lstdatoclientes) {
                Items conWrapp = new Items();
                conWrapp.name = a.Contacto_del_cliente__r.id;                
                conWrapp.label = dc;
                conWrapp.expanded =false ;
                co.add(conWrapp);                
            }
            aWraper.items = co;
            aooo.add(aWraper);
            
        }
       return aooo;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> traerListaOportunidades(String cuentaId){
        list<String> lstTipoOportunidades = new List <String>{'Análisis de necesidades','Diseño de la solución','Propuesta de valor','Negociación / Revisión','Identificación Licitación','En Estudio','Pliegos','Presentada'};
       /* List<Opportunity> lstOportunidades = [SELECT Id, Name, Consecutivooportunidades__c, Tipo_de_Operacion__c, CloseDate, Valor_Total_ETB__c, 
                                             Valor_Total_Aliado__c, StageName, PDC__c FROM Opportunity WHERE StageName in :lstTipoOportunidades AND AccountId =:cuentaId]; 
        */
            List<Opportunity> lstOportunidades = [SELECT Id, Name, Consecutivooportunidades__c, Tipo_de_Operacion__c, CloseDate, Valor_Total_ETB__c, 
                                             Valor_Total_Aliado__c, StageName, PDC__c, PresupuestoInversionProyectada__c, Clasificacion_del_proyecto__c,
                                             Motivo_de_la_perdida__c, Tiempo_de_Cumplimiento_de_la_Oportunidad__c, importancia_estrategica_para_nosotros__c, 
                                             ProyectoIncluidoPlan__c, EmpresaCuentaConPresupuesto__c, MontoPresupuesto__c, ModalidadContratacion__c,
                                             MontoRecurrenteMensual__c, MontoOneTime__c, Tiempo_de_contrato_meses__c, Tiempo_de_contrato_dias__c, InteresadaEnContrato__c, ModeloContratacion__c, OtroModeloDeContratacion__c, 
                                             PotencializaCompraOtrasEntidades__c
                                             FROM Opportunity WHERE StageName in :lstTipoOportunidades AND AccountId =:cuentaId]; 
        return lstOportunidades;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> LstOportunidadesBanderaRoja(String cuentaId){
        list<String> lstTipoOportunidades = new List <String>{'Análisis de necesidades','Diseño de la solución','Propuesta de valor','Negociación / Revisión','Identificación Licitación','En Estudio','Pliegos','Presentada'};
        List<Opportunity> lstOportunidadesBR = [SELECT Id, Problema__c, PropuestaSolucion__c, Area__c, FechaLimite__c, Responsable__c
                                             FROM Opportunity
                                             WHERE Problema__c != '' AND AccountId =:cuentaId];
        return lstOportunidadesBR;
    }

    @AuraEnabled(cacheable=true)
    public static List<Case> traerListaCasos(String cuentaId){
        List<Case> lstCasos = [SELECT id, CaseNumber, Fechaderadicacion__c, IDServicio__c, Plan__c,
                              status, Causal_Estado__c, Priority, Subject, AccountId
                              FROM Case
                              WHERE AccountId =:cuentaId];
        return lstCasos;
    }

    @AuraEnabled(cacheable=true)
    public static List<LineaNegocio> traerListaLineaNegocioXOportunidad(String cuentaId){

        list<String> lstStage = new List<String>{'Análisis de necesidades','Diseño de la solución','Propuesta de valor','Negociación / Revisión'};

        list<AggregateResult> lstlineasNegocio  = [SELECT Oportunidad__r.Name Nombre,Plan__r.NombredelProducto__r.LineaNegocio__c LineaNegocio FROM OperacionComercial__c  
                                                   WHERE CuentaCliente__c= :cuentaId AND Oportunidad__r.StageName IN :lstStage GROUP BY Oportunidad__r.Name,Plan__r.NombredelProducto__r.LineaNegocio__c];
        

        list<LineaNegocio> lstLNegocio = new List<LineaNegocio>();

        for (AggregateResult item : lstlineasNegocio){
           lineaNegocio itemLN = new LineaNegocio();
            itemLN.nombre = ((string) item.get('Nombre'));
            itemLN.lineaNegocio = ((string) item.get('LineaNegocio'));
            lstLNegocio.add(itemLN);
        }

        return lstLNegocio;
    }

    private static list<String> cargarDatosContacto (Dato_Contacto_Cliente__c datoCliente){
        list<String> lstdatos = new list<String>();
    
        lstdatos.add ('Contacto del cliente: ' + datoCliente.Contacto_del_cliente__r.Name + ' Rol: ' + datoCliente.Contacto_del_cliente__r.Rol__c);
                
        if(datoCliente.Cargo_del_cliente__c != null ){
            lstdatos.add('Cargo del cliente: ' + datoCliente.Cargo_del_cliente__c);
        }
        if(datoCliente.Numero_telefono_cliente__c != null){
            lstdatos.add('Teléfono del cliente: ' + datoCliente.Numero_telefono_cliente__c);
        }
        if(datoCliente.Numero_celular_cliente__c != null){
            lstdatos.add('Móvil del cliente: ' + datoCliente.Numero_celular_cliente__c);
        }
        if(datoCliente.Email_cliente__c != null){
            lstdatos.add('Correo del cliente: ' + datoCliente.Email_cliente__c);
        }

        String Owner = datoCliente.Owner.Name;
        String ejecutivoExperiencia = datoCliente.Nombre_de_la_cuenta__r.Administrador_Experiencia_al_Cliente__c;
        String ejecutivoExperiencia1 = '';
        if (ejecutivoExperiencia != null) {ejecutivoExperiencia1 = ejecutivoExperiencia;}
        if (Owner != null) {
            lstdatos.add('Área de ETB: ' + Owner +' - ' + ejecutivoExperiencia1);
        }
        return lstdatos;
    }

    /**
    * @description Método para obtener el potencial y los ingresos operacionales de una cuenta.
    * @author Miguel R. Gómez  miguel.rafael.gomez@accenture.com | 01-25-2022 
    * @param cuentaId 
    * @return List<Opportunity> 
    **/
    @AuraEnabled(cacheable=true)
    public static List<String> ObtenerPotencialIngresosOperacionales(String cuentaId){

        System.debug('Este es la id de la cuenta '+cuentaId);
        List<String> potencialIngresosOper = new List <String>();
        List<Account> cuentas  = [SELECT Id, Potencial__c, IngresosOperacionales__c FROM Account WHERE Id =:cuentaId LIMIT 1]; 

        if(cuentas!=null && cuentas.Size()>0)
        {
            potencialIngresosOper.add(cuentas[0].Potencial__c);
            potencialIngresosOper.add(String.valueOf(cuentas[0].IngresosOperacionales__c));
        }
        else {
            potencialIngresosOper.add('');
            potencialIngresosOper.add('0');
        }
        
 
        return potencialIngresosOper;
    }

    public Class LineaNegocio {
        @AuraEnabled
        public String nombre {get;set;}
        @AuraEnabled
        public String lineaNegocio {get;set;}
        @AuraEnabled
        public String producto {get;set;}
    }

    public Class datoContactoClientetWrapper{
        @AuraEnabled
        public String name{get;set;}
        @AuraEnabled
        public String label{get;set;}
        @AuraEnabled
        public Boolean expanded{get;set;}
        @AuraEnabled
        public List<Items> items{get;set;}
        
    }
    public Class Items{
        @AuraEnabled
        public String name{get;set;}
        @AuraEnabled
        public String label{get;set;}
        @AuraEnabled
        public Boolean expanded{get;set;}
    }
}