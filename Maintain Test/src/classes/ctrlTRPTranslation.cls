/*********************************************************************************
* Apex Class: {ctrlTRPTranslation }
----------------------------------------------------------------------------------
* Purpose/Methods:
* - Class is created for get the data from Eight Objects and Export into Excel for TRPTranslation
----------------------------------------------------------------------------------
*/
Public Class ctrlTRPTranslation {

    public string xmlheader {get;set;}
    public List<TRPTranslation> lstTRPTranslation {get; set;}
    public string strCNId {get; set;}
    public string strLanguage {get; set;}
    public string strfileName {get; set;}
    Concept_Note__c objCN;
    
    Public ctrlTRPTranslation (){
        xmlheader ='<?xml version="1.0"?><?mso-application progid="Excel.Sheet"?>';        
    }
    
    Public ctrlTRPTranslation (ApexPages.StandardController controller) {
        if(apexPages.currentPage().getParameters().get('id')!=null) {
            xmlheader ='<?xml version="1.0"?><?mso-application progid="Excel.Sheet"?>';
            strCNId= apexPages.currentPage().getParameters().get('id');
            objCN = [select id,Name,Language__c,Program_Split__c,Translation_Status__c from Concept_Note__c where id=:strCNId];
            strfileName = 'application/vnd.ms-excel#';
            DateTime d = Date.Today();
            string tdate = d.format('yyyy.MM.dd');
            strfileName += tdate +'-'+objCN.Name + '-TRP-Translation.xls';
            lstTRPTranslation = new  List<TRPTranslation>();
            if(objCN.Translation_Status__c == 'Translation complete') 
                strLanguage = 'ENGLISH';
            else 
                strLanguage = objCN.Language__c;
            fillProgrammSplit();
            fillFundingResource();
            fillPrincipalRecipients();
            fillGoalsObjectives();
            fillIndicators();
            fillCNInterventions();
            fillGrantInterventions();
            fillProgramaticGaps();
            fillFeedItem();
        }
    }
    
    Public void fillProgrammSplit() {
        TRPTranslation objProgrammSplitModel = new TRPTranslation();
        objProgrammSplitModel.IsProtected= 0;
        objProgrammSplitModel.strSheetname = '1. Program Split';
        objProgrammSplitModel.lstHeaders = New List<String>();//{'Id','Rationale_for_Proposed_Split__c'};
        objProgrammSplitModel.lstHeaders.Add('Id');
        if(strLanguage =='FRENCH')
            objProgrammSplitModel.lstHeaders.Add('Rationale for Proposed Split French');
        else if (strLanguage == 'RUSSIAN')
            objProgrammSplitModel.lstHeaders.Add('Rationale for Proposed Split Russian');
        else if (strLanguage == 'SPANISH')
            objProgrammSplitModel.lstHeaders.Add('Rationale for Proposed Split Spanish');
        objProgrammSplitModel.lstHeaders.Add('Rationale for Proposed Split');
        
        objProgrammSplitModel.lstData = New List<Map<String,String>>();
        for(Program_Split__c objProgramsplit: [select ID,Rationale_for_Proposed_Split_Russian__c, Rationale_for_Proposed_Split_French__c, Rationale_for_Proposed_Split_Spanish__c, Rationale_for_Proposed_Split__c from Program_Split__c where ID =: ObjCN.Program_Split__c]){                
            Map<String,String> rowdata = New Map<String,String>();            
            rowdata.put('Id',objProgramsplit.ID);
            rowdata.put('Rationale for Proposed Split',handleNULL(objProgramsplit.Rationale_for_Proposed_Split__c));
            if(strLanguage =='FRENCH')
                rowdata.put('Rationale for Proposed Split French',handleNULL(objProgramsplit.Rationale_for_Proposed_Split_French__c));
            else if (strLanguage == 'RUSSIAN')
                rowdata.put('Rationale for Proposed Split Russian',handleNULL(objProgramsplit.Rationale_for_Proposed_Split_Russian__c));
            else if (strLanguage == 'SPANISH')
                rowdata.put('Rationale for Proposed Split Spanish',handleNULL(objProgramsplit.Rationale_for_Proposed_Split_Spanish__c));         
            objProgrammSplitModel.lstData.add(rowdata);
        }            
        lstTRPTranslation.add(objProgrammSplitModel );
    }
    
    Public void fillFundingResource() {
        TRPTranslation objFundingResourceModel = new TRPTranslation();
        objFundingResourceModel.IsProtected= 0;
        objFundingResourceModel.strSheetname = '2. Funding Sources';
        objFundingResourceModel.lstHeaders = New List<String>();//{'Id','CCM_Comments__c'};
        objFundingResourceModel.lstHeaders.Add('Id');
        if(strLanguage =='FRENCH')
            objFundingResourceModel.lstHeaders.Add('CCM Comments French');
        else if (strLanguage == 'RUSSIAN')
            objFundingResourceModel.lstHeaders.Add('CCM Comments Russian');
        else if (strLanguage == 'SPANISH')
            objFundingResourceModel.lstHeaders.Add('CCM Comments Spanish');
        objFundingResourceModel.lstHeaders.Add('CCM Comments');
         
        objFundingResourceModel.lstData = New List<Map<String,String>>();
        for(Funding_Source__c objFundingResource: [select Id, CCM_Comments__c, CCM_Comments_French__c, CCM_Comments_Russian__c, CCM_Comments_Spanish__c from Funding_Source__c  Where CPF_Report__r.Concept_Note__c =: strCNId]){                
            Map<String,String> rowdata = New Map<String,String>();            
            rowdata.put('Id',objFundingResource.Id); 
            rowdata.put('CCM Comments',handleNULL(objFundingResource.CCM_Comments__c));
            if(strLanguage =='FRENCH')
                rowdata.put('CCM Comments French',handleNULL(objFundingResource.CCM_Comments_French__c));
            else if (strLanguage == 'RUSSIAN')
                rowdata.put('CCM Comments Russian',handleNULL(objFundingResource.CCM_Comments_Russian__c));
            else if (strLanguage == 'SPANISH')
                rowdata.put('CCM Comments Spanish',handleNULL(objFundingResource.CCM_Comments_Spanish__c));
              
            objFundingResourceModel.lstData.add(rowdata);
        }            
        lstTRPTranslation.add(objFundingResourceModel);
    }
    
    Public void fillPrincipalRecipients() {
        TRPTranslation objPrinRecipientsModel = new TRPTranslation();
        objPrinRecipientsModel .IsProtected= 0;
        objPrinRecipientsModel .strSheetname = '3. Principal Recipients';
        objPrinRecipientsModel.lstHeaders = New List<String>();//{'Id','Name'};
        objPrinRecipientsModel.lstHeaders.Add('Id');
        if(strLanguage =='FRENCH')
            objPrinRecipientsModel.lstHeaders.Add('PR Name French');
        else if (strLanguage == 'RUSSIAN')
            objPrinRecipientsModel.lstHeaders.Add('PR Name Russian');
        else if (strLanguage == 'SPANISH')
            objPrinRecipientsModel.lstHeaders.Add('PR Name Spanish');
        objPrinRecipientsModel.lstHeaders.Add('Name');
        
        objPrinRecipientsModel.lstData = New List<Map<String,String>>();
        for(Account  objPrinRecipients: [select Id, Name, PR_Name_French__c, PR_Name_Russian__c, PR_Name_Spanish__c from Account Where Id in (select Principal_Recipient__c from Implementation_Period__c Where Concept_Note__c =: strCNId)]) {                
            Map<String,String> rowdata = New Map<String,String>();            
            rowdata.put('Id',objPrinRecipients.Id); 
            rowdata.put('Name',handleNULL(objPrinRecipients.Name));
            if(strLanguage =='FRENCH')
                rowdata.put('PR Name French',handleNULL(objPrinRecipients.PR_Name_French__c));
            else if (strLanguage == 'RUSSIAN')
                rowdata.put('PR Name Russian',handleNULL(objPrinRecipients.PR_Name_Russian__c));
            else if (strLanguage == 'SPANISH')
                rowdata.put('PR Name Spanish',handleNULL(objPrinRecipients.PR_Name_Spanish__c));
              
            objPrinRecipientsModel.lstData.add(rowdata);
        }            
        lstTRPTranslation.add(objPrinRecipientsModel );
    }
    
    Public void fillGoalsObjectives() {
        TRPTranslation objGoalsObjectivesModel = new TRPTranslation();
        objGoalsObjectivesModel.IsProtected= 0;
        objGoalsObjectivesModel.strSheetname = '4. Goals-Objectives';
        objGoalsObjectivesModel.lstHeaders = New List<String>();//{'Id','Goal__c'};
        objGoalsObjectivesModel.lstHeaders.Add('Id');
        if(strLanguage =='FRENCH')
            objGoalsObjectivesModel.lstHeaders.Add('Goal French');
        else if (strLanguage == 'RUSSIAN')
            objGoalsObjectivesModel.lstHeaders.Add('Goal Russian');
        else if (strLanguage == 'SPANISH')
            objGoalsObjectivesModel.lstHeaders.Add('Goal Spanish');
        objGoalsObjectivesModel.lstHeaders.Add('Goal');
        
        objGoalsObjectivesModel.lstData = New List<Map<String,String>>();
        for(Goals_Objectives__c objGoalsObjectives: [select Id, Goal__c, Goal_French__c, Goal_Russian__c, Goal_Spanish__c from Goals_Objectives__c Where Concept_Note__c =: strCNId]) {                
            Map<String,String> rowdata = New Map<String,String>();            
            rowdata.put('Id',objGoalsObjectives.Id); 
            rowdata.put('Goal',handleNULL(objGoalsObjectives.Goal__c));
            if(strLanguage =='FRENCH')
                rowdata.put('Goal French',handleNULL(objGoalsObjectives.Goal_French__c));
            else if (strLanguage == 'RUSSIAN')
                rowdata.put('Goal Russian',handleNULL(objGoalsObjectives.Goal_Russian__c));
            else if (strLanguage == 'SPANISH')
                rowdata.put('Goal Spanish',handleNULL(objGoalsObjectives.Goal_Spanish__c));
                
            objGoalsObjectivesModel.lstData.add(rowdata);
        }            
        lstTRPTranslation.add(objGoalsObjectivesModel);
    }
    
    Public void fillIndicators() {
        TRPTranslation objIndicatorsModel = new TRPTranslation();
        objIndicatorsModel.IsProtected= 0;
        objIndicatorsModel.strSheetname = '5. Indicators';
        objIndicatorsModel.lstHeaders = New List<String>();//{'Id','Indicator_Full_Name__c','Comments__c'};
        objIndicatorsModel.lstHeaders.Add('Id');
        if(strLanguage =='FRENCH') {
            objIndicatorsModel.lstHeaders.Add('French Name');
        }
        else if (strLanguage == 'RUSSIAN') {
            objIndicatorsModel.lstHeaders.Add('Russian Name');
        }
        else if (strLanguage == 'SPANISH') {
            objIndicatorsModel.lstHeaders.Add('Spanish Name');
        }
        objIndicatorsModel.lstHeaders.Add('Indicator Full Name');
        if(strLanguage =='FRENCH') {
            objIndicatorsModel.lstHeaders.Add('Comments French');
        }
        else if (strLanguage == 'RUSSIAN') {
            objIndicatorsModel.lstHeaders.Add('Comments Russian');
        }
        else if (strLanguage == 'SPANISH') {
            objIndicatorsModel.lstHeaders.Add('Comments Spanish');
        }
        objIndicatorsModel.lstHeaders.Add('Comments');   
        objIndicatorsModel.lstData = New List<Map<String,String>>();
        for(Grant_Indicator__c objIndicators: [select Id, Indicator_Full_Name__c, French_Name__c, Russian_Name__c, Spanish_Name__c, Comments__c, Comments_French__c, Comments_Russian__c, Comments_Spanish__c from Grant_Indicator__c Where (Concept_Note__c =: strCNId OR Parent_Module__r.Implementation_Period__r.Concept_Note__C = :strCNId)]) {                
            Map<String,String> rowdata = New Map<String,String>();            
            rowdata.put('Id',objIndicators.Id); 
            rowdata.put('Indicator Full Name',handleNULL(objIndicators.Indicator_Full_Name__c)); 
            rowdata.put('Comments',handleNULL(objIndicators.Comments__c));
            if(strLanguage =='FRENCH') {
                rowdata.put('French Name',handleNULL(objIndicators.French_Name__c));
                rowdata.put('Comments French',handleNULL(objIndicators.Comments_French__c));
            }
            else if (strLanguage == 'RUSSIAN') {
                rowdata.put('Russian Name',handleNULL(objIndicators.Russian_Name__c));
                rowdata.put('Comments Russian',handleNULL(objIndicators.Comments_Russian__c));
            }
            else if (strLanguage == 'SPANISH') {
                rowdata.put('Spanish Name',handleNULL(objIndicators.Spanish_Name__c));
                rowdata.put('Comments Spanish',handleNULL(objIndicators.Comments_Spanish__c));
            }
                
            objIndicatorsModel.lstData.add(rowdata);
        }            
        lstTRPTranslation.add(objIndicatorsModel);
    }
    
    Public void fillCNInterventions() {
        TRPTranslation objCNInterventionsModel = new TRPTranslation();
        objCNInterventionsModel.IsProtected= 0;
        objCNInterventionsModel.strSheetname = '6. Concept Note Interventions';
        objCNInterventionsModel.lstHeaders = New List<String>();//{'Id','Custom_Intervention_Name__c','Description_of_Intervention__c'};
        objCNInterventionsModel .lstHeaders.Add('Id');
        if(strLanguage =='FRENCH') {
            objCNInterventionsModel.lstHeaders.Add('Custom Intervention Name French');
        }
        else if (strLanguage == 'RUSSIAN') {
            objCNInterventionsModel.lstHeaders.Add('Custom Intervention Name Russian');
        }
        else if (strLanguage == 'SPANISH') {
            objCNInterventionsModel.lstHeaders.Add('Custom Intervention Name Spanish');
        }
        objCNInterventionsModel.lstHeaders.Add('Custom Intervention Name');
        if(strLanguage =='FRENCH') {
            objCNInterventionsModel.lstHeaders.Add('Description of Intervention(French)');
        }
        else if (strLanguage == 'RUSSIAN') {
            objCNInterventionsModel.lstHeaders.Add('Description of Intervention(Russian)');
        }
        else if (strLanguage == 'SPANISH') {
            objCNInterventionsModel.lstHeaders.Add('Description of Intervention(Spanish)');
        }
        objCNInterventionsModel.lstHeaders.Add('Description of Intervention');  
        objCNInterventionsModel.lstData = New List<Map<String,String>>();
        for(Intervention__c objCNIntervention: [select Id,Custom_Intervention_Name_French__c, Custom_Intervention_Name_Russian__c, Custom_Intervention_Name_Spanish__c, Custom_Intervention_Name__c,Description_of_Intervention_French__c,Description_of_Intervention_Russian__c, Description_of_Intervention_Spanish__c,Description_of_Intervention__c from Intervention__c Where Concept_Note__c =: strCNId]) {                
            Map<String,String> rowdata = New Map<String,String>();            
            rowdata.put('Id',objCNIntervention.Id); 
            rowdata.put('Custom Intervention Name',handleNULL(objCNIntervention.Custom_Intervention_Name__c)); 
            rowdata.put('Description of Intervention',handleNULL(objCNIntervention.Description_of_Intervention__c));
            if(strLanguage =='FRENCH') {
                rowdata.put('Custom Intervention Name French',handleNULL(objCNIntervention.Custom_Intervention_Name_French__c));
                rowdata.put('Description of Intervention(French)',handleNULL(objCNIntervention.Description_of_Intervention_French__c));
            }
            else if (strLanguage == 'RUSSIAN') {
                rowdata.put('Custom Intervention Name Russian',handleNULL(objCNIntervention.Custom_Intervention_Name_Russian__c));
                rowdata.put('Description of Intervention(Russian)',handleNULL(objCNIntervention.Description_of_Intervention_Russian__c));
            }
            else if (strLanguage == 'SPANISH') {
                rowdata.put('Custom Intervention Name Spanish',handleNULL(objCNIntervention.Custom_Intervention_Name_Spanish__c));
                rowdata.put('Description of Intervention(Spanish)',handleNULL(objCNIntervention.Description_of_Intervention_Spanish__c));
            }
                
            objCNInterventionsModel.lstData.add(rowdata);
        }            
        lstTRPTranslation.add(objCNInterventionsModel);
    }
    
    Public void fillGrantInterventions() {
        TRPTranslation objGrantInterventionsModel = new TRPTranslation();
        objGrantInterventionsModel.IsProtected= 0;
        objGrantInterventionsModel.strSheetname = '7. Grant Interventions';
        objGrantInterventionsModel.lstHeaders = New List<String>();//{'Id','CN_Cost_Assumptions__c','CN_Other_Funding__c'};
        objGrantInterventionsModel.lstHeaders.Add('Id');
        if(strLanguage =='FRENCH') {
            objGrantInterventionsModel.lstHeaders.Add('CN Cost Assumptions French');
        }
        else if (strLanguage == 'RUSSIAN') {
            objGrantInterventionsModel.lstHeaders.Add('CN Cost Assumptions Russian');
        }
        else if (strLanguage == 'SPANISH') {
            objGrantInterventionsModel.lstHeaders.Add('CN Cost Assumptions Spanish');
        }
        objGrantInterventionsModel.lstHeaders.Add('CN Cost Assumptions');
        if(strLanguage =='FRENCH') {
           objGrantInterventionsModel.lstHeaders.Add('CN Other Funding French');
        }
        else if (strLanguage == 'RUSSIAN') {
            objGrantInterventionsModel.lstHeaders.Add('CN Other Funding Russian');
        }
        else if (strLanguage == 'SPANISH') {
            objGrantInterventionsModel.lstHeaders.Add('CN Other Funding Spanish');
        }
        objGrantInterventionsModel.lstHeaders.Add('CN Other Funding');
            
        objGrantInterventionsModel.lstData = New List<Map<String,String>>();
        for(Grant_Intervention__c objCNIntervention: [select Id, CN_Cost_Assumptions_French__c, CN_Cost_Assumptions_Russian__c, CN_Cost_Assumptions_Spanish__c, CN_Cost_Assumptions__c, CN_Other_Funding_French__c, CN_Other_Funding_Russian__c, CN_Other_Funding_Spanish__c, CN_Other_Funding__c from Grant_Intervention__c Where Implementation_Period__r.Concept_Note__c =: strCNId]) {                
            Map<String,String> rowdata = New Map<String,String>();            
            rowdata.put('Id',objCNIntervention.Id); 
            rowdata.put('CN Cost Assumptions',handleNULL(objCNIntervention.CN_Cost_Assumptions__c)); 
            rowdata.put('CN Other Funding',handleNULL(objCNIntervention.CN_Other_Funding__c));
            if(strLanguage =='FRENCH') {
                rowdata.put('CN Cost Assumptions French',handleNULL(objCNIntervention.CN_Cost_Assumptions_French__c));
                rowdata.put('CN Other Funding French',handleNULL(objCNIntervention.CN_Other_Funding_French__c));
            }
            else if (strLanguage == 'RUSSIAN') {
                rowdata.put('CN Cost Assumptions Russian',handleNULL(objCNIntervention.CN_Cost_Assumptions_Russian__c));
                rowdata.put('CN Other Funding Russian',handleNULL(objCNIntervention.CN_Other_Funding_Russian__c));
            }
            else if (strLanguage == 'SPANISH') {
                rowdata.put('CN Cost Assumptions Spanish',handleNULL(objCNIntervention.CN_Cost_Assumptions_Spanish__c));
                rowdata.put('CN Other Funding Spanish',handleNULL(objCNIntervention.CN_Other_Funding_Spanish__c));
            }
                
            objGrantInterventionsModel.lstData.add(rowdata);
        }            
        lstTRPTranslation.add(objGrantInterventionsModel);
    }
    
    Public void fillProgramaticGaps() {
        TRPTranslation objPGModel = new TRPTranslation();
        objPGModel.IsProtected= 0;
        objPGModel.strSheetname = '8. Programmatic Gaps';
        objPGModel.lstHeaders = New List<String>();//{'Id','CCM_Comments__c'};
        objPGModel.lstHeaders.Add('Id');
        if(strLanguage =='FRENCH')
            objPGModel.lstHeaders.Add('CCM Comments French');
        else if (strLanguage == 'RUSSIAN')
            objPGModel.lstHeaders.Add('CCM Comments Russian');
        else if (strLanguage == 'SPANISH')
            objPGModel.lstHeaders.Add('CCM Comments Spanish');
        objPGModel.lstHeaders.Add('CCM Comments');
        objPGModel.lstData = New List<Map<String,String>>();
        for(Programmatic_Gap__c objPG: [select Id, CCM_Comments_French__c, CCM_Comments_Russian__c, CCM_Comments_Spanish__c, CCM_Comments__c from Programmatic_Gap__c Where Concept_Note__c =: strCNId]) {                
            Map<String,String> rowdata = New Map<String,String>();            
            rowdata.put('Id',objPG.Id); 
            rowdata.put('CCM Comments',handleNULL(objPG.CCM_Comments__c));
            if(strLanguage =='FRENCH')
                rowdata.put('CCM Comments French',handleNULL(objPG.CCM_Comments_French__c));
            else if (strLanguage == 'RUSSIAN')
                rowdata.put('CCM Comments Russian',handleNULL(objPG.CCM_Comments_Russian__c));
            else if (strLanguage == 'SPANISH')
                rowdata.put('CCM Comments Spanish',handleNULL(objPG.CCM_Comments_Spanish__c));
              
            objPGModel.lstData.add(rowdata);
        }            
        lstTRPTranslation.add(objPGModel);
    }
    
    Public void fillFeedItem() {
        TRPTranslation objFeeditem = new TRPTranslation();
        objFeeditem.IsProtected= 0;
        objFeeditem.strSheetname = '9. FeedItem';
        objFeeditem.lstHeaders = New List<String>();//{'Id','CCM_Comments__c'};
        objFeeditem.lstHeaders.Add('Body');
        objFeeditem.lstHeaders.Add('Content File Name'); 
        objFeeditem.lstHeaders.Add('Body English (if translation required)'); 
        objFeeditem.lstHeaders.Add('File Name English (if translation required)'); 
        objFeeditem.lstData = New List<Map<String,String>>();
        for(FeedItem objFI: [select Body,ContentFileName from FeedItem Where ParentId =: strCNId]) {                
            Map<String,String> rowdata = New Map<String,String>();            
            rowdata.put('Body',handleNULL(objFI.Body)); 
            rowdata.put('Content File Name',handleNULL(objFI.ContentFileName));
            rowdata.put('Body English (if translation required)','');
            rowdata.put('File Name English (if translation required)','');
            objFeeditem.lstData.add(rowdata);
        }            
        lstTRPTranslation.add(objFeeditem);
    }
    
    Public Pagereference downloadExcel(){ 
        Pagereference pr = Page.TRPTranslation ;   
        return pr;       
    }
    
    String handleNULL(String value){
        if(value==null){
            return '';
        }else{
            return value;
        }
    }
               
    Public Class TRPTranslation{
        Public Integer IsProtected {get;set;} // 1 for locked and 0 for unlocked
        Public String strSheetname {get;set;} // Worksheet name in excel file
        Public List<String> lstHeaders {get;set;} // header for worksheet excel
        Public List<Map<String,String>> lstData {get;set;} // collection of data with headers specified in "lstHeaders" fields above       
    }  
}