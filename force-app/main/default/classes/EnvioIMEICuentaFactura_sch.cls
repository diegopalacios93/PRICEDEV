global class EnvioIMEICuentaFactura_sch implements Schedulable {
    
    global void execute(SchedulableContext sc){
        Database.executeBatch(new EnvioIMEICuentaFactura_bch(),100);
    }
    
}