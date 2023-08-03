/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Raul Mora
Proyecto:           ETB LTE CORPORATIVO FASE I
Descripción:        Clase de prueba para las clases LTE_PortabilidadSaliente_ws, LTE_SolPortacionSaliente_cls y LTE_FechaVentanaSalienteConfirmada_cls.

Cambios (Versiones)
-------------------------------------
No.     Fecha           Autor                       Descripción
----    ----------      --------------------        ---------------
1.0     2015-08-03      Raul Mora (RM)		        Creación de la clase.
***********************************************************************************************************************/
@isTest
private class LTE_PortabilidadSaliente_ws_tst 
{
	
	public LTE_PortabilidadSaliente_ws.PortabilidadMsg createData()
	{
		//Principal objeto de la clase
		LTE_PortabilidadSaliente_ws.PortabilidadMsg objPortMsg = new LTE_PortabilidadSaliente_ws.PortabilidadMsg();
		//Objeto cabecera
		LTE_PortabilidadSaliente_ws.CabeceraMensaje objCab = new LTE_PortabilidadSaliente_ws.CabeceraMensaje();
		//Objeto cuerpo
		LTE_PortabilidadSaliente_ws.CuerpoMensaje objCuerp = new LTE_PortabilidadSaliente_ws.CuerpoMensaje();
		//Objeto respuesta solicitud portacipon donante
		LTE_PortabilidadSaliente_ws.RespuestaSolicitudPortacionDonante objRespSol = new LTE_PortabilidadSaliente_ws.RespuestaSolicitudPortacionDonante();
		//Objeto lista de numeros
		LTE_PortabilidadSaliente_ws.ListaNumeracion objListNum = new LTE_PortabilidadSaliente_ws.ListaNumeracion();
		List<LTE_PortabilidadSaliente_ws.NumeracionProcesar>  lstNumPro = new List<LTE_PortabilidadSaliente_ws.NumeracionProcesar>();
		//Se diligencia la cabecera
		objCab.Identificador = 'ClasePrueba';
		objCab.Observaciones = 'ClasePrueba';
		objPortMsg.CabeceraMensaje = objCab;
		//Se diligecia el cuerpo
		objRespSol.NombreRazonSocialAbonado = 'Nombre Abonado Clase Prueba';
		objRespSol.DireccionAbonado = 'Dir Clase Prueba';
		objRespSol.IdentificacionAbonado = 'ID Clase';
		objRespSol.Receptor = 'Test';
		objRespSol.TipoUsuario = '1';
		objRespSol.TipoServicio = '1';
		objRespSol.NIP = '1234';
		objRespSol.SolicitudTerceros = '1';
		objRespSol.NRN = '4321';
		objRespSol.DocumentoID = 'DocumentoID Clase Prueba';
		objRespSol.DocumentoAT = 'DocumentoAT Clase Prueba';
		objRespSol.DocumentoCC = 'DocumentoCC Clase Prueba';
		Date dtToday = System.today().addDays(5);
		objCuerp.FechaVentanaConfirmada = dtToday.month() + '/' + dtToday.day() + '/' + dtToday.year();
		System.debug('objCuerp.FechaVentanaConfirmada-> '+objCuerp.FechaVentanaConfirmada);
		List<String> lstNum = new List<String>();
		lstNum.add( '321' );
		lstNum.add( '432' );
		//Configuracion personalizada para la creacion de la tarea
		LTE_PortabilidadSalienteTarea__c confPerTarea = new LTE_PortabilidadSalienteTarea__c();
		confPerTarea.LTE_IdPropietario__c = UserInfo.getUserId();
		confPerTarea.LTE_Asunto__c = 'ClasePrueba';
		insert confPerTarea;
		for( Integer i = 0; i < lstNum.size(); i++ )
		{
			LTE_PortabilidadSaliente_ws.NumeracionProcesar objNumPro = new LTE_PortabilidadSaliente_ws.NumeracionProcesar();
			objNumPro.Numero = lstNum.get(i);
			objNumPro.Fuente = lstNum.size() == 0 ? 'Salesfoce' : 'Siebel';
			lstNumPro.add( objNumPro );
		}
		objListNum.NumeracionProcesar = lstNumPro;
		objRespSol.ListaNumeracion = objListNum;
		
		objCuerp.RespuestaSolicitudPortacionDonante = objRespSol;
		objPortMsg.CuerpoMensaje = objCuerp;
		
		return objPortMsg;
	}
	
    static testMethod void myUnitTest() 
    {
    	LTE_PortabilidadSaliente_ws_tst clsTest = new LTE_PortabilidadSaliente_ws_tst();
        LTE_PortabilidadSaliente_ws.PortabilidadMsg objPortabilidadMsg = clsTest.createData();
        
        Test.startTest();
        	LTE_PortabilidadSaliente_ws.WSRequestPortabilidadSaliente( objPortabilidadMsg );
        	LTE_PortabilidadSaliente_ws.WSRequestFechaVentanaSalienteConfirmada( objPortabilidadMsg );
        	LTE_SolPortacionSaliente_cls.procesarPortabilidadSaliente( objPortabilidadMsg );
        Test.stopTest();
    }
}