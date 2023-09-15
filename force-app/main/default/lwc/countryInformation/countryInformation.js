import { LightningElement, api, track, wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getPicklistValues } from "lightning/uiObjectInfoApi";
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import COUNTRY_FIELD from "@salesforce/schema/Account.Country__c";
import getCountryInformation from '@salesforce/apex/CountryInformationController.getCountryInformation';
import saveCountry from '@salesforce/apex/CountryInformationController.saveCountry';
import initialData from '@salesforce/apex/CountryInformationController.initialData';


export default class CountryInformation extends LightningElement {

    @api recordId;
    @track objCountry = {};
    showInformation = false;
    showSpinner = true;
    buttonDisabled = true;

    @wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
    objectInfo;

    @wire(getPicklistValues, { recordTypeId: "$objectInfo.data.defaultRecordTypeId", fieldApiName: COUNTRY_FIELD })
    countryPicklist;

    @wire(initialData, { recordId: "$recordId" })
    wiredDeviceDetail({ error, data }) {
        if (data) {
            this.showSpinner = false;
            if(data.hasOwnProperty('country')){
                this.showInformation = true;
                this.objCountry.Country = data.country;
                this.objCountry.Capital__c = data.capital;
                this.objCountry.Languages__c = data.languages;
                this.objCountry.Description__c = data.description;
                this.objCountry.Flag_Image__c = data.imgflag;
            }
        } else if (error) {
            this.showSpinner = false;
            console.log(JSON.stringify(error));
        }
    }

    handleSelectedCountry(e){
        const value  = e.detail.value;
        this.showSpinner = true;
        getCountryInformation({country: value}).then(res => {
            if(res){
                this.showInformation = true;
                this.buttonDisabled = false;
                this.objCountry.Name = value;
                this.objCountry.Capital__c = res.capital;
                this.objCountry.Languages__c = res.languages;
                this.objCountry.Description__c = res.description;
                this.objCountry.Flag_Image__c = res.imgflag;
            }
        }).catch(error => {
            console.log(JSON.stringify(error));
        }).finally(() => {
            this.showSpinner = false;
        }) 
    }

    handleSave(){
        this.showSpinner = true;
        saveCountry({accountId: this.recordId, objCountry: this.objCountry}).then(res => {
            this.showSpinner = false;
            this.buttonDisabled = true;
            const evt = new ShowToastEvent({
                title: 'Éxito',
                message: 'Guardado exitoso',
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
        }).catch(error => {
            console.log(JSON.stringify(error));
            const evt = new ShowToastEvent({
                title: 'Error',
                message: 'Algún error inesperado',
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
        })
    }
}