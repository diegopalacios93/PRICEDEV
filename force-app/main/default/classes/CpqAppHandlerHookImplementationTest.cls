/****************************************************************************************************
    Autor:          edwin.bohorquez@globant.com
    Project:        Vlocity - ETB
    Description:    Clase de prueba para para la clase CpqAppHandlerHookImplementation

    Información de Cambios (Versiones)
    -------------------------------------
    No.         Fecha             Autor                     Descripción
    ------      ----------        ------------------        --------------------
    1.0         01-11-2022        Edwin Bohorquez           Creación de Clase test
*****************************************************************************************************/
@IsTest

public with sharing class CpqAppHandlerHookImplementationTest {
	@isTest
    static void invokeMethodWithFields(){
        CpqAppHandlerHookImplementation handlerHookImplementation = new CpqAppHandlerHookImplementation();
        Map<String,Object> input = new Map<String,Object>();
        Map<String,Object> output = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        input.put('fields', 'TestField');
        Test.startTest();
        Boolean result = handlerHookImplementation.invokeMethod('postCartsItems.PreInvoke',input,output,options);
        Test.stopTest();
        System.assertEquals(true, result);
    }
    
    @isTest
    static void invokeMethodWithoutFields(){
        CpqAppHandlerHookImplementation handlerHookImplementation = new CpqAppHandlerHookImplementation();
        Map<String,Object> input = new Map<String,Object>();
        Map<String,Object> output = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Test.startTest();
        Boolean result = handlerHookImplementation.invokeMethod('deleteCartsItems.PreInvoke',input,output,options);
        Test.stopTest();
        System.assertEquals(true, result);
    }
    
    @isTest
    static void invokeMethodWithError(){
        CpqAppHandlerHookImplementation handlerHookImplementation = new CpqAppHandlerHookImplementation();
        Map<String,Object> input = new Map<String,Object>();
        Map<String,Object> output = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        input.put('fields', 'TestError');
        Test.startTest();
        Try{
        	Boolean result = handlerHookImplementation.invokeMethod('deleteCartsItems.PreInvoke',input,output,options);   
        }catch(Exception ex){
            System.assertEquals('Ocurrió un al invocar el metodo', ex.getMessage());
        }
        Test.stopTest();
    }
}