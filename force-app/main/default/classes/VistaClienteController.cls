public class VistaClienteController {
    
    public PageReference AceptarVC3(){
        string accNmbr = ApexPages.currentPage().getParameters().get('id');
        
        List<Account> acc = [
            SELECT Id, AccountNumber, Name, Actividad_Economica__c, 
                	Segmento__c, SubSegmento__c, ValordeCliente__c, TipodeAtencion__c
            FROM Account
            WHERE AccountNumber =: String.valueOf(accNmbr) AND (RecordType.Name = 'Cliente Principal' or RecordType.Name = 'Business')
            ORDER BY CreatedDate DESC
        ];

        try {             
            Manejo_de_ofertas__c manejoDeOfertas = [
                SELECT Id, Tipo_de_Antecion__c, Segmento_cliente__c, Sub_Segmento_cliente__c, 
                        Actividad_Economica_cliente__c, Valor_de_Cliente__c, InformacionDisponible_Politicas__c
                FROM Manejo_de_ofertas__c 
                WHERE CuentaCliente__r.AccountNumber =: String.valueOf(accNmbr)
                ORDER BY CreatedDate DESC
                LIMIT 1
            ];
            
            if(manejoDeOfertas.InformacionDisponible_Politicas__c == null){
                manejoDeOfertas.Tipo_de_Antecion__c = acc[0].TipodeAtencion__c;
                manejoDeOfertas.Segmento_cliente__c = acc[0].Segmento__c;
                manejoDeOfertas.Sub_Segmento_cliente__c = acc[0].SubSegmento__c;
                manejoDeOfertas.Actividad_Economica_cliente__c = acc[0].Actividad_Economica__c;
                manejoDeOfertas.Valor_de_Cliente__c = acc[0].ValordeCliente__c;
                update manejoDeOfertas;
                
                PageReference redirect = new PageReference('/'+ manejoDeOfertas.Id);
                redirect.setRedirect(true);
                return redirect;
            }else{
                String VCError = System.Label.VCError;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, VCError)); 
                return null;
            }
            
        }
        catch (Exception e) {
            String VCError = System.Label.VCError;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, VCError)); 
            return null;
        }
	}
    
    public PageReference VolverVC3(){
        string accNmbr = ApexPages.currentPage().getParameters().get('id');
        
        Account acc = [SELECT Id FROM Account WHERE AccountNumber =: String.valueOf(accNmbr)];
        
        PageReference redirect = new PageReference('/'+ acc.Id);
        redirect.setRedirect(true);
        return redirect;
        
    }
}