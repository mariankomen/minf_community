/**********
Class: Scheduled Candidate Sharing
Description: until we can fix a problem with new candidates not being correctly shared, this class can be scheduled
    to run every hour on the 45 min to run after hireDesk has completed its integration
    
Created: Feb 6/12

**********/
global class scheduledCandidateSharing implements Schedulable{
   global void execute(SchedulableContext sc) {
      CandidateSharingRecalcLAstHour b = new CandidateSharingRecalcLAstHour(); 
      database.executebatch(b);
   }
   

}