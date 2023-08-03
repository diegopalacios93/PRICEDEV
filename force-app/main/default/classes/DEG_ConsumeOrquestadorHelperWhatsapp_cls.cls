public class DEG_ConsumeOrquestadorHelperWhatsapp_cls{
	public static Boolean pasoAgent = false;
	public static String motivoPasoAgente = '';
	public static String motivoContacto = '';
	public static Boolean isFueradeHorario = false;
	public static final String INFO_GENERAL = '{"InfoGeneral":';
	public static final String NO_APLICA = 'No Aplica';
	/*---------------------------------------------------------------------------------------------
	 Autor:
	 Descripción:
	 @params: -----
	 @return: -----
	 ----------------------------------------------------------------------------------------------*/
	public static WrpAnalize manageDeserealizeBody(DEG_WrapperJSONBot_cls.responseMessage bodyRptaMessage, String sessionId, String tokenWatson, String idTranscript){
		System.debug('##idTranscript' + idTranscript);
		WrpAnalize objAnalize = new WrpAnalize();
		String response = '';
		List<WrapMensaje> messageLst = deserealizeBody(bodyRptaMessage, sessionId, tokenWatson, idTranscript);
		
		for(WrapMensaje message:messageLst){
			if(message.esMsn)
			{
				response = (response == '' ? '' : response+'\n') +message.mensaje;
			}
		}

		for(WrapMensaje message:messageLst){
            if(message.idEvent != null && message.idEvent != '' && !pasoAgent ){
				objAnalize.evento = true;
				WrapMensaje wrapMensaje = new WrapMensaje();
				wrapMensaje.waitForDB = true;
                messageLst.add(wrapMensaje);
                break;
            }
        }
		if(pasoAgent){
			messageLst.add(new WrapMensaje('99', '', 'Message', true, false));
		}

		objAnalize.strJSON = JSON.serialize(messageLst);
		objAnalize.strHumanFriendly = response;
		objAnalize.messageLst = messageLst;
		objAnalize.pasoAgente = pasoAgent;
		objAnalize.motivoContacto = motivoContacto;
		system.debug('objAnalize.motivoContacto :'+objAnalize.motivoContacto );
        system.debug('objAnalize.strJSON :'+objAnalize.strJSON );
        system.debug('objAnalize.messageLst :'+objAnalize.messageLst );
        system.debug('objAnalize.pasoAgente :'+objAnalize.pasoAgente );
        
		if (motivoPasoAgente != '' && motivoPasoAgente.contains('|')){
			objAnalize.motivo = motivoPasoAgente.substringBefore('|'); 
			objAnalize.palabraClaveMotivoAgente = motivoPasoAgente.substringAfter('|'); 
		} else {
			objAnalize.motivo = motivoPasoAgente;	
		}
		if (isFueradeHorario){
			objAnalize.isFueradeHorario = isFueradeHorario;
		}
		System.debug('##objAnalize ' + objAnalize);
		return objAnalize;
	}

	/*---------------------------------------------------------------------------------------------
	 Autor:
	 Descripción:
	 @params: -----
	 @return: -----
	 ----------------------------------------------------------------------------------------------*/
	 public static String removeCharacter(String sText){
		if (sText.contains('_')){
			sText = motivoPasoAgente.substringAfter('_');
		}
		return sText;
	}
	/*---------------------------------------------------------------------------------------------
	 Autor:
	 Descripción:
	 @params: -----
	 @return: -----
	 ----------------------------------------------------------------------------------------------*/
	public static List<WrapMensaje> deserealizeBody(DEG_WrapperJSONBot_cls.responseMessage bodyRptaMessage, String sessionId, String tokenWatson, String idTranscript){
		List<String> messageLstEnd = new List<String>();
		List<String> messageTempLst = new List<String>();
		List<String> lstCadena = new List<String>();
		List<String> lstBoton = new List<String>();
		List<String> lstCadenaFinal = new List<String>();
		List<String> splitPipeTextLst = new List<String>();
		List<WrapMensaje> messageLst = new List<WrapMensaje>();
        List<String> infoUsuario = new List<String>();
		List<String> datesLst = new List<String>();
        List<MessagingSession> msgSessionLst = new List<MessagingSession>();
		//Para poder hacer el split a toda la lista de mensajes así({respnosetype,text})
		String message = '';
		String sintaxisVideo = '((video';
		String sintaxisPipe = '||';
		String sintaxisBtnEnlace = '((boton enlace:';
		String sintaxisBtnSeleccion = '((botones seleccion:';
		String sintaxisBtnSugerencia = '((botones sugerencia:';
		String sintaxisPasoAgente = 'PasoAgente';
		String sintaxisMotivoContacto = 'MotivoContacto';
		String sintaxisDatosRecup = 'Datos recuperados:';
		String sintaxisCardTrue = '{card:true}';
		String sintaxisImage = '((imagen';
        String sintaxisInfoUsuario = 'INFOUSUARIO_';
		String sintaxisFueradeHorario = 'FueradeHorario';
		String sintaxisInfoGeneral = 'InfoGeneral';
		Integer iContador = 1;
		// String carryLine = '/\r?\n|\r/g,';
		System.debug('##bodyRptaMessage ' + bodyRptaMessage);
		if (bodyRptaMessage.data != null && bodyRptaMessage.data.messages != null && !bodyRptaMessage.data.messages.isEmpty()){
			for (DEG_WrapperJSONBot_cls.rptaMessage msj : bodyRptaMessage.data.messages){
				System.debug('bodyRptaMessage.data.messages '+bodyRptaMessage.data.messages);
				message = msj.text;
                System.debug('message = msj.text ' + message);
				//message != null &&  (test by avoid more cpu limit) // sometimes message is null!
				if (message != null && msj.response_type == 'text'){
                    //&& message != ''
                	System.debug('If msj.response_type ' + msj.response_type);
					//Evita que los datos recuperados queden en la lista de menjaes
					message = message.replaceAll('\r\n|\n|\r', ' '); //message.replace(carryLine, '');
					System.debug('##message' + message);
					// nuevo 
					if (message.contains(sintaxisFueradeHorario)){
						isFueradeHorario = true;
                		System.debug('If sintaxisFueradeHorario imprime motivoFueradeHorario ' + isFueradeHorario);
                    }
					//It contains pipe, so this part do the split for each message
					if (message.contains(sintaxisPasoAgente)){
						pasoAgent = true;
						motivoPasoAgente = getMotivo(message);
                        
                		System.debug('If sintaxisPasoAgente imprime motivoPasoAgente ' + motivoPasoAgente);
                    }
                    system.debug('motivoContacto antes: '+motivoContacto);
					if (message.contains(sintaxisMotivoContacto)){
							motivoContacto = getMotivo(message);
						}	
						system.debug('motivoContacto despues: '+motivoContacto);
					
					//JSON que envía información de la tecnología y segmento del cliente a través del orquestador 
					General segmentoTecno  = new General();
					if(message.contains(sintaxisInfoGeneral)){
						segmentoTecno  = (General)JSON.deserialize(message,General.class);
						if ( String.isEmpty(segmentoTecno.InfoGeneral.Tecnologia) || String.isEmpty(segmentoTecno.InfoGeneral.Segmento)){
							InfoGeneral infoGen =  new InfoGeneral(segmentoTecno.InfoGeneral.Tecnologia, segmentoTecno.InfoGeneral.Segmento);						
							message = INFO_GENERAL+JSON.serialize(infoGen)+'}';
						} 
						segmentoTecno  = (General)JSON.deserialize(message,General.class);
						Id idCase = [SELECT id, CaseId from MessagingSession WHERE id=:idTranscript LIMIT 1].CaseId; 
						List<Case> cs = [SELECT id,CaseNumber, DEG_Tecnologia__c from Case WHERE Id =:idCase LIMIT 1];
						if(cs.size()>0){
							cs[0].DEG_Tecnologia__c = (!String.isEmpty(segmentoTecno.InfoGeneral.Tecnologia))?segmentoTecno.InfoGeneral.Tecnologia:NO_APLICA;
							cs[0].DEG_Segmento__c = (segmentoTecno.InfoGeneral.Segmento=='Hogares')?'Masivo':segmentoTecno.InfoGeneral.Segmento;
							System.debug('ingreso al if de tecnologia '+ cs[0].DEG_Tecnologia__c);
							update cs;
						}
					}					
					if (message.contains(sintaxisPipe)){
						splitPipeTextLst = splitPipeText(message, splitPipeTextLst);
						for (String msgPipeEach : splitPipeTextLst){ 					
                            System.debug('##message' + splitPipeTextLst);
                            
							if (msgPipeEach.contains(sintaxisVideo)){
								messageLst = getVideo(msgPipeEach, messageLst, sintaxisVideo, sintaxisCardTrue, iContador);
							} else if (msgPipeEach.contains(sintaxisBtnEnlace)){
								messageLst = getBtnEnlace(msgPipeEach, messageLst, sintaxisBtnEnlace, sintaxisCardTrue, iContador);
							} else if (msgPipeEach.contains(sintaxisImage)){
								messageLst = getImage(msgPipeEach, messageLst, sintaxisImage, sintaxisCardTrue, iContador);
							} else if (msgPipeEach.contains(sintaxisBtnSeleccion)){
								String msjPrevio = msgPipeEach.split('\\(\\(')[0];
								if (msjPrevio != null && msjPrevio != ''){
									messageLst.add(new WrapMensaje(String.valueOf(iContador), msjPrevio, 'msn', true, false));
									iContador++;
								}
								lstBoton = splitBotones(msgPipeEach, sintaxisBtnSeleccion);
								messageLst.add(new WrapMensaje(String.valueOf(iContador), lstBoton, 'btn', false, true));
							} else if (msgPipeEach.contains(sintaxisBtnSugerencia)){
								String msjPrevio = msgPipeEach.split('\\(\\(')[0];
								if (msjPrevio != null && msjPrevio != ''){
									messageLst.add(new WrapMensaje(String.valueOf(iContador), msjPrevio, 'msn', true, false));
									iContador++;
								}

								lstBoton = splitBotones(msgPipeEach, sintaxisBtnSugerencia);
								messageLst.add(new WrapMensaje(String.valueOf(iContador), lstBoton, 'btn', false, true));
							}else{
								messageLst.add(new WrapMensaje(String.valueOf(iContador), msgPipeEach, 'msn', true, false));
							}
						}
						/*if (message.contains('&#124;&#124;')){
							System.debug('##viewMessage' + message);
							List<String> auxLst = message.split('&#124;&#124;');
							String aux = auxLst[0] + '\n' + auxLst[1];
							messageLst.add(new WrapMensaje(String.valueOf(iContador), aux, 'msn', true, false));
						}*/
					} else{
						//here is when message haven't pipe
						if (!message.contains(sintaxisDatosRecup) && !message.contains(sintaxisPasoAgente) && !message.contains(sintaxisVideo) && !message.contains(sintaxisBtnSeleccion) && !message.contains(sintaxisBtnSugerencia) && !message.contains(sintaxisBtnEnlace) && !message.contains(sintaxisImage) && !message.contains(sintaxisInfoUsuario) && !message.contains(sintaxisMotivoContacto) && !message.contains(sintaxisFueradeHorario) && !message.contains(sintaxisInfoGeneral)){
							 
							System.debug('##viewMessage' + message);
							messageLst.add(new WrapMensaje(String.valueOf(iContador), message, 'msn', true, false));
						} else if (message.contains(sintaxisVideo)){
							//only for video
							messageLst = getVideo(message, messageLst, sintaxisVideo, sintaxisCardTrue, iContador);
						} else if (message.contains(sintaxisBtnEnlace)){
							//only for btnEnlace
							messageLst = getBtnEnlace(message, messageLst, sintaxisBtnEnlace, sintaxisCardTrue, iContador);
						} else if (message.contains(sintaxisImage)){
							//only for Image
							messageLst = getImage(message, messageLst, sintaxisImage, sintaxisCardTrue, iContador);
						} else if (message.contains(sintaxisBtnSeleccion)){
							String msjPrevio = message.split('\\(\\(')[0];
							if (msjPrevio != null && msjPrevio != ''){
								messageLst.add(new WrapMensaje(String.valueOf(iContador), msjPrevio, 'msn', true, false));
								iContador++;
							}

							lstBoton = splitBotones(message, sintaxisBtnSeleccion);
							messageLst.add(new WrapMensaje(String.valueOf(iContador), lstBoton, 'btn', false, true));
						} else if (message.contains(sintaxisBtnSugerencia)){
							String msjPrevio = message.split('\\(\\(')[0];
							if (msjPrevio != null && msjPrevio != ''){
								messageLst.add(new WrapMensaje(String.valueOf(iContador), msjPrevio, 'msn', true, false));
								iContador++;
							}
							lstBoton = splitBotones(message, sintaxisBtnSugerencia);
							messageLst.add(new WrapMensaje(String.valueOf(iContador), lstBoton, 'btn', false, true));
						} else if(message.contains(sintaxisInfoUsuario)){
                            message = message.substringAfter(sintaxisInfoUsuario);
                            infoUsuario = message.split('::');
                        }
					}
					iContador++;
				} else if (msj.response_type == 'event' && msj.id != null && msj.id != ''){
					if (msj.id == 'autenticacion'){
						messageLst.add(new WrapMensaje(String.valueOf(iContador), msj.id));
					} else if (msj.id == 'rango_fechas'){
						messageLst.add(new WrapMensaje(String.valueOf(iContador), msj.id, msj.dias, new List<String>()));
					} else if (msj.id == 'calendario_web'){
						if (msj.dias_permitidos != null){
							for (DEG_WrapperJSONBot_cls.calendarDays day : msj.dias_permitidos){
								datesLst.add(day.fecha);
							}
						}
						messageLst.add(new WrapMensaje(String.valueOf(iContador), msj.id, msj.dias, datesLst));
					} else if (msj.url != null && msj.url != ''){
						if (msj.url.contains('http')){
							messageLst.add(new WrapMensaje(String.valueOf(iContador), msj.id, msj.url));
						}
					}
					iContador++; //validate if i need this one
				} else if (msj.response_type == 'event' && msj.closeIframe != null ){
					WrapMensaje wrapMessage = new WrapMensaje();
					wrapMessage.closeModal = msj.closeIframe;
					messageLst.add( wrapMessage );
				}
			}
		}
		if (bodyRptaMessage.meta != null  && bodyRptaMessage.meta.status != null && bodyRptaMessage.meta.status == '202' ){
			WrapMensaje wrapMensaje = new WrapMensaje();
			wrapMensaje.waitForDB = true;
			messageLst.add(wrapMensaje);
		}

        if( infoUsuario.size() > 0 ) {
            MessagingSession ms = [SELECT Id, DEG_ApellidoCliente__c, DEG_NombreCliente__c, DEG_TipoDocCliente__c, DEG_NumeroDocCliente__c, DEG_TelefonoCliente__c, DEG_EmailCliente__c FROM MessagingSession WHERE Id =: idTranscript LIMIT 1];

            ms.DEG_NombreCliente__c = infoUsuario[0];
            ms.DEG_ApellidoCliente__c = infoUsuario[1];
            ms.DEG_TelefonoCliente__c = infoUsuario[2];
            ms.DEG_NumeroDocCliente__c = infoUsuario[3];
            ms.DEG_TipoDocCliente__c = infoUsuario[4];
            ms.DEG_EmailCliente__c = infoUsuario[5];

            update ms;
        }

		system.debug('***getCpuTime() consume Helper***' + Limits.getCpuTime());

		return messageLst;
	}

	/*---------------------------------------------------------------------------------------------
	 Autor: Harlinsson Chavarro (HCH)
	 Descripción: for spliting if text has pipe in the string value
	 @params: -----
	 @return: -----
	 ----------------------------------------------------------------------------------------------*/
	public static List<String> splitPipeText(String sText, List<String> splitPipeTextLst){
		String pipeAscci = '&#124;&#124;';
		sText = stext.replace('||', pipeAscci);
		splitPipeTextLst = sText.split(pipeAscci);
		return splitPipeTextLst;
	}

	/*---------------------------------------------------------------------------------------------
	 Autor:
	 Descripción:
	 @params: -----
	 @return: -----
	 ----------------------------------------------------------------------------------------------*/
	public static List<String> splitBotones(String sText, String sTipoBoton){
		Integer posStart = sText.lastIndexOf('((');
		Integer posEnd = sText.IndexOf('))');
		String cadenaUno = sText.substring(posStart, posEnd);
		String cadenaDos = cadenaUno.remove(sTipoBoton);
		List<String> lstCadena = cadenaDos.split(';');
		return lstCadena;
	}

	/*---------------------------------------------------------------------------------------------
	 Autor:
	 Descripción:
	 @params: -----
	 @return: -----
	 ----------------------------------------------------------------------------------------------*/
	public static List<WrapMensaje> splitTextoDentroBotones(String sText, List<WrapMensaje> messageLst, String sTipoboton, Integer iContador){
		messageLst.add(new WrapMensaje(String.valueOf(iContador), getSplitText('¿', '?', sText, 1, sTipoBoton), 'msn', true, false));
		return messageLst;
	}

	/*---------------------------------------------------------------------------------------------
	 Autor:
	 Descripción:
	 @params: -----
	 @return: -----
	 ----------------------------------------------------------------------------------------------*/
	public static String getMotivo(String sText){
		if (sText.contains('_')){
			sText = sText.substringAfter('_');
			sText = sText.replace('_', ' ');
			sText=DEG_ConsumeOrquestadorHelper_cls.getKeyWords(sText);
            system.debug('Hola=>'+sText);
		}
		return sText;
	}

	/*---------------------------------------------------------------------------------------------
	 Autor:
	 Descripción: process video response
	 @params: -----
	 @return: -----
	 ----------------------------------------------------------------------------------------------*/
	public static List<WrapMensaje> getVideo(String sText, List<WrapMensaje> messageLst, String sintaxisVideo, String sintaxisCardTrue, Integer cont){
		List<String> lstSplitComa = new List<String>();
		List<String> lstTextos = new List<String>();
		List<String> lstTextosTemp = new List<String>();
		List<String> lstTextos2Point = new List<String>();
		if (sText.contains(':,')){
			lstSplitComa = sText.split(':,');
			for (String textComa : lstSplitComa){
				textComa = textComa.trim();
				textComa = textComa.contains(sintaxisVideo) ? textComa.remove(sintaxisVideo) : textComa;
				textComa = textComa.contains('))') ? textComa.remove('))') : textComa;
				textComa = textComa.contains(sintaxisCardTrue) ? textComa.remove(sintaxisCardTrue) : textComa;
				lstTextosTemp.add(textComa);
			}
			if (lstTextosTemp[0].contains(':')){
				lstTextos2Point = lstTextosTemp[0].split(':');
				lstTextos.addAll(lstTextos2Point);
			}
			lstTextos.add(lstTextosTemp[1].trim());
		} else{
			System.debug('No conatins , in video text please add');
		}
		messageLst.add(new WrapMensaje(String.valueOf(cont), lstTextos, 'video'));
		return messageLst;
	}

	/*---------------------------------------------------------------------------------------------
	 Autor:
	 Descripción: process botón enlace
	 @params: -----
	 @return: -----
	 ----------------------------------------------------------------------------------------------*/
	public static List<WrapMensaje> getBtnEnlace(String sText, List<WrapMensaje> messageLst, String sintaxisBtnEnlace, String sintaxisCardTrue, Integer cont){
		System.debug('getBtnEnlace stext'+sText);
		System.debug('getBtnEnlace message'+messageLst);
		System.debug('getBtnEnlace'+sintaxisBtnEnlace + ' ' + sintaxisCardTrue +' '+ cont);


		Pattern p = Pattern.compile('(.*)(\\(\\(.*\\)\\))(.*)');
		Matcher pm = p.matcher(sText);

		String textoAntesdeBoton = '';
		String textoBoton = '';

		if( pm.matches() ){
			textoAntesdeBoton = pm.group(1);
			sText = pm.group(2);
		}
		if ( textoAntesdeBoton != null && textoAntesdeBoton != ''){
			messageLst.add(new WrapMensaje(String.valueOf(cont), textoAntesdeBoton, 'msn', true, false));
			cont++;
		}
		System.debug(textoAntesdeBoton);

		List<String> lstSplitComa = new List<String>();
		List<String> lstTextos = new List<String>();
		List<String> lstTextosTemp = new List<String>();
		List<String> lstTextos2Point = new List<String>();
		if (sText.contains(',')){
			lstSplitComa = sText.split(',');
			for (String textComa : lstSplitComa){
				textComa = textComa.contains(sintaxisBtnEnlace) ? textComa.replace(sintaxisBtnEnlace, ':') : textComa;
				textComa = textComa.contains('))') ? textComa.remove('))') : textComa;
				textComa = textComa.contains(sintaxisCardTrue) ? textComa.remove(sintaxisCardTrue) : textComa;
				textComa = textComa.trim();
				lstTextosTemp.add(textComa);
			}
			if (lstTextosTemp[0].contains(':')){
				lstTextos2Point = lstTextosTemp[0].split(':');
				lstTextos.addAll(lstTextos2Point);
			}
			lstTextos.add(lstTextosTemp[1]);
		} else{
			System.debug('No conatins , in btn enlace text please add');
		}
		messageLst.add(new WrapMensaje(String.valueOf(cont), lstTextos, 'btnLink'));
		System.debug('messageLst ' + messageLst );
		return messageLst;
	}

	/*---------------------------------------------------------------------------------------------
	 Autor: Harlinsson Chavarro (HCH)
	 Descripción: process Image response
	 @params: -----
	 @return: -----
	 ----------------------------------------------------------------------------------------------*/
	public static List<WrapMensaje> getImage(String sText, List<WrapMensaje> messageLst, String sintaxisImage, String sintaxisCardTrue, Integer cont){
		List<String> lstSplitPoint = new List<String>();
		List<String> lstTextos2Point = new List<String>();
		List<String> lstTextos = new List<String>();
		List<String> lstTextosTemp = new List<String>();
		if (sText.contains(':,')){
			lstSplitPoint = sText.split(':,');
			for (String textComa : lstSplitPoint){
				textComa = textComa.contains(sintaxisImage) ? textComa.remove(sintaxisImage) : textComa;
				textComa = textComa.contains('))') ? textComa.remove('))') : textComa;
				textComa = textComa.contains(sintaxisCardTrue) ? textComa.remove(sintaxisCardTrue) : textComa;
				textComa = textComa.trim();
				lstTextosTemp.add(textComa);
			}
			if (lstTextosTemp[0].contains(':')){
				lstTextos2Point = lstTextosTemp[0].split(':');
				lstTextos.addAll(lstTextos2Point);
			}
			lstTextos.add(lstTextosTemp[1]);
		} else{
			System.debug('No conatins , in image text please add');
		}
		messageLst.add(new WrapMensaje(String.valueOf(cont), lstTextos, 'image'));
		return messageLst;
	}

	/*---------------------------------------------------------------------------------------------
	 Autor: Harlinsson Chavarro (HCH)
	 Descripción: Metodo para tratar los texto de la rpta de Watson Bot
	 @params: -----
	 @return: -----
	 ----------------------------------------------------------------------------------------------*/
	public static List<String> getSplitText(String charStart, String CharEnd, String text, Integer pos, String remove){
		List<String> lstSplits = new List<String>();
		Integer posStart = text.lastIndexOf(charStart);
		Integer posEnd = text.IndexOf(CharEnd);
		String cadena = text.substring(posStart, posEnd + pos);
		cadena = cadena.remove(remove);
		lstSplits = cadena.split(';');
		return lstSplits;
	}

	/*---------------------------------------------------------------------------------------------
	 Autor: Harlinsson Chavarro (HCH)
	 Descripción: Return rpta con paso agenta y json con todos los mensajes.
	 @params: -----
	 @return: -----
	 ----------------------------------------------------------------------------------------------*/
	public class WrpAnalize{
		public Boolean pasoAgente;
		public String motivo;
		public String motivoContacto;
		public String palabraClaveMotivoAgente;
		public String strJSON;
		public String strHumanFriendly;
		public Boolean evento;
		public List<WrapMensaje> messageLst;
		public Boolean isFueradeHorario;


		public WrpAnalize(){
			this.pasoAgente = false;
			this.strJSON = '';
			this.motivo = '';
			this.motivoContacto = '';
			this.palabraClaveMotivoAgente = '';
			this.evento = false;
			this.isFueradeHorario = false;
			messageLst = new List<WrapMensaje>();
		}
	}

	/*---------------------------------------------------------------------------------------------
	 Autor:
	 Descripción:
	 @params: -----
	 @return: -----
	 ----------------------------------------------------------------------------------------------*/
	public class WrapMensaje{
		public String orden;
		public String mensaje;
		public List<String> mensajes;
		public String tipo;
		public String idEvent;
		public String urlEvent;
		public String days;
		public Integer tiempo = 0;
		public String tokenWatson;
		public String sessionIdWatson;
        public Boolean esData = false;
		public Boolean esMsn = false;
		public Boolean esBtn = false;
		public Boolean esVideo = false;
		public Boolean esImage = false;
		public Boolean esBtnLink = false;
		public Boolean waitForDB = false;
		public Boolean closeModal = false;
		public List<WrpImage> imageLst;
		public List<WrapBoton> lBotones;
		public List<WrapVideo> videoLst;
		public List<WrpBtnEnlace> btnLinkLst;
		public List<String> datesLst;

		public WrapMensaje(){
			this.orden = '';
			this.mensaje = '';
			this.tipo = '';
			this.idEvent = '';
			this.tokenWatson = '';
			this.sessionIdWatson = '';
			this.tiempo = 0;
            this.esData = false;
			this.esMsn = false;
			this.esBtn = false;
			this.esBtnLink = false;
			this.esVideo = false;
			this.esImage = false;
			this.lBotones = new List<WrapBoton>();
			this.videoLst = new List<WrapVideo>();
			this.btnLinkLst = new List<WrpBtnEnlace>();
			this.imageLst = new List<WrpImage>();
			this.datesLst = new List<String>();
			this.waitForDB=false;
			this.closeModal = false;
		}

		public WrapMensaje(String sOrden, String sMensaje, String sTipo, Boolean blMsn, Boolean blBtn){
			this.orden = sOrden;
			this.mensaje = sMensaje;
			this.tipo = sTipo;
			this.esMsn = blMsn;
			this.esBtn = blBtn;
		}

		public WrapMensaje(String sOrden, List<String> lMensaje, String sTipo, Boolean blMsn, Boolean blBtn){
			this.orden = sOrden;
			this.tipo = sTipo;
			this.esMsn = blMsn;
			this.esBtn = blBtn;

			if (blBtn){
				this.lBotones = new List<WrapBoton>();
				for (String sBtn : lMensaje){
					this.lBotones.add(new WrapBoton(sBtn.trim()));
				}
			} else{
				this.mensaje = string.join(lMensaje, '\n'); //lMensaje.toString();
			}
		}

		//for video or btnEnlace
		public WrapMensaje(String sOrden, List<String> lMensaje, String sTipo){
			this.orden = sOrden;
			this.tipo = sTipo;
			if (sTipo == 'video'){
				this.videoLst = new List<WrapVideo>();
				this.esVideo = true;
				for (String text : lMensaje){
					this.videoLst.add(new WrapVideo(text, text.contains('https') ? text : lMensaje[2]));
				}
			} else if (sTipo == 'btnLink'){
				this.btnLinkLst = new List<WrpBtnEnlace>();
				this.esBtnLink = true;
				this.esMsn = true;
				if (lMensaje.size() == 2){
					this.mensaje = lMensaje[0] +': ' +  lMensaje[1];
					this.btnLinkLst.add(new WrpBtnEnlace(lMensaje[0], lMensaje[1]));
				} else{
					this.mensaje = lMensaje[1] +': ' +  lMensaje[2];
					this.btnLinkLst.add(new WrpBtnEnlace(lMensaje[1], lMensaje[2]));
				}
			} else if (sTipo == 'image'){
				this.imageLst = new List<WrpImage>();
				this.esImage = true;
				for (String text : lMensaje){
					this.imageLst.add(new WrpImage(text, text.contains('https') ? text : lMensaje[1]));
				}
			}
		}

		public WrapMensaje( //for event calendar
		String sOrden, String idEvent, String days, List<String> datesLst){
			this.orden = sOrden;
			this.idEvent = idEvent;
			this.days = days;
			this.datesLst = datesLst;
		}

		public WrapMensaje(String sOrden, String idEvent, String urlEvent){
			//for frames
			this.orden = sOrden;
			this.idEvent = idEvent;
			this.urlEvent = urlEvent;
		}

		public WrapMensaje(String sOrden, String idEvent){
			//for Autenticacion
			this.orden = sOrden;
			this.idEvent = idEvent;
		}
	}

	public class WrapBoton{
		public String texto;

		public WrapBoton(){
			this.texto = '';
		}

		public WrapBoton(String sTexto){
			this.texto = sTexto;
		}
	}

	//for saving video response
	public class WrapVideo{
		public String texto;
		public String url;

		public WrapVideo(){
			this.texto = '';
			this.url = '';
		}

		public WrapVideo(String sTexto, String url){
			this.texto = sTexto;
			this.url = url;
		}
	}

	//for saving btn enlace response
	public class WrpBtnEnlace{
		public String texto;
		public String url;

		public WrpBtnEnlace(){
			this.texto = '';
			this.url = '';
		}

		public WrpBtnEnlace(String sTexto, String url){
			this.texto = sTexto;
			this.url = url;
		}
	}

	//for saving image response
	public class WrpImage{
		public String texto;
		public String url;

		public WrpImage(){
			this.texto = '';
			this.url = '';
		}

		public WrpImage(String sTexto, String url){
			this.texto = sTexto;
			this.url = url;
		}
	}

	public class General {
        public InfoGeneral InfoGeneral {get;set;} 
    }
  
    public class InfoGeneral {
        public String Segmento {get;set;}
        public String Telefono {get;set;}
        public String Tecnologia {get;set;}
 		
        public InfoGeneral(String Tecnologia, String Segmento){
			this.Tecnologia = (!String.isEmpty(Tecnologia))?this.Tecnologia:NO_APLICA;
			this.Tecnologia = (!String.isEmpty(Tecnologia))?this.Segmento:'';
		}
    }

}