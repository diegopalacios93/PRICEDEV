public  class FacturacionSolucionesTI_cls {
    
    
    //metodo que valida que plan debe tomar
    public void informacionFacturacionSolTI(OperacionComercial__c OC)
    {
        // debe traer: el servicio sale de la relacion plan y catalogo de producto facturacion.
        //el producto depende del tipo de facturacion de la Operacion comercial
        //el objeto retornado con el boolean especial para que no facture.
        //
    }
    
    //metodo que valida que el plan tenga los valores seleccionados correctamente para el servicio
    public PlanSolucionTI__c validarPlanSeleccionado(OperacionComercial__c OC, list<planSolucionTI__c> planes)
    {
        PlanSolucionTI__c plansolti= null;
        boolean validacion=false;
        System.debug('@@-lista de planes: '+planes);
        if(planes!=null)
        {
            if(OC.AliadoColaborador__c != null){
                for(PlanSolucionTI__c plan :planes)
                {
                    
                    //tomar los valores del plan seleccionado 
                    System.debug('@@-OC.tipoVenta__c::'+OC.tipoVenta__c+' OC.tipoFacturacion__c: '+OC.tipoFacturacion__c);
                    System.debug('@@-Plan sol ti::'+plan);
                    if(OC.tipoVenta__c=='Reventa')
                    {
                        //validar que sea recurrente o no recurrente
                        if(OC.tipoFacturacion__c=='Cobro Recurrente')
                        {
                            //valida que el plan tenga activo
                            if(plan.Recurrente__c && !plan.productivizacion__c && plan.reventa__c && !plan.Aliado__c)
                            {
                                plansolti=plan;
                                break;
                            }
                            
                        }
                        else if(OC.tipoFacturacion__c=='Cobro Unico' || OC.tipoFacturacion__c=='Cobro Variable')
                        {
                            System.debug('@@-plan :: '+plan);
                            if(!plan.Recurrente__c && !plan.productivizacion__c && plan.reventa__c && !plan.Aliado__c)
                            {
                                plansolti=plan;
                                break;
                            }								
                        }
                        
                    }
                    else if(OC.tipoVenta__c=='Productivizacion')
                    {
                        if(OC.tipoFacturacion__c=='Cobro Recurrente')
                        {
                            //valida que el plan tenga activo
                            if(plan.Recurrente__c && plan.productivizacion__c && !plan.reventa__c && !plan.Aliado__c)
                            {
                                plansolti=plan;
                                break;
                            }
                            
                        }
                        else if(OC.tipoFacturacion__c=='Cobro Unico' ||  OC.tipoFacturacion__c=='Cobro Variable')
                        {
                            if(!plan.Recurrente__c && plan.Productivizacion__c && !plan.reventa__c && !plan.Aliado__c)
                            {
                                plansolti=plan;
                                break;
                            }								
                        }
                        
                    }
                    else if(OC.tipoVenta__c=='Alianza')
                    {
                        string idAliado='';
                        idAliado = OC.AliadoColaborador__c;
                        
                        if(OC.tipoFacturacion__c=='Cobro Recurrente')
                        {
                            //se obtiene el aliado de la viabilidad
                            
                            System.debug('@@-plan con aliado:: '+plan);
                            //valida que el plan tenga activo
                            if(plan.Recurrente__c && !plan.productivizacion__c && !plan.reventa__c && plan.Aliado__c && idAliado==plan.AliadoRel__c)
                            {
                                plansolti=plan;
                                break;
                            }
                            
                        }
                        else if(OC.tipoFacturacion__c=='Cobro Unico' ||  OC.tipoFacturacion__c=='Cobro Variable')
                        {
                            if(!plan.Recurrente__c && !plan.Productivizacion__c && !plan.reventa__c && plan.Aliado__c && idAliado==plan.AliadoRel__c)
                            {
                                plansolti=plan;
                                break;
                            }								
                        }
                        
                        
                    }
                    
                } 
            }
        }
        return plansolti;
    }
    
    
    //metodo que valida que el plan tenga los valores seleccionados correctamente para el servicio cuando es plan facturacion cobro unico recurrente
    public List<PlanSolucionTI__c> validarPlanSeleccionadoSoluTI(OperacionComercial__c OC, list<planSolucionTI__c> planes)
    {
        PlanSolucionTI__c plansolti= null;
        boolean validacion=false;
        List<PlanSolucionTI__c> lstPlanSolTI = new List<PlanSolucionTI__c>();
        System.debug('@@-lista de planes: '+planes);
        if(planes!=null)
        {
            if(OC.AliadoColaborador__c != null){
                for(PlanSolucionTI__c plan :planes)
                {
                    
                    //tomar los valores del plan seleccionado 
                    System.debug('@@-OC.tipoVenta__c::'+OC.tipoVenta__c+' OC.tipoFacturacion__c: '+OC.tipoFacturacion__c);
                    System.debug('@@-Plan sol ti::'+plan);
                    if(OC.tipoVenta__c=='Reventa')
                    {
                        //validar que sea recurrente o no recurrente
                        if(OC.tipoFacturacion__c==Label.CobroUnicoRecurrente)
                        {
                            System.debug('@@-plan :: '+plan);
                            if(plan.Recurrente__c && !plan.productivizacion__c && plan.reventa__c && !plan.Aliado__c)
                            {
                                plansolti=plan;
                                lstPlanSolTI.add(plansolti);
                            }
                            if(!plan.Recurrente__c && !plan.productivizacion__c && plan.reventa__c && !plan.Aliado__c)
                            {
                                plansolti=plan;
                                lstPlanSolTI.add(plansolti);
                            }				
                        }			
                        
                    }
                    else if(OC.tipoVenta__c=='Productivizacion')
                    {
                        if(OC.tipoFacturacion__c==Label.CobroUnicoRecurrente)
                        {
                            //valida que el plan tenga activo
                            if(plan.Recurrente__c && plan.productivizacion__c && !plan.reventa__c && !plan.Aliado__c)
                            {
                                plansolti=plan;
                                lstPlanSolTI.add(plansolti);
                            }
                            if(!plan.Recurrente__c && plan.Productivizacion__c && !plan.reventa__c && !plan.Aliado__c)
                            {
                                plansolti=plan;
                                lstPlanSolTI.add(plansolti);
                            }				
                        }
                        
                    }
                    else if(OC.tipoVenta__c=='Alianza')
                    {
                        string idAliado='';
                        idAliado = OC.AliadoColaborador__c;
                        
                        if(OC.tipoFacturacion__c==Label.CobroUnicoRecurrente) {
                            System.debug('@@-plan con aliado:: '+plan);
                            //valida que el plan tenga activo
                            if(plan.Recurrente__c && !plan.productivizacion__c && !plan.reventa__c && plan.Aliado__c && idAliado==plan.AliadoRel__c)
                            {
                                plansolti=plan;
                                lstPlanSolTI.add(plansolti);
                            }
                            if(!plan.Recurrente__c && !plan.Productivizacion__c && !plan.reventa__c && plan.Aliado__c && idAliado==plan.AliadoRel__c)
                            {
                                plansolti=plan;
                                lstPlanSolTI.add(plansolti);
                            }				
                        }
                        
                    }
                    
                }
            }
        }
        return lstPlanSolTI;
    }
    
    //armar Objeto para armar el canonico
    public SolucionTI datosCanonicoSolTI(OperacionComercial__c OC, Planes__c plan, list<PlanSolucionTI__c> plansolti)
    {
        
        System.debug('@@-plansolti::> '+plansolti);
        //validar si el plan elegido es el correcto.
        string nombreplan='';
        string nombreproducto='';
        string nombreservicio='';
        SolucionTI solucion;
        list<ParametroFacturacion__c> listParam = new list<ParametroFacturacion__c>();
        PlanSolucionTI__c correcto = validarPlanSeleccionado(OC,plansolti);
        //Lista con los planes de soluciones TI cuando aplica cobro recurrente y no recurrente.
        //List<PlanSolucionTI__c> resultado2 = validarPlanSeleccionadoSoluTI(OC,plansolti);
        System.debug('@@-correcto::> '+correcto);
        //System.debug('@@-resultado2::> '+resultado2);
        if(correcto!=null )
        {
            nombreplan=correcto.Name;
            nombreproducto=Correcto.Producto__c;
            //se deben recorrer los parametros
            listParam.addAll(correcto.ParametrosFacturacion__r );
            nombreServicio=plan.NombrePlanSolucionTI__c;
            solucion = new SolucionTI(nombreservicio,nombreproducto,nombreplan,listParam);
            
        }
        else if(OC.TOPP__r.TipodeOperacionporplan__c=='Retiro')
        {
            nombreplan='Retiro Sol TI';
            nombreproducto='Retiro Sol';
            //se deben recorrer los parametros
            //listParam.addAll(correcto.ParametrosFacturacion__r );
            nombreServicio=plan.NombrePlanSolucionTI__c;
            solucion = new SolucionTI(nombreservicio,nombreproducto,nombreplan,listParam);
        }
        
        System.debug('@@-solucion-datosCanonicoSolTI->'+solucion);
        return solucion;
    }
    
    //SAO - armar Objeto para armar el canonico cuando se tiene cobro recurrente y no recurrente al mismo tiempo
    public List<SolucionTI> datosCanonicoSolTIcobroRCyNRC(OperacionComercial__c OC, Planes__c plan, list<PlanSolucionTI__c> plansolti)
    {
        
        System.debug('@@-plansolti::> '+plansolti);
        //validar si el plan elegido es el correcto.
        string nombreplan='';
        string nombreproducto='';
        string nombreservicio='';
        SolucionTI solucion;
        String strIdPlan='';
        List<SolucionTI> lstSolucionTI = new List<SolucionTI>();
        list<ParametroFacturacion__c> listParam = new list<ParametroFacturacion__c>();
        //PlanSolucionTI__c correcto = validarPlanSeleccionado(OC,plansolti);
        //Lista con los planes de soluciones TI cuando aplica cobro recurrente y no recurrente.
        List<PlanSolucionTI__c> resultado = validarPlanSeleccionadoSoluTI(OC,plansolti);
        //System.debug('@@-correcto::> '+correcto);
        System.debug('@@-resultado::> '+resultado);
        if(resultado!=null )
        {
            
            for(PlanSolucionTI__c objSolucionTI: resultado) {
                nombreplan=objSolucionTI.Name;
                nombreproducto=objSolucionTI.Producto__c;
                //se deben recorrer los parametros
                listParam.addAll(objSolucionTI.ParametrosFacturacion__r);
                nombreServicio=plan.NombrePlanSolucionTI__c;
                solucion = new SolucionTI(nombreservicio,nombreproducto,nombreplan,listParam);
                lstSolucionTI.add(solucion);
                listParam = new List<ParametroFacturacion__c>();
            }		
        }
        else if(OC.TOPP__r.TipodeOperacionporplan__c=='Retiro')
        {
            for(PlanSolucionTI__c objSolucionTI: resultado) {
                nombreplan='Retiro Sol TI';
                nombreproducto='Retiro Sol';			
                nombreServicio=plan.NombrePlanSolucionTI__c;
                solucion = new SolucionTI(nombreservicio,nombreproducto,nombreplan,listParam);
                lstSolucionTI.add(solucion);
            }	
        }
        
        System.debug('@@- lista solucion-datosCanonicoSolTI->'+lstSolucionTI);
        return lstSolucionTI;
    }
    
    
    
    public class SolucionTI
    {
        public string servicio {get;set;}
        public string producto {get;set;}
        public string plan {get;set;}
        public list<ParametroFacturacion__c> lista {get;set;}
        public SolucionTI(string nombreServicio,string nombreProducto,string nombreplan, list<ParametroFacturacion__c> listaPar)
        {
            if(nombreservicio==null)
                servicio='';
            else
                servicio=nombreservicio;
            if(nombreproducto==null)
            {
                producto='';
            }
            else
                producto=nombreproducto;
            if(nombreplan==null)
                plan='';
            else
                plan=nombreplan;
            lista=listaPar;
            
        }
    }
}