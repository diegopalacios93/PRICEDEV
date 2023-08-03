/***********************************************************************************************************************
Desarrollado por:   ETB
Proyecto:           PORTAFOLIO SUPERIOR FASE II
Descripción:        Clase de prueba PS_IntegrationHelper_tst.
Cambios (Versiones)
-------------------------------------------------------------------
No.     Fecha        Autor                    Descripción
----    ----------   ----------------------   ---------------
1.0     2019-07-16   John Guevara (ETB)		  Creación de la clase.
***********************************************************************************************************************/
@isTest
public class PS_IntegrationHelper_tst {
    
    static testMethod void testmethod1() {
        String smessage = '';
        smessage += '<?xml version="1.0" encoding="UTF-8"?>';
        smessage += '<ser:services xmlns:ser="www.etb.com.co/ETB.MDM.EnterpriseCatalog/CommonSchemas/Revchain/ServiceProvisioning">';
        smessage += '	<ser:service_particulars>';
        smessage += '		<ser:N1_Campo1 attr="nivel1">N1_Valor1</ser:N1_Campo1>';
        smessage += '		<ser:N1_Campo2>N1_Valor2</ser:N1_Campo2>';
        smessage += '		<ser:N2_Campo1>N2_Valor1</ser:N2_Campo1>';
        smessage += '		<ser:N2_Campo2>N2_Valor2</ser:N2_Campo2>';
        smessage += '		<ser:N3_Campo1>N3_Valor1</ser:N3_Campo1>';
        smessage += '		<ser:N3_Campo2>N3_Valor2</ser:N3_Campo2>';
        smessage += '		<ser:N4_Campo1_pos>N4_ValorA</ser:N4_Campo1_pos>';
        smessage += '		<ser:N4_Campo1>N4_ValorA</ser:N4_Campo1>';
        smessage += '		<ser:N4_Campo2>N4_ValorA</ser:N4_Campo2>';
        smessage += '		<ser:N4_Campo1_cond1>N4_ValorA</ser:N4_Campo1_cond1>';
        smessage += '		<ser:N4_Campo1>N4_ValorB</ser:N4_Campo1>';
        smessage += '		<ser:N4_Campo2>N4_ValorB</ser:N4_Campo2>';
        smessage += '		<ser:N4_Campo1_cond1>N4_ValorB</ser:N4_Campo1_cond1>';
        smessage += '		<ser:N4_Campo1_cond2>N4_ValorB</ser:N4_Campo1_cond2>';
        smessage += '		<ser:N2_Campo1>N2_Valor1</ser:N2_Campo1>';
        smessage += '		<ser:N2_Campo2>N2_Valor2</ser:N2_Campo2>';
        smessage += '		<ser:N3_Campo1>N3_Valor1</ser:N3_Campo1>';
        smessage += '		<ser:N3_Campo2>N3_Valor2</ser:N3_Campo2>';
        smessage += '		<ser:N4_Campo1_pos>N4_ValorA</ser:N4_Campo1_pos>';
        smessage += '		<ser:N4_Campo1>N4_ValorA</ser:N4_Campo1>';
        smessage += '		<ser:N4_Campo2>N4_ValorA</ser:N4_Campo2>';
        smessage += '		<ser:N4_Campo1_cond1>N4_ValorA</ser:N4_Campo1_cond1>';
        smessage += '		<ser:N4_Campo1>N4_ValorB</ser:N4_Campo1>';
        smessage += '		<ser:N4_Campo2>N4_ValorB</ser:N4_Campo2>';
        smessage += '		<ser:N4_Campo1_cond1>N4_ValorB</ser:N4_Campo1_cond1>';
        smessage += '		<ser:N4_Campo1_cond2>N4_ValorB</ser:N4_Campo1_cond2>';
        smessage += '		<ser:Cond_Campo1>N2_Valor1</ser:Cond_Campo1>';
        smessage += '		<ser:Cond_Campo2>N2_Valor1</ser:Cond_Campo2>';
        smessage += '		<ser:Cond_Campo4>N4_ValorA</ser:Cond_Campo4>';
        smessage += '		<ser:Cond_Campo1>N2_Valor1</ser:Cond_Campo1>';
        smessage += '		<ser:Cond_Campo2>N2_Valor1</ser:Cond_Campo2>';
        smessage += '		<ser:Cond_Campo4>N4_ValorA</ser:Cond_Campo4>';
        smessage += '	</ser:service_particulars>';
        smessage += '</ser:services>';
        
        
        
        List<Map<String,Object>> lstNivel4 = new List<Map<String,Object>>();
        Map<String,String> mapNivel4_1 = new Map<String,String>();
        mapNivel4_1.put('N4_Campo1','N4_ValorA');
        mapNivel4_1.put('N4_Campo2','N4_ValorA');
        lstNivel4.add(mapNivel4_1);
        Map<String,String> mapNivel4_2 = new Map<String,String>();
        mapNivel4_2.put('N4_Campo1','N4_ValorB');
        mapNivel4_2.put('N4_Campo2','N4_ValorB');
        lstNivel4.add(mapNivel4_2);
        
        Map<String,Object> mapNivel3 = new Map<String,Object>();
        mapNivel3.put('N3_Campo1','N3_Valor1');
        mapNivel3.put('N3_Campo2','N3_Valor2');
        mapNivel3.put('N3_Campo3',lstNivel4);
        
        List<Map<String,Object>> lstNivel2 = new List<Map<String,Object>>();
        Map<String,Object> mapNivel2_1 = new Map<String,Object>();
        mapNivel2_1.put('N2_Campo1','N2_Valor1');
        mapNivel2_1.put('N2_Campo2','N2_Valor2');
        mapNivel2_1.put('N2_Campo3',mapNivel3.clone());
        lstNivel2.add(mapNivel2_1);
        Map<String,Object> mapNivel2_2 = new Map<String,Object>();
        mapNivel2_2.put('N2_Campo1','N2_Valor1');
        mapNivel2_2.put('N2_Campo2','N2_Valor2');
        mapNivel2_2.put('N2_Campo3',mapNivel3.clone());
        lstNivel2.add(mapNivel2_2);
        
        Map<String,Object> mapNivel1 = new Map<String,Object>();
        mapNivel1.put('N1_Campo1','N1_Valor1');
        mapNivel1.put('N1_Campo2','N1_Valor2');
        mapNivel1.put('N1_Campo3',lstNivel2);
        
        
        Map<String,String> mapNivel3_Homologacion = new Map<String,String>();
        mapNivel3_Homologacion.put('Homologacion_1','ValorHomologacion1');
        mapNivel3_Homologacion.put('Homologacion_2','ValorHomologacion2');
        
        Map<String,Object> mapNivel2_Homologacion = new Map<String,Object>();
        mapNivel2_Homologacion.put('TipoHomologacion_1',mapNivel3_Homologacion);
        
        mapNivel1.put('Homologacion',mapNivel2_Homologacion);
        
        String messageTemplate = '';
        messageTemplate += '<?xml version="1.0" encoding="UTF-8"?>';
        messageTemplate += '<ser:services xmlns:ser="www.etb.com.co/ETB.MDM.EnterpriseCatalog/CommonSchemas/Revchain/ServiceProvisioning">';
        messageTemplate += '	<ser:service_particulars>';
        messageTemplate += '		<ser:N1_Campo1 attr="nivel1">{@N1_Campo1}</ser:N1_Campo1>';
        messageTemplate += '		<ser:N1_Campo2>{@N1_Campo2}</ser:N1_Campo2>';
        messageTemplate += '		<ser:xMapIterator IteratorVariable="N1_Campo3">';
        messageTemplate += '			<ser:N2_Campo1>{@N1_Campo3/N2_Campo1}</ser:N2_Campo1>';
        messageTemplate += '			<ser:N2_Campo1>TRANSLATE(\'TipoHomologacion_8\',\'Homologacion_3\')</ser:N2_Campo1>';
        messageTemplate += '			<ser:N2_Campo2>{@N1_Campo3/N2_Campo2}</ser:N2_Campo2>';
        messageTemplate += '			<ser:N3_Campo1>{@N1_Campo3/N2_Campo3/N3_Campo1}</ser:N3_Campo1>';
        messageTemplate += '			<ser:N3_Campo2>{@N1_Campo3/N2_Campo3/N3_Campo2}</ser:N3_Campo2>';
        messageTemplate += '			<ser:N4_Campo1_pos>{@N1_Campo3/N2_Campo3/N3_Campo3[0]/N4_Campo1}</ser:N4_Campo1_pos>';
        messageTemplate += '			<ser:xMapIterator IteratorVariable="N1_Campo3/N2_Campo3/N3_Campo3">';
        messageTemplate += '				<ser:N4_Campo1>{@N1_Campo3/N2_Campo3/N3_Campo3/N4_Campo1}</ser:N4_Campo1>';
        messageTemplate += '				<ser:N4_Campo2>{@N1_Campo3/N2_Campo3/N3_Campo3/N4_Campo2}</ser:N4_Campo2>';
        messageTemplate += '				<ser:xMapConditional Condition="({@N1_Campo3/N2_Campo3/N3_Campo3/N4_Campo2} != \'N4_ValorC\')">';
        messageTemplate += '					<ser:N4_Campo1_cond1>{@N1_Campo3/N2_Campo3/N3_Campo3/N4_Campo2}</ser:N4_Campo1_cond1>';
        messageTemplate += '				</ser:xMapConditional>';
        messageTemplate += '				<ser:xMapConditional Condition="({@N1_Campo3/N2_Campo3/N3_Campo3/N4_Campo2} == \'N4_ValorB\')">';
        messageTemplate += '					<ser:N4_Campo1_cond2>{@N1_Campo3/N2_Campo3/N3_Campo3/N4_Campo2}</ser:N4_Campo1_cond2>';
        messageTemplate += '				</ser:xMapConditional>';
        messageTemplate += '			</ser:xMapIterator>';
        messageTemplate += '		</ser:xMapIterator>';
        messageTemplate += '		<ser:xMapConditional Condition="({@N1_Campo3[0]/N2_Campo1} != \'N4_ValorA\')">';
        messageTemplate += '			<ser:xMapIterator IteratorVariable="N1_Campo3">';
        messageTemplate += '				<ser:xMapConditional Condition="({@N1_Campo3/N2_Campo3/N3_Campo3[0]/N4_Campo2} != \'N4_ValorB\')">';
        messageTemplate += '					<ser:Cond_Campo1>{@N1_Campo3/N2_Campo1}</ser:Cond_Campo1>';
        messageTemplate += '				</ser:xMapConditional>';
        messageTemplate += '				<ser:xMapConditional Condition="({@N1_Campo3/N2_Campo3/N3_Campo3[N4_Campo1==\'N4_ValorA\']/N4_Campo2} != \'N4_ValorC\')">';
        messageTemplate += '					<ser:Cond_Campo2>{@N1_Campo3/N2_Campo1}</ser:Cond_Campo2>';
        messageTemplate += '					<ser:Cond_Campo2>REPLACEUTF8({@N1_Campo3/N2_Campo1})</ser:Cond_Campo2>';
        messageTemplate += '					<ser:Cond_Campo2>SUBSTRING({@N1_Campo3/N2_Campo1},0,1)</ser:Cond_Campo2>';
        messageTemplate += '					<ser:Cond_Campo2>IF(NOT({@N1_Campo3/N2_Campo1}==\'a\',\'0\',\'1\')</ser:Cond_Campo2>';
        messageTemplate += '				</ser:xMapConditional>';
        messageTemplate += '				<ser:xMapConditional Condition="OR({@N1_Campo3/N2_Campo3/N3_Campo3[0]/N4_Campo2} != \'N4_ValorC\' , {@N1_Campo3/N2_Campo3/N3_Campo3[0]/N4_Campo2} != \'N4_ValorB\')">';
        messageTemplate += '					<ser:Cond_Campo3>{@N1_Campo3/N2_Campo1}</ser:Cond_Campo3>';
        messageTemplate += '				</ser:xMapConditional>';
        messageTemplate += '				<ser:xMapConditional Condition="AND(OR({@N1_Campo3/N2_Campo3/N3_Campo3[0]/N4_Campo2} != \'N4_ValorC\', {@N1_Campo3/N2_Campo3/N3_Campo3[0]/N4_Campo2} == \'N4_ValorA\') , {@N1_Campo3/N2_Campo3/N3_Campo3[0]/N4_Campo2} != \'N4_ValorD\')">';
        messageTemplate += '					<ser:Cond_Campo4>{@N1_Campo3/N2_Campo3/N3_Campo3[0]/N4_Campo2}</ser:Cond_Campo4>';
        messageTemplate += '				</ser:xMapConditional>';
        messageTemplate += '			</ser:xMapIterator>';
        messageTemplate += '		</ser:xMapConditional>';
        messageTemplate += '	</ser:service_particulars>';
        messageTemplate += '</ser:services>';
        
        test.startTest();
        
        PS_IntegrationHelper_ctr sc = new PS_IntegrationHelper_ctr();
        
        Dom.Document doc2 = sc.MaptoXML(mapNivel1);
        
        Dom.Document doc = new Dom.Document();
        doc.load(messageTemplate);
        Dom.Document doc3 = sc.PopulateXML(doc,mapNivel1);
        
        test.stopTest();
    }
    
    static testMethod void PopulateMapTest() {
        GeneraData_cls.generarData();
        Case oCase        = GeneraData_cls.caso2;
        
        String sObjetoBase = 'Case';
        Set<String> lstCampoParam = new Set<String>();
        lstCampoParam.add('Id');
        lstCampoParam.add('CaseNumber');
        
        String joinedString = String.join(new List<String>(lstCampoParam), ',');
        String sql = 'SELECT '+joinedString+' FROM '+ sObjetoBase+' WHERE Id = \''+oCase.Id+'\'';
        List<SObject> lstObjetos = Database.query(sql);
        Map<Id,Map<String,Object>> mpPrimaryObject = PS_IntegrationHelper_ctr.PopulateMap(sObjetoBase, lstCampoParam, lstObjetos, 'yyyy-MM-dd\'T\'HH:mm:ssXXX');
    }
}