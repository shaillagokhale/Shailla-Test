global class InsertGrantAttachment implements Database.Batchable<sObject>, Database.AllowsCallouts{

   global List<String> currentBatchSheetIdList;
   global final String Query;
   global List<String> grantNameList;
   private SmartsheetApi api;
   global InsertGrantAttachment (List<String> sheetIdList, String q, List<String> grantNameLstTemp){
      currentBatchSheetIdList = sheetIdList;
      Query = q;
      grantNameList = grantNameLstTemp;
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
     String Token = Smartsheet_Token__c.getinstance('Payal').Access_Token__c;   
     HttpResponse response;   
     Smartsheet.Sheet sheet;  
     api = new SmartsheetApi();
     List<Attachment> attLstInsert = new List<Attachment>();
     String grantName;
     Attachment a;
     Implementation_Period__C ip;
     String attachmentName;
     for(String sheetIdStr : currentBatchSheetIdList){
         if(sheetIdStr != '923676037146500')
         sheet = api.getSheet(Long.valueof(sheetIdStr), Token);
         Boolean createBackUp = false; 
         if(sheet != null){

             integer hyphenIndex = sheet.name.indexof('-');
             grantName = sheet.name.substring(hyphenIndex+1,sheet.name.length());
             Integer ColoumnId = 0;
             Integer coloumnIndex = 0;             
             Integer submitColoumnInd = 0;
             for (Integer j=0; j<sheet.columns.size(); j++) {                                  
                   Smartsheet.Column column = sheet.columns.get(j); 
                   if(column.getTitle().equals('Submit')){
                       submitColoumnInd = column.index;
                       break;
                   }
             }
             
            
            
             for (Smartsheet.row sheetRow : sheet.rows)
             {
                system.debug('Row Number : ' + sheetRow.rowNumber);
                if(sheetRow.rowNumber == 1){
                    system.debug(' Submit sheet : ' + sheetRow.cells[submitColoumnInd].value);
                    if(sheetRow.cells[submitColoumnInd].value.equalsIgnoreCase('true')){
                        createBackUp = true;                                                 
                    }
                    break;
                }
             }
                if(createBackUp){
                    response = api.getSheetAsExcel(Long.valueof(sheetIdStr), Token);

                    Boolean attachmentFound = false;
                    if(response != null){
                        for(Sobject s : scope){
                        ip = (Implementation_Period__C)s;
                        if(ip.Name == grantName){                    
                            attachmentName = ip.Country__C + '-' + ip.Name;
                            break;
                        }
                        }                           
                        if(ip.Attachments != null && ip.Attachments.size() > 0){
                            for(Attachment at : ip.Attachments){
                                if(at.Name.equals(attachmentName)){
                                    attachmentFound = true;
                                    a = at;
                                    break;
                                }
                            }
                        }
                       if(attachmentFound){
                            //a = ip.Attachments.get(0);
                            a.body = response.getBodyAsBlob();
                       }else{
                            a = new Attachment();
                            a.ParentId = ip.id;
                            a.Name = attachmentName;
                            a.body = response.getBodyAsBlob();
                       } 
                       system.debug('grant Id : ' + ip.id + ' Attachment Name : ' + a.name);
                       attLstInsert.add(a);
                     
                     
                }                 
             } 
             
         }
     
      }     
      if( !attLstInsert.Isempty())
         upsert attLstInsert;
   }
   global void finish(Database.BatchableContext BC){
   }
}