@isTest
Public Class TestCreateFundingSource{
    Public Static testMethod void TestCreateFundingSource(){
        Country__c ObjCountry = new Country__c(Name='test australia');
        insert ObjCountry;
        
       
    
        Template__c ObjTemplate = new Template__c(name='Standard CN Template',CurrencyIsoCode='EUR');
        insert ObjTemplate;
                
        List<Recordtype> lstRecordType = [select Id from recordtype where SobjectType =:'account'];
        account Objaccount = new account(name='test',recordtypeid=lstRecordType[0].id,Country__c=ObjCountry.id);
        insert Objaccount;
        
         Grant__c objGrant = new Grant__c(name='test',Principal_Recipient__c = Objaccount.id,Disease_Component__c = 'Malaria');

        Concept_Note__c ObjConceptNote = new Concept_Note__c(Name='botcom',Component__c='Malaria',Number_of_Years__c='3',Page_Template__c=ObjTemplate.id,Implementation_Period_Page_Template__c=ObjTemplate.id,CCM_new__c=Objaccount.id);
        insert ObjConceptNote;

        Implementation_Period__c ObjImplementationPeriod = new Implementation_Period__c(Name='Test period',Concept_Note__c=ObjConceptNote.id,Is_Active__c=true,Principal_Recipient__c=Objaccount.id,Grant_Number_s__c='Tets',Grant__c = objGrant.id);
        insert ObjImplementationPeriod;
  
        CPF_Report__c ObjCPFReport = new CPF_Report__c(CurrencyIsoCode='EUR',Country__c=ObjCountry.id,Component__c='Malaria');
        insert ObjCPFReport;     

    }
}