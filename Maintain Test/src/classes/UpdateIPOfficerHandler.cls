/*********************************************************************************
* Class: UpdateIPOfficerHandler 
* Created by {DeveloperName}, {DateCreated 12/10/2013}
----------------------------------------------------------------------------------
* Purpose: This class is is used to set Finance and Legal officer of 
    Implementation_Period__c from UpdateIPOfficer trigger.
----------------------------------------------------------------------------------
*********************************************************************************/
Public class UpdateIPOfficerHandler {
    Public Static Boolean blnPreventRecursion = false;
    Public static void aiuSetIPOfficer(List<Implementation_Period__c> lstNewIP,Map<Id,Implementation_Period__c> mapOldIP, Boolean blnIsInsert, Boolean blnIsUpdate) {
        Set<Id> setIPIds = New Set<Id>();
        for(Implementation_Period__c objIP: lstNewIP){
           if(!objIP.Locked__c){ 
              setIPIds.Add(objIP.Id);
              System.debug('setIPIds'+setIPIds);
           }
        }
        
        if(setIPIds.Size()>0){
            List<Implementation_Period__c> lstIP = New List<Implementation_Period__c>([Select Id,Principal_Recipient__r.Country__r.CT_Public_Group_ID__c,
                            CT_Finance_Officer__c,CT_Legal_Officer__c  From Implementation_Period__c Where Id IN: setIPIds
                            And Principal_Recipient__r.Country__c != null 
                            And (Principal_Recipient__r.Country__r.CT_Public_Group_ID__c != '' OR Principal_Recipient__r.Country__r.CT_Public_Group_ID__c != null)]); 
           /*  List<Implementation_Period__c> lstIP = New List<Implementation_Period__c>([Select Id,Principal_Recipient__r.Country__r.CT_Public_Group_ID__c,
                            CT_Finance_Officer__c,CT_Legal_Officer__c  From Implementation_Period__c Where Id IN: setIPIds ]); */           
            System.debug('lstIP'+lstIP);               
            Set<String> setCTPublicGroupIds = New Set<String>();
            if(lstIP.size()>0){
                for(Implementation_Period__c objIP : lstIP){
                    setCTPublicGroupIds.Add(objIP.Principal_Recipient__r.Country__r.CT_Public_Group_ID__c);
                    system.debug('setCTPublicGroupIds'+setCTPublicGroupIds);
                }
            }
            
            if(setCTPublicGroupIds.size() > 0){
                List<GroupMember> lstCTGroupMembers = New List<GroupMember>([Select UserOrGroupId,GroupId From GroupMember 
                                Where GroupId IN : setCTPublicGroupIds]);
                system.debug('lstCTGroupMembers '+lstCTGroupMembers );              
                Map<Id,Set<Id>> mapGroupMember = New  Map<Id,Set<Id>>();
                if(lstCTGroupMembers.size()>0){
                    for(GroupMember objGroupMember: lstCTGroupMembers){
                        if(mapGroupMember.Containskey(objGroupMember.GroupId)){
                            mapGroupMember.get(objGroupMember.GroupId).Add(objGroupMember.UserOrGroupId);
                            system.debug('mapGroupMember'+mapGroupMember);
                        } else{
                            mapGroupMember.put(objGroupMember.GroupId, New Set<Id>{objGroupMember.UserOrGroupId});
                            system.debug('mapGroupMember'+mapGroupMember);
                        }
                    }
                }
                
                List<GroupMember> lstGroupMembers = New List<GroupMember>([Select UserOrGroupId,Group.DeveloperName From GroupMember 
                                Where Group.DeveloperName = 'CT_All_Program_Finance' OR Group.DeveloperName = 'CT_All_Legal']);
                system.debug('lstGroupMembers'+lstGroupMembers);                  
                Map<String,Set<Id>> MapGroupDevNameToUserIds = New Map<String,Set<Id>>();
                if(lstGroupMembers.Size()>0){
                    for(GroupMember objGroupMember: lstGroupMembers){
                        if(MapGroupDevNameToUserIds.Containskey(objGroupMember.Group.DeveloperName)){
                            MapGroupDevNameToUserIds.get(objGroupMember.Group.DeveloperName).Add(objGroupMember.UserOrGroupId);
                        } else{
                            MapGroupDevNameToUserIds.put(objGroupMember.Group.DeveloperName, New Set<Id>{objGroupMember.UserOrGroupId});
                        }
                    }
                }
                              
                for(Implementation_Period__c objIPNew: lstIP){ 
                    if(mapGroupMember.get(objIPNew.Principal_Recipient__r.Country__r.CT_Public_Group_ID__c) != null &&    
                        mapGroupMember.get(objIPNew.Principal_Recipient__r.Country__r.CT_Public_Group_ID__c).size() >0){
                        System.debug('insidefirstIF');
                        if(MapGroupDevNameToUserIds.get('CT_All_Program_Finance') != null && MapGroupDevNameToUserIds.get('CT_All_Program_Finance').size() > 0){
                        System.debug('insideSecondIF');
                            if (mapGroupMember.get(objIPNew.Principal_Recipient__r.Country__r.CT_Public_Group_ID__c).size() <  MapGroupDevNameToUserIds.get('CT_All_Program_Finance').size()){
                              System.debug('insideThirdIF');                                                
                                for(Id UserId : mapGroupMember.get(objIPNew.Principal_Recipient__r.Country__r.CT_Public_Group_ID__c)){
                                    if(MapGroupDevNameToUserIds.get('CT_All_Program_Finance').Contains(UserId)){ 
                                        objIPNew.CT_Finance_Officer__c = UserId; 
                                        system.debug('objIPNew.CT_Finance_Officer__c'+objIPNew.CT_Finance_Officer__c);
                                        break;
                                    }
                                }
                            }else{                            
                                for(Id UserId : MapGroupDevNameToUserIds.get('CT_All_Program_Finance')){                                
                                    if(mapGroupMember.get(objIPNew.Principal_Recipient__r.Country__r.CT_Public_Group_ID__c).Contains(UserId)){ 
                                        objIPNew.CT_Finance_Officer__c = UserId; 
                                        system.debug('objIPNew.CT_Finance_Officer__c'+objIPNew.CT_Finance_Officer__c);
                                        break;
                                    }
                                }                             
                            } 
                        }
                        
                        if(MapGroupDevNameToUserIds.get('CT_All_Legal') != null && MapGroupDevNameToUserIds.get('CT_All_Legal').size() > 0){
                            if (mapGroupMember.get(objIPNew.Principal_Recipient__r.Country__r.CT_Public_Group_ID__c).size() <  MapGroupDevNameToUserIds.get('CT_All_Legal').size()){                                                  
                                for(Id UserId : mapGroupMember.get(objIPNew.Principal_Recipient__r.Country__r.CT_Public_Group_ID__c)){
                                    if(MapGroupDevNameToUserIds.get('CT_All_Legal').Contains(UserId)){ 
                                        objIPNew.CT_Legal_Officer__c = UserId; 
                                        break;
                                    }
                                }
                            }else{                            
                                for(Id UserId : MapGroupDevNameToUserIds.get('CT_All_Legal')){                                
                                    if(mapGroupMember.get(objIPNew.Principal_Recipient__r.Country__r.CT_Public_Group_ID__c).Contains(UserId)){ 
                                        objIPNew.CT_Legal_Officer__c = UserId; 
                                        break;
                                    }
                                }                             
                            } 
                        }
                    }                                            
                } 
                blnPreventRecursion = true;
                Update lstIP;  
                blnPreventRecursion = false;        
            }
        }         
    }
    Public static void aiSetIPCycle(List<Implementation_Period__c> lstNewIP) {
        if(lstNewIP.size() > 0){
            Set<Id> setGrantIds = New Set<Id>();
            Set<Id> setIPIds = New Set<Id>();
            for(Implementation_Period__c objIP: lstNewIP){
                if(objIP.Grant__c != null){
                    setGrantIds.Add(objIP.Grant__c);
                    setIPIds.Add(objIP.Id);
                }
            }
            system.debug('$%#$#$#$'+setGrantIds);
            if(setGrantIds.size() > 0){
                Map<Id,Grant__c> MapGrant = new Map<id,Grant__c>([Select (Select id from Implementation_Periods__r where Id NOT IN : setIPIds) From Grant__c Where ID IN : setGrantIds]);
                
                List<Implementation_Period__c> lstIPToUpdate = new List<Implementation_Period__c>();
                Implementation_Period__c objIPNew;
                for(Implementation_Period__c objIP: lstNewIP){
                    objIPNew = new Implementation_Period__c(id = objIP.id);
                    if(MapGrant.containsKey(objIP.Grant__c)){
                        if(MapGrant.get(objIP.Grant__c) != null && MapGrant.get(objIP.Grant__c).Implementation_Periods__r.size() > 0){
                            objIPNew.Id = objIP.id;
                            Integer count = MapGrant.get(objIP.Grant__c).Implementation_Periods__r.size() + 1;
                            if(count <= 9){
                                objIPNew.Implementation_Cycle__c = '0'+count;
                            }else{
                                objIPNew.Implementation_Cycle__c = String.valueof(MapGrant.get(objIP.Grant__c).Implementation_Periods__r.size() + 1);
                            }
                        }else{
                            objIPNew.Implementation_Cycle__c = '01';
                        } 
                    }
                    lstIPToUpdate.add(objIPNew);
                }
                if(lstIPToUpdate.size() > 0) update lstIPToUpdate;
            }
        }
    }
 }