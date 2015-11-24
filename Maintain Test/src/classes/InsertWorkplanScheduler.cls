global class InsertWorkplanScheduler implements Schedulable{
   
   private SmartsheetApi api;
   List<String> sheetIdList = new List<String>();

   List<String> sheetNameList = new List<String>();
   
   public class SheetBatch{
       List<String> sheetNameListinBatch{get;set;}
       List<String> sheetIdListinBatch{get;set;}
   }
   SheetBatch batchInstance;
   List<SheetBatch> sheetBatches;
   global void execute(SchedulableContext SC) {
         api = new SmartsheetApi();
         List<Smartsheet.Sheet> sheetList = api.getSheets();
         if(sheetList.size() > 0){
             Integer sheetCount = 0;
             sheetBatches = new List<SheetBatch>();
              
             for(Smartsheet.Sheet sheetData : sheetList){                 
                 if(sheetCount == 3){
                     batchInstance = new SheetBatch();
                     
                     batchInstance.sheetIdListinBatch = sheetIdList;
                     batchInstance.sheetNameListinBatch = sheetNameList;
                     
                     sheetBatches.add(batchInstance);
                     
                     sheetIdList = new List<String>();
                     sheetNameList = new List<String>();
                     
                     sheetIdList.add(String.valueof(sheetData.id));
                     integer hyphenIndex = sheetData.name.indexof('-');
                     string st = sheetData.name.substring(hyphenIndex+1,sheetData.name.length());
                     
                     system.debug('substring value : Implementation period name : ' + st);
                     
                     sheetNameList.add(st);
                     
                     sheetCount = 0;
                 }else{
                 
                     sheetIdList.add(String.valueof(sheetData.id));
                     integer hyphenIndex = sheetData.name.indexof('-');
                     string st = sheetData.name.substring(hyphenIndex+1,sheetData.name.length());
                     
                     system.debug('substring value : Implementation period name in else : ' + st);
                     
                     sheetNameList.add(st);
                 }
                 sheetCount++;
             }

             batchInstance = new SheetBatch();                     
             batchInstance.sheetIdListinBatch = sheetIdList;
             batchInstance.sheetNameListinBatch = sheetNameList;
             
             sheetBatches.add(batchInstance);
             
             //sheetBatches.add(sheetBatches);
         }
         if(sheetBatches != null && sheetBatches.size() > 0){
             String query = 'Select id, country__C, name, (select name, Id from Attachments) from Implementation_Period__c where name in :grantNameList';
             for(SheetBatch sheetBatchIns : sheetBatches){
                 InsertGrantAttachment ins = new InsertGrantAttachment(sheetBatchIns.sheetIdListinBatch, query, sheetBatchIns.sheetNameListinBatch);                  
                 database.executebatch(ins);
             }
         }
   }
}