/*********************************************************************************
* Test class:   TestCN_Training_Center
  Class: CN_Training_Center 
*  DateCreated : 20/11/2014
----------------------------------------------------------------------------------
* Purpose/Methods:
* - To test CN_Training_Center class 
----------------------------------------------------------------------------------
* History:
* - VERSION  DEVELOPER NAME    DATE            DETAIL FEATURES
     1.0        TCS           20/11/2014      INITIAL DEVELOPMENT
*********************************************************************************/ 

@isTest
Public Class TestCN_Training_Center{
Public static testMethod void TestCN_TrainingE(){
List<Profile> objProfiles = [SELECT id FROM Profile WHERE name = 'System Administrator' Limit 1]; 
          
            User objEsUser = new User(alias = 'u1', email='eS@testorg.com',
            emailencodingkey='UTF-8', lastname='TestingEs', languagelocalekey='es',
            localesidkey='en_US', profileid = objProfiles[0].Id, country = 'Turkey', CommunityNickname = 'u1',
            timezonesidkey='America/Los_Angeles', username='eS@testorg.com');
          insert objEsUser;

          User objRuUser = new User(alias = 'u2', email='rU@testorg.com',
            emailencodingkey='UTF-8', lastname='TestingRu', languagelocalekey='ru',
            localesidkey='en_US', profileid = objProfiles[0].Id, country = 'Australia', CommunityNickname = 'u2',
            timezonesidkey='America/Los_Angeles', username='rU@testorg.com');
          insert objRuUser; 
        
            User objFrUser = new User(alias = 'u3', email='fR@testorg.com',
            emailencodingkey='UTF-8', lastname='TestingFr', languagelocalekey='fr',
            localesidkey='en_US', profileid = objProfiles[0].Id, country = 'Brazil', CommunityNickname = 'u3',
            timezonesidkey='America/Los_Angeles', username='fR@testorg.com');
          insert objFrUser;
          
       
  System.RunAs(objEsUser){
  CN_Training_Center objCN_Training = new CN_Training_Center();
  objCN_Training.strGuidanceArea = 'Concept Note';
  }

  System.RunAs(objRuUser){
  CN_Training_Center objCN_Training = new CN_Training_Center();
  objCN_Training.strGuidanceArea = 'Concept Note';
  }

  System.RunAs(objFrUser){
  CN_Training_Center objCN_Training = new CN_Training_Center();
  objCN_Training.strGuidanceArea = 'Concept Note';
  }

 

}

}