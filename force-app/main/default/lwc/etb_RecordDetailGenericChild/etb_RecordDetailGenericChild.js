import { LightningElement, api, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';

export default class etb_RecordDetailGenericChild extends NavigationMixin(LightningElement) {
    @api recordId;
    @api objectApiName;
    @api fieldsList;
    @api recordMetaConfig;
    mapOptions = {
        draggable: false, 
        disableDefaultUI: true,
        zoomControl: false
     };

    @track config = [];

   /** Consultat el registro segun id y fieldsList recibidos */
    @wire(getRecord, { recordId: '$recordId', fields: [], optionalFields:  '$fieldsList' })
    record({ error, data }) {
        if (error){
            //TO DO
        } else if (data) {
           // console.log("dtvRecordDetailGenericChhild",JSON.stringify(data));
           this.config = [];
            let recordTypeName = data.recordTypeInfo != undefined ? data.recordTypeInfo.name : null;  //Obtener recordtype del objeto en caso de que exista
           
                    let result = this.recordMetaConfig; //Se almacena en la variable result los datos del retrieve de la custom metadata recibida del padre
                   
                    let auxResult =  this.toolFilterByNode(result,'RecordTypeName__c',recordTypeName); //Se filtran de la cmt recibida segun el recortype del registro actual
                    auxResult = (Object.keys(auxResult).length>0)?auxResult: this.toolFilterByNode(result,'RecordTypeName__c',null); 
                    //Se valida si se tienen datos segun el recordtype, sino existe se muestran los datos de la cmt sin recordtype
                    result =  this.toolTransformSections(auxResult,'Section__c'); //Se agrupan los datos en secciones segun la configuracion
                    try {
                        for(let key in result) { //Lectura de las secciones
                            if (result.hasOwnProperty(key)) {
                                let valuesLeft = [];
                                let valuesRight = [];
                                let values = [];
                                let valueMAP = JSON.parse(JSON.stringify(result[key]));
                                for(let keyV in valueMAP){ //Lectura de elementos de la seccion (Registros de la cmt)
                                    let posColumn = valueMAP[keyV]['ColumnPosition__c']; //Se valida si se fijo una posicion especifica
                                    let auxBuiltValue = this.builtValue(data, valueMAP, keyV); //Construir estructura segun tipo y tomar los valores solicitados
                                    if( posColumn==='Left' || ( (keyV%2)==0 && posColumn==undefined)){ //Validar para ubicacion tomando como prioridad posColum
                                        valuesLeft.push({key:keyV, value: auxBuiltValue}); //Ubicar en array de elementos de la izquierda
                                    }else{
                                        valuesRight.push({key:keyV, value: auxBuiltValue}); //Ubicar en array de elementos de la derecha
                                    }
                                    values.push({key:keyV, value: auxBuiltValue}); // Agregar al array de elementos de una seccion
                                   
                                }
                                //Definir array de secciones y elementos. La seccion que tenga el nombre MAIN no tendra titulo visible.
                                (key === 'MAIN') ? this.config.push({key: false, rowVal:this.toolsGetDataForColumns(valuesLeft,valuesRight,key)}):this.config.push({key: key, rowVal:this.toolsGetDataForColumns(valuesLeft,valuesRight,key)});
                                 
                            }
                            
                        }
                        //console.log(JSON.stringify(this.config));
                    } catch(e) {
                        console.error(e);
                    }
                    
               /* })
                .catch((error) => {
                    //TO DO
                });*/

        }
    }

    //Buscar valores solicitados en la data recibida segun la custom metadata
    builtValue = (data, valueMAP, key) => {
        console.log('ETB-45 data ' + JSON.stringify(data));
        console.log('ETB-45 valueMAp ' + JSON.stringify(valueMAP));
        console.log('ETB-45 key ' + JSON.stringify(key));
        console.log('ETB-45 value+key ' + JSON.stringify(valueMAP[key]));
        let value = JSON.parse(JSON.stringify(valueMAP[key]));
        let fieldNode = (value['Field__c']!==undefined)?value['Field__c']:{};
        let aux={}
        if(value['Type__c'] === 'Text') {
            value['isText'] = true;
            value['Value__c'] = (data['fields'][fieldNode]) ? ((typeof data['fields'][fieldNode]['value'] === 'object')?this.toolProcessNode(data['fields'],value['RelationName__c'],'value|displayValue'):data['fields'][fieldNode]['value']):'';
        } else if (value['Type__c'] === 'Lookup') {
            value['isLookup'] = true;
            value['URL__c'] = this.toolProcessNode(data['fields'],fieldNode,'value');//(data['fields'][fieldNode]) ?data['fields'][fieldNode]['value']:'';// '/lightning/r/'+data['fields'][fieldNode]['value']+'/view':'#';
            value['Value__r'] = this.toolProcessNode(data['fields'],value['RelationName__c'],'displayValue|value');//(data['fields'][fieldNode]) ? ((data['fields'][value['RelationName__c']])?data['fields'][value['RelationName__c']]['displayValue']:''):'';
        } else if (value['Type__c'] === 'Owner') {
            value['isText'] = true;
            value['Value__c'] = (data['fields'][fieldNode]) ? data['fields'][fieldNode]['displayValue'] + ', ' + ((fieldNode==='CreatedBy') ? data['fields']['CreatedDate']['displayValue']:((fieldNode==='LastModifiedBy')?data['fields']['LastModifiedDate']['displayValue']:'')) :'';
        } else if (value['Type__c'] === 'RecordType') {
            value['isText'] = true;
            value['Value__c'] = (data['fields'][fieldNode]) ? data['fields'][fieldNode]['displayValue']:'';
        } else if (value['Type__c'] === 'Picklist') {
            value['isText'] = true;
            value['Value__c'] = (data['fields'][fieldNode]) ? ((data['fields'][fieldNode]['displayValue']!==null)?data['fields'][fieldNode]['displayValue']:data['fields'][fieldNode]['value']):'';
        }else if(value['Type__c'] === 'Checkbox'){
            value['isCheckbox'] = true;
            value['Class__c'] = (data['fields'][fieldNode]) ? ((data['fields'][fieldNode]['value']===true)?'checked':'unchecked'):'unchecked';
            value['Value__c'] = (data['fields'][fieldNode]) ? ((data['fields'][fieldNode]['value']===true)?'True':'False'):'False';
        }else if(value['Type__c'] === 'Name'){
        
            if(fieldNode==='Name'){
                aux = data['fields'];
            }else if(data['fields'][fieldNode]['value']!==null){
                aux = data['fields'][fieldNode]['value']['fields'];
            }else{
                aux = undefined;
            }

            value['isText'] = true;
            value['Value__c'] = this.toolCompoundName(aux);
        }else if(value['Type__c'] === 'Address'){
            console.log('address REbeca '+JSON.stringify(data['fields']));
            debugger;
            /*if(fieldNode==='ShippingAddress' ||fieldNode==='BillingAddress' || fieldNode==='Address'){
                aux = data['fields'];
            }else */
            if((data['fields'][fieldNode])!=undefined && data['fields'][fieldNode]['value']!==null){
                aux = data['fields'][fieldNode]['value'];//['fields'];
            }else{
                aux = undefined;
            }

            value['isText'] = true;
            let auxObjConf = this.toolCompoundAddress(aux);
            let auxMarkers = [];
            
            if(auxObjConf.location.Latitude!==null && auxObjConf.location.Longitude!==null)
            auxMarkers.push({location: auxObjConf.location});

            value['Value__c'] = auxObjConf.text;
            value['MapConfig'] = (auxMarkers.length>0)? {Markers: auxMarkers, Url: (auxObjConf.url!=null)?auxObjConf.url:'#',location: auxObjConf.location} : null;
     
        }

        return value;
    }

    toolProcessNode(data,nodes,targetKey){
        let auxSplit = (nodes)?nodes.split('.'):[];
        let auxTargetKey = (targetKey)?targetKey.split('|'):[];
        let auxAcum = {}
        let auxResp = {}

        auxAcum = (auxSplit[0])?data[auxSplit[0]]:'';

        for(var i=0;i<auxSplit.length;i++){
            if(auxAcum===undefined || auxAcum===null){
            auxAcum='';
            break;
            }
            if(i+1===auxSplit.length){
                auxResp = auxAcum[auxTargetKey[0]];
                auxAcum = (auxResp!==null)?auxResp:((auxAcum[auxTargetKey[1]]!==null)?auxAcum[auxTargetKey[1]]:'');
            }else{
                auxAcum = (auxAcum['value'])?auxAcum['value']['fields']:undefined;
                if(auxAcum!==undefined)
                auxAcum = auxAcum[auxSplit[i+1]];
            }
        }

        return auxAcum;
    }

    /*
    toolFilterByInternalNode(mapData,fieldNode,targetVal){
        let mapKeys = Object.keys(mapData);
        let resp = {} ;

        for(let key in mapKeys){
            let auxarr = mapData[mapKeys[key]].filter((el)=>{
                return el[fieldNode]==targetVal;
            });
            if(auxarr.length>0) resp[mapKeys[key]] = auxarr;
        }

        return resp;
    }*/

    //Filtrar elementos segun nodo y valor (Es usado para filtrar elementos que sean de un recordtype especifico)
    toolFilterByNode(records,fieldNode,targetVal){
        let resp = [];

        for(let key in records){
            if(records[key][fieldNode]==targetVal){
                resp.push(records[key]);
            }
        }

        return resp;
    }

    //Transformar la custom metadata recibida en secciones
    toolTransformSections(records,sectionField){
        let resp = {};
        let auxObj = {}
        let auxStrObj='';

        for(let key in records){
            auxObj={}
            auxStrObj='';
    
            if(resp[records[key][sectionField]]===undefined){
                resp[records[key][sectionField]]=[];
            }
            
            resp[records[key][sectionField]].push(records[key]); 
        }
        

        return resp;
    }


    //Retorna un arreglo de objetos con la cantidad de total de filas que se deben mostrar para unificar el recorrido de las columnas
    toolsGetDataForColumns(col1,col2,index){
        let maxColSize = 0;
        let listRow = [];
        

        maxColSize = (col1.length > col2.length)?col1.length:col2.length;

        for(let i=0;i<maxColSize;i++){
            listRow.push({
                colLeft: (col1[i]!==undefined)?col1[i]:null,
                colRight: (col2[i]!==undefined)?col2[i]:null,
                key: index + Date.now()
            });
        }

        return listRow;

    }

    //Retorna un string que contiene concatenada la informacion de una campo tipo Name
    toolCompoundName(fields){
        let resp = '';

        if(fields!==undefined){
        resp+= (fields['Salutation'] &&  fields['Salutation']['displayValue']!==null)? fields['Salutation']['displayValue']+" ":"";
        resp+= (fields['FirstName'] &&  fields['FirstName']['value']!==null)? fields['FirstName']['value']+" ":"";
        resp+= (fields['MiddleName'] &&  fields['MiddleName']['value']!==null)? fields['MiddleName']['value']+" ":"";
        resp+= (fields['LastName'] &&  fields['LastName']['value']!==null)? fields['LastName']['value']+" ":"";
        resp+= (fields['Suffix'] &&  fields['Suffix']['value']!==null)? fields['Suffix']['value']+" ":"";

        resp = (resp.length>0)?resp.substring(0, resp.length-1) : resp;
        }
        return resp;
    }

    /*Retorna un string que contiene concatenada la informacion de una campo tipo Address
     y forma la estructura de la data que ayuda a mostrar la imagen del mapa
     */
    toolCompoundAddress(fields){
        let resp = '';
        //-17.7878151,-63.17176389999999
        let location = {
            Latitude: null,
            Longitude: null
        }
        let longitude;
        let baseUrlMap = 'https://www.google.com/maps/search/?api=1&query=';
        //https://maps.google.com/?q=-17.7878151,-63.17176389999999&ll=-17.7878151,-63.17176389999999&z=5
        let urlMap = '';
        if(fields!==undefined){
            resp+= (fields['ShippingStreet'] &&  fields['ShippingStreet']['value']!==null)? fields['ShippingStreet']['value']+" ":"";
            resp+= (fields['ShippingPostalCode'] &&  fields['ShippingPostalCode']['value']!==null)? fields['ShippingPostalCode']['value']+" ":"";
            resp+= (fields['ShippingCity'] &&  fields['ShippingCity']['value']!==null)? fields['ShippingCity']['value']+" ":"";
            resp+= (fields['ShippingState'] &&  fields['ShippingState']['value']!==null)? fields['ShippingState']['value']+" ":"";
            resp+= (fields['ShippingCountry'] &&  fields['ShippingCountry']['value']!==null)? fields['ShippingCountry']['value']+" ":"";

            //Se agregan campos para el objecto Lead
            resp+= (fields['Street'] &&  fields['Street']['value']!==null)? fields['Street']['value']+", ":"";
            resp+= (fields['City'] &&  fields['City']['value']!==null)? fields['City']['value']+", ":""; 
            resp+= (fields['State'] &&  fields['State']['value']!==null)? fields['State']['value']+", ":"";
            resp+= (fields['PostalCode'] &&  fields['PostalCode']['value']!==null)? fields['PostalCode']['value']+", ":"";
            resp+= (fields['Country'] &&  fields['Country']['value']!==null)? fields['Country']['value']+" ":"";

            resp = (resp.length>0)?resp.substring(0, resp.length-1) : resp;
            
            location.Latitude = (fields['ShippingLatitude'] && fields['ShippingLatitude']['value']!==null)?fields['ShippingLatitude']['value']:null;
            location.Longitude = (fields['ShippingLongitude'] && fields['ShippingLongitude']['value']!==null)?fields['ShippingLongitude']['value']:null; 

            

            if(location.Latitude!==null && location.Longitude!==null){
                urlMap = baseUrlMap + location.Latitude + ',' + location.Longitude;
            }

        }

        return {text: resp, url: urlMap, location: location}
    }


    //Oculrtar el texto mostrado por el componente lightning-formatted-address para mostrar solo el mapa
    renderedCallback() {
        const style = document.createElement('style');
        style.innerText = `a>div.slds-truncate {
        display: none !important;
        }`;
        let elem = this.template.querySelector('lightning-formatted-address');
        if(elem!==null)
        elem.appendChild(style);
    }
    
    //Maneja la navegacion de los enlaces
    handlerLookupNavigate(event){
        event.preventDefault();

        let sectionid = event.target.dataset.sectionid;
        let rowid = event.target.dataset.rowid;
        let columpos = event.target.dataset.columpos;
      
        let elem = this.config[sectionid]['rowVal'][rowid][columpos];
        elem = (elem != undefined && elem.value != undefined)? elem.value: {};
        let recordTarget = (elem['URL__c']!=='')?elem['URL__c']:null;
       
        if(recordTarget!==null){
            this[NavigationMixin.Navigate](
                {
                    type: 'standard__recordPage',
                    attributes: {   
                        recordId: recordTarget,
                        actionName: 'view'
                    },  
                }
            ); 
        }
    }
}