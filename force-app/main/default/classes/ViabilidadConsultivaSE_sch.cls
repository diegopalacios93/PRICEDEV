global class ViabilidadConsultivaSE_sch {
	global void execute(SchedulableContext sc){
        Database.executeBatch(new ViabilidadConsultivaSE_bch(),100);
    }
}