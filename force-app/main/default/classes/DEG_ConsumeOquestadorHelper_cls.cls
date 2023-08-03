/**
 * @description       :
 * @author            : Harlinsson Chavarro (HCH)
 * @group             :
 * @last modified on  : 03-25-2021
 * @last modified by  : Harlinsson Chavarro (HCH)
 * Modifications Log
 * Ver   Date         Author                      Modification
 * 1.0   02-04-2021   Harlinsson Chavarro (HCH)   Initial Version
 **/
public class DEG_ConsumeOquestadorHelper_cls{

  
	/*---------------------------------------------------------------------------------------------
	 Autor:
	 Descripción:
	 @params: -----
	 @return: -----
	 ----------------------------------------------------------------------------------------------*/
	public class wrapMensaje{
		public String orden;
		public String mensaje;
		public String tipo;
		public String idEvent;
		public String urlEvent;
		public String days;
		public String tokenWatson;
		public String sessionIdWatson;
		public Boolean esMsn;
		public Boolean esBtn;
		public Boolean esVideo;
		public Boolean esImage;
		public Boolean esBtnLink;
		public List<wrpImage> imageLst;
		public List<wrapBoton> lBotones;
		public List<wrapVideo> videoLst;
		public List<wrpBtnEnlace> btnLinkLst;
		public List<String> datesLst;

		public wrapMensaje(){
			this.orden = '';
			this.mensaje = '';
			this.tipo = '';
			this.idEvent = '';
			this.tokenWatson = '';
			this.sessionIdWatson = '';
			this.esMsn = false;
			this.esBtn = false;
			this.esBtnLink = false;
			this.esVideo = false;
			this.esImage = false;
			this.lBotones = new List<wrapBoton>();
			this.videoLst = new List<wrapVideo>();
			this.btnLinkLst = new List<wrpBtnEnlace>();
			this.imageLst = new List<wrpImage>();
			this.datesLst = new List<String>();
		}

		

		

		
	}

	public class wrapBoton{
		public String texto;

		
	}

	//for saving video response
	public class wrapVideo{
		public String texto;
		public String url;

		

		public wrapVideo(String sTexto, String url){
			this.texto = sTexto;
			this.url = url;
		}
	}

	//for saving btn enlace response
	public class wrpBtnEnlace{
		public String texto;
		public String url;

		

		public wrpBtnEnlace(String sTexto, String url){
			this.texto = sTexto;
			this.url = url;
		}
	}

	//for saving image response
	public class wrpImage{
		public String texto;
		public String url;

		

		public wrpImage(String sTexto, String url){
			this.texto = sTexto;
			this.url = url;
		}
	}

}