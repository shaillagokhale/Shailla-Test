@isTest
public class TestCN_Training {
    
     Public Static testMethod void TestCN_Training(){
              
         CN_Training objCN_Training = new CN_Training();
         Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
         User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='fr', 
         LocaleSidKey='fr', ProfileId = p.Id, 
         TimeZoneSidKey='America/Los_Angeles', UserName='test1@fb.com');
         
         
         System.runAs(u){
         CN_Training objCN_Training1 = new CN_Training();    
         System.assertEquals(System.UserInfo.getLanguage(),'fr');  
             
          u.LanguageLocaleKey='es';
          u.LocaleSidKey = 'es';
          update u;
          CN_Training objCN_Training2 = new CN_Training();  
          System.assertEquals(System.UserInfo.getLanguage(),'es');   
            
             
           u.LanguageLocaleKey='ru';
           u.LocaleSidKey = 'ru';
           update u;
           CN_Training objCN_Training3 = new CN_Training();  
           System.assertEquals(System.UserInfo.getLanguage(),'ru');   
             
         }
     }   

}