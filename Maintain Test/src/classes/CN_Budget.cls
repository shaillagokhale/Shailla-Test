/*********************************************************************************
* Controller Class: CN_Budget
* DateCreated:  12/11/2013
----------------------------------------------------------------------------------
* Purpose/Methods:
* - 
----------------------------------------------------------------------------------
* Unit Test: TestGoalsAndImpactIndicators
----------------------------------------------------------------------------------
* History:
* - VERSION  DATE            DETAIL FEATURES
    1.0      12/11/2013      INITIAL DEVELOPMENT   
*********************************************************************************/

Public Class CN_Budget{
    Public Decimal intTotalIndicativeY1{get;set;}
    Public Decimal intTotalIndicativeY2{get;set;}
    Public Decimal intTotalIndicativeY3{get;set;}
    Public Decimal intTotalIndicativeY4{get;set;}
    Public Boolean blnblockNavigate{get;set;}
    Public Boolean blnReadOnly {get;set;}
    
    Public Decimal intTotalAboveY1{get;set;}
    Public Decimal intTotalAboveY2{get;set;}
    Public Decimal intTotalAboveY3{get;set;}
    Public Decimal intTotalAboveY4{get;set;}
    
    Public Decimal intTotalIndicative {get;set;}
    Public Decimal intTotalAbove {get;set;}
    
    Public String strCNId {get;set;}
    Public String strGIPId  {get;set;}
    Public String strLanguage {get;set;}
    Public String strGuidanceId {get;set;}
    
    Public List<CNIntervention> lstCNIntervention {get;set;}
    Public List<selectOption> lstPRName {get;set;}
    Public Boolean blnEdit {get;set;} 
    
    String strModuleId {get;set;}
    String strImplementationPeriodId {get;set;}
    String strCatalogModuleId {get;set;}
    String strNumberYear {get;set;}
    
    Public Boolean blnHistory {get; set;}
    Public String APIname {get;set;}
    Public String FieldAPIname {get;set;}
    Public String APITitle {get;set;}
    Public string[] mapofField {get;set;}
    Public string strCNstatus {get;set;}
    
    /* For Custom Setting profile Implementation*/
    Public Boolean blnExternalPro {get; set;}
    Public Boolean blnEditDescription {get; set;}
    Public Boolean blnEditAllocatedValues {get; set;}
    Public Boolean blnEditAboveAllocatedValues {get; set;}
    Public Boolean blnEditAssumptions {get; set;}
    Public Boolean blnSave {get; set;}    
    /* End */
    public CN_Budget(){}
    Public List<Module__c> lstModule {get;set;}
    
    Public CN_Budget(ApexPages.StandardController Controller){
        //blnReadOnly = CheckProfile.checkProfile();
        strModuleId = Apexpages.currentpage().getparameters().get('id');
        blnBlockNavigate = false;
        List<Guidance__c> lstGuidance = [Select Id from Guidance__c where Name = 'Modules Budget'];
            if(!lstGuidance.isEmpty()) {
              strGuidanceId = lstGuidance[0].Id; }
        blnEdit = false;
        if(String.IsBlank(strModuleId) == false){
            lstModule = [Select ID, Name, Implementation_Period__c,Language__c,Concept_Note__r.Status__c,Concept_Note__r.Number_of_Years__c,
                                        Catalog_Module__c,Concept_Note__c, Concept_Note__r.Language__c From Module__c 
                                        Where Id =: strModuleId Limit 1];
        }
        if(lstModule!=null && lstModule.size() > 0) {
            strImplementationPeriodId = lstModule[0].implementation_Period__c;
            strCNId = lstModule[0].Concept_Note__c;
            if(lstModule[0].Concept_Note__c != null) {
                strLanguage = lstModule[0].Concept_Note__r.Language__c;
                
           /*      strLanguage = 'ENGLISH';
            if(System.UserInfo.getLanguage() == 'fr'){
                strLanguage = 'FRENCH'; }
            if(System.UserInfo.getLanguage() == 'ru'){
                strLanguage = 'RUSSIAN'; }
            if(System.UserInfo.getLanguage() == 'es'){
                strLanguage = 'SPANISH'; }
                */
                system.debug('module list'+lstModule);
                strCNstatus = lstModule[0].Concept_Note__r.Status__c; 
                
                /* Commenting the below because of new implementation
                //INC014758
                //Added strCNstatus =='Reviewed and OK for TRP/GAC1' Condition for disabling the page
                if(strCNstatus == 'Submitted to the Global Fund'  && CheckProfile.checkProfileGF()==false){
                    blnReadOnly = true; }
                else if(strCNStatus == 'Not yet submitted'){
                    blnReadOnly = CheckProfile.checkProfile();
                } */
                
                 /* For Custom Setting profile Implementation*/
                 checkProfile();
                 /* End */
                
                
            }          
            strCatalogModuleId = lstModule[0].Catalog_Module__c;
            strNumberYear = lstModule[0].Concept_Note__r.Number_of_Years__c;
        }
        fillData();
        blnHistory = false;
        
        //for testing
        //blnReadOnly = true;      
    }
    //History Popup Open
    /*public void ShowPopupHistory()
    {
        blnHistory = true;
        ShowHistoryPopup();
    }*/
    //History Popup Close
    public void HidePopupHistory()
    {  
        if (HistoryIndexCN > -1 && HistoryIndexGI > -1) {
            lstCNIntervention[HistoryIndexCN ].lstGrantIntervention[HistoryIndexGI].blnHistory = false;
        }
    }
    //Bind History Record
    public Integer HistoryIndexCN {get;set;}
    public Integer HistoryIndexGI {get;set;}
    public void ShowHistoryPopup()
    {
        
        /*Map<String, Schema.SObjectType> sobjectSchemaMap = Schema.getGlobalDescribe();
        List<Schema.SObjectType> objectList = sobjectSchemaMap.Values();
        
        for (Schema.SObjectType s: objectList) {
            Schema.DescribeSObjectResult r = s.getDescribe();
            if(r.isCustom()){
                string Label = r.getLabel();
                string Name = r.getName();
                //system.debug('Label'+ Label + 'Name'+ Name);
                system.debug('@@'+Label);
            }
        }*/
       
        
        HistoryIndexCN = Integer.valueof(Apexpages.currentpage().getparameters().get('HistoryIndexCN'));
        HistoryIndexGI = Integer.valueof(Apexpages.currentpage().getparameters().get('HistoryIndexGI'));
        
        APIname = 'Grant_Intervention__c';
        FieldAPIname ='Implementation_Period__c';
        APITitle = 'History of :';
        mapofField = new List<String> { 'Implementation_Period__c#Responsible PR(s)',
         'Indicative (CurrencyIsoCode)#Indicative or Above Indicative',
         'Above (CurrencyIsoCode)#Indicative or Above Indicative',
         'Indicative_Y1__c#Indicative Y1', 'Indicative_Y2__c#Indicative Y2',
         'Indicative_Y3__c#Indicative Y3','Indicative_Y4__c#Indicative Y4',
         'Above_Indicative_Y1__c#Above Indicative Y1','Above_Indicative_Y2__c#Above Indicative Y2',
         'Above_Indicative_Y3__c#Above Indicative Y3','Above_Indicative_Y4__c#Above Indicative Y4'};
       
        /*mapofField.put('Implementation_Period__c','Responsible PR(s)'); 
        mapofField.put('Implementation_Period__c','Responsible PR(s)');
        mapofField.put('Implementation_Period__c','Responsible PR(s)');
        mapofField.put('Implementation_Period__c','Responsible PR(s)');
        mapofField.put('Implementation_Period__c','Responsible PR(s)');  */
        //---------Common History Code------
        /*String accid= lstCNIntervention[HistoryIndexCN].lstGrantIntervention[HistoryIndexGI].objGI.Implementation_Period__r.Principal_Recipient__c;
        system.debug('aaaid:'+accid);
        String APIname = 'Account';
        String FieldAPIname ='Short_Name__c';
        String query;
        query = 'SELECT CreatedBy.Name,Id, IsDeleted, CreatedById, CreatedDate, Field, OldValue, NewValue FROM ';
       
        String APIname1 = 'Grant_Intervention__c';
        String FieldAPIname1 ='Implementation_Period__c';
        if(APIname.contains('__c')){
            APIname = APIname.subString(0,APIname.length()-3);
            APIname+='__History';
            system.debug('Append:'+ APIname);
        }else{
            APIname+='History';
        }
        query += APIname+' where Field = \''+ FieldAPIname +'\' ' +' and accountid =: accid';
        system.debug('Append:'+ query);
        ////-----------
     
        lstCNIntervention[HistoryIndexCN].lstGrantIntervention[HistoryIndexGI].lstaccHistory = new List<AccountHistory>();
      
        lstCNIntervention[HistoryIndexCN].lstGrantIntervention[HistoryIndexGI].lstGIHistory = [SELECT CreatedBy.Name,Id, IsDeleted, CreatedById, CreatedDate, Field, OldValue, NewValue FROM Grant_Intervention__History
                where Field = 'Implementation_Period__c'  ];
        lstCNIntervention[HistoryIndexCN].lstGrantIntervention[HistoryIndexGI].lstaccHistory = Database.Query(query);
        system.debug('rid' + lstCNIntervention[HistoryIndexCN].lstGrantIntervention[HistoryIndexGI].objGI.Implementation_Period__r.Principal_Recipient__c);
       
        
        if (HistoryIndexCN > -1 && HistoryIndexGI > -1) {
            lstCNIntervention[HistoryIndexCN].lstGrantIntervention[HistoryIndexGI].blnHistory = true;
        }
        system.debug('Bln:'+ lstCNIntervention[HistoryIndexCN].lstGrantIntervention[HistoryIndexGI].blnHistory);
         */
         lstCNIntervention[HistoryIndexCN].lstGrantIntervention[HistoryIndexGI].blnHistory = true;
         system.debug('Bln:'+ lstCNIntervention[HistoryIndexCN].lstGrantIntervention[HistoryIndexGI].blnHistory);
    } 
    Private void fillData(){
        List<Intervention__c> lstIntervention = [
                    Select Id, Name, Description_of_intervention__c,Description_of_Intervention_French__c,Description_of_Intervention_Russian__c,Description_of_Intervention_Spanish__c, Custom_Intervention_Name__c,Standard_or_Custom__c,
                        (
                            Select Id, Name, Implementation_Period__r.Principal_Recipient__r.Short_Name__c, 
                            Implementation_Period__r.Principal_Recipient__c,
                            Indicative_Y1__c,Indicative_Y2__c,Indicative_Y3__c ,Indicative_Y4__c, 
                            Above_Indicative_Y1__c,Above_Indicative_Y2__c,Above_Indicative_Y3__c,
                            Above_Indicative_Y4__c, CN_cost_assumptions__c,CN_Cost_Assumptions_Russian__c,CN_Cost_Assumptions_Spanish__c,CN_Cost_Assumptions_French__c, CN_other_funding__c,
                            CN_Other_Funding_Russian__c,CN_Other_Funding_French__c,CN_Other_Funding_Spanish__c    
                            from Grant_Interventions__r 
                            Order By Implementation_Period__r.Principal_Recipient__r.Short_Name__c
                        )
                    from Intervention__c  where Module_rel__c=:strModuleId  Order By Name
                    ];
                    
                if( strLanguage == 'FRENCH'){
                     
                    lstIntervention = [
                    Select Id,Name, French_Name__c, Description_of_intervention__c,Description_of_Intervention_French__c,Description_of_Intervention_Russian__c,Description_of_Intervention_Spanish__c,Custom_Intervention_Name__c,Standard_or_Custom__c,
                        (
                            Select Id, Name, Implementation_Period__r.Principal_Recipient__r.Short_Name__c, 
                            Implementation_Period__r.Principal_Recipient__c,
                            Indicative_Y1__c,Indicative_Y2__c,Indicative_Y3__c ,Indicative_Y4__c, 
                            Above_Indicative_Y1__c,Above_Indicative_Y2__c,Above_Indicative_Y3__c,
                            Above_Indicative_Y4__c, CN_cost_assumptions__c,CN_Cost_Assumptions_Russian__c,CN_Cost_Assumptions_Spanish__c,CN_Cost_Assumptions_French__c, CN_other_funding__c,
                            CN_Other_Funding_Russian__c,CN_Other_Funding_French__c,CN_Other_Funding_Spanish__c 
                            from Grant_Interventions__r 
                            Order By Implementation_Period__r.Principal_Recipient__r.Short_Name__c
                        )
                    from Intervention__c  where Module_rel__c=:strModuleId  Order By French_Name__c
                    ];
             }
                 
            if(strLanguage == 'RUSSIAN'){
                
               lstIntervention = [
                    Select Id,Name, Russian_Name__c, Description_of_intervention__c,Description_of_Intervention_French__c,Description_of_Intervention_Russian__c,Description_of_Intervention_Spanish__c,Custom_Intervention_Name__c,Standard_or_Custom__c,
                        (
                            Select Id, Name, Implementation_Period__r.Principal_Recipient__r.Short_Name__c, 
                            Implementation_Period__r.Principal_Recipient__c,
                            Indicative_Y1__c,Indicative_Y2__c,Indicative_Y3__c ,Indicative_Y4__c, 
                            Above_Indicative_Y1__c,Above_Indicative_Y2__c,Above_Indicative_Y3__c,
                            Above_Indicative_Y4__c, CN_cost_assumptions__c,CN_Cost_Assumptions_Russian__c,CN_Cost_Assumptions_Spanish__c,CN_Cost_Assumptions_French__c, CN_other_funding__c,
                            CN_Other_Funding_Russian__c,CN_Other_Funding_French__c,CN_Other_Funding_Spanish__c 
                            from Grant_Interventions__r 
                            Order By Implementation_Period__r.Principal_Recipient__r.Short_Name__c
                        )
                    from Intervention__c  where Module_rel__c=:strModuleId  Order By Russian_Name__c
                    ];
                
            }
            
            if(strLanguage == 'SPANISH'){
               
               lstIntervention = [
                    Select Id,Name, Spanish_Name__c, Description_of_intervention__c,Description_of_Intervention_French__c,Description_of_Intervention_Russian__c,Description_of_Intervention_Spanish__c,Custom_Intervention_Name__c,Standard_or_Custom__c,
                        (
                            Select Id, Name, Implementation_Period__r.Principal_Recipient__r.Short_Name__c, 
                            Implementation_Period__r.Principal_Recipient__c,
                            Indicative_Y1__c,Indicative_Y2__c,Indicative_Y3__c ,Indicative_Y4__c, 
                            Above_Indicative_Y1__c,Above_Indicative_Y2__c,Above_Indicative_Y3__c,
                            Above_Indicative_Y4__c, CN_cost_assumptions__c,CN_Cost_Assumptions_Russian__c,CN_Cost_Assumptions_Spanish__c,CN_Cost_Assumptions_French__c, CN_other_funding__c,
                            CN_Other_Funding_Russian__c,CN_Other_Funding_French__c,CN_Other_Funding_Spanish__c 
                            from Grant_Interventions__r 
                            Order By Implementation_Period__r.Principal_Recipient__r.Short_Name__c
                        )
                    from Intervention__c  where Module_rel__c=:strModuleId  Order By Spanish_Name__c
                    ];
                
             }
                    
        lstCNIntervention = new List<CNIntervention>();
        CNIntervention objCNIntervention;
        
        intTotalIndicativeY1 = 0;
        intTotalIndicativeY2 = 0;
        intTotalIndicativeY3 = 0;
        intTotalIndicativeY4 = 0;
        
        intTotalAboveY1 = 0;
        intTotalAboveY2 = 0;
        intTotalAboveY3 = 0;
        intTotalAboveY4 = 0;
        
        intTotalIndicative = 0;
        intTotalAbove = 0;
        GrantIntervention objWrapGI;
        for(Intervention__c objCNI : lstIntervention)
        {
            objCNIntervention = new CNIntervention();
            objCNIntervention.objIntervention = objCNI;
            objCNIntervention.lstGrantIntervention = new List<GrantIntervention>();
            
            for(Grant_Intervention__c objGI : objCNI.Grant_Interventions__r){
                objWrapGI = new GrantIntervention();
                objWrapGI.objGI = objGI;
                objWrapGI.blnEdit = false;
                objWrapGI.blnHistory =false;
                objCNIntervention.lstGrantIntervention.add(objWrapGI);
                
                intTotalIndicativeY1 += ConvertToValue(objGI.Indicative_Y1__c);
                intTotalIndicativeY2 += ConvertToValue(objGI.Indicative_Y2__c);
                intTotalIndicativeY3 += ConvertToValue(objGI.Indicative_Y3__c);
                intTotalIndicativeY4 += ConvertToValue(objGI.Indicative_Y4__c);
                
                intTotalAboveY1 += ConvertToValue(objGI.Above_Indicative_Y1__c);
                intTotalAboveY2 += ConvertToValue(objGI.Above_Indicative_Y2__c);
                intTotalAboveY3 += ConvertToValue(objGI.Above_Indicative_Y3__c);
                intTotalAboveY4 += ConvertToValue(objGI.Above_Indicative_Y4__c);
            }
            //objCNIntervention.blnEdit = false;
            lstCNIntervention.add(objCNIntervention);
        }
        if(strNumberYear == '4'){
            intTotalIndicative += intTotalIndicativeY1 + intTotalIndicativeY2 + intTotalIndicativeY3 + intTotalIndicativeY4;
            intTotalAbove += intTotalAboveY1 + intTotalAboveY2 + intTotalAboveY3 + intTotalAboveY4;
        }else{
            intTotalIndicative += intTotalIndicativeY1 + intTotalIndicativeY2 + intTotalIndicativeY3;
            intTotalAbove += intTotalAboveY1 + intTotalAboveY2 + intTotalAboveY3;
        }
    }
    
    Private Decimal ConvertToValue(Decimal Value){
        if(Value != null){
            return value;
        }
        return 0;
    }
    Public void SaveDraft(){
        Save();
        fillData();
    }
    
    Public PageReference SaveReturn(){
        Save();
        return new PageReference('/apex/CNOverview?id='+strCNId);
    }
    
    Private void Save(){
        List<Intervention__c> lstIntervention = new List<Intervention__c>();
        List<Grant_Intervention__c> lstGrantIntervention = new List<Grant_Intervention__c>();
        for(CNIntervention objCNI : lstCNIntervention)
        {
            lstIntervention.add(objCNI.objIntervention );
            for(GrantIntervention objGrantIntervention :objCNI.lstGrantIntervention){
                lstGrantIntervention.add(objGrantIntervention.objGI);
            }
            
        }
        update lstIntervention;
        update lstGrantIntervention;
        blnBlockNavigate = false;
    }
    
    Public void DeletePR() {
        
        Integer DeleteIndexCN = Integer.valueof(Apexpages.currentpage().getparameters().get('DeleteIndexCN'));
        Integer DeleteIndexGI = Integer.valueof(Apexpages.currentpage().getparameters().get('DeleteIndexGI'));
        system.debug('####---DeleteIndexCI---- '+DeleteIndexCN);
        system.debug('####---DeleteIndexGI---- '+DeleteIndexGI);
        if (DeleteIndexCN > -1 && DeleteIndexGI > -1) {
            delete lstCNIntervention[DeleteIndexCN].lstGrantIntervention[DeleteIndexGI].objGI;
            //remove from list
            lstCNIntervention[DeleteIndexCN].lstGrantIntervention.remove(DeleteIndexGI);
        }
        
        //calculate field again
            CalculateField();
    
    }
    
    Public Void CalculateField() {
    
        intTotalIndicativeY1 = 0;
        intTotalIndicativeY2 = 0;
        intTotalIndicativeY3 = 0;
        intTotalIndicativeY4 = 0;
        
        intTotalAboveY1 = 0;
        intTotalAboveY2 = 0;
        intTotalAboveY3 = 0;
        intTotalAboveY4 = 0;
        
        intTotalIndicative = 0;
        intTotalAbove = 0;
        for(CNIntervention objCNI : lstCNIntervention)
        {
            for(GrantIntervention objGI : objCNI.lstGrantIntervention ){
                intTotalIndicativeY1 += ConvertToValue(objGI.objGI.Indicative_Y1__c);
                intTotalIndicativeY2 += ConvertToValue(objGI.objGI.Indicative_Y2__c);
                intTotalIndicativeY3 += ConvertToValue(objGI.objGI.Indicative_Y3__c);
                intTotalIndicativeY4 += ConvertToValue(objGI.objGI.Indicative_Y4__c);
                
                intTotalAboveY1 += ConvertToValue(objGI.objGI.Above_Indicative_Y1__c);
                intTotalAboveY2 += ConvertToValue(objGI.objGI.Above_Indicative_Y2__c);
                intTotalAboveY3 += ConvertToValue(objGI.objGI.Above_Indicative_Y3__c);
                intTotalAboveY4 += ConvertToValue(objGI.objGI.Above_Indicative_Y4__c);
            }
        }
        if(strNumberYear == '4'){
            intTotalIndicative += intTotalIndicativeY1 + intTotalIndicativeY2 + intTotalIndicativeY3 + intTotalIndicativeY4;
            intTotalAbove += intTotalAboveY1 + intTotalAboveY2 + intTotalAboveY3 + intTotalAboveY4;
        }else{
            intTotalIndicative += intTotalIndicativeY1 + intTotalIndicativeY2 + intTotalIndicativeY3;
            intTotalAbove += intTotalAboveY1 + intTotalAboveY2 + intTotalAboveY3;
        }
    
    }
    
    
    Public void  EditPR () {
        strGIPId = 'All';
        
        lstPRName = new List<SelectOption>();
        lstPRName.Add(new SelectOption('All','--- Select PR ---'));
        Integer DeleteIndexCN = Integer.valueof(Apexpages.currentpage().getparameters().get('DeleteIndexCN'));
        Integer DeleteIndexGI = Integer.valueof(Apexpages.currentpage().getparameters().get('DeleteIndexGI'));
        system.debug('strCNId = '+strCNId);
        set<ID> setExistingIP = new set<ID>();
        for (GrantIntervention objTempGrant :lstCNIntervention[DeleteIndexCN].lstGrantIntervention){
            setExistingIP.add(objTempGrant.objGI.Implementation_Period__c);
        }
        system.debug('setExistingIP = '+setExistingIP);
        
        for(Implementation_Period__c objIP : [select Id,Principal_Recipient__c,Principal_Recipient__r.Short_Name__c
                                              from Implementation_Period__c where Id NOT IN :setExistingIP AND Concept_Note__c =: strCNId ]) {
                                              
            if(objIP.Principal_Recipient__r.Short_Name__c != null)
            lstPRName.Add(new SelectOption(objIP.Id,objIP.Principal_Recipient__r.Short_Name__c));
        }
        if (DeleteIndexCN > -1 && DeleteIndexGI > -1) {
            for(CNIntervention objCNI : lstCNIntervention) {
                for(GrantIntervention objGI : objCNI.lstGrantIntervention){
                    objGI.blnEdit = false;
                }
            }
            lstCNIntervention[DeleteIndexCN].lstGrantIntervention[DeleteIndexGI].blnEdit = true;
        }

    }
    Public Void SavePR () {
        Integer DeleteIndexCN = Integer.valueof(Apexpages.currentpage().getparameters().get('DeleteIndexCN'));
        Integer DeleteIndexGI = Integer.valueof(Apexpages.currentpage().getparameters().get('DeleteIndexGI'));
        System.debug('%%% CN: ' + DeleteIndexCN + ', GI: ' + DeleteIndexGI);
        if (DeleteIndexCN > -1 && DeleteIndexGI > -1) {
            lstCNIntervention[DeleteIndexCN].lstGrantIntervention[DeleteIndexGI].blnEdit = false;
            if(strGIPId  != 'All')
            lstCNIntervention[DeleteIndexCN].lstGrantIntervention[DeleteIndexGI].objGI.Implementation_Period__c = strGIPId ;
            List<Implementation_Period__c> lstSortName = [select Principal_Recipient__r.Short_Name__c from Implementation_Period__c where Id =:strGIPId  AND Concept_Note__c =: strCNId];
            
            if(lstSortName.size() > 0) {
            lstCNIntervention[DeleteIndexCN].lstGrantIntervention[DeleteIndexGI].objGI.Implementation_Period__r.Principal_Recipient__r.Short_Name__c = lstSortName[0].Principal_Recipient__r.Short_Name__c;
            }
            
            Grant_Intervention__c objTempGI = new Grant_Intervention__c( id =lstCNIntervention[DeleteIndexCN].lstGrantIntervention[DeleteIndexGI].objGI.id,Implementation_Period__c = lstCNIntervention[DeleteIndexCN].lstGrantIntervention[DeleteIndexGI].objGI.Implementation_Period__c);
            update objTempGI;
            
            fillData();
            CalculateField();
           
        }
    }
    Public Void CancelPR () {
        lstPRName = new List<SelectOption>();
        Integer DeleteIndexCN = Integer.valueof(Apexpages.currentpage().getparameters().get('DeleteIndexCN'));
        Integer DeleteIndexGI = Integer.valueof(Apexpages.currentpage().getparameters().get('DeleteIndexGI'));

        if (DeleteIndexCN > -1 && DeleteIndexGI > -1) {
            lstCNIntervention[DeleteIndexCN].lstGrantIntervention[DeleteIndexGI].blnEdit = false;
        }
    }
    
    Public Class GrantIntervention{
        Public Grant_Intervention__c objGI {get;set;}
        Public boolean blnEdit {get;set;}  
        Public Boolean blnHistory {get; set;}
        Public List<AccountHistory> lstaccHistory{get; set;}
        Public List<Grant_Intervention__History> lstGIHistory{get;set;}
    }
    
    Public Class CNIntervention{
        Public Intervention__c objIntervention {get;set;}
        Public List<GrantIntervention> lstGrantIntervention {get;set;}
        //Public List<Grant_Intervention__c> lstGrantIntervention {get;set;}
        //Public boolean blnEdit {get;set;}
    }
    
    /* For Custom Setting profile Implementation*/
    public void checkProfile(){
                 blnExternalPro = false;
                 blnEditDescription = false;
                 blnEditAllocatedValues = false;
                 blnEditAboveAllocatedValues = false;
                 blnEditAssumptions = false;
                 blnSave = false;
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        List<Profile_Access_Setting_CN__c> checkpage = new List<Profile_Access_Setting_CN__c>();
        List<String> PermissionSets = new List<String>();
        List<PermissionSetAssignment> standalonePermSets = [ SELECT PermissionSet.Label FROM PermissionSetAssignment WHERE Assignee.Username =: UserInfo.getUserName()];
        if(standalonePermSets.size()>0){
        for(PermissionSetAssignment PermSets : standalonePermSets){
            PermissionSets.add(PermSets.PermissionSet.Label);
            system.debug('Name '+PermSets.PermissionSet.Label);
            
        }}
        checkpage = [Select Salesforce_Item__c,Status__c from Profile_Access_Setting_CN__c where Page_Name__c ='CN_Budget' and (Profile_Name__c =: profileName OR Permission_Sets__c IN: PermissionSets) ];
        system.debug('profileName'+ profileName);
        system.debug('profile list'+ checkpage);
        
        for (Profile_Access_Setting_CN__c check : checkpage){
            if(check.Salesforce_Item__c == 'External Profile') blnExternalPro = true;
            if(check.Salesforce_Item__c == 'Edit Description' && check.Status__c == strCNstatus) blnEditDescription = true;
            if(check.Salesforce_Item__c == 'Edit Allocated Values' && check.Status__c == strCNstatus) blnEditAllocatedValues = true;
            if(check.Salesforce_Item__c == 'Edit Above Allocated Values' && check.Status__c == strCNstatus) blnEditAboveAllocatedValues = true;
            if(check.Salesforce_Item__c == 'Edit Assumptions' && check.Status__c == strCNstatus) blnEditAssumptions = true;
            if(check.Salesforce_Item__c == 'Save' && check.Status__c == strCNstatus) blnSave = true;
        }
    }
    /* End */
    
    
}