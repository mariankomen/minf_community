/**  Copyright (c) 2008, Matthew Friend, Sales Engineering, Salesforce.com Inc.
*  All rights reserved.
*
*  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
*  Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer. 
*  Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
*  Neither the name of the salesforce.com nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission. 
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
*  INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
*  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
*  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
*  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
*  EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

/**
* To adapt this to anouther Object simply search for "Change" to go to the places 
* where the sObject and query must be changed
*/

// Downloaded from AppExchange, modified for Franchise Structure by Vankerk Solutions to show only the parent one level up and only children from the current account
//   Changed: formatObjectStructure method to manage which accounts and child accounts to query, also stops at 3rd round and pads index to account for larger number of children

public with sharing class AccountStructure{

    //Declare variables
    public String currentId;
    public List<ObjectStructureMap> asm ;
    public Map<String, ObjectStructureMap> masm;
    public List<Integer> maxLevel;
    
    /**
    * Contructor
    */
    public AccountStructure() {
        this.asm = new List<ObjectStructureMap>{};
        this.masm = new Map<String, ObjectStructureMap>{};
        this.maxLevel = new List<Integer>{};
    }
    
    /**
    * Allow page to set the current ID
    */
    public void setcurrentId( String cid ){
        currentId = cid;
    }

    /**
    * Return ObjectStructureMap to page
    * @return asm
    */
    public List<ObjectStructureMap> getObjectStructure(){
        asm.clear();
        if ( currentId == null ) {
            currentId = System.currentPageReference().getParameters().get( 'id' );
        }
        
        System.assertNotEquals( currentId, null, 'sObject ID must be provided' );
        asm = formatObjectStructure( CurrentId );
        
        return asm;
    }

    /**
    * Query Account from top down to build the ObjectStructureMap
    * @param currentId
    * @return asm
    */
    public ObjectStructureMap[] formatObjectStructure( String currentId ){
    
        List<ObjectStructureMap> asm = new List<ObjectStructureMap>{};
        masm.clear();

        //Change below
        List<Account> al            = new List<Account>{};
        List<ID> currentParent      = new List<ID>{};
        Map<ID, String> nodeList    = new Map<ID, String>{};
        List<String> nodeSortList   = new List<String>{};
        List<Boolean> levelFlag     = new List<Boolean>{};
        List<Boolean> closeFlag     = new List<Boolean>{};
        String nodeId               = '0';
        String nodeType             = 'child';
        Integer count               = 0;
        Integer level               = 0;
        Boolean endOfStructure      = false;
        
        //Find highest level obejct in the structure
        // get parent of passed in franchise (corp)
        currentParent.add( GetTopElement( currentId ) );
        Boolean currentIsTop = currentParent[0] == currentId;
        //Loop though all children
        while ( !endOfStructure ){
            
            // first round, level=0, currParent contains top (either corp if franchise or corp if corp)
            if( level == 0 ){
                // gets corp account details first round through    
                al = [ SELECT a.Type, a.Site, a.ParentId, a.OwnerId, a.Name, a.Industry, a.Id, a.Store_Number_NonOFG__c, billingstate, billingcountry, recordtype.name FROM Account a WHERE a.id IN : CurrentParent ORDER BY a.Name ];
            } 
            // second round, level=1, currParent contains top again (either corp if franchise or corp if corp)
            else if (level == 1) {
                // if we started at the top, bring in all child accounts (franchises)
                if (currentIsTop)
                    al = [ SELECT a.Type, a.Site, a.ParentId, a.OwnerId, a.Name, a.Industry, a.Id, a.Store_Number_NonOFG__c, billingstate, billingcountry, recordtype.name FROM Account a WHERE a.parentid IN : CurrentParent ORDER BY a.Name ];
                // else just bring in current account
                else 
                // get details for the current account we are on   
                    al = [ SELECT a.Type, a.Site, a.ParentId, a.OwnerId, a.Name, a.Industry, a.Id, a.Store_Number_NonOFG__c, billingstate, billingcountry, recordtype.name FROM Account a WHERE a.ID = :currentId ORDER BY a.Name ];
            }
            // third round, level=2, currParent contains top and all franchises if started from corp, or just corp and franchise if started from franchise
            else if( level == 2 ){
                // if we started from the top we want all children
                if (currentIsTop)
                    al = [ SELECT a.Type, a.Site, a.ParentId, a.OwnerId, a.Name, a.Industry, a.Id, a.Store_Number_NonOFG__c, billingstate, billingcountry, recordtype.name FROM Account a WHERE a.parentid IN : CurrentParent ORDER BY a.Name ];
                else
                // gets children accounts for current account only, not including children of parent  
                    al = [ SELECT a.Type, a.Site, a.ParentId, a.OwnerId, a.Name, a.Industry, a.Id, a.Store_Number_NonOFG__c, billingstate, billingcountry, recordtype.name FROM Account a WHERE a.parentid = :currentId ORDER BY a.Name ];
                // now we stop and don't go any further down the chain
                endOfStructure = true;
            } 
            
            if( al.size() == 0 ){
                endOfStructure = true;
            }
            else{
                currentParent.clear();
                for ( Integer i = 0 ; i < al.size(); i++ ){
                    //Change below
                    Account a = al[i];
                    // to accommodate large lists/numbers and string sorting, pad i to 4 digits
                    string nodeOrder = '';
                    // if less than 1000, pad number
                    if (i < 1000) {
                        // if less than 10, pad with 3 0
                        if (i<10) nodeOrder = '000';
                        else if (i<100) nodeOrder = '00';
                        else nodeOrder = '0';
                    }
                    nodeOrder += string.valueof(i);
                    //system.debug('node order: '+nodeorder);
                    nodeId = ( level > 0 ) ? NodeList.get( a.ParentId )+'.'+nodeOrder : nodeOrder;
                    masm.put( NodeID, new ObjectStructureMap( nodeID, levelFlag, closeFlag, nodeType, false, false, a ) );
                    currentParent.add( a.id );
                    nodeList.put( a.id,nodeId );
                    nodeSortList.add( nodeId );

                }
                
                maxLevel.add( level );                
                level++;
            }
        }
                            
        //Account structure must now be formatted
        NodeSortList.sort();
        for( Integer i = 0; i < NodeSortList.size(); i++ ){
            List<String> pnl = new List<String> {};
            List<String> cnl = new List<String> {};
            List<String> nnl = new List<String> {};
            
            if ( i > 0 ){
                String pn   = NodeSortList[i-1];
                pnl         = pn.split( '\\.', -1 );
            }

            String cn   = NodeSortList[i];
            cnl         = cn.split( '\\.', -1 );
            if( i < NodeSortList.size()-1 ){
                String nn = NodeSortList[i+1];
                nnl = nn.split( '\\.', -1 );
            }
            
            ObjectStructureMap tasm = masm.get( cn );
            if ( cnl.size() < nnl.size() ){
                //Parent
                tasm.nodeType = ( isLastNode( cnl ) ) ? 'parent_end' : 'parent';
            }
            else if( cnl.size() > nnl.size() ){
                tasm.nodeType   = 'child_end';
                tasm.closeFlag  = setcloseFlag( cnl, nnl, tasm.nodeType );
            }
            else{
                tasm.nodeType = 'child';
            }
            tasm.levelFlag = setlevelFlag( cnl, tasm.nodeType ); 
            
            //Change below
            if ( tasm.account.id == currentId ) {
                tasm.currentNode = true;
            }
            asm.add( tasm );
        }
        
        asm[0].nodeType             = 'start';
        asm[asm.size()-1].nodeType  = 'end';
        
        return asm;
    }
    
    /**
    * Determin parent elements relationship to current element
    * @return flagList
    */
    public List<Boolean> setlevelFlag( List<String> nodeElements, String nodeType ){
        
        List<Boolean> flagList = new List<Boolean>{};
        String searchNode   = '';
        String workNode     = '';
        Integer cn          = 0;
        
        for( Integer i = 0; i < nodeElements.size() - 1; i++ ){
            cn = Integer.valueOf( nodeElements[i] );
            cn++;
            searchNode  = workNode + String.valueOf( cn );
            workNode    = workNode + nodeElements[i] + '.';
            if ( masm.containsKey( searchNode ) ){
                flagList.add( true );
            }
            else {
                flagList.add( false );
            }
        }
        
        return flagList;
    }
    
    /**
    * Determin if the element is a closing element
    * @return flagList
    */
    public List<Boolean> setcloseFlag( List<String> cnl, List<String> nnl, String nodeType ){
        
        List<Boolean> flagList = new List<Boolean>{};
        String searchNode   = '';
        String workNode     = '';
        Integer cn          = 0;
        
        for( Integer i = nnl.size(); i < cnl.size(); i++ ){
            flagList.add( true );
        }
        
        return flagList;
    }
    
    /**
    * Determin if Element is the bottom node  
    * @return Boolean
    */
    public Boolean isLastNode( List<String> nodeElements ){
        
        String searchNode   = '';
        Integer cn          = 0;
        
        for( Integer i = 0; i < nodeElements.size(); i++ ){
            if ( i == nodeElements.size()-1 ){
                cn = Integer.valueOf( nodeElements[i] );
                cn++;
                searchNode = searchNode + String.valueOf( cn );
            }
            else {
                searchNode = searchNode + nodeElements[i] + '.';
            }
        }
        if ( masm.containsKey( searchNode ) ){
            return false;
        }
        else{
            return true;
        }
    }
    
    /**
    * Find the top most element in Heirarchy  
    * @return objId
    */
    public String GetTopElement( String objId ){
        // March 2015: changed code to only go one level up at most
        Account a = [ Select a.Id, a.ParentId From Account a where a.Id =: objId limit 1 ];
        if (a.parentid != null)
            return a.Parentid;
        else return a.id;
     /*   
        Boolean top = false;
        while ( !top ) {
            //Change below
            Account a = [ Select a.Id, a.ParentId From Account a where a.Id =: objId limit 1 ];
            
            if ( a.ParentID != null ) {
                objId = a.ParentID;
            }
            else {
                top = true;
            }
        }
        return objId ;
        */
    }
    
    /**
    * Wrapper class
    */
    public with sharing class ObjectStructureMap{

        public String nodeId;
        public Boolean[] levelFlag = new Boolean[]{};
        public Boolean[] closeFlag = new Boolean[]{};
        public String nodeType;
        public Boolean currentNode;
        
        /**
        * @Change this to your sObject
        */
        public Account account;
        
        public String getnodeId() { return nodeId; }
        public Boolean[] getlevelFlag() { return levelFlag; }
        public Boolean[] getcloseFlag() { return closeFlag; }
        public String getnodeType() { return nodeType; }
        public Boolean getcurrentNode() { return currentNode; }


        /**
        * @Change this to your sObject
        */
        public Account getaccount() { return account; }
        
        public void setnodeId( String n ) { this.nodeId = n; }
        public void setlevelFlag( Boolean l ) { this.levelFlag.add(l); }
        public void setlcloseFlag( Boolean l ) { this.closeFlag.add(l); }
        public void setnodeType( String nt ) { this.nodeType = nt; }
        public void setcurrentNode( Boolean cn ) { this.currentNode = cn; }

        /**
        * @Change this to your sObject
        */
        public void setaccount( Account a ) { this.account = a; }

        /**
        * @Change the parameters to your sObject
        */
        public ObjectStructureMap( String nodeId, Boolean[] levelFlag,Boolean[] closeFlag , String nodeType, Boolean lastNode, Boolean currentNode, Account a ){
            
            this.nodeId         = nodeId;
            this.levelFlag      = levelFlag; 
            this.closeFlag      = closeFlag;
            this.nodeType       = nodeType;
            this.currentNode    = currentNode;

            //Change this to your sObject  
            this.account = a;
        }
    }
}