import B2BSampleApp from "vlocity_cmt/b2bSampleApp";
import etb_b2bSampleAppTemplate from "./etb_b2bSampleApp.html";
/**
* @class customB2BSampleApp
* @extends {LightningElement} Extends the b2bSampleApp
*
* @classdesc
* customB2BSampleApp is the component for navigating between components.<br/><br/>
*/
 
export default class customB2BSampleApp extends B2BSampleApp {
 render(){
   return etb_b2bSampleAppTemplate;
 }
}