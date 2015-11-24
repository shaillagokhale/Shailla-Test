@isTest
Public Class TestShare_with_CT  
{
    Public Static testMethod void TestShare_with_CT ()
    {
        Country__c objCountry = new Country__c(name='bulgaria',CT_Public_Group_ID__c='00Gb0000000thZO');
        insert objCountry; 
        LFA_Work_Plan__c objWP = new LFA_Work_Plan__c(name='Test WO',Country__c=objCountry.ID,Country_Team_can_edit__c=FALSE);
        insert objWP;
        LFA_Work_Plan__c objWP1 = new LFA_Work_Plan__c(name='Test WO',Country__c=objCountry.ID,Country_Team_can_edit__c=True);
        insert objWP1;
      
    }
}