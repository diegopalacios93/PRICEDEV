@isTest
public class DEG_GetTokenWatson_tst {

    @isTest
    static void TestGetTokenWatson() {

        DEG_ConsumeOrquestador_mck mock = new DEG_ConsumeOrquestador_mck('getTokenWatsonString');
		Test.setMock(HttpCalloutMock.class, mock);
		
        Test.startTest();
		String response = DEG_GetTokenWatson_ws.callTokenWatson();
		Test.stopTest();

		String expectedResponse = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJib3QiOiJrb25lY3RhLWV' + 
                                  '0YiIsInNpdGUiOiI2MkxiQjgwY0pCQSIsImNvbnYiOiIzTzNwVVd3dk9zeFRWUkVpbU9HU' +
                                  'zZqLUEiLCJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjUwMDAvZXRiLyIsImF1ZCI6Imh0dHA' +
                                  '6Ly9sb2NhbGhvc3Q6NTAwMC9ldGIvIiwidXNlciI6ImRpZ2l0YWwuZGV2IiwiaWF0IjoxN' +
                                  'jE4MjQ0OTA4LCJleHAiOjE2MTgzMzEzMDh9.-xmRo3Aw2kcEErs96bCXi2JRXf-wCImGl4ICE8LD-MQ';
		
        System.assertEquals(expectedResponse, response);
        
    }

}