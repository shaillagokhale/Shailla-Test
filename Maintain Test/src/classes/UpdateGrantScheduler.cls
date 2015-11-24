global class UpdateGrantScheduler implements Schedulable{
   
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
                 if(sheetCount == 4){
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
             String query = 'Select id, name, country__C, First_Disbursement_End_Date__c, First_Disbursement_Start_Date__c, (Select Annual_Procurement_Review_End_Date__c,Annual_Procurement_Review_Start_Date__c,Anti_Terrorism_Screening_End_Date__c,Anti_Terrorism_Screening_Start_Date__c, Asset_Procement_Plan_End_Date__c,Asset_procement_plan_Start_Date__c,Board_Approval_of_the_Renewal_End_Date__c,Board_Approval_of_the_Renewal_Start_Date__c,Board_approves_Grant_End_Date__c,CCM_develops_Concept_Note_End_Date__c,CCM_develops_Concept_Note_Start_Date__c, Country_Risk_Assessment_End_Date__c,Country_Risk_Assessment_Start_Date__c, CP_ADMF_Process_End_Date__c, CP_ADMF_Process_Start_Date__c,CT_approves_Auditor_select_End_Date__c, CT_approves_Auditor_select_Start_Date__c,CT_approves_closure_plan_End_Date__c,CT_approves_closure_plan_Start_Date__c, CT_QUART_Creation_End_Date__c, CT_QUART_Creation_Start_Date__c, CT_review_and_submit_document_End_Date__c  ,CT_review_and_submit_document_Start_Date__c,CT_sends_feedback_to_the_PR_End_Date__c,CT_sends_feedback_to_the_PR_Start_Date__c,CT_sends_TOR_to_the_PR_End_Date__c,CT_sends_TOR_to_the_PR_Start_Date__c,CT_submit_PR_Capacity_Assessment_EndDt__c, CT_Submit_PR_Capacity_Assessment_StartDt__c,CT_verifies_agrees_LFA_End_Date__c,CT_verifies_agrees_LFA_Start_Date__c,Detailed_budget_target_End_Date__c, Detailed_budget_target_Start_Date__c,EFR_LFA_Due_date_End_Date__c, EFR_LFA_Due_date_Start_Date__c,EFR_PR_Due_date_End_Date__c,EFR_PR_Due_date_Start_Date__c,Extension_Review_End_Date__c,Extension_Review_Start_Date__c,Final_closure_report_document_End_Date__c,Final_closure_report_document_Start_Date__c ,Finance_Process_End_Date__c,Finance_Process_Start_Date__c,GAC_Review_Make_Recommendation_EndDt__c,GAC_Review_Make_Recommendation_StartDt__c, GAC_Reviews_and_Approves_End_Date__c ,GAC_Reviews_and_Approves_Start_Date__c,Grant_Closure_letter_to_PR_End_Date__c,Grant_Closure_letter_to_PR_Start_Date__c,Grant_Closure_plan_budget_End_Date__c,Grant_Closure_plan_budget_Start_Date__c,Grant_Document_Submit_to_GAC_End_Dt__c,Grant_Document_Submit_to_GAC_Start_Dt__c, Grant_Signing_at_Renewal_End_Date__c,Grant_Signing_at_Renewal_Start_Date__c,Guidance_on_grant_closure_End_Date__c,Guidance_on_grant_closure_Start_Date__c,LFA_sends_PR_SR_Audit_report_End_Date__c,LFA_sends_PR_SR_Audit_report_Start_Date__c,LFA_submits_OSDV_report_End_Date__c,LFA_submits_OSDV_report_Start_Date__c,Mess_tool_due_date_End_Date__c, Mess_tool_due_date_Start_Date__c,Other_milestones_End_Date__c, Other_milestones_Start_Date__c,Preassessment_Report_CCM_End_Date__c,Preassessment_Report_CCM_Start_Date__c, PR_submit_Auditor_selected_End_Date__c,PR_submit_Auditor_selected_Start_Date__c,PR_submit_Audit_Plan_End_Date__c,PR_submit_Audit_Plan_Start_Date__c,PR_submit_PR_SR_Audit_Report_End_Date__c,PR_submit_PR_SR_Audit_Report_Start_Date__c,Publishing_Process_End_Date__c, Publishing_Process_Start_Date__c,QUART_review_by_ORC_End_Date__c, QUART_review_by_ORC_Start_Date__c,QUART_Review_by_QA_End_Date__c,QUART_Review_by_QA_Start_Date__c,Request_for_Renewal_by_CCM_End_Date__c,Request_for_Renewal_by_CCM_Start_Date__c,Review_by_Renewals_Panel_End_Date__c,Review_by_Renewals_Panel_Start_Date__c,Review_of_Request_for_Renewal_End_Date__c,Review_of_Request_for_Renewal_Start_Date__c, Secretariat_signs_Grant_End_Date__c, Secretariat_signs_Grant_Start_Date__c,Training_plan_due_date_End_Date__c, Training_plan_due_date_Start_Date__c,TRP_Reviews_Document_and_Submits_EndDt__c  ,TRP_Reviews_Document_and_Submits_StartDt__c ,Visit_Performed_on_End_Date__c,Visit_Performed_on_Start_Date__c from Implementation_Period__C.Workplan__r) from Implementation_Period__c where name in :grantNameList';
             for(SheetBatch sheetBatchIns : sheetBatches){
                 UpdateGrantBatch b = new UpdateGrantBatch(sheetBatchIns.sheetIdListinBatch, query, sheetBatchIns.sheetNameListinBatch);                  
                 database.executebatch(b);
             }
         }
   }
}