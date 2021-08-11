import { LightningElement, api } from 'lwc';
 
export default class ShowPdfById extends LightningElement {
    @api fileId;
    @api heightInRem;

    @api contenBodyId;
    @api versionId;
    @api fileExtension;
    @api versionData;
    isDoc=false;
    isHTML=false;
    isDocxPdf=false;
    get pdfHeight() {
        return this.heightInRem + 'rem';
    }
    get url() {
       return '/sfc/servlet.shepherd/version/renditionDownload?rendition=SVGZ&versionId='+this.versionId+'&operationContext=CHATTER&contentId='+this.contenBodyId+'&page=0';
    }
    get htmlHeight()
    {
        return 'height:'+this.heightInRem+'rem';
    }
    get docDownload()
    {
        return '/sfc/servlet.shepherd/document/download/' + this.fileId;
    }
    renderedCallback() {
        if(this.isHTML){
            this.template.querySelector('.htmlcontainer').innerHTML =this.versionData;
         }
    }
   
    get loadValues()
    {
        if(this.fileExtension==='html')
        {
            this.isHTML=true; 
            this.isDoc=false;
            this.isDocxPdf=false;
        }
        else if(this.fileExtension==='doc'){
            this.isDoc=true;
            this.isHTML=false; 
            this.isDocxPdf=false;
        }
        else{
            this.isDocxPdf=true;
            this.isDoc=false;
            this.isHTML=false;
        }
    }
}