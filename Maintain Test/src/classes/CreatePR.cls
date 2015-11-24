public without sharing class CreatePR {

    Public Account objAccount {get;set;}
    Public List<selectOption> prTypeOptions {get;set;}
    Public String ccmId;
    Public String countryId;
    Public String component;
    Public Date cnStart;
    Public Date cnEnd;
    Public String cnId;
    Public String GM {get;set;}
    Public String length;
    Public String cnLocalCurrency;
    Public String cnGrantCurrency;
    Public String pageId {get;set;}
    Public String strRetURL {get;set;}
    Public String strRetURLGM {get;set;}
    Public String language;
    
    //Field and button labels
    Public String AccountName {get;set;}
    Public String PRType {get;set;}
    Public String PRSubType {get;set;}
    Public String ShortName {get;set;}
    Public String Save {get;set;}
    Public String Cancel {get;set;}
    Public String AddNewPR {get;set;}
          
    public CreatePR(ApexPages.StandardController stdController) {
      objAccount = (Account)stdController.getRecord(); 
      cnId = Apexpages.currentpage().getparameters().get('cnId');
      pageId = Apexpages.currentpage().getparameters().get('pageId');
      language = Apexpages.currentpage().getparameters().get('language');
      GM = Apexpages.currentpage().getparameters().get('GM');
      prTypeOptions = new List<selectOption>();
      
          AccountName = 'Organization Name';
          PRType = 'PR Type';
          PRSubType = 'PR Sub-Type';
          ShortName = 'Short Name';
          Save = 'Save';
          Cancel = 'Cancel';
          AddNewPR = 'Add New PR';
      
      if(language == 'fr'){
          AccountName = 'Nom de compte';
          PRType = 'Type de récipiendaire principal';
          PRSubType = 'Sous-type de récipiendaire principal';
          ShortName = 'Nom abrégé';
          Save = 'Sauvegarder';
          Cancel = 'Annuler';
          AddNewPR = 'Ajouter un nouveau récipiendaire principal';
          prTypeOptions.add(new selectOption('', '--Aucun--'));
      }
      else if(language == 'ru'){
          AccountName = 'название счета';
          PRType = 'Вид ОР';
          PRSubType = 'Подвид ОР';
          ShortName = 'Краткое название';
          Save = 'Сохранить';
          Cancel = 'Отменить';
          AddNewPR = 'Добавить нового ОР';
          prTypeOptions.add(new selectOption('', '--Нет--'));
      }
      else if(language == 'es'){
          AccountName = 'Nombre de cuenta';
          PRType = 'Tipo de RP';
          PRSubType = 'Subtipo de RP';
          ShortName = 'Nombre corto';
          Save = 'Guardar';
          Cancel = 'Cancelar';
          AddNewPR = 'Añadir nuevo RP';
          prTypeOptions.add(new selectOption('', '--Ninguno--'));
      }
      else{
        prTypeOptions.add(new selectOption('', '--None--'));
      }
      
      Schema.DescribeFieldResult F = Account.Type__c.getDescribe();
      List<Schema.PicklistEntry> lstPickVals = F.getPicklistValues();
      System.debug(lstPickVals);
      for(Schema.PicklistEntry pe : lstPickVals){
        prTypeOptions.add(new selectOption(pe.getValue(),pe.getLabel())); }    
      
      if(String.valueOf(URL.getSalesforceBaseUrl()).contains('modules')){
          strRetURL = 'https://theglobalfund--modules--c.cs17.visual.force.com/apex/CN_implementers?id=';
          system.debug('strRetURL'+strRetURL);
          strRetURLGM = 'https://modules-theglobalfund.cs17.force.com/GM/apex/CN_implementers?id=';
        } else if(String.valueOf(URL.getSalesforceBaseUrl()).contains('tgftest')){
          strRetURL = 'https://theglobalfund--tgftest--c.cs17.visual.force.com/apex/CN_implementers?id=';
          strRetURLGM = 'https://tgftest-theglobalfund.cs17.force.com/GM/apex/CN_implementers?id=';
       } else {
          strRetURL = 'https://theglobalfund--c.eu2.visual.force.com/apex/CN_implementers?id=';
          strRetURLGM = 'https://theglobalfund.force.com/GM/apex/CN_implementers?id=';
       }
       
       
      
      if(cnId != null){
      List<Concept_Note__c> lstCN = [Select Id, CCM_new__c, CCM_new__r.Country__c, CCM_new__r.Country__r.Currency__c, 
                                      Component__c, Start_Date__c, Funding_End_Date__c, Number_of_Years__c, CurrencyIsoCode 
                                      from Concept_Note__c where Id = :cnId];
     if(!lstCN.isEmpty()){
          cnLocalCurrency = lstCN[0].CCM_New__r.Country__r.Currency__c;
          cnGrantCurrency = lstCN[0].CurrencyISOCode;
          countryId = lstCN[0].CCM_new__r.Country__c;
          ccmId = lstCN[0].CCM_new__c;
          component = lstCN[0].Component__c;
          cnStart = lstCN[0].Start_Date__c;
          cnEnd = lstCN[0].Funding_End_Date__c;  
          length = lstCN[0].Number_of_Years__c;  
        }
      } 
   }

    Public PageReference saveRecord() {
    	system.debug('Test');
      objAccount.Country__c = countryId;
      objAccount.Coordinating_Mechanism__c = ccmId;
      objAccount.New_PR_Status__c = 'Pending';
      insert objAccount;
      System.debug(objAccount.Id);                               
      Grant__c objGrantNew = new Grant__c(Name = 'Test',Principal_Recipient__c = objAccount.Id,Disease_Component__c = component, Grant_Status__c = 'Concept Note',Country__c = countryId,Start_Date__c = cnStart,End_Date__c = cnEnd);
        insert objGrantNew;
      System.debug(objGrantNew.Id);
      Implementation_Period__c objGoal = new Implementation_Period__c(Principal_Recipient__c = objAccount.Id, Concept_Note__c = cnId,Custom_PR__c = true, Start_Date__c = cnStart, End_Date__c = cnEnd, Length_Years__c = length, Local_Currency__c = cnLocalCurrency,Currency_of_Grant_Agreement__c = cnGrantCurrency,Grant__c = objGrantNew.id);
        insert objGoal;
      System.debug(objGoal.Id);
        
      return NULL;
    }

}