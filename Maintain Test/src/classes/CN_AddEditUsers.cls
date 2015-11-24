Public with Sharing Class CN_AddEditUsers{

    Public List<User> lstUser{get;set;}
    Public String OrgID;
    Public String ConceptNoteID;
    Public Integer DeleteIndexUser{get;set;}
    List<Account> lstOrg;
    Public List<SelectOption> lstSelProfile{get;set;}
    Public String strLanguage {get;set;}
    Public String strGuidanceId {get;set;}
        
    Public CN_AddEditUsers(ApexPages.StandardController controller) {
        strLanguage = 'ENGLISH';
        if(System.UserInfo.getLanguage() == 'fr'){
            strLanguage = 'FRENCH'; }
        if(System.UserInfo.getLanguage() == 'ru'){
            strLanguage = 'RUSSIAN'; }
        if(System.UserInfo.getLanguage() == 'es'){
            strLanguage = 'SPANISH'; }
        List<Guidance__c> lstGuidance = [Select Id from Guidance__c where Name = 'Manage Users'];
            if(!lstGuidance.isEmpty()) {
              strGuidanceId = lstGuidance[0].Id; }
              
        ConceptNoteID = Apexpages.currentpage().getparameters().get('CNid');
        OrgID  = Apexpages.currentpage().getparameters().get('Id'); 
        lstUser = New List<User>();
        lstOrg = [Select Id,Name From Account Where Id =:OrgID Limit 1];  
        if(lstOrg.size() > 0)
        {
            OrgID  = ((string)lstOrg[0].ID).subString(0,15);
            FillUsers();
            FillProfileList();
        }
    }
    Void FillProfileList()
    {
        List<Profile> lstProfile=[Select Id, Name from Profile 
        where Name='CCM Drafter' OR Name='CCM Reviewer'
        ];
        if(lstProfile !=null && lstProfile.size()>0)
        {
            lstSelProfile= new List<SelectOption>();
            for(Profile objP:lstProfile)
            {
                lstSelProfile.add(new SelectOption(objP.ID,objP.Name));
            }
        }
    }
    
    Void FillUsers()
    {
         if(OrgID != null){
            lstUser = [SELECT Id,FirstName,LastName,Title,Profile.Name,ProfileID,UserRoleID,Email,Alias,Username,CommunityNickname,LanguageLocaleKey,LocaleSidKey,TimeZoneSidKey,DefaultCurrencyIsoCode,isActive FROM User 
            WHERE FirstName = 'Taria' ];
        }
    }
    
    Public void AddUser1() 
    {   
         if(OrgID != null)
         {     
            if(lstUser ==null)
            {
                lstUser = new List<User>();
            }
            User U =new User();
            U =new User();
            U.OrgID__c=OrgID ;
            U.emailencodingkey='UTF-8';
            U.languagelocalekey='en_US';
            U.localesidkey='en_US';
            U.timezonesidkey='Europe/Berlin';
            U.UserRoleID='00Eb0000000V7TI';
            lstUser.add(U);
        }
    }   
    
    Public PageReference saveUser(){
       UpsertUser();
       return New PageReference('/apex/ConceptNoteOverview?id='+ConceptNoteID);
    }
    
    Public PageReference QuickSave(){
       UpsertUser();
       return null;      
    }
    
    Public PageReference cancelUser(){
       return New PageReference('/apex/ConceptNoteOverview?id='+ConceptNoteID);
    }
    
    Public Pagereference  DeleteUser(){
        return null;
    }
    
    Void UpsertUser()
    {
       List<User> lstInsert=new List<User>();
       List<User> lstUpdate=new List<User>();
       For(User objUser:lstUser)
       {
            if(objUser.ID==NULL)
            {
                objUser.username=objUser.Email;
                objUser.alias= (objUser.FirstName+objUser.LastName.subString(0,1)).replace(' ','');
                lstInsert.add(objUser);
            }
            else
            {
               lstUpdate.add(objUser);
            }
       }
       
       insert lstInsert;
       update lstUpdate;
       FillUsers(); 
    }

}