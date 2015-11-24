//***************************************************************************************

// Purpose     :  This Class is handler for Trigger-WorkPlanResponsibleTrigger.    
// Date        :  19-Nov-2014
// Created By  :  TCS  
// Author      :  Gaurav Guleria
// Description :  Updates Responsible(Responsible__c) fields in Task and Step Objects with following Values:
//                1. If More than one Child(Responsible)records then Responsible(Responsible__c) will be equal to Responsible
//                  (Responsible__c on Responsible Object)User Names separated by Semicolons. 
//                2. Blank if no related Responsible record. 
//                
//                
//                

public class WorkplanResponsibleTriggerHandler {

     
    
    
    public static void filterResponsibleToInsert(List <Responsible__c > ResponsibleListToFilter) {
            System.debug('@@2:ResponsibleListToFilter'+ResponsibleListToFilter);
           // List<Responsible__c> 4listToInsert=new List<Responsible__c>();
            Set<Id> taskIds=new Set<Id>();
            
           for (Responsible__c res: ResponsibleListToFilter) {
            if (res.Task__c != null){
                    taskIds.add(res.Task__c);
                }                
            }
           List<Responsible__c> listResp= new List<Responsible__c>();
           listResp=[SELECT Id,Responsible__c,Task__c FROM Responsible__c WHERE Task__c in :taskIds];      //Make Correct query    
           System.debug('@@3:listResp'+listResp);
            for(Responsible__c res: ResponsibleListToFilter) 
            {   
                
                for(Responsible__c resMaster:listResp)
                {
                        if(res.Task__c==resMaster.Task__c && res.Responsible__c==resMaster.Responsible__c)
                        {
                          // listToDelete.add(res);
                          res.addError('Responsible already exist for this task');
                        }
                }
                
            }
            //System.debug('@@4listToInsert:'+listToDelete);
           // delete listToDelete;
        }

    public static void updateResponsibleOnTaskAndStep(List < Responsible__c > ResponsibleRecordsList, List < Responsible__c > ResponsibleRecforDelete) {
        //Task record Ids Set
        Set < Id > taskIds = new Set < Id > ();
        //Step record Ids Set 
        Set < Id > stepIds = new Set < Id > ();

        Map < Id, Set < Id >> responsibleUserMapforTask = new Map < Id, Set < Id >> ();
        Map < Id, Set < Id >> responsibleUserMapforSteps = new Map < Id, Set < Id >> ();

        Set < Id > removeUserId = new Set < Id > ();
        //Task records List
        List < Task__c > taskList = new List < Task__c > ();
        //Step records List
        List < Step__c > stepList = new List < Step__c > ();


        //Responsible records List containing Task Ids
        List < Responsible__c > ResponsibleListForTask = new List < Responsible__c > ();
        //For Insert and Update
        if (trigger.isInsert || trigger.isUpdate) {
            for (Responsible__c res: ResponsibleRecordsList) {
                if (String.isNotBlank(res.Step__c)) {
                    stepIds.add(res.Step__c);
                }
                if (String.isNotBlank(res.Task__c)) {
                    taskIds.add(res.Task__c);
                    System.Debug('@@TaskIds' + taskIds);
                }
            }

            if (stepIds.SIZE() > 0) {
                //Query Step records and respective Responsible records with step Ids
                stepList = [SELECT Responsible__c, Task_Name__r.Id, Task_Name__r.ownerId, (SELECT id, Responsible__r.Name FROM Responsible__r) FROM Step__c WHERE ID IN: stepIds];
                //update Responsible field in Step with Responsible User Names separated by Semicolons  
                for (Step__c step: stepList) {
                    List < String > responsibleNameList = new List < String > ();
                    Set < Id > userSet = new Set < Id > ();
                    Integer listSize = 0;
                    String responsibleNames = '';
                    if (step.Responsible__r.SIZE() > 0) {
                        for (Responsible__c res: step.Responsible__r) {
                            if (res.Responsible__c != null && res.Responsible__c != step.Task_Name__r.ownerId) userSet.add(res.Responsible__c);
                            responsibleNameList.add(res.Responsible__r.Name);
                            responsibleNameList.add(';');
                        }
                        listSize = responsibleNameList.SIZE();
                        responsibleNameList[listSize - 1] = '';
                        for (String name: responsibleNameList) {
                            responsibleNames = responsibleNames + name;
                        }
                    }
                    if (!userSet.Isempty()) responsibleUserMapforSteps.put(step.Task_Name__r.Id, userSet);
                    //update Responsible in respective Step
                    step.Responsible__c = responsibleNames;
                }
                //update Step List
                update stepList;
                if (trigger.isInsert || trigger.isupdate) {

                    if (!responsibleUserMapforSteps.Isempty()) {

                        List < Task__Share > taskShareLst = new List < Task__Share > ();
                        for (Id ids: responsibleUserMapforSteps.keyset()) {
                            for (Id userId: responsibleUserMapforSteps.get(Ids)) {
                                Task__Share tskrow = new Task__Share(ParentId = ids, AccessLevel = 'Edit', UserOrGroupId = userId);
                                taskShareLst.add(tskrow);
                            }
                        }
                        if (!taskShareLst.Isempty())
                           insert taskShareLst;

                    }
                }
            }

            if (taskIds.SIZE() > 0) {
                System.debug('@@@In Task loop on 13Dec 14');
                //Query Task records and respective Responsible records with Task Ids
                taskList = [SELECT id, Responsible__c, ownerId, (SELECT id, Responsible__r.Name FROM Responsible__r) FROM Task__c WHERE ID IN: taskIds];
                //update Responsible field in Task with Responsible User Names separated by Semicolons          
                if (taskList.SIZE() > 0) {
                    for (task__c tsk: taskList) {

                        List < String > responsibleNameList = new List < String > ();
                        Set < Id > userSet = new Set < Id > ();
                        Integer listSize = 0;
                        String responsibleNames = '';
                        if (tsk.Responsible__r.SIZE() > 0) {
                            for (Responsible__c res: tsk.Responsible__r) {
                                if (res.Responsible__c != null && res.Responsible__c != tsk.ownerId) userSet.add(res.Responsible__c);
                                responsibleNameList.add(res.Responsible__r.Name);
                                responsibleNameList.add(';');
                            }
                            listSize = responsibleNameList.SIZE();
                            responsibleNameList[listSize - 1] = '';
                            for (String name: responsibleNameList) {
                                responsibleNames = responsibleNames + name;
                            }

                        }
                        if (!userSet.Isempty()) responsibleUserMapforTask.put(tsk.id, userSet);
                        //update Responsible in respective Task
                        tsk.Responsible__c = responsibleNames;
                    }
                    update taskList;

                    if (trigger.isInsert || trigger.isupdate) {
                        if (!responsibleUserMapforTask.Isempty()) {
                            List < Task__Share > taskShareLst = new List < Task__Share > ();
                            for (Id ids: responsibleUserMapforTask.keyset()) {
                                for (Id userId: responsibleUserMapforTask.get(Ids)) {
                                    Task__Share tskrow = new Task__Share(ParentId = ids, AccessLevel = 'Edit', UserOrGroupId = userId);
                                    taskShareLst.add(tskrow);
                                }
                            }

                            if (!taskShareLst.Isempty())
                                insert taskShareLst;
                        }
                    }


                }
            }
        }
        //for Delete
        if (trigger.isDelete) {
            List < Task__c > tsklistresponsibleUpdate =  new List < Task__c >();
            List < Step__c > steplistresponsibleUpdate = new  List < Step__c >();
             Set<Id> allResponsibleSet = new Set<Id>();
            for (Responsible__c res: ResponsibleRecforDelete) {
                if (res.Step__c != null) stepIds.add(res.Step__c);
                if (res.Task__c != null) taskIds.add(res.Task__c);
                if (res.Responsible__c != null) removeUserId.add(res.Responsible__c);
            }
           // if (stepIds.size() > 0) {
                for (Step__c stp: [Select id, Task_Name__c from step__c where id In: stepIds]) {
                    taskIds.add(stp.Task_Name__c);
                }
           // }

           // if (taskIds.size() > 0) {
                for (task__c tsk: [Select id, ownerId, (Select id from Milestones__r) from task__c where id in : taskIds]) {
                    for (Step__c stp: tsk.Milestones__r) {
                        stepIds.add(stp.Id);
                    }
                }
            //}
            Map < Id, List < Step__c >> tsktoSteplistMap = new Map < Id, List < Step__c >> ();
            Map < Id, Id > StepToTaskMap = new Map < Id, Id > ();
            Map < Id, Set < String >> taskSetMap = new Map < Id, Set < String >> ();
            Map < Id, Set < String >> StepSetMap = new Map < Id, Set < String >> ();
            
            
            for (Task__c tsk: [Select id,Responsible__c, ownerId, (Select id from Milestones__r), (Select id, Task__c,Responsible__r.Name, step__c, Responsible__c from Responsible__r) from task__c where id IN: taskIds]) {
                String responsibleNames = '';
                for(Step__c stp : tsk.Milestones__r)
                    stepIds.add(stp.Id);
                if (!tsk.Responsible__r.isEmpty()) {
                    for (Responsible__c res: tsk.Responsible__r) {
                        responsibleNames += res.Responsible__r.Name +',';
                        if (taskSetMap.keySet().contains(tsk.id)) {
                            Set < String > repSet = taskSetMap.get(tsk.id);
                            repSet.add(res.responsible__c);
                            repSet.add(tsk.OwnerId);
                            allResponsibleSet.add(res.responsible__c);
                            allResponsibleSet.add(tsk.OwnerId);
                            taskSetMap.put(res.Task__c, repset);
                        } else {
                            Set < String > repSet = new Set < String > ();
                            repSet.add(res.responsible__c);
                            repSet.add(tsk.OwnerId);
                            allResponsibleSet.add(res.responsible__c);
                            allResponsibleSet.add(tsk.OwnerId);
                            taskSetMap.put(tsk.Id, repSet);
                        }
                        
                        
                    }
                }
                List < Step__c > stepsLst = new List < Step__c > ();
                if (!tsk.Milestones__r.isEmpty()) {
                    for (Step__c s: tsk.Milestones__r) {
                        stepsLst.add(s);
                        stepIds.add(s.Id);
                    }
                }
                tsktoSteplistMap.put(tsk.Id, stepsLst);
                tsk.Responsible__c = responsibleNames.removeEnd(',');
                tsklistresponsibleUpdate.add(tsk);
            }
            System.Debug('@@@@@@@@@'+stepIds);
            for (Step__c stp: [Select id,Responsible__c, Task_Name__c, Task_Name__r.OwnerId, (Select id, Responsible__r.Name, Step__r.Task_Name__c, Task__c, step__c, Responsible__c from Responsible__r) from Step__c where Id IN: stepIds]) {
                 String responsibleNames = '';
                if (!stp.Responsible__r.isEmpty()) {
                    for (Responsible__c res: stp.Responsible__r) {
                         responsibleNames += res.Responsible__r.Name +',';
                        if (StepSetMap.keySet().contains(stp.Id)) {
                            Set < String > repSet = StepSetMap.get(stp.Id);
                            repSet.add(res.responsible__c);
                            repSet.add(stp.Task_Name__r.OwnerId);
                            allResponsibleSet.add(res.responsible__c);
                            allResponsibleSet.add(stp.Task_Name__r.OwnerId);
                            StepSetMap.put(res.Step__c, repSet);
                        } else {
                            Set < String > repSet = new Set < String > ();
                            repSet.add(res.Responsible__c);
                            repSet.add(stp.Task_Name__r.OwnerId);
                            allResponsibleSet.add(res.responsible__c); 
                            allResponsibleSet.add(stp.Task_Name__r.OwnerId);
                            StepSetMap.put(res.Step__c, repSet);
                        }
                    }
                }
                StepToTaskMap.put(stp.Id, stp.Task_Name__c);
                stp.Responsible__c = responsibleNames.removeEnd(',');
                steplistresponsibleUpdate.add(stp);
            }
            
      
            System.Debug('@@taskSetMap' + taskSetMap);
            System.Debug('@@tsktoSteplistMap' + tsktoSteplistMap);
            System.Debug('@@StepSetMap' + StepSetMap);
            System.Debug('@@StepToTaskMap' + StepToTaskMap);
            system.Debug('allResponsibleSet' + allResponsibleSet);
            Map < Id, set < Id >> itemTodelete = new Map < Id, set < Id >> ();
            Id tskId;
            for (Responsible__c res: ResponsibleRecforDelete) {
                tskId = null;
                // if(!taskSetMap.Isempty() || !StepSetMap.Isempty()){
                if (res.Task__c != null) {
                     if (res.Responsible__c != null && !allResponsibleSet.contains(res.Responsible__c)) {    
                                if (!itemTodelete.containsKey(res.Task__c)) 
                                    itemTodelete.put(res.Task__c, new Set < Id > ());
                                itemTodelete.get(res.Task__c).add(res.Responsible__c);

                     }
                }
                system.debug('*****1******' + res.step__c);
                if (res.step__c != null) {
                    system.debug('*****2******' + res.Responsible__c);
                    tskId = StepToTaskMap.get(res.step__c);
                    system.Debug('allResponsibleSet' + allResponsibleSet);
                        
                        if (res.Responsible__c != null && !allResponsibleSet.contains(res.Responsible__c)) {
                           
                                if (!itemTodelete.containsKey(tskId)) 
                                    itemTodelete.put(tskId, new Set < Id > ());
                                itemTodelete.get(tskId).add(res.Responsible__c);

                        }
                }
            }

            if (!itemTodelete.Isempty()) {

                Set < Id > parentIdset = new Set < Id > ();
                Set < Id > userIdset = new Set < Id > ();
                for (id ids: itemTodelete.keyset()) {
                    parentIdset.add(ids);
                    userIdset.addAll(itemTodelete.get(ids));
                }
                system.debug('*****parentIdset******' + parentIdset);
                system.debug('*****userIdset******' + userIdset);
                List < Task__Share > removetaskShareLst = [Select id from Task__Share where UserOrGroupId IN: userIdset and parentId IN: parentIdset and RowCause = 'Manual'];
                system.debug('*****removetaskShareLst******' + removetaskShareLst);
                if (!removetaskShareLst.Isempty()) delete removetaskShareLst;
            }
            if(!tsklistresponsibleUpdate.isempty())
                update tsklistresponsibleUpdate;
            
            if(!steplistresponsibleUpdate.isempty())
                update steplistresponsibleUpdate;
        }

    }
}