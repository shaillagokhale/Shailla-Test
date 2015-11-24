/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
public class TestCtrlTRPTranslation {

    public static testMethod void TestCtrlTRPTranslation() {
        Account objAccount = new Account();
        objAccount.name = 'test';
        insert objAccount;
        
        Guidance__c objGuidance = new Guidance__c();
        objGuidance.Name = 'Program Split';
        insert objGuidance;
        
        Funding_Opportunity__c objFundOpp = new Funding_Opportunity__c (Name = '2014to16', isCurrent__c = true);
        insert objFundOpp;
        
        Program_Split__c objProgramSplit = new Program_Split__c();
        objProgramSplit.Name = 'test';
        objProgramSplit.CCM__c = objAccount.id;
        objProgramSplit.OPS_Submitted__c = true;
        objProgramSplit.RPS_Submitted__c = false;
        objProgramSplit.Language__c = 'SPANISH';
        objProgramSplit.Show_Combined_Concept_Note__c = false;
        insert objProgramSplit;
        
        Template__c objTemplate = new Template__c();
        objTemplate.name = 'test';
        insert objTemplate;
        
        Page__c objPage = new Page__c();
        objPage.Template__c = objTemplate.id;
        insert objPage;
        
        List<Concept_Note__c> lstConceptNote = new List<Concept_Note__c>();
        
        Concept_Note__c objConceptNote = new Concept_Note__c();
        objConceptNote.Program_Split__c = objProgramSplit.id;
        objConceptNote.CCM_new__c = objAccount.id;
        objConceptNote.Component__c = 'Health Systems Strengthening';
        objConceptNote.Page_Template__c = objTemplate.id;
        objConceptNote.Implementation_Period_Page_Template__c = objTemplate.id;
        objConceptNote.Communicated_Allocation_USD__c = 2000000;
        objConceptNote.Pre_MRL__c = 1000000;
        objConceptNote.Original_Proposed_Split__c = 2000000;
        objConceptNote.Revised_Proposed_Split__c = 1000000;
        objConceptNote.Agreed_Split_USD__c = 200000;
        objConceptNote.Agreed_Split_EUR__c = 200000;
        objConceptNote.Language__c = 'ENGLISH';
        lstConceptNote.Add(objConceptNote); 
        
        objConceptNote = new Concept_Note__c();
        objConceptNote.Program_Split__c = objProgramSplit.id;
        objConceptNote.CCM_new__c = objAccount.id;
        objConceptNote.Component__c = 'HIV/AIDS';
        objConceptNote.Page_Template__c = objTemplate.id;
        objConceptNote.Implementation_Period_Page_Template__c = objTemplate.id;
        objConceptNote.Communicated_Allocation_USD__c = 2000000;
        objConceptNote.Pre_MRL__c = 1000000;
        objConceptNote.Original_Proposed_Split__c = 2000000;
        objConceptNote.Revised_Proposed_Split__c = 1000000;
        objConceptNote.Language__c = 'SPANISH';
        lstConceptNote.Add(objConceptNote);
        
        objConceptNote = new Concept_Note__c();
        objConceptNote.Program_Split__c = objProgramSplit.id;
        objConceptNote.CCM_new__c = objAccount.id;
        objConceptNote.Component__c = 'Tuberculosis';
        objConceptNote.Page_Template__c = objTemplate.id;
        objConceptNote.Implementation_Period_Page_Template__c = objTemplate.id;
        objConceptNote.Communicated_Allocation_USD__c = 2000000;
        objConceptNote.Pre_MRL__c = 1000000;
        objConceptNote.Original_Proposed_Split__c = 2000000;
        objConceptNote.Revised_Proposed_Split__c = 1000000;
        objConceptNote.Language__c = 'RUSSIAN';
        lstConceptNote.Add(objConceptNote);
        
        objConceptNote = new Concept_Note__c();
        objConceptNote.Program_Split__c = objProgramSplit.id;
        objConceptNote.CCM_new__c = objAccount.id;
        objConceptNote.Component__c = 'HIV/TB';
        objConceptNote.Page_Template__c = objTemplate.id;
        objConceptNote.Implementation_Period_Page_Template__c = objTemplate.id;
         //Added
        objConceptNote.Original_Proposed_Split__c = 2000000;
        objConceptNote.Revised_Proposed_Split__c = 1000000;
        objConceptNote.Language__c = 'FRENCH';
        //
        lstConceptNote.Add(objConceptNote);
        
        insert lstConceptNote;
        
        Grant__c objGrant = new Grant__c();
        objGrant.Disease_Component__c  = 'Health Systems Strengthening';
        objGrant.Principal_Recipient__c = objAccount.id;
        insert objGrant;
        
       
        Implementation_Period__c objImplementationPeriod = new Implementation_Period__c();
        objImplementationPeriod.name='test';
        objImplementationPeriod.Principal_Recipient__c = objAccount.id;
        objImplementationPeriod.Start_Date__c = system.today();
        objImplementationPeriod.grant__c = objGrant.id;
        objImplementationPeriod.Concept_Note__c = objConceptNote.id;
        insert objImplementationPeriod;
        
        
        Apexpages.currentpage().getparameters().put('id',objConceptNote.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objPage);
        ctrlTRPTranslation objTRPTrans = new ctrlTRPTranslation(sc);
        objTRPTrans.fillProgrammSplit();
        objTRPTrans.fillFundingResource();
        objTRPTrans.fillPrincipalRecipients();
        objTRPTrans.fillGoalsObjectives();
        objTRPTrans.fillIndicators();
        objTRPTrans.fillCNInterventions();
        objTRPTrans.fillGrantInterventions();
        objTRPTrans.fillProgramaticGaps();
        objTRPTrans.fillFeedItem();
             
    
    }
}