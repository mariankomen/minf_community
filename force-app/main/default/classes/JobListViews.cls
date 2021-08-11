/*************
Class: Job List Views
Description: extension builds picklist of available list views, using lables for french and ease of change and OFG users seeing more
    details list views than non-OFG users.

Created: Jan 17/13, Vankerk Solutions
Modification Log:
    Jan 30/13, added views for AN and easyhome
    Mar 1/15: commented out Multi Service User filter until needed, also commented out the User query since it is not necessary without Multi User
    July 27/15: added support for tracking last selected list view in custom setting
    
*************/
public class JobListViews {

    public List<selectOption> listnames {get; set;}
    public string selectedlist {get; set;}
    public Profile p {get; set;}
    
    public JobListViews(ApexPages.StandardSetController controller) {
        listnames = new List<selectOption>();
        p = [select id, name from Profile where id = :Userinfo.getprofileid()];
        
        // if Got Junk STORE or REG User, show certain list views
        if (p.name == 'Mr. Lube Franchise HirePortal Regional Mgr EN' || p.name == 'Mr. Lube Franchise HirePortal Store User EN') {
            listnames.add(new selectOption('00BU0000003EIUl', Label.View_All_Active_Franchise_Jobs)); 
            listnames.add(new selectOption('00BU0000003EIUk', Label.View_All_Inactive_Franchise_Jobs)); 
            selectedlist = '00BU0000003EIUl'; // default to Active
        }
        
        
        if (p.name == 'Mr. Lube Husaro HirePortal Regional Manager EN') {
            listnames.add(new selectOption('00B0P000005Ldyd', Label.All_Active)); 
            listnames.add(new selectOption('00B0P000005LdyY', Label.All_Inactive)); 
            selectedlist = '00B0P000005Ldyd'; // default to Active
        }
        
        // if Akzo HR user, show certain list views
        else if (p.name == 'AkzoNobel HirePortal HR User EN' || p.name == 'AkzoNobel HirePortal HR User FR') {
            listnames.add(new selectOption('00BU0000002IiBw', Label.All_Active_DuluxBetonel)); // All Active Dulux/Betonel Jobs
            listnames.add(new selectOption('00BU0000002IiCa', Label.All_Active_PPGPAR)); // All Active PPG Architectural Jobs
            listnames.add(new selectOption('00BU0000002IiCB', Label.All_Inactive_DuluxBetonel)); // All inactive Jobs Dulux/Betonel Jobs
            listnames.add(new selectOption('00BU0000002IiCp', Label.All_Inactive_PPGPAR)); // All inactive Jobs PPG Architectural Jobs
            listnames.add(new selectOption('00BU0000002HkgE', Label.All_InApproval)); // All In Approval Jobs 
            selectedlist = '00BU0000002IiBw'; // default to all Active
        } 
        // if Akzo RM user, show certain list views
        else if (p.name == 'AkzoNobel HirePortal Regional Mgr EN' || p.name == 'AkzoNobel HirePortal Regional Mgr FR') {
            listnames.add(new selectOption('00BU0000002HkTy', Label.All_Active)); // All Active Jobs
            listnames.add(new selectOption('00BU0000002HkU3', Label.All_Inactive)); // All Inactive Jobs            
            listnames.add(new selectOption('00BU0000002HiCm', Label.All_InApproval)); // All In Approval Jobs            
            selectedlist = '00BU0000002HkTy'; // default to all Active
        } 
        // if Akzo Store user, show certain list views
        else if (p.name == 'AkzoNobel HirePortal Store User EN' || p.name == 'AkzoNobel HirePortal Store User FR' || p.name == 'AkzoNobel HirePortal Store User EN - Int Sch') {
            listnames.add(new selectOption('00BU0000002HkTy', Label.All_Active)); // All Active Jobs
            listnames.add(new selectOption('00BU0000002HkU3', Label.All_Inactive)); // All Inactive Jobs            
            listnames.add(new selectOption('00BU0000002HiCm', Label.All_InApproval)); // All In Approval Jobs            
            selectedlist = '00BU0000002HkTy'; // default to all Active
        }
        
        //PPG USA Store and Regional
        else if (p.name == 'PPG USA Hireportal Region MGR EN' || p.name == 'PPG USA Hireportal Store User EN') {
            listnames.add(new selectOption('00BU0000004Pfrl', Label.All_Active)); // All Active Jobs
            listnames.add(new selectOption('00BU0000004Pfrm', Label.All_Inactive)); // All Inactive Jobs             
            listnames.add(new selectOption('00BU0000004Pkiy', Label.All_InApproval)); // All In Approval Jobs                    
            selectedlist = '00BU0000004Pfrl'; // default to all Active
        }
        //PPG USA HR
        else if (p.name == 'PPG USA Hireportal HR UserEN') {
            listnames.add(new selectOption('00BU0000004Pm3F', Label.All_Active)); // All Active Jobs
            listnames.add(new selectOption('00BU0000004Pfrm', Label.All_Inactive)); // All Inactive Jobs             
            listnames.add(new selectOption('00BU0000004AgDY', Label.All_InApproval)); // All In Approval Jobs                    
            selectedlist = '00BU0000004Pm3F'; // default to all Active
        }
        
        // if MFG Internal users, show certain list views
        else if (p.name == 'MindField Internal HirePortal Store User EN' || p.name == 'MindField Internal HirePortal Regional Mgr User EN' || p.name == 'MindField Internal HirePortal HR User EN') {
            listnames.add(new selectOption('00BU0000002HkTy', Label.All_Active)); // All Active Jobs
            listnames.add(new selectOption('00BU0000002HkU3', Label.All_Inactive)); // All Inactive Jobs            
            listnames.add(new selectOption('00BU0000002HiCm', Label.All_InApproval)); // All In Approval Jobs            
            selectedlist = '00BU0000002HkTy'; // default to all Active
        }
        
        // Tim Hortons NSM- Oct, 2017
        else if (p.name == 'Tim Hortons hireportal HR User (NSM) EN' || p.name == 'Tim Hortons hireportal RGL (NSM) EN' || p.name == 'Tim Hortons hireportal Store User (NSM) EN') {
            listnames.add(new selectOption('00B0P000004ulpV', Label.All_Active)); // All Active Jobs
            //listnames.add(new selectOption('00B3D000001Htyc', Label.All_Active)); // All Active Jobs
            listnames.add(new selectOption('00B0P000004ulpW', Label.All_Inactive)); // All Inactive Jobs                 
            //selectedlist = '00B0P000004ulpV'; // default to all Active
            selectedlist = '00B0P000004ulpV'; // default to all Active
        }
        
        // Wendys NSM- Nov, 2017
        else if (p.name == 'Wendys hireportal HR User (NSM) EN' || p.name == 'Wendys hireportal RGL (NSM) EN' || p.name == 'Wendys hireportal Store User (NSM) EN') {
            listnames.add(new selectOption('00B0P000004uokE', Label.All_Active)); // All Active Jobs
            listnames.add(new selectOption('00B0P000004uokF', Label.All_Inactive)); // All Inactive Jobs                 
            selectedlist = '00B0P000004uokE'; // default to all Active
        }
        
        // Sporting Life July, 2019
        else if (p.name == 'Sporting Life HR User (NSM) EN' || p.name == 'Sporting Life Store User (NSM) EN' ) {
            listnames.add(new selectOption('00B0P000004wEz1', 'View all Active Jobs for Sporting Life')); // All Active Jobs
            listnames.add(new selectOption('00B0P000004wEz6', 'View all Inactive Jobs for Sporting Life')); // All Inactive Jobs                 
            selectedlist = '00B0P000004wEz1'; // default to all Active
        }
        
       // Sporting Life FR July, 2019
        else if (p.name == 'Sporting Life HR User (NSM) FR' || p.name == 'Sporting Life Store User (NSM) FR' ) {
            listnames.add(new selectOption('00B0P000004wF9B', 'Emplois actifs pour Sporting life')); // Tout travail actif
            listnames.add(new selectOption('00B0P000004wF96', 'Emplois inactifs pour Sporting Life')); // Tout travail inactif                 
            selectedlist = '00B0P000004wF9B'; // default to all Active
        }
        
         // Ecoservice Group- Dec, 2018
        else if (p.name == 'Eco Group hireportal HR User (NSM) EN' || p.name == 'Eco Group hireportal RGL (NSM) EN' || p.name == 'Eco Group hireportal Store User (NSM) EN') {
            listnames.add(new selectOption('00B0P000004i7JO', 'View all Active Jobs for Ecoservice Group')); // All Active Jobs
            listnames.add(new selectOption('00B0P000004i7JP', 'View all Inactive Jobs for Ecoservice Group')); // All Inactive Jobs                 
            selectedlist = '00B0P000004i7JO'; // default to all Active
        }
        
        
        // Golf Town - March, 2019
        else if (p.name == 'Golf Town hireportal HR User (NSM) EN' || p.name == 'Golf Town hireportal Store User (NSM) EN') {
            listnames.add(new selectOption('00B0P000004yFhF', Label.All_Active)); // All Active Jobs
            listnames.add(new selectOption('00B0P000004yFhH', Label.All_Inactive)); // All Inactive Jobs                 
            selectedlist = '00B0P000004yFhF'; // default to all Active
        }
        else if (p.name ==  'Golf Town hireportal HR User (NSM) FR' || p.name == 'Golf Town hireportal Store User (NSM) FR') {
            listnames.add(new selectOption('00B0P000004yFhG', Label.All_Active)); // All Active Jobs
            listnames.add(new selectOption('00B0P000004yFhI', Label.All_Inactive)); // All Inactive Jobs                 
            selectedlist = '00B0P000004yFhG'; // default to all Active
        }
        
        
        else if (p.name == 'Canadian Tire hireportal Store User EN'|| p.name == 'Canadian Tire hireportal RGL EN' || p.name =='Canadian Tire hireportal HR User EN' ||
                 p.name == 'Canadian Tire hireportal HR User EN - NSM'|| p.name == 'Canadian Tire hireportal RGL EN - NSM' || p.name =='Canadian Tire hireportal Store User EN - NSM') { 
            listnames.add(new selectOption('00B0P000004urIa', Label.All_Active)); // All Active Jobs
            listnames.add(new selectOption('00B0P000004urIk', Label.All_Inactive)); // All inactive Jobs
            selectedlist = '00B0P000004urIa'; // default to all Active
        }
        
        else if (p.name == 'MFG TalentDrive HirePortal Regional User EN') {
             listnames.add(new selectOption('00B0P000004eBdr', Label.All_Active)); // All Active Jobs   
         //  listnames.add(new selectOption('00BU0000002HkTy', Label.All_Active)); // All Active Jobs Original   
             listnames.add(new selectOption('00B0P000004eD6g', Label.All_Inactive)); // All inactive Jobs
         //  listnames.add(new selectOption('00BU0000002HkU3', Label.All_Inactive)); // All inactive Jobs Original
           selectedlist = '00B0P000004eBdr'; // default to all Active  
        //selectedlist = '00B1g000000VYNd'; // default to all Active  
        }
        
        else if (p.name == 'MFG TalentReach HirePortal Regional Manager EN') {
             listnames.add(new selectOption('00B0P000005Lhwb', Label.All_Active)); // All Active Jobs   
         //  listnames.add(new selectOption('00BU0000002HkTy', Label.All_Active)); // All Active Jobs Original   
             listnames.add(new selectOption('00B0P000005Lhwg', Label.All_Inactive)); // All inactive Jobs
         //  listnames.add(new selectOption('00BU0000002HkU3', Label.All_Inactive)); // All inactive Jobs Original
           selectedlist = '00B0P000005Lhwb'; // default to all Active  
        //selectedlist = '00B0P000005Lhwg'; // default to all Active  
        }
        
        else if (p.name == 'MFG TalentDrive HirePortal Store User EN') {
        //New logic block to target MFG ondemand store users to not show pipeline jobs in their list view. This profile used to get targeted in the logic block #325 in the exclusion list
             listnames.add(new selectOption('00B0P000004eD6M', Label.All_Active)); // All Active Jobs   
             listnames.add(new selectOption('00B0P000004eD6N', Label.All_Inactive)); // All inactive Jobs
        selectedlist = '00B0P000004eD6M'; // default to all Active  
                  }
                                  
        else if (p.name == 'MFG TalentReach HirePortal Store User EN') {
        //New logic block to target MFG ondemand store users to not show pipeline jobs in their list view. This profile used to get targeted in the logic block #325 in the exclusion list
             listnames.add(new selectOption('00B0P000005LhwM', Label.All_Active)); // All Active Jobs   
             listnames.add(new selectOption('00B0P000005LhwR', Label.All_Inactive)); // All inactive Jobs
        selectedlist = '00B0P000005LhwM'; // default to all Active  
                  }
                  
        
         else if (p.name == 'FGL Sports HirePortal HR User EN' || p.name == 'FGL Sports HirePortal HR User EN Dashboard Trial') {
            listnames.add(new selectOption('00BU0000002IIUs', Label.View_all_Active_Jobs_FGL)); // All Active Jobs
            listnames.add(new selectOption('00BU0000002IIUn', Label.All_Active_Marks)); // All Active Jobs
            listnames.add(new selectOption('00BU0000002HkU3', Label.All_Inactive)); // All inactive Jobs
        selectedlist = '00BU0000002IIUs'; // default to all Active  
        }
        
        else if (p.name == 'FGL Sports HirePortal Regional Manager EN' || p.name == 'Marks HirePortal Regional Mgr EN') {
            listnames.add(new selectOption('00BU0000002HkTy', Label.All_Active)); // All Active Jobs
            listnames.add(new selectOption('00BU0000002HkU3', Label.All_Inactive)); // All Inactive Jobs                        
            selectedlist = '00BU0000002HkTy'; // default to all Active
        }
        
        else if (p.name == 'Marks HirePortal Store User FR') {
            listnames.add(new selectOption('00B0P000004wHNp', Label.All_Active)); // Voir tous les emplois actifs
            listnames.add(new selectOption('00B0P000004wHNu', Label.All_Inactive)); // Afficher tous les emplois inactifs
        selectedlist = '00B0P000004wHNp'; // Voir tous les emplois actifs 
        } 
        
         else if ( p.name == 'Marks HirePortal Regional Mgr FR') {
            listnames.add(new selectOption('00B0P000004wLns', Label.All_Active)); // Voir tous les emplois actifs
            listnames.add(new selectOption('00B0P000004wLnx', Label.All_Inactive)); // Afficher tous les emplois inactifs
        selectedlist = '00B0P000004wLns'; // Voir tous les emplois actifs 
        } 
       
        
        // if any other non-OWF user, add Active/Inactive options
        else if ((!p.name.startswith('OFG')) && (!p.name.startswith('easyhome')) && (!p.name.startswith('MFG TalentDrive HirePortal Regional'))  && (!p.name.startswith('MFG TalentReach HirePortal Regional Manager EN')) && (!p.name.startswith('Akzo')) && (!p.name.startswith('FGL Sports HirePortal HR')) && (!p.name.startswith('Kal Tire HirePortal Regional Mgr EN')) && (!p.name.startswith('easyfinancial'))) {
            listnames.add(new selectOption('00BU0000002HiIL', Label.All_Active)); // All Active Jobs
            listnames.add(new selectOption('00BU0000002HiIQ', Label.All_Inactive)); // All inactive Jobs
            selectedlist = '00BU0000002HiIL'; // default to all Active
        }

        
        // finally, if we came to this list view page with a listid parameter already set, use that as the selectedList
        if (apexpages.currentPage().getparameters().get('listid') != null)
            selectedList = apexpages.currentPage().getparameters().get('listid');

        /* Deprecated Accounts **************************************************************************************************************/
                 /* Country Grocer - April 10, 2017
               else if (p.name == 'Country Grocer Hireportal HR User EN' || p.name == 'Country Grocer Hireportal Reg MGR EN' || p.name == 'Country Grocer Hireportal Store User EN') {
                  listnames.add(new selectOption('00B0P000004i58T', Label.All_Active)); // All Active Jobs
                 listnames.add(new selectOption('00B0P0000046C6h', Label.All_Inactive)); // All Inactive Jobs                 
                selectedlist = '00B0P000004i58T'; // default to all Active
               }
               */
        
                /*  when we are ready to implement Multi Service User, add back the User query, the first if and add an 'else' before the next if for 1800GotJunk
                User currUser = [select id, Multi_Service_User__c from User where id = :userinfo.getUserId()];
        
                 // if Multi-Service is Enabled, show certain list views
                if (currUser.Multi_Service_User__c == 'Yes') {
                    listnames.add(new selectOption('00BU0000003EIUl', Label.View_All_Active_Franchise_Jobs)); 
                    listnames.add(new selectOption('00BU0000003EIUk', Label.View_All_Inactive_Franchise_Jobs)); 
                    selectedlist = '00BU0000003EIUl'; // default to Active
                }
                
                else ...
                */
                        
                 /* if Got Junk STORE or REG User, show certain list views
                if (p.name == '1800GotJunk HirePortal STORE User' || p.name == '1800GotJunk HirePortal REG User' || p.name == '1800GotJunk HirePortal STORE User Preview' || p.name == '1800GotJunk HirePortal REG User Preview') {
                    listnames.add(new selectOption('00BU0000003EIUl', Label.View_All_Active_Franchise_Jobs)); 
                    listnames.add(new selectOption('00BU0000003EIUk', Label.View_All_Inactive_Franchise_Jobs)); 
                    selectedlist = '00BU0000003EIUl'; // default to Active
                }
                
                 // if Got Junk HR user, show certain list views
                else if (p.name == '1800GotJunk HirePortal HR User EN' || p.name == '1800GotJunk HirePortal HR User EN Preview')  {
                    listnames.add(new selectOption('00BU0000003EKE7', Label.View_All_Active_Franchise_Jobs)); 
                    listnames.add(new selectOption('00BU0000003EKE2', Label.View_All_Inactive_Franchise_Jobs)); 
                    listnames.add(new selectOption('00BU0000003EKDs', Label.View_All_Active_Franchise_Jobs_HO)); 
                    listnames.add(new selectOption('00BU0000003EKDx', Label.View_All_Inactive_Franchise_Jobs_HO)); 
                    selectedlist = '00BU0000003EKE7'; // default to Active
                }*/
                
                /*Dealer Intelligence Non HR
                 else if (p.name == 'Dealer Intelligence Regional User EN' || p.name == 'Dealer Intelligence Store User EN' ) {
                    listnames.add(new selectOption('00BU0000004AfqF', Label.All_Active)); // All Active Jobs
                    listnames.add(new selectOption('00BU0000004Afqo', Label.All_Inactive)); // All Inactive Jobs                 
                    selectedlist = '00BU0000004AfqF'; // default to all Active
                 
                 }
                 
                //Dealer Intelligence HR
                 else if (p.name == 'Dealer Intelligence HR User EN') {
                    listnames.add(new selectOption('00BU0000004AfqA', Label.All_Active)); // All Active Jobs
                    listnames.add(new selectOption('00BU0000004Afqo', Label.All_Inactive)); // All Inactive Jobs                 
                    selectedlist = '00BU0000004AfqA'; // default to all Active
                 }*/
        
               /* Kitchen Stuff Plus
                else if (p.name == 'Kitchen Stuff Plus Hireportal Store User EN' || p.name == 'Kitchen Stuff Plus Hireportal Reg MGR EN' || p.name == 'Kitchen Stuff Plus Hireportal HR User EN') {
                    listnames.add(new selectOption('00BU0000004Pg95', Label.All_Active)); // All Active Jobs
                    listnames.add(new selectOption('00BU0000004Pg96', Label.All_Inactive)); // All Inactive Jobs                 
                    selectedlist = '00BU0000004Pg95'; // default to all Active
                }
                
                // Turnabout - Sept 20, 2016
                else if (p.name == 'Turnabout Hireportal HR User EN' || p.name == 'Turnabout Hireportal Reg MGR EN' || p.name == 'Turnabout Hireportal Store User EN') {
                    listnames.add(new selectOption('00B0P0000045gzt', Label.All_Active)); // All Active Jobs
                    listnames.add(new selectOption('00B0P0000045gzu', Label.All_Inactive)); // All Inactive Jobs                 
                    selectedlist = '00B0P0000045gzt'; // default to all Active
                }*/
        
               /* Capilano Golf - Jan, 2018
                else if (p.name == 'Capilano Golf and Country Club hireportal HR User (NSM) EN' || p.name == 'Capilano Golf and Country Club hireportal RGL (NSM) EN' || p.name == 'Capilano Golf and Country Club hireportal Store User (NSM) EN') {
                    listnames.add(new selectOption('00B0P000004uzaF', Label.All_Active)); // All Active Jobs
                    listnames.add(new selectOption('00B0P000004uzaK', Label.All_Inactive)); // All Inactive Jobs                 
                    selectedlist = '00B0P000004uzaF'; // default to all Active
                }
                
                // Wallace & Carey Inc - Jan, 2018
                else if (p.name == 'W & C Inc hireportal HR User (NSM) EN' || p.name == 'W & C Inc hireportal RGL (NSM) EN' || p.name == 'W & C Inc hireportal Store User (NSM) EN') {
                    listnames.add(new selectOption('00B0P000004v0xt', Label.All_Active)); // All Active Jobs
                    listnames.add(new selectOption('00B0P000004v0y3', Label.All_Inactive)); // All Inactive Jobs                 
                    selectedlist = '00B0P000004v0xt'; // default to all Active
                }*/
        
               /* DirectTap - May, 2017
                else if (p.name == 'DirectTap Hireportal HR User EN' || p.name == 'DirectTap Hireportal Reg MGR EN' || p.name == 'DirectTap Hireportal Store User EN') {
                    listnames.add(new selectOption('00B0P000004ogMv', Label.All_Active)); // All Active Jobs
                    listnames.add(new selectOption('00B0P000004ogMw', Label.All_Inactive)); // All Inactive Jobs                 
                    selectedlist = '00B0P000004ogMv'; // default to all Active
                }
                
                
                
                // if easyhome/easyfinancial master user, show different views
                else if (p.name == 'easyfinancial and easyhome Head HirePortal HR (EH Focus) User EN') {
                    listnames.add(new selectOption('00BU0000002Hkfk', Label.All_EHActive)); // All Active easyhome Jobs
                    listnames.add(new selectOption('00BU0000002Hkfu', Label.All_EHInActive)); // All Active easyhome Jobs
                    listnames.add(new selectOption('00BU0000002Hkfp', Label.All_EFActive)); // All Active easyfinancial Jobs
                    listnames.add(new selectOption('00BU0000002Hkfz', Label.All_EFInActive)); // All InActive easyfinancial Jobs
                    listnames.add(new selectOption('00BU0000002HrQ0', Label.All_EHSupportActive)); // All Active easyhome support center Jobs
                    listnames.add(new selectOption('00BU0000002HrQA', Label.All_EHSupportInActive)); // All InActive easyhome support centerJobs            
                    selectedlist = '00BU0000002Hkfk'; // default to all EH Active
                }
                
                // if easyhome/easyfinancial master user, show different views
                else if (p.name == 'easyfinancial and easyhome Head HirePortal HR (EF Focus) User EN') {
                    listnames.add(new selectOption('00BU0000002Hkfk', Label.All_EHActive)); // All Active easyhome Jobs
                    listnames.add(new selectOption('00BU0000002Hkfu', Label.All_EHInActive)); // All Active easyhome Jobs
                    listnames.add(new selectOption('00BU0000002Hkfp', Label.All_EFActive)); // All Active easyfinancial Jobs
                    listnames.add(new selectOption('00BU0000002Hkfz', Label.All_EFInActive)); // All InActive easyfinancial Jobs
                    listnames.add(new selectOption('00BU0000002HrQ0', Label.All_EHSupportActive)); // All Active easyhome support center Jobs
                    listnames.add(new selectOption('00BU0000002HrQA', Label.All_EHSupportInActive)); // All InActive easyhome support centerJobs            
                    selectedlist = '00BU0000002Hkfp'; // default to all EF Active
                }
                
                // if easyhome user, show different views
                else if (p.name == 'easyhome HirePortal HR User EN') {
                    listnames.add(new selectOption('00BU0000002Hkfk', Label.All_EHActive)); // All Active easyhome Jobs
                    listnames.add(new selectOption('00BU0000002Hkfu', Label.All_EHInActive)); // All InActive easyhome Jobs
                    selectedlist = '00BU0000002Hkfk'; // default to all Active
                }      
                // if easyfinancial, show different views
                else if (p.name == 'easyfinancial HirePortal HR User EN' || p.name == 'easyfinancial HirePortal Regional Mgr EN' || p.name == 'easyfinancial HirePortal Store User EN') {
                    listnames.add(new selectOption('00BU0000002Hkfp', Label.All_EFActive)); // All Active easyfinancial Jobs
                    listnames.add(new selectOption('00BU0000002Hkfz', Label.All_EFInActive)); // All InActive easyfinancial Jobs
                    selectedlist = '00BU0000002Hkfp'; // default to all Active
                }
                
                else if (p.name == 'easyhome HirePortal Store User EN') {
                    listnames.add(new selectOption('00BU0000002HkTy', Label.All_Active)); // All Active Jobs
                    listnames.add(new selectOption('00BU0000002HkU3', Label.All_Inactive)); // All inactive Jobs
                selectedlist = '00BU0000002HkTy'; // default to all Active  
                }*/
               /*
                else if (p.name == 'North West Company Hireportal HR User EN'|| p.name == 'North West Company Hireportal Store User EN' || p.name =='North West Company Hireportal Region MGR EN'  ) {
                    listnames.add(new selectOption('00BU0000002HiIL', Label.All_Active)); // All Active Jobs
                    listnames.add(new selectOption('00BU0000002HiIQ', Label.All_Inactive)); // All inactive Jobs
                    selectedlist = '00BU0000002HiIL'; // default to all Active
                }
        
                else if (p.name == 'OFG HirePortal Store User EN - LPO Specific' || p.name == 'OFG HirePortal HR User EN - LPO Specific') {
                    listnames.add(new selectOption('00BU0000002HiDL', Label.Open_OFG_LPO_All_regions)); //1-View All OPEN Jobs for all LPO Regions
                    listnames.add(new selectOption('00BU0000002HiFW', Label.Open_OFG_LPO_My_regions)); //1-View All OPEN Jobs for OUR LPO Region
                    listnames.add(new selectOption('00BU0000002HiGU', Label.Sent_OFG_LPO_All_Region)); //2-View Jobs w/ Cands for all LPO Regions
                    listnames.add(new selectOption('00BU0000002HiGZ', Label.All_OFG_LPO_All_Region)); //3-View All Jobs for all LPO Regions
                    selectedlist = '00BU0000002HiFW'; // default to all open for My regions
                }
                
                //SOF Sourcing Solution
                //View for HR users when on new sourcing solution
                else if (p.name == 'OFG HirePortal HR User EN' && NewServiceModel_Util.IsSOFSourcingUser(Userinfo.getUserId())) {
                
                    //OFG
                    listnames.add(new selectOption('00B0P000004uwvy', 'View All Jobs - Overwaitea'));
                    //PriceSmart Foods
                    listnames.add(new selectOption('00B0P000004uwvz', 'View All Jobs - PriceSmart'));
                    //Urban Fare
                    listnames.add(new selectOption('00B0P000004uww5', 'View All Jobs - Urban Fare'));
                    //Save On Foods – AB
                    listnames.add(new selectOption('00B0P000004uww0', 'View All Jobs - SOF AB')); 
                    //Save On Foods - BC
                    listnames.add(new selectOption('00B0P000004uww1', 'View All Jobs - SOF BC'));
                    //Save On Foods - SK
                    listnames.add(new selectOption('00B0P000004uww3', 'View All Jobs - SOF SK'));
                    //Save On Foods - MB
                    listnames.add(new selectOption('00B0P000004uww2', 'View All Jobs - SOF MB'));
                    //Save On Foods - YK
                    listnames.add(new selectOption('00B0P000004uww4', 'View All Jobs - SOF YK'));
                    
                    //New views June 2018
                    //View All Jobs – E-Commerce
                    listnames.add(new selectOption('00B0P000004eOeb', 'View All Jobs – E-Commerce'));
                    //View All Jobs – Resource Protection
                    listnames.add(new selectOption('00B0P000004eOed', 'View All Jobs – Resource Protection'));
                    //View All Jobs – Wine
                    listnames.add(new selectOption('00B0P000004eOee', 'View All Jobs – Wine'));
                    //View All Jobs – Not Applicable
                    listnames.add(new selectOption('00B0P000004eOec', 'View All Jobs – Not Applicable'));
                
                    selectedlist = '00B0P000004uwvy'; //BC
                }
                
                // else show all the OWF options for HR, LPO or Store users
                else if (p.name == 'OFG HirePortal HR User EN') {
                    listnames.add(new selectOption('00BU0000002HiFH', Label.Open_OFG_HRView_Coopers)); //1-View All OPEN Jobs for All Coopers
                    listnames.add(new selectOption('00BU0000002HiFC', Label.Open_OFG_HRView_Overwaitea)); //1-View All OPEN Jobs for All Overwaitea
                    listnames.add(new selectOption('00BU0000002HiF8', Label.Open_OFG_HRVIEW_PriceSmart)); //1-View All OPEN Jobs for All PriceSmart
                    listnames.add(new selectOption('00BU0000002HiEs', Label.Open_OFG_HRView_SOFAB)); //1-View All OPEN Jobs for All SOF AB
                    listnames.add(new selectOption('00BU0000002HiF2', Label.Open_OFG_HRView_SOFBC)); //1-View All OPEN Jobs for All SOF BC
                    listnames.add(new selectOption('00BU0000002HiFR', Label.Open_OFG_HRView_UrbanFare)); //1-View All OPEN Jobs for All Urban Fare
                    listnames.add(new selectOption('00BU0000002HiFM', Label.Open_OFG_HRView_All_BC_Region)); //1-View All OPEN Jobs for Entire BC
                    listnames.add(new selectOption('00BU0000002HiFv', Label.Open_OFG_HRView_All_Regions)); //1-View All OPEN Jobs for Entire Company
                    listnames.add(new selectOption('00BU0000002HiFg', Label.Sent_OFG_HRView_Coopers)); //2-View Jobs w/ Candidates All Coopers
                    listnames.add(new selectOption('00BU0000002HiFq', Label.Sent_OFG_HRView_Overwaitae)); //2-View Jobs w/ Candidates All Overwaitea
                    listnames.add(new selectOption('00BU0000002HiGF', Label.Sent_OFG_HRView_PriceSmart)); //2-View Jobs w/ Candidates All PriceSmart
                    listnames.add(new selectOption('00BU0000002HiG0', Label.Sent_OFG_HRView_SOFAB)); //2-View Jobs w/ Candidates All SOF AB
                    listnames.add(new selectOption('00BU0000002HiG5', Label.Sent_OFG_HRView_SOFBC)); //2-View Jobs w/ Candidates All SOF BC
                    listnames.add(new selectOption('00BU0000002HiGA', Label.Sent_OFG_HRView_Urban)); //2-View Jobs w/ Candidates All Urban Fare
                    listnames.add(new selectOption('00BU0000002HiGP', Label.Sent_OFG_HRView_BC_Region)); //2-View Jobs w/ Candidates Entire BC
                    listnames.add(new selectOption('00BU0000002HiFh', Label.Sent_OFG_HRView_All_Region)); //2-View Jobs w/ Candidates Entire Company
                    selectedlist = '00BU0000002HiFh'; // default to all Overwaitea
                }
                */
        
                 /*
                 else if (p.name == 'Kal Tire HirePortal Regional Mgr EN') {
                    listnames.add(new selectOption('00BU0000002HkTy', Label.All_Active)); // All Active Jobs
                    listnames.add(new selectOption('00BU0000002HkU3', Label.All_Inactive)); // All inactive Jobs
                selectedlist = '00BU0000002HkTy'; // default to all Active  
                }
        
                else if (p.name == 'Earls HirePortal Regional Mgr EN' || p.name == 'Earls HirePortal Store User EN') {
                    listnames.add(new selectOption('00BU0000002HkTy', Label.All_Active)); // All Active Jobs
                    listnames.add(new selectOption('00BU0000002HkU3', Label.All_Inactive)); // All inactive Jobs
                selectedlist = '00BU0000002HkTy'; // default to all Active  
                }*/
        
                /*SOF Sourcing Solution
                //View for store users when on new sourcing solution
                else if ((p.name == 'OFG HirePortal Store User EN' || p.name == 'OFG HirePortal Regional Mgr EN') && NewServiceModel_Util.IsSOFSourcingUser(Userinfo.getUserId())) {
                    listnames.add(new selectOption('00B0P000004uww6', 'View Broadcasted Jobs')); // All Broadcasted Jobs
                    listnames.add(new selectOption('00B0P000004uww8', 'View Non-Broadcasted Jobs')); // All Non - Broadcasted
                    listnames.add(new selectOption('00B0P000004uww7', 'View Full Cycle Recruitment Jobs')); // All Old FCR jobs
                    selectedlist = '00B0P000004uww6'; // default to all Active  
                }
        
                else { //if (p.name == 'OFG HirePortal Store User EN')  This was for Store Users but instead we do a catch all in case OFG profile names change or don't match for some reason
                    listnames.add(new selectOption('00BU0000002HiFD', Label.Open_OFG_Store_Open_Jobs)); //1-View All OPEN Jobs for OUR OFG Store
                    listnames.add(new selectOption('00BU0000002HiGj', Label.Open_OFG_Store_Filled_Jobs)); //2-View Filled Jobs for OUR OFG Store
                    listnames.add(new selectOption('00BU0000002HiGo', Label.All_OFG_Store_jobs)); //3-View All Jobs for OUR OFG Store
                    selectedlist = '00BU0000002HiFD'; // default to all open
                }*/
        /*END  Deprecated Accounts **************************************************************************************************************/  

    }
    
    // page action method - if portal user, store the initial list they are on in the custom setting
    //  if they are not portal, redirect to standard jobs tab without override 
    public pagereference pageredirect() {
        string uType = Userinfo.getusertype();
        if ( uType == 'CustomerSuccess' ||  uType == 'PowerCustomerSuccess' ||  uType == 'CSPLitePortal') {
            storeListId();
            return null;
        }
        else
            return new pagereference('/a0P/o?sfdc.override=1&nooverride=1');

    }
    
    // when list view is selected, this function will store the selected list in the custom setting
    //   for the user - accessed from the custom Jobs field 'Job View' to put in retURL parameter
    public void storeListId() {
        // store selected List in custom setting for this user
        JobListView__c myListView = JobListView__c.getInstance(Userinfo.getuserid());
        if (myListView == null)
            myListView = new JobListView__c();
        if (myListView.listid__c != selectedList) {
            myListView.listid__c = selectedList;
            upsert myListView;  
        }
 
    }
    
    //  action method on the List views dropdown field; when selected, we store the list Id in a custom setting and then
    //     refresh the page with the new list view showing
    public pagereference selectList() {
        try {
            storeListId();
            pagereference samePg = page.JobListViews;
            samePg.getParameters().put('listid', selectedlist );
            samePg.setRedirect(true);
            return samePg;
         } catch (Exception e) {
             apexpages.addmessages(e);
             return null;
         }   
    }
    
    

}