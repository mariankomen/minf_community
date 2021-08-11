/*************
Class: Case List Views
Description: extension builds picklist of available list views, using labels for french and ease of change.

Created: Feb 27/13, Vankerk Solutions
Modification Log:
    
*************/
public class CaseListViews {

    public List<selectOption> listnames {get; set;}
    public string selectedlist {get; set;}
    
    public CaseListViews(ApexPages.StandardSetController controller) {
        //selectedlist = '00BU0000002HiMm';
        listnames = new List<selectOption>();
        Profile p = [select id, name from Profile where id = :Userinfo.getprofileid()];
        
        //April 2019, add new FR case lists (name of case list cannot be translated so need to split it out)
        if (p.name.contains('FR')){
            selectedlist = '00B0P000004yFhA';
            
            if (p.name.contains('HR') ) {
                listnames.add(new selectOption('00B0P000004yFh9', Label.All_Closed_Cases_with_MFG)); //View All Closed with MFG
                listnames.add(new selectOption('00B0P000004yFhA', Label.All_Open_Cases_with_MFG)); //View All Open with MFG
                selectedlist = '00B0P000004yFhA'; // default to All Open
            }
            else { 
                listnames.add(new selectOption('00B0P000004yFh8', Label.All_My_Open_Cases)); //View All my open cases
                listnames.add(new selectOption('00B0P000004yFh7', Label.All_Closed_Cases_with_MFG)); //View All my closed cases   
                selectedlist = '00B0P000004yFh8'; // default to All my open cases
            }
        }
        else {
            selectedlist = '00B0P000004yF8F';
        
            // if HR User, show certain list views
            if (p.name.contains('HR') ) {
                listnames.add(new selectOption('00BU0000002HiMN', Label.All_Closed_Cases_with_MFG)); //View All Closed with MFG
                listnames.add(new selectOption('00B0P000004yF8F', Label.All_Open_Cases_with_MFG)); //View All Open with MFG
                selectedlist = '00B0P000004yF8F'; // default to All Open
            }
            // else show All my open cases
            else {
            
                //Jan 2017, the commented out view below was deleted.
                //we had to create a new one '00BQ0000001DITr'
                //listnames.add(new selectOption('00BU0000002HiMm', Label.All_My_Open_Cases)); //View All my open cases
                listnames.add(new selectOption('00B0P0000045srg', Label.All_My_Open_Cases)); //View All my open cases
                listnames.add(new selectOption('00BU0000004TdVE', Label.All_My_Closed_Cases)); //View All my closed cases   
                selectedlist = '00B0P0000045srg'; // default to All my open cases
            } 
        }
   }

   

}