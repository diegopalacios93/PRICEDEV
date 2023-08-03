/*******************************************************************************
Desarrollado por:		Avanxo Colombia
Autor:					Luis Eduardo Mogollón
Proyecto:				ETB - CRM Evolutivos
Descripción:			Clase que maneja las banderas de ejecucion de los triggers
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0		21-08-2014	Luis Eduardo Mogollon (LEM)		Creación de la clase
*******************************************************************************/

public class BanderasEjecucion {

private static set<String> stEjecutado = new set<String>();
	public static boolean ValidarEjecucion(String nombre)
	{
		return stEjecutado.contains(nombre);
	}
	public static void setEjecucion(string nombre)
	{
		stEjecutado.add(nombre);
	}
	
	public static void unSetEjecucion(string nombre)
	{
		for(String s: stEjecutado)
		{
		    if(s.contains(nombre)){
		        stEjecutado.remove(s);
		    }
		} 
	}
}