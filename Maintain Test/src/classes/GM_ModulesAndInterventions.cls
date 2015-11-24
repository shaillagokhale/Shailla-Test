public Class GM_ModulesAndInterventions{
    public String strConceptNoteId {get;set;}
    Public List<Page__c> lstPages {get;set;}
    public String strImplementationPeriodId {get;set;}
    public String strPageId {get;set;}
    public String strComponent {get;set;}
    public List<WrapModules> lstModules {get;set;}
    Public List<Module__c> lstmodulesside {get;set;}
    //public List<wrapIntervention> lstinterventions {get;set;}
    public List<CatalogModuleWrapper> lstCatModules {get;set;}
    //public List<CatalogInterventionWrapper> lstinterventions {get; set;}
    public List<ImplementationPeriodWrapper> implementationPeriods {get; set;}
    Public String strAddNewModuleDescription {get;set;}
    Public Map<Id,Implementation_Period__c> mapImplementationPeriod;
    Public String IPComponent;
    Public Boolean blnExpandSection {get;set;}
    
    Public String  strLanguage {get;set;}
    Public String  strIPLanguage {get;set;}
    Public String  strGuidanceId {get;set;}
    //public String strConceptNoteId {get;set;}
    
    Public Boolean blnExternalPro  {get;set;}
    Public Boolean blnEdit {get;set;}
    Public Boolean blnDelete {get;set;}
    Public Boolean blnAddModule {get;set;}
    Public Boolean blnAddIntervention {get;set;}
    
    public GM_ModulesAndInterventions(ApexPages.StandardController controller) {
        strPageId = Apexpages.currentpage().getparameters().get('id');
        blnExpandSection = false;  
        if(String.IsBlank(strPageId) == false){
            List<Page__c> lstPage = [Select Implementation_Period__r.Concept_Note__c,Implementation_Period__c,Implementation_Period__r.Language__c,Implementation_Period__r.Component__c,Implementation_Period__r.Grant__r.Disease_Component__c From Page__c Where Id =: strPageId And Implementation_Period__c != null Limit 1];
            if(lstPage.size() > 0){
                strImplementationPeriodId = lstPage[0].Implementation_Period__c;
                IPComponent = lstPage[0].Implementation_Period__r.Grant__r.Disease_Component__c;
                strComponent = lstPage[0].Implementation_Period__r.Component__c;
                strConceptNoteId =lstPage[0].Implementation_Period__r.Concept_Note__c;
                //TCS 22/7/2014 Added to check IP Language
                strIPLanguage = lstPage[0].Implementation_Period__r.Language__c; //new variable strCNLanguage
                  if(strIPLanguage == null) strIPLanguage = 'ENGLISH';
            
            }
            
            lstPages = new List<Page__c>();
            lstPages = [Select Id,Name,URL_Prefix__c,Order__c,Modular__c,implementation_Period__r.Name From Page__c Where Implementation_Period__c =: strImplementationPeriodId Order by Order__c]; 
            lstModulesside = new List<Module__c>();   
            lstModulesside = [Select Id,Name,Implementation_Period__c From Module__c Where Implementation_Period__c =: strImplementationPeriodID Order by Name]; 
        }
            
      
        //strImplementationPeriodId = Apexpages.currentpage().getparameters().get('id');
        Set<Id> catalogModuleIds = new Set<Id>();
        if(String.IsBlank(strImplementationPeriodId) == false){
            blnConfirmDelete = false;
            blndisplaySave = false;
            blnAddModuleConfirm  = false;
            blnAddInterventionConfirm = false ;
            blnInterventionConfirmDelete = false ;
            
            List<Module__c> lstModule = new List<Module__c>();
            lstModules = new List<WrapModules>();
            //lstinterventions  = new List<wrapIntervention>();
           /* List<Module__c> lstCNModule = [SELECT Name FROM Module__c WHERE Concept_Note__c =: strConceptNoteId Order By CreatedDate];
            List<String> ModuleName =new List<String>();
            for(Module__c moduleLst : lstCNModule)
            {
                String name = moduleLst.Name;
                ModuleName.add(name);
            } */
            lstModule = [Select Id, Name, Component__c, Implementation_Period__c, Catalog_Module__c,Modular_Order__c, (select Id, Name, Module__c,Catalog_Intervention__c,Standard_or_Custom__c,Custom_Intervention_Name__c,Custom_Intervention_Name_French__c,Custom_Intervention_Name_Russian__c,Custom_Intervention_Name_Spanish__c from Grant_Interventions__r)
                            From Module__c Where Implementation_Period__c =: strImplementationPeriodId Order By CN_Module__r.CreatedDate];
            system.debug('#$$#$#$lstmodule'+lstModule);
            Set<Id> CatModuleIds = new Set<Id>();
            Set<Id> CatIntervetion = new Set<Id>();
            Set<Id> interventionIds = new Set<Id>();
            
            for(Module__c objGO : lstModule){
                CatModuleIds.add(objGO.Catalog_Module__c);
                for(Grant_Intervention__c objGI : objGO.Grant_Interventions__r){
                        interventionIds.add(objGI.Id);
                        CatIntervetion.add(objGI.Catalog_Intervention__c);
                }
            }
            
            List<Catalog_Intervention__c> lstCatInt = [Select Catalog_Module__c,Spanish_Name__c, Spanish_Description__c, 
                                                Russian_Name__c, Name,Id, French_Name__c, 
                                                Description__c, Component__c From Catalog_Intervention__c 
                                                Where Id Not IN : CatIntervetion 
                                                And Catalog_Module__c IN : CatModuleIds];
            
            Map<Id,List<Catalog_Intervention__c>> mapCatModuleIdToCatInt = new Map<Id,List<Catalog_Intervention__c>>();
            for(Catalog_Intervention__c objCI : lstCatInt){
                if(mapCatModuleIdToCatInt.ContainsKey(objCI.Catalog_Module__c)){
                    mapCatModuleIdToCatInt.get(objCI.Catalog_Module__c).add(objCI);
                }else{
                    mapCatModuleIdToCatInt.put(objCI.Catalog_Module__c,new List<Catalog_Intervention__c>{objCI});
                }
            }
            
            /*Map<Id,set<String>> mapIntIdimpleIdStr = new Map<Id,set<String>>();
            Map<Id, Grant_Intervention__c> interventionAndChildMap = new Map<Id, Grant_Intervention__c>([Select Id, (Select Id, Name, PR_Short_Name__c,Implementation_Period__c From Grant_Interventions__r) From Intervention__c ]);
            
            for(Intervention__c objInt : interventionAndChildMap.values()){
                for(Grant_Intervention__c objGI : objInt.Grant_Interventions__r){
                    if(mapIntIdimpleIdStr.ContainsKey(objInt.Id)){
                        mapIntIdimpleIdStr.get(objInt.Id).add(objGI.Implementation_Period__c);
                    }else{
                        mapIntIdimpleIdStr.put(objInt.Id,new set<String>{objGI.Implementation_Period__c});
                    }
                }
            }*/
            
            //mapImplementationPeriod = new Map<Id,Implementation_Period__c>([Select Name, Principal_Recipient__c, Principal_Recipient__r.Name, Id, Grant__c, Implementation_Period__c 
              //                                           From Implementation_Period__c where Implementation_Period__c =: strImplementationPeriodId ]);
            
            system.debug('#$$#$#$'+lstModule);
            Integer Count = 1;
            for(Module__c objGO : lstModule){
                WrapModules objWrap = new WrapModules();
                objWrap.ModuleDescription = objGO.Name;
                objWrap.ModuleId = objGO.Id;
                objWrap.Module = objGO;
                objWrap.blnDisplay = true;
                objWrap.IndexModule = Count;
                objWrap.showChildDetails = false ;
                objWrap.showStandardInterventionButton = (objGO.Catalog_Module__c != null) ;
                objWrap.childInterventions = new List<wrapIntervention>();
                objWrap.lstinterventions = new List<CatalogInterventionWrapper>();
                if(mapCatModuleIdToCatInt.get(objGO.Catalog_Module__c) != null){
                    for(Catalog_Intervention__c objCat : mapCatModuleIdToCatInt.get(objGO.Catalog_Module__c)){
                        objWrap.lstinterventions.add(new CatalogInterventionWrapper(objCat));
                    }
                }
                for(Grant_Intervention__c objGI : objGO.Grant_Interventions__r){
                    wrapIntervention objWrapInt = new wrapIntervention();
                    objWrapInt.objIntervention = objGI;
                    objWrapInt.IndexIntervention = Count;
                    objWrapInt.blnIndicatorDisplay = true;                    
                    objWrap.childInterventions.add(objWrapInt);
                }
                lstModules.add(objWrap);
                
                if(objGO.Catalog_Module__c != null) {
                    catalogModuleIds.add(objGO.Catalog_Module__c);
                }
                Count ++;
            }
        }
        system.debug('#$$#$#$'+lstModules);
        /*
        Set<Id> lastModuleIds = new Set<Id>();
        if(lstModules != null && !lstModules.isEmpty()) {
            for(WrapModules objGO : lstModules ){
              lastModuleIds.add(objGO.ModuleId);
            }
        }
        List<Module__c> remaingModule = [select Id, Name,Component__c,Implementation_Period__c, (select Id, Name from Interventions__r)
                    From Module__c Where Id not in :lastModuleIds ] ;
                    
        List<WrapModules> remaingModuleWrapperList = new List<WrapModules>();
        Integer counter = lstModules != null ? (lstModules.size() + 1) : 0 ;
        for(Module__c obj: remaingModule ) {
            WrapModules objWrap = new WrapModules();
            objWrap.ModuleDescription = obj.Name;
            objWrap.ModuleId = obj.Id;
            objWrap.blnDisplay = true;
            objWrap.IndexModule = counter;
            objWrap.isSelected = false ;
            objWrap.showChildDetails = false ;
            objWrap.childInterventions = new List<wrapIntervention>();
            for(Intervention__c objGI : obj.Interventions__r){
                wrapIntervention objWrapInt = new wrapIntervention();
                objWrapInt.objIntervention = objGI;
                objWrapInt.IndexIntervention = counter;
                objWrapInt.blnIndicatorDisplay = true;
                objWrap.childInterventions.add(objWrapInt);
            }
            remaingModuleWrapperList.add(objWrap);
            counter++ ;
        }
        */
        
        lstCatModules = new List<CatalogModuleWrapper>();
        for( Catalog_Module__c cm : [select Id,Name,Component__c, component_multi__c from Catalog_Module__c 
                                        where component_multi__c INCLUDES (:IPComponent)
                                        and Id not in :catalogModuleIds]) 
        {
            lstCatModules.add(new CatalogModuleWrapper(cm));
           
        }
         system.debug('lstCatModules'+lstCatModules);
       
        
        //allRemainingModules = remaingModuleWrapperList ;
        strLanguage = 'ENGLISH';
        if(System.UserInfo.getLanguage() == 'fr'){
            strLanguage = 'FRENCH'; }
        if(System.UserInfo.getLanguage() == 'ru'){
            strLanguage = 'RUSSIAN'; }
        if(System.UserInfo.getLanguage() == 'es'){
            strLanguage = 'SPANISH'; }
            
         List<Guidance__c> lstGuidance = [Select Id from Guidance__c where Name = :label.GM_Modules_Interventions];
            if(!lstGuidance.isEmpty()) 
            {
              strGuidanceId = lstGuidance[0].Id;
            }
    checkProfile(); //TCS 22/08/2014: Added for Profile access
    }
    
    //public List<WrapModules> allRemainingModules { get; set;}

    public Boolean blnAddModuleConfirm {get; set;}
    public Boolean blnAddInterventionConfirm {get; set;}
    public Boolean blnConfirmDelete {get;set;}
    public Boolean blnAddPRConfirm {get; set;}
    public Boolean blnInterventionConfirmDelete {get;set;}
    public Boolean blndisplaySave {get;set;}
    public Integer selectedModuleRowToAddIntervention ;
    //public Integer DeleteIndex {get;set;} 
    public Integer DeleteChildIndex {get;set;}
    public Integer EditIndex {get;set;} 
    public Integer ChildEditIndex {get;set;}
    
    public void AddSelectedModule() {
        List<CatalogModuleWrapper> remaingCatalogModuleWrapperList = new List<CatalogModuleWrapper>();
        List<Module__c> newModulesList = new List<Module__c>();
        
        Set<Id> CatNoduleIds = new Set<Id>();
        for(CatalogModuleWrapper wObj : lstCatModules ) {
            if(wObj.isSelected != null && wObj.isSelected) {
                Module__c mod = new Module__c();
                mod.Catalog_Module__c = wObj.catalogModule.Id ;
                CatNoduleIds.add(wObj.catalogModule.Id);
                //mod.Component__c = wObj.catalogModule.Component__c ;
                mod.Component__c = strComponent;
                mod.Implementation_Period__c = strImplementationPeriodId ;
                mod.Name = wObj.catalogModule.Name ;
                newModulesList.add(mod);
            } else {
                remaingCatalogModuleWrapperList.add(wObj);
            }
        }
        
        if(!newModulesList.isEmpty()) {
            insert newModulesList ;
            
            List<Catalog_Intervention__c> lstCatInt = [Select Catalog_Module__c,Spanish_Name__c, Spanish_Description__c, 
                                                Russian_Name__c, Name,Id, French_Name__c, 
                                                Description__c, Component__c From Catalog_Intervention__c 
                                                Where Catalog_Module__c IN : CatNoduleIds];
            
            Map<Id,List<Catalog_Intervention__c>> mapCatModuleIdToCatInt = new Map<Id,List<Catalog_Intervention__c>>();
            if(lstCatInt.size() > 0){
                for(Catalog_Intervention__c objCI : lstCatInt){
                    if(mapCatModuleIdToCatInt.ContainsKey(objCI.Catalog_Module__c)){
                        mapCatModuleIdToCatInt.get(objCI.Catalog_Module__c).add(objCI);
                    }else{
                        mapCatModuleIdToCatInt.put(objCI.Catalog_Module__c,new List<Catalog_Intervention__c>{objCI});
                    }
                }
            }
            
            for(Module__c module : newModulesList) {
                WrapModules objWrap = new WrapModules();
                objWrap.ModuleDescription = module.Name;
                objWrap.ModuleId = module.Id;
                objWrap.Module = module;
                objWrap.blnDisplay = true;
                objWrap.showStandardInterventionButton = (module.Catalog_Module__c != null) ; 
                objWrap.IndexModule = lstModules.size() + 1;
                objWrap.showChildDetails = false ;
                objWrap.childInterventions = new List<wrapIntervention>();
                objWrap.lstinterventions = new List<CatalogInterventionWrapper>();
                if(mapCatModuleIdToCatInt.get(module.Catalog_Module__c) != null){
                    for(Catalog_Intervention__c objCat : mapCatModuleIdToCatInt.get(module.Catalog_Module__c)){
                        objWrap.lstinterventions.add(new CatalogInterventionWrapper(objCat));
                    }
                }
                lstModules.add(objWrap);
            }
        }
        
        lstCatModules = remaingCatalogModuleWrapperList ;
        blnAddModuleConfirm = false ;
    }
    
    public void AddSelectedIntervention() {
        integer parentRowIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('parentRowIndex'));
        WrapModules moduleWrapper = lstModules[parentRowIndex];
        
        List<Grant_Intervention__c> newInterventionList = new List<Grant_Intervention__c>();
        
        for(CatalogInterventionWrapper wObj : moduleWrapper.lstinterventions ) {
            if(wObj.isSelected != null && wObj.isSelected) {
                Grant_Intervention__c intervention = new Grant_Intervention__c();
                //intervention.French_Name__c = wObj.catalogIntervention.French_Name__c ;
                //intervention.Russian_Name__c = wObj.catalogIntervention.Russian_Name__c ;
                //intervention.Spanish_Name__c = wObj.catalogIntervention.Spanish_Name__c ;
                intervention.Name = wObj.catalogIntervention.Name ;
                intervention.Implementation_Period__c = strImplementationPeriodId ;
                intervention.Module__c = moduleWrapper.ModuleId ;
                intervention.Catalog_Intervention__c = wObj.catalogIntervention.id;
                newInterventionList.add(intervention);
            }
        }
        
        List<CatalogInterventionWrapper> lstinterventionsTemp = new List<CatalogInterventionWrapper>();
        
        for(CatalogInterventionWrapper wObj : moduleWrapper.lstinterventions ) {
            if(wObj.isSelected == false) {
                lstinterventionsTemp.add(wObj);
            }
        }
        moduleWrapper.lstinterventions = new List<CatalogInterventionWrapper>();
        moduleWrapper.lstinterventions.addAll(lstinterventionsTemp);
        // Set selected checkbox to false for all interventions
        for(CatalogInterventionWrapper wObj : moduleWrapper.lstinterventions ) {
                wObj.isSelected = false ;
        }
        
        if(!newInterventionList.isEmpty()) {
            insert newInterventionList ;
            
            for(Grant_Intervention__c intrvntn : newInterventionList) {
                WrapIntervention objWrapInt = new wrapIntervention();
                objWrapInt.objIntervention = intrvntn;
                objWrapInt.IndexIntervention = moduleWrapper.childInterventions.size() + 1;
                objWrapInt.blnIndicatorDisplay = true;                
                moduleWrapper.childInterventions.add(objWrapInt);
                
            }
        }
        blnAddInterventionConfirm = false ;
    }
    
    public void AddCustomIntervention() {
        integer parentRowIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('parentRowIndex'));
        
        if(parentRowIndex != null) {
                WrapModules moduleWrapper = lstModules[parentRowIndex];
                List<WrapIntervention> interventions = lstModules[parentRowIndex].childInterventions ;
                
                Grant_Intervention__c intervention = new Grant_Intervention__c(Implementation_Period__c = strImplementationPeriodId);
                WrapIntervention objWrapInt = new WrapIntervention();
                objWrapInt.objIntervention = intervention ;
                objWrapInt.blnIndicatorDisplay = false ;
                objWrapInt.isAddedFromCustom = true;
                objWrapInt.IndexIntervention = interventions.size() + 1;
                //objWrapInt.WrapPrShortNameList = new List<WrapPrShortName>();
                interventions.add(objWrapInt);
        }
    }
    
    /*public void AddSelectedPR() {
        ChildEditIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('ChildEditIndex'));
        EditIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('EditIndex'));
        
        WrapIntervention selectedIntervention = lstModules[EditIndex].childInterventions[ChildEditIndex];
        List<Grant_Intervention__c> grantInterventionList = new List<Grant_Intervention__c>();
        
        Set<Id> IPIds = new Set<Id>();
        for(ImplementationPeriodWrapper wObj : selectedIntervention.implementationPeriods ) {
            if(wObj.isSelected != null && wObj.isSelected) {
                Grant_Intervention__c grantIntervention = new Grant_Intervention__c();
                grantIntervention.CN_Intervention__c = selectedIntervention.objIntervention.Id ;
                grantIntervention.Implementation_Period__c = wObj.implementationPeriod.Id ;
                IPIds.add(wObj.implementationPeriod.Id);
                grantIntervention.Name = selectedIntervention.objIntervention.Name;
                grantIntervention.Module__c = selectedIntervention.objIntervention.Module__c ;
                grantInterventionList.add(grantIntervention);
            }
        }
        
        List<Module__c> lstModuleToInsert = new List<Module__c>();
        List<Implementation_Period__c> lstIP = [Select Id,(Select Id From Modules__r Where Name =: lstModules[EditIndex].ModuleDescription) From Implementation_Period__c Where Id IN : IPIds];
        for(Implementation_Period__c objIP : lstIP){
            if(objIP.Modules__r.size() > 0){
            }else{
                Module__c objModule = new Module__c(Name = lstModules[EditIndex].ModuleDescription,Implementation_Period__c = objIP.Id,Catalog_module__c = lstModules[EditIndex].module.Catalog_module__c);
                lstModuleToInsert.add(objModule);
            }
        }
        if(lstModuleToInsert.size() > 0) insert lstModuleToInsert;
        
        List<ImplementationPeriodWrapper> ImplementationPeriodTemp = new List<ImplementationPeriodWrapper>();
        
        for(ImplementationPeriodWrapper wObj : selectedIntervention.implementationPeriods) {
            if(wObj.isSelected == false) {
                ImplementationPeriodTemp.add(wObj);
            }
        }
        selectedIntervention.implementationPeriods = new List<ImplementationPeriodWrapper>();
        selectedIntervention.implementationPeriods.addAll(ImplementationPeriodTemp);
        // Set selected checkbox to false for all interventions
        for(ImplementationPeriodWrapper wObj : selectedIntervention.implementationPeriods) {
            wObj.isSelected = false;
        }
        
        if(!grantInterventionList.isEmpty()) {
            insert grantInterventionList ;
        }
        
        
        
        blnAddPRConfirm = false ;
    }
    */
    /*
    public void toogleShowChilDetailOfModule() {
        integer toggleIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('toggleIndex'));
        system.debug('toggleIndex----> ' + toggleIndex);
        if(toggleIndex != null){
                system.debug('toggleIndex----> ' + lstModules[toggleIndex-1].showChildDetails);
            lstModules[toggleIndex-1].showChildDetails = !lstModules[toggleIndex-1].showChildDetails;
            system.debug('toggleIndex----> ' + lstModules[toggleIndex-1].showChildDetails);
        }
    }
    */
    
    /*public void CancelAddModule() {
        
        system.debug('Cancel Add module called------------');
        blnAddModuleConfirm = false ;
        // Set selected checkbox to false for all interventions
        if(lstCatModules != null) {
                for(CatalogModuleWrapper wObj : lstCatModules ) {
                    wObj.isSelected = false ;
                }
        }
    }*/
    
    public void CancelInterventionEdit() {
        Integer ChildCancelIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('ChildCancelIndex'));
        Integer CancelIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('CancelIndex'));
        
        if(CancelIndex != null && ChildCancelIndex != null){
                lstModules[CancelIndex].childInterventions[ChildCancelIndex].blnIndicatorDisplay = true ;
                Grant_Intervention__c intrvntn = lstModules[CancelIndex].childInterventions[ChildCancelIndex].objIntervention ;
                system.debug('-------> ' + lstModules[CancelIndex].childInterventions.size());
                system.debug('-------> ' + lstModules[CancelIndex].childInterventions[ChildCancelIndex]);
                if(intrvntn.id == null) {
                        lstModules[CancelIndex].childInterventions.remove(ChildCancelIndex);
                }
        }
    }
    
    /*public void CancelAddIntervention() {
        blnAddInterventionConfirm = false ;
    }
    
    public void CancelAddPR() {
        blnAddPRConfirm = false ;
    }*/
    
    public void EditModule(){
        integer EditIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('EditIndex'));
        if(EditIndex != null){
            lstModules[EditIndex].blnDisplay = false;
        }
    }
    
    public void EditGrantIntervention() {
        Integer ChildEditIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('ChildEditIndex'));
        Integer EditIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('EditIndex'));
        
        if(EditIndex != null && ChildEditIndex != null){
                lstModules[EditIndex].childInterventions[ChildEditIndex].blnIndicatorDisplay = false ;
                Grant_Intervention__c intrvntn = lstModules[EditIndex].childInterventions[ChildEditIndex].objIntervention ;
                
                if(intrvntn.Id != null)  {
                        upsert intrvntn ;
                }
        }
    }
    
    /*public void ConfirmDeleteModule(){
        DeleteIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('DeleteIndex')); 
        // this boolean is no longer used
        blnConfirmDelete = true;
    }
    public void CancelDeleteModule(){
        blnConfirmDelete = false;
    }*/
    public void DeleteModule(){
        Integer DeleteIndex = Integer.valueOf(Apexpages.currentpage().getparameters().get('deleteModuleIndex'));
        if(DeleteIndex != null){
                List<Grant_Intervention__c> toDeleteIntervention = new List<Grant_Intervention__c>();
                for(WrapIntervention wi: lstModules[DeleteIndex].childInterventions) {
                        toDeleteIntervention.add(wi.objIntervention);
                }
                
                List<Module__c> lstGrantModuleToDelete = [Select Id From Module__c 
                                                where Catalog_module__c =: lstModules[DeleteIndex].module.Catalog_Module__c
                                                And CN_Module__c =: lstModules[DeleteIndex].module.Id];
                
                if(lstGrantModuleToDelete.size() > 0){ 
                    
                    List<Grant_Indicator__c> lstGIndToUpdate = [Select Id From Grant_Indicator__c 
                                                        Where Parent_Module__c IN : lstGrantModuleToDelete
                                                        And Indicator_Type__c = 'Coverage/Output'];
                    if(lstGIndToUpdate.size() > 0) Delete lstGIndToUpdate;
                    Delete lstGrantModuleToDelete;
                }
                
                if(!toDeleteIntervention.isEmpty()) delete toDeleteIntervention;
                Set<Id> catalogModuleIds = new Set<Id>();
                catalogModuleIds.add(lstModules[DeleteIndex].Module.catalog_module__c);
            delete lstModules[DeleteIndex].Module;
            lstModules.remove(DeleteIndex);
            blnConfirmDelete = false;
            
        if(lstCatModules.size() > 0){
                
                for(CatalogModuleWrapper obj: lstCatModules){
                    catalogModuleIds.add(obj.catalogModule.id);
                }
            }
            lstCatModules = new List<CatalogModuleWrapper>();
            for( Catalog_Module__c cm : [select Id,Name,Component__c, component_multi__c,French_Name__c,Spanish_Name__c,Russian_Name__c from Catalog_Module__c where component_multi__c INCLUDES (:strComponent) and 
                                            Id in :catalogModuleIds order by Name]) {
                lstCatModules.add(new CatalogModuleWrapper(cm));
            }
            // Repopulate the Catalog Module List
            /*Set<Id> catalogModuleIds = new Set<Id>();
            for(WrapModules objGO : lstModules){
                if(objGO.Module.Catalog_Module__c != null) {
                    catalogModuleIds.add(objGO.Module.Catalog_Module__c);
                }
            }
            lstCatModules = new List<CatalogModuleWrapper>();
            for(Catalog_Module__c cm : [select Id,Name,Component__c, component_multi__c from Catalog_Module__c where Component__c =: strComponent and 
                              Id not in :catalogModuleIds order by Name]) {
                lstCatModules.add(new CatalogModuleWrapper(cm));
            }*/
        }
    }
    public void SaveModule(){
        integer SaveIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('SaveIndex'));
        
        system.debug('@#@#@#'+SaveIndex);
        system.debug('@#@#@#'+lstModules.size());
        if(SaveIndex > lstModules.size()){
            Module__c objModule = new Module__c(Name = strAddNewModuleDescription,Implementation_Period__c = strImplementationPeriodId, Component__c = strComponent);
            insert objModule;
            WrapModules objWrap = new WrapModules();
            objWrap.ModuleDescription = objModule.Name;
            objWrap.ModuleId = objModule.Id;
            objWrap.Module =  objModule;
            objWrap.blnDisplay = true;
            objWrap.isCustomRow = false;
            objWrap.IndexModule = SaveIndex;
            objWrap.showChildDetails = true;
            objWrap.showStandardInterventionButton = true;
            objWrap.childInterventions = new List<wrapIntervention>();
            lstModules.add(objWrap);
        }else{
            List<Module__c> lstModulesToUpsert = new List<Module__c>();
            Module__c objModule = new Module__c(Implementation_Period__c = strImplementationPeriodId, Component__c = strComponent);
            if(lstModules[SaveIndex].ModuleId != null){
                objModule.id = lstModules[SaveIndex].ModuleId;
            }
            objModule.Name = lstModules[SaveIndex].ModuleDescription;
            lstModulesToUpsert.add(objModule);
            if(lstModulesToUpsert.size() > 0) Upsert lstModulesToUpsert;
            lstModules[SaveIndex].blnDisplay = true;
        }
    }
    
    public void SaveGrantIntervention() {
        Integer ChildSaveIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('ChildSaveIndex'));
        Integer SaveIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('SaveIndex'));
        
        if(SaveIndex != null && ChildSaveIndex != null){
            WrapModules moduleW = lstModules[SaveIndex] ;
            if(ChildSaveIndex > moduleW.childInterventions.size()){
                WrapIntervention objWrapInt = new wrapIntervention();
                Grant_Intervention__c objInterventionTemp = new Grant_Intervention__c(Name = moduleW.strAddNewCustomInterventionDec,Implementation_Period__c = strImplementationPeriodId,Module__c = moduleW.ModuleId);
                insert objInterventionTemp;
                objWrapInt.objIntervention = objInterventionTemp;
                objWrapInt.IndexIntervention = ChildSaveIndex;
                objWrapInt.blnIndicatorDisplay = true;
                moduleW.childInterventions.add(objWrapInt);
                
            }else{
                moduleW.childInterventions[ChildSaveIndex].blnIndicatorDisplay = true ;
                Grant_Intervention__c interventionToInsert = moduleW.childInterventions[ChildSaveIndex].objIntervention;
                interventionToInsert.Module__c = moduleW.ModuleId ;
                upsert interventionToInsert ;
            }                
        }
    }
    
    public void CancelModule(){
        integer CancelIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('CancelIndex'));
        if(CancelIndex != null){
            if(lstModules[CancelIndex].ModuleId != null){
                lstModules[CancelIndex].blnDisplay = true;
            }else{
                lstModules.remove(CancelIndex);
            }
        }
    }
    
    /*
    public void AddNewModule(){
        //WrapModules objWrap = new WrapModules();
        //objWrap.blnDisplay = false;
        //lstModules.add(objWrap);
        blnAddModuleConfirm = true ;
    }
    */
    
    /*public void AddCustomModule() {
        WrapModules objWrap = new WrapModules();
        objWrap.blnDisplay = false;
        objWrap.isCustomRow = true ;
        if(lstModules != null && lstModules.size() > 0){
            objWrap.IndexModule = lstModules.size() + 1 ;
        }else{
            lstModules = new List<WrapModules>();
            objWrap.IndexModule = 1 ;
        }
        objWrap.showChildDetails = false ;
        objWrap.showStandardInterventionButton = false ;
        objWrap.childInterventions = new List<wrapIntervention>();
        lstModules.add(objWrap);
    }*/
    
    /*public void AddNewIntervention() {
        integer parentRowIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('parentRowIndex'));
        selectedModuleRowToAddIntervention = parentRowIndex != null ? parentRowIndex : -1 ;
        
        WrapModules moduleWrapper = lstModules[selectedModuleRowToAddIntervention];
        
        Set<String> alreadyAddedCatalogModule = new Set<String>();
        for(WrapIntervention objWrapInt : moduleWrapper.childInterventions) {
                alreadyAddedCatalogModule.add(objWrapInt.objIntervention.Name);
        }
        
        lstinterventions = new List<CatalogInterventionWrapper>();
        for (Catalog_Intervention__c cI : [Select Spanish_Name__c, Spanish_Description__c, Russian_Name__c, Name, Catalog_Module__c, Id, French_Name__c, 
                                            Description__c, Component__c From Catalog_Intervention__c where Name not in : alreadyAddedCatalogModule and 
                                            Catalog_Module__c =: moduleWrapper.Module.Catalog_Module__c order by Name] ) {
            lstinterventions.add(new CatalogInterventionWrapper(cI));
        }
        blnAddInterventionConfirm = true;
    }*/
    
    /*Public void Addinterventions(){
        if(lstModules.size() > 0){
            for(WrapModules objModule : lstModules){
                lstinterventions = new List<CatalogInterventionWrapper>();
                set<String> setName = mew Set<String>();
                mapModuleIdToCatalogInt.add(objModule.ModuleId,setName);
                if(objModule.childInterventions.size() > 0){
                    for(WrapIntervention objInt : objModule.childInterventions){
                        mapModuleIdToCatalogInt.get(objModule.ModuleId).add(objInt.objIntervention.Name);
                    }
                }
            }
        }
    }
    
    
    
    public void EditModuleIntervention() {
        integer EditIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('EditIndex'));
        integer EditInterventionIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('ChildEditIndex'));
        
        if(EditIndex != null && EditInterventionIndex != null){
            lstModules[EditIndex].childInterventions[EditInterventionIndex].blnIndicatorDisplay = false;
        }
    }
    
    public void ConfirmInterventionDelete() {
        blnInterventionConfirmDelete = true ;
    }
    public void CancelInterventionDelete(){
        blnInterventionConfirmDelete = false;
    }*/
    public void DeleteIntervention(){
        Integer DeleteIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('DeleteIndex'));
        Integer DeleteChildIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('ChildDeleteIndex'));
        if(DeleteIndex != null && DeleteChildIndex != null){
            Grant_Intervention__c todeleteIntervention = lstModules[DeleteIndex].childInterventions[DeleteChildIndex].objIntervention;
            
            List<Catalog_Intervention__c> lstCatInt = [Select Catalog_Module__c,Spanish_Name__c, Spanish_Description__c, 
                                                Russian_Name__c, Name,Id, French_Name__c, 
                                                Description__c, Component__c From Catalog_Intervention__c 
                                                Where Id =: todeleteIntervention.Catalog_Intervention__c Limit 1];
            
            if(todeleteIntervention != null){
                if(lstCatInt.size() > 0){
                    lstModules[DeleteIndex].lstinterventions.add(new CatalogInterventionWrapper(lstCatInt[0]));
                }
                
                /*List<Grant_Intervention__c> lstGIToDelete = [Select Id From Grant_Intervention__c Where CN_Intervention__c =: todeleteIntervention.id];
                if(lstGIToDelete.size() > 0) Delete lstGIToDelete;*/
                
                
                                         
                delete todeleteIntervention ;
            }
            
            lstModules[DeleteIndex].childInterventions.remove(DeleteChildIndex) ;
            blnInterventionConfirmDelete = false;
        }
    }
    
    /*public void RemoveModule(String GModuleName,Set<Id> setPrShortNameList,Id CatModId){
        Set<Id> setIPIds = new Set<Id>();
        List<Implementation_Period__c> lstImpPR  = [Select Id,(Select Module__c From Grant_Interventions__r Where Module__r.Name =: GModuleName) From Implementation_Period__c Where Id IN : setIPIds];
        for(Implementation_Period__c objIp : lstImpPR){
            setIPIds.add(objIp.Id);
        }
        system.debug('#####'+setIPIds);
        if(setIPIds.size() > 0){
            List<Module__c> lstModuleToDelete = [Select Id From Module__c Where Implementation_Period__c IN : setIPIds And Implementation_Period__c = null And Name =: GModuleName And Catalog_Module__c =: CatModId];
            if(lstModuleToDelete.size() > 0) Delete lstModuleToDelete;
        }
    }*/
    
    /*
    public void EditIntervention(){
        for(wrapIntervention objWrap : lstinterventions){
            objWrap.blnIndicatorDisplay = false;
        }
        blndisplaySave = true;
    }
    public void CancelIntervention(){
        for(wrapIntervention objWrap : lstinterventions){
            objWrap.blnIndicatorDisplay = true;
        }
        blndisplaySave = false;
    }
    
    public void SaveIntervention(){
        List<Intervention__c> lstInterventionToUpdate = new List<Intervention__c>();
        for(wrapIntervention objWrap : lstinterventions){
            lstInterventionToUpdate.add(objWrap.objIntervention);
        }
        if(lstInterventionToUpdate.size() > 0) update lstInterventionToUpdate;
        for(wrapIntervention objWrap : lstinterventions){
            objWrap.blnIndicatorDisplay = true;
        }
    }
    */
    
    //TCS 22/08/2014: Added below code for Profile Access
    public void checkProfile(){
         Id profileId=userinfo.getProfileId();
         String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
     
      List<Profile_Access_Setting__c> checkpage = [Select Salesforce_Item__c from Profile_Access_Setting__c where Page_Name__c ='GM_ModulesAndInterventions' and Profile_Name__c =: profilename];
      system.debug(checkpage);
      for (Profile_Access_Setting__c check : checkpage){
        if (check.Salesforce_Item__c == 'External Profile') blnExternalPro = true;
        if(check.Salesforce_Item__c == 'Edit')blnEdit = true;
        if(check.Salesforce_Item__c == 'Delete')blnDelete = true;
        if(check.Salesforce_Item__c == 'Add Modules')blnAddModule = true;
        if(check.Salesforce_Item__c == 'Add Interventions')blnAddIntervention = true;
        }
    }
    
    public class ImplementationPeriodWrapper {
        public Implementation_Period__c implementationPeriod {get; set;}
        
        public Boolean isSelected {get { return isSelected == null ? false : isSelected ;} set; }
        public ImplementationPeriodWrapper(Implementation_Period__c ip) {
                this.implementationPeriod = ip ;
                this.isSelected = false ;
        }
    }
    
    public class CatalogInterventionWrapper {
        public Catalog_Intervention__c catalogIntervention {get; set;}
        public Boolean isSelected {get { return isSelected == null ? false : isSelected ; } set;}
        
        public CatalogInterventionWrapper(Catalog_Intervention__c cM) {
            this.catalogIntervention = cM ;
            this.isSelected = false ;
        }
    }
    
    public class CatalogModuleWrapper {
        public Catalog_Module__c catalogModule {get; set;}
        public Boolean isSelected {get { return isSelected == null ? false : isSelected ; } set;}
        
        public CatalogModuleWrapper(Catalog_Module__c cM) {
            this.catalogModule = cM ;
            this.isSelected = false ;
        }
    }
    
    public class WrapModules{
        public String ModuleDescription{get;set;}
        public Id ModuleId{get;set;}
        public Module__c Module{get;set;}
        public Integer IndexModule {get;set;}
        public Boolean blnDisplay {get;set;}
        public Boolean isCustomRow {get {return isCustomRow != null ? isCustomRow : false ; } set; }
        
        public Boolean showStandardInterventionButton {get; set;}
        public Boolean showChildDetails {get; set;}
        //public Boolean isSelected {get { return isSelected == null ? false : isSelected ; } set;}
        public List<wrapIntervention> childInterventions {get; set;}
        Public String strAddNewCustomInterventionDec {get;set;}       
        public List<CatalogInterventionWrapper> lstinterventions {get; set;} 
        Public Map<Id,Set<Id>> mapModuleIdToCatalogInt {get;set;}
    }
    public Class WrapIntervention{
        public Grant_Intervention__c objIntervention {get;set;}
        public Integer IndexIntervention {get;set;}
        public Boolean blnIndicatorDisplay {get;set;}
        public List<ImplementationPeriodWrapper> implementationPeriods {get; set;}
        public Boolean isAddedFromCustom {get {return isAddedFromCustom != null ? isAddedFromCustom : false; } set;}
        //public List<String> prShortNameList {get; set;}
    }
   
}