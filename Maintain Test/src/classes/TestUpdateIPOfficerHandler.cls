/*********************************************************************************
* Test Class: {TestUpdateIPOfficerHandler}
*  DateCreated : 01/30/2014
----------------------------------------------------------------------------------
* Purpose/Methods:
* - Used for cover all methods of UpdateIPOfficerHandler.
----------------------------------------------------------------------------------
* History:
* - VERSION  DEVELOPER NAME    DATE            DETAIL FEATURES
     1.0                      01/30/2014      INITIAL DEVELOPMENT
*********************************************************************************/

@isTest
Public Class TestUpdateIPOfficerHandler{
    Public Static testMethod void TestUpdateIPOfficerHandler(){
    
        List<GroupMember> lst = [Select UserOrGroupId,Group.DeveloperName From GroupMember where Group.DeveloperName = 'CT_All_Program_Finance'];
        
        Country__c ObjCountry = new Country__c();
        ObjCountry.Name = 'Australia';
        ObjCountry.CT_Public_Group_ID__c = 'Test';
        if(lst.size() > 0)objCountry.CT_Public_Group_ID__c = lst[0].GroupId;
        insert ObjCountry;
        
        Account objAcc = new Account();
        objAcc.Name = 'Test Acc';
        objAcc.Country__c = objCountry.id;
        insert objAcc;
        
        Grant__c ObjGrant = new Grant__c();
        ObjGrant.Name = 'SRB--6';
        ObjGrant.Principal_Recipient__c = objAcc.id;
        ObjGrant.GIS_Grant_ID__c = 'Test';
        insert ObjGrant;
        
        Implementation_Period__c ObjImplementationPeriod = new Implementation_Period__c();
        ObjImplementationPeriod.Name = 'Test';
        ObjImplementationPeriod.Principal_Recipient__c = objAcc.id;
        ObjImplementationPeriod.Grant__c = ObjGrant.id;
        ObjImplementationPeriod.Implementation_Cycle__c = 't';
        ObjImplementationPeriod.Principal_Recipient__c = objAcc.id;  
        insert ObjImplementationPeriod;
        
        List<GroupMember> lst1 = [Select UserOrGroupId,Group.DeveloperName From GroupMember where Group.DeveloperName = 'CT_All_Legal'];
        
        Country__c ObjCountry1 = new Country__c();
        ObjCountry1.Name = 'Australia';
        if(lst1.size() > 0) objCountry1.CT_Public_Group_ID__c = lst1[0].GroupId;
        insert ObjCountry1;
        
        Account objAcc1 = new Account();
        objAcc1.Name = 'Test Acc';
        objAcc1.Country__c = objCountry1.id;
        insert objAcc1;
    }
}