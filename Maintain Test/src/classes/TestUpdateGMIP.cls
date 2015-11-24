@isTest
public class TestUpdateGMIP{
Public static testMethod void TesttrgUpdateGMIP(){

    Account objAcc= TestClassHelper.createAccount();
    insert objAcc;
    test.startTest();
    Grant__c objGrant = TestClassHelper.createGrant(objAcc);
    insert objGrant;
        
        Concept_Note__c objCN = TestClassHelper.createCN();
        objCN.CCM_new__c = objAcc.id;
        insert objCN;
        
        Implementation_Period__c objIP= TestClassHelper.createIP(objGrant,objAcc);
        objIP.Concept_Note__c = objCN.Id;
        insert objIP;

        Page__c objPage = TestClassHelper.createPage();
        objPage.Implementation_Period__c = objIP.Id;
        insert objPage;
        
        Goals_Objectives__c objGoal = TestClassHelper.createGoalsObjectives();
        objGoal.Concept_note__c = objCN.Id;
        insert objGoal;
        
        Catalog_Module__c objCM = TestClassHelper.createCatalogModule();
        insert objCM;
        
        Catalog_Module__c objCM1 = TestClassHelper.createCatalogModule();
        objCM1.Name = 'Test CM1';
        objCM1.Component__c = 'Malaria';
        objCM1.component_multi__c = 'Malaria';
        insert objCM1;
        
        Module__c objModule = TestClassHelper.createModule();
        //objModule.Implementation_Period__c = objIP.Id;
        objModule.Catalog_Module__c = objCM.id;
        objModule.Component__c = 'Malaria';
        insert objModule;
        test.stopTest();
        Catalog_Intervention__c objCI = TestClassHelper.createCatalogIntervention();
        objCI.Catalog_Module__c  = objCM.Id;
        insert objCI; 
        
        Indicator__c objCatInd = TestClassHelper.createCatalogIndicator();
        insert objCatInd;
        
        Grant_Indicator__c objInd = TestClassHelper.createGrantIndicator();
        objInd.Concept_note__c = objCN.Id;
        objInd.Indicator_Type__c = 'Impact';
        objInd.Standard_or_Custom__c = 'Standard';
        objInd.Indicator__c = objCatInd.Id;
        objInd.Goal_Objective__c = objGoal.Id;
        insert objInd;
        
        Module__c objIPModule = TestClassHelper.createModule();
        objModule.Implementation_Period__c = objIP.Id;
        //objIPModule.Catalog_Module__c = objCM.id;
        objIPModule.Component__c = 'Malaria';
        insert objIPModule;
        
        Grant_Indicator__c objInd1 = TestClassHelper.createGrantIndicator();
        objInd1.Grant_Implementation_Period__c = objIP.Id;
        objInd1.Indicator_Type__c = 'Coverage/Outcome';
        objInd1.Standard_or_Custom__c = 'Standard';
        objInd1.Parent_Module__c = objIPModule.Id;
        objInd.Indicator__c = objCatInd.Id;
        insert objInd1;
        
        Grant_Intervention__c objInt = TestClassHelper.createGrantIntervention(objIP);
        objInt.Name = 'TestIntervention';
        objInt.Module__c = objIPModule.Id;
        insert objInt;
        
        Ind_Goal_Jxn__c objJxn = TestClassHelper.insertIndicatorGoalJxn(objGoal,objInd);
        
        objIP.Status__c = 'Grant-Making';
        update objIP;
}



}