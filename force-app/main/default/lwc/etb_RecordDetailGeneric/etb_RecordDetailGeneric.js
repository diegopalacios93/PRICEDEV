import { LightningElement, api, track } from 'lwc';
import getMetadata from '@salesforce/apex/etb_RecordDetailGeneric.getMetadata';
import checkAccesibleField from '@salesforce/apex/etb_RecordDetailGeneric.checkAccesibleField';

export default class etb_RecordDetailGeneric extends LightningElement {
    @api recordId;
    @api objectApiName;

    @track config = [];
    fieldsList;
    recordMetaConfig;
    loadRecords = false;

    validTypes = ['Owner', 'RecordType'];

    connectedCallback() {
        console.log(this.objectApiName);
        getMetadata({ objectApiName: this.objectApiName })
            .then( async (result) => {
                console.log(JSON.stringify(result));
                let fieldsApiNames = result.map(elem => elem.Field__c);
                // get accessible fields for the current user
                let accessibleFields = await this.checkPermissionFields(fieldsApiNames);

                // contain all fields to show in the record page based on permission
                result = result.filter(elem => accessibleFields.hasOwnProperty(elem.Field__c) || this.validTypes.includes(elem.Type__c));

                console.log('accessibleFields', accessibleFields);
                console.log('Result', result);

                this.recordMetaConfig = JSON.parse(JSON.stringify(result));
                this.fieldsList = this.toolGetFieldsToList(result);
                this.loadRecords = true;
            })
            .catch((error) => {
                //TO DO
            });
    }

    checkPermissionFields(fields) {
        let accessibleFields = checkAccesibleField({ objectApiName: this.objectApiName, fields: fields }).then(res => {
            return JSON.parse(res);
        });

        return accessibleFields;
    }

    toolGetFieldsToList(data) {
        let listField = {};
        let aux = '';
        for (let key in data) {
            let value = data[key];
            let auxFields = [];

            auxFields = this.toolGetSpecialField(value);


            for (let valField of auxFields) {
                aux = value['Object__c'] + '.' + valField;
                listField[aux] = {
                    fieldApiName: valField,
                    objectApiName: value['Object__c']
                }
            }
        }

        //console.log('toolGetFieldsToList', listField);
        return Object.values(listField);
    }

    toolGetSpecialField(data) {

        let field = data['Field__c'];
        let fieldRelated = data['RelationName__c'];
        let type = data['Type__c'];
        let resp = [];


        if (field === 'CreatedBy') {
            resp = [field, field + '.Name', 'CreatedDate'];
        } else if (field === 'LastModifiedBy') {
            resp = [field, field + '.Name', 'LastModifiedDate'];
        } else if (type === 'Name') {
            resp = [field, 'Salutation', 'FirstName', 'MiddleName', 'LastName', 'Suffix'];
        } else if (field == 'ShippingAddress') {
            resp = [field, 'ShippingGeocodeAccuracy', 'ShippingCity', 'ShippingCountry', 'ShippingLatitude', 'ShippingLongitude', 'ShippingPostalCode', 'ShippingState', 'ShippingStreet'];
        } else if (field == 'Address') {
            resp = [field, 'GeocodeAccuracy', 'City', 'Country', 'Latitude', 'Longitude', 'PostalCode', 'State', 'Street']; 
        } else {
            resp = [field];
        }

        if (fieldRelated != undefined) {
            resp.push(fieldRelated);
        }

        return resp;
    }


}