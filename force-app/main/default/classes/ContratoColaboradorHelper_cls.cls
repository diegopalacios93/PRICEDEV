public class ContratoColaboradorHelper_cls {
    
    public class ConvertirNumeroATexto { 
        public String[] to_19 = new string[]{ 'CERO', 'UN','DOS','TRES','CUATRO','CINCO','SEIS','SIETE','OCHO','NUEVE','DIEZ','ONCE','DOCE','TRECE','CATORCE','QUINCE','DIECISEIS','DIECISIETE','DIECIOCHO','DIECINUEVE'}; 
    	public String[] tens  = new string[]{ 'VEINTE', 'TREINTA', 'CUARENTA', 'CINCUENTA', 'SESENTA', 'SETENTA', 'OCHENTA', 'NOVENTA'};  
    	public String[] denom = new string[]{ '','MIL','MILLON','MIL','BILLON','TRILLON','CUATRILLON'}; 
        
        public string getCifraEnTexto(long val){ 
          String ret;    
          if (val <= 100) {              
            return convertirDosCifrasEnTexto(val.intValue());  
          } 
          if (val < 1000) {              
            return convertirTresCifrasEnTexto(val.intValue());  
          }
          for (integer v = 0; v < denom.size(); v++) {              
            integer didx = v - 1;  
            long dval = (long)Math.pow(1000, v);  
            if (dval > val) {               
              long mod = (integer)Math.pow(1000, didx);  
              long l   = val / mod;  
              long r   = val - (l * mod);  
              ret  = '';          
             
              if(l <> 1){                  
                  if(denom[didx] == 'MILLON' || denom[didx] == 'BILLON' || denom[didx] == 'TRILLON' || denom[didx] == 'CUATRILLON')
                    ret  = convertirTresCifrasEnTexto(l) + ' ' + denom[didx]+'ES';  
                  else
                    ret  = convertirTresCifrasEnTexto(l) + ' ' + denom[didx];  
              }else{                   
                  if(val >= 1000000 && val <1000000000){
                    ret  = 'UN '+denom[didx];
                  }else
                    ret  = denom[didx];
              }              
              if (r > 0) {                 
                ret += ' '+getCifraEnTexto(r);  
              }
              if(r == 0 && val >= 1000000)
                return ret+' DE ';  
              else
                return ret;  
             }  
          }
          return null;  
    	}
        public string convertirDosCifrasEnTexto(Long val){                
            if (val < 20)  
                return to_19[(Integer) val];  
            if(val == 100)  
                return 'CIEN';  
            
            for (integer v = 0; v < tens.size(); v++) {  
                String dcap = tens[v];  
                integer dval = 20 + 10 * v;  
                if (dval + 10 > val) {  
                    if (Math.Mod(val,10) != 0){  
                        if(dcap == 'VEINTE'){
                            dcap = 'VEINTI';
                            return dcap + '' + to_19[Math.Mod((Integer)val,10)];  
                        }else
                            return dcap + ' Y ' + to_19[Math.Mod((Integer)val,10)];  
                    }
                    return dcap;  
                }
            }        
            return null;
        }    
        public String convertirTresCifrasEnTexto(long val){  
          String word = '';  
          long rem = val / 100;  
          long mod = Math.mod(val,100);  
          if (rem > 0) {  
              if(val < 200){
                  if(val == 100)
                    word = 'CIEN';
                  else
                    word = 'CIENTO';
              }else{
                  if(to_19[(integer)rem] == 'CINCO')
                    word = 'QUINIENTOS';
                  else if(to_19[(integer)rem] == 'SIETE')
                    word = 'SETECIENTOS';
                  else if(to_19[(integer)rem] == 'NUEVE')
                    word = 'NOVECIENTOS';
                  else
                    word = to_19[(integer)rem] + 'CIENTOS';  
               }
           	   if (mod > 0) {  
               		word += ' ';  
               }  
          }  
          if (mod > 0) {          
            word += convertirDosCifrasEnTexto(mod);
          }  
          return word;  
        }
    }   
}