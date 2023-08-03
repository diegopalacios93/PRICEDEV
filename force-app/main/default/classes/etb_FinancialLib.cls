/****************************************************************************************************
    Author:          emmanuel.flores@globant.com
    Project:        Vlocity - ETB
    Description:    Vlocity enabled apex class for Integration Procedures calls
*****************************************************************************************************/
global with sharing class etb_FinancialLib  implements vlocity_cmt.VlocityOpenInterface{

    public Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        Boolean result = true;        
        try {
            switch on methodName
            {
                when 'pmt' {
                    pmt(inputMap, outMap, options);
                }
                when 'pv' {
                    pv(inputMap, outMap, options);
                }
                when 'ceiling' {
                    //outMap.put('result',Math.ceil((double)inputMap.get('x')));
                    Decimal x = (Decimal)inputMap.get('x'), y = (Decimal)inputMap.get('y');
                    outMap.put('result',etb_FinancialLib.ceiling(x,y));
                }
                when 'floor' {
                    outMap.put('result',Math.floor((double)inputMap.get('x')));
                }
                when 'max' {
                    outMap.put('result',Math.max((double)inputMap.get('x'),(double)inputMap.get('y')));
                }
                when 'min' {
                    outMap.put('result',Math.min((double)inputMap.get('x'),(double)inputMap.get('y')));
                }
                when 'pow' {
                    outMap.put('result',Math.pow((double)inputMap.get('x'),(double)inputMap.get('y')));
                }
                when 'average' {
                    List<Double> values = (List<Double>)inputMap.get('values');
                    double res = etb_FinancialLib.average(values);
                    outMap.put('result', res);
                }
                when else {
                    result = false;

                }
            }
        } catch(Exception e) {
            System.debug('GLB_PruebaConcepto inbokeMethod -> exception: ' + e.getLineNumber());
            throw e;
        }
        return result;
    }

    /**
     *
     * @param r rate
     * @param n num of periods
     * @param p present value
     * @param f future value
     * @param t type (true=pmt at beginning of period, false=pmt at end of period)
     */
    public static double pmt(double r, double n, double p, double f, boolean t) {
        if (r == 0) {
            return -1*(f+p)/n;
        } else {
            double r1 = r + 1;
            return ( f + p * Math.pow(r1, n) ) * r
                  /
               ((t ? r1 : 1) * (1 - Math.pow(r1, n)));
        }
    }

    public static void pmt(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
        double r, n,p,f;
        boolean t ;
        double outcome;

        if( input != null ){
             
            r = (double) input.get('rate');
            n = (double) input.get('periods');
            p = (double) input.get('present');
            f = (double) input.get('future');
            t = (boolean) input.get('pmt');
    
    
            outcome = pmt(r,n,p,f,t);
        }

       

        outMap.put('result',outcome);
    }

        /**
     * Present value of an amount given the number of future payments, rate, amount
     * of individual payment, future value and boolean value indicating whether
     * payments are due at the beginning of period
     * (false =&gt; payments are due at end of period)
     * @param r rate
     * @param n num of periods
     * @param y pmt per period
     * @param f future value
     * @param t type (true=pmt at beginning of period, false=pmt at end of period)
     */
    public static double pv(double r, double n, double y, double f, boolean t) {
        if (r == 0) {
            return -1*((n*y)+f);
        } else {
            double r1 = r + 1;
            return (( ( 1 - Math.pow(r1, n) ) / r ) * (t ? r1 : 1)  * y - f)
                     /
                    Math.pow(r1, n);
        }
    }

    public static void pv(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
        double r, n,p,f;
        boolean t ;
        double outcome;

        if( input != null ){
             
            r = (double) input.get('rate');
            n = (double) input.get('periods');
            p = (double) input.get('present');
            f = (double) input.get('future');
            t = (boolean) input.get('pmt');
    
    
            outcome = pv(r,n,p,f,t);
        }

        outMap.put('result',outcome);
    }

    /**
     * Note: this function is different from java.lang.Math.ceil(..).
     * <p>
     * When n and s are "valid" arguments, the returned value is: Math.ceiling(n/s) * s;
     * <br>
     * n and s are invalid if any of following conditions are true:
     * <ul>
     * <li>s is zero</li>
     * <li>n is negative and s is positive</li>
     * <li>n is positive and s is negative</li>
     * </ul>
     * In all such cases, Double.NaN is returned.
     * @param n
     * @param s
     */
    public static Decimal ceiling(Decimal n, Decimal s) {
        if (n>0 && s<0) {
            //return Double.NaN;
            return 0;
        } else {
            return (n == 0 || s == 0) ? 0 : Math.ceil(n/s) * s;
        }
    }

    /**
     * average of all values
     * @param values
     */
    public static double average(List<Double> values) {
        double ave = 0;
        double sum = 0;
        for (double value : values) {
            sum += value;
        }
        ave = sum / values.size();
        return ave;
    }
}