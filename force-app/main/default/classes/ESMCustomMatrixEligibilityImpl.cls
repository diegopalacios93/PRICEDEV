/*
* VLOCITY, INC. CONFIDENTIAL
* __________________
*
*  2014-2020 Vlocity, Inc.
*  All Rights Reserved.
*
* NOTICE:  All information contained herein is, and remains
* the property of Vlocity, Inc. and its suppliers,
* if any. The intellectual and technical concepts contained
* herein are proprietary to Vlocity, Inc. and its suppliers and may be
* covered by U.S. and Foreign Patents, patents in process, and are
* protected by trade secret or copyright law. Dissemination of this
* information and reproduction, modification or reverse-engineering
* of this material, is prohibited unless prior written permission
* is obtained from Vlocity, Inc.
*
* @author: Vlocity
* 
* B2B CMEX Eligibility function implementation class 
*
*/
global class ESMCustomMatrixEligibilityImpl implements vlocity_cmt.VlocityOpenInterface, Callable
{
    private static String NSP = 'vlocity_cmt__';
    private static String cachePartition;
    
    private static boolean defaultValueOnError = false;
    private static boolean defaultValueOnEmptyContext = false;
    
    
    global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> output, Map<String, Object> options)
    {
        try
        {
            if (methodName.equalsIgnoreCase('checkEligibility'))
            {
                checkEligibility(input, output, options);
                return true;
            }
            return false;
        }
        catch (Exception ex) {
            System.debug(LoggingLevel.ERROR, ex);
            System.debug(LoggingLevel.ERROR, ex.getStackTraceString());
            output.put('error', ex.getMessage());
            throw ex;
        }   
    }

    public Object call(String action, Map<String, Object> args) 
    {
        Map<String,Object> inputMap = (Map<String,Object>)args.get('input');
        Map<String,Object> outputMap = (Map<String,Object>)args.get('output');
        Map<String,Object> options = (Map<String,Object>)args.get('options');
        
        return invokeMethod(action, inputMap, outputMap, options);
    }
    
    private void checkEligibility(Map<String,Object> inputMap, Map<String,Object> outputMap, Map<String,Object> options)
    {
        List<Object> inpList = (List<Object>) inputMap.get('arguments');
        String contextValueStr = (String) inpList[0];
        
        if(String.isBlank(contextValueStr))
        {
            outputMap.put('result', defaultValueOnEmptyContext);
            outputMap.put('isEligible', defaultValueOnEmptyContext);
            return;
        }
       
        Map<String, Object> cartContextValueObj = (Map<String, Object>) JSON.deserializeUntyped(contextValueStr);
        String productCode = (String) inpList[1];
        
        if(cartContextValueObj == NULL || cartContextValueObj.values().isEmpty())
        {
            outputMap.put('result', defaultValueOnEmptyContext);
            outputMap.put('isEligible', defaultValueOnEmptyContext);
            return;
        }
        else if(String.isBlank(productCode))
        {
            outputMap.put('result', defaultValueOnError);
            outputMap.put('isEligible', defaultValueOnError);
            return;
        }
        
        Map<String, Object> eligibileInput = new Map<String, Object>();
        eligibileInput.put('ProcedureName', 'ProductEligibilityProcedure');

        Map<String,Object> procData = new Map<String, Object>();
        procData.put('ProductCode', productCode);
        eligibileInput.put('InputData', procData);

        Map<String, Object> eligibileOutput  = new Map<String, Object>();
        Map<String, Object> eligibileOptions = new Map<String, Object>();

        invokeCalculationProcedure(eligibileInput, eligibileOutput, eligibileOptions);

        List<Object> result = (List<Object>) eligibileOutput.get('Result');
        for(Object resRow : result)
        {
            Map<String, Object> rowNodes = (Map<String, Object>) resRow;
            String expressionStr = (String) rowNodes.get('ProductEligibilityMatrix__Expression');
            Boolean expectedResult = Boolean.valueof(rowNodes.get('ProductEligibilityMatrix__Result'));
            
            Map<String, Object> inputEvaluate = new Map<String, Object>();
            Map<String, Object> outputEvaluate = new Map<String, Object>();
            Map<String, Object> optionEvaluate = new Map<String, Object>();
            inputEvaluate.put('Expression', replaceTokenWithValue(expressionStr ,  cartContextValueObj));
            outputEvaluate = (Map<String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService('ESM_EvaluateFormula', inputEvaluate, optionEvaluate);
            Object actualResult = outputEvaluate.get('Result');
            
            if(actualResult instanceof boolean)
            {
                boolean actualResultBool = boolean.valueof(actualResult);
                outputMap.put('result', actualResultBool);
                outputMap.put('isEligible', actualResultBool);
            }
            else
            {
                outputMap.put('result', defaultValueOnError);
                outputMap.put('isEligible', defaultValueOnError);
            }
        }
    }
    
    private String replaceTokenWithValue(String expressionWithToken, Map<String, Object> tokenValueMapping)
    {
        for(String tokenName : tokenValueMapping.KeySet())
        {
            expressionWithToken = expressionWithToken.replaceAll( tokenName + ' ', '\'' +((String) tokenValueMapping.get(tokenName)) + '\' ');
        }
        return expressionWithToken;
    }

    private void invokeCalculationProcedure (Map<String, Object> input, Map<String, Object> output, Map<String, Object> options)
    {
        String procedureName = (String)input.get('ProcedureName');
        Object inputData = input.get('InputData');

        if (String.isBlank(procedureName) || inputData == null )
        {
            output.put('ErrorMessage', 'ProcedureName or InputData are empty.');
            return;
        }
        // Construct the matrix calculation service
        Type t = Type.forName('vlocity_cmt.PricingMatrixCalculationService');

        vlocity_cmt.VlocityOpenInterface matrixService = (vlocity_cmt.VlocityOpenInterface)t.newInstance();

        Map<String, Object> inputMap = new Map<String, Object>{
        'inputData' => inputData
        };
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> optionsMap = new Map<String, Object>{
        'configurationName' => procedureName, // String procedureName = 'TestCalculationProcedure'
        'inputKey' => 'inputData', // tells the service what is the key for the data in the inputMap,
        'mode' => null,
        'isExpressionSet' => false,
        'verbose' => true,
        'matchInputVariables' => true,
        'effectiveDate' => String.valueOf(System.Now()),
        'configurationVersionId' => null // Set the matrix version id. Null version id picks the latest version with highest priority
        };

        // TODO: Extract error
        // invoke the calculation procedure
        matrixService.invokeMethod('calculate', inputMap, outputMap, optionsMap);
        
        //Parse the calculation procedure response
        List<Object> outList = (List<Object>)outputMap.get('output');
        List<Object> objectList;
        if (outList != null && !outList.isEmpty())
        {
            vlocity_cmt.PricingCalculationService.CalculationProcedureResults calcProcResults =
                (vlocity_cmt.PricingCalculationService.CalculationProcedureResults)outList[0];
            objectList = calcProcResults.calculationResults;
        }

        // return the objectList
        output.put('Result', objectList);
    }
}