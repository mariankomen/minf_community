/*************
Class: Candidate List Views
Description: extension builds picklist of available list views, using labels for french and ease of change and OFG users seeing more
    details list views than non-OFG users.

Created: Jan 27/13, Vankerk Solutions
Modification Log:
    Jan 30/13, added views for AN and easyhome
    Aug 3/13, added support for URL parameter for listId, used by Candidate Rating popup to know which list view was being used
    Feb 21/15, GB - Added Views based on User field - Multi-Service User (passed from Client Profile.Multi-Service Enabled)
    July 27/15: added support for tracking last selected list view in custom setting
    Nov 10/15: MK - added custom view based on urgent NWC request
    
*************/
public class CandidateListViews { 

    public List<selectOption> listnames {get; set;}
    public string selectedlist {get; set;}
    
    public CandidateListViews(ApexPages.StandardSetController controller) {
        selectedlist = '00BU0000004AnI1';
        listnames = new List<selectOption>();
        Profile p = [select id, name from Profile where id = :Userinfo.getprofileid()];
      //User currUser = [select id, Multi_Service_User__c from User where id = :userinfo.getUserId()];

        // if Akzo HR, show certain list views
        if (p.name == 'AkzoNobel HirePortal HR User EN' || p.name == 'AkzoNobel HirePortal HR User FR') {
            listnames.add(new selectOption('00BU0000002Ijvv', Label.All_Active_Dulux_Candidates)); //View Active Candidates for Dulux/Betonel
            listnames.add(new selectOption('00BU0000002Ijvg', Label.All_Active_PPG_Candidates)); //View Active Candidates for PPG Architectural
            listnames.add(new selectOption('00BU0000002Ijw0', Label.All_Current_Dulux_Employee)); //View Current Employees for Dulux/Betonel
            listnames.add(new selectOption('00BU0000002Ijvl', Label.All_Current_PPG_Employee)); //View Current Employees for PPG Architectural
            listnames.add(new selectOption('00BU0000002HiLK', Label.All_Inactive_Candidates)); //View Inactive Candidates
            listnames.add(new selectOption('00BU0000002HiLU', Label.All_Past_Employee)); //View Past Employees
            selectedlist = '00BU0000002HiLF'; // default to Active
        }
        // if Akzo RM EN or store, show certain list views
        else if (p.name == 'AkzoNobel HirePortal Regional Mgr EN' || p.name == 'AkzoNobel HirePortal Regional Mgr FR' ||
                 p.name == 'AkzoNobel HirePortal Store User EN' || p.name == 'AkzoNobel HirePortal Store User FR' || p.name == 'AkzoNobel HirePortal Store User EN - Int Sch') {
            listnames.add(new selectOption('00BU0000002HkUD', Label.All_Active_Candidates)); //View Active Candidates
            listnames.add(new selectOption('00BU0000002HkUI', Label.All_Current_Employee)); //View Current Employees
            listnames.add(new selectOption('00BU0000002HkUN', Label.All_Inactive_Candidates)); //View Inactive Candidates
            listnames.add(new selectOption('00BU0000002HkUS', Label.All_Past_Employee)); //View Past Employees
            selectedlist = '00BU0000002HkUD'; // default to Active
        } 
        
        // if PPG USA
        else if (p.name == 'PPG USA Hireportal Region MGR EN' || p.name == 'PPG USA Hireportal Store User EN' ) {
            listnames.add(new selectOption('00BU0000004Pfrk', Label.All_Active_Candidates)); //View Active Candidates
            listnames.add(new selectOption('00BU0000002HkUI', Label.All_Current_Employee)); //View Current Employees
            listnames.add(new selectOption('00BU0000002HkUN', Label.All_Inactive_Candidates)); //View Inactive Candidates
            listnames.add(new selectOption('00BU0000002HkUS', Label.All_Past_Employee)); //View Past Employees
            selectedlist = '00BU0000004Pfrk'; // default to Active
        }
        // if PPG USA
        else if ( p.name == 'PPG USA Hireportal HR UserEN') {
            listnames.add(new selectOption('00BU0000004Pm3K', Label.All_Active_Candidates)); //View Active Candidates
            listnames.add(new selectOption('00BU0000002HkUI', Label.All_Current_Employee)); //View Current Employees
            listnames.add(new selectOption('00BU0000002HkUN', Label.All_Inactive_Candidates)); //View Inactive Candidates
            listnames.add(new selectOption('00BU0000002HkUS', Label.All_Past_Employee)); //View Past Employees
            selectedlist = '00BU0000004Pm3K'; // default to Active
            
        }
       
        // Tim Hortons NSM - Oct, 2017
        else if (p.name == 'Tim Hortons hireportal HR User (NSM) EN' || p.name == 'Tim Hortons hireportal RGL (NSM) EN' || p.name == 'Tim Hortons hireportal Store User (NSM) EN') {
            listnames.add(new selectOption('00B0P000004ulpT', Label.All_Active_Candidates)); //View Active Candidates
            listnames.add(new selectOption('00BU0000002HkUI', Label.All_Current_Employee)); //View Current Employees
            listnames.add(new selectOption('00B0P000004ulpU', Label.All_Inactive_Candidates)); //View Inactive Candidates
            listnames.add(new selectOption('00BU0000002HkUS', Label.All_Past_Employee)); //View Past Employees
            selectedlist = '00B0P000004ulpT'; // default to Active
        }
        
        // Wendys NSM - Nov, 2017
        else if (p.name == 'Wendys hireportal HR User (NSM) EN' || p.name == 'Wendys hireportal RGL (NSM) EN' || p.name == 'Wendys hireportal Store User (NSM) EN') {
            listnames.add(new selectOption('00B0P000004uokC', Label.All_Active_Candidates)); //View Active Candidates
            listnames.add(new selectOption('00BU0000002HkUI', Label.All_Current_Employee)); //View Current Employees
            listnames.add(new selectOption('00B0P000004uokD', Label.All_Inactive_Candidates)); //View Inactive Candidates
            listnames.add(new selectOption('00BU0000002HkUS', Label.All_Past_Employee)); //View Past Employees
            selectedlist = '00B0P000004uokC'; // default to Active
        }
        
        // Ecoservice Group - Dec, 2018
        else if (p.name == 'Eco Group hireportal HR User (NSM) EN' || p.name == 'Eco Group hireportal RGL (NSM) EN' || p.name == 'Eco Group hireportal Store User (NSM) EN') {
            listnames.add(new selectOption('00B0P000004i7JM', 'View Active Candidates - Ecoservice Group')); //View Active Candidates
            listnames.add(new selectOption('00BU0000002HkUI', Label.All_Current_Employee)); //View Current Employees
            listnames.add(new selectOption('00B0P000004i7JN', 'View Inactive Candidates - Ecoservice Group')); //View Inactive Candidates
            //listnames.add(new selectOption('00BU0000002HkUS', Label.All_Past_Employee)); //View Past Employees
            selectedlist = '00B0P000004i7JM'; // default to Active
        }
        
        // Golf Town - March, 2019
        else if (p.name == 'Golf Town hireportal HR User (NSM) EN' || p.name == 'Golf Town hireportal Store User (NSM) EN') {
            listnames.add(new selectOption('00B0P000004yFhB', Label.All_Active_Candidates)); //View Active Candidates
            listnames.add(new selectOption('00BU0000002HkUI', Label.All_Current_Employee)); //View Current Employees
            listnames.add(new selectOption('00B0P000004yFhD', Label.All_Inactive_Candidates)); //View Inactive Candidates
            selectedlist = '00B0P000004yFhB'; // default to Active
        }
        else if (p.name ==  'Golf Town hireportal HR User (NSM) FR' || p.name == 'Golf Town hireportal Store User (NSM) FR') {
            listnames.add(new selectOption('00B0P000004yFhC', Label.All_Active_Candidates)); //View Active Candidates
            listnames.add(new selectOption('00BU0000002HkUI', Label.All_Current_Employee)); //View Current Employees
            listnames.add(new selectOption('00B0P000004yFhE', Label.All_Inactive_Candidates)); //View Inactive Candidates
            selectedlist = '00B0P000004yFhC'; // default to Active
        }
        
         else if (p.name == 'Sporting Life HR User (NSM) EN' || p.name == 'Sporting Life Store User (NSM) EN') {
            listnames.add(new selectOption('00B0P000004wEzG', Label.All_Active_Candidates)); //View Active Candidates
            listnames.add(new selectOption('00BU0000002HkUI', Label.All_Current_Employee)); //View Current Employees
            listnames.add(new selectOption('00B0P000004wEzL', Label.All_Inactive_Candidates)); //View Inactive Candidates
            selectedlist = '00B0P000004wEzG'; // default to Active
        }
          else if (p.name == 'Sporting Life HR User (NSM) FR'|| p.name == 'Sporting Life Store User (NSM) FR') {
            listnames.add(new selectOption('00B0P000004wEzQ', Label.All_Active_Candidates)); //Voir les candidats actifs
            listnames.add(new selectOption('00B0P000004wFBH', Label.All_Current_Employee)); //Voir les employés actuels
            listnames.add(new selectOption('00B0P000004wEzV', Label.All_Inactive_Candidates)); //Afficher les candidats inactifs
            selectedlist = '00B0P000004wEzQ'; // default to Active
        }
          
           
        // if HirePortal Regional MFGOD
        else if (p.name == 'MFG TalentReach HirePortal Regional Manager EN'|| p.name == 'MFG TalentReach HirePortal Store User EN') {
            listnames.add(new selectOption('00BU0000002HkUD', Label.All_Active_Candidates)); //View Active Candidates
            listnames.add(new selectOption('00BU0000002HkUN', Label.All_Inactive_Candidates)); //View Inactive Candidates
            listnames.add(new selectOption('00BU0000002HiLU', Label.All_Past_Employee)); //View Past Employees
            listnames.add(new selectOption('00BU0000003BOqu', Label.View_Active_4_Star_Candidates)); //View 4 Star Active Candidates
            listnames.add(new selectOption('00BU0000003BOqt', Label.View_Active_3_Star_Candidates)); //View 3 Star Active Candidates
            listnames.add(new selectOption('00BU0000003BOqs', Label.View_Active_2_Star_Candidates)); //View 2 Star Active Candidates
            listnames.add(new selectOption('00BU0000003BOqr', Label.View_Active_1_Star_Candidates)); //View 1 Star Active Candidates
            selectedlist = '00BU0000002HkUD'; // default to Active EF
        }
        //if HirePortal Regional MFGOD HR Users
        else if (p.name == 'MFG TalentReach HirePortal HR User EN') {
            listnames.add(new selectOption('00BU0000003Dyci', Label.All_Active_Candidates)); //View Active Candidates
            listnames.add(new selectOption('00BU0000002HkUN', Label.All_Inactive_Candidates)); //View Inactive Candidates
            listnames.add(new selectOption('00BU0000002HiLU', Label.All_Past_Employee)); //View Past Employees
            listnames.add(new selectOption('00BU0000003BOqu', Label.View_Active_4_Star_Candidates)); //View 4 Star Active Candidates
            listnames.add(new selectOption('00BU0000003BOqt', Label.View_Active_3_Star_Candidates)); //View 3 Star Active Candidates
            listnames.add(new selectOption('00BU0000003BOqs', Label.View_Active_2_Star_Candidates)); //View 2 Star Active Candidates
            listnames.add(new selectOption('00BU0000003BOqr', Label.View_Active_1_Star_Candidates)); //View 1 Star Active Candidates
            selectedlist = '00BU0000003Dyci'; // default to Active EF
        }
        // if HirePortal Regional FGL HR
        else if (p.name == 'FGL Sports HirePortal HR User EN') {
            listnames.add(new selectOption('00BU0000002IIV2', Label.All_Active_Candidates_FGL)); //View Active Candidates
            listnames.add(new selectOption('00BU0000002IIUx', Label.View_Active_Candidates_Marks)); //View Active Candidates
            listnames.add(new selectOption('00BU0000002HkUN', Label.All_Inactive_Candidates)); //View Inactive Candidates
            selectedlist = '00BU0000002IIV2'; // default to Active
        }
        
        else if (p.name == 'Marks HirePortal Store User FR') {
            listnames.add(new selectOption('00B0P000004wHNf', Label.All_Active_Candidates)); //View Active Candidates
            listnames.add(new selectOption('00B0P000004wHNk', Label.All_Inactive_Candidates)); //View Inactive Candidates
            selectedlist = '00B0P000004wHNf'; // default to Active
        }
        
        else if (p.name == 'Marks HirePortal Regional Mgr FR') {
            listnames.add(new selectOption('00B0P000004wLo2', Label.All_Active_Candidates)); //View Active Candidates
            listnames.add(new selectOption('00B0P000004wLo7', Label.All_Inactive_Candidates)); //View Inactive Candidates
            selectedlist = '00B0P000004wLo2'; // default to Active
        }
        
        else if (p.name == 'Canadian Tire hireportal Store User EN'|| p.name == 'Canadian Tire hireportal RGL EN' || p.name =='Canadian Tire hireportal HR User EN' ||
                 p.name == 'Canadian Tire hireportal HR User EN - NSM'|| p.name == 'Canadian Tire hireportal RGL EN - NSM' || p.name =='Canadian Tire hireportal Store User EN - NSM') {
            listnames.add(new selectOption('00B0P000004urIp', Label.All_Active_Candidates)); //View Active Candidates
            listnames.add(new selectOption('00BU0000002HkUI', Label.All_Current_Employee)); //View Current Employees
            listnames.add(new selectOption('00B0P000004urIz', Label.All_Inactive_Candidates)); //View Inactive Candidates
            listnames.add(new selectOption('00BU0000002HkUS', Label.All_Past_Employee)); //View Past Employees
            selectedlist = '00BU0000002HkUD';
        }
        
        else if (p.name.startswith('MFG TalentDrive')) {
            listnames.add(new selectOption('00BU0000002HkUD', Label.All_Active_Candidates)); //View Active Candidates
            listnames.add(new selectOption('00BU0000002HkUI', Label.All_Current_Employee)); //View Current Employees
            listnames.add(new selectOption('00BU0000002HkUN', Label.All_Inactive_Candidates)); //View Inactive Candidates
            listnames.add(new selectOption('00BU0000002HkUS', Label.All_Past_Employee)); //View Past Employees
            selectedlist = '00BU0000002HkUD';
        }
        
        // if any TalentConnect, add Active/Inactive options and View Starred Candidates
        else if ((p.name.startswith('COBS')) || (p.name.startswith('Edible Canada')) || (p.name.startswith('Fountain Tire')) || (p.name.startswith('General Paint')) || 
                (p.name.startswith('GrowthWorks')) ||  (p.name.startswith('Mr. Lube HirePortal')) || (p.name.startswith('Olsen Europe'))   || (p.name.startswith('No Limits')) || p.name =='The Grocery Shop HirePortal Store User EN') {
            listnames.add(new selectOption('00BU0000002HiLF', Label.All_Active_Candidates)); //View Active Candidates
            listnames.add(new selectOption('00BU0000002HiLP', Label.All_Current_Employee)); //View Current Employees
            listnames.add(new selectOption('00BU0000002HiLK', Label.All_Inactive_Candidates)); //View Inactive Candidates
            listnames.add(new selectOption('00BU0000002HiLU', Label.All_Past_Employee)); //View Past Employees
            listnames.add(new selectOption('00BU0000003BOqu', Label.View_Active_4_Star_Candidates)); //View 4 Star Active Candidates
            listnames.add(new selectOption('00BU0000003BOqt', Label.View_Active_3_Star_Candidates)); //View 3 Star Active Candidates
            listnames.add(new selectOption('00BU0000003BOqs', Label.View_Active_2_Star_Candidates)); //View 2 Star Active Candidates
            listnames.add(new selectOption('00BU0000003BOqr', Label.View_Active_1_Star_Candidates)); //View 1 Star Active Candidates       
            selectedlist = '00BU0000002HiLF'; // default to Active
        }
        else if (p.name == 'Marks HirePortal Regional Mgr EN' || p.name == 'FGL Sports HirePortal Regional Manager EN' || p.name == 'FGL Sports HirePortal Regional Manager FR') {
            listnames.add(new selectOption('00BU0000002HkUD', Label.All_Active_Candidates)); //View Active Candidates
            listnames.add(new selectOption('00BU0000002HkUI', Label.All_Current_Employee)); //View Current Employees
            listnames.add(new selectOption('00BU0000002HkUN', Label.All_Inactive_Candidates)); //View Inactive Candidates
            listnames.add(new selectOption('00BU0000002HkUS', Label.All_Past_Employee)); //View Past Employees
            selectedlist = '00BU0000002HkUD'; // default to Active
        } 
        
        // if any other non-OWF user, add Active/Inactive options
        else if ((!p.name.startswith('OFG')) && (!p.name.startswith('easyhome')) && (!p.name.startswith('MFG TalentDrive HirePortal Regional')) && (!p.name.startswith('Kal Tire HirePortal Regional Mgr EN')) 
                && (!p.name.startswith('FGL Sports HirePortal HR User')) && (!p.name.startswith('Akzo')) && (!p.name.startswith('easyfinancial')) && (!p.name.startswith('COBS')) && (!p.name.startswith('Edible Canada')) 
                && (!p.name.startswith('Fountain Tire')) && (!p.name.startswith('General Paint')) && (!p.name.startswith('GrowthWorks'))  && (!p.name.startswith('Proline'))&& (!p.name.startswith('MFG TalentReach')) && 
                (!p.name.startswith('Mr. Lube HirePortal')) && (!p.name.startswith('Olsen Europe')) && (!p.name.startswith('Paws & Claws'))) {
            listnames.add(new selectOption('00BU0000002HiLF', Label.All_Active_Candidates)); //View Active Candidates
            listnames.add(new selectOption('00BU0000002HiLP', Label.All_Current_Employee)); //View Current Employees
            listnames.add(new selectOption('00BU0000002HiLK', Label.All_Inactive_Candidates)); //View Inactive Candidates
            listnames.add(new selectOption('00BU0000002HiLU', Label.All_Past_Employee)); //View Past Employees          
            selectedlist = '00BU0000002HiLF'; // default to Active
        }

         /* Deprecated Accounts **************************************************************************************************************/ 
         
          /* Country Grocer - April 18, 2017
            else if (p.name == 'Country Grocer Hireportal HR User EN' || p.name == 'Country Grocer Hireportal Reg MGR EN' || p.name == 'Country Grocer Hireportal Store User EN') {
                listnames.add(new selectOption('00B0P0000046C6e', Label.All_Active_Candidates)); //View Active Candidates
                listnames.add(new selectOption('00BU0000002HkUI', Label.All_Current_Employee)); //View Current Employees
                listnames.add(new selectOption('00B0P0000046C6f', Label.All_Inactive_Candidates)); //View Inactive Candidates
                listnames.add(new selectOption('00BU0000002HkUS', Label.All_Past_Employee)); //View Past Employees
                selectedlist = '00B0P0000046C6e'; // default to Active
            }
          */
         
          /* if Multi-Service is Enabled, show certain list views
                if (p.name == '1800GotJunk HirePortal REG User' || p.name == '1800GotJunk HirePortal STORE User' || p.name == '1800GotJunk HirePortal REG User Preview' || p.name == '1800GotJunk HirePortal STORE User Preview') {
                    listnames.add(new selectOption('00BU0000003EJpH', Label.View_All_Active_Sourcing_Candidates)); 
                    listnames.add(new selectOption('00BU0000003EJpM', Label.View_All_Active_Recruitment_Candidates)); 
                    listnames.add(new selectOption('00BU0000002HkUI', Label.All_Current_Employee)); 
                    listnames.add(new selectOption('00BU0000003EJpW', Label.View_All_Inactive_Sourcing_Candidates)); 
                    listnames.add(new selectOption('00BU0000003EJpR', Label.View_All_Inactive_Recruitment_Candidates)); 
                    selectedlist = '00BU0000003EJpH'; // default to Active
                }
        
                //if Got Junk HR Users, show certain list views
                else if (p.name == '1800GotJunk HirePortal HR User EN' || p.name == '1800GotJunk HirePortal HR User EN Preview') {
                    listnames.add(new selectOption('00BU0000003Dyci', Label.All_Active_Candidates)); //View Active Candidates
                    listnames.add(new selectOption('00BU0000002HkUN', Label.All_Inactive_Candidates)); //View Inactive Candidates
                    listnames.add(new selectOption('00BU0000002HiLP', Label.All_Current_Employee)); 
                    listnames.add(new selectOption('00BU0000002HiLU', Label.All_Past_Employee)); //View Past Employees
        
                    selectedlist = '00BU0000003Dyci'; // default to Active EF
                }
                */
        
                /*Kitchen Stuff Plus
                else if (p.name == 'Kitchen Stuff Plus Hireportal Store User EN' || p.name == 'Kitchen Stuff Plus Hireportal Reg MGR EN' || p.name == 'Kitchen Stuff Plus Hireportal HR User EN') {
                    listnames.add(new selectOption('00BU0000004Pg87', Label.All_Active_Candidates)); //View Active Candidates
                    listnames.add(new selectOption('00BU0000002HkUI', Label.All_Current_Employee)); //View Current Employees
                    listnames.add(new selectOption('00BU0000002HiLK', Label.All_Inactive_Candidates)); //View Inactive Candidates
                    listnames.add(new selectOption('00BU0000002HkUS', Label.All_Past_Employee)); //View Past Employees
                    selectedlist = '00BU0000002HkUD'; // default to Active
                    
                }
                
                // Turnabout - Sept 20, 2016
                else if (p.name == 'Turnabout Hireportal HR User EN' || p.name == 'Turnabout Hireportal Reg MGR EN' || p.name == 'Turnabout Hireportal Store User EN') {
                    listnames.add(new selectOption('00B0P0000045h95', Label.All_Active_Candidates)); //View Active Candidates
                    listnames.add(new selectOption('00BU0000002HkUI', Label.All_Current_Employee)); //View Current Employees
                    listnames.add(new selectOption('00B0P0000045h96', Label.All_Inactive_Candidates)); //View Inactive Candidates
                    listnames.add(new selectOption('00BU0000002HkUS', Label.All_Past_Employee)); //View Past Employees
                    selectedlist = '00B0P0000045h95'; // default to Active
                    
                }*/
        
                /* DirectTap - May, 2017
                else if (p.name == 'DirectTap Hireportal HR User EN' || p.name == 'DirectTap Hireportal Reg MGR EN' || p.name == 'DirectTap Hireportal Store User EN') {
                    listnames.add(new selectOption('00B0P000004ogMt', Label.All_Active_Candidates)); //View Active Candidates
                    listnames.add(new selectOption('00BU0000002HkUI', Label.All_Current_Employee)); //View Current Employees
                    listnames.add(new selectOption('00B0P000004ogMu', Label.All_Inactive_Candidates)); //View Inactive Candidates
                    listnames.add(new selectOption('00BU0000002HkUS', Label.All_Past_Employee)); //View Past Employees
                    selectedlist = '00B0P000004ogMt'; // default to Active
                    
                }*/
        
                /* Capilano Golf - Jan, 2018
                else if (p.name == 'Capilano Golf and Country Club hireportal HR User (NSM) EN' || p.name == 'Capilano Golf and Country Club hireportal RGL (NSM) EN' || p.name == 'Capilano Golf and Country Club hireportal Store User (NSM) EN') {
                    listnames.add(new selectOption('00B0P000004uzaZ', Label.All_Active_Candidates)); //View Active Candidates
                    listnames.add(new selectOption('00BU0000002HkUI', Label.All_Current_Employee)); //View Current Employees
                    listnames.add(new selectOption('00B0P000004uzae', Label.All_Inactive_Candidates)); //View Inactive Candidates
                    listnames.add(new selectOption('00BU0000002HkUS', Label.All_Past_Employee)); //View Past Employees
                    selectedlist = '00B0P000004uzaZ'; // default to Active
                }
                
               // Wallace & Carey Inc - Jan, 2018
                else if (p.name == 'W & C Inc hireportal HR User (NSM) EN' || p.name == 'W & C Inc hireportal RGL (NSM) EN' || p.name == 'W & C Inc hireportal Store User (NSM) EN') {
                    listnames.add(new selectOption('00B0P000004v0yS', Label.All_Active_Candidates)); //View Active Candidates
                    listnames.add(new selectOption('00BU0000002HkUI', Label.All_Current_Employee)); //View Current Employees
                    listnames.add(new selectOption('00B0P000004v0yr', Label.All_Inactive_Candidates)); //View Inactive Candidates
                    listnames.add(new selectOption('00BU0000002HkUS', Label.All_Past_Employee)); //View Past Employees
                    selectedlist = '00B0P000004v0yS'; // default to Active
                }*/
        
        
        
                /*Dealer Intelligence non HR
                else if (p.name == 'Dealer Intelligence Regional User EN' || p.name == 'Dealer Intelligence Store User EN' ) {
                    listnames.add(new selectOption('00BU0000004AfvK', Label.All_Active_Candidates)); //View Active Candidates
                    listnames.add(new selectOption('00BU0000002HkUI', Label.All_Current_Employee)); //View Current Employees
                    listnames.add(new selectOption('00BU0000002HiLK', Label.All_Inactive_Candidates)); //View Inactive Candidates
                    listnames.add(new selectOption('00BU0000002HkUS', Label.All_Past_Employee)); //View Past Employees
                    selectedlist = '00BU0000002HkUD'; // default to Active
                    
                }
                
                //Dealer Intelligence HR
                else if (p.name == 'Dealer Intelligence HR User EN') {
                    listnames.add(new selectOption('00BU0000004AfvK', Label.All_Active_Candidates)); //View Active Candidates
                    listnames.add(new selectOption('00BU0000002HkUI', Label.All_Current_Employee)); //View Current Employees
                    listnames.add(new selectOption('00BU0000002HiLK', Label.All_Inactive_Candidates)); //View Inactive Candidates
                    listnames.add(new selectOption('00BU0000002HkUS', Label.All_Past_Employee)); //View Past Employees
                    selectedlist = '00BU0000002HkUD'; // default to Active
                    
                }
                
                // if easyfinancial/easyhome master user, show different views
                else if (p.name == 'easyfinancial and easyhome Head HirePortal HR (EH Focus) User EN') {
                    listnames.add(new selectOption('00BU0000002HkgT', Label.All_Active_CandidatesEF)); //View Active Cand - EF
                    listnames.add(new selectOption('00BU0000002HkgJ', Label.All_Active_CandidatesEH)); //View Active Cand - EH
                    listnames.add(new selectOption('00BU0000002HrQP', Label.All_Active_CandidatesEHSupport)); //View Active Cand - EH Support Center
                    listnames.add(new selectOption('00BU0000002HiLP', Label.All_Current_Employee)); //View Current Employees
                    listnames.add(new selectOption('00BU0000002HiLK', Label.All_Inactive_Candidates)); //View Inactive Candidates
                    listnames.add(new selectOption('00BU0000002HiLU', Label.All_Past_Employee)); //View Past Employees
                    listnames.add(new selectOption('00BU0000003BOqu', Label.View_Active_4_Star_Candidates)); //View 4 Star Active Candidates
                    listnames.add(new selectOption('00BU0000003BOqt', Label.View_Active_3_Star_Candidates)); //View 3 Star Active Candidates
                    listnames.add(new selectOption('00BU0000003BOqs', Label.View_Active_2_Star_Candidates)); //View 2 Star Active Candidates
                    listnames.add(new selectOption('00BU0000003BOqr', Label.View_Active_1_Star_Candidates)); //View 1 Star Active Candidates           
                    selectedlist = '00BU0000002HkgJ'; // default to Active EH
                } 
                // if easyfinancial/easyhome master user, show different views
                else if (p.name == 'easyfinancial and easyhome Head HirePortal HR (EF Focus) User EN') {
                    listnames.add(new selectOption('00BU0000002HkgT', Label.All_Active_CandidatesEF)); //View Active Cand - EF
                    listnames.add(new selectOption('00BU0000002HkgJ', Label.All_Active_CandidatesEH)); //View Active Cand - EH
                    listnames.add(new selectOption('00BU0000002HrQP', Label.All_Active_CandidatesEHSupport)); //View Active Cand - EH Support Center
                    listnames.add(new selectOption('00BU0000002HiLP', Label.All_Current_Employee)); //View Current Employees
                    listnames.add(new selectOption('00BU0000002HiLK', Label.All_Inactive_Candidates)); //View Inactive Candidates
                    listnames.add(new selectOption('00BU0000002HiLU', Label.All_Past_Employee)); //View Past Employees
                    listnames.add(new selectOption('00BU0000003BOqu', Label.View_Active_4_Star_Candidates)); //View 4 Star Active Candidates
                    listnames.add(new selectOption('00BU0000003BOqt', Label.View_Active_3_Star_Candidates)); //View 3 Star Active Candidates
                    listnames.add(new selectOption('00BU0000003BOqs', Label.View_Active_2_Star_Candidates)); //View 2 Star Active Candidates
                    listnames.add(new selectOption('00BU0000003BOqr', Label.View_Active_1_Star_Candidates)); //View 1 Star Active Candidates           
                    selectedlist = '00BU0000002HkgT'; // default to Active EF
                }
                // if easyhome, show different views
                else if (p.name == 'easyhome HirePortal HR User EN' || p.name == 'easyhome HirePortal Regional Mgr EN' || p.name == 'easyhome HirePortal Store User EN') {
                    listnames.add(new selectOption('00BU0000002HkgJ', Label.All_Active_CandidatesEH)); //View Active Cand - EH
                    listnames.add(new selectOption('00BU0000002HiLP', Label.All_Current_Employee)); //View Current Employees
                    listnames.add(new selectOption('00BU0000002HiLK', Label.All_Inactive_Candidates)); //View Inactive Candidates
                    listnames.add(new selectOption('00BU0000002HiLU', Label.All_Past_Employee)); //View Past Employees
                    listnames.add(new selectOption('00BU0000003BOqu', Label.View_Active_4_Star_Candidates)); //View 4 Star Active Candidates
                    listnames.add(new selectOption('00BU0000003BOqt', Label.View_Active_3_Star_Candidates)); //View 3 Star Active Candidates
                    listnames.add(new selectOption('00BU0000003BOqs', Label.View_Active_2_Star_Candidates)); //View 2 Star Active Candidates
                    listnames.add(new selectOption('00BU0000003BOqr', Label.View_Active_1_Star_Candidates)); //View 1 Star Active Candidates           
                    selectedlist = '00BU0000002HkgJ'; // default to Active EH
                }
                // if easyfinancial, show different views
                else if (p.name == 'easyfinancial HirePortal HR User EN' || p.name == 'easyfinancial HirePortal Regional Mgr EN' || p.name == 'easyfinancial HirePortal Store User EN') {
                    listnames.add(new selectOption('00BU0000002HkgT', Label.All_Active_CandidatesEF)); //View Active Cand - EF
                    listnames.add(new selectOption('00BU0000002HiLP', Label.All_Current_Employee)); //View Current Employees
                    listnames.add(new selectOption('00BU0000002HiLK', Label.All_Inactive_Candidates)); //View Inactive Candidates
                    listnames.add(new selectOption('00BU0000002HiLU', Label.All_Past_Employee)); //View Past Employees
                    listnames.add(new selectOption('00BU0000003BOqu', Label.View_Active_4_Star_Candidates)); //View 4 Star Active Candidates
                    listnames.add(new selectOption('00BU0000003BOqt', Label.View_Active_3_Star_Candidates)); //View 3 Star Active Candidates
                    listnames.add(new selectOption('00BU0000003BOqs', Label.View_Active_2_Star_Candidates)); //View 2 Star Active Candidates
                    listnames.add(new selectOption('00BU0000003BOqr', Label.View_Active_1_Star_Candidates)); //View 1 Star Active Candidates           
                    selectedlist = '00BU0000002HkgT'; // default to Active EF
                }
                // if HirePortal ProLineTrucking Regional
                else if (p.name == 'Proline Trucking Hireportal Store User User EN'|| p.name == 'Proline Trucking Hireportal Rergional User EN') {
                    listnames.add(new selectOption('00BU0000002HkUD', Label.All_Active_Candidates)); //View Active Candidates
                    listnames.add(new selectOption('00BU0000002HkUN', Label.All_Inactive_Candidates)); //View Inactive Candidates
                    listnames.add(new selectOption('00BU0000002HiLU', Label.All_Past_Employee)); //View Past Employees
                    listnames.add(new selectOption('00BU0000003BOqu', Label.View_Active_4_Star_Candidates)); //View 4 Star Active Candidates
                    listnames.add(new selectOption('00BU0000003BOqt', Label.View_Active_3_Star_Candidates)); //View 3 Star Active Candidates
                    listnames.add(new selectOption('00BU0000003BOqs', Label.View_Active_2_Star_Candidates)); //View 2 Star Active Candidates
                    listnames.add(new selectOption('00BU0000003BOqr', Label.View_Active_1_Star_Candidates)); //View 1 Star Active Candidates
                    selectedlist = '00BU0000002HkUD'; // default to Active EF
                }
                
                //if HirePortal Proline Trucking HR Users
                else if (p.name == 'Proline Trucking Hireportal HR User EN') {
                    listnames.add(new selectOption('00BU0000003Dyci', Label.All_Active_Candidates)); //View Active Candidates
                    listnames.add(new selectOption('00BU0000002HkUN', Label.All_Inactive_Candidates)); //View Inactive Candidates
                    listnames.add(new selectOption('00BU0000002HiLU', Label.All_Past_Employee)); //View Past Employees
                    listnames.add(new selectOption('00BU0000003BOqu', Label.View_Active_4_Star_Candidates)); //View 4 Star Active Candidates
                    listnames.add(new selectOption('00BU0000003BOqt', Label.View_Active_3_Star_Candidates)); //View 3 Star Active Candidates
                    listnames.add(new selectOption('00BU0000003BOqs', Label.View_Active_2_Star_Candidates)); //View 2 Star Active Candidates
                    listnames.add(new selectOption('00BU0000003BOqr', Label.View_Active_1_Star_Candidates)); //View 1 Star Active Candidates
                    selectedlist = '00BU0000003Dyci'; // default to Active EF
                }*/
        
        
                /* if HirePortal Regional Kal-Tire HR
                else if (p.name == 'Kal Tire HirePortal Regional Mgr EN') {
                    listnames.add(new selectOption('00BU0000002HkUD', Label.All_Active_Candidates)); //View Active Candidates
                    listnames.add(new selectOption('00BU0000002HkUN', Label.All_Inactive_Candidates)); //View Inactive Candidates
                    selectedlist = '00BU0000002HkUD';
                }
                
                // if HirePortal Regional Earls
                else if (p.name == 'Earls HirePortal Regional Mgr EN' || p.name == 'Earls HirePortal Store User EN') {
                    listnames.add(new selectOption('00BU0000002HkUD', Label.All_Active_Candidates)); //View Active Candidates
                    listnames.add(new selectOption('00BU0000002HkUI', Label.All_Current_Employee)); //View Current Employees
                    listnames.add(new selectOption('00BU0000002HkUN', Label.All_Inactive_Candidates)); //View Inactive Candidates
                    listnames.add(new selectOption('00BU0000002HkUS', Label.All_Past_Employee)); //View Past Employees
                    selectedlist = '00BU0000002HkUD';}
                    
                // if HirePortal Regional Earls
                else if (p.name == 'HY Louie HirePortal Regional Mgr EN' || p.name == 'HY Louie HirePortal Store User EN' || p.name == 'HY Louie HirePortal HR User EN') {
                    listnames.add(new selectOption('00BU0000002HkUD', Label.All_Active_Candidates)); //View Active Candidates
                    listnames.add(new selectOption('00BU0000002HkUI', Label.All_Current_Employee)); //View Current Employees
                    listnames.add(new selectOption('00BU0000002HkUN', Label.All_Inactive_Candidates)); //View Inactive Candidates
                    listnames.add(new selectOption('00BU0000002HkUS', Label.All_Past_Employee)); //View Past Employees
                    selectedlist = '00BU0000002HkUD';
                }*/
        
        
                /* if any TalentConnect, add Active/Inactive options and View Starred Candidates
                else if (p.name == 'North West Company Hireportal HR User EN')  {
                    listnames.add(new selectOption('00BU0000004PevW', Label.All_Active_Candidates)); //View Active Candidates
                    listnames.add(new selectOption('00BU0000002HiLP', Label.All_Current_Employee)); //View Current Employees
                    listnames.add(new selectOption('00BU0000002HiLK', Label.All_Inactive_Candidates)); //View Inactive Candidates
                    listnames.add(new selectOption('00BU0000002HiLU', Label.All_Past_Employee)); //View Past Employees
                    listnames.add(new selectOption('00BU0000003BOqu', Label.View_Active_4_Star_Candidates)); //View 4 Star Active Candidates
                    listnames.add(new selectOption('00BU0000003BOqt', Label.View_Active_3_Star_Candidates)); //View 3 Star Active Candidates
                    listnames.add(new selectOption('00BU0000003BOqs', Label.View_Active_2_Star_Candidates)); //View 2 Star Active Candidates
                    listnames.add(new selectOption('00BU0000003BOqr', Label.View_Active_1_Star_Candidates)); //View 1 Star Active Candidates
                    listnames.add(new selectOption('00BU0000004AmBC', Label.View_Active_No_Star_Candidates)); //View No Star Active Candidates
                    listnames.add(new selectOption('00BU00000044dkN', Label.View_NWC_Custom_Active_Candidates)); //View Custom NWC Active Candidates
                    selectedlist = '00BU0000004AmBC'; // default to Active
                }
                */
        
        
                /*
                else if (p.name == 'OFG HirePortal Store User EN - LPO Specific' || p.name == 'OFG HirePortal HR User EN - LPO Specific') {
                    listnames.add(new selectOption('00BU0000002HiIz', Label.SentCand_OFG_LPO)); //1 - View Candidates for Open Jobs LPO
                    listnames.add(new selectOption('00BU0000002HiJx', Label.HiredCand_OFG_LPO)); //2 - View Candidates Recently Hired LPO
                    listnames.add(new selectOption('00BU0000002HiK3', Label.RejectedCand_OFG_LPO)); //3 - View Candidate Recently Rejected LPO
                    selectedlist = '00BU0000002HiIz'; // default to all open jobs
                }
        
                // else show all the OWF options for HR, LPO or Store users
                else if (p.name == 'OFG HirePortal HR User EN') {
                    listnames.add(new selectOption('00BU0000002HiJT', Label.SentCand_OFG_HRView_Cooper)); //1 - View Candidates for Review Coopers
                    listnames.add(new selectOption('00BU0000002HiJO', Label.SentCand_OFG_HRView_All_Region)); //1 - View Candidates for Review Entire Co
                    listnames.add(new selectOption('00BU0000002HiJn', Label.SentCand_OFG_HRView_Overwaitea)); //1 - View Candidates for Review OF
                    listnames.add(new selectOption('00BU0000002HiJY', Label.SentCand_OFG_HRView_PSF)); //1 - View Candidates for Review PSF
                    listnames.add(new selectOption('00BU0000002HiJd', Label.SentCand_OFG_HRView_SOFAB)); //1 - View Candidates for Review SOF AB
                    listnames.add(new selectOption('00BU0000002HiJi', Label.SentCand_OFG_HRView_SOFBC)); //1 - View Candidates for Review SOF BC
                    listnames.add(new selectOption('00BU0000002HiJs', Label.SentCand_OFG_HRView_UF)); //1 - View Candidates for Review UF
                    selectedlist = '00BU0000002HiJO'; // default to all Regions
                }
                
        
                else  { //if (p.name == 'OFG HirePortal Store User EN')  This was for Store Users but instead we do a catch all in case OFG profile names change or don't match for some reason
                    listnames.add(new selectOption('00BU0000002HiJE', Label.SentCand_OFG_Store)); //1 - View Candidates for Open Jobs OFG
                    listnames.add(new selectOption('00BU0000002HiK2', Label.HiredCand_OFG_Store)); //2 - View Candidates Recently Hired OFG
                    listnames.add(new selectOption('00BU0000002HiK7', Label.RejectedCand_OFG_Store)); //3 - View Candidate Recently Rejected OFG
                    selectedlist = '00BU0000002HiJE'; // default to open jobs
                }
                */
         /*END  Deprecated Accounts **************************************************************************************************************/ 
        
        // check if we have a list Id in URL
        if (ApexPages.currentPage().getParameters().get('listId') != null)
                selectedlist = ApexPages.currentPage().getParameters().get('listId');
        //system.debug('listid is now:  '+selectedlist);
    }

    // page action method - if portal user, store the initial list they are on in the custom setting
    //  if they are not portal, redirect to standard candidates tab without override 
    public pagereference pageredirect() {
        string uType = Userinfo.getusertype();
        if ( uType == 'CustomerSuccess' ||  uType == 'PowerCustomerSuccess' ||  uType == 'CSPLitePortal') {
        
            //OFG Sourcing Solution
            //redirect to new candidate sourcing page
            if (NewServiceModel_Util.IsSOFSourcingUser(Userinfo.getUserId())) {
                PageReference pageRef = page.CandidateListView_Sourcing;
                return pageRef;
            } 
        
            storeListId();
            return null;
        }
        else
            return new pagereference('/a0Q/o?sfdc.override=1&nooverride=1');

    }
    
    // when list view is selected, this function will store the selected list in the custom setting
    //   for the user - accessed from the custom Candidate field 'Candidate View' to put in retURL parameter
    public void storeListId() {
        // store selected List in custom setting for this user
        CandidateListView__c myListView = CandidateListView__c.getInstance(Userinfo.getuserid());
        if (myListView == null)
            myListView = new CandidateListView__c();
        if (myListView.candidate_listid__c != selectedList) {
            myListView.candidate_listid__c = selectedList;
            upsert myListView;  
        }
 
    }
        
    //  action method on the List views dropdown field; when selected, we store the list Id in a custom setting and then
    //     refresh the page with the new list view showing
    public pagereference selectList() {
        try {
            storeListId();
            pagereference samePg = page.CandidateListViews;
            samePg.getParameters().put('listid', selectedlist );
            samePg.setRedirect(true);
            return samePg;
        } catch (Exception e) {
             apexpages.addmessages(e);
             return null;
         }   
    }

}