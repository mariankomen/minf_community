import { LightningElement,  api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import getRecords from '@salesforce/apex/MassEmailingApplicantsController.getRecords';
import getEmailBody from '@salesforce/apex/MassEmailingApplicantsController.getTemplateBody';
import sendEmail from '@salesforce/apex/MassEmailingApplicantsController.sendEmail';
import CcAddress from '@salesforce/schema/EmailMessage.CcAddress';
const SUCCESS_CSS_TOAST_CLASS = "slds-scoped-notification slds-media slds-media_center slds-theme_success";
const FAIL_CSS_TOAST_CLASS = "slds-scoped-notification slds-media slds-media_center slds-theme_error";
const SUCCESS_ICON_CONTAINER_CSS_TOAST_CLASS = "slds-icon_container slds-icon-utility-success";
const FAIL_ICON_CONTAINER_CSS_TOAST_CLASS = "slds-icon_container slds-icon-utility-error";
const SUCCESS_ICON_TOAST = "/assets/icons/utility-sprite/svg/symbols.svg#success";
const FAIL_ICON_TOAST = "/assets/icons/utility-sprite/svg/symbols.svg#error";
export default class MassEmailingApplicants extends  NavigationMixin(LightningElement) 
{
    @api
    jobApplicants;
    @api
    jobId;
    
    @track
    state = {
        templates: [],
        applicants: [],
        tos: [],
        loaded: false ,       
        showToast:false,
        activeSections :['A'],
        height:'350rem'
    }

    handleSectionToggle(event) {
        const openSections = event.detail.openSections;

        if (openSections.length === 0) {
            this.state.height='600rem';
        } else {
            this.state.height='350rem';
        }
    }

    sendToVF(message) 
    {
    
        let iframe = this.template.querySelector('iframe');
        iframe.contentWindow.postMessage(message, '*');
    }


    navigateToJobRecord(evt)
     {        
       
        evt.preventDefault();
        evt.stopPropagation();
        console.log( 'this.jobPageRef : ' +  JSON.stringify(this.jobPageRef)  );
        
        // Navigate to the record
        this[NavigationMixin.Navigate](this.jobPageRef);

    }
   
    connectedCallback() 
    {
        this.jobPageRef={
            type: 'standard__recordPage',
            attributes: {
                recordId:'a0P5C000000bUlhUAE' ,
                actionName: 'view'
            }
        };
    }

    async renderedCallback() {
        if (this.state.loaded) {
            return null;
        }
     
        window.addEventListener('message', event => {          
            
            this.state.emailBody= event.data;
        }, false);


        try {
             this.data =  await  getRecords({jobApplicants:this.jobApplicants});            
            
        } catch (error) {
            this.error = error;
            console.log(error);
        } finally 
        {
            this.state.loaded = true;         
            
            this.state.jobId = this.jobId;
            if (this.data.applicants[0])
            {
                this.state.templates = this.data.email_templates;    
                this.state.applicants = this.data.applicants;               
                this.state.from = this.data.from;               
                this.state.jobName =  JSON.parse(this.jobApplicants)[0].Job__r.Name ;
                this.state.selectedFrom=this.state.from[0].value;
            }
            else
            {
                this.state.jobName="";
                this.state.showToast=true;
                this.state.toastClass= FAIL_CSS_TOAST_CLASS;
                this.state.toastIconClass=FAIL_ICON_CONTAINER_CSS_TOAST_CLASS;
                this.state.toastIcon = FAIL_ICON_TOAST;
                this.state.toastMessage = "Please select one or more applicants to email.";
                this.state.toastTitle = "error";
            }
        }

       
    }
    
    async handleTemplate(event) {
        this.state.templateId = event.detail.value;

        const data = await getEmailBody({ templateId : this.state.templateId,  whatId : this.state.jobId});

        this.state.emailBody = data.body;
        this.state.subject = data.subject;

        this.sendToVF({content:this.state.emailBody});
    }

    handleApplicantRemove (event) {
        
        const name = event.detail.item.name;
        this.state.applicants = this.state.applicants.filter(applicant => applicant.name!=name);
    }

    handleChange(event) {
        const field = event.target.name;        
        this.state[field]=event.target.value;
    }


    get url() {
        return `/lightning/r/SFDC_Job__c/${this.state.jobId}/view`;
    }

    get JobLabel() 
    {
        return `Email Applicants | ${this.state.jobName}`;
    }


    handleTextAreaLoad()
    {
        this.sendToVF({content:this.state.emailBody});
    }

    handleTryAgain()
    {
        this.state.showToast=false;        
    }

    async handleSendEmail(event) 
    {

        let show=true;
        let showTryAgaing=false;
        try {            
            const input = this.template.querySelector(".subject");
            if (input.validity.valid) 
            {                                
                await sendEmail({ jobApplicants:this.jobApplicants, emailInfoJson: JSON.stringify( {from:this.state.selectedFrom, body:this.state.emailBody, subject:input.value })});        
                
            } else
            {
                input.reportValidity();
                show=false;
            }

            this.state.toastClass= SUCCESS_CSS_TOAST_CLASS;
            this.state.toastIconClass=SUCCESS_ICON_CONTAINER_CSS_TOAST_CLASS;
            this.state.toastIcon = SUCCESS_ICON_TOAST;
            this.state.toastMessage = "Email(s) sent successfully.";
            this.state.toastTitle = "success";        

       } catch (error) {
        
        this.state.toastClass= FAIL_CSS_TOAST_CLASS;
        this.state.toastIconClass=FAIL_ICON_CONTAINER_CSS_TOAST_CLASS;
        this.state.toastIcon = FAIL_ICON_TOAST;
        this.state.toastMessage = error.body.message;
        this.state.toastTitle = "error";
        showTryAgaing=true;                  

       } finally 
       {
            this.state.showToast=show;
            this.state.showTryAgaing=showTryAgaing; 
       }

    }
}