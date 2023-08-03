import { LightningElement, api, track, wire } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { NavigationMixin } from "lightning/navigation";

const ARR_TABS = ["DATOS", "INTERNET", "LARGA DISTANCIA", "LOCAL", "REDES MOVILES"];

export default class etb_AssetDetails extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
  @api recordId;
  @track showTable = false;
  @track noHayDatos = true;
  @track familyTodos = true;
  @track familyDatos = true;
  @track familyInter = true;
  @track familyLocal = true;
  @track familyRMoviles = true;
  @track familyLDistancia = true;
  @track totalElementos = "";
  @track totalDatos = "";
  @track totalInternet = "";
  @track totalLargaDistancia = "";
  @track totalLocal = "";
  @track totalRedesMoviles = "";
  maxData;
  data = [];
  record = {};
  pagedData = [];
  jsonDatos = {};
  showspinner = true;
  _ns = getNamespaceDotNotation();
  emptyStateImg = '/resource/ETB_StaticResources/img/Empty_State.png';


  connectedCallback() {
    this.getAssets();
    this.data = [];
  }

  getAssets() {
    try {
      const input = { AccountId: this.recordId };
      const params = {
        input: JSON.stringify(input),
        sClassName: `vlocity_cmt.IntegrationProcedureService`,
        sMethodName: "etb_GetAssetDetail",
        options: "{}"
      };
      this.omniRemoteCall(params, false)
      .then((response) => {
        console.log('VIP Request', input);
        console.log('VIP Response', response.result.IPResult);
        this.pagedData = [];
        
        let longitud = "Assets" in response.result.IPResult ? response.result.IPResult.Assets.length : 0;
       
        let totalAssets = longitud
        if(totalAssets >= 999){
          totalAssets = "+999"
        } else if(totalAssets == 0 || totalAssets == "" || totalAssets == undefined){
          totalAssets = 0
        }
       
        console.log('Longitud ahora--->' + longitud);
        this.totalElementos = "Todos (" + totalAssets + ")";
        this.totalDatos = "Datos (0)";
        this.totalInternet = "Internet (0)";
        this.totalLargaDistancia = "Larga Distancia (0)";
        this.totalLocal = "Local (0)";
        this.totalRedesMoviles = "Redes Móviles (0)";
        if (longitud > 0) {
          this.showTable = true;
          this.data = response.result.IPResult.Assets;
          this.filterData(this.data);
          this.noHayDatos = false;
          this.familyTodos = false;
          this.maxData = longitud;
          this.pagedData = this.data;
          console.log("this.showTable", this.showTable);
          console.log("this.pagedData", this.pagedData);
        } else {
          this.showTable = false;
          this.noHayDatos = true;
          this.showspinner = false;
        }
      })
      .catch((error) => {
        window.console.log(error, "error");
      });
  } catch (error) {
    console.log("Fallo get assets ", error);
  }
  //this.showspinner = false;
}
handleActive(event) {
  let datosFiltrados = [];
  let valorEvent = event.target.value;
  if (this.data.length > 0) {
    datosFiltrados = ((valorEvent == "0") ? this.data.slice() : this.jsonDatos[ARR_TABS[parseInt(valorEvent - 1)]]);
    if (datosFiltrados.length > 0) {
      this.hideComponents(((valorEvent == "0") ? "TODOS" : ARR_TABS[valorEvent - 1]), ((datosFiltrados.length > 0) ? false : true));
    } else {
      datosFiltrados = this.data;
    }
    this.pagedData = [];
    this.pagedData = datosFiltrados.slice();
    console.log('paged data--->' + this.pagedData);
    this.maxData = this.pagedData.length;
  }
}
filterData = function (datos) {
  
  if (datos.length > 0) {
    for (const arrtabs of ARR_TABS) {
      this.jsonDatos[arrtabs] = [];
      for (let o = 0; o < datos.length; o++) {
        if (datos[o]?.BusinessLine == arrtabs) {
          datos[o]["Iden"] = datos[o]["Id"] + o;
          this.jsonDatos[arrtabs].push(datos[o]);
        }
      }

      let total = this.jsonDatos[arrtabs].length;
    console.log("total",total)
      if(total >= 999){
        total = "+999"
      }

      switch(arrtabs){
        case "DATOS":
          this.totalDatos = "Datos (" + total + ")";
          break;
        case "INTERNET":
          this.totalInternet = "Internet (" + total + ")";
          break;
        case "LARGA DISTANCIA":
          this.totalLargaDistancia = "Larga Distancia (" + total + ")";
          break;
        case "LOCAL":
          this.totalLocal = "Local (" + total + ")";
          break;
        case "REDES MOVILES":
          this.totalRedesMoviles = "Redes Móviles (" + total + ")";
          break;
      }
    }
  }
  this.showspinner = false;
}
hideComponents(name, value) {
  switch (name) {
    case "TODOS":
      this.familyTodos = value;
      this.familyDatos = true;
      this.familyInter = true;
      this.familyLDistancia = true;
      this.familyLocal = true;
      this.familyRMoviles = true;
      break;
    case "DATOS":
      this.familyTodos = true;
      this.familyDatos = value;
      this.familyInter = true;
      this.familyLDistancia = true;
      this.familyLocal = true;
      this.familyRMoviles = true;
      break;
    case "INTERNET":
      this.familyTodos = true;
      this.familyDatos = true;
      this.familyInter = value;
      this.familyLDistancia = true;
      this.familyLocal = true;
      this.familyRMoviles = true;
      break;
    case "LARGA DISTANCIA":
      this.familyTodos = true;
      this.familyDatos = true;
      this.familyInter = true;
      this.familyLDistancia = value;
      this.familyLocal = true;
      this.familyRMoviles = true;
      break;
    case "LOCAL":
      this.familyTodos = true;
      this.familyDatos = true;
      this.familyInter = true;
      this.familyLDistancia = true;
      this.familyLocal = value;
      this.familyRMoviles = true;
      break;
    case "REDES MOVILES":
      this.familyTodos = true;
      this.familyDatos = true;
      this.familyInter = true;
      this.familyLDistancia = true;
      this.familyLocal = true;
      this.familyRMoviles = value;
      break;
  }
}
}