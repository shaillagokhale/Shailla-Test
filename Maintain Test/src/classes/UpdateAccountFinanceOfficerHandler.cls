/*********************************************************************************
* Class: UpdateAccountFinanceOfficerHandler
* Created by {DeveloperName}, {DateCreated 12/06/2013}
----------------------------------------------------------------------------------
* Purpose: This class is is used to set Finance officer of Account from 
    UpdateAccountFinanceOfficer trigger.
----------------------------------------------------------------------------------
*********************************************************************************/
Public class UpdateAccountFinanceOfficerHandler {

    //Runs on insert or on update if country has changed or CT_Finance_Officer__c is null
    Public static void aiuSetAccountFinanceOfficer(List<Account> lstNewAccounts,Map<Id,Account> mapOldAccounts, Boolean blnIsInsert, Boolean blnIsUpdate) {
        Set<Id> setAccountIds = New Set<Id>();
        List<Account> lstAccountsToUpdate = New List<Account>();
        for(Account objAccount: lstNewAccounts){
            if(blnIsInsert && objAccount.Country__c != null){
                    setAccountIds.Add(objAccount.Id);
                    System.debug('setAccountIds'+setAccountIds);
            }else if(blnIsUpdate && objAccount.Country__c != null && (objAccount.Country__c != mapOldAccounts.get(objAccount.Id).Country__c || objAccount.CT_Finance_Officer__c == null)){
                setAccountIds.Add(objAccount.Id);
                 System.debug('setAccountIds'+setAccountIds);
            }
        }
        
        if(setAccountIds.Size()>0){
            List<Account> lstAccounts = New List<Account>([Select Id,Country__r.CT_Public_Group_ID__c,CT_Finance_Officer__c From Account Where Id IN: setAccountIds 
                                                          AND Locked__c = false AND (Country__r.CT_Public_Group_ID__c != '' OR Country__r.CT_Public_Group_ID__c != null)]);  //2014-16-06 Locked__c criterion added by Matthew Miller
            System.debug('lstAccounts '+lstAccounts);
            Set<String> setCTPublicGroupIds = New Set<String>();
            if(lstAccounts.size()>0){
                for(Account objAcc: lstAccounts){
                    setCTPublicGroupIds.Add(objAcc.Country__r.CT_Public_Group_ID__c);
                    System.debug('setCTPublicGroupIds'+setCTPublicGroupIds);
                }
            }
            
            if(setCTPublicGroupIds.size() > 0){
                List<GroupMember> lstCTGroupMembers = New List<GroupMember>([Select UserOrGroupId,GroupId From GroupMember 
                                Where GroupId IN : setCTPublicGroupIds]);
                System.debug('lstCTGroupMembers'+lstCTGroupMembers);               
                Map<Id,Set<Id>> mapGroupMember = New  Map<Id,Set<Id>>();
                if(lstCTGroupMembers.size()>0){
                    for(GroupMember objGroupMember: lstCTGroupMembers){
                        if(mapGroupMember.Containskey(objGroupMember.GroupId)){
                            mapGroupMember.get(objGroupMember.GroupId).Add(objGroupMember.UserOrGroupId);
                            System.debug('mapGroupMember'+mapGroupMember);   
                        } else{
                            mapGroupMember.put(objGroupMember.GroupId, New Set<Id>{objGroupMember.UserOrGroupId});
                            System.debug('mapGroupMember'+mapGroupMember);   
                        }
                    }
                }
                
                List<GroupMember> lstGroupMembers = New List<GroupMember>([Select UserOrGroupId,Group.DeveloperName From GroupMember 
                                Where Group.DeveloperName = 'CT_All_Program_Finance']);  
                Set<Id> setGroupMembersUserIds = New Set<Id>();
                if(lstGroupMembers.Size()>0){
                    for(GroupMember objGroupMember: lstGroupMembers){
                        setGroupMembersUserIds.Add(objGroupMember.UserOrGroupId);
                        System.debug('setGroupMembersUserIds'+setGroupMembersUserIds);  
                    }
                }
                              
                for(Account objAccount: lstAccounts){ 
                    if(mapGroupMember.get(objAccount.Country__r.CT_Public_Group_ID__c) != null && setGroupMembersUserIds.size()>0 &&    
                        mapGroupMember.get(objAccount.Country__r.CT_Public_Group_ID__c).size() >0){  
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
                //Update lstAccounts; 
                update lstAccountsToUpdate;    //Only updating the accounts where the FO was added            
            }
        }         
    }         
 }