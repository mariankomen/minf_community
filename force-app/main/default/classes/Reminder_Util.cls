/*****************************
  Class: Reminder_Util
  Purpose: This class contains utility methods for MFG_Reminder trigger.  Includes testing methods


  Created: Aug 23/09 by Niki Vankerk, Vankerk Solutions, Inc
  Modification Log:
      May 7/10: Added CloseReminder method and type__c field setting in CreateReminders method
      July 13/10: Added labels for french translations
      Aug 11/10: Added code to determine language from Job Owner user record, then coded french/english directly in class because
            Candidates may be added to a Job by an English user (hence code and label are english) but the Job Owner is french
      Nov 3/10: Added code to handle Left Message type of Reminders
*****************************/
public with sharing class Reminder_Util {

    // static variable to track if a trigger has already been run - to avoid double triggers after workflow
    public static boolean firstRun = true; 

    // CreateReminder will generate a MFG_Reminder record for each Job Candidate passed in
    // Input: jcs: list of Job Candidates to attach Reminder, required
    //        action: string indicating the type of reminders to create, required
    public static boolean CreateReminder(List<SFDC_Job_Candidate__c> jcs, string action) {
        // check input values are valid
        if (jcs.isempty() || action == '') return false;
        //system.debug('Job Candidates coming into CreateReminder: '+jcs);
        Set<Id> jobIds = new Set<Id>();
        for (SFDC_Job_Candidate__c jc : jcs) {   
            jobIds.add(jc.sfdc_job__c);
        }
        Map<Id, SFDC_Job__c> jobMap = new Map<Id, SFDC_Job__c>([select id, job_owner_link__c, job_owner_link__r.languagelocalekey from SFDC_Job__c where id in :jobIds]);
        //system.debug('jobMap for related jobs is: '+jobMap);     
        // list to hold new Reminders for mass insert
        List<MFG_Reminder__c> newReminders = new List<MFG_Reminder__c>();
        // cycle through list of JCs and create Reminders for each
        for (SFDC_Job_Candidate__c jc : jcs) {
            string JobLang;
            JobLang = jobMap.get(jc.sfdc_job__c).job_owner_link__r.languagelocalekey;
            //system.debug('language is: '+JobLang);
            MFG_Reminder__c reminder = new MFG_Reminder__c();
            reminder.Candidate__c = jc.Candidate__c;
            reminder.sfdc_job__c = jc.sfdc_job__c;
            reminder.SFDC_job_candidate__c = jc.id;
            reminder.status__c = 'New';
            // if insert due date is today + 5 and different text
            if (action == 'insert') {
                reminder.due_date__c = date.today() + 5;
                // type of reminder is Initial Update
                reminder.type__c = 'Initial Update';                 
                if (JobLang == 'fr') { //french wording for reminder
                    // take first 80 char - the JC Name could put reminder name > 80 char
                    string jcName = 'Candidat disponible pour l\'examen, référence de poste '+jc.Job_ID__c+' - '+TranslateJobTitle(jc.Job_Title__c);
                    reminder.name = jcName.substring(0,(jcName.length() > 80 ? 80 : jcName.length()));
                    // description is rich text area
                    reminder.description__c = 'Le candidat '+jc.Candidate_Name__c+' a été présélectionné et s\'avère qualifié pour l\'offre d\'emploi de '+TranslateJobTitle(jc.Job_Title__c)+
                        ' (référence '+jc.Job_ID__c+').  Une fois que vous avez appelé le candidat pour organiser une entrevue, veuillez mettre à jour son état :'+
                        '\n1.\tAccédez au dossier du candidat ('+jc.url__c+')\n2.\t'+
                        'Cliquez sur le bouton Mettre à jour l’état du candidat et faites passer l\'état à Entrevue en cours. Un message vous demandera d\'indiquer '+
                        'la date de l\'entrevue du candidat.\n3.\tVous devrez également nous tenir au courant de l\'état du ou des candidats présentés.';                     
                }
                else { //english wording
                    // take first 80 char - the JC Name could put reminder name > 80 char
                    string jcName = 'Candidate Available for Review in Job ID '+jc.Job_ID__c+' - '+jc.Job_Title__c;
                    reminder.name = jcName.substring(0,(jcName.length() > 80 ? 80 : jcName.length()));
                    // description is rich text area
                    reminder.description__c = 'The candidate '+jc.Candidate_Name__c+' is screened and qualified for the '+jc.Job_Title__c+
                        ' job opening (Job ID '+jc.Job_ID__c+').  Once you have called the candidate to schedule an interview, please update the '+
                        'status of the candidate by:\n1.\tGoing to the Candidates Record ('+jc.url__c+')\n2.\t'+
                        'Clicking the Update Candidate Status button and changing the candidate\'s status to Interviewing. You will then be prompted '+
                        'to include the date you are interviewing this candidate.\n3.\tYou will also be asked to update us on the status of the candidate(s) '+
                        'presented.'; 
                } // end if/else language for insert
            } else if (action == 'update') {
                // update, due date is interview date + 1 and different subject
                // if we got here without either an interview date or scheduled interview date, just use 7 days out
                if ( jc.interview_date__c == null && jc.scheduled_interview_date_time__c == null)
                    reminder.due_date__c = date.today().adddays(7);
                else
                    // use either interview date or the date portion of the scheduled interview date/time field
                    reminder.due_date__c = (jc.interview_date__c != null ? jc.interview_date__c : jc.scheduled_interview_date_time__c.date()) + 1;
                // type of reminder is Interview
                reminder.type__c = 'Interview'; 
                if (JobLang == 'fr') { //french wording for reminder                                
                    // take first 80 char - the JC Name could put reminder name > 80 char
                    string jcName = 'Mise à jour d\'entrevue de candidat référence de poste '+jc.Job_ID__c+' - '+TranslateJobTitle(jc.Job_Title__c);
                    reminder.name = jcName.substring(0,(jcName.length() > 80 ? 80 : jcName.length()));
                    reminder.description__c = 'Le candidat '+jc.Candidate_Name__c+' a été présélectionné et s\'avère qualifié pour l\'offre d\'emploi de '+TranslateJobTitle(jc.Job_Title__c)+
                        ' (référence '+jc.Job_ID__c+'). Veuillez nous mettre à jour sur les résultats de cette entrevue par :\n1.\t'+
                        'Accédez au dossier du candidat ('+jc.url__c+')\n2.\tEn cliquant sur le statut de candidat de mise à jour boutonnez et changement du candidate'+
                        ' statut de s avec votre décision de location. Si vous souhaitez avoir une autre entrevue, alors mettez à jour svp la date d\'entrevue avec votre '+
                        'nouvelle date.\n3.\tVous devrez également nous tenir au courant de l\'état du ou des candidats présentés.';
                }
                else { //english wording
                    // take first 80 char - the JC Name could put reminder name > 80 char
                    string jcName = 'Candidate Interview Update in Job ID '+jc.Job_ID__c+' - '+jc.Job_Title__c;
                    reminder.name = jcName.substring(0,(jcName.length() > 80 ? 80 : jcName.length()));
                    reminder.description__c = 'Your store indicated two days ago that it was interviewing '+jc.Candidate_Name__c+' on '+reminder.due_date__c.format()+
                        ' for the '+jc.Job_Title__c+' job opening (Job ID '+jc.Job_ID__c+'). Please update us on the outcome of this interview by:\n1.\tGoing to the '+
                        'Candidates Record ('+jc.url__c+')\n2.\tClicking the Update Candidate Status button and changing the candidate\'s status with your hiring decision.'+
                        ' If you wish to have another interview, then please update the Interview Date with your new date.\n3.\tYou will also be asked to update us on the '+
                        'status of the other candidate(s) presented.\n\nThank you!';  
                } // end if/else language for insert                                
            } else  {
            // Message, due date is message date + 3 and different subject
                reminder.due_date__c = jc.candidate_message_date__c + 3;
                // type of reminder is Message
                reminder.type__c = 'Message'; 
                if (JobLang == 'fr') { //french wording for reminder                                
                    // take first 80 char - the JC Name could put reminder name > 80 char
                    string jcName = 'Suivi du Candidat: Numéro d\'Emplois '+jc.Job_ID__c+' - '+TranslateJobTitle(jc.Job_Title__c);
                    reminder.name = jcName.substring(0,(jcName.length() > 80 ? 80 : jcName.length()));
                    reminder.description__c = 'Votre magasin a indiqué il ya trois jours qu\'on avait laissé un message pour '+jc.Candidate_Name__c+' sur '+jc.Candidate_Message_Date__c.format()+
                        ' pour le poste de '+TranslateJobTitle(jc.Job_Title__c)+' (référence '+jc.Job_ID__c+'). S\'il vous plaît nous informer si quelque chose s\'est passé avec ce candidat:'+
                        '\n1.\tAccédez au dossier du candidat ('+jc.url__c+')\n2.\tEn cliquant sur le statut de candidat de mise à jour boutonnez et changement du candidate'+
                        ' statut de s avec votre décision de location. \n3.\tVous devrez également nous tenir au courant de l\'état du ou des candidats présentés.';
                }
                else { //english wording
                    // take first 80 char - the JC Name could put reminder name > 80 char
                    string jcName = 'Candidate Message Follow-Up from Job ID '+jc.Job_ID__c+' - '+jc.Job_Title__c;
                    reminder.name = jcName.substring(0,(jcName.length() > 80 ? 80 : jcName.length()));
                    reminder.description__c = 'Your store indicated three days ago that it had left a message for '+jc.Candidate_Name__c+' on '+jc.candidate_message_date__c.format()+
                        ' for the '+jc.Job_Title__c+' job opening (Job ID '+jc.Job_ID__c+'). Please update us if anything has happened with this candidate by:\n1.\tGoing to the '+
                        'Candidates Record ('+jc.url__c+')\n2.\tClicking the Update Candidate Status button and changing the candidate\'s status with your hiring decision.'+
                        '\n3.\tYou will also be asked to update us on the status of the other candidate(s) presented.\n\nThank you!';  
                } // end if/else language for insert 
            } // end else interview type reminder
            // add reminder to the list
            newReminders.add(reminder);
        } // end loop through JCs
        // now if there are any reminders, insert them
        if (!newReminders.isempty()) {
            try {
                insert newReminders;
            } catch (Exception e) { system.debug('Errors from Reminder_Util.CreateReminder method: '+e); // continue with method 
            } // end try/catch segment
        } // end if there are reminders
                
        return true;
    }

    // DeleteReminder will close any open MFG_Reminder records of a certain Type for each Job Candidate passed in
    // Input: jcs: list of Job Candidates to check for open Reminders, required
    //        ReminderType: string indicating the type of reminders to close, required
    public static boolean CloseReminder(List<SFDC_Job_Candidate__c> jcs, string ReminderType) {
        // check input values are valid
        if (jcs.isempty() || ReminderType == '') return false;
        // list to hold Reminders for mass delete
        List<MFG_Reminder__c> clsReminders = new List<MFG_Reminder__c>();
        // cycle through list of JCs and find open Reminders for each
        for (MFG_Reminder__c r : [select id from MFG_Reminder__c where status__c != 'Complete' and type__c = :ReminderType and SFDC_Job_Candidate__c in :jcs]) {
            r.status__c = 'Complete';
            clsReminders.add(r);
        } // end loop through open Reminders

        // now if there are any reminders, update them
        if (!clsReminders.isempty()) {
            try {
                update clsReminders;
            } catch (Exception e) { system.debug('Errors from Reminder_Util.CloseReminder method: '+e); // continue with method 
            } // end try/catch segment
        } // end if there are reminders

        // send back that we completed        
        return true;
    }


    // TranslateJobTitle will take in text and send back the translation if we have it
    // Input: JobTitle is english text of the Job's Job Title field
    public static string TranslateJobTitle(string JobTitle) {
        // if we have a translation, send back French, otherwise send back our original input
        if (JobTitle == 'Operations Manager') return 'Directeur opérations';
        if (JobTitle == 'Product Process Manager') return 'Directeur de processus de produit';
        if (JobTitle == 'Sales Manager') return 'Directeur commercial';
        if (JobTitle == 'General Manager') return 'Directeur général';
        // if we get here we didn't find a match so sent the original back        
        return JobTitle;
    }

    // test code to ensure reminders are generated for each insert with Qualified Candidates as status
    
   
}