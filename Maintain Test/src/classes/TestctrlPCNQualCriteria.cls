@IsTest

Private Class TestctrlPCNQualCriteria{
    Static testmethod void TestctrlPCNQualCriteria(){
        List<RecordType> lstRecordTypes = New List<RecordType>([Select Id from RecordType where sobjectType = 'PCN_Criteria__c' And 
              (RecordType.DeveloperName = 'Performance' OR RecordType.DeveloperName = 'Impact' OR RecordType.DeveloperName = 'Increasing_Rate_of_Infection' 
              OR RecordType.DeveloperName = 'Risk' OR RecordType.DeveloperName = 'Absorptive_Capacity' OR RecordType.DeveloperName = 'Final_Allocation_Absorptive_Capacity')]);

        Account objAcct = new Account();
        objAcct.Name = 'Test Acct';
        insert objAcct;
        
        
        Concept_Note__c objCN = new Concept_Note__c();
        objCN.Name = 'Test CN';
        objCN.CCM_New__c = objAcct.id;
        objCN.Start_Date__c = system.today();
        objCN.Funding_End_Date__c = system.today();
        objCN.P_I_IR_and_Risk_Status__c ='Under Review';   
        insert objCN;
        
        PCN_Criteria__c objPCNPerformance = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[4].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNPerformance;
        
        PCN_Criteria__c objPCNImpact = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[2].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNImpact;
        
        PCN_Criteria__c objPCNIRI = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[3].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNIRI;
        
        PCN_Criteria__c objPCNRISK = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[5].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNRISK;
                
        PCN_Criteria__c objPCNFAC = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[1].Id,Concept_Note__c = objCN.Id,Country_Team_Justification__c='test',Status__c = 'Accepted');
        Insert objPCNFAC;
        
        PCN_Criteria__c objPCNAC = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[0].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNAC;
        
        //User objUser = [Select Id from User Limit 1];
        Attachment objAttach = New Attachment(Name = 'TestAttach',Description='Descri',ParentId = objPCNPerformance.Id,Body=blob.valueof('tttt'));
        Insert objAttach;
        
        FeedItem objFI = New FeedItem(ContentFileName = 'TestFI.txt',ContentData=blob.valueof('tttt'),ParentId = objPCNPerformance.Id);
        Insert objFI;        
      
        Apexpages.currentpage().getParameters().put('id',objCN.id);
        ApexPages.currentPage().getHeaders().put('Host','https://theglobalfund--modules--c.cs17.visual.force.com');
         
        ApexPages.StandardController std = new ApexPages.StandardController(objCN);
        ctrlPCNQualCriteria obj = new ctrlPCNQualCriteria(std);
        obj.AddNewFile();
        obj.AddNewFileOtherConsideration();
        obj.AddNewFileFinalOtherConsideration();
        obj.strRecordTypeName = 'Performance';
        obj.changePCNStatusToAccepted();
        obj.fillFunctionalTeamFileList(New List<Attachment>{objAttach},New List<FeedItem>{objFI});
        obj.retrieveFunctionalTeamFiles();
        obj.retrievePCNRequestUpdateInformation();
        obj.uploadPCNRequestUpdatedFile();
        obj.savePCNRequestUpdated();
        obj.changePCNStatusToRequestUpdated();
        obj.changePCNStatusToRequestUpdatedSubmitted();
        
        obj.strRecordTypeName = 'Absorptive_Capacity';   
        obj.SetCapAmountPopUp();
        obj.SubmitOtherConsiderations();
        
        obj.strRecordTypeName = 'Final_Allocation_Absorptive_Capacity';   
        obj.SetCapAmountPopUp();
        obj.SubmitOtherConsiderations();
        
        
        obj.SubmitAbsorptiveCapacity();
        obj.SubmitAll();
        
        Apexpages.currentpage().getParameters().put('RecordType','Absorptive_Capacity');        
        obj.uploadOtherConsiderationsFiles();
        Apexpages.currentpage().getParameters().put('RecordType','Final_Allocation_Absorptive_Capacity'); 
        obj.uploadOtherConsiderationsFiles();
        
        
        obj.SetStatusImpactPerformance();
        obj.Submit();
        
        obj.lstFeedItemsFinalOtherConsideration = New List<FeedItem>();
        obj.lstFeedItemsFinalOtherConsideration.Add(objFI);
        
        Apexpages.currentpage().getParameters().put('FOIndex','0');
        obj.removeFinalOtherConsiderationFile();
        
        obj.lstPerformance[0].Status__c = 'Accepted';
        obj.lstImpact[0].Status__c = 'Accepted';
        obj.lstIncreasingReatofInfection[0].Status__c = 'Accepted';
        obj.lstRisk[0].Status__c = 'Accepted';
        obj.SubmitAll();
        
    }
    
    Static testmethod void TestctrlPCNQualCriteria1(){
        List<RecordType> lstRecordTypes = New List<RecordType>([Select Id from RecordType where sobjectType = 'PCN_Criteria__c' And 
              (RecordType.DeveloperName = 'Performance' OR RecordType.DeveloperName = 'Impact' OR RecordType.DeveloperName = 'Increasing_Rate_of_Infection' 
              OR RecordType.DeveloperName = 'Risk' OR RecordType.DeveloperName = 'Absorptive_Capacity' OR RecordType.DeveloperName = 'Final_Allocation_Absorptive_Capacity')]);

        Account objAcct = new Account();
        objAcct.Name = 'Test Acct';
        insert objAcct;        
        
        Concept_Note__c objCN = new Concept_Note__c();
        objCN.Name = 'Test CN';
        objCN.CCM_New__c = objAcct.id;
        objCN.Start_Date__c = system.today();
        objCN.Funding_End_Date__c = system.today();
        objCN.P_I_IR_and_Risk_Status__c ='Under Review';   
        insert objCN;
        
        PCN_Criteria__c objPCNPerformance = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[4].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNPerformance;
        
        PCN_Criteria__c objPCNImpact = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[2].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNImpact;
        
        PCN_Criteria__c objPCNIRI = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[3].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNIRI;
        
        PCN_Criteria__c objPCNRISK = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[5].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNRISK;
                
        PCN_Criteria__c objPCNFAC = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[1].Id,Concept_Note__c = objCN.Id,Country_Team_Justification__c='test',Status__c = 'Accepted');
        Insert objPCNFAC;
        
        PCN_Criteria__c objPCNAC = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[0].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNAC;
        
        //User objUser = [Select Id from User Limit 1];
        Attachment objAttach = New Attachment(Name = 'TestAttach',Description='Descri',ParentId = objPCNPerformance.Id,Body=blob.valueof('tttt'));
        Insert objAttach;
        
        FeedItem objFI = New FeedItem(ContentFileName = 'TestFI.txt',ContentData=blob.valueof('tttt'),ParentId = objPCNPerformance.Id);
        Insert objFI;        
      
        Apexpages.currentpage().getParameters().put('id',objCN.id);
        ApexPages.currentPage().getHeaders().put('Host','https://theglobalfund--modules--c.cs17.visual.force.com');
         
        ApexPages.StandardController std = new ApexPages.StandardController(objCN);
        ctrlPCNQualCriteria obj = new ctrlPCNQualCriteria(std);
        obj.AddNewFile();
        obj.AddNewFileOtherConsideration();
        obj.AddNewFileFinalOtherConsideration();
        obj.strRecordTypeName = 'Impact';
        obj.changePCNStatusToAccepted();
        obj.fillFunctionalTeamFileList(New List<Attachment>{objAttach},New List<FeedItem>{objFI});
        obj.retrieveFunctionalTeamFiles();
        obj.retrievePCNRequestUpdateInformation();
        obj.uploadPCNRequestUpdatedFile();
        obj.savePCNRequestUpdated();
        obj.changePCNStatusToRequestUpdated();
        obj.changePCNStatusToRequestUpdatedSubmitted();
        
        obj.strRecordTypeName = 'Absorptive_Capacity';   
        obj.SetCapAmountPopUp();
        obj.SubmitOtherConsiderations();
        
        obj.strRecordTypeName = 'Final_Allocation_Absorptive_Capacity';   
        obj.SetCapAmountPopUp();
        obj.SubmitOtherConsiderations();
        
        
        obj.SubmitAbsorptiveCapacity();
        obj.SubmitAll();
        
        Apexpages.currentpage().getParameters().put('RecordType','Absorptive_Capacity');        
        obj.uploadOtherConsiderationsFiles();
        Apexpages.currentpage().getParameters().put('RecordType','Final_Allocation_Absorptive_Capacity'); 
        obj.uploadOtherConsiderationsFiles();
        
        
        obj.SetStatusImpactPerformance();
        obj.Submit();
        
        Apexpages.currentpage().getParameters().put('Index','0');
        obj.removeRequestUpdateUploadFiles();
        
        Apexpages.currentpage().getParameters().put('OIndex','0');
        obj.removeOtherConsiderationFile();
        
        obj.lstPerformance[0].Status__c = 'Accepted';
        obj.lstImpact[0].Status__c = 'Accepted';
        obj.lstIncreasingReatofInfection[0].Status__c = 'Accepted';
        obj.lstRisk[0].Status__c = 'Accepted';
        obj.SubmitAll();
    }
    
    Static testmethod void TestctrlPCNQualCriteria2(){
        List<RecordType> lstRecordTypes = New List<RecordType>([Select Id from RecordType where sobjectType = 'PCN_Criteria__c' And 
              (RecordType.DeveloperName = 'Performance' OR RecordType.DeveloperName = 'Impact' OR RecordType.DeveloperName = 'Increasing_Rate_of_Infection' 
              OR RecordType.DeveloperName = 'Risk' OR RecordType.DeveloperName = 'Absorptive_Capacity' OR RecordType.DeveloperName = 'Final_Allocation_Absorptive_Capacity')]);

        Account objAcct = new Account();
        objAcct.Name = 'Test Acct';
        insert objAcct;       
        
        Concept_Note__c objCN = new Concept_Note__c();
        objCN.Name = 'Test CN';
        objCN.CCM_New__c = objAcct.id;
        objCN.Start_Date__c = system.today();
        objCN.Funding_End_Date__c = system.today();
        objCN.P_I_IR_and_Risk_Status__c ='Under Review';   
        insert objCN;
        
        PCN_Criteria__c objPCNPerformance = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[4].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNPerformance;
        
        PCN_Criteria__c objPCNImpact = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[2].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNImpact;
        
        PCN_Criteria__c objPCNIRI = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[3].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNIRI;
        
        PCN_Criteria__c objPCNRISK = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[5].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNRISK;
                
        PCN_Criteria__c objPCNFAC = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[1].Id,Concept_Note__c = objCN.Id,Country_Team_Justification__c='test',Status__c = 'Accepted');
        Insert objPCNFAC;
        
        PCN_Criteria__c objPCNAC = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[0].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNAC;
        
        //User objUser = [Select Id from User Limit 1];
        Attachment objAttach = New Attachment(Name = 'TestAttach',Description='Descri',ParentId = objPCNPerformance.Id,Body=blob.valueof('tttt'));
        Insert objAttach;
        
        FeedItem objFI = New FeedItem(ContentFileName = 'TestFI.txt',ContentData=blob.valueof('tttt'),ParentId = objPCNPerformance.Id);
        Insert objFI;        
      
        Apexpages.currentpage().getParameters().put('id',objCN.id);
        ApexPages.currentPage().getHeaders().put('Host','https://theglobalfund--modules--c.cs17.visual.force.com');
         
        ApexPages.StandardController std = new ApexPages.StandardController(objCN);
        ctrlPCNQualCriteria obj = new ctrlPCNQualCriteria(std);
        obj.AddNewFile();
        obj.AddNewFileOtherConsideration();
        obj.AddNewFileFinalOtherConsideration();
        obj.strRecordTypeName = 'Risk';
        obj.changePCNStatusToAccepted();
        obj.fillFunctionalTeamFileList(New List<Attachment>{objAttach},New List<FeedItem>{objFI});
        obj.retrieveFunctionalTeamFiles();
        obj.retrievePCNRequestUpdateInformation();
        obj.uploadPCNRequestUpdatedFile();
        obj.savePCNRequestUpdated();
        obj.changePCNStatusToRequestUpdated();
        obj.changePCNStatusToRequestUpdatedSubmitted();
        
        obj.strRecordTypeName = 'Absorptive_Capacity';   
        obj.SetCapAmountPopUp();
        obj.SubmitOtherConsiderations();
        
        obj.strRecordTypeName = 'Final_Allocation_Absorptive_Capacity';   
        obj.SetCapAmountPopUp();
        obj.SubmitOtherConsiderations();
        
        
        obj.SubmitAbsorptiveCapacity();
        obj.SubmitAll();
        
        Apexpages.currentpage().getParameters().put('RecordType','Absorptive_Capacity');        
        obj.uploadOtherConsiderationsFiles();
        Apexpages.currentpage().getParameters().put('RecordType','Final_Allocation_Absorptive_Capacity'); 
        obj.uploadOtherConsiderationsFiles();
        
        obj.SetStatusImpactPerformance();
        obj.Submit();
        
        obj.lstPerformance[0].Status__c = 'Accepted';
        obj.lstImpact[0].Status__c = 'Accepted';
        obj.lstIncreasingReatofInfection[0].Status__c = 'Accepted';
        obj.lstRisk[0].Status__c = 'Accepted';
        obj.SubmitAll();
    }
    
    Static testmethod void TestctrlPCNQualCriteria3(){
        List<RecordType> lstRecordTypes = New List<RecordType>([Select Id from RecordType where sobjectType = 'PCN_Criteria__c' And 
              (RecordType.DeveloperName = 'Performance' OR RecordType.DeveloperName = 'Impact' OR RecordType.DeveloperName = 'Increasing_Rate_of_Infection' 
              OR RecordType.DeveloperName = 'Risk' OR RecordType.DeveloperName = 'Absorptive_Capacity' OR RecordType.DeveloperName = 'Final_Allocation_Absorptive_Capacity')]);

        Account objAcct = new Account();
        objAcct.Name = 'Test Acct';
        insert objAcct;
        
        Concept_Note__c objCN = new Concept_Note__c();
        objCN.Name = 'Test CN';
        objCN.CCM_New__c = objAcct.id;
        objCN.Start_Date__c = system.today();
        objCN.Funding_End_Date__c = system.today();
        objCN.P_I_IR_and_Risk_Status__c ='Under Review';   
        insert objCN;
        
        PCN_Criteria__c objPCNPerformance = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[4].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNPerformance;
        
        PCN_Criteria__c objPCNImpact = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[2].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNImpact;
        
        PCN_Criteria__c objPCNIRI = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[3].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNIRI;
        
        PCN_Criteria__c objPCNRISK = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[5].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNRISK;
                
        PCN_Criteria__c objPCNFAC = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[1].Id,Concept_Note__c = objCN.Id,Country_Team_Justification__c='test',Status__c = 'Accepted');
        Insert objPCNFAC;
        
        PCN_Criteria__c objPCNAC = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[0].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNAC;
        
        //User objUser = [Select Id from User Limit 1];
        Attachment objAttach = New Attachment(Name = 'TestAttach',Description='Descri',ParentId = objPCNPerformance.Id,Body=blob.valueof('tttt'));
        Insert objAttach;
        
        FeedItem objFI = New FeedItem(ContentFileName = 'TestFI.txt',ContentData=blob.valueof('tttt'),ParentId = objPCNPerformance.Id);
        Insert objFI;        
      
        Apexpages.currentpage().getParameters().put('id',objCN.id);
        ApexPages.currentPage().getHeaders().put('Host','https://theglobalfund--modules--c.cs17.visual.force.com');
         
        ApexPages.StandardController std = new ApexPages.StandardController(objCN);
        ctrlPCNQualCriteria obj = new ctrlPCNQualCriteria(std);
        obj.AddNewFile();
        obj.AddNewFileOtherConsideration();
        obj.AddNewFileFinalOtherConsideration();
        obj.strRecordTypeName = 'Increasing_Rate_of_Infection';
        obj.changePCNStatusToAccepted();
        obj.fillFunctionalTeamFileList(New List<Attachment>{objAttach},New List<FeedItem>{objFI});
        obj.retrieveFunctionalTeamFiles();
        obj.retrievePCNRequestUpdateInformation();
        obj.uploadPCNRequestUpdatedFile();
        obj.savePCNRequestUpdated();
        obj.changePCNStatusToRequestUpdated();
        obj.changePCNStatusToRequestUpdatedSubmitted();
        
        obj.strRecordTypeName = 'Absorptive_Capacity';   
        obj.SetCapAmountPopUp();
        obj.SubmitOtherConsiderations();
        
        obj.strRecordTypeName = 'Final_Allocation_Absorptive_Capacity';   
        obj.SetCapAmountPopUp();
        obj.SubmitOtherConsiderations();
        
        
        obj.SubmitAbsorptiveCapacity();
        obj.SubmitAll();
        
        Apexpages.currentpage().getParameters().put('RecordType','Absorptive_Capacity');        
        obj.uploadOtherConsiderationsFiles();
        Apexpages.currentpage().getParameters().put('RecordType','Final_Allocation_Absorptive_Capacity'); 
        obj.uploadOtherConsiderationsFiles();
        
        obj.SetStatusImpactPerformance();
        obj.Submit();
        
        obj.lstPerformance[0].Status__c = 'Accepted';
        obj.lstImpact[0].Status__c = 'Accepted';
        obj.lstIncreasingReatofInfection[0].Status__c = 'Accepted';
        obj.lstRisk[0].Status__c = 'Accepted';
        obj.SubmitAll();
    }
    
    Static testmethod void TestctrlPCNQualCriteria4(){
        List<RecordType> lstRecordTypes = New List<RecordType>([Select Id from RecordType where sobjectType = 'PCN_Criteria__c' And 
              (RecordType.DeveloperName = 'Performance' OR RecordType.DeveloperName = 'Impact' OR RecordType.DeveloperName = 'Increasing_Rate_of_Infection' 
              OR RecordType.DeveloperName = 'Risk' OR RecordType.DeveloperName = 'Absorptive_Capacity' OR RecordType.DeveloperName = 'Final_Allocation_Absorptive_Capacity')]);

        Account objAcct = new Account();
        objAcct.Name = 'Test Acct';
        insert objAcct;        
        
        Concept_Note__c objCN = new Concept_Note__c();
        objCN.Name = 'Test CN';
        objCN.CCM_New__c = objAcct.id;
        objCN.Start_Date__c = system.today();
        objCN.Funding_End_Date__c = system.today();
        objCN.P_I_IR_and_Risk_Status__c ='Under Review';   
        insert objCN;
        
        PCN_Criteria__c objPCNPerformance = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[4].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNPerformance;
        
        PCN_Criteria__c objPCNImpact = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[2].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNImpact;
        
        PCN_Criteria__c objPCNIRI = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[3].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNIRI;
        
        PCN_Criteria__c objPCNRISK = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[5].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNRISK;
                
        PCN_Criteria__c objPCNFAC = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[1].Id,Concept_Note__c = objCN.Id,Country_Team_Justification__c='test',Status__c = 'Accepted');
        Insert objPCNFAC;
        
        PCN_Criteria__c objPCNAC = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[0].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNAC;
        
        //User objUser = [Select Id from User Limit 1];
        Attachment objAttach = New Attachment(Name = 'TestAttach',Description='Descri',ParentId = objPCNPerformance.Id,Body=blob.valueof('tttt'));
        Insert objAttach;
        
        FeedItem objFI = New FeedItem(ContentFileName = 'TestFI.txt',ContentData=blob.valueof('tttt'),ParentId = objPCNPerformance.Id);
        Insert objFI;        
      
        Apexpages.currentpage().getParameters().put('id',objCN.id);
        ApexPages.currentPage().getHeaders().put('Host','https://theglobalfund--modules--c.cs17.visual.force.com');
         
        ApexPages.StandardController std = new ApexPages.StandardController(objCN);
        ctrlPCNQualCriteria obj = new ctrlPCNQualCriteria(std);
        obj.strShowJustifiedAllocation = 'Justified Allocation';
        obj.AddNewFile();
        obj.AddNewFileOtherConsideration();
        obj.AddNewFileFinalOtherConsideration();
        obj.strRecordTypeName = 'Absorptive_Capacity';
        obj.changePCNStatusToAccepted();
        obj.fillFunctionalTeamFileList(New List<Attachment>{objAttach},New List<FeedItem>{objFI});
        obj.retrieveFunctionalTeamFiles();
        obj.retrievePCNRequestUpdateInformation();
        obj.uploadPCNRequestUpdatedFile();
        obj.savePCNRequestUpdated();
        obj.changePCNStatusToRequestUpdated();
        obj.changePCNStatusToRequestUpdatedSubmitted();
        
        obj.strRecordTypeName = 'Absorptive_Capacity';   
        obj.SetCapAmountPopUp();
        obj.SubmitOtherConsiderations();
        
        obj.strRecordTypeName = 'Final_Allocation_Absorptive_Capacity';   
        obj.SetCapAmountPopUp();
        obj.SubmitOtherConsiderations();
        
        
        obj.SubmitAbsorptiveCapacity();
        obj.SubmitAll();
        
        Apexpages.currentpage().getParameters().put('RecordType','Absorptive_Capacity');        
        obj.uploadOtherConsiderationsFiles();
        Apexpages.currentpage().getParameters().put('RecordType','Final_Allocation_Absorptive_Capacity'); 
        obj.uploadOtherConsiderationsFiles();
        
        obj.SetStatusImpactPerformance();
        obj.Submit();
        
        obj.lstPerformance[0].Status__c = 'Accepted';
        obj.lstImpact[0].Status__c = 'Accepted';
        obj.lstIncreasingReatofInfection[0].Status__c = 'Accepted';
        obj.lstRisk[0].Status__c = 'Accepted';
        obj.SubmitAll();
    }
    
    Static testmethod void TestctrlPCNQualCriteria5(){
        List<RecordType> lstRecordTypes = New List<RecordType>([Select Id from RecordType where sobjectType = 'PCN_Criteria__c' And 
              (RecordType.DeveloperName = 'Performance' OR RecordType.DeveloperName = 'Impact' OR RecordType.DeveloperName = 'Increasing_Rate_of_Infection' 
              OR RecordType.DeveloperName = 'Risk' OR RecordType.DeveloperName = 'Absorptive_Capacity' OR RecordType.DeveloperName = 'Final_Allocation_Absorptive_Capacity')]);

        Account objAcct = new Account();
        objAcct.Name = 'Test Acct';
        insert objAcct;
        
        Concept_Note__c objCN = new Concept_Note__c();
        objCN.Name = 'Test CN';
        objCN.CCM_New__c = objAcct.id;
        objCN.Start_Date__c = system.today();
        objCN.Funding_End_Date__c = system.today();
        objCN.P_I_IR_and_Risk_Status__c ='Under Review';   
        insert objCN;
        
        PCN_Criteria__c objPCNPerformance = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[4].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNPerformance;
        
        PCN_Criteria__c objPCNImpact = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[2].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNImpact;
        
        PCN_Criteria__c objPCNIRI = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[3].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNIRI;
        
        PCN_Criteria__c objPCNRISK = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[5].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNRISK;
                
        PCN_Criteria__c objPCNFAC = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[1].Id,Concept_Note__c = objCN.Id,Country_Team_Justification__c='test',Status__c = 'Accepted');
        Insert objPCNFAC;
        
        PCN_Criteria__c objPCNAC = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[0].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNAC;
        
        //User objUser = [Select Id from User Limit 1];
        Attachment objAttach = New Attachment(Name = 'TestAttach',Description='Descri',ParentId = objPCNPerformance.Id,Body=blob.valueof('tttt'));
        Insert objAttach;
        
        FeedItem objFI = New FeedItem(ContentFileName = 'TestFI.txt',ContentData=blob.valueof('tttt'),ParentId = objPCNPerformance.Id);
        Insert objFI;        
      
        Apexpages.currentpage().getParameters().put('id',objCN.id);
        ApexPages.currentPage().getHeaders().put('Host','https://theglobalfund--modules--c.cs17.visual.force.com');
         
        ApexPages.StandardController std = new ApexPages.StandardController(objCN);
        ctrlPCNQualCriteria obj = new ctrlPCNQualCriteria(std);
        obj.AddNewFile();
        obj.AddNewFileOtherConsideration();
        obj.AddNewFileFinalOtherConsideration();
        obj.strRecordTypeName = 'Absorptive_Capacity';
        obj.changePCNStatusToAccepted();
        obj.fillFunctionalTeamFileList(New List<Attachment>{objAttach},New List<FeedItem>{objFI});
        obj.retrieveFunctionalTeamFiles();
        obj.retrievePCNRequestUpdateInformation();
        obj.uploadPCNRequestUpdatedFile();
        obj.savePCNRequestUpdated();
        obj.changePCNStatusToRequestUpdated();
        obj.changePCNStatusToRequestUpdatedSubmitted();
        
        obj.strRecordTypeName = 'Absorptive_Capacity';   
        obj.SetCapAmountPopUp();
        obj.SubmitOtherConsiderations();
        
        obj.strRecordTypeName = 'Final_Allocation_Absorptive_Capacity';   
        obj.SetCapAmountPopUp();
        obj.SubmitOtherConsiderations();
        
        
        obj.SubmitAbsorptiveCapacity();
        obj.SubmitAll();
        
        Apexpages.currentpage().getParameters().put('RecordType','Absorptive_Capacity');        
        obj.uploadOtherConsiderationsFiles();
        Apexpages.currentpage().getParameters().put('RecordType','Final_Allocation_Absorptive_Capacity'); 
        obj.uploadOtherConsiderationsFiles();
        
        obj.SetStatusImpactPerformance();
        obj.Submit();
        
        obj.lstPerformance[0].Status__c = 'Accepted';
        obj.lstImpact[0].Status__c = 'Accepted';
        obj.lstIncreasingReatofInfection[0].Status__c = 'Accepted';
        obj.lstRisk[0].Status__c = 'Accepted';
        obj.SubmitAll();
    }
    
    Static testmethod void TestctrlPCNQualCriteria6(){
        List<RecordType> lstRecordTypes = New List<RecordType>([Select Id from RecordType where sobjectType = 'PCN_Criteria__c' And 
              (RecordType.DeveloperName = 'Performance' OR RecordType.DeveloperName = 'Impact' OR RecordType.DeveloperName = 'Increasing_Rate_of_Infection' 
              OR RecordType.DeveloperName = 'Risk' OR RecordType.DeveloperName = 'Absorptive_Capacity' OR RecordType.DeveloperName = 'Final_Allocation_Absorptive_Capacity')]);

        Account objAcct = new Account();
        objAcct.Name = 'Test Acct';
        insert objAcct;     
        
        Concept_Note__c objCN = new Concept_Note__c();
        objCN.Name = 'Test CN';
        objCN.CCM_New__c = objAcct.id;
        objCN.Start_Date__c = system.today();
        objCN.Funding_End_Date__c = system.today();
        objCN.P_I_IR_and_Risk_Status__c ='Under Review';   
        insert objCN;
        
        PCN_Criteria__c objPCNPerformance = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[4].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNPerformance;
        
        PCN_Criteria__c objPCNImpact = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[2].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNImpact;
        
        PCN_Criteria__c objPCNIRI = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[3].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNIRI;
        
        PCN_Criteria__c objPCNRISK = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[5].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNRISK;
                
        PCN_Criteria__c objPCNFAC = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[1].Id,Concept_Note__c = objCN.Id,Country_Team_Justification__c='test',Status__c = 'Accepted');
        Insert objPCNFAC;
        
        PCN_Criteria__c objPCNAC = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[0].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNAC;
        
        //User objUser = [Select Id from User Limit 1];
        Attachment objAttach = New Attachment(Name = 'TestAttach',Description='Descri',ParentId = objPCNPerformance.Id,Body=blob.valueof('tttt'));
        Insert objAttach;
        
        FeedItem objFI = New FeedItem(ContentFileName = 'TestFI.txt',ContentData=blob.valueof('tttt'),ParentId = objPCNPerformance.Id);
        Insert objFI;        
      
        Apexpages.currentpage().getParameters().put('id',objCN.id);
        ApexPages.currentPage().getHeaders().put('Host','https://theglobalfund--modules--c.cs17.visual.force.com');
         
        ApexPages.StandardController std = new ApexPages.StandardController(objCN);
        ctrlPCNQualCriteria obj = new ctrlPCNQualCriteria(std);
        obj.AddNewFile();
        obj.AddNewFileOtherConsideration();
        obj.AddNewFileFinalOtherConsideration();
        obj.strRecordTypeName = 'Final_Allocation_Absorptive_Capacity';
        obj.changePCNStatusToAccepted();
        obj.fillFunctionalTeamFileList(New List<Attachment>{objAttach},New List<FeedItem>{objFI});
        obj.retrieveFunctionalTeamFiles();
        obj.retrievePCNRequestUpdateInformation();
        obj.uploadPCNRequestUpdatedFile();
        obj.savePCNRequestUpdated();
        obj.changePCNStatusToRequestUpdated();
        obj.changePCNStatusToRequestUpdatedSubmitted();
        
        obj.strRecordTypeName = 'Absorptive_Capacity';   
        obj.SetCapAmountPopUp();
        obj.SubmitOtherConsiderations();
        
        obj.strRecordTypeName = 'Final_Allocation_Absorptive_Capacity';   
        obj.SetCapAmountPopUp();
        obj.SubmitOtherConsiderations();
        
        
        obj.SubmitAbsorptiveCapacity();
        obj.SubmitAll();
        
        Apexpages.currentpage().getParameters().put('RecordType','Absorptive_Capacity');        
        obj.uploadOtherConsiderationsFiles();
        Apexpages.currentpage().getParameters().put('RecordType','Final_Allocation_Absorptive_Capacity'); 
        obj.uploadOtherConsiderationsFiles();
        
        obj.SetStatusImpactPerformance();
        obj.Submit();
        
        obj.lstPerformance[0].Status__c = 'Accepted';
        obj.lstImpact[0].Status__c = 'Accepted';
        obj.lstIncreasingReatofInfection[0].Status__c = 'Accepted';
        obj.lstRisk[0].Status__c = 'Accepted';
        obj.SubmitAll();
    }
    
    Static testmethod void TestctrlPCNQualCriteria7(){
        List<RecordType> lstRecordTypes = New List<RecordType>([Select Id from RecordType where sobjectType = 'PCN_Criteria__c' And 
              (RecordType.DeveloperName = 'Performance' OR RecordType.DeveloperName = 'Impact' OR RecordType.DeveloperName = 'Increasing_Rate_of_Infection' 
              OR RecordType.DeveloperName = 'Risk' OR RecordType.DeveloperName = 'Absorptive_Capacity' OR RecordType.DeveloperName = 'Final_Allocation_Absorptive_Capacity')]);
        RecordType objRT = [Select Id from RecordType where sobjectType = 'PCN_Criteria__c' And RecordType.DeveloperName = 'Other_Considerations'];
        
        
        Account objAcct = new Account();
        objAcct.Name = 'Test Acct';
        insert objAcct;        
        
        Concept_Note__c objCN = new Concept_Note__c();
        objCN.Name = 'Test CN';
        objCN.CCM_New__c = objAcct.id;
        objCN.Start_Date__c = system.today();
        objCN.Funding_End_Date__c = system.today();
        objCN.P_I_IR_and_Risk_Status__c ='Under Review';   
        insert objCN;
        
        PCN_Criteria__c objPCNOtherConsideration = new PCN_Criteria__c();
        objPCNOtherConsideration.Name = 'Test';
        objPCNOtherConsideration.RecordTypeId = objRT.Id;
        objPCNOtherConsideration.Concept_Note__c = objCN.Id;
        objPCNOtherConsideration.Status__c = 'No Other Considerations Entered';
        insert objPCNOtherConsideration;
        
        PCN_Criteria__c objPCNPerformance = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[4].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNPerformance;
        
        PCN_Criteria__c objPCNImpact = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[2].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNImpact;
        
        PCN_Criteria__c objPCNIRI = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[3].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNIRI;
        
        PCN_Criteria__c objPCNRISK = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[5].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNRISK;
                
        PCN_Criteria__c objPCNFAC = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[1].Id,Concept_Note__c = objCN.Id,Country_Team_Justification__c='test',Status__c = 'Accepted');
        Insert objPCNFAC;
        
        PCN_Criteria__c objPCNAC = New PCN_Criteria__c(Name = 'TestingP@@',RecordTypeId = lstRecordTypes[0].Id,Concept_Note__c = objCN.Id,Status__c = 'Accepted');
        Insert objPCNAC;
        
        //User objUser = [Select Id from User Limit 1];
        Attachment objAttach = New Attachment(Name = 'TestAttach',Description='Descri',ParentId = objPCNPerformance.Id,Body=blob.valueof('tttt'));
        Insert objAttach;
        
        FeedItem objFI = New FeedItem(ContentFileName = 'TestFI.txt',ContentData=blob.valueof('tttt'),ParentId = objPCNPerformance.Id);
        Insert objFI;        
      
        Apexpages.currentpage().getParameters().put('id',objCN.id);
        ApexPages.currentPage().getHeaders().put('Host','https://theglobalfund--modules--c.cs17.visual.force.com');
         
        ApexPages.StandardController std = new ApexPages.StandardController(objCN);
        ctrlPCNQualCriteria obj = new ctrlPCNQualCriteria(std);
        obj.AddNewFile();
        obj.AddNewFileOtherConsideration();
        obj.AddNewFileFinalOtherConsideration();
        obj.strRecordTypeName = 'Other_Considerations';
        obj.changePCNStatusToAccepted();
        obj.fillFunctionalTeamFileList(New List<Attachment>{objAttach},New List<FeedItem>{objFI});
        obj.retrieveFunctionalTeamFiles();
        obj.retrievePCNRequestUpdateInformation();
        obj.uploadPCNRequestUpdatedFile();
        obj.savePCNRequestUpdated();
        obj.changePCNStatusToRequestUpdated();
        obj.changePCNStatusToRequestUpdatedSubmitted();
        
              
        obj.strRecordTypeName = 'Other_Considerations';   
        obj.SetCapAmountPopUp();
        obj.SubmitOtherConsiderations();
        
        
        obj.SubmitAbsorptiveCapacity();
        obj.SubmitAll();
        
        
        Apexpages.currentpage().getParameters().put('RecordType','Other_Considerations'); 
        obj.uploadOtherConsiderationsFiles();
        obj.SaveOtherConsiderations();
        
        obj.SetStatusImpactPerformance();
        obj.Submit();
        
        obj.lstPerformance[0].Status__c = 'Accepted';
        obj.lstImpact[0].Status__c = 'Accepted';
        obj.lstIncreasingReatofInfection[0].Status__c = 'Accepted';
        obj.lstRisk[0].Status__c = 'Accepted';
        obj.SubmitAll();
    }
}