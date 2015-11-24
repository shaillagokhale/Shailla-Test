global class UpdateGrantBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{

   global List<String> currentBatchSheetIdList;
   global final String Query;
   global List<String> grantNameList;
   private SmartsheetApi api;
   global UpdateGrantBatch(List<String> sheetIdList, String q, List<String> grantNameLstTemp){

      currentBatchSheetIdList = sheetIdList;
      Query = q;
      grantNameList = grantNameLstTemp;
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
     String Token = Smartsheet_Token__c.getinstance('Payal').Access_Token__c;
     Smartsheet.Sheet sheet;      
     List<Smartsheet_Templates__c> templateDetails = [Select Template_Name__c,Task_Code__c,TaskNameEndDate__c,TaskNameStartDate__c from Smartsheet_Templates__c where Operation__c =: 'Outbound'];
     Workplan__C wp;
     List<Workplan__C> wpList = new List<Workplan__c>();
     api = new SmartsheetApi();    
     
     for(String sheetIdStr : currentBatchSheetIdList){
         if(sheetIdStr != '923676037146500')
         sheet = api.getSheet(Long.valueof(sheetIdStr), Token);
         Boolean insertWorkplanDates = false; 
         if(sheet != null){

             integer hyphenIndex = sheet.name.indexof('-');
             String grantName = sheet.name.substring(hyphenIndex+1,sheet.name.length());
             Integer ColoumnId = 0;
             Integer coloumnIndex = 0;
             Smartsheet.Row rowDetailToGetFD; 
             Integer submitColoumnInd = 0;
             for (Integer j=0; j<sheet.columns.size(); j++) {
                                  
                   Smartsheet.Column column = sheet.columns.get(j);                  
                   if(column.getTitle().equals('Task Code'))
                   {
                    coloumnID = Integer.valueof(column.id);
                    coloumnIndex = column.index;
                    system.debug('Coloumn index in Batch: ' + coloumnIndex + ' coloumn ID in Batch ' + ColoumnId);
                   }
                   if(column.getTitle().equals('Submit')){
                       submitColoumnInd = column.index;
                   }
             }
             Boolean fdRowFound = false;
             Implementation_Period__C ip;
             
             for(Sobject s : scope){
                ip = (Implementation_Period__C)s;
                if(ip.name.equals(grantName)){                   
                    if(ip.workplan__r != null && ip.workplan__r.size() > 0){
                        system.debug('Workplan is not null');
                        wp = ip.workplan__r.get(0);
                        wp.name = ip.Country__C + '-' + ip.Name;
                    }else{
                        system.debug('Workplan is null');
                        wp = new Workplan__C();
                        wp.name = ip.Country__C + '-' + ip.Name;
                    }
                    system.debug('Grant Name : ' + ip.name);
                    break;
                }
             }
             for (Smartsheet.row sheetRow : sheet.rows)
             {
                system.debug('Row Number : ' + sheetRow.rowNumber);
                if(sheetRow.rowNumber == 1){
                    system.debug(' Submit sheet : ' + sheetRow.cells[submitColoumnInd].value);
                    if(sheetRow.cells[submitColoumnInd].value.equalsIgnoreCase('true')){
                        insertWorkplanDates = true;                         
                        continue;  
                    }else{
                        wp = null;
                        break;
                    }
                }
                if(insertWorkplanDates){
                    for(Smartsheet_Templates__c sheetTemplate : templateDetails){
                        if(!(sheetRow.cells.size() < 4)){
                            if(sheetTemplate.Task_Code__c == sheetRow.cells[coloumnIndex].value){
                            system.debug('I m inside if');                            
                                if(sheetTemplate.TaskNameEndDate__c != null && sheetRow.cells[coloumnIndex + 2].value != null && sheetRow.cells[coloumnIndex + 2].type == 'DATE'){
                                    system.debug('API name : ' + sheetTemplate.TaskNameEndDate__c + ' cell value : ' +  sheetRow.cells[coloumnIndex + 2].value);
                                    wp.put(sheetTemplate.TaskNameEndDate__c, Date.valueof(sheetRow.cells[coloumnIndex + 2].value));
                                }
                                if(sheetTemplate.TaskNameStartDate__c != null && sheetRow.cells[coloumnIndex + 1].value != null && sheetRow.cells[coloumnIndex + 1].type == 'DATE'){
                                    system.debug('API name : ' + sheetTemplate.TaskNameStartDate__c + ' cell value : ' +  sheetRow.cells[coloumnIndex + 1].value);
                                    wp.put(sheetTemplate.TaskNameStartDate__c, Date.valueof(sheetRow.cells[coloumnIndex + 1].value));
                                }
                                break;
                            }
                        }
                    }    
                }                 
             } 
             system.debug('workplan : ' + wp);
             if(wp != null){
                 if(wp.Implementation_Period__r != null){                 
                     wp.Implementation_Period__r = ip;
                 }else{               
                    wp.Implementation_period__c = ip.id;        
                 }    
                 system.debug('adding wp');
                 wpList.add(wp);
                 ip.Workplan__r.addAll(wpList);
             }
        }
        
   }
   if(wpList != null && wpList.size() > 0)
   upsert(wpList);
   //update(scope);
   }
   global void finish(Database.BatchableContext BC){
   }
}