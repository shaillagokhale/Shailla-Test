/*********************************************************************************
* Class: AccountTriggerHandler
* Created/Updated by {Rahul Kumar}, {DateCreated Dec-05-2014}
----------------------------------------------------------------------------------
* Purpose: This class is is used to Contain all methods used in Account trigger
    AccountTrigger trigger.All trigger merged into one.
----------------------------------------------------------------------------------
*********************************************************************************/
Public class AccountTriggerHandler {

    //Runs on insert or on update if country has changed or CT_Finance_Officer__c is null
    Public static void aiuSetAccountFinanceOfficer(List<Account> lstNewAccounts,Map<Id,Account> mapOldAccounts, Boolean blnIsInsert, Boolean blnIsUpdate) {
        Set<Id> setAccountIds = New Set<Id>();
        List<Account> lstAccountsToUpdate = New List<Account>();
        for(Account objAccount: lstNewAccounts)
        {
            if(blnIsInsert && objAccount.Country__c != null)
            {
                    setAccountIds.Add(objAccount.Id);
                    System.debug('setAccountIds'+setAccountIds);
            }
            else if(blnIsUpdate && objAccount.Country__c != null && (objAccount.Country__c != mapOldAccounts.get(objAccount.Id).Country__c || objAccount.CT_Finance_Officer__c == null))
            {
                setAccountIds.Add(objAccount.Id);
                 System.debug('setAccountIds'+setAccountIds);
            }
        }        
        if(setAccountIds.Size()>0)
        {
            List<Account> lstAccounts = New List<Account>([Select Id,Country__r.CT_Public_Group_ID__c,CT_Finance_Officer__c From Account Where Id IN: setAccountIds 
                                                          AND Locked__c = false AND (Country__r.CT_Public_Group_ID__c != '' OR Country__r.CT_Public_Group_ID__c != null)]);  //2014-16-06 Locked__c criterion added by Matthew Miller
            System.debug('lstAccounts '+lstAccounts);
            Set<String> setCTPublicGroupIds = New Set<String>();
            if(lstAccounts.size()>0)
            {
                for(Account objAcc: lstAccounts)
                {
                    setCTPublicGroupIds.Add(objAcc.Country__r.CT_Public_Group_ID__c);
                    System.debug('setCTPublicGroupIds'+setCTPublicGroupIds);
                }
            }
            
            if(setCTPublicGroupIds.size() > 0)
            {
                List<GroupMember> lstCTGroupMembers = New List<GroupMember>([Select UserOrGroupId,GroupId From GroupMember 
                                Where GroupId IN : setCTPublicGroupIds]);
                System.debug('lstCTGroupMembers'+lstCTGroupMembers);               
                Map<Id,Set<Id>> mapGroupMember = New  Map<Id,Set<Id>>();
                if(lstCTGroupMembers.size()>0)
                {
                    for(GroupMember objGroupMember: lstCTGroupMembers)
                    {
                        if(mapGroupMember.Containskey(objGroupMember.GroupId))
                        {
                            mapGroupMember.get(objGroupMember.GroupId).Add(objGroupMember.UserOrGroupId);
                            System.debug('mapGroupMember'+mapGroupMember);   
                        } else
                        {
                            mapGroupMember.put(objGroupMember.GroupId, New Set<Id>{objGroupMember.UserOrGroupId});
                            System.debug('mapGroupMember'+mapGroupMember);   
                        }
                    }
                }
                
                List<GroupMember> lstGroupMembers = New List<GroupMember>([Select UserOrGroupId,Group.DeveloperName From GroupMember 
                                Where Group.DeveloperName = 'CT_All_Program_Finance']);  
                Set<Id> setGroupMembersUserIds = New Set<Id>();
                if(lstGroupMembers.Size()>0)
                {
                    for(GroupMember objGroupMember: lstGroupMembers)
                    {
                        setGroupMembersUserIds.Add(objGroupMember.UserOrGroupId);
                        System.debug('setGroupMembersUserIds'+setGroupMembersUserIds);  
                    }
                }
                              
                for(Account objAccount: lstAccounts)
                { 
                    if(mapGroupMember.get(objAccount.Country__r.CT_Public_Group_ID__c) != null && setGroupMembersUserIds.size()>0 &&    
                        mapGroupMember.get(objAccount.Country__r.CT_Public_Group_ID__c).size() >0)
                        {  
                        System.Debug('FirstIF');
                        if (mapGroupMember.get(objAccount.Country__r.CT_Public_Group_ID__c).size() <  setGroupMembersUserIds.size()){ 
                         System.Debug('SecondIF');                                                 
                            for(Id UserId : mapGroupMember.get(objAccount.Country__r.CT_Public_Group_ID__c)){
                                if(setGroupMembersUserIds.Contains(UserId)){ 
                                 System.Debug('ThirdIF');
                                    objAccount.CT_Finance_Officer__c = UserId;
                                    lstAccountsToUpdate.add(objAccount); 
                                    break;
                                }
                            }
                        }else{                            
                            for(Id UserId : setGroupMembersUserIds){                                
                                if(mapGroupMember.get(objAccount.Country__r.CT_Public_Group_ID__c).Contains(UserId)){
                                  System.Debug('ElseIF');
                                    objAccount.CT_Finance_Officer__c = UserId; 
                                    system.debug('objAccount.CT_Finance_Officer__c'+objAccount.CT_Finance_Officer__c);
                                    lstAccountsToUpdate.add(objAccount); 
                                    break;
                                }
                            }                             
                        } 
                    }                                            
                }
                update lstAccountsToUpdate;    //Only updating the accounts where the FO was added            
            }
        }         
    }
public static void UpsertAccountShareRecords(List<Account> acc)
    {
        List<User> lstCustomerCommunity =[Select Id, Name, Profile.UserLicense.Name From User Where Profile.UserLicense.Name = 'Customer Community Login' and id = :Userinfo.getUserId()];
        if(lstCustomerCommunity==null || lstCustomerCommunity.size()==0)
        {
            //For the CM User add-on
            List<AccountShare> acctShares  = new List<AccountShare>();     
            // For each of the Account records being inserted, do the following:
            for(Account acct :acc)
            {    
                if(acct.CT_ID__c != null)
                {
                    // Create a new AccountShare record to be inserted in to the AccountShare table.
                    AccountShare ctShare = new AccountShare();
                        
                    // Populate the AccountShare record with the ID of the record to be shared.
                    ctShare.AccountId = acct.Id;
                        
                    // the CT ID formula field, which brings in the value of the CT ID on Country 
                    ctShare.AccountAccessLevel = 'Edit';
                    ctShare.CaseAccessLevel = 'None';
                    ctShare.OpportunityAccessLevel = 'None';
                    ctShare.UserOrGroupId = acct.CT_ID__c;               
                    // Add the new Share record to the list of new Share records.
                    acctShares.add(ctShare);
                }
                //Share Account as read-only with specified LFA Reviewer
                if(acct.LFA_Reviewer__c != null && acct.LFA_Reviewer__c != Userinfo.getuserId())
                {
                    AccountShare LFAShare = new AccountShare();                
                    LFAShare.AccountId = acct.Id;
                    LFAShare.AccountAccessLevel = 'Read';
                    LFAShare.CaseAccessLevel = 'None';
                    LFAShare.OpportunityAccessLevel = 'None';
                    LFAShare.UserOrGroupId = acct.LFA_Reviewer__c;                 
                    acctShares.add(LFAShare);            
                }
            }
            upsert acctShares;
        }
    }
public static void SubmitAccountCustomApproval(Set<Id> accIds,Map<Id,Account> oldMap)
    {
        List<Account> lstAccs = [Select Id, Approval_Status__c, CT_Finance_Officer__c,
                            (Select Id, Status__c from Account_Approvals__r where Status__c = 'Pending')
                            from Account where Id in :accIds];
                            
            for(Account acc: lstAccs)
            {                        
             if(acc.Approval_Status__c == 'Finance Officer verification' 
               && oldMap.get(acc.Id).Approval_Status__c != 'Finance Officer verification'
               && acc.CT_Finance_Officer__c != null && acc.Account_Approvals__r.size() == 0)
               { 
                    Account_Approval__c apApp = new Account_Approval__c();
                    apApp.Account__c = acc.Id;
                    apApp.Status__c = 'Pending';
                    apApp.Assigned_to__c = acc.CT_Finance_Officer__c;
                    insert apApp;
                 
                    Account_Approval__c apSub = new Account_Approval__c();
                    apSub.Account__c = acc.Id;
                    apSub.Status__c = 'Submitted';
                    //Most Recent Submitter -- see where this is being set
                    apSub.Assigned_to__c = UserInfo.getUserId();
                    apSub.Actual_Approver__c = UserInfo.getUserId();
                    insert apSub;   
               }
            }
    }
public static void SubmitForApproval(List<Account> acc)
{
    Set<Id> setbankId = new Set<Id>();
    List<Account> lstacc = new List<Account>();
    Map<String,String> mapApproval = new Map<String,String>();

    for (Account bank : acc) 
    {
         if(bank.Approval_Status__c == 'Update information')
             setbankId.add(bank.Id);        
    }    
    for(ProcessInstance pi : [SELECT Status,TargetObjectId FROM ProcessInstance where Status = 'Pending'])
    {
       mapApproval.put(pi.TargetObjectId,pi.Status);
    }
    lstacc = [Select Id, Name, Most_Recent_Submitter__c,CT_Finance_Officer__c, Approval_Status__c from Account where Id in :setbankId];
    for (Account bank : lstacc) 
    {
        if(bank.Approval_Status__c == 'Update information')
        {
            if(bank.CT_Finance_Officer__c != null)
            {
              bank.Most_Recent_Submitter__c = UserInfo.getUserId();
            }  
        }
    }    
    if(!StopRecursion.hasAlreadyCreatedFollowUpTasks())
    {    
        for (Account bank : lstacc) 
        {
            if(bank.Approval_Status__c == 'Finance Officer verification')
            {
               if(bank.CT_Finance_Officer__c != null && !mapApproval.containskey(bank.Id))
                {
                 Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
                 app.setObjectId(bank.id);
                 Approval.ProcessResult result = Approval.process(app);
                } 
            }   
        }   
        if(!lstacc.isEmpty())
        {
           StopRecursion.setAlreadyCreatedFollowUpTasks();
           update lstacc;
        }  
    }
}
public static void UpdateAccountOwner(List<Account> acc)
{
/*********************************************************************
Step 1: Add the Country ids from all the Accounts in the trigger to a set and query for those country records.
Vendor Add-on: Add Account Ids depending on whether the account is a parent or child
Step 2: Create a map between Country ids and FPM ids so that each Country Id is linked to an FPM Id
Step 3: For each Account in the trigger, retrieve the relevant FPM user id using the map and set the owner Id
**********************************************************************/
Set<Id> countryIds = new Set<Id>();
set<Id>coWithFPM = new Set<Id>();
Map<Id,Id> mapCountryFPMIds = new Map<Id,Id>();
Id prID = [Select ID from RecordType where SObjectType = 'Account' and Name = 'PR'].Id;
List<Country__c> lstCountries = new List<Country__c>();

//For the Vendor bit
Set<Id> setParentAccIds = new Set<Id>();
Set<Id> setChildAccIds = new Set<Id>();
List<Account> lstParentAccts = new List<Account>();
List<Account> lstChildAcctsToUpdate = new List<Account>();
Map<Id,Id> mapAcctVendorIds = new Map<Id,Id>();

   //Step 1 -- only if PR Record Type
   for (Account acct : acc)
    {
        if(acct.RecordTypeId == prID)
        {
            countryIds.add(acct.Country__c);      
            //Vendor Add-on: adding Acct Ids based on whether parent or child
            if(acct.ParentId != null && acct.Vendor_ID__c == null)
            {
                setChildAccIds.add(acct.Id);
                setParentAccIds.add(acct.ParentId); 
            }         
            if(!acct.ChildAccounts.isEmpty() && acct.Vendor_ID__c != null)
            {
                setParentAccIds.add(acct.Id); 
            }
        }
    } 

    lstCountries = [Select Id, FPM__c from Country__c where Id in: countryIds AND FPM__c != null];
           
     //Step 2
     for(Country__c co : lstCountries){
       mapCountryFPMIds.put(co.Id,co.FPM__c); 
       coWithFPM.add(co.Id); }
   
   //Step 3   
   for (Account acct : acc) 
    {
      if(acct.RecordTypeId == prID && acct.Country__c != null && coWithFPM.contains(acct.Country__c)){
      acct.OwnerId = mapCountryFPMIds.get(acct.Country__c); }
    }
}   
}