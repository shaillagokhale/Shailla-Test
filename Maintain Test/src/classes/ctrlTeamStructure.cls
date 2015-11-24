/*********************************************************************************
* {Controller} Class: {ctrlTeamStructure}
* DateCreated  : 07/22/2013
----------------------------------------------------------------------------------
* Purpose/Methods:
* - This controller used for Team Structure page which opens through a button on work plan 
    and will be used for country teams to manage their teams.
* 
* Unit Test: TestctrlTeamStructure
----------------------------------------------------------------------------------
* History:
* - VERSION  DEVELOPER NAME    DATE            DETAIL FEATURES
    1.0                      07/22/2013      INITIAL DEVELOPMENT
*********************************************************************************/

public with sharing class ctrlTeamStructure {

    // Global Variables
    
    Public  Id ContactId{get;set;}
    Public  String strAccId {get;set;}
    Public  String strAccName{get;set;}
    Public  String strParentAccId{get;set;}
    Public  String strConId{get;set;}
    
    Public  String strCountryName{get;set;}
    Public  String strCountryRegion{get;set;}
    Public  String strRoleId{get;set;}
    Public  String strRoleName{get;set;}
    Public  String strErrorMsg{get;set;}
    Public  String strCountryId{get;set;}
    Public  List<SelectOption> LocationOptions{get;private set;}
    Public  List<SelectOption> GfApprovedOptions{get;private set;}
    
    Public  List<Contact> lstContact{get;set;} 
    Public  List<SelectOption> RoleOptions {get; private set;}
    Public  List<WrapperContactRate> lstWrapContactRate{get;set;}
    
    Private String strWorkPlanId;    
    Private Boolean blnLFARole;   
    
   /********************************************************************
       Constructor
       Purpose: Initialize Objects and Lists used by this page
   
   ********************************************************************/
       
    Public ctrlTeamStructure(){
        strWorkPlanId = Apexpages.currentpage().getparameters().get('WPId');
        lstWrapContactRate = new List<WrapperContactRate>();
        blnLFARole =false;
        fillList();
        FillLocationAndGFApproved();
    }

   /********************************************************************
       Name: addContactRow
       Purpose: Used for add Contact and new rate row in list.   
   ********************************************************************/
    Public PageReference addContactRow(){
        String AddConId = Apexpages.currentpage().getparameters().get('AddConId');      
        if(String.IsBlank(AddConId) == false){
            List<Contact> lstContactTemp = [Select id,FirstName,LastName,Active_LFA_Member__c,Experience__c from Contact where id = :AddConId Limit 1];
            for(WrapperContactRate objWrapConRate :lstWrapContactRate){
                if(lstContactTemp[0].id == objWrapConRate.ObjContact.Id){
                    strErrorMsg = 'Contact already exits';                    
                    return null;
                }                
            }
            strErrorMsg = null;
            WrapperContactRate objWrapCRate = new WrapperContactRate(new Contact(AccountId = strAccId));
            objWrapCRate.ObjContact = lstContactTemp[0];           
            
            Rate__c objRate = new Rate__c(Contact__c = lstContactTemp[0].Id,Country__c = strCountryId);
            wrpRate objwrpRate = new wrpRate(objRate);
            objwrpRate.strRoleName = objwrpRate.objRate.LFA_Role__r.Name;           
            objWrapCRate.lstWrpRate = new List<wrpRate>();           
            objWrapCRate.lstWrpRate.add(objwrpRate);
            lstWrapContactRate.add(objWrapCRate);            
        }
        return null;
    }
    
   /********************************************************************
       Name: SaveContact
       Purpose: Used for Save Contact and releted rates in workplans 
                and redirect to releted workplan detail page. 
   
   ********************************************************************/
    
    Public PageReference SaveContact(){        
        QuickSaveContact();
        if(blnLFARole == true){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select LFA Role .');
            ApexPages.addMessage(myMsg);
            return null;
        }else{
            PageReference p;
            if(String.IsBlank(strWorkPlanId) == false){
                p = new PageReference('/'+strWorkPlanId);
            }
            return p;
        }
    }
    
    /********************************************************************
       Name: Cancel
       Purpose: Used for Cancel save contact and rates.
   
   ********************************************************************/
    
    Public PageReference Cancel(){
        PageReference p;
        if(String.IsBlank(strWorkPlanId) == false){
            p = new PageReference('/'+strWorkPlanId);
        }
        return p;
    }
    
   /************************************************************************
       Name: fillList
       Purpose: Used for retrive contact and their releted rates data in List. 
                Called in Construstor of this class.
   
   *************************************************************************/
    
    Public Void fillList(){        
        if(String.IsBlank(strWorkPlanId) == false){
            List<LFA_Work_Plan__c> lstWorkplan = [Select id,LFA__c,LFA__r.Name,LFA__r.Parent.Id,Country__c,Country__r.Name,
                                                  Country__r.Region_name__c from LFA_Work_Plan__c where Id = :strWorkPlanId Limit 1];  
            if(lstWorkplan.size() >0){
                strAccId = lstWorkplan[0].LFA__c;
                strAccName = lstWorkplan[0].LFA__r.Name;
                strParentAccId = lstWorkplan[0].LFA__r.Parent.Id;
                strCountryId = lstWorkplan[0].Country__c;
                strCountryName = lstWorkplan[0].Country__r.Name;
                strCountryRegion = lstWorkplan[0].Country__r.Region_name__c;
            }            
        }
        if(String.IsBlank(strCountryId)==false && (String.IsBlank(strAccId)==false || String.IsBlank(strParentAccId)==false)){
            lstContact = [Select Id,Name,FirstName,LastName,Active_LFA_Member__c,Experience__c,
                            Account.Country__r.Name,Account.Country__r.Region_name__c,
                            (Select id,LFA_Role__c,Other_LFA_Role__c,LFA_Role__r.Name,Active__c,
                                LFA_Location__c,Rate__c,Next_Year_Daily_Rate__c,Difference__c,
                                GF_Approved__c from Rates__r Where Contact__c != null And Country__c =: strCountryId) 
                                from Contact where (AccountId =: strAccId OR AccountId =:strParentAccId
                                OR (Contact.Account.ParentId != null and Contact.Account.ParentId =:strParentAccId)) Order By LastName ASC];
        }                         
        if(lstContact.size() > 0){                       
            for(Contact objCon : lstContact){
                if(objCon.Rates__r.size() >0){
                    WrapperContactRate objWrapConRate = new WrapperContactRate(objCon);                   
                    List<wrpRate> lstwrapRateTemp = new List<wrpRate>();                    
                    for(Rate__c objRate:objCon.Rates__r){                                        
                        wrpRate objwrpRate = new wrpRate(objRate);
                        objwrpRate.objRate = objRate;
                        objwrpRate.strRoleName = objwrpRate.objRate.LFA_Role__r.Name;
                        objwrpRate.decdifference = objwrpRate.objRate.Difference__c;
                        lstwrapRateTemp.add(objwrpRate);
                    }                  
                    if(lstwrapRateTemp.size() >0){
                        objWrapConRate.lstWrpRate = lstwrapRateTemp;
                    }                   
                    lstWrapContactRate.add(objWrapConRate);       
                }
            }
        }
        FillRole();
    }
    
    Public void FillLocationAndGFApproved(){
        LocationOptions = new List<SelectOption>();
        GfApprovedOptions = new List<SelectOption>();
        Schema.sObjectType objType = Rate__c.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe(); 
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
        List<Schema.PicklistEntry> Locations = fieldMap.get('LFA_Location__c').getDescribe().getPickListValues();
        List<Schema.PicklistEntry> GfApproved = fieldMap.get('GF_Approved__c').getDescribe().getPickListValues();
        LocationOptions.add(new SelectOption('', '--None--'));
        GfApprovedOptions.add(new SelectOption('', '--None--'));
        for (Schema.PicklistEntry Entry : Locations){ 
            LocationOptions.add(new SelectOption(Entry.getLabel(), Entry.getValue()));
        }
        for (Schema.PicklistEntry Entry : GfApproved){ 
            GfApprovedOptions.add(new SelectOption(Entry.getLabel(), Entry.getValue()));
        }
    }
    
   /************************************************************************
       Name: addContactRateRow
       Purpose: Used for add rate object row in List of wrapper class list.                 
   
   ************************************************************************/    
    
    Public Void addContactRateRow(){                
        if(String.IsBlank(ContactId) == false){
            for(WrapperContactRate objWrapConRate : lstWrapContactRate){
                if(objWrapConRate.objContact.Id == ContactId){                    
                    Rate__c objRate = new Rate__c(Contact__c = ContactId,Country__c = strCountryId);
                    wrpRate objwrpRate = new wrpRate(objRate);
                    objwrpRate.strRoleName = objwrpRate.objRate.LFA_Role__r.Name;                  
                    if(objWrapConRate.lstWrpRate == null){
                        objWrapConRate.lstWrpRate = New List<wrpRate>();
                    }                 
                    objWrapConRate.lstWrpRate.add(objwrpRate);
                    break;
                }
            } 
            ContactId = null; 
        }
    }
    
   /************************************************************************
       Name: DeleteRates
       Purpose: Used for delete rate releted to contact .                 
   
   ************************************************************************/
    Public Void DeleteRates(){        
        Integer DeleteConRateIndex = integer.valueof(Apexpages.currentpage().getparameters().get('DeleteConRateIndex'));
        Integer DeleteRateIndex = integer.valueof(Apexpages.currentpage().getparameters().get('DeleteRateIndex'));
        
        List<Rate__c> lstRateToDelete = new List<Rate__c>();
        if(DeleteConRateIndex !=null && DeleteRateIndex != null){
            if(lstWrapContactRate[DeleteConRateIndex].lstWrpRate[DeleteRateIndex].objRate.Id != null){
                lstRateToDelete.add(lstWrapContactRate[DeleteConRateIndex].lstWrpRate[DeleteRateIndex].objRate);
            }            
            lstWrapContactRate[DeleteConRateIndex].lstWrpRate.remove(DeleteRateIndex);
            if(lstWrapContactRate[DeleteConRateIndex].lstWrpRate.size() == 0){
                lstWrapContactRate.remove(DeleteConRateIndex);
                system.debug('###lstWrapContactRate->'+lstWrapContactRate);
            }
            DeleteConRateIndex = null;
            DeleteRateIndex = null;            
        }
        if(lstRateToDelete.size() > 0) Delete lstRateToDelete;
    }
    
    /************************************************************************
       Name: QuickSaveContact
       Purpose: Used for save Contact with releted rates rows.
               Called on 'Quick Save' button and also in SaveContact method.
   
   ************************************************************************/
    Public void QuickSaveContact(){
        blnLFARole = false;
        List<Rate__c> lstRateToupsert = new List<Rate__c>();        
        Map<Id,Contact> mapOldContactIdToNewContactObj = new Map<Id,Contact>();        
        Map<Id,List<Rate__c>> mapOldContactIdToRates = new Map<Id,List<Rate__c>>();    
        if(lstWrapContactRate != null && lstWrapContactRate.size() > 0){
            Contact objContactTemp;
            List<Rate__c> lstRatesInsert;
            Rate__c objRateTemp;             
            for(WrapperContactRate objWrapConRate : lstWrapContactRate){
                objContactTemp = new Contact();
                objContactTemp = objWrapConRate.objContact;
                system.debug('###objContactTemp.Id->'+objContactTemp.Id);
                mapOldContactIdToNewContactObj.put(objContactTemp.Id,objContactTemp);
               
                lstRatesInsert = new List<Rate__c>();
                if(objWrapConRate.lstWrpRate.size() > 0){
                    for(WrpRate objwrpRate : objWrapConRate.lstWrpRate){                    
                        objRateTemp = new rate__c();
                        objRateTemp = objwrpRate.objRate;
                        if(objwrpRate.strRoleName != 'Other Professional'){
                            objRateTemp.Other_LFA_Role__c = null;
                        }
                        lstRatesInsert.add(objRateTemp);
                    }
                }
                mapOldContactIdToRates.put(objContactTemp.Id,lstRatesInsert);
            }
        }
        if(mapOldContactIdToNewContactObj.size() > 0){            
            update mapOldContactIdToNewContactObj.values();
        }
       
        for(ID ContactId : mapOldContactIdToRates.keyset()){
            if(mapOldContactIdToRates.get(ContactId) != null){            
                for(Rate__c objRate : mapOldContactIdToRates.get(ContactId)){
                    if(objRate.LFA_Location__c != null || objRate.GF_Approved__c != null ||
                       objRate.Next_Year_Daily_Rate__c != null || objRate.LFA_Location__c != null ||
                       objRate.LFA_Role__c != null){
                        if(objRate.LFA_Role__c != null){
                            objRate.Contact__c = mapOldContactIdToNewContactObj.get(ContactId).id;
                            lstRateToupsert.add(objRate);
                        }else{
                            blnLFARole =true;
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select LFA Role.');
                            ApexPages.addMessage(myMsg);
                            return;
                        }
                    }
                }
            }
        }
        
        if(lstRateToupsert.size() > 0) upsert lstRateToupsert;
        lstWrapContactRate = new List<WrapperContactRate>();
        fillList();
    }
    
    /***********************************************************************************
       Name: FillRole
       Purpose: Used for Fill LFA Role Name Field and set values from lookup to picklist.
                Called on 'Quick Save' button and also in SaveContact method.
   
    ************************************************************************************/
    
    Public Void FillRole(){
        RoleOptions = new List<SelectOption>();
        List<LFA_Role__c> lstRoles = [Select Id,Name From LFA_Role__c];
        RoleOptions.add(new Selectoption('',''));
        if(lstRoles != null && lstRoles.size() > 0){
            for(LFA_Role__c objRole: lstRoles){
                RoleOptions.add(new Selectoption(objRole.id,objRole.Name));                
            }
        }
    }
    
    /***********************************************************************************
      WrapperClass :- WrapperContactRate
    ************************************************************************************/
    
    Public Class WrapperContactRate{
        Public Contact objContact{get;set;}        
        Public List<wrpRate> lstWrpRate{get;set;}
        
        Public WrapperContactRate(Contact objCon){                   
            this.objContact = objCon;
        }  
    }
    /***********************************************************************************
      WrapperClass :- wrpRate       
    ************************************************************************************/
    Public Class wrpRate{
        Public Rate__c objRate{get;set;}
        Public Decimal decdifference{get;set;}        
        Public String strRoleName{get;set;}   
        Public wrpRate(Rate__c objRate){
            this.objRate = objRate;           
        }
    }
}