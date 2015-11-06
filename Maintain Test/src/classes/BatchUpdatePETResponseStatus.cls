global class BatchUpdatePETResponseStatus implements Database.Batchable<sObject> {
   global final String Query;
   global final String WpId;   
   global final String Status;
   global final Set<ID> setPEToUpdate;
   global BatchUpdatePETResponseStatus(String q,Set<ID> setPET){
       //WpId = WpId;
       System.debug('@@@@@@@setPEToUpdate ' + setPEToUpdate);
       setPEToUpdate=new Set<Id>();
       setPEToUpdate.addAll(setPET);
       //setPEToUpdate = setPEToUpdate;  
       Query = q;
      // Status = s;
   }
   global Database.QueryLocator start(Database.BatchableContext BC){
       return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
       if(scope != null && scope.size() > 0){
          PerformanceEvalutionHandler.auUpdatePetResponse((List<PET_Response__c>)scope);
          System.debug('@@@@@@@@@@@@ (List<PET_Response__c>)scope' + (List<PET_Response__c>)scope);
            
       }
   }

   global void finish(Database.BatchableContext BC){
   
   }
}