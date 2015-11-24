global class ctrlGrantMakingOverview{
    public String strGIPId {get;set;}
    public List<Period__c> lstRP {get;set;}
    Public List<Page__c> lstPages {get;set;}
    Public List<Module__c> lstModules {get;set;}
    Public Boolean blnExpandSection {get;set;}
    Public List<BLPayee> lstBLPayee {get;set;}   
    Public List<BLCost> lstBLCost {get;set;} 
    Public List<BLModule> lstBLModule {get;set;} 
    Public List<Profile_Access_Setting__c> lstProfileSetting {get;set;}
    Public set<string> myset{get;set;}
    
    Public Integer TotalModuleY1Cost {get;set;}
    Public Integer TotalModuleY2Cost {get;set;}
    Public Integer TotalModuleY3Cost {get;set;}
    Public Integer TotalModuleY4Cost {get;set;}
    Public Integer AllYearModuleTotalCost {get;set;}
    
    Public Integer TotalY1Cost {get;set;}
    Public Integer TotalY2Cost {get;set;}
    Public Integer TotalY3Cost {get;set;}
    Public Integer TotalY4Cost {get;set;}
    Public Integer AllYearTotalCost {get;set;}
    
    Public Integer TotalPayeeY1Cost {get;set;}
    Public Integer TotalPayeeY2Cost {get;set;}
    Public Integer TotalPayeeY3Cost {get;set;}
    Public Integer TotalPayeeY4Cost {get;set;}
    Public Integer AllYearPayeeTotalCost {get;set;}
    
    Public Boolean blnDraftStatusExist {get;set;}
    Public String strGuidanceId {get;set;}
    Public String strLanguage {get;set;}
    public Implementation_Period__c recordIP {get; set;}
    ApexPages.StandardController ip_sc = null;
    
    public String strRationale {get;set;}
    public String strGoalsAndStrategies {get;set;}
    public String strBeneficiaries {get;set;}
    public Boolean blnProfileCheck{get;set;}
    Public List<Page__c> lstPagesOnCancel {get;set;}
    //public List<String> strPRComments {get;set;}
    //public List<String> strLFAComments {get;set;}
    //public List<String> strCTComments {get;set;}
    public Boolean blnExternalPro {get; set;}
    public Boolean blnGrantInfo {get; set;}
    public Boolean blnDialog {get;set;}
    public Boolean blnSubmitGrant {get;set;}
    public Boolean blnPrgTitle {get;set;}
    public Boolean blnViewChart {get;set;}
    public Boolean blnSubmitBudgetToCT {get;set;}
    public Boolean blnSubmitBudgetToLFA {get;set;}
    public Boolean blnLFASubmitBudgetToCT {get;set;}
    public Boolean blnShareBudgetwithPR {get;set;}
    public Boolean blnSubmitFinalBudget {get;set;}
    public Boolean blnAgreeFinalBudget {get;set;}
    public String strBudgetStatus {get;set;}
    
    public List<IP_Detail_Information__c> lstIPDetails = new List<IP_Detail_Information__c>();
    String profileName;
    Public List<BLModule> lstBLModuleByModule {get;set;}
    Public String [] lstGranInfoFields {get; set;}
    
    public ctrlGrantMakingOverview(ApexPages.StandardController controller) {
        
        strGIPId = Apexpages.currentpage().getparameters().get('id');
        
        recordIP = (Implementation_Period__c)controller.getrecord();
         
        ip_sc = controller;     
        blnExpandSection = false;  
        blnDraftStatusExist = false;
        lstGranInfoFields = new String[] {'Rationale_for_Program__c', 'Goals_and_Strategies_for_program__c', 'Target_beneficiaries_of_program__c'};
        lstRP = new List<Period__c>();   
        lstRP = [Select Id, Period_Number__c,Start_Date__c,End_Date__c,Due_Date__c From Period__c Where Implementation_Period__c =: strGIPID And Type__c = 'Reporting' Order by Period_Number__c];        
    
        lstPages = new List<Page__c>();   
        lstPages = [Select Id,Name,French_Name__c, Russian_Name__c, Spanish_Name__c, URL_Prefix__c,Order__c,Modular__c,Status__c,PR_Comments__c,LFA_Comments__c,CT_Comments__c,Latest_PR_Comment__c,Latest_LFA_Comment__c,Latest_CT_Comment__c From Page__c Where Implementation_Period__c =: strGIPID Order by Order__c]; 
        
        lstIPDetails = [SELECT Budget_Status__c FROM IP_Detail_Information__c WHERE Implementation_Period__c =:strGIPId];
        system.debug('List of Detail Records'+lstIPDetails);
        if(lstIPDetails.size()>0){
        	strBudgetStatus = lstIPDetails[0].Budget_Status__c;
        }
        system.debug('Budget Status '+strBudgetStatus);
        CheckBoolean();
        
        lstModules = new List<Module__c>();   
        lstModules = [Select Id,Name,Implementation_Period__c From Module__c Where Implementation_Period__c =: strGIPID Order by Name];  
        
        List<AggregateResult> lstBudgetLineModule = [Select Grant_Intervention__r.Module__r.Name Modulename,Grant_Intervention__r.Name Interventionname, Sum(Y1_Grant_Amount__c) ModuleY1,Sum(Y2_Grant_Amount__c) ModuleY2,Sum(Y3_Grant_Amount__c) ModuleY3,Sum(Y4_Grant_Amount__c) ModuleY4 From Budget_Line__c WHERE Grant_Intervention__r.Implementation_Period__c =: strGIPId Group By Grant_Intervention__r.Module__r.Name,Grant_Intervention__r.Name];
        List<AggregateResult> lstBudgetLineCost = [Select Cost_Input__r.Cost_Grouping__c CostGrouping,Sum(Y1_Grant_Amount__c) CostY1,Sum(Y2_Grant_Amount__c) CostY2,Sum(Y3_Grant_Amount__c) CostY3,Sum(Y4_Grant_Amount__c) CostY4 From Budget_Line__c Where Cost_Input__r.Cost_Grouping__c != null And Grant_Intervention__r.Implementation_Period__c =: strGIPId Group By Cost_Input__r.Cost_Grouping__c Order by Cost_Input__r.Cost_Grouping__c];
        List<AggregateResult> lstBudgetLinePayee = [Select Payee__c PayeeId,Sum(Y1_Grant_Amount__c) PayeeY1,Sum(Y2_Grant_Amount__c) PayeeY2,Sum(Y3_Grant_Amount__c) PayeeY3,Sum(Y4_Grant_Amount__c) PayeeY4 From Budget_Line__c where Payee__c != null And Grant_Intervention__r.Implementation_Period__c =: strGIPId Group By Payee__c ];
        
        List<AggregateResult> lstBudgetLineGroupByModule = [Select Grant_Intervention__r.Module__r.Name Modulename, Sum(Y1_Grant_Amount__c) ModuleY1,Sum(Y2_Grant_Amount__c) ModuleY2,Sum(Y3_Grant_Amount__c) ModuleY3,Sum(Y4_Grant_Amount__c) ModuleY4 From Budget_Line__c WHERE Grant_Intervention__r.Implementation_Period__c =: strGIPId Group By Grant_Intervention__r.Module__r.Name];        
        
        Set<Id> setPayeeIds = new Set<Id>();
        for(AggregateResult objAgg : lstBudgetLinePayee){
            setPayeeIds.add((Id)objAgg.get('PayeeId'));       
        
        List<Implementation_Period__c> lstIP = [select Id, Name, Rationale_for_Program__c, Goals_and_Strategies_for_program__c, Target_beneficiaries_of_program__c from Implementation_Period__c where Id = :strGIPId];//Revert commented after changes to field type is deployed
        
        //List<Implementation_Period__c> lstIP = [select Id, Name from Implementation_Period__c where Id = :strGIPId];
        If(lstIP.size()>0)
        {
        strRationale =lstIP[0].Rationale_for_Program__c;
        strGoalsAndStrategies =lstIP[0].Goals_and_Strategies_for_program__c;
        strBeneficiaries =lstIP[0].Target_beneficiaries_of_program__c; //Revert commented after changes to field type is deployed
        }
        
        
        /*if(lstPages.size()>0)
        {
        for(integer i=0;i<lstPages.size();i++){
        strPRComments[i]  =lstPages[i].PR_Comments__c;
        strLFAComments[i]  =lstPages[i].LFA_Comments__c;
        strCTComments[i] =lstPages[i].CT_Comments__c;
        }
        }*/
        }
        Map<Id,Implementer__c> mapImplementer = new Map<Id,Implementer__c>([Select Id,Implementer_Name__c From Implementer__c Where Id IN : setPayeeIds]);
        
        lstBLModuleByModule = new List<BLModule>();
        for(AggregateResult objAggM : lstBudgetLineGroupByModule){
            BLModule objwrapByModule = new BLModule();
                        
            objwrapByModule.ModuleName = String.valueof(objAggM.get('Modulename'));
            objwrapByModule.blnbckgrnd = true;
            
            if(objAggM.get('ModuleY1') != null) objwrapByModule.ModuleCostY1 = Integer.valueof(objAggM.get('ModuleY1'));
            else objwrapByModule.ModuleCostY1 = 0;
            if(objAggM.get('ModuleY2') != null) objwrapByModule.ModuleCostY2 = Integer.valueof(objAggM.get('ModuleY2'));
            else objwrapByModule.ModuleCostY2 = 0;
            if(objAggM.get('ModuleY3') != null) objwrapByModule.ModuleCostY3 = Integer.valueof(objAggM.get('ModuleY3'));
            else objwrapByModule.ModuleCostY3 = 0;
            if(objAggM.get('ModuleY4') != null) objwrapByModule.ModuleCostY4 = Integer.valueof(objAggM.get('ModuleY4'));
            else objwrapByModule.ModuleCostY4 = 0;
            objwrapByModule.TotalModuleCost = objwrapByModule.ModuleCostY1 + objwrapByModule.ModuleCostY2 + objwrapByModule.ModuleCostY3 + objwrapByModule.ModuleCostY4;
            
            lstBLModuleByModule.add(objwrapByModule);
            }
        
        lstBLModule = new List<BLModule>();
        
        Integer index = 1;
        String ModName ='';  
        for(AggregateResult objAgg : lstBudgetLineModule){
            
            BLModule objwrap = new BLModule();
            objwrap.InterventionName = String.valueof(objAgg.get('Interventionname'));            
            
            objwrap.ModuleName = String.valueof(objAgg.get('Modulename'));
            
            if(objwrap.ModuleName == ModName)
            {objwrap.ModuleName = '';}
            else
            { objwrap.ModuleName = String.valueof(objAgg.get('Modulename'));}
            
            ModName = String.valueof(objAgg.get('Modulename'));
            
            if(objAgg.get('ModuleY1') != null) objwrap.ModuleCostY1 = Integer.valueof(objAgg.get('ModuleY1'));
            else objwrap.ModuleCostY1 = 0;
            if(objAgg.get('ModuleY2') != null) objwrap.ModuleCostY2 = Integer.valueof(objAgg.get('ModuleY2'));
            else objwrap.ModuleCostY2 = 0;
            if(objAgg.get('ModuleY3') != null) objwrap.ModuleCostY3 = Integer.valueof(objAgg.get('ModuleY3'));
            else objwrap.ModuleCostY3 = 0;
            if(objAgg.get('ModuleY4') != null) objwrap.ModuleCostY4 = Integer.valueof(objAgg.get('ModuleY4'));
            else objwrap.ModuleCostY4= 0;
            objwrap.TotalModuleCost = objwrap.ModuleCostY1 + objwrap.ModuleCostY2 + objwrap.ModuleCostY3 + objwrap.ModuleCostY4;
            
            if(TotalModuleY1Cost == null) TotalModuleY1Cost = objwrap.ModuleCostY1;
            else TotalModuleY1Cost += objwrap.ModuleCostY1;
            if(TotalModuleY2Cost == null) TotalModuleY2Cost = objwrap.ModuleCostY2;
            else TotalModuleY2Cost += objwrap.ModuleCostY2;
            if(TotalModuleY3Cost == null) TotalModuleY3Cost = objwrap.ModuleCostY3;
            else TotalModuleY3Cost += objwrap.ModuleCostY3;
            if(TotalModuleY4Cost == null) TotalModuleY4Cost = objwrap.ModuleCostY4;
            else TotalModuleY4Cost += objwrap.ModuleCostY4;
            if(AllYearModuleTotalCost == null) AllYearModuleTotalCost = objwrap.TotalModuleCost;
            else AllYearModuleTotalCost += objwrap.TotalModuleCost;
            
            lstBLModule.add(objwrap);
            /* TCS- 08/09/2014: User Story update to include Module Table*/
                if(index>lstBudgetLineModule.size()){
                
                }
                else if(index==lstBudgetLineModule.size() || (index<lstBudgetLineModule.size() && lstBudgetLineModule[index].get('Modulename') != lstBudgetLineModule[index-1].get('Modulename')))
                {
                    
                for(BLModule objByModule : lstBLModuleByModule)
                {if(lstBudgetLineModule[index-1].get('Modulename') == objByModule.Modulename)
                {
                lstBLModule.add(objByModule);
                break;
                }
                }
                }
                 
                
            
           index++;
            
        }
        
        //for(BLModule objwrap: lstBLModule)
         
        
        
            //if(count<lstBLModule.size() && lstBLModule[count].Modulename != lstBLModule[count+1].Modulename)
          /*  for(Integer count=0;count< lstBLModule.size();count++ ){
            if(count>=lstBLModule.size() && lstBLModule[count].Modulename == lstBLModule[count+1].Modulename)
            {}
            else
            {
            for(BLModule objwrapByModule: lstBLModuleByModule)
            {
            lstBLModule.add(objwrapByModule);
            System.debug('Errors'+objwrapByModule);
             break;
             }
            
            }
            }*/
        
       
        
        
        lstBLPayee = new List<BLPayee>();
        for(AggregateResult objAgg : lstBudgetLinePayee){
            BLPayee objwrap = new BLPayee();
            objwrap.PayeeName = mapImplementer.get((ID)objAgg.get('PayeeId')).Implementer_Name__c;
            if(objAgg.get('PayeeY1') != null) objwrap.PayeeCostY1 = Integer.valueof(objAgg.get('PayeeY1'));
            else objwrap.PayeeCostY1 = 0;
            if(objAgg.get('PayeeY2') != null) objwrap.PayeeCostY2 = Integer.valueof(objAgg.get('PayeeY2'));
            else objwrap.PayeeCostY2 = 0;
            if(objAgg.get('PayeeY3') != null) objwrap.PayeeCostY3 = Integer.valueof(objAgg.get('PayeeY3'));
            else objwrap.PayeeCostY3 = 0;
            if(objAgg.get('PayeeY4') != null) objwrap.PayeeCostY4 = Integer.valueof(objAgg.get('PayeeY4'));
            else objwrap.PayeeCostY4= 0;
            objwrap.TotalPayeeCost = objwrap.PayeeCostY1 + objwrap.PayeeCostY2 + objwrap.PayeeCostY3 + objwrap.PayeeCostY4;
            
            if(TotalPayeeY1Cost == null) TotalPayeeY1Cost = objwrap.PayeeCostY1;
            else TotalPayeeY1Cost += objwrap.PayeeCostY1;
            if(TotalPayeeY2Cost == null) TotalPayeeY2Cost = objwrap.PayeeCostY2;
            else TotalPayeeY2Cost += objwrap.PayeeCostY2;
            if(TotalPayeeY3Cost == null) TotalPayeeY3Cost = objwrap.PayeeCostY3;
            else TotalPayeeY3Cost += objwrap.PayeeCostY3;
            if(TotalPayeeY4Cost == null) TotalPayeeY4Cost = objwrap.PayeeCostY4;
            else TotalPayeeY4Cost += objwrap.PayeeCostY4;
            if(AllYearPayeeTotalCost == null) AllYearPayeeTotalCost = objwrap.TotalPayeeCost;
            else AllYearPayeeTotalCost += objwrap.TotalPayeeCost;
            lstBLPayee.add(objwrap);
        }
        
        lstBLCost = new List<BLCost>();
        for(AggregateResult objAgg : lstBudgetLineCost){
            BLCost objwrap = new BLCost();
            objwrap.CostGrouping = String.valueof(objAgg.get('CostGrouping'));
            if(objAgg.get('CostY1') != null) objwrap.CostY1 = Integer.valueof(objAgg.get('CostY1'));
            else objwrap.CostY1 = 0;
            if(objAgg.get('CostY2') != null) objwrap.CostY2 = Integer.valueof(objAgg.get('CostY2'));
            else objwrap.CostY2 = 0;
            if(objAgg.get('CostY3') != null) objwrap.CostY3 = Integer.valueof(objAgg.get('CostY3'));
            else objwrap.CostY3 = 0;
            if(objAgg.get('CostY4') != null) objwrap.CostY4 = Integer.valueof(objAgg.get('CostY4'));
            else objwrap.CostY4= 0;
            objwrap.TotalCost = objwrap.CostY1 + objwrap.CostY2 + objwrap.CostY3 + objwrap.CostY4;
            
            if(TotalY1Cost == null) TotalY1Cost = objwrap.CostY1;
            else TotalY1Cost += objwrap.CostY1;
            if(TotalY2Cost == null) TotalY2Cost = objwrap.CostY2;
            else TotalY2Cost += objwrap.CostY2;
            if(TotalY3Cost == null) TotalY3Cost = objwrap.CostY3;
            else TotalY3Cost += objwrap.CostY3;
            if(TotalY4Cost == null) TotalY4Cost = objwrap.CostY4;
            else TotalY4Cost += objwrap.CostY4;
            if(AllYearTotalCost == null) AllYearTotalCost = objwrap.TotalCost;
            else AllYearTotalCost += objwrap.TotalCost;
            lstBLCost.add(objwrap);
        }
         List<Guidance__c> lstGuidance = [Select Id from Guidance__c where Name = :label.Grant_Making_Overview];
            if(!lstGuidance.isEmpty()) 
            {
              strGuidanceId = lstGuidance[0].Id;
            }
            strLanguage = 'ENGLISH';
        if(System.UserInfo.getLanguage() == 'fr'){
            strLanguage = 'FRENCH'; }
        if(System.UserInfo.getLanguage() == 'ru'){
            strLanguage = 'RUSSIAN'; }
        if(System.UserInfo.getLanguage() == 'es'){
            strLanguage = 'SPANISH'; }
      
       
        
      
    /*  lstProfileSetting = [Select id,Name,Profile_Id__c,Page_Name__c,Salesforce_Item__c,Profile_Name__c from Profile_Access_Setting__c where Page_Name__c='grantmakingoverview' AND Profile_Name__c=:profileName];
      system.debug('**profile access'+lstProfileSetting); 
     
      
       myset = new set<string>();
       
        for(Profile_Access_Setting__c m :lstProfileSetting){ 
        
        if(m.Salesforce_Item__c == 'Grant information Btn'){
        blnProfileCheck = true;
        }
        
        //myset.add(m.Profile_Name__c); 
        }
        system.debug('**blnProfileCheck'+blnProfileCheck); */
        checkProfile(); //TCS 31/7/2014 Calling to check Profile
        
    }
    
   Public PageReference saveIP(){
   /*recordIP.Rationale_for_Program__c = strRationale;
   recordIP.Goals_and_Strategies_for_program__c = strGoalsAndStrategies;
   recordIP.Target_beneficiaries_of_program__c = strBeneficiaries;
        update (recordIP);*/
        //ip_sc.Save();
        update (recordIP);        
        PageReference pageRef = new PageReference('/apex/grantmakingoverview?Id=' + strGIPId );
        pageRef.setRedirect(true);
        return pageRef;

   }
    Public PageReference cancelIP(){
   
   /*system.debug(recordIP.Rationale_for_Program__c+'strRationale =recordIP.Rationale_for_Program__c;'+strRationale );     
   strRationale =recordIP.Rationale_for_Program__c;
   strGoalsAndStrategies =recordIP.Goals_and_Strategies_for_program__c;
   strBeneficiaries =recordIP.Target_beneficiaries_of_program__c;*/ 
     //ip_sc.Cancel();
        PageReference pageRef = new PageReference('/apex/grantmakingoverview?Id=' + strGIPId );
        pageRef.setRedirect(true);
        return pageRef;
   
   }
    /*Public void SubmitToReview(){
        Integer ReviewIndex = integer.valueof(Apexpages.currentpage().getparameters().get('ReviewIndex'));
        if(ReviewIndex != null){
            for(integer i=0;i<lstPages.size();i++){
                if(i == ReviewIndex){
                    lstPages[i].Status__c = 'Global Fund Review';
                }
            }
            update lstPages;
            
            lstPages = new List<Page__c>();   
            lstPages = [Select Id,Name,French_Name__c, Russian_Name__c, Spanish_Name__c,URL_Prefix__c,Order__c,Modular__c,Status__c,PR_Comments__c,LFA_Comments__c,CT_Comments__c,Latest_PR_Comment__c,Latest_LFA_Comment__c,Latest_CT_Comment__c From Page__c Where Implementation_Period__c =: strGIPID Order by Order__c]; 
            CheckBoolean();
            
        }
    }
    
    Public void SubmitToGrant(){
        if(lstPages != null && lstPages.size() > 0){
            for(Page__c objPage : lstPages){
                if(objPage.Status__c == 'Draft'){
                    objPage.Status__c = 'TGF Review';
                }
            }
            update lstPages;
            lstPages = new List<Page__c>();   
            lstPages = [Select Id,Name,French_Name__c, Russian_Name__c, Spanish_Name__c,URL_Prefix__c,Order__c,Modular__c,Status__c,PR_Comments__c,LFA_Comments__c,CT_Comments__c,Latest_PR_Comment__c,Latest_LFA_Comment__c,Latest_CT_Comment__c From Page__c Where Implementation_Period__c =: strGIPID Order by Order__c]; 
            CheckBoolean();
        }
    }*/
    
    Public void CheckBoolean(){
        if(lstPages != null && lstPages.size() > 0){
            blnDraftStatusExist = false;
            for(Page__c objPage : lstPages){
                if(objPage.Status__c == 'Draft'){
                    blnDraftStatusExist = true;
                    break;
                }
            }
        }
    }
   Public void SavePage(){
        Integer SavePageIndex = integer.valueof(Apexpages.currentpage().getparameters().get('SavePageIndex'));
        if(SavePageIndex != null){
        /*lstPages[SavePageIndex].PR_Comments__c = strPRComments[SavePageIndex];
        lstPages[SavePageIndex].LFA_Comments__c = strLFAComments[SavePageIndex] ;
        lstPages[SavePageIndex].CT_Comments__c = strCTComments[SavePageIndex];*/
            update lstPages;
            //lstPages = new List<Page__c>();   
            //lstPages = [Select Id,Name,URL_Prefix__c,Order__c,Modular__c,Status__c,PR_Comments__c,LFA_Comments__c,CT_Comments__c,Latest_PR_Comment__c,Latest_LFA_Comment__c,Latest_CT_Comment__c From Page__c Where Implementation_Period__c =: strGIPID Order by Order__c]; 
           // blnHasNoChild = false;
        }
    }
    Public void CancelPage(){
        Integer CancelPageIndex = integer.valueof(Apexpages.currentpage().getparameters().get('CancelPageIndex'));
        if(CancelPageIndex != null){
        /*strPRComments[CancelPageIndex]  =lstPages[CancelPageIndex].PR_Comments__c;
        strLFAComments[CancelPageIndex]  =lstPages[CancelPageIndex].LFA_Comments__c;
        strCTComments[CancelPageIndex] =lstPages[CancelPageIndex].CT_Comments__c;*/
        
        
        lstPagesOnCancel = new List<Page__c>();   
        lstPagesOnCancel = [Select PR_Comments__c,LFA_Comments__c,CT_Comments__c From Page__c Where Implementation_Period__c =: strGIPID Order by Order__c]; 
        if(lstPagesOnCancel.size()>0){
        lstPages[CancelPageIndex].PR_Comments__c=lstPagesOnCancel[CancelPageIndex].PR_Comments__c;
        lstPages[CancelPageIndex].LFA_Comments__c=lstPagesOnCancel[CancelPageIndex].LFA_Comments__c;
        lstPages[CancelPageIndex].CT_Comments__c=lstPagesOnCancel[CancelPageIndex].CT_Comments__c;}
        }
       
    }
    @RemoteAction   
    global static BLModule[] loadDataModule() { 
        List<AggregateResult> lstBudgetLineModule = [Select Grant_Intervention__r.Module__r.Name Modulename,Sum(Y1_Grant_Amount__c) ModuleY1,Sum(Y2_Grant_Amount__c) ModuleY2,Sum(Y3_Grant_Amount__c) ModuleY3,Sum(Y4_Grant_Amount__c) ModuleY4 From Budget_Line__c Group By Grant_Intervention__r.Module__r.Name ];
        List<BLModule> lstBLModule = new List<BLModule>();
        for(AggregateResult objAgg : lstBudgetLineModule){
            BLModule objwrap = new BLModule();
            objwrap.ModuleName = String.valueof(objAgg.get('Modulename'));
            if(objAgg.get('ModuleY1') != null) objwrap.ModuleCostY1 = Integer.valueof(objAgg.get('ModuleY1'));
            else objwrap.ModuleCostY1 = 0;
            if(objAgg.get('ModuleY2') != null) objwrap.ModuleCostY2 = Integer.valueof(objAgg.get('ModuleY2'));
            else objwrap.ModuleCostY2 = 0;
            if(objAgg.get('ModuleY3') != null) objwrap.ModuleCostY3 = Integer.valueof(objAgg.get('ModuleY3'));
            else objwrap.ModuleCostY3 = 0;
            if(objAgg.get('ModuleY4') != null) objwrap.ModuleCostY4 = Integer.valueof(objAgg.get('ModuleY4'));
            else objwrap.ModuleCostY4= 0;
            objwrap.TotalModuleCost = objwrap.ModuleCostY1 + objwrap.ModuleCostY2 + objwrap.ModuleCostY3 + objwrap.ModuleCostY4;
            lstBLModule.add(objwrap);
        }
        return lstBLModule;
    }
    
    @RemoteAction   
    global static BLCost[] loadDataCost() { 
        List<AggregateResult> lstBudgetLineCost = [Select Cost_Input__r.Cost_Grouping__c CostGrouping,Sum(Y1_Grant_Amount__c) CostY1,Sum(Y2_Grant_Amount__c) CostY2,Sum(Y3_Grant_Amount__c) CostY3,Sum(Y4_Grant_Amount__c) CostY4 From Budget_Line__c Where Cost_Input__r.Cost_Grouping__c != null Group By Cost_Input__r.Cost_Grouping__c ];
        List<BLCost> lstBLCost = new List<BLCost>();
        for(AggregateResult objAgg : lstBudgetLineCost){
            BLCost objwrap = new BLCost();
            objwrap.CostGrouping = String.valueof(objAgg.get('CostGrouping'));
            if(objAgg.get('CostY1') != null) objwrap.CostY1 = Integer.valueof(objAgg.get('CostY1'));
            else objwrap.CostY1 = 0;
            if(objAgg.get('CostY2') != null) objwrap.CostY2 = Integer.valueof(objAgg.get('CostY2'));
            else objwrap.CostY2 = 0;
            if(objAgg.get('CostY3') != null) objwrap.CostY3 = Integer.valueof(objAgg.get('CostY3'));
            else objwrap.CostY3 = 0;
            if(objAgg.get('CostY4') != null) objwrap.CostY4 = Integer.valueof(objAgg.get('CostY4'));
            else objwrap.CostY4= 0;
            objwrap.TotalCost = objwrap.CostY1 + objwrap.CostY2 + objwrap.CostY3 + objwrap.CostY4;
            lstBLCost.add(objwrap);
        }
        return lstBLCost;
    }
    
    @RemoteAction   
    global static BLPayee[] loadDataPayee() { 
        List<AggregateResult> lstBudgetLinePayee = [Select Payee__c PayeeId,Sum(Y1_Grant_Amount__c) PayeeY1,Sum(Y2_Grant_Amount__c) PayeeY2,Sum(Y3_Grant_Amount__c) PayeeY3,Sum(Y4_Grant_Amount__c) PayeeY4 From Budget_Line__c where Payee__c != null Group By Payee__c ];
        Set<Id> setPayeeIds = new Set<Id>();
        for(AggregateResult objAgg : lstBudgetLinePayee){
            setPayeeIds.add((Id)objAgg.get('PayeeId'));
        }
        Map<Id,Implementer__c> mapImplementer = new Map<Id,Implementer__c>([Select Id,Implementer_Name__c From Implementer__c Where Id IN : setPayeeIds]);
        List<BLPayee> lstBLPayee = new List<BLPayee>();
        for(AggregateResult objAgg : lstBudgetLinePayee){
            BLPayee objwrap = new BLPayee();
            objwrap.PayeeName = mapImplementer.get((ID)objAgg.get('PayeeId')).Implementer_Name__c;
            if(objAgg.get('PayeeY1') != null) objwrap.PayeeCostY1 = Integer.valueof(objAgg.get('PayeeY1'));
            else objwrap.PayeeCostY1 = 0;
            if(objAgg.get('PayeeY2') != null) objwrap.PayeeCostY2 = Integer.valueof(objAgg.get('PayeeY2'));
            else objwrap.PayeeCostY2 = 0;
            if(objAgg.get('PayeeY3') != null) objwrap.PayeeCostY3 = Integer.valueof(objAgg.get('PayeeY3'));
            else objwrap.PayeeCostY3 = 0;
            if(objAgg.get('PayeeY4') != null) objwrap.PayeeCostY4 = Integer.valueof(objAgg.get('PayeeY4'));
            else objwrap.PayeeCostY4= 0;
            objwrap.TotalPayeeCost = objwrap.PayeeCostY1 + objwrap.PayeeCostY2 + objwrap.PayeeCostY3 + objwrap.PayeeCostY4;
            lstBLPayee.add(objwrap);
        }
        return lstBLPayee;
    } 
    
    Public void SaveChanges(){
        update lstRP;
    }
    
    //TCS 31/7/2014 Created for Profile Access 
    public void checkProfile(){
        Id profileId=userinfo.getProfileId();
         profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        List<Profile_Access_Setting__c> checkpage = [Select Salesforce_Item__c, Status__c from Profile_Access_Setting__c where Page_Name__c ='GrantMakingOverview' and Profile_Name__c =: profilename];
        system.debug(checkpage);
        for (Profile_Access_Setting__c check : checkpage){
            if (check.Salesforce_Item__c == 'External Profile') blnExternalPro = true;
            if(check.Salesforce_Item__c == 'Edit Grant Information')blnGrantInfo = true;
            if(check.Salesforce_Item__c == 'Submit Grant')blnSubmitGrant = true;
            if(check.Salesforce_Item__c == 'Dialogue')blnDialog = true;
            if(check.Salesforce_Item__c == 'Submit Grant')blnSubmitGrant = true;
            if(check.Salesforce_Item__c == 'Edit Program Title')blnPrgTitle = true;
            if(check.Salesforce_Item__c == 'View Chart')blnViewChart = true;
            if(check.Salesforce_Item__c == 'Submit Budget to Country Team' && check.Status__c == strBudgetStatus) blnSubmitBudgetToCT = true;
            if(check.Salesforce_Item__c == 'Submit Budget to LFA' && check.Status__c == strBudgetStatus) blnSubmitBudgetToLFA = true;
            if(check.Salesforce_Item__c == 'LFA Submit Budget to CT' && check.Status__c == strBudgetStatus) blnLFASubmitBudgetToCT = true;
            if(check.Salesforce_Item__c == 'CT shared reviewed budget with PR' && check.Status__c == strBudgetStatus) blnShareBudgetwithPR = true;
            if(check.Salesforce_Item__c == 'PR submitted final budget' && check.Status__c == strBudgetStatus) blnSubmitFinalBudget = true;
            if(check.Salesforce_Item__c == 'CT agrees with final budget' && check.Status__c == strBudgetStatus) blnAgreeFinalBudget = true;
        }
        
    }
    
    global Class BLModule{
        Public Integer ModuleCostY1 {get;set;}
        Public Integer ModuleCostY2 {get;set;}
        Public Integer ModuleCostY3 {get;set;}
        Public Integer ModuleCostY4 {get;set;}
        Public Integer TotalModuleCost {get;set;}
        Public String ModuleName {get;set;}
        Public String InterventionName {get;set;}
        Public Boolean blnbckgrnd {get; set;}
    }
    global Class BLCost{
        Public Integer CostY1 {get;set;}
        Public Integer CostY2 {get;set;}
        Public Integer CostY3 {get;set;}
        Public Integer CostY4 {get;set;}
        Public Integer TotalCost {get;set;}
        Public String CostGrouping {get;set;}
    }
    global Class BLPayee{
        Public Integer PayeeCostY1 {get;set;}
        Public Integer PayeeCostY2 {get;set;}
        Public Integer PayeeCostY3 {get;set;}
        Public Integer PayeeCostY4 {get;set;}
        Public Integer TotalPayeeCost {get;set;}
        Public String PayeeName {get;set;}
    }
    public pageReference saveText(){
    update(recordIP);
    return null;   
    }
    public pageReference doEdit(){
    return ip_sc.Edit();
    }
    public pageReference SubmitDetailBudget(){
    	system.debug('List of Detail Records'+lstIPDetails);
    	if(strBudgetStatus == 'Not yet submitted by PR') lstIPDetails[0].Budget_Status__c = 'Submitted to the Global Fund';
    	lstIPDetails[0].Detail_Budget_Last_Submitted_By__c = UserInfo.getUserId();
    	update lstIPDetails;
    	strBudgetStatus = lstIPDetails[0].Budget_Status__c;
    	 PageReference pageRef = new PageReference('/apex/grantmakingoverview?Id=' + strGIPId );
        pageRef.setRedirect(true);
        return pageRef;
    }
}