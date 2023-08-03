import { LightningElement, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import B2bCartSummary from 'vlocity_cmt/b2bCartSummary';
import { NavigationMixin } from 'lightning/navigation';


    export default class Etb_b2bCartSummary extends NavigationMixin(B2bCartSummary) {
    quoteId;
    accountId;
    quoteName;
    currentPageReference = null;
    urlStateParameters = null;
    openReliesOnQuoteModal = false;
    /* Params from Url */
    urlId = null;
    urlLanguage = null;
    urlType = null;
    // Obtenemos el contextId desde la URL
    @wire(CurrentPageReference)

    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.urlStateParameters = currentPageReference.state;
            this.setParametersBasedOnUrl();
        }
    }

    setParametersBasedOnUrl() {
        this.quoteId = this.urlStateParameters.c__cartId;
        this.accountId = this.urlStateParameters.c__accountId;
        this.quoteName = this.urlStateParameters.c__cartName;
        console.log('this.quoteId, this.accountId, this.cartName', this.quoteId, this.accountId, this.quoteName);
    }

    connectedCallback(){
        super.connectedCallback();
        //nList can be any variable, need to store the route Quote property
        this.nList = this.route.Quote;
        console.log('route: ',JSON.stringify(this.route));
        console.log('nList: ',JSON.stringify(this.nList));
        console.log('cartData ',JSON.stringify(this.cartData));
        this.actionList.splice(0,1,{label:'Generar contrato',method:'generateContract'});
        this.actionList.splice(1,0,{label:'Viabilizar productos',method:'viabilizarProductos'});
        this.actionList.splice(1,0,{label:'Descuentos',method:'descuentos'});
        this.actionList.splice(1,0,{label:'ReliesOn Quote',method:'reliesOnQuote'});
        this.actionList.splice(5,2);
    }

    executeAction(evt){
        const func = evt.currentTarget.dataset.method;
        console.log(JSON.stringify(func));
        if(func == "reliesOnQuote"){
            this.openReliesOnQuoteModal = true;
        }
        this[func]();
    }

    // Utilizado para redirigir al OS de Generación de contrato
    generateContract(){
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'vlocity_cmt__vlocityLWCOmniWrapper'
            },
            state: {
                c__ContextId: this.quoteId,
                c__target: 'c:etbGenerateContractFromESMEnglish',
                c__layout: 'lightning', // or can be 'newport'
                c__tabIcon: 'standard:contract',
                c__tabLabel: 'Generar contrato',
            }
        })
    }

    // Utilizado para redirigir al OS de Viabilizar productos
    viabilizarProductos(){
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'vlocity_cmt__vlocityLWCOmniWrapper'
            },
            state: {
                c__ContextId: this.quoteId,
                c__QuoteName: this.quoteName,
                c__target: 'c:etbViabilizarProductosEnglish',
                c__layout: 'lightning', // or can be 'newport'
                c__tabIcon: 'standard:contract',
                c__tabLabel: 'Viabilizar productos',
            }
        })
    }

    // Utilizado para redirigir al OS de Gestion de cuentas
    createServiceAccount(){
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'vlocity_cmt__vlocityLWCOmniWrapper'
            },
            state: {
                c__ContextId: this.accountId,
                c__target: 'c:etbAccountManagementEnglish',
                c__layout: 'lightning', // or can be 'newport'
                c__tabIcon: 'standard:location',
                c__tabLabel: 'Gestión de cuentas',
            }
        })
    }

    descuentos(){
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'vlocity_cmt__vlocityLWCOmniWrapper'
            },
            state: {
                c__ContextId: this.quoteId,
                c__target: 'c:etbManageDiscountEnglish',
                c__layout: 'lightning', // or can be 'newport'
                c__tabIcon: 'standard:quotes',
                c__tabLabel: 'Agregar descuentos',
            }
        })
    }
}