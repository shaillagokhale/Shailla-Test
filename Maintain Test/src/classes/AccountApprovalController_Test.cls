@isTest
public with sharing class AccountApprovalController_Test {


public static testMethod void AccountApprovalController_Test(){
Account objAcc = TestClassHelper.createAccount();
insert objAcc;

Account_Approval__c objApp = new Account_Approval__c();
objApp.Account__c = objAcc.Id;
objApp.status__c = 'Pending';
insert objApp;

Grant__c objGrant = TestClassHelper.insertGrant(objAcc);

Implementation_Period__c objIP = TestClassHelper.createIP(objGrant, objAcc);
objIP.name = 'Approval IP';
insert objIP; 

objAcc.Submitted_GIP_Id__c = objIP.Id;
update objAcc;

Contact objCon = TestClassHelper.createContact();
objCon.AccountId = objAcc.Id;
objCon.Primary_Contact__c = true; 
insert objCon;

Apexpages.currentpage().getparameters().put('accId',objAcc.Id);
//ApexPages.StandardController sc = new ApexPages.StandardController(objAcc);
AccountApprovalController objAA = new AccountApprovalController();
//objAA.currentApprovalRequest = objApp;
System.debug(objAA.currentApprovalRequest+ 'Approval**');
//objAA.approve();
objAA.reject();

//objAA.updateApprovals('Approved');
//objAA.updateApprovals('Reject');

}

}