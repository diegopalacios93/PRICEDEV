/**
 * @description       : 
 * @author            : Adrian Bohorquez
 * @group             : 
 * @last modified on  : 08-10-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                      Modification
 * 1.0   06-08-2021   Adrian Bohorquez   Initial Version
**/
import { api, LightningElement, track } from 'lwc';
import IconoKey from '@salesforce/resourceUrl/DEG_IconoKey';
import IconoUser from '@salesforce/resourceUrl/DEG_IconoUser';
import IconoETB from '@salesforce/resourceUrl/DEG_IconoETB';
import LogoETBEmpresas from '@salesforce/resourceUrl/DEG_LogoETBEmpresas';
import authenticate from '@salesforce/apex/DEG_LoginEmpresas_cls.authenticate'
import cancelAuth from '@salesforce/apex/DEG_LoginEmpresas_cls.cancelAuth'   

export default class Deg_login_webchatEmpresas_lwc extends LightningElement {
  @track showModal = true;
  @track mailError = false;
  @track passError = false;
  @track invalid = false;
  @track loading = false;
  @track emailInput = '';
  @track passInput = '';
  @api token;

  sessionId = '';
  authPage = 'false';
  iconoKey = IconoKey;
  iconoUser = IconoUser;
  iconoETB = IconoETB;
  LogoETBEmpresas = LogoETBEmpresas;
  patternPass = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$/;
  patternMail = /^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$/;

  getParameterByName(name, url = window.location.href) {
    name = name.replace(/[\[\]]/g, '\\$&');
    var regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)'),
      results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, ' '));
  }

  connectedCallback() {
    this.authPage = this.getParameterByName('auth');
    this.sessionId = this.getParameterByName('sessionId');
  }

  handleChange(event) {
    this.invalid = false;
    if (event.target.name == 'mail') this.emailInput = event.target.value;
    if (event.target.name == 'password') this.passInput = event.target.value;
  }

  async handleSubmit() {
    if (this.validateCredential(this.emailInput, this.passInput)) {
      let sessionId = this.authPage == 'true' ? this.sessionId : window.sessionIdWatson;
      const login = {
        mail: this.emailInput,
        password: this.passInput,
        sessionId: sessionId,
        tokenWatson: this.token
      }
      this.loading = true;
      authenticate({ login }).then(() => {
        this.closeModal();
      }).catch(() => {
        this.closeModal();
      });
    }
  }

  closeModal() {
    this.loading = false;
    if (this.authPage == 'true') window.close();
    else this.showModal = false;
    this.emailInput = '';
    this.passInput = '';
  }



  handleCancel() {
    let sessionId = this.authPage == 'true' ? this.sessionId : window.sessionIdWatson;
    console.log(sessionId);
    this.loading = true;
    cancelAuth({ sessionId, token: this.token })
      .then(() => {
        this.closeModal();
      })
      .catch(() => {
        this.closeModal();
      });

  }

  validateCredential(mail, pass) {
    let res = true;
    if (mail === '' || pass === '') {
     // this.mailError = false;    ADN
      this.passError = false;
      this.invalid = true;
      return false;
    } else {
      this.invalid = false;
//    if (!this.validateEmail(mail)) {  ADN
//        this.mailError = true;
//        res = false;
//      } else this.mailError = false;

      if (!this.validatePass(pass)) {
        this.passError = true;
        res = false;
      } else this.passError = false;

      return res;
    }
  }

  validateEmail(email) {
    return this.patternMail.test(email);
  }

  validatePass(pass) {
    return this.patternPass.test(pass);
  }
}