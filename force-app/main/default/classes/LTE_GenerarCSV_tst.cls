/***************************************************************************************************************************
*** Desarrollado por:       Avanxo Colombia                                                                              ***
*** Autor:                  Andrés Oliva (AO)                                                                            ***
*** Proyecto:               ETB - LTE                                                                                    ***
*** Descripcion:            Clase de prueba d ela clase LTE_GenerarCSV                                               ***
***                          
*** User history:                                                                                                        ***
*** Sprint:                                                                                                              ***
*** Release:                                                                                                             ***
***                                                                                                                      ***    
*** Cambios (Versiones)                                                                                                  ***
*** -------------------------------------                                                                                ***
***             No.     Fecha           Autor                   Descripción                                              ***    
***            -----    ----------      --------------------    ---------------                                          ***
*** @version    1.0     2015-09-16      Andrés Oliva (AO)      Class created                                             ***
***************************************************************************************************************************/
@isTest

private class LTE_GenerarCSV_tst
{
	public static  LTE_DetalleOferta__c oDetalleOferta;
  public static  Reserva__c           oReserva;

	 public static void CreateData()
    {
       oReserva       = LTE_DataGenerator_cls.CreateOfertaEconomica(true);
       oDetalleOferta = LTE_DataGenerator_cls.createDetalleOfertaListasNegras(true);       
    }

     public static testMethod void test_method_one() 
    {
       Test.startTest();
            CreateData();           
            LTE_GenerarCSV generar = new LTE_GenerarCSV();            
            String strResultado = generar.getCSV(); 

       Test.stopTest();
    }
}