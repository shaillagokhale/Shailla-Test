@isTest
Public Class TestctrlHealthProducts{
    Public static testMethod void TestctrlHealthProducts(){
        /*Account objAcc = new Account();
        objAcc.Name = 'Test Acc';
        insert objAcc;*/
        
         Account objAcc = TestClassHelper.insertAccount();
        
        Template__c objTemplate = new Template__c(Name = 'Test Template');
        insert objTemplate;
        test.startTest();
        Grant__c objGrant  = TestClassHelper.insertGrant(objAcc);
        
        Concept_Note__c objCN = new Concept_Note__c();
        objCN.Name = 'Test CN';
        objCN.Component__c = 'Malaria';
        objCN.Language__c = 'ENGLISH';
        objCN.CCM_new__c = objAcc.Id;
        objCN.Number_of_Years__c = '3';
        objCN.Page_Template__c = objTemplate.Id;
        insert objCN;
        
        PSM__c objPSM = new PSM__c();
        objPSM.Name = 'Test PSM Cost';
        insert objPSM;
        
        
        Implementation_Period__c objIP = new Implementation_Period__c();
        objIP.Principal_Recipient__c = objAcc.id;        
        objIP.Length_Years__c = '4';
        insert objIP;
       
        
        Catalog_Cost_Input__c objCI = new Catalog_Cost_Input__c();
        objCI.PSM__c = true;
        objCI.Disease_Impact__c = 'Malaria';
        objCI.GIS_ID__c = 123;
        objCI.Is_inactive__c = false;
        insert objCI;
        
        Catalog_Generic_Product__c objGP = new Catalog_Generic_Product__c();
        objGP.Catalog_Cost_Input__c = objCI.Id;
        objGP.name = 'Test GP';
        objGP.Product_Category__c = 'Test';
        objGP.GIS_ID__c = 123;
        insert objGP;
        
        Catalog_Product__c objCP = new Catalog_Product__c();
        objCP.Generic_Product__c = objGP.Id;
        objCP.Strength_Shape__c = 'Test';
        objCP.Unit__c = 'Test';
        objCP.GIS_ID__c = 123;
        insert objCP;       
        
        Product__c objProduct = new product__c();
        objProduct.Implementation_Period__c = objIP.Id;
        objProduct.Catalog_Product__c = objCP.Id;
        objProduct.Product_Main_Category__c = 'Pharmaceuticals';
        insert objProduct;
        
        Product__c objProduct1 = new product__c();
        objProduct1.Implementation_Period__c = objIP.Id;
        objProduct1.Catalog_Product__c = objCP.Id;
        objProduct1.Product_Main_Category__c = 'PSM Cost';
        insert objProduct1;
        
        
        
        Intervention__c objInt = new Intervention__c();
        objInt.Name = 'test Int';
        objInt.Concept_note__c = objCN.Id;
        insert objInt;
        
       /* PSM_Intervention_Split__c objPSm = new PSM_Intervention_Split__c();
        objPSm.Product__c = objProduct.Id;
        objPSm.Intervention__c = objInt.id;
        objPSm.Y1__c = 10;
        objPSm.Y2__c = 10;
        objPSm.Y3__c = 10;
        objPSm.Y4__c = 10;
        insert objPSm;*/
        
        Page__c objPage = new Page__c();
        objPage.Implementation_Period__c = objIP.Id;
        insert objPage;
        
        
        Grant_Intervention__c objGi = new Grant_Intervention__c();
        objGi.name = 'Test';
        objGi.Implementation_Period__c = objIP.Id;
        insert objGi;
        test.stopTest();
        
        PSM_Intervention_Split__c objPI = new PSM_Intervention_Split__c();
        objPI.Product__c = objProduct.id;
        objPI.Intervention__c = objGi.id;
        objPI.Y1__c = 10;
        objPI.Y2__c = 10;
        objPI.Y3__c = 10;
        objPI.Y4__c = 10;
        insert objPI;
         
        
        Apexpages.currentpage().getparameters().put('id',objPage.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objPage);
        ctrlHealthProducts objHP = new ctrlHealthProducts(sc);
        
        objHP.strSelectedCatagory  = 'Pharmaceuticals';
        objHP.selectedCatagory();
        
        objHP.ConvertIntervention();
        
       
       
        Apexpages.currentpage().getparameters().put('EditIndex','0');
        objHP.EditProduct();
        
        Apexpages.currentpage().getparameters().put('ChangeIndexGP','0');
        Apexpages.currentpage().getparameters().put('CostInputId',objCI.Id);
        objHP.fillGenericProduct();
        
        //objHP.objNewProduct = new wrapProducts();
        objHP.objNewProduct.strCostInputName = objCI.Id;
        objHP.fillGenericProductNew();
        
        Apexpages.currentpage().getparameters().put('ChangeIndex','0');
        Apexpages.currentpage().getparameters().put('GenericProductId',objGP.Id);
        objHP.fillStrenthAndUnit();
        
        objHP.objNewProduct.strGenericProductName = objGP.Id;
        objHP.fillStrenthAndUnitNew();
        
        Apexpages.currentpage().getparameters().put('CancelIndex','0');
        objHP.CancelProduct();
        
       
        Apexpages.currentpage().getparameters().put('SaveIndex','0');
        Apexpages.currentpage().getparameters().put('CPId',objCP.Id);
        objHP.SaveProduct();
        
        Apexpages.currentpage().getparameters().put('SaveIndex','2');
        Apexpages.currentpage().getparameters().put('CPId',objCP.Id);
        //Test.startTest();
        objHP.SaveProduct();
       
        
        Apexpages.currentpage().getparameters().put('CancelBLIndex','0');
        objHP.CancelDialogeBox();
        
        Apexpages.currentpage().getparameters().put('SaveBLIndex','0');
        objHP.SaveDialogeBox();
        
        Apexpages.currentpage().getparameters().put('OpenBLIndex','0');
        objHP.OpenDialogeBoxRecord();
        
       
        
      /* Apexpages.currentpage().getparameters().put('SaveIndex','0');
       objHP.SavePSMCost();*/
        
       /* Apexpages.currentpage().getparameters().put('EditIndex','0');
        objHP.EditPSMCost();
        
        */
        
        Apexpages.currentpage().getparameters().put('OpenIndex','0');
         
         
        objHP.CancelInterventionSplitPopup();
        
        objHP.OpenInterventionSplitPopup();
        
        objHP.AddPSMSplit();
        
        objHP.SavePSMSplit();
        
      //  Apexpages.currentpage().getparameters().put('DeleteIndex','0');
       // objHP.DeletePSMSplit();
         
        Apexpages.currentpage().getparameters().put('DeleteIndex','0');
        objHP.DeleteProduct();
        
        
        
         
         
        
    }
}