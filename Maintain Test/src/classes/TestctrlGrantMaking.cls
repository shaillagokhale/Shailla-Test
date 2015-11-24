@isTest
public class TestctrlGrantMaking{
    public static testMethod void TestctrlGrantMaking(){
        
        //UserRole sysAdminRole = [Select Id From UserRole Limit 1];
        
        User objUser = [Select ID, country from User where id=:userinfo.getUserId()];
        objUser.country = 'Test';
        //objUser.UserRoleId = sysAdminRole.Id;
        update objUser;
        
        Country__c objCon = new Country__c();
        objCon.Name = objUser.Country;
        insert objCon;
        
        //User objPRUser = new User();
        /*Profile objProfile = [select id from profile where name='PR Read Only'];
        User objPRUser = new User(alias = 'u1', email='u1@testorg.com',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = objProfile.Id,  CommunityNickname = 'u1',
            timezonesidkey='America/Los_Angeles', username='u1@testorg.com');
            
        //User objUser1 = [Select ID, country from User where id=:objPRUser.Id];
        User objUser1 = [Select ID, country from User where profileid =: objProfile.Id];*/
        
        	List<Profile> objProfiles = [select id from profile Limit 3]; 
        	
            User objEsUser = new User(alias = 'u1', email='eS@testorg.com',
            emailencodingkey='UTF-8', lastname='TestingEs', languagelocalekey='es',
            localesidkey='en_US', profileid = objProfiles[0].Id, country = objCon.Id, CommunityNickname = 'u1',
            timezonesidkey='America/Los_Angeles', username='eS@testorg.com');
			insert objEsUser;        
			
			User objRuUser = new User(alias = 'u2', email='rU@testorg.com',
            emailencodingkey='UTF-8', lastname='TestingRu', languagelocalekey='ru',
            localesidkey='en_US', profileid = objProfiles[1].Id, country = objCon.Id, CommunityNickname = 'u2',
            timezonesidkey='America/Los_Angeles', username='rU@testorg.com');
			insert objRuUser; 
        
        	User objFrUser = new User(alias = 'u3', email='fR@testorg.com',
            emailencodingkey='UTF-8', lastname='TestingFr', languagelocalekey='fr',
            localesidkey='en_US', profileid = objProfiles[2].Id, country = objCon.Id, CommunityNickname = 'u3',
            timezonesidkey='America/Los_Angeles', username='fR@testorg.com');
			insert objFrUser;
        	
        Country__c objCon1 = new Country__c();
        //objCon1.Name = '';
        //insert objCon1;
        
        Guidance__c objGuidance = new Guidance__c();
        objGuidance.Name = 'Grant-Making Home';
        insert objGuidance;
        
        Account objAcc = TestClassHelper.createAccount();
        objAcc.Country__c = objCon.Id ;
        insert objAcc;     
        
        Grant__c objGrant = TestClassHelper.createGrant(objAcc);
        objGrant.Grant_Status__c = 'Not yet submitted';
        insert objGrant;
        
        Implementation_Period__c objIP = TestClassHelper.createIP(objGrant,objAcc);
        /* objIP.Name = 'NGA-M-UN';
        objIP.Principal_Recipient__c = objAcc.Id;
        objIP.Grant__c = objGrant.Id;
        objIP.Start_Date__c =Date.today();
        objIP.End_Date__c =Date.today().addYears(3);
        objIP.Length_Years__c ='3';  */      
        objIP.Status__c =  'Grant-Making';
        objIP.CurrencyIsoCode='USD';
        objIP.Grant_Making_submission_date__c=Date.today().addYears(3);
        objIP.High_level_budget_GAC_1_EUR__c = 1000.00;
        objIP.High_level_budget_GAC_1_USD__c = 10002.99;
        objIP.High_level_budget_TRP_USD__c= 10003.77;
        objIP.High_level_budget_TRP_EUR__c= 10003.67;
        insert objIP;
        
        Page__c ObjPage = TestClassHelper.createPage();
        /*Objpage.Name = 'Test';
        Objpage.Status__c= 'Draft';*/
        Objpage.Implementation_Period__c = ObjIP.id;
        insert Objpage;
        
        Profile_Access_Setting__c objProfCust = TestClassHelper.createProfileSetting();
        objProfCust.Page_Name__c ='GrantMakingHome';
        objProfCust.Salesforce_Item__c = 'External Profile';
        
        insert objProfCust;
        
        Apexpages.currentpage().getparameters().put('id',objCon.Id);       
        ApexPages.StandardController sc = new ApexPages.StandardController(objCon);
        ctrlGrantMaking objGMO = new ctrlGrantMaking(sc);
        //Apexpages.currentpage().getparameters().put('id',null);
        objGMO.CountryId=objCon.Id;
        objGMO.strCountry = objCon.Name;
        //objGMO.UserID = objUser1.Id;
            
        objGMO.strGuidanceId  = objGuidance.Id;
        objGMO.lstIP[0]=objIP;
        objGMO.IPByCountry();
        objGMO.FillCountry(objCon.Name);
        objGMO.SaveChanges();

        //Apexpages.currentpage().getparameters().put('id',objCon1.Id);       
        ApexPages.StandardController sc1 = new ApexPages.StandardController(objCon1);
        ctrlGrantMaking objGMO1 = new ctrlGrantMaking(sc1);
        
        objGMO1.CountryId=objCon1.Id;
        objGMO1.strCountry = objCon.Name;
        //objGMO1.UserID = objUser2.Id;
            
        objGMO1.strGuidanceId  = objGuidance.Id;
        objGMO1.lstIP[0]=objIP;
        objGMO1.IPByCountry();
        objGMO1.FillCountry(objCon1.Name);
        objGMO1.SaveChanges();
     	test.starttest();
       	System.RunAs(objRuUser)
        {
		 Implementation_Period__c objImpObject = objIP;       
        Apexpages.currentpage().getparameters().put('id',objCon.Id);       
        ApexPages.StandardController scRu = new ApexPages.StandardController(objCon);
        ctrlGrantMaking objGMORu = new ctrlGrantMaking(scRu);
        //Apexpages.currentpage().getparameters().put('id',null);
        objGMORu.CountryId=objCon.Id;
        objGMORu.strCountry = objCon.Name;
        //objGMO.UserID = objUser1.Id;
            
        objGMORu.strGuidanceId  = objGuidance.Id;
        if(objGMORu.lstIP.size()>0)
        {
        objGMORu.lstIP[0]=objImpObject;
        }
        objGMORu.checkProfile();
        objGMORu.IPByCountry();
        objGMORu.FillCountry(objCon.Name);
        objGMORu.SaveChanges();
		        
        }
        
        System.RunAs(objFrUser)
        {
		 Implementation_Period__c objImpObject = objIP;       
        Apexpages.currentpage().getparameters().put('id',objCon.Id);       
        ApexPages.StandardController scFr = new ApexPages.StandardController(objCon);
        ctrlGrantMaking objGMOFr = new ctrlGrantMaking(scFr);
        //Apexpages.currentpage().getparameters().put('id',null);
        objGMOFr.CountryId=objCon.Id;
        objGMOFr.strCountry = objCon.Name;
        //objGMO.UserID = objUser1.Id;
            
        objGMOFr.strGuidanceId  = objGuidance.Id;
        if(objGMOFr.lstIP.size()>0)
        {
        objGMOFr.lstIP[0]=objImpObject;
        }
        objGMOFr.checkProfile();
        objGMOFr.IPByCountry();
        objGMOFr.FillCountry(objCon.Name);
        objGMOFr.SaveChanges();
		        
        }
        
        System.RunAs(objEsUser)
        {
		 Implementation_Period__c objImpObject = objIP;       
        Apexpages.currentpage().getparameters().put('id',objCon.Id);       
        ApexPages.StandardController scEs = new ApexPages.StandardController(objCon);
        ctrlGrantMaking objGMOEs = new ctrlGrantMaking(scEs);
        //Apexpages.currentpage().getparameters().put('id',null);
        objGMOEs.CountryId=objCon.Id;
        objGMOEs.strCountry = objCon.Name;
        //objGMO.UserID = objUser1.Id;
            
        objGMOEs.strGuidanceId  = objGuidance.Id;
        if(objGMOEs.lstIP.size()>0)
        {
        objGMOEs.lstIP[0]=objImpObject;
        }
        objGMOEs.checkProfile();
        objGMOEs.IPByCountry();
        objGMOEs.FillCountry(objCon.Name);
        objGMOEs.SaveChanges();
		        
        }
     test.stoptest();
    }
	
	
}