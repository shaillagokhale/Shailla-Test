/*********************************************************************************
* Class: UpdateBankAccountFinanceOfficerHandler
* Created by {DeveloperName}, {DateCreated 12/10/2013}
----------------------------------------------------------------------------------
* Purpose: This class is is used to set Finance officer of Account from 
    UpdateBankAccountFinanceOfficer trigger.
----------------------------------------------------------------------------------
*********************************************************************************/
Public class UpdateBankAccountFinanceOfficerHandler {

    //Only runs on insert where Account__c is not null, or on update if CT Finance Officer is null or Bank Account has changed Accounts
    Public static void aiuSetBankAccountFinanceOfficer(List<Bank_Account__c> lstNewBankAccounts,Map<Id,Bank_Account__c> mapOldBankAccounts, Boolean blnIsInsert, Boolean blnIsUpdate) {
        Set<Id> setBankAccountIds = New Set<Id>();
        Set<Id> setBankAccountIds1 = New Set<Id>();
         
        List<Bank_Account__c> lstBankAccountsToUpdate = new List<Bank_Account__c>();
        for(Bank_Account__c objBA: lstNewBankAccounts){
            if(blnIsInsert && objBA.Account__c != null){
                setBankAccountIds.Add(objBA.Id);
                setBankAccountIds1.Add(objBA.Id);
            }else if(blnIsUpdate && objBA.Account__c != null && (objBA.Account__c != mapOldBankAccounts.get(objBA.Id).Account__c || objBA.CT_Finance_Officer__c == null)){
                setBankAccountIds.Add(objBA.Id);
                setBankAccountIds1.Add(objBA.Id);
            }
        }
        
        if(setBankAccountIds.Size()>0){
            List<Bank_Account__c> lstBankAccounts = New List<Bank_Account__c>([Select Id,Account__r.Country__r.CT_Public_Group_ID__c,
                            CT_Finance_Officer__c From Bank_Account__c Where Id IN: setBankAccountIds 
                            AND Locked__c = false
                            AND Account__r.Country__c != null 
                            AND (Account__r.Country__r.CT_Public_Group_ID__c != '' OR Account__r.Country__r.CT_Public_Group_ID__c != null)]);
            Set<String> setCTPublicGroupIds = New Set<String>();
            if(lstBankAccounts.size()>0){
                for(Bank_Account__c objAcc: lstBankAccounts){
                    setCTPublicGroupIds.Add(objAcc.Account__r.Country__r.CT_Public_Group_ID__c);
                }
            }
            
            if(setCTPublicGroupIds.size() > 0){
                List<GroupMember> lstCTGroupMembers = New List<GroupMember>([Select UserOrGroupId,GroupId From GroupMember 
                                Where GroupId IN : setCTPublicGroupIds]);
                Map<Id,Set<Id>> mapGroupMember = New  Map<Id,Set<Id>>();
                if(lstCTGroupMembers.size()>0){
                    for(GroupMember objGroupMember: lstCTGroupMembers){
                        if(mapGroupMember.Containskey(objGroupMember.GroupId)){
                            mapGroupMember.get(objGroupMember.GroupId).Add(objGroupMember.UserOrGroupId);
                        } else{
                            mapGroupMember.put(objGroupMember.GroupId, New Set<Id>{objGroupMember.UserOrGroupId});
                        }
                    }
                }
                
                List<GroupMember> lstGroupMembers = New List<GroupMember>([Select UserOrGroupId,Group.DeveloperName From GroupMember 
                                Where Group.DeveloperName = 'CT_All_Program_Finance']);  
                Set<Id> setGroupMembersUserIds = New Set<Id>();
                if(lstGroupMembers.Size()>0){
                    for(GroupMember objGroupMember: lstGroupMembers){
                        setGroupMembersUserIds.Add(objGroupMember.UserOrGroupId);
                    }
                }
                              
                for(Bank_Account__c objAccount: lstBankAccounts){ 
                    if(mapGroupMember.get(objAccount.Account__r.Country__r.CT_Public_Group_ID__c) != null && setGroupMembersUserIds.size()>0 &&    
                        mapGroupMember.get(objAccount.Account__r.Country__r.CT_Public_Group_ID__c).size() >0){  
                        if (mapGroupMember.get(objAccount.Account__r.Country__r.CT_Public_Group_ID__c).size() <  setGroupMembersUserIds.size()){                                                  
                            for(Id UserId : mapGroupMember.get(objAccount.Account__r.Country__r.CT_Public_Group_ID__c)){
                                if(setGroupMembersUserIds.Contains(UserId)){ 
                                    objAccount.CT_Finance_Officer__c = UserId;
                                    lstBankAccountsToUpdate.add(objAccount);
                                    break;
                                }
                            }
                        }else{                            
                            for(Id UserId : setGroupMembersUserIds){                                
                                if(mapGroupMember.get(objAccount.Account__r.Country__r.CT_Public_Group_ID__c).Contains(UserId)){ 
                                    objAccount.CT_Finance_Officer__c = UserId;
                                    lstBankAccountsToUpdate.add(objAccount);
                                    break;
                                }
                            }                             
                        } 
                    }                                            
                } 
                //Update lstBankAccounts;
                update lstBankAccountsToUpdate;  //only updating the ones that changed, which means that the other failed ones won't retrigger the trigger at this point             
            }
         }         
         
         if(!setBankAccountIds1.isEmpty())
         {
             List<Bank_Account__c> lstBankAccounts1 = New List<Bank_Account__c>([Select Id,Account__r.Country__r.CT_Public_Group_ID__c,
                            CT_Finance_Officer__c,LFA_Reviewer__c,Account__r.LFA_Reviewer__c From Bank_Account__c Where Id IN: setBankAccountIds1]);
                            
                             for(Bank_Account__c objAccount: lstBankAccounts1){ 
                             
                             if(objAccount.Account__r.LFA_Reviewer__c != null)
                              objAccount.LFA_Reviewer__c = objAccount.Account__r.LFA_Reviewer__c;
                                                         
                             }
                  
                  if(!StopRecursion.hasAlreadyCreatedBankAcc_LFA_Rev())
                  {         
                     if(!lstBankAccounts1.isEmpty()) 
                     {
                      StopRecursion.setAlreadyCreatedBankAcc_LFA_Rev();
                       update lstBankAccounts1;       
                     }
                  }   
         
         }
    }         
 }