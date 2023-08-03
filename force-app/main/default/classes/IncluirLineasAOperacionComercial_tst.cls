@isTest
public class IncluirLineasAOperacionComercial_tst {
	static testMethod void IncluirLineasAOperacionComercial_tst() {
        List<ID> lstID = new List<ID>();        
        GeneraData_cls.generarData();
        lstID.add(GeneraData_cls.retencionServicio.Id);
        system.debug('fse2'+lstID);
        IncluirLineasAOperacionComercial_cls.incluirLineas(lstID);
        
    }
}