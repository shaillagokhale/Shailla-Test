@isTest
Public Class TestModulesAndInterventions{
    Public static testMethod void TestModulesAndInterventions(){
        Account objAcc = new Account();
        objAcc.Name = 'Test Acc';
        objAcc.Short_Name__c = 'MOH';
        insert objAcc;
        
        Template__c objTemplate = new Template__c(Name = 'Test Template');
        insert objTemplate;
        
        Concept_Note__c objCN = TestClassHelper.createCN();
        objCN.Name = 'Test CN';
        objCN.Component__c = 'Malaria';
        objCN.Language__c = 'ENGLISH';
        objCN.CCM_new__c = objAcc.Id;
        objCN.Number_of_Years__c = '4';
        objCN.Page_Template__c = objTemplate.Id;
        objCN.Indicative_Amount__c = 10;
        insert objCN;
                        
        Page__c objPage = new Page__c();
        objPage.Concept_note__c = objCN.Id;
        insert objPage;
        
        Catalog_Module__c objCM = new Catalog_Module__c();
        objCM.Name = 'Test CM';
        insert objCM;
        
        Indicator__c objGi = new Indicator__c();   
        objGi.Indicator_Type__c = 'Coverage/Output';
        objGi.Catalog_Module__c = objCM.id;
        insert objGi;
        
        Catalog_Module__c objCM1 = new Catalog_Module__c();
        objCM1.Name = 'Test CM1';
        objCM1.Component__c = 'Malaria';
        objCM1.component_multi__c = objCN.Component__c;
        insert objCM1;
        
        Module__c objModule = new Module__c();
        objmodule.Name = 'Test';
        objModule.Component__c = 'Malaria';
        objModule.Concept_note__c = objCN.Id;
        objModule.Catalog_Module__c = objCM.id;
        insert objModule;
        test.startTest();
        Module__c objModule1 = new Module__c();
        objmodule1.Name = 'Test';
        objModule1.Component__c = 'Malaria';
        objModule1.Concept_note__c = objCN.Id;
        insert objModule1;
        
        Intervention__c objInt = new Intervention__c();
        objInt.Name = 'Test';
        objInt.Module_rel__c = objModule.Id;
        objInt.Concept_note__c = objCN.Id;
        insert objInt;
        
        Catalog_Intervention__c objCI = new Catalog_Intervention__c();
        objCI.Name = 'Test CI';
        objCI.Catalog_Module__c  = objCM.Id;
        insert objCI;
        
        Implementation_Period__c objIP = new Implementation_Period__c();
        objIP.Principal_Recipient__c = objAcc.Id;
        objIP.Concept_Note__c = objCN.id;
        insert objIP;
        
        
        Grant_Intervention__c objGrant_Intervention = TestClassHelper.createGrantIntervention(objIP);
        objGrant_Intervention.Implementation_Period__c = objIP.id;
        objGrant_Intervention.CN_Intervention__c = objInt.id;
        objGrant_Intervention.Standard_or_Custom__c = 'Custom';
        insert objGrant_Intervention;
        test.stopTest();
        
        Apexpages.currentpage().getparameters().put('id',objPage.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objPage);
        ModulesAndInterventions objCls = new ModulesAndInterventions(sc);
        
        objCls.lstCatModules[0].isSelected = true;
        objCls.AddSelectedModule();
        
        Apexpages.currentpage().getparameters().put('ModuleIndex','0');
        Apexpages.currentpage().getparameters().put('interventionIndex','0');
        Apexpages.currentpage().getparameters().put('PRIndex','0');
        objCls.lstModules[0].childInterventions[0].WrapPrShortNameList[0].EditPRName = objAcc.Id;
        objCls.SaveImplementationPeriod();
        objCls.EditImplementationPeriod();
        objCls.CancelImplementationPeriod();
        objCls.DeleteImplementationPeriod();
        
        
        
        Apexpages.currentpage().getparameters().put('parentRowIndex','0');
        objCls.lstModules[0].lstinterventions[0].isSelected = true;
        objCls.AddSelectedIntervention();
        
        Apexpages.currentpage().getparameters().put('ChildEditIndex','0');
        Apexpages.currentpage().getparameters().put('EditIndex','0');
        
        objCls.lstModules[0].childInterventions[0].implementationPeriods[0].isSelected = true;        
        objCls.AddSelectedPR();
        
        
        
        Apexpages.currentpage().getparameters().put('ChildCancelIndex','0');
        Apexpages.currentpage().getparameters().put('CancelIndex','0');
        objCls.CancelInterventionEdit();
         
        Apexpages.currentpage().getparameters().put('EditIndex','0');
        objCls.EditModule();
        
        Apexpages.currentpage().getparameters().put('ChildEditIndex','0');
        Apexpages.currentpage().getparameters().put('EditIndex','0');
        objCls.EditGrantIntervention();
        
        Apexpages.currentpage().getparameters().put('SaveIndex','0');
        objCls.SaveModule(); 
        
        String indexModule = String.valueof(objCls.lstModules.size()+1);
        Apexpages.currentpage().getparameters().put('SaveIndex',indexModule);
        objCls.SaveModule();
        
        Apexpages.currentpage().getparameters().put('ChildSaveIndex','0');
        Apexpages.currentpage().getparameters().put('SaveIndex','0');
        objCls.SaveGrantIntervention();
        
        String indexInt = String.valueof(objCls.lstModules[0].childInterventions.size()+1);
        Apexpages.currentpage().getparameters().put('ChildSaveIndex',indexInt);
        Apexpages.currentpage().getparameters().put('SaveIndex','0');
        objCls.SaveGrantIntervention();
        
        
        Apexpages.currentpage().getparameters().put('CancelIndex','0');
        objCls.CancelModule();
        
        Apexpages.currentpage().getparameters().put('DeleteIndex','0');
        Apexpages.currentpage().getparameters().put('ChildDeleteIndex','1');       
        objCls.DeleteIntervention();
        
        Apexpages.currentpage().getparameters().put('deleteModuleIndex','1');
        objCls.DeleteModule();
        
        
        //Apexpages.currentpage().getparameters().put('parentRowIndex','0');
        //objCls.AddCustomIntervention();
        /*
        */
        
        Profile_Access_Setting_CN__c checkProfile = TestClassHelper.createProfileSettingCN();
        checkProfile.Page_Name__c ='ModulesAndInterventions';
        checkProfile.Salesforce_Item__c = 'External Profile';
        checkProfile.Status__c = 'Not yet submitted'; 
        insert checkProfile;
        objCls.checkProfile(); 
    }
    Public static testMethod void TestModulesAndInterventions2(){
        Account objAcc = new Account();
        objAcc.Name = 'Test Acc';
        objAcc.Short_Name__c = 'MOH';
        insert objAcc;
        
        Template__c objTemplate = new Template__c(Name = 'Test Template');
        insert objTemplate;
        
        Concept_Note__c objCN = TestClassHelper.createCN();
        objCN.Name = 'Test CN';
        objCN.Component__c = 'Malaria';
        objCN.Language__c = 'FRENCH';
        objCN.CCM_new__c = objAcc.Id;
        objCN.Number_of_Years__c = '4';
        objCN.Page_Template__c = objTemplate.Id;
        objCN.Indicative_Amount__c = 10;
        insert objCN;
                        
        Page__c objPage = new Page__c();
        objPage.Concept_note__c = objCN.Id;
        insert objPage;
        
        Catalog_Module__c objCM = new Catalog_Module__c();
        objCM.Name = 'Test CM';
        insert objCM;
        
        Indicator__c objGi = new Indicator__c();   
        objGi.Indicator_Type__c = 'Coverage/Output';
        objGi.Catalog_Module__c = objCM.id;
        insert objGi;
        
        Catalog_Module__c objCM1 = new Catalog_Module__c();
        objCM1.Name = 'Test CM1';
        objCM1.Component__c = 'Malaria';
        objCM1.component_multi__c = objCN.Component__c;
        insert objCM1;
        
        Module__c objModule = new Module__c();
        objmodule.Name = 'Test';
        objModule.Component__c = 'Malaria';
        objModule.Concept_note__c = objCN.Id;
        objModule.Catalog_Module__c = objCM.id;
        insert objModule;
        test.startTest();
        Module__c objModule1 = new Module__c();
        objmodule1.Name = 'Test';
        objModule1.Component__c = 'Malaria';
        objModule1.Concept_note__c = objCN.Id;
        insert objModule1;
        
        Intervention__c objInt = new Intervention__c();
        objInt.Name = 'Test';
        objInt.Module_rel__c = objModule.Id;
        objInt.Concept_note__c = objCN.Id;
        insert objInt;
        
        Catalog_Intervention__c objCI = new Catalog_Intervention__c();
        objCI.Name = 'Test CI';
        objCI.Catalog_Module__c  = objCM.Id;
        insert objCI;
        
        Implementation_Period__c objIP = new Implementation_Period__c();
        objIP.Principal_Recipient__c = objAcc.Id;
        objIP.Concept_Note__c = objCN.id;
        insert objIP;
        
        
        Grant_Intervention__c objGrant_Intervention = TestClassHelper.createGrantIntervention(objIP);
        objGrant_Intervention.Implementation_Period__c = objIP.id;
        objGrant_Intervention.CN_Intervention__c = objInt.id;
        objGrant_Intervention.Standard_or_Custom__c = 'Custom';
        insert objGrant_Intervention;
        test.stopTest();
        
        Apexpages.currentpage().getparameters().put('id',objPage.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objPage);
        ModulesAndInterventions objCls = new ModulesAndInterventions(sc);
        
        objCls.lstCatModules[0].isSelected = true;
        objCls.AddSelectedModule();
        
        Apexpages.currentpage().getparameters().put('ModuleIndex','0');
        Apexpages.currentpage().getparameters().put('interventionIndex','0');
        Apexpages.currentpage().getparameters().put('PRIndex','0');
        objCls.lstModules[0].childInterventions[0].WrapPrShortNameList[0].EditPRName = objAcc.Id;
        objCls.SaveImplementationPeriod();
        objCls.EditImplementationPeriod();
        objCls.CancelImplementationPeriod();
        objCls.DeleteImplementationPeriod();
        
        
        
        Apexpages.currentpage().getparameters().put('parentRowIndex','0');
        objCls.lstModules[0].lstinterventions[0].isSelected = true;
        objCls.AddSelectedIntervention();
        
        Apexpages.currentpage().getparameters().put('ChildEditIndex','0');
        Apexpages.currentpage().getparameters().put('EditIndex','0');
        
        objCls.lstModules[0].childInterventions[0].implementationPeriods[0].isSelected = true;        
        objCls.AddSelectedPR();
        
        
        
        Apexpages.currentpage().getparameters().put('ChildCancelIndex','0');
        Apexpages.currentpage().getparameters().put('CancelIndex','0');
        objCls.CancelInterventionEdit();
         
        Apexpages.currentpage().getparameters().put('EditIndex','0');
        objCls.EditModule();
        
        Apexpages.currentpage().getparameters().put('ChildEditIndex','0');
        Apexpages.currentpage().getparameters().put('EditIndex','0');
        objCls.EditGrantIntervention();
        
        Apexpages.currentpage().getparameters().put('SaveIndex','0');
        objCls.SaveModule(); 
        
        String indexModule = String.valueof(objCls.lstModules.size()+1);
        Apexpages.currentpage().getparameters().put('SaveIndex',indexModule);
        objCls.SaveModule();
        
        Apexpages.currentpage().getparameters().put('ChildSaveIndex','0');
        Apexpages.currentpage().getparameters().put('SaveIndex','0');
        objCls.SaveGrantIntervention();
        
        String indexInt = String.valueof(objCls.lstModules[0].childInterventions.size()+1);
        Apexpages.currentpage().getparameters().put('ChildSaveIndex',indexInt);
        Apexpages.currentpage().getparameters().put('SaveIndex','0');
        objCls.SaveGrantIntervention();
        
        
        Apexpages.currentpage().getparameters().put('CancelIndex','0');
        objCls.CancelModule();
        
        Apexpages.currentpage().getparameters().put('DeleteIndex','0');
        Apexpages.currentpage().getparameters().put('ChildDeleteIndex','1');       
        objCls.DeleteIntervention();
        
        Apexpages.currentpage().getparameters().put('deleteModuleIndex','1');
        objCls.DeleteModule();
        
        Apexpages.currentpage().getparameters().put('ModuleIndex','0');
        Apexpages.currentpage().getparameters().put('interventionIndex','0');
        objCls.SaveCustomIntName();
        //Apexpages.currentpage().getparameters().put('parentRowIndex','0');
        //objCls.AddCustomIntervention();
        /*
        */
        
        Profile_Access_Setting_CN__c checkProfile = TestClassHelper.createProfileSettingCN();
        checkProfile.Page_Name__c ='ModulesAndInterventions';
        checkProfile.Salesforce_Item__c = 'External Profile';
        checkProfile.Status__c = 'Not yet submitted'; 
        insert checkProfile;
        objCls.checkProfile(); 
    }
    Public static testMethod void TestModulesAndInterventions1(){
        Account objAcc = new Account();
        objAcc.Name = 'Test Acc';
        objAcc.Short_Name__c = 'MOH';
        insert objAcc;
        
        Template__c objTemplate = new Template__c(Name = 'Test Template');
        insert objTemplate;
        
        Concept_Note__c objCN = TestClassHelper.createCN();
        objCN.Name = 'Test CN';
        objCN.Component__c = 'Malaria';
        objCN.Language__c = 'SPANISH';
        objCN.CCM_new__c = objAcc.Id;
        objCN.Number_of_Years__c = '4';
        objCN.Page_Template__c = objTemplate.Id;
        objCN.Indicative_Amount__c = 10;
        insert objCN;
                        
        Page__c objPage = new Page__c();
        objPage.Concept_note__c = objCN.Id;
        insert objPage;
        
        Catalog_Module__c objCM = new Catalog_Module__c();
        objCM.Name = 'Test CM';
        insert objCM;
        
        Indicator__c objGi = new Indicator__c();   
        objGi.Indicator_Type__c = 'Coverage/Output';
        objGi.Catalog_Module__c = objCM.id;
        insert objGi;
        
        Catalog_Module__c objCM1 = new Catalog_Module__c();
        objCM1.Name = 'Test CM1';
        objCM1.Component__c = 'Malaria';
        objCM1.component_multi__c = objCN.Component__c;
        insert objCM1;
        
        Module__c objModule = new Module__c();
        objmodule.Name = 'Test';
        objModule.Component__c = 'Malaria';
        objModule.Concept_note__c = objCN.Id;
        objModule.Catalog_Module__c = objCM.id;
        insert objModule;
        test.startTest();
        Module__c objModule1 = new Module__c();
        objmodule1.Name = 'Test';
        objModule1.Component__c = 'Malaria';
        objModule1.Concept_note__c = objCN.Id;
        insert objModule1;
        
        Intervention__c objInt = new Intervention__c();
        objInt.Name = 'Test';
        objInt.Module_rel__c = objModule.Id;
        objInt.Concept_note__c = objCN.Id;
        insert objInt;
        
        Catalog_Intervention__c objCI = new Catalog_Intervention__c();
        objCI.Name = 'Test CI';
        objCI.Catalog_Module__c  = objCM.Id;
        insert objCI;
        
        Implementation_Period__c objIP = new Implementation_Period__c();
        objIP.Principal_Recipient__c = objAcc.Id;
        objIP.Concept_Note__c = objCN.id;
        insert objIP;
        
        
        Grant_Intervention__c objGrant_Intervention = TestClassHelper.createGrantIntervention(objIP);
        objGrant_Intervention.Implementation_Period__c = objIP.id;
        objGrant_Intervention.CN_Intervention__c = objInt.id;
        objGrant_Intervention.Standard_or_Custom__c = 'Custom';
        insert objGrant_Intervention;
        test.stopTest();
        
        Apexpages.currentpage().getparameters().put('id',objPage.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objPage);
        ModulesAndInterventions objCls = new ModulesAndInterventions(sc);
        
        objCls.lstCatModules[0].isSelected = true;
        objCls.AddSelectedModule();
        
        Apexpages.currentpage().getparameters().put('ModuleIndex','0');
        Apexpages.currentpage().getparameters().put('interventionIndex','0');
        Apexpages.currentpage().getparameters().put('PRIndex','0');
        objCls.lstModules[0].childInterventions[0].WrapPrShortNameList[0].EditPRName = objAcc.Id;
        objCls.SaveImplementationPeriod();
        objCls.EditImplementationPeriod();
        objCls.CancelImplementationPeriod();
        objCls.DeleteImplementationPeriod();
        
        
        
        Apexpages.currentpage().getparameters().put('parentRowIndex','0');
        objCls.lstModules[0].lstinterventions[0].isSelected = true;
        objCls.AddSelectedIntervention();
        
        Apexpages.currentpage().getparameters().put('ChildEditIndex','0');
        Apexpages.currentpage().getparameters().put('EditIndex','0');
        
        objCls.lstModules[0].childInterventions[0].implementationPeriods[0].isSelected = true;        
        objCls.AddSelectedPR();
        
        
        
        Apexpages.currentpage().getparameters().put('ChildCancelIndex','0');
        Apexpages.currentpage().getparameters().put('CancelIndex','0');
        objCls.CancelInterventionEdit();
         
        Apexpages.currentpage().getparameters().put('EditIndex','0');
        objCls.EditModule();
        
        Apexpages.currentpage().getparameters().put('ChildEditIndex','0');
        Apexpages.currentpage().getparameters().put('EditIndex','0');
        objCls.EditGrantIntervention();
        
        Apexpages.currentpage().getparameters().put('SaveIndex','0');
        objCls.SaveModule(); 
        
        String indexModule = String.valueof(objCls.lstModules.size()+1);
        Apexpages.currentpage().getparameters().put('SaveIndex',indexModule);
        objCls.SaveModule();
        
        Apexpages.currentpage().getparameters().put('ChildSaveIndex','0');
        Apexpages.currentpage().getparameters().put('SaveIndex','0');
        objCls.SaveGrantIntervention();
        
        String indexInt = String.valueof(objCls.lstModules[0].childInterventions.size()+1);
        Apexpages.currentpage().getparameters().put('ChildSaveIndex',indexInt);
        Apexpages.currentpage().getparameters().put('SaveIndex','0');
        objCls.SaveGrantIntervention();
        
        
        Apexpages.currentpage().getparameters().put('CancelIndex','0');
        objCls.CancelModule();
        
        Apexpages.currentpage().getparameters().put('DeleteIndex','0');
        Apexpages.currentpage().getparameters().put('ChildDeleteIndex','1');       
        objCls.DeleteIntervention();
        
        Apexpages.currentpage().getparameters().put('deleteModuleIndex','1');
        objCls.DeleteModule();
        
        
        //Apexpages.currentpage().getparameters().put('parentRowIndex','0');
        //objCls.AddCustomIntervention();
        /*
        */
        
        Profile_Access_Setting_CN__c checkProfile = TestClassHelper.createProfileSettingCN();
        checkProfile.Page_Name__c ='ModulesAndInterventions';
        checkProfile.Salesforce_Item__c = 'External Profile';
        checkProfile.Status__c = 'Not yet submitted'; 
        insert checkProfile;
        objCls.checkProfile(); 
    }
}