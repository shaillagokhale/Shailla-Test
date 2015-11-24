@istest
public class TestClassHelper{

//static Country__c objCountry;
//static User objUser = [Select ID, country from User where id=:userinfo.getUserId()];
//Static Account objAcc;
public static Country__c insertCountry(){
        User objUser = [Select ID, country from User where id=:userinfo.getUserId()];
        Country__c objCountry = new Country__c();
        objCountry.Name = 'Testcountry';
        objCountry.French_Name__c = 'TestFrench';
        objCountry.Russian_Name__c = 'TestRussian';
        objCountry.Spanish_Name__c = 'TestSpanish';
        
        objCountry.FPM__c = objUser.id;
        objCountry.Country_Fiscal_Cycle_Start_Date__c = Date.today();
        objCountry.Country_Fiscal_Cycle_End_Date__c = Date.today()+12;
        insert objCountry;
        return objCountry;
} 
public static Country__c createCountry(){
        User objUser = [Select ID, country from User where id=:userinfo.getUserId()];
        Country__c objCountry = new Country__c();
        objCountry.Name = 'Testcountry';
        objCountry.French_Name__c = 'TestFrench';
        objCountry.Russian_Name__c = 'TestRussian';
        objCountry.Spanish_Name__c = 'TestSpanish';
        
        objCountry.FPM__c = objUser.id;
        objCountry.Country_Fiscal_Cycle_Start_Date__c = Date.today();
        objCountry.Country_Fiscal_Cycle_End_Date__c = Date.today()+12;
        
        return objCountry;
} 

public static Profile_Access_Setting__c createProfileSetting(){
        Profile_Access_Setting__c objProfCust = new Profile_Access_Setting__c();
        objProfCust.Name = 'Record 1';
        objProfCust.Profile_Name__c = 'System Administrator';
        return objProfCust;
}
public static Account insertAccount(){
        Country__c objCountry = TestClassHelper.insertCountry();
        Account objAcc = new Account();
        objAcc.Name = 'Test Acc';
        objAcc.Short_Name__c = 'MOH';
        objAcc.Country__c = objCountry.Id ;
        insert objAcc;        
        return objAcc;
}
public static Bank__c createBank(){
        Country__c objCountry = TestClassHelper.insertCountry();
        Bank__c bank = new Bank__c();
        bank.Country__c = objCountry.Id ;
        return bank;
}
public static Bank_Account__c createBankAcc(){
        Bank_Account__c bankAcc = new Bank_Account__c();
        return bankAcc;

}
public static Account createAccount(){
        //Country__c objCountry = TestClassHelper.insertCountry();
        Account objAcc = new Account();
        objAcc.Name = 'Test Acc';
        objAcc.Short_Name__c = 'MOH';
        //objAcc.Country__c = objCountry.Id ;          
        return objAcc;
}
public static Attachment createAttach(){
        
        Attachment attach=new Attachment();     
        attach.Name = 'Unit Test Attachment';
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        attach.body = bodyBlob;
        
        
        return attach;
}
public static Template__c insertTemp(){        
        Template__c objTemplate = new Template__c(Name = 'Test Template');
        insert objTemplate;
        return objTemplate;
        }
public static Concept_Note__c createCN(){          
        Template__c objTemplate =  TestClassHelper.insertTemp(); 
        Program_Split__c objPrgmSplit = TestClassHelper.insertProgramSplit();    
        Concept_Note__c objCN = new Concept_Note__c();        
        objCN.Name = 'Test CN';
        objCN.Component__c = 'Malaria';
        objCN.Language__c = 'ENGLISH';        
        objCN.Number_of_Years__c = '3';
        objCN.Page_Template__c = objTemplate.Id;   
        objCN.Program_Split__c = objPrgmSplit.Id;     
        return objCN;
        }
public static Grant__c createGrant(Account objAcc){        
        Grant__c objGrant = new Grant__c();
        objGrant.Disease_Component__c =  'Malaria';
        objGrant.Name = 'Test';
        objGrant.Principal_Recipient__c = objAcc.id;               
        return objGrant;
}
public static Module__c createModule(){
        Module__c ObjModule = new Module__c();
        ObjModule.Name = 'Test';
        ObjModule.CurrencyIsoCode = 'EUR';        
        return ObjModule;
}
public static Period__c insertPeriod(){
        Period__c ObjRP = new Period__c();
        ObjRP.Country__c = 'Test';
        insert ObjRP;
        return ObjRP;

}
public static Period__c createPeriod(){
        Period__c ObjRP = new Period__c();
        ObjRP.Country__c = 'Test';
        return ObjRP;

}
public static Implementer__c insertImplementor(){
        Implementer__c ObjImplementer = new Implementer__c();
        ObjImplementer.Implementer_Name__c = 'Test';       
        insert ObjImplementer;
        return ObjImplementer;
}

public static Implementer__c createImplementor(){
        Implementer__c ObjImplementer = new Implementer__c();
        ObjImplementer.Implementer_Name__c = 'Test';       
        return ObjImplementer;
}
public static Implementation_Period__c createIP(Grant__c objGrant,Account objAcc){
        //Grant__c objGrant = TestClassHelper.insertGrant();
        //Account objAcc = TestClassHelper.insertAcc();
        Implementation_Period__c objIP = new Implementation_Period__c();
        objIP.Name = 'NGA-M-UNDP';
        objIP.Principal_Recipient__c = objAcc.Id;
        //objIP.Principal_Recipient__c = '001g000000A8HKj';
        objIP.Grant__c = objGrant.Id;
        objIP.Start_Date__c =Date.today();
        //objIP.End_Date__c =Date.today().addYears(3);
        objIP.Length_Years__c ='3';        
        return objIP;
}
public static Page__c createPage(){
        //Implementation_Period__c objIP = TestClassHelper.insertIP();
        Page__c objPage = new Page__c();
        Objpage.Name = 'Test';
        Objpage.Status__c= 'Draft';
        //ObjPage.Implementation_Period__c = objIP.Id;        
        return objPage;
}
public static Catalog_Module__c createCatalogModule(){
        Catalog_Module__c objCM = new Catalog_Module__c();
        objCM.Name = 'Test CM';
        return objCM;
}
public static Grant_Intervention__c createGrantIntervention(Implementation_Period__c objIP){
        //Implementation_Period__c objIP = TestClassHelper.insertIP();
        Grant_Intervention__c ObjGrantIntervention = new Grant_Intervention__c ();
        ObjGrantIntervention.Implementation_Period__c = objIP.id;        
        return ObjGrantIntervention;
}
public static Catalog_Cost_Input__c insertCostInput(){
        Catalog_Cost_Input__c ObjCatalogCostInput = new Catalog_Cost_Input__c();
        ObjCatalogCostInput.Name = '8.2 Renovation/constructions';
        ObjCatalogCostInput.GIS_ID__c = 46;
        ObjCatalogCostInput.CurrencyIsoCode = 'EUR'; 
        ObjCatalogCostInput.PSM__c = FALSE;
        ObjCatalogCostInput.Cost_Grouping__c = '1. Human Resources (HR)';
        insert ObjCatalogCostInput;
        return ObjCatalogCostInput;
}

public static Catalog_Cost_Input__c createCostInput(){
        Catalog_Cost_Input__c ObjCatalogCostInput = new Catalog_Cost_Input__c();
        ObjCatalogCostInput.Name = '8.2 Renovation/constructions';
        ObjCatalogCostInput.GIS_ID__c = 46;
        ObjCatalogCostInput.CurrencyIsoCode = 'EUR'; 
        //ObjCatalogCostInput.Cost_Grouping__c = '1. Human Resources (HR)';
        
        return ObjCatalogCostInput;
}
public static Budget_Line__c createBudgetLine(){
        //Catalog_Cost_Input__c ObjCatalogCostInput = TestClassHelper.insertCostInput();
        //Grant_Intervention__c ObjGrantIntervention = TestClassHelper.insertGrantIntervention();
        //Implementer__c ObjImplementer = TestClassHelper.insertImplementor();
        Budget_Line__c ObjBudgetLine = new  Budget_Line__c();
        ObjBudgetLine.CurrencyIsoCode = 'EUR';                   
        return ObjBudgetLine;
}
public static Catalog_Intervention__c createCatalogIntervention(){
        Catalog_Intervention__c objCI = new Catalog_Intervention__c();
        objCI.Name = 'Test CI';
        return objCI; 
}
public static Goals_Objectives__c createGoalsObjectives() {
        Goals_Objectives__c objGoal = new Goals_Objectives__c();
        objGoal.Goal__c = 'Test Goal';        
        objGoal.Type__c = 'Goal';
        objGoal.Number__c = 1;        
        return objGoal;
}

public static Grant_Indicator__c createGrantIndicator(){        
        Grant_Indicator__c objIndicator = new Grant_Indicator__c();
        objIndicator.Indicator_Full_Name__c = 'Test Indicator';
        objIndicator.Data_Type__c = 'Percent';
        return objIndicator;
}        
public static Ind_Goal_Jxn__c insertIndicatorGoalJxn(Goals_Objectives__c objGoal,Grant_Indicator__c objIndicator) { 
        Ind_Goal_Jxn__c objJun = new Ind_Goal_Jxn__c();
        objJun.Goal_Objective__c = objGoal.Id;
        objJun.Indicator__c = objIndicator.Id;
        insert objJun;
        return objJun;
}

public static Indicator__c createCatalogIndicator(){
        Indicator__c objCatIndicator = new Indicator__c();
        objCatIndicator.Programme_Area__c = 'Malaria';
        objCatIndicator.Indicator_Type__c = 'Impact';
        objCatIndicator.Type_of_Data__c = 'Percent';
        objCatIndicator.Full_Name_En__c = 'Test Cat Indicator';
        return objCatIndicator;
}
public static Project_multi_lingual__c createProjMultiLanguage() {
        Project_multi_lingual__c objPs = new Project_multi_lingual__c();
        objPs.English_Text__c = 'Concept Notes';
        objPs.French_Text__c = 'Les notes succinctes';
        objPs.Spanish_Text__c = 'documentos de síntesis';
        objPs.Group_Name__c = 'GoalsAndImpactIndicators';
        objPs.Key__c = 'GIConceptNotes';
        return objPs;
}
public static Program_Split__c insertProgramSplit(){
        Program_Split__c objPrgmSplit = new Program_Split__c();
        Account objAcc = TestClassHelper.insertAccount();
        objPrgmSplit.CCM__c = objAcc.Id;
        insert objPrgmSplit;
        return objPrgmSplit;    
}
public static Profile_Access_Setting_CN__c createProfileSettingCN(){        
        Profile_Access_Setting_CN__c checkProfile = new Profile_Access_Setting_CN__c();
        checkProfile.Name = 'Record 1';
        checkProfile.Profile_Name__c = 'System Administrator';
        return checkProfile;
}
  public static Step__c createMileStone(Id User_Id ,Id MileStone_Id,Id Task_Id)
    {
        Step__c mileStoneRecord                = new Step__c(); 
        mileStoneRecord.Name                        = 'Test MileStone';
        //mileStoneRecord.Assigned_To__c              = User_Id;        
        mileStoneRecord.Original_Predecessors__c     = MileStone_Id;
        mileStoneRecord.Task_Name__c                     = Task_Id;
        mileStoneRecord.Original_Duration__c                = 60;
       //mileStoneRecord.Actual_Start_Date__c         = Date.Today()-50;
        mileStoneRecord.Actual_Completion_Date__c   = Date.Today()+50 ;
        //mileStoneRecord.Original_Start_Date__c               = Date.Today()-50;
        
        return mileStoneRecord;
    }
    
     //create Milestone Without Parent MileStone
     public static Step__c createMileStoneWithoutParentMileStone(Id User_Id ,Id Task_Id)
    {
        Step__c mileStoneRecord                = new Step__c(); 
        mileStoneRecord.Name                        = 'Test MileStone';
        //mileStoneRecord.Assigned_To__c              = User_Id; 
        mileStoneRecord.Task_Name__c                     = Task_Id;
        mileStoneRecord.Original_Duration__c                = 60;
        //mileStoneRecord.Actual_Start_Date__c        = Date.Today()-50;
        mileStoneRecord.Actual_Completion_Date__c     = Date.Today()+50 ;
        //mileStoneRecord.Original_Start_Date__c       = Date.Today()-49;
        insert mileStoneRecord;
        return mileStoneRecord;
    }
    
    public static Grant__c createGrant(Id account_Id){                
        Grant__c objGrant             = new Grant__c();
        objGrant.Disease_Component__c       =  'Malaria';
        objGrant.Name               = 'Test';
        objGrant.Principal_Recipient__c     = account_Id;
        insert objGrant;               
        return objGrant;
    }    
    
    public static Implementation_Period__c createIp(Id Account_Id, Id Grant_Id){
        
        Implementation_Period__C ip       = new Implementation_Period__C();
        ip.name                 = 'Test Ip';
        ip.Principal_Recipient__c         = Account_Id;     
        ip.Grant__c               = Grant_Id;
        ip.Start_Date__c             = Date.today();
        //ip.End_Date__c               =Date.today().addYears(3);
        ip.Length_Years__c             ='3';        
        insert ip;
        return ip;
    }
    //create Single Task
    public static Task__c createTask(Id Country_Id, Id User_Id,Id ImplementationPeriod_Id)
    {
        Task__c TaskRecord             = new Task__c(); 
        //TaskRecord.Country__c           = Country_Id;        
        //TaskRecord.Complete__c           = 40;
        //TaskRecord.Actual_Start_Date__c     = Date.Today()-50;
        //TaskRecord.Actual_Completion_Date__c       = Date.Today()+50 ;
        //TaskRecord.Assigned_To__c         = User_Id;
        TaskRecord.Comments__c           = 'Test Comments';
        //TaskRecord.Country__c           = Country_Id;
        TaskRecord.Grant_Name__c   = ImplementationPeriod_Id;        
        //TaskRecord.Duration__c           = 50;
        //TaskRecord.End_Date__c           = Date.Today()+50 ;
       // TaskRecord.Original_Start_Date__c         = Date.Today()-50;
        TaskRecord.Status__c           = 'In Progress;';
        TaskRecord.Name        = 'Test Task';
        TaskRecord.Task_Name__c         = 'Training Plan';
        insert taskrecord;
        return TaskRecord;
    }
     public static Account createTestAccount(Id country_Id){
        Account acc               = new Account();
        acc.name                ='Testusr';
        acc.Short_Name__c             = 'MOH';        
        acc.Address_line_1__c           = 'Test Address 1';
        acc.Address_line_2__c           = 'Test Address 2';
        acc.Address_line_3__c           = 'Test Address 3';
        acc.Short_Name__c             = 'MOH';
        acc.Country__c               = country_Id ;   
        insert acc;  
        return acc;
     }
     
     public static Attachment createTaskAttachment(Id task_id){
         Attachment att = new Attachment();
         Blob b = Blob.valueof('');
         att.ParentId = task_id;
         att.name = 'AT';
         att.body = b;
         insert att;
         return att;
     }
}