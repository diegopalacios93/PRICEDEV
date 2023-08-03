@isTest
public with sharing class etb_FinancialLib_tst {

    
    @IsTest
    static void testPmt() {
        double f, r, y, p, x;
        double n;
        boolean t;

        r = 0; n = 3; p = 2; f = 7; t = true;
        y = etb_FinancialLib.pmt(r, n, p, f, t);
        x = -3;
        System.assertEquals( x, y);

        // cross check with pv
        r = 1; n = 10; p = -109.66796875; f = 10000; t = false;
        y = etb_FinancialLib.pmt(r, n, p, f, t);
        x = 100;
        System.assertEquals( x, y);

        

        r = 1; n = 10; p = -209.5703125; f = 10000; t = true;
        y = etb_FinancialLib.pmt(r, n, p, f, t);
        x = 100;
        System.assertEquals( x, y);


        Map<String,Object> input = new Map<String,Object>();
        Map<String,Object> outPut = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();

        input.put('rate',r);
        input.put('periods',n);
        input.put('present',p);
        input.put('future',f);
        input.put('pmt',t);

        etb_FinancialLib.pmt(input,outPut,options);

        System.assertNotEquals(outPut.get('result'),null,'null result !!!');

    }

    @IsTest
    static void testPv() {
        double f, r, y, p, x;

        double n;
        boolean t;

        r = 0; n = 3; y = 2; f = 7; t = true;
        f = etb_FinancialLib.pv(r, n, y, f, t);
        x = -13;
        System.assertEquals( x, f);

        r = 1; n = 10; y = 100; f = 10000; t = false;
        p = etb_FinancialLib.pv(r, n, y, f, t);
        x = -109.66796875;
        System.assertEquals( x, p);

        r = 1; n = 10; y = 100; f = 10000; t = true;
        p = etb_FinancialLib.pv(r, n, y, f, t);
        x = -209.5703125;
        System.assertEquals( x, p);

        r = 2.95; n = 13; y = 13000; f = 333891.23; t = false;
        p = etb_FinancialLib.pv(r, n, y, f, t);
        x = -4406.785442944962;
        System.assertEquals( x, p);

        r = 2.95; n = 13; y = 13000; f = 333891.23; t = true;
        p = etb_FinancialLib.pv(r, n, y, f, t);
        x = -17406.78521481564;
        System.assertEquals( x, p);


        Map<String,Object> input = new Map<String,Object>();
        Map<String,Object> outPut = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();

        input.put('rate',r);
        input.put('periods',n);
        input.put('present',y);
        input.put('future',f);
        input.put('pmt',t);

        etb_FinancialLib obj =  new etb_FinancialLib();

        obj.invokeMethod('pv',input, outPut, options);

        p = (double) outPut.get('result');
        System.assertEquals( x, p);

    }

    static testMethod void testinvokeMethod() {
        etb_FinancialLib obj = new etb_FinancialLib();
        double f, r, y, p, x;
        double n;
        boolean t;

        r = 1; n = 10; p = -209.5703125; f = 10000; t = true;

        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();

        inputMap.put('rate',r);
        inputMap.put('periods',n);
        inputMap.put('present',p);
        inputMap.put('future',f);
        inputMap.put('pmt',t);


        obj.invokeMethod('pmt',inputMap, outMap, options);

        x = 100;

        p = (double)outMap.get('result');
        System.assertEquals( x, p);

        
    }

    static testMethod void testCeilingCall() {

            etb_FinancialLib obj = new etb_FinancialLib();
            Map<String,Object> inputMap = new Map<String,Object>();
            Map<String,Object> outMap = new Map<String,Object>();
            Map<String,Object> options = new Map<String,Object>();

            double x = 10114457.831325302;
            double y = 100;


            inputMap.put('x', x);
            inputMap.put('y', y);


            obj.invokeMethod('ceiling',inputMap, outMap, options);

            System.assertNotEquals(outMap.get('result'), null);
 
    }

    

    static testMethod void testinvokeMethodError() {
        etb_FinancialLib obj = new etb_FinancialLib();
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();

        Boolean result;

            result = obj.invokeMethod('fake',inputMap, outMap, options);

        System.assertEquals( result, false);
    }

    static testMethod void testWrappedMath() {

        String [] maths =  new String[] {'ceiling','floor','max','min','pow'};

        for (String math : maths) {
            etb_FinancialLib obj = new etb_FinancialLib();
            Map<String,Object> inputMap = new Map<String,Object>();
            Map<String,Object> outMap = new Map<String,Object>();
            Map<String,Object> options = new Map<String,Object>();

            double x = 1.1234567890;
            double y = 2.0987654321;


            inputMap.put('x', x);
            inputMap.put('y', y);


            obj.invokeMethod(math,inputMap, outMap, options);

            System.assertNotEquals(outMap.get('result'), null);
            
        }

    }


    static testMethod void testException() {
        etb_FinancialLib obj = new etb_FinancialLib();
        Map<String,Object> inputMap = new Map<String,Object>();
        try {
            obj.invokeMethod('floor',inputMap, null, null);

        } catch (Exception ex) {
            System.assert(true, 'reached exception');
        }


    }

    @IsTest
    static void testCeiling() {
        double d;
        double s;
        double x;

        // test cases Nasser
        d = 1167912.848399057; s = 100;
        x = etb_FinancialLib.ceiling(d, s);
        System.assertEquals( 1168000, etb_FinancialLib.ceiling(d, s));

        d = 0; s = 0;

        System.assertEquals( 0, etb_FinancialLib.ceiling(d, s));

        d = 1; s = 0;
        System.assertEquals( 0, etb_FinancialLib.ceiling(d, s));

        d = 0; s = 1;
        System.assertEquals( 0, etb_FinancialLib.ceiling(d, s));

        d = -1; s = 0;
        System.assertEquals( 0, etb_FinancialLib.ceiling(d, s));

        d = 0; s = -1;
        System.assertEquals( 0, etb_FinancialLib.ceiling(d, s));

        //d = 10; s = 1.11;
        //System.assertEquals( 11.1, etb_FinancialLib.ceiling(d, s));

        d = 11.12333; s = 0.03499;
        System.assertEquals( 11.12682, etb_FinancialLib.ceiling(d, s));

        

        d = -11.12333; s = -0.03499;
        System.assertEquals( -11.12682, etb_FinancialLib.ceiling(d, s));

        d = 100; s = 0.001;
        System.assertEquals( 100, etb_FinancialLib.ceiling(d, s));

        d = -0.001; s = -9.99;
        System.assertEquals( -9.99, etb_FinancialLib.ceiling(d, s));

        d = 4.42; s = 0.05;
        System.assertEquals( 4.45, etb_FinancialLib.ceiling(d, s));

        d = 0.05; s = 4.42;
        System.assertEquals( 4.42, etb_FinancialLib.ceiling(d, s));

        d = 0.6666; s = 3.33;
        System.assertEquals( 3.33, etb_FinancialLib.ceiling(d, s));


        // samples from http://www.excelfunctions.net/Excel-Ceiling-Function.html
        // and https://support.office.com/en-us/article/CEILING-function-0a5cd7c8-0720-4f0a-bd2c-c943e510899f
        d = 22.25; s = 0.1;
        System.assertEquals( 22.3, etb_FinancialLib.ceiling(d, s));
        d = 22.25; s = 0.5;
        System.assertEquals( 22.5, etb_FinancialLib.ceiling(d, s));
        d = 22.25; s = 1;
        System.assertEquals( 23, etb_FinancialLib.ceiling(d, s));
        d = 22.25; s = 10;
        System.assertEquals( 30, etb_FinancialLib.ceiling(d, s));
        d = 22.25; s = 20;
        System.assertEquals( 40, etb_FinancialLib.ceiling(d, s));
        d = -22.25; s = -0.1;
        System.assertEquals( -22.3, etb_FinancialLib.ceiling(d, s));
        d = -22.25; s = -1;
        System.assertEquals( -23, etb_FinancialLib.ceiling(d, s));
        d = -22.25; s = -5;
        System.assertEquals( -25, etb_FinancialLib.ceiling(d, s));

        d = 22.25; s = 1;
        System.assertEquals( 23, etb_FinancialLib.ceiling(d, s));

        d = -22.25; s = 1;
        System.assertEquals( -22, etb_FinancialLib.ceiling(d, s)); // returns an error in Excel 2007 & earlier
        d = -22.25; s = -1;
        System.assertEquals( -23, etb_FinancialLib.ceiling(d, s));

        // test cases for newer versions of Excel where d can be negative for
        d = -11.12333; s = 0.03499;
        System.assertEquals( -11.09183, etb_FinancialLib.ceiling(d, s));

        // test cases NaN
        d = 1; s = -1;
        System.assertEquals( 0, etb_FinancialLib.ceiling(d, s));


    }


    @IsTest
    static void testAverage() {
        double [] values = new Double[]{2,10,20,15};

        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        etb_FinancialLib obj = new etb_FinancialLib();
        inputMap.put('values', values);
        obj.invokeMethod('average',inputMap, outMap, options);

        System.assertNotEquals(outMap.get('result'), null);

    }
}