global class BatchUpdateResourceStatus implements Database.Batchable<sObject> {
   global final String Query;
   global final String WpId;   
   global final String Status;
   global BatchUpdateResourceStatus(String q,String WpId,String s){
       WpId = WpId;
       Query = q;
       Status = s;
   }
   global Database.QueryLocator start(Database.BatchableContext BC){
       return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
       if(scope != null && scope.size() > 0){
           for(LFA_Resource__c s:(List<LFA_Resource__c>)scope){
               s.WP_Status_text__c = Status;
               s.WasNegotiationOrLFAAgreed__c = true;
           }
           update scope;
       }
   }

   global void finish(Database.BatchableContext BC){
   }
}