/**
 * @description       :
 * @author            : Harlinsson Chavarro (HCH)
 * @group             :
 * @last modified on  : 03-29-2022
 * @last modified by  : j.martinez.mercado
 * Modifications Log
 * Ver   Date         Author                        Modification
 * 1.0   02-04-2021   Harlinsson Chavarro (HCH)     Initial Version
 * 1.0   14-04-2021   Rodrigo (RDC)                 keepAlive
 * 1.1   03-29-2022   Juan Camilo Villegas          Se agrega mapeo de campo de tecnología 
 **/
public class DEG_ConsumeOrquestadorHelper_cls{
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
		WrpAnalize objAnalize = new WrpAnalize();
		String response = '';
		List<WrapMensaje> messageLst = deserealizeBody(bodyRptaMessage, sessionId, tokenWatson, idTranscript);
		
		for(WrapMensaje message:messageLst){
			if(message.esMsn)
			{
				response = (response == '' ? '' : response+'\n') + message.mensaje;				
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
			//new
			// if (message.colaMensajeria != '') {
				// String cola = message.colaMensajeria;
				// cola = cola.replace('ColaMensajeria_', '');
				// cola = cola.replace('_', ' ');
			// 	objAnalize.colaUsuario = cola;
			// }
			//--
        }
		if(pasoAgent){
			messageLst.add(new WrapMensaje('99', System.Label.DEG_MensajePasoAgente, 'Message', true, false));
		}

		objAnalize.strJSON = JSON.serialize(messageLst);
		objAnalize.strHumanFriendly = response;
		objAnalize.messageLst = messageLst;
		objAnalize.pasoAgente = pasoAgent;
		objAnalize.motivoContacto = motivoContacto;
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
	public static List<WrapMensaje> deserealizeBody(DEG_WrapperJSONBot_cls.responseMessage bodyRptaMessage, String sessionId, String tokenWatson, String idTranscript){
		List<String> messageLstEnd = new List<String>();
		List<String> messageTempLst = new List<String>();
		List<String> lstCadena = new List<String>();
		List<String> lstBoton = new List<String>();
		List<String> lstCadenaFinal = new List<String>();
		List<String> splitPipeTextLst = new List<String>();
		List<WrapMensaje> messageLst = new List<WrapMensaje>();
		List<String> datesLst = new List<String>();
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
		String sintaxisFueradeHorario = 'FueradeHorario';
		String sintaxisInfoGeneral = 'InfoGeneral';
		Integer iContador = 1;
		// String carryLine = '/\r?\n|\r/g,';
		System.debug('##bodyRptaMessage ' + bodyRptaMessage);
		if (bodyRptaMessage.data != null && bodyRptaMessage.data.messages != null && !bodyRptaMessage.data.messages.isEmpty()){
			List<LiveChatTranscript> listaCambioCola = new List<LiveChatTranscript>();
			for (DEG_WrapperJSONBot_cls.rptaMessage msj : bodyRptaMessage.data.messages){
				message = msj.text;
				//message != null &&  (test by avoid more cpu limit) // sometimes message is null!
				if (message != null && message != '' && msj.response_type == 'text'){
					//Evita que los datos recuperados queden en la lista de menjaes
					message = message.replaceAll('\r\n|\n|\r', ' '); //message.replace(carryLine, '');
					if (message.contains(sintaxisFueradeHorario)){
						
						isFueradeHorario = true;
                        
                		System.debug('If sintaxisFueradeHorario imprime motivoFueradeHorario ' + motivoPasoAgente);
					}
					//It contains pipe, so this part do the split for each message
					if (message.contains(sintaxisMotivoContacto)){
						motivoContacto = getMotivo(message);
					}
					if (message.contains(sintaxisPasoAgente)){
						pasoAgent = true;
						motivoPasoAgente = getMotivo(message);
					}
					//JSON que envía información de la tecnología y segmento del cliente a través del orquestador 
					General segmentoTecno  = new General();
					if(message.contains(sintaxisInfoGeneral)){
						segmentoTecno  = (General)JSON.deserialize(message,General.class);
						System.debug('message1:: '+message);
						if ( String.isEmpty(segmentoTecno.InfoGeneral.Tecnologia) || String.isEmpty(segmentoTecno.InfoGeneral.Segmento)){
							System.debug('message2:: '+message);
							InfoGeneral infoGen =  new InfoGeneral(segmentoTecno.InfoGeneral.Tecnologia, segmentoTecno.InfoGeneral.Segmento);						
							message = INFO_GENERAL+JSON.serialize(infoGen)+'}';
							System.debug('message3:: '+message);
						} 
						segmentoTecno  = (General)JSON.deserialize(message,General.class);
						Id idCase = [SELECT id, CaseId from LivechatTranscript WHERE id=:idTranscript LIMIT 1].CaseId; 
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
							if (msgPipeEach.contains(sintaxisVideo)){
								messageLst = getVideo(msgPipeEach, messageLst, sintaxisVideo, sintaxisCardTrue, iContador);
							} else if (msgPipeEach.contains(sintaxisBtnEnlace)){
								messageLst = getBtnEnlace(msgPipeEach, messageLst, sintaxisBtnEnlace, sintaxisCardTrue, iContador);
							} else if (msgPipeEach.contains(sintaxisImage)){
								messageLst = getImage(msgPipeEach, messageLst, sintaxisImage, sintaxisCardTrue, iContador);
							} else if (msgPipeEach.contains(sintaxisBtnSeleccion)){
								/*//Get only botones de Selección in a List
								 Boolean blnAsk = false;
								 if (msgPipeEach.contains('?')){
								 blnAsk = true;
								 messageLst.add(new WrapMensaje(String.valueOf(iContador), getSplitText('¿', '?', msgPipeEach, 1, sintaxisBtnSeleccion), 'msn', true, false));
								 }
								 iContador = blnAsk ? iContador++ : iContador;
								 */
								String msjPrevio = msgPipeEach.split('\\(\\(')[0];
								if (msjPrevio != null && msjPrevio != ''){
									messageLst.add(new WrapMensaje(String.valueOf(iContador), msjPrevio, 'msn', true, false));
									iContador++;
								}
								lstBoton = splitBotones(msgPipeEach, sintaxisBtnSeleccion);
								messageLst.add(new WrapMensaje(String.valueOf(iContador), lstBoton, 'btn', false, true));
							} else if (msgPipeEach.contains(sintaxisBtnSugerencia)){
								/*/Get only botones de Selección in a List
								 Boolean blnAsk = false;
								 if (msgPipeEach.contains('?')){
								 blnAsk = true;
								 messageLst.add(new WrapMensaje(String.valueOf(iContador), getSplitText('¿', '?', msgPipeEach, 1, sintaxisBtnSugerencia), 'msn', true, false));
								 }
								 iContador = blnAsk ? iContador++ : iContador;
								 */

								String msjPrevio = msgPipeEach.split('\\(\\(')[0];
								if (msjPrevio != null && msjPrevio != ''){
									messageLst.add(new WrapMensaje(String.valueOf(iContador), msjPrevio, 'msn', true, false));
									iContador++;
								}

								lstBoton = splitBotones(msgPipeEach, sintaxisBtnSugerencia);
								messageLst.add(new WrapMensaje(String.valueOf(iContador), lstBoton, 'btn', false, true));
							} else{
								messageLst.add(new WrapMensaje(String.valueOf(iContador), msgPipeEach, 'msn', true, false));
							}
						}
					} else{
						//here is when message haven't pipe
						if (!message.contains(sintaxisDatosRecup) && !message.contains(sintaxisPasoAgente) && !message.contains(sintaxisVideo) && !message.contains(sintaxisBtnSeleccion) && !message.contains(sintaxisBtnSugerencia) && !message.contains(sintaxisBtnEnlace) && !message.contains(sintaxisImage) && !message.contains(sintaxisMotivoContacto) && !message.contains('ColaMensajeria')&& !message.contains(sintaxisFueradeHorario) && !message.contains(sintaxisInfoGeneral)){
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
							//Get only botones de Selección in a List
							/*Boolean blnAsk = false;
							 if (message.contains('?')){
							 blnAsk = true;
							 messageLst.add(new WrapMensaje(String.valueOf(iContador), getSplitText('¿', '?', message, 1, sintaxisBtnSeleccion), 'msn', true, false));
							 }
							 iContador = blnAsk ? iContador++ : iContador;
							 */
							String msjPrevio = message.split('\\(\\(')[0];
							if (msjPrevio != null && msjPrevio != ''){
								messageLst.add(new WrapMensaje(String.valueOf(iContador), msjPrevio, 'msn', true, false));
								iContador++;
							}

							lstBoton = splitBotones(message, sintaxisBtnSeleccion);
							messageLst.add(new WrapMensaje(String.valueOf(iContador), lstBoton, 'btn', false, true));
						} else if (message.contains(sintaxisBtnSugerencia)){
							//Get only botones de Selección in a List
							/*
							 Boolean blnAsk = false;
							 if (message.contains('?')){
							 blnAsk = true;
							 messageLst.add(new WrapMensaje(String.valueOf(iContador), getSplitText('¿', '?', message, 1, sintaxisBtnSugerencia), 'msn', true, false));
							 }*/
							//get previus message in case of WhatsApp or Facebook Text
							String msjPrevio = message.split('\\(\\(')[0];
							if (msjPrevio != null && msjPrevio != ''){
								messageLst.add(new WrapMensaje(String.valueOf(iContador), msjPrevio, 'msn', true, false));
								iContador++;
							}
							lstBoton = splitBotones(message, sintaxisBtnSugerencia);
							messageLst.add(new WrapMensaje(String.valueOf(iContador), lstBoton, 'btn', false, true));

						} 
						// else if (message.contains('ColaMensajeria')){
						// 	String cola = message;
						// 	cola = cola.replace('ColaMensajeria_', '');
						// 	cola = cola.replace('_', ' ');
						// 	// List<LiveChatTranscript> chatCola = [	SELECT Id, DEG_Cola_Mensajeria__c 
						// 	// 										FROM LiveChatTranscript 
						// 	// 										WHERE Id =: idTranscript 
						// 	// 										LIMIT 1];
						// 	// chatCola[0].DEG_Cola_Mensajeria__c = cola;
						// 	// listaCambioCola = chatCola;
						// 	// Map<String, Object> Params = new Map<String, Object>();
						// 	// Params.put('LiveChat', chatCola[0]);
						// 	// Flow.Interview.Cambiar_Cola flujoCambiarCola = new Flow.Interview.Cambiar_Cola(Params);
						// 	// flujoCambiarCola.start();
						// 	// messageLst.add(new WrapMensaje(String.valueOf(iContador), chatCola[0].DEG_Cola_Mensajeria__c, 'msn', true, false));
						// }
					}
					iContador++;
				} else if (msj.response_type == 'event' && msj.id != null && msj.id != ''){
					if (msj.id == 'autenticacion'){
						messageLst.add(new WrapMensaje(String.valueOf(iContador), msj.id));
					}
					else if (msj.id == 'autenticacion_empresas'){
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
			// if (listaCambioCola.size() > 0) {
			// 	update listaCambioCola;
			// }
		}
		if (bodyRptaMessage.meta != null  && bodyRptaMessage.meta.status != null && bodyRptaMessage.meta.status == '202' ){
			WrapMensaje wrapMensaje = new WrapMensaje();
			wrapMensaje.waitForDB = true;
			messageLst.add(wrapMensaje);
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
			sText=getKeyWords(sText);
		}
		return sText;
	}


	/*---------------------------------------------------------------------------------------------
	 Autor:Diego Alejandro Rico(DARF)
	 Descripción:
	 @params: -----
	 @return: -----
	 ----------------------------------------------------------------------------------------------*/
	public static String getKeyWords(string strMoti){
		string strRtunr;
		boolean blnChange=false;
		Falla_Tecnica__mdt objMdt =([SELECT ID,DE_Palabra_Clave__c,DEG_Opciones_de_Watson__c,developername FROM Falla_Tecnica__mdt 
                             WHERE developername =:'DEG_Soporte_tecnico_masivos' limit 1]);
		wrpKeyWords objwp=(wrpKeyWords)json.deserialize(objMdt.DEG_Opciones_de_Watson__c,wrpKeyWords.class);
		system.debug(objwp);
		system.debug(objMdt);
		system.debug(objMdt.DEG_Opciones_de_Watson__c);
		for(string objstr:objwp.palabrasclave){
			string sText=objstr;
			sText =sText.contains('_')?sText.replace('_', ' '):sText;
			system.debug('objstr=>'+objstr);
			system.debug('sText=>'+sText);
            if(sText==strMoti){
                return objMdt.DE_Palabra_Clave__c+'|'+strMoti;
            }
		}
		return strMoti;
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
			System.debug('No contains , in video text please add');
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
			System.debug(lstSplitComa);
			for (String textComa : lstSplitComa){
				textComa = textComa.contains(sintaxisBtnEnlace) ? textComa.replace(sintaxisBtnEnlace, ':') : textComa;
				textComa = textComa.contains('))') ? textComa.remove('))') : textComa;
				textComa = textComa.contains(sintaxisCardTrue) ? textComa.remove(sintaxisCardTrue) : textComa;
				textComa = textComa.trim();
				lstTextosTemp.add(textComa);
			}
			System.debug('split?'+lstSplitComa);
			if (lstTextosTemp[0].contains(':')){
				lstTextos2Point = lstTextosTemp[0].split(':');
				//lstTextos.add(lstTextos2Point[1]);
				lstTextosTemp[0] = lstTextos2Point[1];
			}
			lstTextos.addAll(lstTextosTemp);
		} else{
			System.debug('No contains , in btn enlace text please add');
		}
		System.debug('##lstTextos++ ' + lstTextos);
		messageLst.add(new WrapMensaje(String.valueOf(cont), lstTextos, 'btnLink'));
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
			System.debug('No contains , in image text please add');
		}
		System.debug('valores contador?'+String.valueOf(cont)+' lista '+lstTextos);

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
		public String palabraClaveMotivoAgente;
		public String motivo;
		//new
		public String colaUsuario;
		//--
		public Boolean contacto;
		public String motivoContacto;
		public String strJSON;
		public String strHumanFriendly;
		public Boolean evento;
		public List<WrapMensaje> messageLst;
		public Boolean isFueradeHorario;

		public WrpAnalize(){
			this.pasoAgente = false;
			this.palabraClaveMotivoAgente = '';
			this.contacto = false;
			//new
			this.colaUsuario = '';
			//--
			this.strJSON = '';
			this.motivo = '';
			this.motivoContacto = null;
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
		public String tokenWatson;
		public String sessionIdWatson;
		//new
		// public String colaMensajeria;
		//--
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
			//new
			// this.colaMensajeria = '';
			//--
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
				System.debug('##lmensaje++ ' + lMensaje);
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

	public class wrpKeyWords{
		public list<String> palabrasClave;
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