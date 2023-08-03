import { LightningElement,wire, api, track } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getdata from '@salesforce/apex/deg_downloadData_ctr.getData';

export default class Deg_downloadData_lwc extends LightningElement {

    @api labelButton='Descargar';
    @api listidpre=[];
    @track disablebuttonDown=true;
    listid = ['0012900000bZgcKAAS','0012900000bbMyQAAU','0012900000cQsy5AAC','0012900000cQvFjAAK','0012900000cR2xIAAS'];
    @api fields='Id, Name, AnnualRevenue, Industry, Phone';
    @api objname='Account';
    @api whitwhe=false;
    @api allActivitiesData;
    data;

    @api csvheaders ={
        Id:"Record Id",
        Name:"Name",
        AnnualRevenue:"Annual Revenue",
        Industry:"Industry",
        Phone:"Phone"

    }
    
    @api 
    infoget(listidpre2,event){
        console.log("dataget");
        console.log(event);
        console.log(listidpre2[0]);
        console.log(this.listid);
        this.listid=[];
        for(var i=0; i<listidpre2.length; i++){
            console.log(listidpre2[i]);
            this.listid.push(listidpre2[i]);
        }
        console.log(this.listid)
        this.data =[] ;
        getdata({listid:this.listid,objName:this.objname,fields:this.fields,whitwhe:this.whitwhe})
        .then((result)=> {
            console.log("dataget-result");
            this.data = result;
            console.log(this.data[0]);

            let contactsArray=[];
            for(let row of this.data){
                const flattendRow={};
                    let rowKeys=Object.keys(row);
                    console.log(rowKeys);
                    console.log(row);
                    //rowKeys.foreach(rowKey=>{
                        for (let i = 0, len = rowKeys.length; i < len; i++) {
                            let testl=rowKeys[i];
                        const singleNodeValue= row[rowKeys[i]];
                        console.log(singleNodeValue);
                        if(singleNodeValue.constructor===Object){
                            flattendRow[testl]=this.flatten(singleNodeValue,flattendRow,testl);
                        }
                        else{
                            flattendRow[testl]=singleNodeValue;
                        }
                    //});
                    }
                    contactsArray.push(flattendRow);
            //}
            console.log(contactsArray);
            }
            this.allActivitiesData=contactsArray;
            console.log(allActivitiesData);
            
        })
        .catch(error => {
            this.data = error;
        });


        if(listidpre2.length>0){
            console.log("length>0");
            this.disablebuttonDown=false;
        }
        else{
            console.log("length==0");
            this.disablebuttonDown=true;
            console.log('disablebuttonDown=>'+this.disablebuttonDown);
        }
    }
    flatten = (nodeValue, flattenedRow, nodeName) => {  
        let rowKeys = Object.keys(nodeValue);
        rowKeys.forEach((key) => { 
            console.log(key);     
            let finalKey = nodeName + '.'+ key;
            flattenedRow[finalKey] = nodeValue[key];
        })
    } 

    downloadData(){
        console.log(this.listid);
        console.log(Object.values(this.csvheaders));
        this.listid=[];
        console.log('downloadData'); 
        //this.exportCSVFile(this.csvheaders, this.data, "accounts detail");
        this.exportCSVFile(this.csvheaders, this.allActivitiesData, "accounts detail");
    }

    exportCSVFile(headers, totalData, fileTitle){
        console.log("exportCSVFile");
        if(!totalData || !totalData.length){
            console.log("return null");
            return null
        }
        console.log("exportCSVFile");
        const jsonObject = JSON.stringify(totalData)
        const result = this.convertToCSV(jsonObject, headers)
        console.log('headers');
        console.log(headers);
        if(result === null) return
        const blob = new Blob([result])
        const exportedFilename = fileTitle ? fileTitle+'.csv' :'export.csv'
        if(navigator.msSaveBlob){
            navigator.msSaveBlob(blob, exportedFilename)
        } else if (navigator.userAgent.match(/iPhone|iPad|iPod/i)){
            const link = window.document.createElement('a')
            link.href='data:text/csv;charset=utf-8,' + encodeURI(result);
            link.target="_blank"
            link.download=exportedFilename
            link.click()
        } else {
            const link = document.createElement("a")
            if(link.download !== undefined){
                const url = URL.createObjectURL(blob)
                link.setAttribute("href", url)
                link.setAttribute("download", exportedFilename)
                link.style.visibility='hidden'
                document.body.appendChild(link)
                link.click()
                document.body.removeChild(link)
            }
        }
        
    
    }
    convertToCSV(objArray, headers){
        console.log("convertToCSV");
        const columnDelimiter = ';'
        const lineDelimiter = '\r\n'
        const actualHeaderKey = Object.keys(headers)
        const headerToShow = Object.values(headers) 
        console.log('headers.values');
        console.log(Object.values(headers));
        console.log('headers.keys');
        console.log(Object.keys(headers));
        let str = ''
        str+=headerToShow.join(columnDelimiter) 
        str+=lineDelimiter
        const data = typeof objArray !=='object' ? JSON.parse(objArray):objArray
    
        data.forEach(obj=>{
            let line = ''
            actualHeaderKey.forEach(key=>{
                if(line !=''){
                    line+=columnDelimiter
                }
                let strItem = obj[key]+''
                console.log(strItem);
                //line+=strItem? strItem.replace(/;/g, '"/;/"'):strItem
                line+=strItem? '"'+strItem+'"':strItem
            })
            str+=line+lineDelimiter
        })
        console.log("str", str)
        return str
    }

    
}