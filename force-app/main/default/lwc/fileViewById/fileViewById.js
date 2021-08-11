import { LightningElement, api, track, wire } from 'lwc';
import getRelatedFilesByRecordId from '@salesforce/apex/TalemetryGateway.getRelatedFiles';
 
export default class ShowPdfRelatedToRecordId extends LightningElement {
    // Current record ID. *recordId* is a reserved identifier
    @api recordId;
    // Declare to pass heightInRem to the child component in markup
    @api heightInRem;
    error;
    // Specify which file for child component to render
    @track fileID;
    pdfFiles = [];
    //
    fileDetails={};
    contenBodyId;
    versionId;
    fileExtension;
    versionData;
 
    @wire(getRelatedFilesByRecordId, { recordId: '$recordId' })
    wiredFieldValue({ error, data }) {
        if (data) {
            this.pdfFiles = JSON.parse(data);
            this.error = undefined;
            console.log('display Data=>'+JSON.stringify(data));
            if(JSON.parse(data)[0] && JSON.parse(data)[0].contentDocumentId) this.fileID=JSON.parse(data)[0].contentDocumentId;
        } else if (error) {
            this.error = error;
            this.pdfFiles = undefined; 
            this.fileID = undefined; 
        }
    }
 
    // Maps file ID and title to tab value and label
    get tabs() {
        if (!this.fileID) return [];
 
        const tabs = [];
        for (var i=0;i<this.pdfFiles.length;i++) {
            tabs.push({
                value: this.pdfFiles[i].contentDocumentId,
                label: this.pdfFiles[i].title
                
            });
            this.fileDetails[this.pdfFiles[i].contentDocumentId+'contenBodyId']=this.pdfFiles[i].contentBodyId;
            this.fileDetails[this.pdfFiles[i].contentDocumentId+'versionId']=this.pdfFiles[i].versionId;
            this.fileDetails[this.pdfFiles[i].contentDocumentId+'fileExtension']=this.pdfFiles[i].fileExtension;
            this.fileDetails[this.pdfFiles[i].contentDocumentId+'versionData']=this.pdfFiles[i].versionData;
        }
        return tabs;
    }
 
    // event handler for each tab: onclick tab, change fileID
    setFileID(e) {
        this.fileID = e.target.value;
        this.contenBodyId=this.fileDetails[e.target.value+'contenBodyId'];
        this.versionId=this.fileDetails[e.target.value+'versionId'];
        this.fileExtension=this.fileDetails[e.target.value+'fileExtension'];
        this.versionData=this.fileDetails[e.target.value+'versionData'];

    }
}