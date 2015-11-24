/****************************************************************************
* SmartsheetAPI
----------------------------------------------------------------------------------
*History
*Version       Date       DETAIL FEATURES
  1.0         09/06/2014   Describes SmartsheetAPI Classes                  
*****************************************************************************/
 public with sharing class SmartsheetApi {
   private static final String GRANT_TYPE_AUTH = 'authorization_code';
    private static final String GRANT_TYPE_REFRESH = 'refresh_token';

    private static final Integer SERVICE_UNAVAILABLE_CODE = 503;
    private static final Integer MAX_RETRIES = 5;
    private static final Integer WAIT_INTERVAL_SECS = 5;

    private static final String TOKEN_PATH = '/token';
    private static final String SHEETS_PATH = '/sheets';
    private static final String TEMPLATES_PATH = '/templates';

    private Smartsheet_Config__c config;
    public LIST<Smartsheet_Config__c> confi;
    private String accessToken;
    private String refreshToken;
    private Datetime tokenExpires;
    private HttpClient httpClient;
    private Boolean retryOnRateLimit = true;

    /*
     * constructor with org default config
     */
    public SmartsheetApi() {
       //
          /* if (Smartsheet_Config__c.getInstance() == null) {
               system.debug('**Test**');
              upsert new Smartsheet_Config__c(Name='Smartsheet Config',SetupOwnerId=UserInfo.getOrganizationId()); 
          }*/
         this.config = Smartsheet_Config__c.getOrgDefaults();
         
        
            
         System.debug('***Config Details**'+this.config);
      
        // get authToken from User object
        getAccessToken();
        httpClient = new HttpClient(config.API_Base_URL__c + '/' + config.API_Version__c);
    }

    /*
     * constructor with config name
     */
    public SmartsheetApi(String configName) {
        this.config = Smartsheet_Config__c.getInstance(configName);

        // get authToken from User object
        getAccessToken();
        httpClient = new HttpClient(config.API_Base_URL__c + '/' + config.API_Version__c);
    }

    /*
     * set retry on rate limit
     */
    public void setRetryOnRateLimit(Boolean retry) {
        this.retryOnRateLimit = retry;
    }

    public Boolean getRetryOnRateLimit() {
        return this.retryOnRateLimit;
    }

    /*
     * get the sheet list
     */
    public List<Smartsheet.Sheet> getSheets() {
        User u = [SELECT Id, Access_Token__c, Token_Expires__c FROM User WHERE Id = :UserInfo.getUserId()]; 
        String Token = u.Access_Token__c; 
        List<Smartsheet.Sheet> sheets = (List<Smartsheet.Sheet>)callSmartsheetApi(SHEETS_PATH, 'GET', null, Token, List<Smartsheet.Sheet>.class); 
        return sheets;
    }

    /*
     * get the sheet of sheetId
     */
    public Smartsheet.Sheet getSheet(Long sheetId, String Token) {
        String path = '/sheet/' + sheetId;
        system.debug('**Sheet Id**'+sheetId);
        //String Token = Smartsheet_Token__c.getinstance('Payal').Access_Token__c;

        Smartsheet.Sheet sheet = (Smartsheet.Sheet)callSmartsheetApi(path, 'GET', null, Token, Smartsheet.Sheet.class); 
        system.debug('**callApi Sucessfull**');
        return sheet;
    }

    /*
     * get the sheet of sheetId
     */
    public HttpResponse getSheetAsExcel(Long sheetId, String Token) {
        String path = '/sheet/' + sheetId;
        system.debug('**Sheet Id**'+sheetId);
        //String Token = Smartsheet_Token__c.getinstance('Payal').Access_Token__c;

        HttpResponse response = (HttpResponse)callSmartsheetAttachmentApi(path, 'GET', null, Token, null); 
        system.debug('**callApi Sucessfull**');
        return response;
    }
    
    /*
     * create a sheet with provided sheet object
     */
    public Smartsheet.SheetResult createSheet(Smartsheet.Sheet sheet) {
        /* get JSON string of sheet */
        String sheetStr = getJsonForNewSheet(sheet);
         String Token = Smartsheet_Token__c.getinstance('Payal').Access_Token__c;
        Smartsheet.SheetResult sheetResult = (Smartsheet.SheetResult)callSmartsheetApi(SHEETS_PATH, 'POST', sheetStr, Token, Smartsheet.SheetResult.class);
        return sheetResult;
    }

    /*
     * insert rows to the sheet of sheetId
     */
    public Smartsheet.RowsResult insertRows(Long sheetId, Smartsheet.InsertRows insertRows) {
        String path = '/sheet/' + sheetId + '/rows';
        /* get JSON string of InsertRows object */
        String insertRowsStr = getJsonForInsertRows(insertRows);           
        User u = [SELECT Id, Access_Token__c, Token_Expires__c FROM User WHERE Id = :UserInfo.getUserId()];
        String Token = u.Access_Token__c;
        Smartsheet.RowsResult rowsResult = (Smartsheet.RowsResult)callSmartsheetApi(path, 'POST', insertRowsStr, Token, Smartsheet.RowsResult.class);
        return rowsResult;
    }

    /*
     * The second leg of OAuth flow to get accessToken
     */
    public Smartsheet.AccessToken getAccessToken(String code) {

        String doHash = config.Client_Secret__c + '|' + code;
        Blob digest = Crypto.generateDigest('SHA-256', Blob.valueOf(doHash));
        String hex = EncodingUtil.convertToHex(digest);

        // build request query parameters for getting access token
        Map<String, String> params = new Map<String, String>();
        params.put('client_id', config.Client_Id__c);
        params.put('hash', hex);
        params.put('redirect_uri', config.Redirect_URL__c);
        params.put('grant_type', GRANT_TYPE_AUTH);
        params.put('code', code);
            System.debug('**Params in getAccessToken**'+params);
        // send a request to get access token
        HttpResponse response = httpClient.sendRequest(TOKEN_PATH, 'POST', params, null);
        Smartsheet.AccessToken accessToken = (Smartsheet.AccessToken)JSON.deserialize(response.getBody(), Smartsheet.AccessToken.class);

        // update accessToken in User object
        saveAccessToken(accessToken);
        return accessToken;
    }

    /*
     * refresh the access token
     */
    public Smartsheet.AccessToken refreshAccessToken() {
        String doHash = config.Client_Secret__c + '|' + this.refreshToken;
        Blob digest = Crypto.generateDigest('SHA-256', Blob.valueOf(doHash));
        String hex = EncodingUtil.convertToHex(digest);

        // build request query parameters for refresh access token
        Map<String, String> params = new Map<String, String>();
        params.put('client_id', config.Client_Id__c);
        params.put('hash', hex);
        params.put('redirect_uri', config.Redirect_URL__c);
        params.put('grant_type', GRANT_TYPE_REFRESH);
        params.put('refresh_token', this.refreshToken);

        // send a request to refresh token
        HttpResponse response = httpClient.sendRequest(TOKEN_PATH, 'POST', params, null);
        Smartsheet.AccessToken accessToken = (Smartsheet.AccessToken)JSON.deserialize(response.getBody(), Smartsheet.AccessToken.class);

        // update accessToken in User object
        saveAccessToken(accessToken);
        return accessToken;
    }


    /*
     * The method is called to request authorization code to authorization url, which is a start of OAuth flow.
     */
    public String getRequestAuthCodeUrl(String state) {
    //confi = [SELECT API_Base_URL__c,API_Version__c,Authorize_URL__c,Client_Id__c,
      //                       Client_Secret__c,Redirect_URL__c,Scope__c from Smartsheet_Config__c];
        system.debug('**Config is **'+config);

        String params = 'response_type=code&client_id=' + config.Client_Id__c + '&redirect_uri=' + config.Redirect_URL__c +
            '&scope=' + config.Scope__c + '&state=' + state;
         System.debug('****Params***'+params);
         String url = config.Authorize_URL__c + '?' + params;
        
        system.debug('****URL***'+url);
        return url;
    }

    /*
     * get the JSON string of sheet object.
     * JSON.serialize() method produces null value, so need to use a custom generator.
     */
    private String getJsonForNewSheet(Smartsheet.Sheet s) {
        JSONGenerator gen = JSON.createGenerator(false);
        gen.writeStartObject();
        gen.writeStringField('name', s.name);
        gen.writeFieldName('columns');
            gen.writeStartArray();

            for (Integer i=0; i < s.columns.size(); i++) {
                Smartsheet.Column column = s.columns.get(i);

                if (column.title != null && !column.title.equals('')) {
                    gen.writeStartObject();
                    gen.writeStringField('title', column.title);

                    if (column.primary != null && column.primary) {
                        gen.writeBooleanField('primary', true);
                    }
                    gen.writeStringField('type', column.type);

                    if(column.type.equals('PICKLIST') && column.options != null) {
                        gen.writeFieldName('options');
                        gen.writeStartArray();

                        for(Integer x=0; x < column.options.size(); x++) {
                            gen.writeString(column.options.get(x));
                        }
                        gen.writeEndArray();
                    }

                    gen.writeEndObject();
                }
            }
            gen.writeEndArray();
        gen.writeEndObject();
        String jsonStr = gen.getAsString();
        return jsonStr;
    }

    /*
     * get the JSON string of insertRow object
     * JSON.serialize() method produces null value, so need to use a custom generator.
     */
    private String getJsonForInsertRows(Smartsheet.InsertRows insertRows) {
        JSONGenerator gen = JSON.createGenerator(false);
        gen.writeStartObject();

        if (insertRows.toTop != null && insertRows.toTop) {
            gen.writeBooleanField('toTop', true);
        } else if (insertRows.toBottom != null && insertRows.toBottom) {
            gen.writeBooleanField('toBottom', true);
        } else if (insertRows.parentId != null) {
            gen.writeNumberField('parentId', insertRows.parentId);
        } else if (insertRows.siblingId != null) {
            gen.writeNumberField('siblingId', insertRows.siblingId);
        } else {
            System.debug('No insert position is specified, using toTop by default');
            gen.writeBooleanField('toTop', true);
        }

        gen.writeFieldName('rows');
            gen.writeStartArray();
            for (Integer i=0; i < insertRows.rows.size(); i++) {
                Smartsheet.Row row = insertRows.rows.get(i);
                gen.writeStartObject();
                gen.writeFieldName('cells');
                gen.writeStartArray();

                for (Integer j=0; j < row.cells.size(); j++) {
                    Smartsheet.Cell cell = row.cells.get(j);

                    // changing nulls to blank string for the writeStringField()
                    if(cell.value == null){
                        cell.value = '';
                    }

                    gen.writeStartObject();
                    gen.writeNumberField('columnId', cell.columnId);
                    gen.writeStringField('value', cell.value);
                    gen.writeBooleanField('strict', false);
                  /* if(cell.strict != null) {
                        gen.writeBooleanField('strict', cell.strict);
                    } */
                    gen.writeEndObject();
                }
                gen.writeEndArray();
                gen.writeEndObject();
            }
            gen.writeEndArray();
        gen.writeEndObject();
        String jsonStr = gen.getAsString();
        return jsonStr;
    }

    /* 
     * callout to Smartsheet api with the provided path, method and object data
     */
    private Object callSmartsheetApi(String path, String method, Object obj, String accessToken, Type returnType) { //Changes for the accesstoken        if (this.accessToken == null) {
            /*if (this.accessToken == null) {
            // todo: redirect to OAuth flow to login
            throw new SmartsheetException('Api is called without access token, please login to Smartsheet');
        }        // refresh token if expired
        if (this.tokenExpires != null) {
            Datetime now = System.now();
            if (this.tokenExpires.getTime() < now.getTime()) {  // expired, refresh it
                refreshAccessToken();
            }
        }*/

        String body = null;
        if (obj != null) {
            if  (obj instanceof String) {
                body = (String)obj;
                system.debug('**Body** '+body);
            } else {
                body = JSON.serialize(obj);
                
            }
        }

        // retry on rate limit
        for (Integer i=0; i < MAX_RETRIES; i++) {
            sleepForDefinedInterval(20);
            HttpResponse response = httpClient.sendRequest(path, method, body, accessToken, false);
            system.debug('**respose status**'+response.getStatusCode());
            // handle error and rate limit
            if (response.getStatusCode() == 200) {  // no error     
                system.debug('Response'+ response.getBody());    
                system.debug('Return Type'+ returnType);  
                
                Object returnObject = JSON.deserialize(response.getBody(), returnType);
                system.debug('Deserialize JSON object'+returnObject);
                return returnObject;
            } else {
                Smartsheet.RestError restError = (Smartsheet.RestError)JSON.deserialize(response.getBody(), Smartsheet.RestError.class);
                 system.debug('Rest Error'+restError );
                if (restError.errorCode == 1003) {  // token is expired, refresh token
                    refreshAccessToken();
                } else if (this.retryOnRateLimit && response.getStatusCode() == SERVICE_UNAVAILABLE_CODE) {
                    if (i < MAX_RETRIES) {
                        sleepForDefinedInterval(i+1);
                    }
                } else {
                    throw new SmartsheetException('Error on Smartsheet API call, ' + restError.message);
                }
            }
        }
        system.debug('Call Api returning Null');
        return null;
    }
    
     /* 
     * callout to Smartsheet Attachment api with the provided path, method and object data
     */
    private Object callSmartsheetAttachmentApi(String path, String method, Object obj, String accessToken, Type returnType) { 

                

            HttpResponse response = httpClient.sendRequest(path, method, null, accessToken, True);
            system.debug('**respose status**'+response.getStatusCode());
            // handle error and rate limit
                
                system.debug('Response'+ response.getBodyAsBlob());    
                //system.debug('Return Type'+ returnType);  
                
                //Object returnObject = JSON.deserialize(response.getBody(), returnType);
                //system.debug('Deserialize JSON object'+returnObject);
                return response;
         
    }

    /*
     * retrieve access token from User object
     */
    private void getAccessToken() {
        // get authToken from User object
        User u = [SELECT Access_Token__c, Refresh_Token__c, Token_Expires__c FROM User WHERE Id = :UserInfo.getUserId()];
        system.debug('Refresh Token '+u.Refresh_Token__c);
        this.accessToken = u.Access_Token__c;
        this.refreshToken = u.Refresh_Token__c;
        if (u.Token_Expires__c != null) {
            this.tokenExpires = u.Token_Expires__c;
        }

    }

    /*
     * save an access token to User object
     */
    private void saveAccessToken(Smartsheet.AccessToken accessToken) {
        if (accessToken != null) {
            User u = [SELECT Id, Access_Token__c, Refresh_Token__c, Token_Expires__c FROM User WHERE Id = :UserInfo.getUserId()];
            u.Access_Token__c = accessToken.access_token;
            u.Refresh_Token__c = accessToken.refresh_token;
            Datetime now = System.now();
            Datetime expires = now.addSeconds(accessToken.expires_in);
            u.Token_Expires__c = expires;
            try {
                update u;
            } catch (DmlException e) {
                System.debug('Error on saving access token to User, ' + e.getMessage());
                throw new SmartsheetException('Error on saving access token to User');
            }

            this.accessToken = accessToken.access_token;
            this.refreshToken = accessToken.refresh_token;
            this.tokenExpires = expires;
        }
    }

    /*
     * fake sleep method.
     * There seems no way to sleep in APEX, I just put the fake sleep with looping.
     * I think the retry should be implemented outside the toolkit by using @future
     */
    public static void sleepForDefinedInterval(Integer retryNumber) {
        Integer sleepSecs = retryNumber * WAIT_INTERVAL_SECS;
        System.debug('503 (Service Unavailable) received - sleep ' + sleepSecs + ' secs before retry...');
        try {
            String looping = 'looping';
            for (Integer i=0; i<10; i++) {
                looping = looping + i;
            }
        } catch (Exception e) {
            System.debug('Threas.sleep got Exception ' + e.getMessage());
        }
    }
    
    /*
     * get the template list
     */
    public List<Smartsheet.Template> getTemplates() {
        String Token = Smartsheet_Token__c.getinstance('Payal').Access_Token__c;
        List<Smartsheet.Template> templates = (List<Smartsheet.Template>)callSmartsheetApi(TEMPLATES_PATH, 'GET', null, Token, List<Smartsheet.Template>.class);    
        return templates;
    }
   
   private String getJsonForSheet(Smartsheet.Sheet t) {
        JSONGenerator gen = JSON.createGenerator(false);
        gen.writeStartObject();
        gen.writeStringField('name', t.name);
        gen.writeNumberField('fromId',t.id);
        gen.writeEndObject();
        String jsonStr = gen.getAsString();
        return jsonStr;
    }
    /*
     * create a sheet with provided sheet object
     */
    public Smartsheet.SheetResult createNewSheet(Smartsheet.Sheet template) {
        /* get JSON string of sheet */
        String sheetStr = getJsonForSheet(template);
        String sheetpath = SHEETS_PATH + '?include=data,attachments,discussions';
        String Token = Smartsheet_Token__c.getinstance('Payal').Access_Token__c;
        Smartsheet.SheetResult sheetResult = (Smartsheet.SheetResult)callSmartsheetApi(sheetpath , 'POST', sheetStr, Token, Smartsheet.SheetResult.class);
        return sheetResult;
    }
    /*
     * create a row with provided row object
     */
    public Smartsheet.Row getRow(Long sheetId, Integer i) {
        /*Smartsheet.Sheet sheet = getSheet(sheetId);
        system.debug('**Sheet **'+sheet);
         List<Smartsheet.Row> rows = new List<Smartsheet.Row>();
         system.debug('**Sheet rows**'+sheet.rows.size());
        for(Integer i=1;i<sheet.rows.size();i++)
        {*/
        String path = '/sheet/' + sheetId+ '/row/'+ i;
        User u = [SELECT Id, Access_Token__c FROM User WHERE Id = :UserInfo.getUserId()];
        String Token = u.Access_Token__c;
        Smartsheet.Row row = (Smartsheet.Row)callSmartsheetApi(path, 'GET', null, Token, Smartsheet.Row.class);
        system.debug('**Row Result** '+row);
        /*rows.add(row);
        }*/
        return row;
    }
     /*
     * get the JSON string of insertRow object
     * JSON.serialize() method produces null value, so need to use a custom generator.
     */
    private String getJsonForUpdateRows(Smartsheet.UpdateCells updateCells) {
        JSONGenerator gen = JSON.createGenerator(false);
      //  gen.writeStartObject();
        system.debug('**Inside JSOn for updating cells**');
       
        //  gen.writeFieldName('cells');
            gen.writeStartArray();
            system.debug('***Cell in Updatecell '+updateCells.cells.size());
            for (Integer i=0; i < updateCells.cells.size(); i++) {
                Smartsheet.Cell cell = updateCells.cells.get(i);
                    // changing nulls to blank string for the writeStringField()
                    if(cell.value == null){
                        cell.value = '';
                    }
                     gen.writeStartObject();
                    gen.writeNumberField('columnId', cell.columnId);
                    gen.writeStringField('value', cell.value);
                    gen.writeBooleanField('strict', cell.strict);
                  /* if(cell.strict != null) {
                        gen.writeBooleanField('strict', cell.strict);
                    } */
                    gen.writeEndObject();
                }
                system.debug('**Inside JSOn for updating cells - Start Array**');
                gen.writeEndArray();
             // gen.writeEndObject();
            system.debug ('**JSON Generator** '+gen.getAsString());
        String jsonStr = gen.getAsString();
        system.debug ('**JSON String** '+jsonStr);
        return jsonStr;
        }
    
    /*
     * update cells to the rows of rowId
     */
      public Smartsheet.CellsResult updateCells(Long rowId, Smartsheet.UpdateCells updateCells) {
      sleepForDefinedInterval(20);
        
        String path = '/row/' + rowId + '/cells';
        /* get JSON string of InsertRows object */
        String updateRowsCells = getJsonForUpdateRows(updateCells);
        system.debug ('**JSON Object** '+updateRowsCells);
       // User u = [SELECT Id, Access_Token__c, Token_Expires__c FROM User WHERE Id = :UserInfo.getUserId()];
        //String Token = u.Access_Token__c;
        String Token = Smartsheet_Token__c.getinstance('Payal').Access_Token__c;
        Smartsheet.CellsResult rowsResult = (Smartsheet.CellsResult)callSmartsheetApi(path, 'PUT', updateRowsCells, Token, Smartsheet.CellsResult.class);
        return rowsResult;
    } 
   /*
     * publish sheet of sheetId
     */
  /*  public Smartsheet.sheetPublish getPublishStatus(Long sheetId) {
        String path = '/sheet/' + sheetId + '/publish';
         get JSON string of InsertRows object */
        //String updateRowsCells = getJsonForUpdateRows(updateCells);
       // system.debug ('**JSON Object** '+updateRowsCells);
    /*    Smartsheet.sheetPublish publishResult = (Smartsheet.sheetPublish)callSmartsheetApi(path, 'Get', null, Smartsheet.sheetPublish.class);
        return publishResult;
    } */
    
    /*
     *JSON for Sharing a sheet with MultipleGroup
     */
      private String getJsonForMultiShare(Smartsheet.ShareWithGroups shareGroup) {
        JSONGenerator gen = JSON.createGenerator(false);
                    gen.writeStartObject();
                    gen.writeStringField('accessLevel','VIEWER');
                    gen.writeStringField('type', shareGroup.type);
                    if(shareGroup.type == 'USER')
                    {
                    gen.writeStringField('email', shareGroup.email);
                    }
                    else { gen.writeNumberField('groupId', shareGroup.groupId);
                    }
                    gen.writeEndObject();
                system.debug ('**JSON Generator** '+gen.getAsString());
        String jsonStr = gen.getAsString();
        system.debug ('**JSON String** '+jsonStr);
        return jsonStr;
        }
    /*
     * share sheet with groups
     */
      public Smartsheet.ShareGroupResult sharewithgroups(Long sheetId, Smartsheet.ShareWithGroups  shareGroup) {
      sleepForDefinedInterval(20);
        
        String path = '/sheet/' + sheetId + '/shareswithgroups';
        /* get JSON string of InsertRows object */
        String multiShare = getJsonForMultiShare(shareGroup);
        system.debug ('**JSON Object** '+multiShare);
        String Token = Smartsheet_Token__c.getinstance('Payal').Access_Token__c;

        Smartsheet.ShareGroupResult shareWithGroups = (Smartsheet.ShareGroupResult)callSmartsheetApi(path, 'POST', multiShare, Token, Smartsheet.ShareGroupResult.class);
        return shareWithGroups;
    }
    
    /*
     *JSON for Sharing a sheet with Single User
     */
      private String getJsonForUserShare() {
        JSONGenerator gen = JSON.createGenerator(false);
                    gen.writeStartObject();
                    gen.writeStringField('accessLevel','EDITOR');
                    String Uemail = userinfo.getUserEmail();
                    gen.writeStringField('email', Uemail );
                   
                    gen.writeEndObject();
                system.debug ('**JSON Generator** '+gen.getAsString());
        String jsonStr = gen.getAsString();
        system.debug ('**JSON String1** '+jsonStr);
        return jsonStr;
        }
    /*
     * share sheet with User
     */
      public Smartsheet.ShareUserResult ShareGroup(Long sheetId) {
      sleepForDefinedInterval(20);
        
        String path = '/sheet/' + sheetId + '/shares';
        /* get JSON string of InsertRows object */
        String multiShare = getJsonForUserShare();
        system.debug ('**JSON Object** '+multiShare);
        String Token = Smartsheet_Token__c.getinstance('Payal').Access_Token__c;
        Smartsheet.ShareUserResult ShareUser = (Smartsheet.ShareUserResult)callSmartsheetApi(path, 'POST', multiShare, Token, Smartsheet.ShareUserResult.class);
        return ShareUser;
    }
    /*
     * share sheet with groups
     */
    public List<Smartsheet.ShareGroup> listallgroups() {
       String path = '/groups';
       String Token = Smartsheet_Token__c.getinstance('Payal').Access_Token__c;

         List<Smartsheet.ShareGroup> Groups = (List<Smartsheet.ShareGroup>)callSmartsheetApi(path, 'GET', null, Token, List<Smartsheet.ShareGroup>.class);
                    return Groups;
    }
 }