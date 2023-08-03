import B2bTotalBar from "vlocity_cmt/b2bTotalBar";
    export default class etb_b2bTotalBar extends B2bTotalBar{
        // your properties and methods here
        connectedCallback(){
            super.connectedCallback();
            //nList can be any variable, need to store the route Quote property
            this.nList = this.route.Quote;
            console.log('memberType ',this.memberType);
            console.log('memberType ',JSON.stringify(this.memberType));
            if(this.memberType == 'Location'){
                this.memberType = 'Ubicación';
            }
            if(this.memberType == 'Product'){
                this.memberType = 'Producto';
            }
            console.log('nuevo memberType ',this.memberType);
            console.log('nuevo memberType ',JSON.stringify(this.memberType));
        }

        // get memberType(){
        //     if(this.memberType == 'Location'){
        //         this.memberType = 'Ubicación';
        //     }
        //     if(this.memberType == 'Product'){
        //         this.memberType = 'Producto';
        //     }
        // }
    }