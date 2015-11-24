/*********************************************************************************
* Test Class: {TestUpdateAccountFinanceOfficer}
*  DateCreated : 01/30/2014
----------------------------------------------------------------------------------
* Purpose/Methods:
* - Used for cover all methods of UpdateAccountFinanceOfficer.
----------------------------------------------------------------------------------
* History:
* - VERSION  DEVELOPER NAME    DATE            DETAIL FEATURES
     1.0                      01/30/2014      INITIAL DEVELOPMENT
*********************************************************************************/

@isTest
Public Class TestUpdateAccountFinanceOfficer{
    Public static testMethod void TestUpdateAccountFinanceOfficer(){
        List<GroupMember> lst = [Select UserOrGroupId,GroupId From GroupMember where Group.DeveloperName = 'CT_All_Program_Finance'];

        Country__c objCountry = new Country__c();
        objCountry.Name = 'Test Country';
        if(lst.size() > 0)objCountry.CT_Public_Group_ID__c = lst[0].GroupId;
        insert objCountry;
        
        Country__c objCountry1 = new Country__c();
        objCountry1.Name = 'Test Country1';
        if(lst.size() > 0)objCountry1.CT_Public_Group_ID__c = lst[0].GroupId;
        insert objCountry1;
        
        Account objAcc = new Account();
        objAcc.name = 'test Acc';
        objAcc.Country__c = objCountry.id;
        insert objAcc;
        
        objAcc.Country__c = objCountry1.id;
        update objAcc;
    }
}