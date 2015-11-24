/*********************************************************************************
* Test Class: {TestUpdateIPDetailRelatedToAcc}
*  DateCreated : 10/29/2014
----------------------------------------------------------------------------------
* Purpose/Methods:
* - Used for cover all methods of UpdateIPDetailRelatedToAcc.
----------------------------------------------------------------------------------
* History:
* - VERSION  DEVELOPER NAME    DATE            DETAIL FEATURES
     1.0                      10/29/2014      INITIAL DEVELOPMENT
*********************************************************************************/
@isTest
Public Class TestUpdateIPDetailRelatedToAcc{


Public static testMethod void TestUpdateIPDetailRelatedToAcc()
{

 Id objProfileId = [select id from profile Limit 1].Id; 
          
            User objUserFPM = new User(alias = 'u1', email='fpm@testorg.com',
            emailencodingkey='UTF-8', lastname='Testingfpm', languagelocalekey='es',
            localesidkey='en_US', profileid = objProfileId, CommunityNickname = 'u1',
            timezonesidkey='America/Los_Angeles', username='fpm@testorg.com');
      insert objUserFPM;   

 User objUserPO1 = new User(alias = 'u1', email='po1@testorg.com',
            emailencodingkey='UTF-8', lastname='Testingpo1', languagelocalekey='es',
            localesidkey='en_US', profileid = objProfileId, CommunityNickname = 'u2',
            timezonesidkey='America/Los_Angeles', username='po1@testorg.com');
      insert objUserPO1; 
      
      
       User objUserPO2 = new User(alias = 'u1', email='po2@testorg.com',
            emailencodingkey='UTF-8', lastname='Testingpo2', languagelocalekey='es',
            localesidkey='en_US', profileid = objProfileId, CommunityNickname = 'u3',
            timezonesidkey='America/Los_Angeles', username='po2@testorg.com');
      insert objUserPO2; 
      
       User objUserPO3 = new User(alias = 'u1', email='po3@testorg.com',
            emailencodingkey='UTF-8', lastname='Testingpo3', languagelocalekey='es',
            localesidkey='en_US', profileid = objProfileId, CommunityNickname = 'u4',
            timezonesidkey='America/Los_Angeles', username='po3@testorg.com');
      insert objUserPO3; 

    User objUserHPM = new User(alias = 'u1', email='hpm@testorg.com',
            emailencodingkey='UTF-8', lastname='Testinghpm', languagelocalekey='es',
            localesidkey='en_US', profileid = objProfileId, CommunityNickname = 'u5',
            timezonesidkey='America/Los_Angeles', username='hpm@testorg.com');
      insert objUserHPM; 


    User objUserMEPH = new User(alias = 'u1', email='MEPH@testorg.com',
            emailencodingkey='UTF-8', lastname='Testingmeph', languagelocalekey='es',
            localesidkey='en_US', profileid = objProfileId, CommunityNickname = 'u6',
            timezonesidkey='America/Los_Angeles', username='meph@testorg.com');
      insert objUserMEPH; 

  User objUserFO = new User(alias = 'u1', email='fo@testorg.com',
            emailencodingkey='UTF-8', lastname='Testingfo', languagelocalekey='es',
            localesidkey='en_US', profileid = objProfileId, CommunityNickname = 'u7',
            timezonesidkey='America/Los_Angeles', username='fo@testorg.com');
      insert objUserFO; 



Country__c objCountry = new Country__c();
objCountry.Name = 'Bulgaria one';
objCountry.FPM__c = objUserFPM.Id;
objCountry.PO_1__c = objUserPO1.Id;
objCountry.PO_2__c = objUserPO2.Id;
objCountry.PO_3__c = objUserPO3.Id;
objCountry.MEPH_Specialist__c = objUserMEPH.Id;
objCountry.HPM_Specialist__c = objUserHPM.Id;
//objCountry.Finance_Officer__c = objUserFO.Id;
insert objCountry;



Account prAccount = new Account();
prAccount.name = 'Fight TB';
prAccount.Country__c = objCountry.Id;
insert prAccount;

Implementation_Period__c objIP = new Implementation_Period__c();
objIP.name = 'Against TB';
objIP.Principal_Recipient__c = prAccount.Id;
insert objIP;

IP_Detail_Information__c objIPDetail = new IP_Detail_Information__c();
objIPDetail.Name = 'IP Status';
objIPDetail.Implementation_Period__c = objIP.Id;
insert objIPDetail;

List<Country__c> lstCountry = [SELECT Id,Name, Finance_Officer__c from Country__c WHERE name =: 'Bulgaria one'];
Country__c objCon = new Country__c();
if(lstCountry.size()>0)

for(Country__c objC: lstCountry)
{
objC.Finance_Officer__c = objUserFO.Id;
}
update lstCountry;

//System.assertEquals('fpm@testorg.com', objIPDetail.FPM_Email__c);
System.assertEquals('fo@testorg.com', objIPDetail.Finance_Officer_Email__c);
}

}