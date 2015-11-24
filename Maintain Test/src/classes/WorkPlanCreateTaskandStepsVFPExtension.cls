//****************************************************************************************

// Purpose     :  This Class is meant for creating Task and related Step records when user clicks on Add Grant Workplan     
//                Button on Home Page.
// Date        :  01-Dec-2014
// Created By  :  TCS 
// Author      :  Gaurav Guleria
// Description :  This Class is meant for creating Task and related Step records.This Class is related with 
//                WorkPlanCreateTaskandStepsVFP Page.
// Revision:   :  
public with sharing class WorkPlanCreateTaskandStepsVFPExtension {

    public Implementation_Period__c  implementationPeriodObj{get;set;}
    public List<Country__c> allCountryList {get;set;}
    public List<Country__c> countryList {get;set;}
    public string countryId{get;set;}    
    public string diseaseComponentVal{get;set;}
    public String statusVal{get;set;}
    public string implementationPeriodId{get;set;}
    public List<Implementation_Period__c> ImplementationPeriodList{get;set;}
    public List<SelectOption> grantSelectOptions{get;set;}
    public String pleaseSelectMsg{get;set;}
    public Boolean showpleaseSelectMsg{get;set;}
    public String ImplementationPeriodQuery{get;set;}
    public String duplicateWorkplanMsg{get;set;}
    public Boolean showduplicateWorkplanMsg{get;set;}
    public Id loggedinUserId{get;set;}
    public List<GroupMember> groupMemberRec{get;set;}
    public List<Id> countryIds{get;set;}
    //public Id publicGroupId{get;set;}
    public WorkPlanCreateTaskandStepsVFPExtension(ApexPages.StandardController controller) {
        
        ImplementationPeriodQuery = '';
        
        //Fetch only those countries which belong to public groups the logged-in User has a user has membership
        countryIds = new List<Id>();
        groupMemberRec = new List<GroupMember>();
        loggedinUserId = UserInfo.getUserId();
        allCountryList= new List<Country__c>([SELECT id,CT_Public_Group_ID__c,Name FROM Country__c ORDER BY Name]);
        countryList =   new List<Country__c>();                             
        groupMemberRec = [SELECT GroupId FROM GroupMember WHERE UserOrGroupId=:loggedinUserId];
        System.debug('@@loggedinUserId '+loggedinUserId );
        for(Country__c cont:allCountryList){
            for(GroupMember gm:groupMemberRec){
                if(gm.GroupId==cont.CT_Public_Group_ID__c){
                    countryList.add(cont); 
                    countryIds.add(cont.Id);
                }
            }
        }        
        //countryList = new List<Country__c>([SELECT id,Name FROM Country__c ORDER BY Name]);
        grantSelectOptions = new List<SelectOption>() ;
        grantSelectOptions.add(new SelectOption('---Select Grant---','---Select Grant---'));
        /*List<Implementation_Period__c> ImplementationPeriodList = new List<Implementation_Period__c>(); 
        ImplementationPeriodList = [SELECT id,Name FROM Implementation_Period__c ORDER BY Name ];
        for(Implementation_Period__c ip:ImplementationPeriodList){
            grantSelectOptions.add(new SelectOption(ip.Id,ip.Name));  
        }*/ 
    }
    
    public PageReference createWorkPlan(){
        if( statusVal=='---Select Status---' || implementationPeriodId=='---Select Grant---'){
            showpleaseSelectMsg=TRUE;
            showduplicateWorkplanMsg = FALSE;
            pleaseSelectMsg = 'Please select a Grant and a Status. If no Grant is available select different criteria.';
            return null; 
        }
        else{            
            //Task List to insert
            List<Task__c> taskList = new List<Task__c>();
            //Task List already present in the System for the Implementation Period Selected
            List<Task__c> taskListAvailable = new List<Task__c>();
            PageReference pageRef = new PageReference('/00Og0000000SxOx');
            List<Task_Lookup__c> taskLookUpList = new List<Task_Lookup__c>();
            List<Milestone_Lookup__c> stepLookUpList = new List<Milestone_Lookup__c>();
            Set<String> mileLookUpPredecessorNameSet = new Set<String>();
            Set<String> taskNameSet = new Set<String>();
            Set<Id> taskIdSet = new Set<Id>();
            List<Step__c> predecessorList = new List<Step__c>(); 
            List<Step__c> stepRecordsList = new List<Step__c>(); 
            taskLookUpList = [SELECT Grant_Cycle__c,Task_Type__c, Due_Date_Guidance__c 
                              FROM Task_Lookup__c WHERE Grant_Cycle__c=:statusVal];
            //Map with Task Id as KEY and Task Record(Task__c) as VALUE
            Map<Id,Task__c> taskId_TaskRecordMap = new Map<Id,Task__c>();
            taskListAvailable = [SELECT id FROM Task__c WHERE Grant_Name__c=:implementationPeriodId AND Grant_Name__r.Status__c =:statusVal];
            if(taskListAvailable.SIZE()>0){
            
                duplicateWorkplanMsg= 'Workplan already exists for the selected Grant and Grant status.Please select another status or Grant.';
                showpleaseSelectMsg = FALSE;
                showduplicateWorkplanMsg = TRUE;
                return null; 
            }
            else{
                if(taskLookUpList.SIZE()>0){
                    for(Task_Lookup__c tskLook : taskLookUpList){
                        system.Debug('@@In taskLookUpList Loop' );
                        //create TASK
                        Task__c taskrec = new Task__c();
                        taskrec.Name = tskLook.Task_Type__c;
                        if(statusVal=='Concept Note'){
                            RecordType rt = [select id FROM RecordType WHERE Name='Concept Note' AND SobjectType='Task__c'];
                            taskrec.RecordTypeId= rt.Id;
                        }
                        else if(statusVal=='Grant-Making'){
                            RecordType rt = [select id FROM RecordType WHERE Name='Grant Making' AND SobjectType='Task__c'];
                            taskrec.RecordTypeId= rt.Id;
                        }
                        else if(statusVal=='Grant Implementation'){
                            RecordType rt = [select id FROM RecordType WHERE Name='Grant Implementation' AND SobjectType='Task__c'];
                            taskrec.RecordTypeId= rt.Id;
                        }
                        taskrec.Grant_Name__c  =    implementationPeriodId;
                        system.debug('@@implementationPeriodId'+implementationPeriodId);
                        taskrec.Task_Name__c = tskLook.Task_Type__c;
                        taskrec.Due_Date_Guidance__c = tskLook.Due_Date_Guidance__c;
                        taskNameSet.add(taskrec.Name);
                        taskList.add(taskrec);
                    }
                    
                    insert taskList ;
                    
                    //Update Predecessor of Step if both(Predecessor and Step) are inserted simultaneously
                    for(Task__c tsk :taskList){
                        taskIdSet.add(tsk.Id);
                        taskId_TaskRecordMap.put(tsk.Id,tsk);
                    }
                    stepLookUpList = [SELECT Duration__c,Milestone__c,Predecessor__c,Task_Name__c,Calculate_Business_Days__c 
                                    FROM Milestone_Lookup__c WHERE Task_Name__c IN:taskNameSet]; 
                    for(Milestone_Lookup__c milook :stepLookUpList){
                        mileLookUpPredecessorNameSet.Add(milook.Predecessor__c); //add predecessor from custom setting
                    
                    }
                    predecessorList = [SELECT id,Name,Task_Name__r.Task_Name__c,Task_Name__r.Grant_Name__c,Task_Name__c, Original_Due_Date__c,Original_Duration__c 
                                        FROM Step__c WHERE Name IN:mileLookUpPredecessorNameSet];
                    stepRecordsList = [SELECT id,Name,Original_Predecessors__r.Name,Task_Name__c
                                        FROM Step__c WHERE Task_Name__c IN:taskIdSet];  
                    for(Step__c milst :stepRecordsList){
                        for(Milestone_Lookup__c milook:stepLookUpList){             
                            for(Step__c predess : predecessorList){
                                Task__c tsk = new Task__c();
                                tsk = taskId_TaskRecordMap.get(milst.Task_Name__c);
                                if(milst.Name == milook.Milestone__c && tsk.Task_Name__c== milook.Task_Name__c &&
                                      tsk.Grant_Name__c == predess.Task_Name__r.Grant_Name__c && predess.name == milook.Predecessor__c){
                                    //Populate Predecessor in Milestone
                                    milst.Original_Predecessors__c = predess.Id; 
                                    //Pick Duration from related Step Custom Setting
                                    milst.Original_Duration__c = milook.Duration__c;
                                }
                            }
                        }
                    }
                    update stepRecordsList;
                }
                showduplicateWorkplanMsg = FALSE;
                showpleaseSelectMsg = FALSE;
            }
            return pageRef;
        }
    }
    //get all Country records names
    public List<SelectOption> getCountries() {
        List<SelectOption> countryOptions = new List<SelectOption>();
        countryOptions.add(new SelectOption('---Select Country---','---Select Country---'));
        for(Country__c cont: countryList ){
            countryOptions.add(new SelectOption(cont.Id,cont.Name));
        }
        return countryOptions;
    }
    //get Disease Component(Disease_Component__c) Picklist values from Grant(Grant__c) object
    public List<SelectOption> getdiseaseComponent() {
        List<SelectOption> componentOptions = new List<SelectOption>();
        componentOptions.add(new SelectOption('---Select Component---','---Select Component---'));
        Schema.DescribeFieldResult fieldResult = Grant__c.Disease_Component__c.getDescribe();
        List<Schema.PicklistEntry> plentry = fieldResult.getPicklistValues(); 
        for(Schema.PicklistEntry f: plentry){
            componentOptions.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        return componentOptions;
    }
    //Get Status(Status__c) Picklist Values from Implementation Period(Implementation_Period__c) object
    public List<SelectOption> getgrantStatus() {
        List<SelectOption> statusOptions = new List<SelectOption>();
        statusOptions.add(new SelectOption('---Select Status---','---Select Status---'));
        Schema.DescribeFieldResult fieldResult = Implementation_Period__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> plentry = fieldResult.getPicklistValues(); 
        for(Schema.PicklistEntry f: plentry){
            statusOptions .add(new SelectOption(f.getLabel(), f.getValue()));
        }
        return statusOptions ;
    }
    
    public void refreshGrantList(){
        grantSelectOptions.clear();
        showpleaseSelectMsg=FALSE;
        grantSelectOptions.add(new SelectOption('---Select Grant---','---Select Grant---'));
        if(countryId == '---Select Country---' || diseaseComponentVal == '---Select Component---'){
            ImplementationPeriodQuery = 'SELECT id,Name FROM Implementation_Period__c WHERE Status__c=:statusVal';
                                        
        }
        if(countryId<> '---Select Country---' || diseaseComponentVal=='---Select Component---' && statusVal<>'---Select Status---'){
            ImplementationPeriodQuery = 'SELECT id,Name FROM Implementation_Period__c WHERE Grant__r.Country__c=:countryId AND Status__c=:statusVal';
        
        }
        if(countryId<> '---Select Country---' || diseaseComponentVal<>'---Select Component---' && statusVal<>'---Select Status---'){
            ImplementationPeriodQuery = 'SELECT id,Name FROM Implementation_Period__c WHERE Grant__r.Country__c=:countryId AND Grant__r.Disease_Component__c=:diseaseComponentVal AND Status__c=:statusVal';
        
        }
        ImplementationPeriodList = Database.Query(ImplementationPeriodQuery);
        for(Implementation_Period__c ip:ImplementationPeriodList){
            grantSelectOptions.add(new SelectOption(ip.Id,ip.Name));  
        }
    }
    
}