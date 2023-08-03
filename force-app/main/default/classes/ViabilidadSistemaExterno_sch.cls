global class ViabilidadSistemaExterno_sch {
	global void execute(SchedulableContext sc){
        Database.executeBatch(new ViabilidadSistemaExterno_bch(),100);
    }
}