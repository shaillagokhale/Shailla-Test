public class DisagreegationTableController {

    public boolean toggleBit {get;set;}    
    public String recordId                                            {get; set;}
    public String objectName                                          {get; set;}
    public Boolean isEditable                                         {get; set;}
    public Boolean isSaved                                            {get; set;}
    public Grant_Disaggregated__c gdd                                 {get; set;}
    public String componentName                                       {get; set;}
    public List<DisagreegationTableWrapper> disAggreegationWraprList  {get; set;}
    Public String [] lstGranInfoFields {get; set;}
    public Boolean blnHistory{get;set;}
    public List<sObject> lstHistory {get;set;}
    public Set<Id> grantDisID{get;set;}
    Public Map<String, String > mapfield {get;set;}
    Public String strRecordId {get;set;} // Stores Target Record Id passed from attributes
    Public String strObjectName {get;set;} // Stores Taget Object API name passed from attributes
    Public String strRecordTitle {get;set;}
    List<DisagreegationTableWrapper> aggreegationWrapperList;
    Grant_Disaggregated__c CNTarget1;
    public String strSelectedGID {get; set;}
    public Boolean blnCTComments {get;set;}
    public Boolean blnLFAComments {get;set;}
    public Boolean blnPRComments {get;set;}
    public Boolean blneditmode{get;set;}
    //public String showHistoryPopup  {get; set;}
    public Grant_Disaggregated__c grantdis{get;set;}
    
    public List<DisagreegationTableWrapper> getaggreegationWrapperList() {
        if(recordId != null && recordId != '') {
            aggreegationWrapperList = new List<DisagreegationTableWrapper>();
            system.debug('>>>>>>>>>>>>>>>>'+recordId+'IsEditableeeeeeeeee'+toggleBit);
            disAggreegationWraprList = new List<DisagreegationTableWrapper>();
            Set<id> cdSet = new Set<Id>();
            List<Catalog_Disaggregated__c> cdList;
            List<Grant_Disaggregated__c> gdList;
            Map<String, Grant_Disaggregated__c> strGrntDisaggregatedMap = new Map<String, Grant_Disaggregated__c>();
            DisagreegationTableWrapper aggreegationWrapper;
            Grant_Disaggregated__c grntDisaggregated;
            gdd = new Grant_Disaggregated__c();             
            cdList = [SELECT Id, Disaggregation_Category__c, Disaggregation_Value__c, Catalog_Indicator__c
                      FROM Catalog_Disaggregated__c
                      WHERE Catalog_Indicator__c in (SELECT Indicator__c
                                                     FROM Grant_Indicator__c
                                                     WHERE id =: recordId)
                                                     ORDER BY Disaggregation_Category__c];
            if(cdList != null && !cdList.isEmpty()) {
               for(Catalog_Disaggregated__c cdRec : cdList) {
                   cdSet.add(cdRec.Id);
               }
            }
            
            gdList = [SELECT Name,Id,Catalog_Disaggregated__c, Component__c, Disaggregated_Baseline_Sources__c, Disaggregated_Baseline_Year__c,
                      Disaggregated_Baseline_Value__c, Catalog_Disaggregated__r.Disaggregation_Category__c, Catalog_Disaggregated__r.Disaggregation_Value__c
                      FROM Grant_Disaggregated__c
                      WHERE Grant_Indicator__c =:recordId];
            
            for(Grant_Disaggregated__c gdRecord : gdList) {
                strGrntDisaggregatedMap.put(gdRecord.Catalog_Disaggregated__r.Disaggregation_Category__c + gdRecord.Catalog_Disaggregated__r.Disaggregation_Value__c, gdRecord);
                //grantDisID.add(gdRecord.ID);
            }   
            string flag = '';
            Integer count;
            Integer categoryIndex;
            Integer i = 0;
            for(Catalog_Disaggregated__c cdd : cdList) {
                grntDisaggregated = new Grant_Disaggregated__c();
                system.debug('nnnnnnnnnnnnnnnnnnn'+strGrntDisaggregatedMap.get(cdd.Disaggregation_Category__c + cdd.Disaggregation_Value__c));
                if(strGrntDisaggregatedMap.get(cdd.Disaggregation_Category__c + cdd.Disaggregation_Value__c) != null) {
                    grntDisaggregated = strGrntDisaggregatedMap.get(cdd.Disaggregation_Category__c + cdd.Disaggregation_Value__c);          
                    if(grntDisaggregated.Component__c == null && grntDisaggregated.Component__c == '')
                        grntDisaggregated.Component__c = componentName;
                    if(flag == cdd.Disaggregation_Category__c) {
                        cdd.Disaggregation_Category__c = '';
                        count++;
                        if(i == (cdList.size() - 1))
                            disAggreegationWraprList[categoryIndex].cs = count;     
                        System.debug('equalsssssss'+flag+count);
                    }
                    else {
                        flag = cdd.Disaggregation_Category__c;
                        System.debug('not equalsssss'+flag+count);
                        if(i != 0)
                            disAggreegationWraprList[categoryIndex].cs = count;
                            system.debug('category count'+categoryIndex);
                        count = 1;
                        categoryIndex = i;
                        
                        
                    }
                    
                    aggreegationWrapper = new DisagreegationTableWrapper(cdd, grntDisaggregated, 0);
                }
                else {
                    //grntDisaggregated = new Grant_Disaggregated__c();
                    grntDisaggregated.Catalog_Disaggregated__c = cdd.Id;
                    grntDisaggregated.Grant_Indicator__c = recordId;
                    grntDisaggregated.Component__c = componentName;
                    if(flag == cdd.Disaggregation_Category__c) {
                        cdd.Disaggregation_Category__c = '';
                        count++;
                        if(i == (cdList.size() - 1))
                            disAggreegationWraprList[categoryIndex].cs = count;                          
                    }
                    else 
                        flag = cdd.Disaggregation_Category__c;
                        if(i != 0)
                            disAggreegationWraprList[categoryIndex].cs = count;
                            system.debug('category count'+categoryIndex);
                        count = 1;
                        categoryIndex = i;
                        aggreegationWrapper = new DisagreegationTableWrapper(cdd, grntDisaggregated, 0);
                }
                disAggreegationWraprList.add(aggreegationWrapper);
                i++;
            }
            aggreegationWrapperList = disAggreegationWraprList;
        }
        return disAggreegationWraprList;
    }
    
    public void setaggreegationWrapperList(List<DisagreegationTableWrapper> s) {
        aggreegationWrapperList = s;
    }
    
    public DisagreegationTableController() {
        //getHistoryTrack();
        grantdis = new Grant_Disaggregated__c();
        toggleBit = false;
        isEditable = true;
        isSaved = false;
        CNTarget1 = new Grant_Disaggregated__c(); 
        checkProfile();  
    }   
    public void EditDisaggregated() {
        isEditable = false;
        isSaved = true;
        blneditmode = true;        
    }
    public void CancelIndicator(){
        isEditable = true;
        isSaved = false;
        blneditmode = false;
    }
    
    public void SaveAction() {
        List<Grant_Disaggregated__c> upsertGDList = new List<Grant_Disaggregated__c>();
        System.debug(';;;;;;;;;;;;;;;;;;;;;;'+aggreegationWrapperList);
        Grant_Disaggregated__c gdRec;
        for(DisagreegationTableWrapper dtWrapper : aggreegationWrapperList) {
            if(dtWrapper.gd.id == null && dtWrapper.gd.id == '') {
                System.debug('Insert new Grant Disaggregated Record');
                gdRec = new Grant_Disaggregated__c();
                if((dtWrapper.gd.Disaggregated_Baseline_Year__c != null && dtWrapper.gd.Disaggregated_Baseline_Year__c != '') ||
                   (dtWrapper.gd.Disaggregated_Baseline_Sources__c!= null && dtWrapper.gd.Disaggregated_Baseline_Sources__c!= '') ||
                   (dtWrapper.gd.Disaggregated_Baseline_Value__c != null)) {
                    gdRec = dtWrapper.gd;
                }
                upsertGDList.add(gdRec);
            }
            else {
                System.debug('Update Grant Disaggregated Record');
                gdRec = new Grant_Disaggregated__c();
                gdRec = dtWrapper.gd;
                upsertGDList.add(gdRec);
                
            }            
        }
        if(upsertGDList != null && !upsertGDList.isempty()) {
            upsert upsertGDList;
        }
        isEditable = true;
        isSaved = false;
        blneditmode = false;
    }
    
    public class DisagreegationTableWrapper {
        public Catalog_Disaggregated__c cd              {get; set;}
        public Grant_Disaggregated__c gd                {get; set;}
        public Integer cs                               {get; set;}
        public DisagreegationTableWrapper (Catalog_Disaggregated__c cd, Grant_Disaggregated__c gd, Integer cs) {
            this.cd = cd;
            this.gd = gd;
            this.cs = cs;
        }
    } 
    
    Public void ShowHistoryPopup(){
        blnHistory = true;
        system.debug('Bln:'+ blnHistory);            
        }
    
    //History Popup Close         
    Public void HidePopupHistory(){                
        blnHistory = false;
        system.debug('Bln:'+ blnHistory);            
    } 
    public void checkProfile(){
         Id profileId=userinfo.getProfileId();
         String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
     
      List<Profile_Access_Setting__c> checkpage = [Select Salesforce_Item__c from Profile_Access_Setting__c where Page_Name__c ='GM_GoalsAndImpactIndicators' and Profile_Name__c =: profilename];
      system.debug(checkpage);
      for (Profile_Access_Setting__c check : checkpage){
        if(check.Salesforce_Item__c == 'CT Comments')blnCTComments = true;
        if(check.Salesforce_Item__c == 'LFA Comments')blnLFAComments = true;
        if(check.Salesforce_Item__c == 'PR Comments')blnPRComments = true;
      }
    }
    public Grant_Disaggregated__c CNTarget {
    get{
        if(strSelectedGID != '' && strSelectedGID != null) {
        Grant_Disaggregated__c gc = [select id,PR_Comments__c,Global_Fund_Comments__c,LFA_Comments__c                                
                                from Grant_Disaggregated__c 
                                where Id =: strSelectedGID limit 1];
                                CNTarget1 = gc;
                                return gc;
                        }
                                else 
                                return null;
            }                          
   
        }
     
    Public void saveGlobalComments(){
        strSelectedGID = '';
    //fetchCNTargets();
    //system.debug('***CNTarget'+CNTarget.Country_Team_Comments__c);
    system.debug('***CNTarget'+CNTarget1);
    
    update CNTarget1;
    
    }
}