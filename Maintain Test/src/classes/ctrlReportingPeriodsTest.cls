@isTest(seealldata=false)
public class ctrlReportingPeriodsTest{

        
public static testMethod void myctrlReportingPeriodsTest(){


 User objUser = [Select ID, country from User where id=:userinfo.getUserId()];
     
        /*Country__c objCountry = new Country__c();
        objCountry.Name = 'test';
        objCountry.FPM__c = objUser.id;
        objCountry.Country_Fiscal_Cycle_Start_Date__c = Date.today();
        objCountry.Country_Fiscal_Cycle_End_Date__c = Date.today()+12;
        insert objCountry;
        //static Country__c objCountry;
        //objCountry=TestClassHelper.insertCountry();
        //Account objAcc = TestClassHelper.insertAcc();
        //Grant__c objGrant = TestClassHelper.insertGrant();
        
        Account objAcc = new Account();
        objAcc.Name = 'Test Acc';
        objAcc.Short_Name__c = 'MOH';
        objAcc.Country__c = objCountry.Id;
        insert objAcc;
        
        Grant__c objGrant = new Grant__c();
        objGrant.Disease_Component__c =  'Malaria';
        objGrant.Name = 'Test';
        objGrant.Principal_Recipient__c = objAcc.Id;
        insert objGrant;
        
        Implementation_Period__c objIP = new Implementation_Period__c();
        objIP.Principal_Recipient__c = objAcc.Id;
        objIP.Grant__c = objGrant.Id;
        objIP.Start_Date__c =Date.today();
        objIP.End_Date__c =Date.today().addYears(3);
        objIP.Length_Years__c ='3';
        //objIP.Principal_Recipient__r.Country__r.Country_Fiscal_Cycle_Start_Date__c = Date.today();
        //objIP.Principal_Recipient__r.Country__r.Country_Fiscal_Cycle_End_Date__c = Date.today()+12;     
        insert objIP;
        List<Implementation_Period__c>lstIP = new List<Implementation_Period__c>();
        lstIP.add(objIP);
        system.debug('@@list IP@@'+lstIP);
        
        Page__c objPage =  TestClassHelper.insertPage();
            
        Page__c objPage = new Page__c();
        objPage.Implementation_Period__c = objIP.Id;
        insert objPage;
        
        Period__c per = new Period__c();
        per.Implementation_Period__c = objIP.Id;
        per.Start_Date__c = Date.today();
        insert per;*/
        
        Account objAcc = TestClassHelper.insertAccount();
        
        Profile_Access_Setting__c objProfCust = TestClassHelper.createProfileSetting();
        objProfCust.Page_Name__c ='ReportingPeriods';
        objProfCust.Salesforce_Item__c = 'External Profile';
        objProfCust.Salesforce_Item__c = 'Edit Period Button';
        objProfCust.Salesforce_Item__c = 'Period Document Due Date';
        objProfCust.Salesforce_Item__c = 'Choose Reporting Frequency';
        objProfCust.Salesforce_Item__c = 'Change Frequency';
        insert objProfCust;
        
        Grant__c objGrant  = TestClassHelper.createGrant(objAcc);
        insert objGrant;
       
        Implementation_Period__c objIP = TestClassHelper.createIP(objGrant,objAcc);
        insert objIP;
        
        List<Implementation_Period__c>lstIP = new List<Implementation_Period__c>();
        lstIP.add(objIP);
        
        Page__c ObjPage = TestClassHelper.createPage();
        ObjPage.Implementation_Period__c = objIP.Id;
        insert ObjPage;
        
        Period__c ObjRP = TestClassHelper.createPeriod();
        ObjRP.Implementation_Period__c = objIP.Id;
        ObjRP.Start_Date__c = Date.today();
        ObjRP.EFR__c=false;
        ObjRP.EFR_Due_Date__c = system.today();
        ObjRP.PU__c=false;
        ObjRP.PU_Due_Date__c =  system.today();
        ObjRP.Audit_Report__c=false;
        ObjRP.AR_Due_Date__c=system.today();
        ObjRP.DR__c=false;
        ObjRP.Type__c = 'Reporting';
        ObjRP.Due_Date__c=system.today();
        insert ObjRP;
        
        Guidance__c objGuidance = new Guidance__c();
        objGuidance.Name = 'GM Reporting Periods';
        insert objGuidance; 
        
        Apexpages.currentpage().getparameters().put('id',objPage.Id); 
        ApexPages.StandardController sc = new ApexPages.StandardController(objPage);
        ctrlReportingPeriods objClsReport = new ctrlReportingPeriods(sc);
        objClsReport.dateIPStart =lstIP[0].Start_Date__c;
        objClsReport.dateCtrFiscalEnd = lstIP[0].Principal_Recipient__r.Country__r.Country_Fiscal_Cycle_End_Date__c;
        objClsReport.selectopt = '1';

        objClsReport.GeneratePeriod();
        objClsReport.SaveChanges();
        objClsReport.EditPeriod();
        objClsReport.AddDoC();
        objClsReport.noOperation();
        Apexpages.currentpage().getparameters().put('SaveDocIndex','0');
        //objClsReport.SaveDocIndex = 1;
        objClsReport.SaveDoc();
        objClsReport.CancelDocPopup();

}
public static testMethod void myctrlReportingPeriodsTest2(){
Account objAcc = TestClassHelper.insertAccount();
        
        Grant__c objGrant  = TestClassHelper.createGrant(objAcc);
        insert objGrant;
       
        Implementation_Period__c objIP = TestClassHelper.createIP(objGrant,objAcc);
        insert objIP;
        
        List<Implementation_Period__c>lstIP = new List<Implementation_Period__c>();
        lstIP.add(objIP);
        
        Page__c ObjPage = TestClassHelper.createPage();
        ObjPage.Implementation_Period__c = objIP.Id;
        insert ObjPage;
        
        Period__c ObjRP = TestClassHelper.createPeriod();
        ObjRP.Implementation_Period__c = objIP.Id;
        ObjRP.Start_Date__c = Date.today();
        ObjRP.EFR__c=true;
        ObjRP.EFR_Due_Date__c = system.today().addDays(10);
        ObjRP.PU__c=true;
        ObjRP.PU_Due_Date__c =  system.today().addDays(10);
        ObjRP.Audit_Report__c=false;
        ObjRP.AR_Due_Date__c=system.today();
        ObjRP.DR__c=True;
        ObjRP.Type__c = 'Reporting';
        ObjRP.Due_Date__c=system.today();
        insert ObjRP;
     
        Apexpages.currentpage().getparameters().put('id',objPage.Id); 
        ApexPages.StandardController sc = new ApexPages.StandardController(objPage);
        ctrlReportingPeriods objClsReport = new ctrlReportingPeriods(sc);
        objClsReport.dateIPStart =lstIP[0].Start_Date__c;
        objClsReport.dateIPStart.addMonths(6); 
        System.debug('**objClsReport.dateIPStart'+objClsReport.dateIPStart);
        objClsReport.dateCtrFiscalEnd = lstIP[0].Principal_Recipient__r.Country__r.Country_Fiscal_Cycle_End_Date__c;
        objClsReport.selectopt = '2';

        objClsReport.GeneratePeriod();
        objClsReport.SaveChanges();
        objClsReport.EditPeriod();
        objClsReport.AddDoC();
        objClsReport.noOperation();
        Apexpages.currentpage().getparameters().put('SaveDocIndex','0');
        //objClsReport.SaveDocIndex = 1;
        objClsReport.SaveDoc();
        objClsReport.CancelDocPopup();



}
public static testMethod void myctrlReportingPeriodsTest3(){
    Account objAcc = TestClassHelper.insertAccount();
        
        Grant__c objGrant  = TestClassHelper.createGrant(objAcc);
        insert objGrant;
       
        Implementation_Period__c objIP = TestClassHelper.createIP(objGrant,objAcc);
        insert objIP;
        
        List<Implementation_Period__c>lstIP = new List<Implementation_Period__c>();
        lstIP.add(objIP);
        
        Page__c ObjPage = TestClassHelper.createPage();
        ObjPage.Implementation_Period__c = objIP.Id;
        insert ObjPage;
        
         
        
        Period__c ObjRP = TestClassHelper.createPeriod();
        ObjRP.Implementation_Period__c = objIP.Id;
        ObjRP.Start_Date__c = Date.today();
        ObjRP.EFR__c=false;
        ObjRP.EFR_Due_Date__c = system.today();
        system.debug('**ObjRP.EFR_Due_Date__c'+ObjRP.EFR_Due_Date__c);
        ObjRP.PU__c=false;
        ObjRP.PU_Due_Date__c =  system.today();
        ObjRP.Audit_Report__c=false;
        ObjRP.AR_Due_Date__c=system.today();
        ObjRP.DR__c=true;
        ObjRP.Type__c = 'Reporting';
        ObjRP.Due_Date__c=system.today().addDays(2);
        insert ObjRP;
     
        Apexpages.currentpage().getparameters().put('id',objPage.Id); 
        ApexPages.StandardController sc = new ApexPages.StandardController(objPage);
        ctrlReportingPeriods objClsReport = new ctrlReportingPeriods(sc);
        objClsReport.dateIPStart =lstIP[0].Start_Date__c;
        objClsReport.dateCtrFiscalEnd = lstIP[0].Principal_Recipient__r.Country__r.Country_Fiscal_Cycle_End_Date__c;
        
        objClsReport.selectopt = '4';

        objClsReport.GeneratePeriod();
        objClsReport.SaveChanges();
        objClsReport.EditPeriod();
        objClsReport.AddDoC();
        objClsReport.noOperation();
        Apexpages.currentpage().getparameters().put('SaveDocIndex','0');
        //objClsReport.SaveDocIndex = 1;
        objClsReport.SaveDoc();
        objClsReport.CancelDocPopup();
}
public static testMethod void myctrlReportingPeriodsTest4(){
        
        Country__c objCountry = TestClassHelper.createCountry();
        objCountry.Country_Fiscal_Cycle_Start_Date__c = null;
        objCountry.Country_Fiscal_Cycle_End_Date__c = null;
        insert objCountry;
        
        Account objAcc = TestClassHelper.createAccount();
        objAcc.Country__c = objCountry.Id ;
        insert objAcc;
        
        Grant__c objGrant  = TestClassHelper.createGrant(objAcc);
        insert objGrant;
       
        Implementation_Period__c objIP = TestClassHelper.createIP(objGrant,objAcc);
        objIP.Start_Date__c =null;
        objIP.End_Date__c =null;
        insert objIP;
        
        List<Implementation_Period__c>lstIP = new List<Implementation_Period__c>();
        lstIP.add(objIP);
        
        Page__c ObjPage = TestClassHelper.createPage();
        ObjPage.Implementation_Period__c = objIP.Id;
        insert ObjPage;
        
         
        
        Period__c ObjRP = TestClassHelper.createPeriod();
        ObjRP.Implementation_Period__c = objIP.Id;
        ObjRP.Start_Date__c = Date.today();
        ObjRP.EFR__c=false;
        ObjRP.EFR_Due_Date__c = system.today();
        system.debug('**ObjRP.EFR_Due_Date__c'+ObjRP.EFR_Due_Date__c);
        ObjRP.PU__c=false;
        ObjRP.PU_Due_Date__c =  system.today();
        ObjRP.Audit_Report__c=false;
        ObjRP.AR_Due_Date__c=system.today();
        ObjRP.DR__c=true;
        ObjRP.Type__c = 'Reporting';
        ObjRP.Due_Date__c=system.today().addDays(2);
        insert ObjRP;
     
        Apexpages.currentpage().getparameters().put('id',objPage.Id); 
        ApexPages.StandardController sc = new ApexPages.StandardController(objPage);
        ctrlReportingPeriods objClsReport = new ctrlReportingPeriods(sc);
        objClsReport.dateIPStart =lstIP[0].Start_Date__c;
        
        objClsReport.dateCtrFiscalEnd = lstIP[0].Principal_Recipient__r.Country__r.Country_Fiscal_Cycle_End_Date__c;
        
        objClsReport.selectopt = '4';

        objClsReport.GeneratePeriod();
        objClsReport.SaveChanges();
        objClsReport.EditPeriod();
        objClsReport.AddDoC();
        objClsReport.noOperation();
        Apexpages.currentpage().getparameters().put('SaveDocIndex','0');
        //objClsReport.SaveDocIndex = 1;
        objClsReport.SaveDoc();
        objClsReport.CancelDocPopup();
}
public static testMethod void myctrlReportingPeriodsTest5(){
        
        Country__c objCountry = TestClassHelper.createCountry();
        objCountry.Country_Fiscal_Cycle_Start_Date__c = null;
        objCountry.Country_Fiscal_Cycle_End_Date__c = null;
        insert objCountry;
        
        Account objAcc = TestClassHelper.createAccount();
        objAcc.Country__c = objCountry.Id ;
        insert objAcc;
        
        Grant__c objGrant  = TestClassHelper.createGrant(objAcc);
        insert objGrant;
       
        Implementation_Period__c objIP = TestClassHelper.createIP(objGrant,objAcc);
        
        insert objIP;
        
        List<Implementation_Period__c>lstIP = new List<Implementation_Period__c>();
        lstIP.add(objIP);
        
        Page__c ObjPage = TestClassHelper.createPage();
        ObjPage.Implementation_Period__c = objIP.Id;
        insert ObjPage;
         
         
        
        Period__c ObjRP = TestClassHelper.createPeriod();
        ObjRP.Implementation_Period__c = objIP.Id;
        ObjRP.Start_Date__c = Date.today();
        ObjRP.EFR__c=false;
        ObjRP.EFR_Due_Date__c = system.today();
        system.debug('**ObjRP.EFR_Due_Date__c'+ObjRP.EFR_Due_Date__c);
        ObjRP.PU__c=false;
        ObjRP.PU_Due_Date__c =  system.today();
        ObjRP.Audit_Report__c=true;
        ObjRP.AR_Due_Date__c=system.today().addDays(10);
        ObjRP.DR__c=true;
        ObjRP.Type__c = 'Reporting';
        ObjRP.Due_Date__c=system.today().addDays(2);
        insert ObjRP;
     
        Apexpages.currentpage().getparameters().put('id',objPage.Id); 
        ApexPages.StandardController sc = new ApexPages.StandardController(objPage);
        ctrlReportingPeriods objClsReport = new ctrlReportingPeriods(sc);
        objClsReport.dateIPStart =lstIP[0].Start_Date__c;
        objClsReport.dateIPStart.addMonths(9); 
        System.debug('**objClsReport.dateIPStart'+objClsReport.dateIPStart);
        objClsReport.dateCtrFiscalEnd = lstIP[0].Principal_Recipient__r.Country__r.Country_Fiscal_Cycle_End_Date__c;
        
        objClsReport.selectopt = '4';
        System.debug('**lstRP in Test ObjRP before'+ObjRP);
        objClsReport.GeneratePeriod();
        System.debug('**lstRP in Test ObjRP after'+ObjRP);
        objClsReport.SaveChanges();
        objClsReport.EditPeriod();
        objClsReport.AddDoC();
        objClsReport.noOperation();
        Apexpages.currentpage().getparameters().put('SaveDocIndex','0');
        //objClsReport.SaveDocIndex = 1;
        System.debug('**lstRP in Test'+objClsReport.lstRP);
        objClsReport.SaveDoc();
        objClsReport.CancelDocPopup();
}
}