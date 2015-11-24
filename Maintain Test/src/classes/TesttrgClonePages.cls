@isTest
Public Class TesttrgClonePages
{
    Public Static testMethod void TestTrgCreateSections ()
    {
        List<RecordType> lstRT = [select id from RecordType where developerName='CCM' and sobjectType='Account'];
        if(lstRT!=null && lstRT.size()>0){
            Account objAcc = new Account(name='Test CCM',RecordTypeID=lstRT[0].id);
            insert objAcc;
            
            insert new Indicator__c(Programme_Area__c='HIV',Default_Indicator__c=true,Cross_Cutting__c =true,indicator_type__c='Impact');
            
            Template__c objTemplate = new Template__c(name='Test Template');
            insert objTemplate;
            
            insert new page__c(name='Page 1',Template__c=objTemplate.id);
            
            List<Concept_Note__c> lstConceptNote = new List<Concept_Note__c>();
            lstConceptNote.add(new Concept_Note__c(name='Test CN',CCM_new__c=objAcc.ID,Component__c='HIV',Page_Template__c=objTemplate.ID));
            lstConceptNote.add(new Concept_Note__c(name='Test CN',CCM_new__c=objAcc.ID,Component__c='HIV',Page_Template__c=objTemplate.ID));
            insert lstConceptNote ;
        }
        
    }
}