@isTest
Public Class TestRescalingFormula_4feb{
    Public static testMethod void TestRescalingFormula_4feb(){
        

        
        Account objAccount = new Account();
        objAccount.Name = 'Test_Account';
        objAccount.Approval_Status__c ='Approved';
        
        insert objAccount;
     
        
        Template__c objTemplate = new Template__c();
        objTemplate.Name = 'Test Template';
        insert objTemplate;
        
        Band__c objBand =new Band__c();
        objBand.Insufficient_Funds__c = true;
        objBand.Sum_of_P_I_IR_Adjusted_Notional_Funding__c = 200;
        objBand.Sum_of_Eligible_NFAs__c =100;
        objBand.Sum_of_Risk_Adjustments__c = 50;
        objBand.Sum_of_Eligible_Risk_Adjustments__c = 150;
        objBand.Sum_of_NFAs_not_equal_to_EF__c = 100;
       
        insert objBand;
        
        
        Concept_Note__c objCN = new Concept_Note__c();
        objCN.Name = 'Test CN';
        objCN.Component__c = 'Malaria';
        objCN.Language__c = 'ENGLISH';
        objCN.CCM_new__c = objAccount.Id;
        objCN.Number_of_Years__c = '3';
        objCN.Page_Template__c = objTemplate.Id;
        objCN.Eligible_for_Rescaling__c = 'yes';
        objCN.Minimum__c=9999999;
        objCN.Final_Allocation__c=objCN.NFA__c; 
        objCN.Band__c = objBand.id;
        ///-----
        objCN.Existing_Funding__c = 12000;
        objCN.NFA__c = 12000;
        objCN.Allocation_Status__c = 'Underallocated';
        objCN.Theoretical_Adjustment_Stamped_Sum__c = 500;
        objCN.Existing_Funding__c = 999999;
        objCN.Risk_Adjustment__c= 1000;
        
        insert objCN;
        
        
        string ws1= RescalingFormula_4feb.executeRescalingFormula(objBand.id);
      
        objCN.Minimum__c=3;
        objCN.CFA__c= 300;
        objCN.Risk_Adjustment__c=3;
        objCN.Final_Allocation__c= 5400;
        objCN.Eligible_for_Rescaling__c = 'no';
      
        update objCN;
      
        
        objBand.Sum_of_P_I_IR_Adjusted_Notional_Funding__c = 12;
        objBand.Sum_of_Eligible_NFAs__c =12;
        objBand.Sum_of_Risk_Adjustments__c = 10;
        objBand.Sum_of_Eligible_Risk_Adjustments__c = 12;
        objBand.Sum_of_NFAs_not_equal_to_EF__c = 100;
        
        update objBand;
        
        
        objCN.Existing_Funding__c = 100;
        objCN.NFA__c = 100;
        objCN.Allocation_Status__c = 'Underallocated';
        objCN.Theoretical_Adjustment_Stamped_Sum__c = 500;
        objCN.Existing_Funding__c = 100;
        objCN.Risk_Adjustment__c= 100;
        
        update objCN;
        
        string ws2= RescalingFormula_4feb.executeRescalingFormula(objBand.id);
        
        objBand.Sum_of_P_I_IR_Adjusted_Notional_Funding__c = 12000;
        objBand.Sum_of_Eligible_NFAs__c =12000;
        objBand.Sum_of_Risk_Adjustments__c = 100;
        objBand.Sum_of_Eligible_Risk_Adjustments__c = 12000;
        objBand.Sum_of_NFAs_not_equal_to_EF__c = 500;
        
        update objBand;
        
        
        objCN.Existing_Funding__c = 20100;
        objCN.NFA__c = 12200;
        objCN.Allocation_Status__c = 'Underallocated';
        objCN.Theoretical_Adjustment_Stamped_Sum__c = 1500;
        objCN.Existing_Funding__c = 11200;
        objCN.Risk_Adjustment__c= 12200;
        objCN.CFA__c= 10;
        objCN.Maximum__c = 5;
     
        update objCN;
       
        
       
        string ws3= RescalingFormula_4feb.executeRescalingFormula(objBand.id);
       
        objCN.CFA__c= 100;
        objCN.Maximum__c = 50;

        update objCN;
        
       
        string ws4= RescalingFormula_4feb.executeRescalingFormula(objBand.id);
        
        
        
    }
    Public static testMethod void TestRescalingFormula_4febAboveMax(){
        Account objAccount = new Account();
        objAccount.Name = 'Test_Account';
        insert objAccount;
        
        Template__c objTemplate = new Template__c();
        objTemplate.Name = 'Test Template';
        insert objTemplate;
        
        Band__c objBand =new Band__c();
        objBand.Sum_of_P_I_IR_Adjusted_Notional_Funding__c = 12000;
        objBand.Sum_of_Eligible_NFAs__c =12000;
        objBand.Sum_of_Risk_Adjustments__c = 100;
        objBand.Sum_of_Eligible_Risk_Adjustments__c = 12000;
        objBand.Sum_of_NFAs_not_equal_to_EF__c = 500;
        insert objBand;
        
        /*Concept_Note__c objCN = new Concept_Note__c();
        objCN.Name = 'Test CN';
        objCN.Component__c = 'Malaria';
        objCN.Language__c = 'ENGLISH';
        objCN.CCM_new__c = objAccount.Id;
        objCN.Number_of_Years__c = '3';
        objCN.Page_Template__c = objTemplate.Id;
        objCN.Eligible_for_Rescaling__c = 'yes';
        objCN.Minimum__c=9999999;
        objCN.Final_Allocation__c=objCN.NFA__c; 
        objCN.Band__c = objBand.id;
        ///-----
        objCN.Existing_Funding__c = 12000;
        objCN.NFA__c = 12000;
        objCN.Allocation_Status__c = 'Underallocated';
        objCN.Theoretical_Adjustment_Stamped_Sum__c = 500;
        objCN.Existing_Funding__c = 999999;
        objCN.Risk_Adjustment__c= 1000;
        insert objCN;
        
        objCN.Existing_Funding__c = 0;
        update objCN;
        string ws4= RescalingFormula_4feb.executeRescalingFormula(objBand.id);*/
        
        Concept_Note__c objCN1 = new Concept_Note__c();
        objCN1.Name = 'Test CN';
        objCN1.Component__c = 'Malaria';
        objCN1.Language__c = 'ENGLISH';
        objCN1.CCM_new__c = objAccount.Id;
        objCN1.Number_of_Years__c = '3';
        objCN1.Page_Template__c = objTemplate.Id;
        objCN1.Eligible_for_Rescaling__c = 'yes';
        objCN1.Maximum__c= 999999999;
        objCN1.CFA__c= 99;
        objCN1.Final_Allocation__c=objCN1.NFA__c; 
        objCN1.Band__c = objBand.id;
        ///-----
        
        objCN1.NFA__c = 120;
        objCN1.Allocation_Status__c = 'Underallocated';
        objCN1.Theoretical_Adjustment_Stamped_Sum__c = 500;
        objCN1.Existing_Funding__c = 9;
        objCN1.Risk_Adjustment__c= 10;
        insert objCN1;
        
        //string ws5= RescalingFormula_4feb.executeRescalingFormula(objBand.id);
        RescalingFormula_4feb.getlstBelowMax(objBand.id);
        RescalingFormula_4feb.setAboveMaxToMax(objBand.id);
        RescalingFormula_4feb.executeRescalingUp(objBand.id);
        RescalingFormula_4feb.getIntDenomUp(objBand.id);
        RescalingFormula_4feb.getIntDenomDown(objBand.id);
        
        
        RescalingFormula_4feb.getIntExcess(objBand.id);
        RescalingFormula_4feb.executeRescalingDown(objBand.id);
        
        
        
    }
}