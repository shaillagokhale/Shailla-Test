Public without sharing Class UpdateRegionalTotalHandler {
    Public static void aiuUpdateRegionalTotalForRegionalBudgets(List<LFA_Work_Plan__c> triggerNew,
                                                              map<id,LFA_Work_Plan__c> oldMap,
                                                              Boolean isInsert,Boolean isUpdate,
                                                              Boolean isDelete,Boolean isUndelete){
        
        set<id> setRegionalBudgetsIds = New Set<Id>(); 
        if(isInsert || isUndelete || isUpdate){
            for(LFA_Work_Plan__c objWorkPlan: triggerNew){
                if((isInsert || isUndelete) && objWorkPlan.Regional_Budget__c != null && 
                                               objWorkPlan.Total_Budget__c != null){
                    setRegionalBudgetsIds.add(objWorkPlan.Regional_Budget__c);                
                }else if(isUpdate && (objWorkPlan.Regional_Budget__c != oldMap.get(objWorkPlan.Id).Regional_Budget__c ||
                                       objWorkPlan.Total_Budget__c != oldMap.get(objWorkPlan.Id).Total_Budget__c)) {
                    if(objWorkPlan.Regional_Budget__c != null){
                        setRegionalBudgetsIds.Add(objWorkPlan.Regional_Budget__c );                    
                    }
                    if(oldMap.get(objWorkPlan.Id).Regional_Budget__c != null){
                        setRegionalBudgetsIds.Add(oldMap.get(objWorkPlan.Id).Regional_Budget__c);                    
                    }               
                }
            }
        }else if(isDelete){
            for(LFA_Work_Plan__c objWorkPlan: oldMap.values()){
                if(objWorkPlan.Regional_Budget__c != null && objWorkPlan.Total_Budget__c != null){
                        setRegionalBudgetsIds.Add(objWorkPlan.Regional_Budget__c); 
                }
            }
        }
        
        if(setRegionalBudgetsIds.size() > 0){
            List<Regional_Budget__c> lstRegionalBudget = new List<Regional_Budget__c>();
            List<Regional_Budget__c> lstRegionalBudgetToUpdate = new List<Regional_Budget__c>();
            lstRegionalBudget = [Select id, Current_Regional_Total__c,
                                                (Select id,Total_Budget__c 
                                                from LFA_Work_Plans__r where 
                                                Total_Budget__c != null) 
                                            from Regional_Budget__c Where id IN : setRegionalBudgetsIds];
            for(Regional_Budget__c RB : lstRegionalBudget){
                Decimal CurrentRegionalTotal = 0;
                if(RB.LFA_Work_Plans__r.size() > 0){                    
                    for(LFA_Work_Plan__c WP : RB.LFA_Work_Plans__r){
                        if(WP.Total_Budget__c != null){                           
                            CurrentRegionalTotal += WP.Total_Budget__c;
                        }
                    }
                }                
                if(RB.Current_Regional_Total__c != CurrentRegionalTotal){
                    RB.Current_Regional_Total__c = CurrentRegionalTotal;
                    lstRegionalBudgetToUpdate.add(RB);
                }                
            }
            if(lstRegionalBudgetToUpdate.Size()>0){
                Update lstRegionalBudgetToUpdate;
            }
        }
    }
}