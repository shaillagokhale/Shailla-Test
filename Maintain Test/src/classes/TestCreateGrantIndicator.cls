@isTest (seeAllData = True)
public class TestCreateGrantIndicator {
    Public static testMethod void TestCreateGrantIndicator(){
        Account objAcc = new Account();
        objAcc.Name = 'Test Acc';
        objAcc.Short_Name__c = 'MOH';
        insert objAcc;
        
        Implementation_Period__c objIP = new Implementation_Period__c();
        objIP.Principal_Recipient__c = objAcc.Id;
        insert objIP;
        
        Catalog_Module__c objCM = new Catalog_Module__c();
        objCM.Name = 'Test CM';
        insert objCM;
        
        Indicator__c objInd = new Indicator__c();
        objInd.Catalog_Module__c = objCM.Id;
        objInd.Indicator_Type__c = 'Coverage/Output';
        objInd.Full_Name_En__c = 'test';
        objInd.Type_of_Data__c = 'Number';
        insert objInd;
        
        Indicator__c objInd1 = new Indicator__c();
        objInd1.Catalog_Module__c = objCM.Id;
        objInd1.Indicator_Type__c = 'Coverage/Output';
        objInd1.Full_Name_En__c = 'test';
        objInd1.Type_of_Data__c = 'Number';
        insert objInd1;
        
        Module__c objModule = new Module__c();
        objmodule.Name = 'Test';
        objModule.Component__c = 'Malaria';
        objModule.Implementation_Period__c = objIP.Id;
        objModule.Catalog_Module__c = objCM.id;
       
        
        Module__c objModule1 = new Module__c();
        objmodule1.Name = 'Test';
        objModule1.Component__c = 'Malaria';
        objModule1.Implementation_Period__c = objIP.Id;
        objModule1.Catalog_Module__c = objCM.id;
        
        List<Module__c> lstAddModule = new List<Module__c>();
        lstAddModule.add(objModule1);
        lstAddModule.add(objModule);
        insert lstAddModule;
        
        
        
        
               
    
    }        
}