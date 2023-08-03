import { LightningElement, api, track } from 'lwc';
import tmpl from './etb_PurchaseDetails.html';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

const FORMATTER = new Intl.NumberFormat('es-CO', { style: 'currency', currency: 'COP' });
export default class etb_PurchaseDetails extends OmniscriptBaseMixin(LightningElement) {
  @api summaryinfo;
  @track structToShowSummaryAB = [];
  @track structToShowSummaryCD = [];
  summaryAllData = [];

  connectedCallback() {
    this.summaryAllData = JSON.parse(JSON.stringify(this.summaryinfo));
    this.createInternalStruct();
  }
  render() {
    return tmpl;
  }

  createInternalStruct() {
    let sections = ((!this.summaryAllData == false) ? Object.keys(this.summaryAllData) : []);
    if (sections.length > 0 && !this.summaryAllData == false) {
      for (let i = 0; i < sections.length; i++) {
        let auxElems = [];
        let section = sections[i];
        let auxElemsK = [];
        let arr = [];
        if (section == 'B') {
          this.summaryAllData[section].elements.forEach(element =>
            arr.push(element)
          );
          this.summaryAllData[section].elements = [];
          this.summaryAllData[section].elements.push(arr);
        }
        let auxElemsKeys = Object.keys(this.summaryAllData[section].elements[0]);
        for (let j = 0; j < auxElemsKeys.length; j++) {
          if (section == 'B') {
            let string = this.summaryAllData[section].elements[0][j].value;
            if (this.summaryAllData[section].elements[0][j].validation == 'U') {
              this.summaryAllData[section].elements[0][j].value = "Precio único \\n " + FORMATTER.format(string);
            } else if (this.summaryAllData[section].elements[0][j].validation == 'R') {
              this.summaryAllData[section].elements[0][j].value = "Precio recurrente \\n " + FORMATTER.format(string) + " mensuales";
            }
            this.summaryAllData[section].elements[0][auxElemsKeys[j]].label = this.summaryAllData[section].elements[0][auxElemsKeys[j]].label.replace("\\n", "\n");
            this.summaryAllData[section].elements[0][auxElemsKeys[j]].value = this.summaryAllData[section].elements[0][auxElemsKeys[j]].value.replace("\\n", "\n");
          } else if (section == 'D') {
            this.summaryAllData[section].elements[0][auxElemsKeys[j]].value = FORMATTER.format(this.summaryAllData[section].elements[0][auxElemsKeys[j]].value);
          };
          if (this.summaryAllData[section].elements[0][auxElemsKeys[j]].value === 'empty') {
            delete this.summaryAllData[section].elements[0][auxElemsKeys[j]];
          } else {
            let valueElem = this.summaryAllData[section].elements[0][auxElemsKeys[j]].value;
            auxElemsK.push({
              total: ((section == "C" || section == "D") ? this.summaryAllData[section].elements[0][auxElemsKeys[j]].total : ""),
              elemNode: auxElemsKeys[j],
              label: this.summaryAllData[section].elements[0][auxElemsKeys[j]].label,
              value: ((valueElem !== undefined) ? (Array.isArray(valueElem) ? valueElem : String(valueElem)) : undefined),
              priority: this.summaryAllData[section].elements[0][auxElemsKeys[j]].priority
            });
          };
        }
        auxElemsK.sort((a, b) => a.priority - b.priority);
        auxElems = [...auxElems, ...auxElemsK];

        let elementToPush = { title: this.summaryAllData[section].title, id: section, elements: auxElems };
        if (section == "A" || section == "B") {
          this.structToShowSummaryAB.push(elementToPush);
        } else if (section == "C" || section == "D") {
          this.structToShowSummaryCD.push(elementToPush);
        }
      }
    }
  }
}