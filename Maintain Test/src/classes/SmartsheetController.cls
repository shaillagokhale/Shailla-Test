/****************************************************************************
 Smartsheet Controller           
*****************************************************************************/
public with sharing class SmartsheetController {

    private static List<SelectOption> AUTH_TYPE_LIST = new SelectOption[] {
        new SelectOption('OAuth2.0', 'OAuth 2.0'),
        new SelectOption('UserGeneratedToken', 'User Generated Token')
    };

 /*   private static List<SelectOption> API_METHOD_LIST = new SelectOption[] {
        new SelectOption('ListSheets', 'List Sheets'),
        new SelectOption('CreateSheet', 'Create Sheet'),
        new SelectOption('InsertRows', 'Insert Rows'),
        new SelectOption('ListTemplates', 'List Templates')
    };

    private static List<SelectOption> COLUMN_TYPE_LIST = new SelectOption[] {
        new SelectOption('TEXT_NUMBER', 'TEXT NUMBER'),
        new SelectOption('DATE', 'DATE'),
        new SelectOption('DATETIME', 'DATETIME'),
        new SelectOption('CONTACT_LIST', 'CONTACT LIST'),
        new SelectOption('CHECKBOX', 'CHECKBOX'),
        new SelectOption('PICKLIST', 'PICKLIST')
    }; */

    private String oauthState;
    private SmartsheetApi api;
    public ApexPages.StandardController ctrl;
    public Implementation_Period__c grantDetails {get; set;}
   public String grantId {get; set;}
    public SmartsheetController(ApexPages.StandardController Controller ) {
        ctrl = controller;
        api = new SmartsheetApi();
        User u = [SELECT Access_Token__c FROM User WHERE Id = :UserInfo.getUserId()];
        token = u.Access_Token__c;
        System.debug('***Access Token**'+token);
        
        grantId = ctrl.getid();
        grantDetails = [SELECT Country__c,Id,Name,End_Date__c,Start_Date__c FROM Implementation_Period__c where Id=:ctrl.getId()];
        system.debug('Grant Details** '+grantDetails);
        /*
         * new sheet object
         */
        //createNewSheetObject();
        //createNewInsertRowsObject();
    } 

    public String token {
        get {
            if (token == null) {
                return 'No Access Token Found.';
            } else {
                return 'Token Saved';
            }
            return token;
        }
        set; 
    }
    public String authType { get; set; }
    public String generatedToken { get; set; }
    public Smartsheet.Sheet sheet { get; set; } // currently selected sheet
    public Smartsheet.Sheet newSheet { get; set; }  // used for creating new sheet
    public Smartsheet.InsertRows insertRows { get; set; }   // used for inserting rows to the currently selected sheet
    public List<Smartsheet.Sheet> sheets { get; set; } // list of sheets
    public List<Smartsheet.Template> templates { get; set; } // list of templates
    public List<Smartsheet.Template> countryTemplates { get; set; }
    public List<Smartsheet.Sheet> userSheet {get; Set;}
    public Smartsheet.Row updateRow {get; set;}
    public Smartsheet.updateCells updateCells {get; set;}
    public Boolean blncreate {get; set;}
    public Boolean selectTask {get; set;}
    public String url {get; set;}
    
    public Boolean renderAuthorize {get; set;}
    
    public String apiMethod { get; set; }
    public Long sheetId { get; set; }
    public Long templateId{ get; set; }
    public Long Id { get; set; }
    public Smartsheet.Template template { get; set; }
   // public String templateName { get; set; } //to get task of template
    public AggregateResult[] TaskName {get; set; }
    public List<SelectOption> getAuthTypeList() {
        return AUTH_TYPE_LIST;
    }

 

    /* 
     * Smartsheet OAuth redirect_url is set to the VF page. When Smartsheet makes callback,
     * this oauthTarget() method is get called.
     */
    public PageReference oauthTarget() {
        
        /* 
         * retrieve oauth state from User object
         */
        User u = [SELECT Id, OAuth_State__c FROM User WHERE Id = :UserInfo.getUserId()];
        oauthState = u.OAuth_State__c;

        String code = ApexPages.currentPage().getParameters().get('code');
        String state = ApexPages.currentPage().getParameters().get('state');
        String error = ApexPages.currentPage().getParameters().get('error');
         System.debug('**Code**'+code+'**state**'+state+'**error**'+error);
         renderAuthorize = true;
        if (code == null && state == null && error == null) {
            /* 
             * Regular VF visit, not OAuth callback
             */
            system.debug('**Token**'+token);
            listTemplate();
            listSheet();
            renderAuthorize = false;
            return null;
            
        }

        /* 
         * check state
         */
        if (error != null) {
            System.debug('oauthTarget: non-null error returned ' + error);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,
                    'Smartsheet API error returned: ' + error));        } else if (state == null || !state.equals(oauthState)) {
            System.debug('oauthTarget: state is null or does not match, ' + state);
            throw new SmartsheetException('oauthTarget: state is null or does not match, ' + state);
            renderAuthorize = true;
        } else {
            /*
             * requesting authroization code is successful
             *
             * request access token
             */
            Smartsheet.AccessToken accessToken = api.getAccessToken(code);
            token = accessToken.access_token;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,
                    'Logged in to Smartsheet successfully'));
            renderAuthorize = false;
        }
       
        return null;
    }
     private void updateCellsObject(Integer i) {
        List<Smartsheet_Templates__c> templateDetails = [Select Template_Name__c,Task_Code__c from Smartsheet_Templates__c where Operation__c =: 'Inbound'];
        if (sheet != null) {
            updateCells = new Smartsheet.updateCells();
            List<Smartsheet.Cell> cells = new List<Smartsheet.Cell>();
            system.debug('**Sheet rows*** '+sheet.rows.size());
            
            //for (Integer i=1; i<sheet.rows.size(); i++) {
                 updateRow = sheet.rows.get(i);
                 system.debug('update Rows'+updateRow);
                 system.debug('Cell Size '+updateRow.cells.size());
                 Smartsheet.Cell cellValue = new Smartsheet.Cell();
                 if(updateRow.cells.size() > 3){
                    system.debug('Cell Value** '+updateRow.cells.get(2));
                    cellValue = updateRow.cells.get(2); 
                for (Integer j=0; j<sheet.columns.size(); j++) {
                        system.debug('**column loop**'+j);
                        Smartsheet.Column column = sheet.columns.get(j);
                        system.debug('**Column Id** '+column.getId());
                   // if (templateDetails[k].Header_Column__c == j && templateDetails[k].Header_Row__c ==  i )
                   // {
                        Date date1 = grantDetails.Start_Date__c;
                        Date date2 = grantDetails.End_Date__c;
                       // system.debug('Sub Task '+templateDetails.Sub_Task__c);
                         for(Integer k=0;k<templateDetails.size();k++){
                        if(templateDetails[k].Task_Code__c == cellValue.getValue())
                      // if(cellValue.getValue() == 'Implementation Period')
                         {
                            system.debug('**Task Code** '+templateDetails[k].Task_Code__c);
                     if(column.getTitle() == 'Start Date' || column.getTitle() == 'Duration')
                     {
                        Smartsheet.Cell cell = new Smartsheet.Cell();
                        cell.columnId = column.getId();
                        cell.strict = false;
                        system.debug('Difference between Dates'+date1.daysBetween(date2));
                       // if(column.getTitle() == 'Grant Number')cell.value = grantDetails.Name;
                        if(column.getTitle() == 'Start Date')cell.value = date1.year()+'-'+date1.month()+'-'+date1.day();
                        if(column.getTitle() == 'Duration')cell.value = string.valueof(date1.daysBetween(date2));
                         cells.add(cell);
                     }
                    system.debug('**Cells** '+cells);
                }
              
                   }
               }
                //}
                }
            updateCells.cells = cells;
        }
    }
     public void listTemplate() {
            templates = api.getTemplates();
           countryTemplates = new List<Smartsheet.Template>();
          for(Integer i=0;i<templates.size();i++){
                Smartsheet.Template countryTemplate = new Smartsheet.Template();
                system.debug('Template Details** '+templates.get(i));
                system.debug('**Template Name**'+templates.get(i).getName());
                system.debug('**Country Name**'+grantDetails.Country__c);
                if(templates.get(i).getName() == grantDetails.Country__c)
                {
                    countryTemplates.add(templates.get(i));
                    system.debug('**temp** '+countryTemplates);
                }
                
            } 
      }
            
        public PageReference createSheet() {
            //system.debug('**templateId'+templateId);
        //templateId = integer.valueof(Apexpages.currentpage().getparameters().get('templateId'));
            
            blncreate = true;
            //template = api.getTemplate(templateId);
            //newSheet.rows = null;
            newSheet = new Smartsheet.Sheet();
            newSheet.name = grantDetails.Country__c+'-'+grantDetails.Name;
            system.debug('Parameters '+Apexpages.currentPage().getParameters());
            system.debug('**templateId'+templateId);
            //newSheet.Id = Long.valueof(Apexpages.currentPage().getParameters().get('templateId'));
             newSheet.Id = templateId;
            system.debug('**templateId'+newSheet.Id);
           
             system.debug('Template Id '+newSheet.Id);
            Smartsheet.SheetResult sheetResult = api.createNewSheet(newSheet);
            system.debug('Sheet Id'+sheetResult.result.id);
            String Token = Smartsheet_Token__c.getinstance('Payal').Access_Token__c;
            sheet = api.getSheet(sheetResult.result.id, Token);
            system.debug('**sheet.rows.size()**'+sheet.rows.size());
            for (Integer i=0;i<sheet.rows.size();i++)
            {
                system.debug('Inside Row Loop'+i);
                Smartsheet.Row rowDetail = new Smartsheet.Row();
                rowDetail = sheet.rows.get(i);
                 updateCellsObject(i);
                if(updateCells.cells.size()!=0)
                    Smartsheet.CellsResult rowsResult = api.updateCells(rowDetail.getId(), updateCells);
               // List<Smartsheet.ShareWithGroups> sharesheet = api.multisharewithgroups(sheetResult.result.id,);
            }
             List<Smartsheet.ShareGroup> groupDetails = new List<Smartsheet.ShareGroup>(); 
            groupDetails = api.listallgroups();
            if (groupDetails != null || groupDetails.size() != 0){
            Smartsheet.ShareWithGroups sharesheet = new Smartsheet.ShareWithGroups();
           for (Integer j=0;j<groupDetails.size();j++){
                if(groupDetails[j].name == grantDetails.Country__c){
                sharesheet.groupId = groupDetails[j].Id;
                sharesheet.type = 'GROUP';
               api.sharewithgroups(sheetResult.result.id ,sharesheet);
               }
             }
            
            }
            api.ShareGroup(sheetResult.result.id);
            
            //Code to update Grant making object after updating updating IP in the created sheet
            /*sheet = api.getSheet(sheetResult.result.id, Token);
            Integer ColoumnId = 0;
            Integer coloumnIndex = 0;
            Smartsheet.Row rowDetailToGetFD;
                
            for (Integer j=0; j<sheet.columns.size(); j++) {
                                  
                   Smartsheet.Column column = sheet.columns.get(j);                  
                   if(column.getTitle().equals('Task Name'))
                   {
                    coloumnID = Integer.valueof(column.id);
                    coloumnIndex = column.index;
                    system.debug('Coloumn index : ' + coloumnIndex + ' coloumn ID ' + ColoumnId);
                }
            }
                    
            Boolean fdRowFound = false;
            for (Integer i=0;i<sheet.rows.size();i++)
            {
                rowDetailToGetFD = sheet.rows.get(i);
                system.debug('Row details : ' + rowDetailToGetFD);
                for(Smartsheet.cell rowCell : rowDetailToGetFD.cells){
                    system.debug('Row Cel : ' + rowCell);
                    if(Integer.valueof(rowCell.columnId) == coloumnID){
                            if(rowCell.value != null && rowCell.value.equals('First Disbursement')){
                                system.debug('Breaking oout of loop 1');
                                fdRowFound = true;
                                break;
                            }
                    }
                }
                
                system.debug('Inside Row Loop'+i);                
                if(fdRowFound){
                    break;
                }
              
            }
            system.debug('rowDetailToGetFD ::: ' + rowDetailToGetFD);
            String grantStartDate = rowDetailToGetFD.cells[coloumnIndex + 2].value;
            String grantEndDate = rowDetailToGetFD.cells[coloumnIndex + 3].value;
            system.debug('Start date : ' + grantStartDate +  ' End Date : ' + grantEndDate);
            //List<Implementation_Period__c> grantList = [Select First_Disbursement_End_Date__c, First_Disbursement_Start_Date__c from Implementation_Period__c where ]
            system.debug('Grant details before upsert: ' + grantDetails);
            grantDetails.First_Disbursement_End_Date__c = Date.valueof(grantEndDate);
            grantDetails.First_Disbursement_Start_Date__c = Date.valueof(grantStartDate);
            
            upsert(grantDetails);*/
            system.debug('Grant details : ' + grantDetails);
            //blncreate = false;
             //url = sheetResult.result.permalink;
             system.debug('URL : ' + url);
             PageReference redirect = new PageReference(sheetResult.result.permalink);
             redirect.setRedirect(true);
             return redirect; 
    }
    
    public void listSheet(){
        sheets = api.getSheets();
        
          system.debug('**User Sheet**'+userSheet);
          for(Integer i=0;i<sheets.size();i++){
                Smartsheet.Sheet countrySheet = new Smartsheet.Sheet();
                String SheetName = grantDetails.Country__c+'-'+grantDetails.Name;
              if(sheets.get(i).getName() == SheetName)
                {
                    userSheet = new List<Smartsheet.Sheet>();
                    userSheet.add(sheets.get(i));
                }
                
            } 
    }
    public PageReference navigate(){
      /*  Smartsheet.sheetPublish publishResult = api.getPublishStatus(newSheet.Id);
        system.debug('**Result** '+publishResult); 
        PageReference redirect = new PageReference(publishResult.getReadWriteUrl()); */
        Smartsheet.Sheet sheetNavigate = new Smartsheet.Sheet();
        system.debug('***Sheet Id in Navigation** '+sheetId);
        User u = [SELECT Id, Access_Token__c, Token_Expires__c FROM User WHERE Id = :UserInfo.getUserId()]; 
        String Token = u.Access_Token__c;
        sheetNavigate = api.getSheet(sheetId, Token);
        String redirectURI = sheetNavigate.permalink.replace('home','orgsso/theglobalfund.org');
        system.debug('Redirect URL : ' + redirectURI);
        PageReference redirect = new PageReference(redirectURI);
        redirect.setRedirect(true);
        return redirect;
    }
   
}