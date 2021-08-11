/************************
Class: Candidate Record Rating, extension for Candidate Record Rating Page and Popup VF pages
Description: handles displaying gold/clear stars based on the current Candidate Record's rating out of 3.
    Can be used for inline VF page with save/refresh option or from window where we want to wait until user
    hits Save button to update rating.

Created: July 25/13, Vankerk Solutions
Modification Log:
    Nov 30/13: updated max rating to 4

************************/
public class CandidateRecordRating{

    public integer maxRating { get; set; }  
    public SFDC_Candidate__c candidate {get; set;}
    public string ratingNotes {get; set;}  // need to hold comments as portal users don't have edit on Can Rec

    // set up properties as needed
    public CandidateRecordRating(ApexPages.StandardController controller) {
        candidate = (SFDC_Candidate__c) controller.getrecord();
        maxrating = 4;
        ratingNotes = candidate.rating_notes__c;
        // if we have a rating value passed in, set our star rating to this
        if (Apexpages.currentpage().getparameters().get('rating') != null) {
            candidate.starrating__c = integer.valueof(Apexpages.currentpage().getparameters().get('rating'));   
        }
    }
    
    public List<starRating> stars;
    // rerun stars query each time to update image based on current rating
    public starRating[] getStars() {
           stars = new List<starRating>();
           for (Integer i = 1; i <= maxRating; i++) {
               stars.add(new starRating(i, (candidate.starrating__c == null ? 0 : candidate.starrating__c)));
           }            
        return stars;
    }
    
    // selection from the page
    public decimal selectedRating {get;
        set{
            // if we selected 1 and were already at 1 it means we want to go to 0
            if (candidate.starrating__c == 1 && value == 1) candidate.starrating__c = 0;
            else candidate.starrating__c = value;
    }}
    
    // save the new rating and return back (used in pop up VF page to then close window)
    public PageReference SaveRating() {
        // using a text field for rating notes since portal users don't have edit rights on candidate
        candidate.rating_notes__c = ratingNotes;
        update candidate;
        return null;

    }
    // save the new rating and reload the page (used in vf page emedded in record)
    public PageReference SaveRatingRefresh() {
        SaveRating();
        PageReference callPage = page.candidaterecordratingpage;
        callPage.getparameters().put('id', candidate.id);
        callPage.setRedirect(true);
        return callpage;  
    }    
    
    // class for stars
    public class starRating{
        public integer rating {get; set;}
        public string imageLink {get;set;}
        public string imageText {get; set;}
        
        public starRating(integer rateNum, decimal currentRating) {
            rating = rateNum;
            // images stored in static resource zip called RatingStars, referenced in VF page
            imageLink = (rateNum <= currentRating ? 'RatingOn' : 'RatingOff') + '.png';
            // if this is rating of 1 and the current rating is 1, show text of setting to 0
            imageText = Label.Set_Rating_to + ' ' + (rating == 1 && currentRating == 1 ? '0' : string.valueof(rateNum));
                
        }
    }
}