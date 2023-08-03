public class LTE_LibreriaUtilitaria_cls {
    
        public static boolean checkImei(String ccNumber)
        {
        	if(ccNumber==null){
        		return true;   	
        	}
        	
        	if(!ccNumber.isNumeric()){
        		return false;   	
        	}
        	
        	if(ccNumber.length()!=15){
        		return false;        	
        	}
                Integer sum = 0;
                boolean alternate = false;
                for (Integer i = ccNumber.length() - 1; i >= 0; i--)
                {
                        Integer n = Integer.valueOf(ccNumber.substring(i, i + 1));
                        if (alternate)
                        {
                                n *= 2;
                                if (n > 9)
                                {
                                        n = math.mod(n ,10) + 1;
                                }
                        }
                        sum += n;
                        alternate = !alternate;
                }
                return math.mod(sum , 10) == 0;
        }
        

 
/****************************************************************************************************
	Nombre:      fn_GenerarDigVerNITCol
	Descripción: Este método permite generar el dígito de verificación de los NITs en Colombia.
	Variables de entrada:
	- nit: Es el Número de Identificación Tributaria en formato texto. Enviar SIN puntos, espacios o caracteres especiales
	Variables de salida:
	- vdigito: Número del Dígito de verificación en formato Texto.
	****************************************************************************************************/
	public static string fn_GenerarDigVerNITCol( String nit )
	{
		Integer vsuma = 0;
		//Se debe ajustar para garantizar que la longitud siempre sea de 15.
		if( nit == null || nit == '' || nit.length() <= 0 )
			return null;
		Integer ajuste = 15 - nit.length();
		for( Integer i = 0; i < ajuste ; i++ )
			nit = '0' + nit;
		
		for( Integer i = 0; i < 15 ; i++ )
		{
			try
			{
				Integer intTemp = Integer.valueOf( nit.substring( i, i + 1 ) );
				
				if( ( i + 1 ) == 1 )
					vsuma = vsuma + ( intTemp * 71 );		
				else if( ( i + 1 ) == 2 )		
					vsuma = vsuma + ( intTemp * 67 );		
				else if( ( i + 1 ) == 3 )     		
					vsuma = vsuma + ( intTemp * 59 );		
				else if( ( i + 1 ) == 4 )		
					vsuma = vsuma + ( intTemp * 53 );		
				else if( ( i + 1 ) == 5 )		
					vsuma = vsuma + ( intTemp * 47 );		
				else if( ( i + 1 ) == 6 )		
					vsuma = vsuma + ( intTemp * 43 );		
				else if( ( i + 1 ) == 7 )		
					vsuma = vsuma + ( intTemp * 41 );		
				else if( ( i + 1 ) == 8 )		
					vsuma = vsuma + ( intTemp * 37 );		
				else if( ( i + 1 ) == 9 )		
					vsuma = vsuma + ( intTemp * 29 );		
				else if( ( i + 1 ) == 10 )		
					vsuma = vsuma + ( intTemp * 23 );		
				else if( ( i + 1 ) == 11 )		
					vsuma = vsuma + ( intTemp * 19 );		
				else if( ( i + 1 ) == 12 )		
					vsuma = vsuma + ( intTemp * 17 );		
				else if( ( i + 1 ) == 13 )		
					vsuma = vsuma + ( intTemp * 13 );		
				else if( ( i + 1 ) == 14 )		
					vsuma = vsuma + ( intTemp * 7 );		
				else if( ( i + 1 ) == 15 )		
					vsuma = vsuma + ( intTemp * 3 );
			}
			catch( System.exception e ){ return null; }
		}
		
		Integer vdigito = Math.mod( vsuma, 11 );
		
		if( vdigito > 1 )
			vdigito = 11 - vdigito;
			
		return '' + vdigito;
	}
	
	public static void DigitoVerificacion(list<account> cuentas){
		
		for(account cuenta:cuentas){
			if(cuenta.AccountNumber!=null && cuenta.AccountNumber.isNumeric()){
				cuenta.DigitodeVerificacion__c=decimal.valueOf(fn_GenerarDigVerNITCol(cuenta.AccountNumber));
			} 
		}		
	
	}


}