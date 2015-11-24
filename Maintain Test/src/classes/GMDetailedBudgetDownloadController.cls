public with sharing class GMDetailedBudgetDownloadController {
    public Set<Integer> noOfRecords                                                   {get; set;}
    String moduleID;
    public List<SelectOption> grantInterventionOptions                         {get; set;}
    public String selectedIntervention                                         {get; set;}
    public List<SelectOption> costGroupOptions                                 {get; set;}
    public List<SelectOption> costInputOptions                                 {get; set;}
    public List<SelectOption> recipientOptions                                 {get; set;}
    public List<SelectOption> currencyOptions                                  {get; set;}
    public String selectedCostGroup                                            {get; set;}
    public String selectedCostInput                                            {get; set;}
    public String selectedRecipient                                            {get; set;}
    public String selectedCurrency                                             {get; set;}
    
    public GMDetailedBudgetDownloadController(ApexPages.StandardController controller) {
        noOfRecords = new Set<Integer>();
        for(integer i = 1; i<= 5; i++) {
            noOfRecords.add(i);    
        }                        
        moduleID = Apexpages.currentpage().getparameters().get('Id');
        List<Module__c> moduleList = [Select Implementation_Period__c, Implementation_Period__r.Local_Currency__c,
                                      Implementation_Period__r.Currency_of_Grant_Agreement__c,
                                      Implementation_Period__r.Other_Currency__c
                                      From Module__c 
                                      Where id =: moduleID And Implementation_Period__c != null];
        String implementationPeriodId = moduleList[0].Implementation_Period__c;
        /*Currency*/
        currencyOptions = new List<SelectOption>();
        if(moduleList[0].Implementation_Period__r.Currency_of_Grant_Agreement__c != null){
            currencyOptions.add(new SelectOption('Grant Currency',moduleList[0].Implementation_Period__r.Currency_of_Grant_Agreement__c));
        }
        if(moduleList[0].Implementation_Period__r.Local_Currency__c != null){
            currencyOptions.add(new SelectOption('Local Currency',moduleList[0].Implementation_Period__r.Local_Currency__c));
        }
        if(moduleList[0].Implementation_Period__r.Other_Currency__c != null){
            currencyOptions.add(new SelectOption('Other Currency',moduleList[0].Implementation_Period__r.Other_Currency__c));
        }
        
        /**Grant Intervention**/
        grantInterventionOptions = new List<SelectOption>();
        grantInterventionOptions.add(new SelectOption('','--None--'));      
        List<Grant_Intervention__c> GIList = [SELECT Id,Name 
                                              FROM Grant_Intervention__c 
                                              WHERE Module__c =: moduleID 
                                              ORDER BY Name];
        if(!GIList.isEmpty() && GIList != null){
            for(Grant_Intervention__c gi: GIList){
                grantInterventionOptions.add(new SelectOption(gi.Id,gi.Name));
            }
        }       
        /****Cost Grouping**/
        costGroupOptions =  new List<Selectoption>(); 
        Schema.DescribeFieldResult fieldResult = Catalog_Cost_Input__c.Cost_Grouping__c.getDescribe();
        costGroupOptions.add(new SelectOption('', '-- None --'));
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry f : ple){
           costGroupOptions.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        /**Cost Input**/       
        costInputOptions = new List<SelectOption>();
        List<Catalog_Cost_Input__c> costInputList = [SELECT Id, Name
                                                     FROM Catalog_Cost_Input__c 
                                                     ORDER BY Cost_Input_Number__c];
        costInputOptions.add(new SelectOption('','--None--'));
        if(costInputList!= null && !costInputList.isEmpty()){
            for(Catalog_Cost_Input__c objCI : costInputList){
                costInputOptions .add(new SelectOption(objCI.Id,objCI.Name));
            }
        }
        /**Recipient**/
        recipientOptions = new List<SelectOption>();
        recipientOptions.add(new SelectOption('','--None--'));
        List<Implementer__c> implementerList = [Select Id,Name, Implementer_Name__c 
                                                From Implementer__c 
                                                where Grant_Implementation_Period__c =: implementationPeriodId];
        if(!implementerList.isEmpty() && implementerList != null){
            for(Implementer__c objImp : implementerList){
                recipientOptions.add(new SelectOption(objImp.Id,objImp.Implementer_Name__c));
            }
        }                        
    }
}