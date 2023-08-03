public class FutureSincronizarCtasFact_Revchain_cls {
	@Future(callout=true)
	public static void integrarRevchain(string jsonString) {                
        List<String> lstIdCuentaFacturacion = (List<String>)System.JSON.deserialize(jsonString, List<String>.class);
        
        if(lstIdCuentaFacturacion[0] != null){        
            set<String> setIdCtaFacturacion	= new set<String>();
            setIdCtaFacturacion.add(lstIdCuentaFacturacion[0]);
            SincronizacionCtasFact_Revchain_cls objCtasFac = new SincronizacionCtasFact_Revchain_cls();            
            objCtasFac.CrearCuentasFacturacion(setIdCtaFacturacion);
        }
    }      
}