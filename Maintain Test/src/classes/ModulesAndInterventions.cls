public Class ModulesAndInterventions{
    public String strConceptNoteId {get;set;}
    public String strPageId {get;set;}
    public String strComponent {get;set;}
    public List<WrapModules> lstModules {get;set;}
    //public List<wrapIntervention> lstinterventions {get;set;}
    public List<CatalogModuleWrapper> lstCatModules {get;set;}
    //public List<CatalogInterventionWrapper> lstinterventions {get; set;}
    public List<ImplementationPeriodWrapper> implementationPeriods {get; set;}
    Public List<Page__c> lstPageTodisplay {get;set;}
    Public List<Module__c> lstdispmodules {get;set;}
    Public String strAddNewModuleDescription {get;set;}
    Public Map<Id,Implementation_Period__c> mapImplementationPeriod;
    Public Boolean blnExpandSection {get;set;}
    Public String strLanguage {get;set;}
    Public String strCNLanguage {get;set;}
    Public Boolean blnReadOnly {get;set;}
    
    //TCS 11/09/2014: Defined below variables for Profile Access
    //Used in checkProfile function
    public String strCNStaus;
    public Boolean blnExternalPro {get;set;}
    public Boolean blnAddModule {get;set;}
    public Boolean blnAddIntervention {get;set;}
    public Boolean blnEditModule {get;set;}
    public Boolean blnDeleteModule {get;set;}
    public Boolean blnEditIntervention {get;set;}
    public Boolean blnDeleteIntervention {get;set;}
    public Boolean blnAddPR {get;set;}
    public Boolean blnEditPR {get;set;}
    public Boolean blnDeletePR {get;set;}

    public ModulesAndInterventions(ApexPages.StandardController controller) {
        //blnReadOnly = CheckProfile.checkProfile();
        strPageId = Apexpages.currentpage().getparameters().get('id');
        LoadModules();
        checkProfile(); 
        //allRemainingModules = remaingModuleWrapperList ;
    }
    
    //public List<WrapModules> allRemainingModules { get; set;}
    
    public void LoadModules() {
        if(String.IsBlank(strPageId) == false){
            List<Page__c> lstPage = [Select Concept_note__c,Concept_Note__r.Component__c, Concept_Note__r.Status__c, Concept_Note__r.Language__c From Page__c Where Id =: strPageId And Concept_note__c != null Limit 1];
            if(lstPage.size() > 0){
                strConceptNoteId = lstPage[0].Concept_note__c;
                strComponent = lstPage[0].Concept_Note__r.Component__c;
                                
                strLanguage = 'ENGLISH';
                if(System.UserInfo.getLanguage() == 'fr'){
                strLanguage = 'FRENCH'; }
                if(System.UserInfo.getLanguage() == 'ru'){
                strLanguage = 'RUSSIAN'; }
                if(System.UserInfo.getLanguage() == 'es'){
                strLanguage = 'SPANISH'; }
            
                                
                /**************************Remove Comments from the below line to 
                                           display details in concept note language
                **************************************************************************/
                strCNLanguage = lstPage[0].Concept_note__r.Language__c; //new variable strCNLanguage
                strCNStaus = lstPage[0].Concept_Note__r.Status__c; //varible status used in checkProfile Function 
                  if(strCNLanguage == null) strCNLanguage = 'ENGLISH';
             /*   if(lstPage[0].Concept_Note__r.Status__c == 'Submitted to the Global Fund' && CheckProfile.checkProfileGF()==false){
                    blnReadOnly = true; 
                }else if(lstPage[0].Concept_Note__r.Status__c == 'Not yet submitted'){
                    blnReadOnly = CheckProfile.checkProfile();
                } */
                
            }           
        }
        lstPageTodisplay = new List<Page__c>();
        lstPageTodisplay = [Select Id,Name,URL_Prefix__c,Order__c,Modular__c From Page__c Where Concept_Note__c =: strConceptNoteId  Order by Order__c];
        
        lstdispModules = new List<Module__c>();   
        lstdispModules = [Select Id,Name,Implementation_Period__c,implementation_Period__r.Name From Module__c Where Concept_Note__c =: strConceptNoteID Order by Name]; 
            
        //strConceptNoteId = Apexpages.currentpage().getparameters().get('id');
        Set<Id> catalogModuleIds = new Set<Id>();
        if(String.IsBlank(strConceptNoteId) == false){
            blnConfirmDelete = false;
            blndisplaySave = false;
            blnAddModuleConfirm  = false;
            blnAddInterventionConfirm = false ;
            blnInterventionConfirmDelete = false ;
            
            List<Module__c> lstModule = new List<Module__c>();
            lstModules = new List<WrapModules>();
            //lstinterventions  = new List<wrapIntervention>();
            lstModule = [Select id, Name, Component__c, Concept_Note__c, Catalog_Module__c, Catalog_Module__r.French_Name__c, Catalog_Module__r.Spanish_Name__c,Catalog_Module__r.Russian_Name__c,Modular_Order__c, 
                        (select Id, Name, Module_rel__c,Intervention__c,Intervention__r.Name,Intervention__r.French_Name__c,Intervention__r.Spanish_Name__c,Intervention__r.Russian_Name__c,Custom_Intervention_Name__c,
                        Custom_Intervention_Name_French__c, Custom_Intervention_Name_Russian__c, Custom_Intervention_Name_Spanish__c,Standard_or_Custom__c from Interventions__r)
                            From Module__c Where Concept_Note__c =: strConceptNoteId ORDER BY Modular_Order__c NULLS LAST];
            
            Set<Id> CatNoduleIds = new Set<Id>();
            Set<Id> CatIntervetion = new Set<Id>();
            Set<Id> interventionIds = new Set<Id>();
            
            for(Module__c objGO : lstModule){
                CatNoduleIds.add(objGO.Catalog_Module__c);
                for(Intervention__c objGI : objGO.Interventions__r){
                        interventionIds.add(objGI.Id);
                        CatIntervetion.add(objGI.Intervention__c);
                }
            }
            
            List<Catalog_Intervention__c> lstCatInt = [Select Catalog_Module__c,Spanish_Name__c, Spanish_Description__c, 
                                                Russian_Name__c, Name,Id, French_Name__c, 
                                                Description__c, Component__c From Catalog_Intervention__c 
                                                Where (Id Not IN : CatIntervetion OR Name Like 'Other%')
                                                And Catalog_Module__c IN : CatNoduleIds];
            
            Map<Id,List<Catalog_Intervention__c>> mapCatModuleIdToCatInt = new Map<Id,List<Catalog_Intervention__c>>();
            for(Catalog_Intervention__c objCI : lstCatInt){
                if(mapCatModuleIdToCatInt.ContainsKey(objCI.Catalog_Module__c)){
                    mapCatModuleIdToCatInt.get(objCI.Catalog_Module__c).add(objCI);
                }else{
                    mapCatModuleIdToCatInt.put(objCI.Catalog_Module__c,new List<Catalog_Intervention__c>{objCI});
                }
            }
            
            Map<Id,set<String>> mapIntIdimpleIdStr = new Map<Id,set<String>>();
            Map<Id, Intervention__c> interventionAndChildMap = new Map<Id, Intervention__c>([Select Id,Custom_Intervention_Name__c,Custom_Intervention_Name_French__c,Custom_Intervention_Name_Russian__c,Custom_Intervention_Name_Spanish__c,Standard_or_Custom__c, (Select Id, Name, PR_Short_Name__c,PR__c,Implementation_Period__c From Grant_Interventions__r) From Intervention__c ]);
            
            for(Intervention__c objInt : interventionAndChildMap.values()){
                for(Grant_Intervention__c objGI : objInt.Grant_Interventions__r){
                    if(mapIntIdimpleIdStr.ContainsKey(objInt.Id)){
                        mapIntIdimpleIdStr.get(objInt.Id).add(objGI.Implementation_Period__c);
                    }else{
                        mapIntIdimpleIdStr.put(objInt.Id,new set<String>{objGI.Implementation_Period__c});
                    }
                }
            }
            
            mapImplementationPeriod = new Map<Id,Implementation_Period__c>([Select Name, Principal_Recipient__c, 
                                                        Principal_Recipient__r.Name, Id, Grant__c, Concept_Note__c 
                                                        From Implementation_Period__c 
                                                        where Concept_Note__c =: strConceptNoteId ]);
            
            
            Integer Count = 1;
            for(Module__c objGO : lstModule){
                WrapModules objWrap = new WrapModules();
                if(strLanguage == 'French') objWrap.ModuleDescription = objGO.Catalog_Module__r.French_Name__c;
                else if(strLanguage == 'Spanish') objWrap.ModuleDescription = objGO.Catalog_Module__r.Spanish_Name__c;
                else if(strLanguage == 'Russian') objWrap.ModuleDescription = objGO.Catalog_Module__r.Russian_Name__c;
                else objWrap.ModuleDescription = objGO.Name;
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
                for(Intervention__c objGI : objGO.Interventions__r){
                    wrapIntervention objWrapInt = new wrapIntervention();
                    objWrapInt.objIntervention = objGI;
                    
                    //The below operation is to prevent a null reference, but also allow for interventions where the name is not just "Other" but "Other interventions for XYZ"
                    String strSubString = '';
                    if(objGI.Intervention__r.Name != null) strSubString = objGI.Intervention__r.name.subString(0,5);
                    
                    if(strSubString != 'Other'){
                        if(strLanguage=='French') objWrapInt.IntDescription = objGI.Intervention__r.French_Name__c;
                        else if(strLanguage=='Spanish') objWrapInt.IntDescription = objGI.Intervention__r.Spanish_Name__c;
                        else if(strLanguage=='Russian') objWrapInt.IntDescription = objGI.Intervention__r.Russian_Name__c;
                        else objWrapInt.IntDescription = objGI.Name;
                    }else{
                        if(strCNLanguage=='FRENCH') objWrapInt.IntDescription = objGI.Custom_Intervention_Name_French__c;
                        else if(strCNLanguage=='RUSSIAN') objWrapInt.IntDescription = objGI.Custom_Intervention_Name_Russian__c;
                        else if(strCNLanguage=='SPANISH') objWrapInt.IntDescription = objGI.Custom_Intervention_Name_Spanish__c;
                        else objWrapInt.IntDescription = objGI.Custom_Intervention_Name__c;
                    }
                    objWrapInt.IndexIntervention = Count;
                    objWrapInt.blnIndicatorDisplay = true;
                    objWrapInt.WrapPrShortNameList = new List<WrapPrShortName>();
                    objWrapInt.implementationPeriods = new List<ImplementationPeriodWrapper>();
                    for(Implementation_Period__c objIp : mapImplementationPeriod.values()){
                        if(mapIntIdimpleIdStr.get(objGI.Id) != null){
                            if(mapIntIdimpleIdStr.get(objGI.Id).contains(objIp.Id) == false){
                                objWrapInt.implementationPeriods.add(new ImplementationPeriodWrapper(objIp));
                            }
                        }else{
                            objWrapInt.implementationPeriods.add(new ImplementationPeriodWrapper(objIp));
                        }
                    }
                    
                    if(interventionAndChildMap.containsKey(objGI.Id)) {
                        for (Grant_Intervention__c grntInt : interventionAndChildMap.get(objGI.Id).Grant_Interventions__r) {
                            WrapPrShortName objWrapSN = new WrapPrShortName();
                            if(grntInt.PR_Short_Name__c != null){
                                
                                objWrapSN.PrId = grntInt.Implementation_Period__c;
                                objWrapSN.prShortName = grntInt.PR_Short_Name__c;
                                objWrapSN.blndisplayPRPicklist = false;
                            }else{
                                objWrapSN.PrId = grntInt.Implementation_Period__c;
                                objWrapSN.prShortName = grntInt.PR__c;
                                objWrapSN.blndisplayPRPicklist = false;
                            }
                            objWrapInt.WrapPrShortNameList.add(objWrapSN);
                        }
                    }
                    objWrap.childInterventions.add(objWrapInt);
                }
                lstModules.add(objWrap);
                
                if(objGO.Catalog_Module__c != null) {
                    catalogModuleIds.add(objGO.Catalog_Module__c);
                }
                Count ++;
            }
        }
        
        /*
        Set<Id> lastModuleIds = new Set<Id>();
        if(lstModules != null && !lstModules.isEmpty()) {
            for(WrapModules objGO : lstModules ){
              lastModuleIds.add(objGO.ModuleId);
            }
        }
        List<Module__c> remaingModule = [select Id, Name,Component__c,Concept_Note__c, (select Id, Name from Interventions__r)
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
        for( Catalog_Module__c cm : [select Id,Name,Component__c, component_multi__c,French_Name__c,Spanish_Name__c,Russian_Name__c from Catalog_Module__c where component_multi__c INCLUDES (:strComponent) and 
                                        Id not in :catalogModuleIds order by Modular_Order__c NULLS LAST]) {
            lstCatModules.add(new CatalogModuleWrapper(cm));
        }
    }
    
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
                mod.Concept_Note__c = strConceptNoteId ;
                mod.Name = wObj.catalogModule.Name ;
                mod.French_Name__c = wObj.catalogModule.French_Name__c;
                mod.Spanish_Name__c = wObj.catalogModule.Spanish_Name__c;
                mod.Russian_Name__c = wObj.catalogModule.Russian_Name__c;
                newModulesList.add(mod);
            } else {
                remaingCatalogModuleWrapperList.add(wObj);
            }
       }
       if(!newModulesList.isEmpty())
            insert newModulesList ;
       LoadModules(); 
    }
    
    public void EditImplementationPeriod() {
        
        integer ModuleIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('ModuleIndex'));
        integer interventionIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('interventionIndex'));
        integer PRIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('PRIndex'));
        if(ModuleIndex != null && interventionIndex != null && PRIndex != null){
            lstModules[ModuleIndex].childInterventions[interventionIndex].WrapPrShortNameList[PRIndex].blndisplayPRPicklist = true;
            
            if(lstModules[ModuleIndex].childInterventions[interventionIndex].implementationPeriods.size() > 0){
                lstModules[ModuleIndex].childInterventions[interventionIndex].EditPROptions = new List<SelectOption>();
                lstModules[ModuleIndex].childInterventions[interventionIndex].EditPROptions.add(new SelectOption('','--'+label.Select_PR+'--'));
                for(ImplementationPeriodWrapper objIPWrap : lstModules[ModuleIndex].childInterventions[interventionIndex].implementationPeriods){
                    lstModules[ModuleIndex].childInterventions[interventionIndex].EditPROptions.add(new SelectOption(objIPWrap.implementationPeriod.id,objIPWrap.implementationPeriod.Principal_Recipient__r.Name));
                }
            }
        }
    }
    
    Public void CancelImplementationPeriod() {
        integer ModuleIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('ModuleIndex'));
        integer interventionIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('interventionIndex'));
        integer PRIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('PRIndex'));
        if(ModuleIndex != null && interventionIndex != null && PRIndex != null){
            lstModules[ModuleIndex].childInterventions[interventionIndex].WrapPrShortNameList[PRIndex].blndisplayPRPicklist = false;
        }
    }
    Public void DeleteImplementationPeriod() {
        integer ModuleIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('ModuleIndex'));
        integer interventionIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('interventionIndex'));
        integer PRIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('PRIndex'));
        if(ModuleIndex != null && interventionIndex != null && PRIndex != null){
            
            //if(lstModules[ModuleIndex].childInterventions[interventionIndex].implementationPeriods.size() > 0){
                String IPId = lstModules[ModuleIndex].childInterventions[interventionIndex].WrapPrShortNameList[PRIndex].prId;
                String ModuleId = lstModules[ModuleIndex].module.id;
                String CatModuleId = lstModules[ModuleIndex].module.Catalog_module__c;
                String IntId = lstModules[ModuleIndex].childInterventions[interventionIndex].objIntervention.id;
                List<Implementation_Period__c> lstIPRemoved = [Select Name, Principal_Recipient__c, Principal_Recipient__r.Name, Id, Grant__c, Concept_Note__c 
                                     From Implementation_Period__c 
                                     where Id =: lstModules[ModuleIndex].childInterventions[interventionIndex].WrapPrShortNameList[PRIndex].prId];
                
                if(lstIPRemoved.size() > 0){
                    if(lstModules[ModuleIndex].childInterventions[interventionIndex].implementationPeriods.size() > 0){
                    }else{
                        lstModules[ModuleIndex].childInterventions[interventionIndex].implementationPeriods = new List<ImplementationPeriodWrapper>();
                    }
                    lstModules[ModuleIndex].childInterventions[interventionIndex].implementationPeriods.add(new ImplementationPeriodWrapper(lstIPRemoved[0]));
                }
                lstModules[ModuleIndex].childInterventions[interventionIndex].EditPROptions = new List<SelectOption>();
                lstModules[ModuleIndex].childInterventions[interventionIndex].EditPROptions.add(new SelectOption('','--'+label.Select_PR+'--'));
                if(lstModules[ModuleIndex].childInterventions[interventionIndex].implementationPeriods.size() > 0){
                    for(ImplementationPeriodWrapper objIPWrap : lstModules[ModuleIndex].childInterventions[interventionIndex].implementationPeriods){
                        lstModules[ModuleIndex].childInterventions[interventionIndex].EditPROptions.add(new SelectOption(objIPWrap.implementationPeriod.id,objIPWrap.implementationPeriod.Principal_Recipient__r.Name));
                    }
                }
                Boolean blnDeleteGrantModule = true;
                Integer intPRDeleteIndex = 0;
                for(wrapIntervention objChildIntervention : lstModules[ModuleIndex].childInterventions){
                    intPRDeleteIndex = 0;
                    for(WrapPrShortName objPR : objChildIntervention.WrapPrShortNameList){
                        if(objPR.prid == IPId && IntId != objChildIntervention.objIntervention.id){
                            blnDeleteGrantModule = false;
                            break;
                        }
                        intPRDeleteIndex++;
                    }
                    if(blnDeleteGrantModule == false){
                        break; 
                    }
                }
                List<Module__c> lstGrantModuleToDelete = [Select Id From Module__c 
                                                    Where Implementation_Period__c =: IPId 
                                                    And Catalog_module__c =: CatModuleId And CN_Module__c =: ModuleId];
                if(blnDeleteGrantModule){
                    if(lstGrantModuleToDelete.size() > 0){                                
                        List<Grant_Intervention__c> lstGIToDelete = [Select Id From Grant_Intervention__c 
                                                    Where Implementation_Period__c =: IPId 
                                                    And CN_Intervention__c =: IntId And Module__c IN : lstGrantModuleToDelete];
                                                 
                    
                        List<Grant_Indicator__c> lstGIndToDelete = [Select Id From Grant_Indicator__c 
                                                                Where Grant_Implementation_Period__c =: IPId
                                                                And Parent_Module__c IN : lstGrantModuleToDelete
                                                                And Indicator_Type__c = 'Coverage/Output'];
                        
                        if(lstGIToDelete.size() > 0) Delete lstGIToDelete;
                        if(lstGIndToDelete.size() > 0) Delete lstGIndToDelete;
                        Delete lstGrantModuleToDelete;
                        
                    }
                }else{
                    if(lstGrantModuleToDelete.size() > 0){                                
                        List<Grant_Intervention__c> lstGIToDelete = [Select Id From Grant_Intervention__c 
                                                    Where Implementation_Period__c =: IPId 
                                                    And CN_Intervention__c =: IntId And Module__c IN : lstGrantModuleToDelete];
                        
                        if(lstGIToDelete.size() > 0) Delete lstGIToDelete;
                    }
                }
                
            //}
            //delete new __c(id=lstModules[ModuleIndex].childInterventions[interventionIndex].WrapPrShortNameList[PRIndex].prid);
            lstModules[ModuleIndex].childInterventions[interventionIndex].WrapPrShortNameList.remove(PRIndex);
        }
    }
    
    Public void SaveImplementationPeriod() {
        integer ModuleIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('ModuleIndex'));
        integer interventionIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('interventionIndex'));
        integer PRIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('PRIndex'));
        if(ModuleIndex != null && interventionIndex != null && PRIndex != null){
            String IPId = lstModules[ModuleIndex].childInterventions[interventionIndex].WrapPrShortNameList[PRIndex].prId;
            String ModuleId = lstModules[ModuleIndex].module.id;
            String CatModuleId = lstModules[ModuleIndex].module.Catalog_module__c;
            String IntId = lstModules[ModuleIndex].childInterventions[interventionIndex].objIntervention.id;
            String newPRId = null;
            if(String.isblank(lstModules[ModuleIndex].childInterventions[interventionIndex].WrapPrShortNameList[PRIndex].EditPRName) == false){
                newPRId = lstModules[ModuleIndex].childInterventions[interventionIndex].WrapPrShortNameList[PRIndex].EditPRName;
            }
            if(newPRId != null){
                if(lstModules[ModuleIndex].childInterventions[interventionIndex].implementationPeriods.size() > 0){
                    if(lstModules[ModuleIndex].childInterventions[interventionIndex].WrapPrShortNameList != null && lstModules[ModuleIndex].childInterventions[interventionIndex].WrapPrShortNameList.size() > 0){
                    
                    }else{
                        lstModules[ModuleIndex].childInterventions[interventionIndex].WrapPrShortNameList = new List<WrapPrShortName>();
                    }
                    Integer count = 0;
                    Integer Finalcount = null;
                    
                    List<Grant_Intervention__c> lstGI = [Select Id, Name, PR_Short_Name__c,PR__c,Implementation_Period__c From Grant_Intervention__c Where Implementation_Period__c =: IPId];
                    if(lstGI.size() > 0){
                        lstGI[0].Implementation_Period__c = newPRId;
                        update lstGI;
                        
                        lstGI = [Select Id, Name, PR_Short_Name__c,PR__c,Implementation_Period__c From Grant_Intervention__c Where Implementation_Period__c =: newPRId];
                        
                        if(lstGI.size() > 0){
                            lstModules[ModuleIndex].childInterventions[interventionIndex].WrapPrShortNameList[PRIndex].PrId = newPRId;
                            lstModules[ModuleIndex].childInterventions[interventionIndex].WrapPrShortNameList[PRIndex].prShortName  = lstGI[0].PR_Short_Name__c;
                            lstModules[ModuleIndex].childInterventions[interventionIndex].WrapPrShortNameList[PRIndex].blndisplayPRPicklist = false;
                        }else{
                            Grant_Intervention__c grantIntervention = new Grant_Intervention__c();
                            grantIntervention.CN_Intervention__c = lstModules[ModuleIndex].childInterventions[interventionIndex].objIntervention.Id ;
                            grantIntervention.Implementation_Period__c = newPRId;
                            grantIntervention.Name = lstModules[ModuleIndex].childInterventions[interventionIndex].objIntervention.Name;
                            grantIntervention.Module__c = lstModules[ModuleIndex].childInterventions[interventionIndex].objIntervention.Module_rel__c ;
                            insert grantIntervention;
                            
                            lstGI = [Select Id, Name, PR_Short_Name__c,PR__c,Implementation_Period__c From Grant_Intervention__c Where Id =: grantIntervention.id];
                            
                            lstModules[ModuleIndex].childInterventions[interventionIndex].WrapPrShortNameList[PRIndex].PrId = newPRId;
                            lstModules[ModuleIndex].childInterventions[interventionIndex].WrapPrShortNameList[PRIndex].prShortName  = lstGI[0].PR_Short_Name__c;
                            lstModules[ModuleIndex].childInterventions[interventionIndex].WrapPrShortNameList[PRIndex].blndisplayPRPicklist = false;
                        }    
                    }
                    for(ImplementationPeriodWrapper objIPWrap : lstModules[ModuleIndex].childInterventions[interventionIndex].implementationPeriods){
                        if(newPRId == objIPWrap.implementationPeriod.id){
                            Finalcount = count;
                            break;
                        }
                        count++;
                    }
                    lstModules[ModuleIndex].childInterventions[interventionIndex].implementationPeriods.remove(finalcount);
                    List<Implementation_Period__c> lstIPOld = [Select Name, Principal_Recipient__c,
                                            Principal_Recipient__r.Name, Id, Grant__c, Concept_Note__c 
                                            From Implementation_Period__c 
                                            where Id =: IPId];
                    if(lstIPOld.size() > 0){
                        lstModules[ModuleIndex].childInterventions[interventionIndex].implementationPeriods.add(new ImplementationPeriodWrapper(lstIPOld[0]));
                        lstModules[ModuleIndex].childInterventions[interventionIndex].EditPROptions.add(new SelectOption(lstIPOld[0].id,lstIPOld[0].Principal_Recipient__r.Name));
                    }
                    
                    List<Module__c> lstGrantModuleToUpdate = [Select Id From Module__c 
                                                Where Implementation_Period__c =: IPId 
                                                And Catalog_module__c =: CatModuleId And CN_Module__c =: ModuleId];
                
                    if(lstGrantModuleToUpdate.size() > 0){ 
                        for(Module__c obj : lstGrantModuleToUpdate){
                            obj.Implementation_Period__c = newPRId;
                        }
                                         
                        List<Grant_Intervention__c> lstGIToUpdate = [Select Id From Grant_Intervention__c 
                                                Where Implementation_Period__c =: IPId 
                                                And CN_Intervention__c =: IntId And Module__c IN : lstGrantModuleToUpdate];
                        List<Grant_Indicator__c> lstGIndToUpdate = [Select Id From Grant_Indicator__c 
                                                            Where Grant_Implementation_Period__c =: IPId
                                                            And Parent_Module__c IN : lstGrantModuleToUpdate
                                                            And Indicator_Type__c = 'Coverage/Output'];
                    
                        if(lstGIToUpdate.size() > 0){
                            for(Grant_Intervention__c obj : lstGIToUpdate){
                                obj.Implementation_Period__c = newPRId;
                            }
                            update lstGIToUpdate;
                        }
                        
                        update lstGrantModuleToUpdate;
                        
                        if(lstGIndToUpdate.size() > 0){
                            for(Grant_Indicator__c obj : lstGIndToUpdate){
                                obj.Grant_Implementation_Period__c = newPRId;
                            }
                            update lstGIndToUpdate;
                        }
                       
                    }
                }
            }
        }
    }
    
    public void AddSelectedIntervention() {
        integer parentRowIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('parentRowIndex'));
        WrapModules moduleWrapper = lstModules[parentRowIndex];
        
        List<Intervention__c> newInterventionList = new List<Intervention__c>();
        
        for(CatalogInterventionWrapper wObj : moduleWrapper.lstinterventions ) {
            if(wObj.isSelected != null && wObj.isSelected) {
                Intervention__c intervention = new Intervention__c();
                intervention.French_Name__c = wObj.catalogIntervention.French_Name__c ;
                intervention.Russian_Name__c = wObj.catalogIntervention.Russian_Name__c ;
                intervention.Spanish_Name__c = wObj.catalogIntervention.Spanish_Name__c ;
                system.debug('@#@#@#@#@#'+wObj.catalogIntervention.Name);
                if(wObj.catalogIntervention.Name.toupperCase().startsWith('OTHER')) intervention.Standard_or_Custom__c = 'Custom';
                intervention.Name = wObj.catalogIntervention.Name ;
                intervention.Concept_Note__c = strConceptNoteId ;
                intervention.Module_rel__c = moduleWrapper.ModuleId ;
                intervention.Intervention__c = wObj.catalogIntervention.id;
                newInterventionList.add(intervention);
            }
        }
        
        List<CatalogInterventionWrapper> lstinterventionsTemp = new List<CatalogInterventionWrapper>();
        
        for(CatalogInterventionWrapper wObj : moduleWrapper.lstinterventions ) {
            if(wObj.isSelected == false || wObj.catalogIntervention.Name.toupperCase().startsWith('OTHER')) {
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
            
            for(Intervention__c intrvntn : newInterventionList) {
                WrapIntervention objWrapInt = new wrapIntervention();
                objWrapInt.objIntervention = intrvntn;
                if(intrvntn.Standard_or_Custom__c != 'Custom'){
                    if(strLanguage=='French') objWrapInt.IntDescription = intrvntn.French_Name__c;
                    else if(strLanguage=='Spanish') objWrapInt.IntDescription = intrvntn.Spanish_Name__c;
                    else if(strLanguage=='Russian') objWrapInt.IntDescription = intrvntn.Russian_Name__c;
                    else objWrapInt.IntDescription = intrvntn.Name;
                    objWrapInt.blnIndicatorDisplay = true;
                }else{
                    objWrapInt.IntDescription = '';
                    objWrapInt.blnIndicatorDisplay = false;
                }
                
                objWrapInt.IndexIntervention = moduleWrapper.childInterventions.size() + 1;
                
                objWrapInt.WrapPrShortNameList = new List<WrapPrShortName>();
                moduleWrapper.childInterventions.add(objWrapInt);
                objWrapInt.implementationPeriods = new List<ImplementationPeriodWrapper >();
                for(Implementation_Period__c objIp : mapImplementationPeriod.values()){
                    objWrapInt.implementationPeriods.add(new ImplementationPeriodWrapper(objIp));
                }
            }
        }
        blnAddInterventionConfirm = false ;
    }
    public void SaveCustomIntName(){
        integer ModuleIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('ModuleIndex'));
        integer interventionIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('interventionIndex'));
        if(ModuleIndex != null && interventionIndex != null){
            if(strCNLanguage == 'FRENCH') lstModules[ModuleIndex].childInterventions[interventionIndex].objIntervention.Custom_Intervention_Name_French__c = lstModules[ModuleIndex].childInterventions[interventionIndex].IntDescription;
            else if(strCNLanguage == 'RUSSIAN') lstModules[ModuleIndex].childInterventions[interventionIndex].objIntervention.Custom_Intervention_Name_Russian__c = lstModules[ModuleIndex].childInterventions[interventionIndex].IntDescription;
            else if(strCNLanguage == 'SPANISH') lstModules[ModuleIndex].childInterventions[interventionIndex].objIntervention.Custom_Intervention_Name_Spanish__c = lstModules[ModuleIndex].childInterventions[interventionIndex].IntDescription;
            else lstModules[ModuleIndex].childInterventions[interventionIndex].objIntervention.Custom_Intervention_Name__c = lstModules[ModuleIndex].childInterventions[interventionIndex].IntDescription;
            
            lstModules[ModuleIndex].childInterventions[interventionIndex].blnIndicatorDisplay = true;
            update lstModules[ModuleIndex].childInterventions[interventionIndex].objIntervention;
        }
    }
    /*public void AddCustomIntervention() {
        integer parentRowIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('parentRowIndex'));
        
        if(parentRowIndex != null) {
                WrapModules moduleWrapper = lstModules[parentRowIndex];
                List<WrapIntervention> interventions = lstModules[parentRowIndex].childInterventions ;
                
                Intervention__c intervention = new Intervention__c(Concept_Note__c = strConceptNoteId);
                WrapIntervention objWrapInt = new WrapIntervention();
                objWrapInt.objIntervention = intervention ;
                objWrapInt.blnIndicatorDisplay = false ;
                objWrapInt.isAddedFromCustom = true;
                objWrapInt.IndexIntervention = interventions.size() + 1;
                objWrapInt.WrapPrShortNameList = new List<WrapPrShortName>();
                interventions.add(objWrapInt);
        }
    }*/
    
    public void AddSelectedPR() {
        ChildEditIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('ChildEditIndex'));
        EditIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('EditIndex'));
        
        WrapIntervention selectedIntervention = lstModules[EditIndex].childInterventions[ChildEditIndex];
        List<Grant_Intervention__c> grantInterventionList = new List<Grant_Intervention__c>();
        Set<Id> IPIds = new Set<Id>();
        for(ImplementationPeriodWrapper wObj : selectedIntervention.implementationPeriods){
            if(wObj.isSelected != null && wObj.isSelected) {
                Grant_Intervention__c grantIntervention = new Grant_Intervention__c();
                grantIntervention.CN_Intervention__c = selectedIntervention.objIntervention.Id ;
                grantIntervention.Implementation_Period__c = wObj.implementationPeriod.Id ;
                IPIds.add(wObj.implementationPeriod.Id);
                grantIntervention.Name = selectedIntervention.objIntervention.Name;
                grantIntervention.Standard_or_Custom__c = selectedIntervention.objIntervention.Standard_or_Custom__c;
                grantIntervention.Catalog_Intervention__c = selectedIntervention.objIntervention.Intervention__c;
                //ICS 21/7/2014: Added to copy Custom Intervention Name in Grant Intervention
                if(grantIntervention.Standard_or_Custom__c == 'Custom'){
                grantIntervention.Custom_Intervention_Name__c = selectedIntervention.objIntervention.Custom_Intervention_Name__c;
                grantIntervention.Custom_Intervention_Name_French__c = selectedIntervention.objIntervention.Custom_Intervention_Name_French__c;
                grantIntervention.Custom_Intervention_Name_Spanish__c = selectedIntervention.objIntervention.Custom_Intervention_Name_Spanish__c;
                grantIntervention.Custom_Intervention_Name_Russian__c = selectedIntervention.objIntervention.Custom_Intervention_Name_Russian__c;
                }
                //grantIntervention.Module__c = selectedIntervention.objIntervention.Module_rel__c ;
                grantInterventionList.add(grantIntervention);
            }
        }
        
        List<Module__c> lstModuleToInsert = new List<Module__c>();
        Map<Id,Implementation_Period__c> mapIPForGModule = new Map<Id,Implementation_Period__c>([Select Id,(Select Id From Modules__r Where Name =: lstModules[EditIndex].ModuleDescription ) From Implementation_Period__c Where Id IN : IPIds]);
        
        //for(Implementation_Period__c objIP : lstIP){
            if(grantInterventionList.size() > 0){
                for(Grant_Intervention__c objGI : grantInterventionList){
                    if(mapIPForGModule.containsKey(objGI.Implementation_Period__c) && 
                        mapIPForGModule.get(objGI.Implementation_Period__c) != null &&
                        mapIPForGModule.get(objGI.Implementation_Period__c).Modules__r.size() > 0){
                        objGI.Module__c = mapIPForGModule.get(objGI.Implementation_Period__c).Modules__r[0].id;
                    }else{
                        Module__c objModule = new Module__c(Name = lstModules[EditIndex].ModuleDescription,Implementation_Period__c = objGI.Implementation_Period__c,Catalog_module__c = lstModules[EditIndex].module.Catalog_module__c,CN_Module__c = lstModules[EditIndex].module.Id);
                        lstModuleToInsert.add(objModule);
                        
                    }
                }
            }
       // }
        if(lstModuleToInsert.size() > 0){
            insert lstModuleToInsert;
            for(Grant_Intervention__c objGI : grantInterventionList){
                for(Module__c objMod : lstModuleToInsert){
                    if(objMod.Implementation_Period__c == objGI.Implementation_Period__c){
                        objGI.Module__c = objMod.id;
                    }
                }
            }
            
            
         /*List<Indicator__c> lstIndicator = [Select Id,Full_Name_En__c,Catalog_module__c,French_Name__c,Spanish_Name__c,Russian_Name__c,Type_of_Data__c,Target_Accumulation__c 
                            from Indicator__c where Indicator_Type__c = 'Coverage/Output' and Catalog_Module__c =:  lstModuleToInsert[0].Catalog_Module__c];
            if(lstIndicator.size() > 0){
                Grant_Indicator__c objGI;
                List<Grant_Indicator__c> lstGrantIndicatorToInsert = new List<Grant_Indicator__c>();
                for(Indicator__c objInd : lstIndicator){
                    for(Module__c objMod : lstModuleToInsert){
                        objGI = new Grant_Indicator__c();
                        objGI.Indicator_Full_Name__c = objInd.Full_Name_En__c;
                        objGI.Russian_Name__c = objInd.Russian_Name__c;
                        objGI.French_Name__c = objInd.French_Name__c;
                        objGI.Spanish_Name__c = objInd.Spanish_Name__c;
                        objGI.Indicator_Type__c = 'Coverage/Output';
                        objGI.Component__c = strComponent;
                        objGI.Data_Type__c = objInd.Type_of_Data__c;
                        objGI.Target_Accumulation__c = objInd.Target_Accumulation__c;
                        objGI.Parent_Module__c = objMod.id;
                        objGI.Standard_or_Custom__c = 'Standard';
                        objGI.Grant_Implementation_Period__c = objMod.Implementation_Period__c;
                         //Added To display Coverage and Op indicator Full name
                        objGI.Indicator__c = objInd.Id;
                        lstGrantIndicatorToInsert.add(objGI);
                    }
                }
                insert lstGrantIndicatorToInsert;
            }*/
        }
        
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
            insert grantInterventionList;
        }
        
        selectedIntervention.WrapPrShortNameList.clear();
        for( Grant_Intervention__c grantInv : [select Id, name, Implementation_Period__c,PR_Short_Name__c,PR__c from Grant_Intervention__c where CN_Intervention__c = : selectedIntervention.objIntervention.Id]) {
            WrapPrShortName obj = new WrapPrShortName();
            if (grantInv.PR_Short_Name__c != null) {
                obj.PrId = grantInv.Implementation_Period__c;
                obj.prShortName = grantInv.PR_Short_Name__c;
            } else {
                obj.PrId = grantInv.Implementation_Period__c;
                obj.prShortName = grantInv.PR__c;
            }
            selectedIntervention.WrapPrShortNameList.add(obj);
        }
        
        blnAddPRConfirm = false ;
    }
    
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
                Intervention__c intrvntn = lstModules[CancelIndex].childInterventions[ChildCancelIndex].objIntervention ;
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
                Intervention__c intrvntn = lstModules[EditIndex].childInterventions[ChildEditIndex].objIntervention ;
                
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
                List<Intervention__c> toDeleteIntervention = new List<Intervention__c>();
                for(WrapIntervention wi: lstModules[DeleteIndex].childInterventions) {
                        toDeleteIntervention.add(wi.objIntervention);
                }
                /*for( Catalog_Module__c cm : [select Id,Name,Component__c, component_multi__c,French_Name__c,Spanish_Name__c,Russian_Name__c from Catalog_Module__c where Component__c =: strComponent and 
                                  Id =: lstModules[DeleteIndex].Module.catalog_Module__c]) {
                    CatalogModuleWrapper obj = new CatalogModuleWrapper(cm);
                    obj.catalogModule = cm;
                    obj.CatModuleName = cm.Name;
                    obj.isSelected = false;
                    lstCatModules.add(obj);
                }*/
                
                List<Module__c> lstGrantModuleToDelete = [Select Id From Module__c 
                                                where Catalog_module__c =: lstModules[DeleteIndex].module.Catalog_Module__c
                                                And CN_Module__c =: lstModules[DeleteIndex].module.Id];
                system.debug('@@lstGrantModuleToDelete@@'+lstGrantModuleToDelete);
                if(lstGrantModuleToDelete.size() > 0){ 
                    
                    List<Grant_Indicator__c> lstGIndToUpdate = [Select Id From Grant_Indicator__c 
                                                        Where Parent_Module__c IN : lstGrantModuleToDelete
                                                        And Indicator_Type__c = 'Coverage/Output'];
                   /* V.Singh to delete the Grant intervention records if the realted module is deleted */
                    List<Grant_Intervention__c> lstGIntervenToDel = [Select Id From Grant_Intervention__c Where Module__c IN : lstGrantModuleToDelete]; 
                    
                    if(lstGIndToUpdate.size() > 0) Delete lstGIndToUpdate;
                    if(lstGIntervenToDel.size() > 0) Delete lstGIntervenToDel;
                    Delete lstGrantModuleToDelete;
                }
                
                if(!toDeleteIntervention.isEmpty()) delete toDeleteIntervention;
                Set<Id> catalogModuleIds = new Set<Id>();
                catalogModuleIds.add(lstModules[DeleteIndex].Module.catalog_module__c);
            delete lstModules[DeleteIndex].Module;
            lstModules.remove(DeleteIndex);
            blnConfirmDelete = false;
            
            /*if(lstCatModules.size() > 0){
                Set<Id> catalogModuleIds = new Set<Id>();
                for(CatalogModuleWrapper obj: lstCatModules){
                    catalogModuleIds.add(obj.catalogModule.id);
                }
                lstCatModules = new List<CatalogModuleWrapper>();
                for( Catalog_Module__c cm : [select Id,Name,Component__c, component_multi__c,French_Name__c,Spanish_Name__c,Russian_Name__c from Catalog_Module__c 
                                  Where Id in :catalogModuleIds order by Name]) {
                                  
                    CatalogModuleWrapper obj = new CatalogModuleWrapper(cm);
                    obj.catalogModule = cm;
                    obj.CatModuleName = cm.Name;
                    obj.isSelected = false;
                    lstCatModules.add(obj);
                }
            }*/
            
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
            for( Catalog_Module__c cm : [select Id,Name,Component__c, component_multi__c,French_Name__c,Spanish_Name__c,Russian_Name__c from Catalog_Module__c where Component__c =: strComponent and 
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
            Module__c objModule = new Module__c(Name = strAddNewModuleDescription,Concept_Note__c = strConceptNoteId, Component__c = strComponent);
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
            Module__c objModule = new Module__c(Concept_Note__c = strConceptNoteId, Component__c = strComponent);
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
                Intervention__c objInterventionTemp = new Intervention__c(Name = moduleW.strAddNewCustomInterventionDec,Concept_Note__c = strConceptNoteId,Module_rel__c = moduleW.ModuleId);
                insert objInterventionTemp;
                objWrapInt.objIntervention = objInterventionTemp;
                objWrapInt.IndexIntervention = ChildSaveIndex;
                objWrapInt.blnIndicatorDisplay = true;
                objWrapInt.WrapPrShortNameList = new List<WrapPrShortName>();
                moduleW.childInterventions.add(objWrapInt);
                objWrapInt.implementationPeriods = new List<ImplementationPeriodWrapper>();
                for(Implementation_Period__c objIp : mapImplementationPeriod.values()){
                    objWrapInt.implementationPeriods.add(new ImplementationPeriodWrapper(objIp));
                }
            }else{
                moduleW.childInterventions[ChildSaveIndex].blnIndicatorDisplay = true ;
                Intervention__c interventionToInsert = moduleW.childInterventions[ChildSaveIndex].objIntervention;
                interventionToInsert.Module_rel__c = moduleW.ModuleId ;
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
    
    
    public void AddCustomModule() {
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
    }*/
    
    /*public void AddNewPR() {
        ChildEditIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('ChildEditIndex'));
        EditIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('EditIndex'));
        blnAddPRConfirm = true ;
        
        Intervention__c selectedIntervention = lstModules[EditIndex].childInterventions[ChildEditIndex].objIntervention ;
        // query all child Grant Intervention of Intervention and pick its parent Implementaion Period and don't query it
        List<Grant_Intervention__c> childCGrantInterventions = [Select Id, Name, PR_Short_Name__c,PR__c, CN_Intervention__c, Implementation_Period__c 
                                                                From Grant_Intervention__c where CN_Intervention__c =:selectedIntervention.Id ];
        
        Set<Id> impPeriodIds = new Set<Id>();
        for(Grant_Intervention__c grntInv : childCGrantInterventions) {
                impPeriodIds.add(grntInv.Implementation_Period__c);
        }
        
        implementationPeriods = new List<ImplementationPeriodWrapper>();
        for ( Implementation_Period__c ip : [Select Name, Principal_Recipient__c, Principal_Recipient__r.Name, Id, Grant__c, Concept_Note__c 
                                             From Implementation_Period__c where Concept_Note__c =: strConceptNoteId and Id not in :impPeriodIds]){
                
            implementationPeriods.add(new ImplementationPeriodWrapper(ip));
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
            Intervention__c todeleteIntervention = lstModules[DeleteIndex].childInterventions[DeleteChildIndex].objIntervention;
            
            List<Catalog_Intervention__c> lstCatInt = [Select Catalog_Module__c,Spanish_Name__c, Spanish_Description__c, 
                                                Russian_Name__c, Name,Id, French_Name__c, 
                                                Description__c, Component__c From Catalog_Intervention__c 
                                                Where Id =: todeleteIntervention.Intervention__c Limit 1];
            Set<Id> setIntIdAll = new Set<Id>();
            if(todeleteIntervention != null){
                if(lstCatInt.size() > 0){
                    setIntIdAll.add(lstCatInt[0].Id);
                }
                //if(lstModules[DeleteIndex].lstinterventions.size() > 0){
                    for(CatalogInterventionWrapper obj : lstModules[DeleteIndex].lstinterventions){
                        setIntIdAll.add(obj.catalogIntervention.id);
                    }
                    List<Catalog_Intervention__c> lstCatIntAll = [Select Catalog_Module__c,Spanish_Name__c, Spanish_Description__c, 
                                                Russian_Name__c, Name,Id, French_Name__c, 
                                                Description__c, Component__c From Catalog_Intervention__c 
                                                Where (Id IN : setIntIdAll OR Name Like 'Other%')
                                                And catalog_module__c =: lstModules[DeleteIndex].module.catalog_module__c order by name];
                    if(lstCatIntAll.size() >0 ){
                        lstModules[DeleteIndex].lstinterventions = new List<CatalogInterventionWrapper>();
                        for(Catalog_Intervention__c objCI : lstCatIntAll ){
                            lstModules[DeleteIndex].lstinterventions.add(new CatalogInterventionWrapper(objCI));
                        }
                    }                            
                    
               // }
                
                List<Grant_Intervention__c> lstGIToDelete = [Select Id From Grant_Intervention__c Where CN_Intervention__c =: todeleteIntervention.id];
                if(lstGIToDelete.size() > 0) Delete lstGIToDelete;
                
                Set<Id> PRToDeleteIds = new Set<Id>();
                system.debug('#$%#$#@$#$'+lstModules[DeleteIndex].childInterventions[DeleteChildIndex].WrapPrShortNameList);
                if(lstModules[DeleteIndex].childInterventions[DeleteChildIndex].WrapPrShortNameList != null){
                    for(WrapPrShortName objImpPR : lstModules[DeleteIndex].childInterventions[DeleteChildIndex].WrapPrShortNameList){
                        PRToDeleteIds.add(objImpPR.prid);
                        system.debug('#$%#$#@$#$'+PRToDeleteIds);
                    }
                }
                if(PRToDeleteIds != null){
                    system.debug('#$%#$#@$#$'+PRToDeleteIds);
                    RemoveModule(lstModules[DeleteIndex].Module.Name,PRToDeleteIds,lstModules[DeleteIndex].Module.Catalog_Module__c);
                }
                //if(PRToDeleteIds.size() > 0){
                    
                    
                    /*Boolean blnIsOtherPRExist = false;
                    for(WrapIntervention objInt : lstModules[DeleteIndex].childInterventions){
                        if(objInt.objIntervention.id != todeleteIntervention.id){
                            for(ImplementationPeriodWrapper objImpPR : objInt.implementationPeriods){
                                if(PRToDeleteIds.Contains(objImpPR.implementationPeriod.id)){
                                    blnIsOtherPRExist = true;
                                    break;
                                }
                            }
                        }
                    }
                    if(blnIsOtherPRExist == false){
                        List<Grant_Intervention__c> lstGI = [Select Id From Grant_Intervention__c Where Id =: todeleteIntervention.Catalog_Module__c];
                        if(lstCatModule.size() > 0) Delete lstCatModule;
                    }*/
               // }
                
                
                /*integer count = 0;
                for(CatalogInterventionWrapper objcat : lstModules[DeleteIndex].lstinterventions){
                    if(objcat.catalogIntervention.id == todeleteIntervention.Intervention__c){
                        lstModules[DeleteIndex].lstinterventions.remove(count);
                    }
                    count++;
                }    */                                
                delete todeleteIntervention ;
            }
            
            lstModules[DeleteIndex].childInterventions.remove(DeleteChildIndex) ;
            
            
            
            blnInterventionConfirmDelete = false;
        }
    }
    
    public void RemoveModule(String GModuleName,Set<Id> setPrShortNameList,Id CatModId){
        Set<Id> setIPIds = new Set<Id>();
        List<Implementation_Period__c> lstImpPR  = [Select Id,(Select Module__c From Grant_Interventions__r Where Module__r.Name =: GModuleName) From Implementation_Period__c Where Id IN : setIPIds];
        for(Implementation_Period__c objIp : lstImpPR){
            setIPIds.add(objIp.Id);
        }
        system.debug('#####'+setIPIds);
        if(setIPIds.size() > 0){
            List<Module__c> lstModuleToDelete = [Select Id From Module__c Where Implementation_Period__c IN : setIPIds And Concept_Note__c = null And Name =: GModuleName And Catalog_Module__c =: CatModId];
            if(lstModuleToDelete.size() > 0) Delete lstModuleToDelete;
        }
    }
    
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
        Public String CatModuleName {get;set;}
        public Boolean isSelected {get { return isSelected == null ? false : isSelected ; } set;}
        
        public CatalogModuleWrapper(Catalog_Module__c cM) {
            this.catalogModule = cM ;
            this.isSelected = false ;
        }
    }
    //TCS 11/09/2014: Added to give profile based permissions
     public void checkProfile(){
        blnExternalPro =false;
        blnAddModule =false;
        blnAddIntervention =false;
        blnEditModule =false;
        blnDeleteModule =false;
        blnEditIntervention =false;
        blnDeleteIntervention =false;
        blnAddPR =false;
        blnEditPR =false;
        blnDeletePR =false;
         Id profileId=userinfo.getProfileId();
         String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
         List<Profile_Access_Setting_CN__c> checkpage = new List<Profile_Access_Setting_CN__c>();
         List<String> PermissionSets = new List<String>();
         List<PermissionSetAssignment> standalonePermSets = [ SELECT PermissionSet.Id, PermissionSet.Name, PermissionSet.Label FROM PermissionSetAssignment WHERE Assignee.Username =: UserInfo.getUserName()];
        if(standalonePermSets.size()>0){
        for(PermissionSetAssignment PermSets : standalonePermSets){
            PermissionSets.add(PermSets.PermissionSet.Label);
            system.debug('Name '+PermSets.PermissionSet.Label);
            
        }}
        system.debug('Check CN Status '+strCNStaus );
        checkpage = [Select Salesforce_Item__c,Status__c from Profile_Access_Setting_CN__c where Page_Name__c ='ModulesAndInterventions' and (Profile_Name__c =: profileName OR Permission_Sets__c IN: PermissionSets)];
      for (Profile_Access_Setting_CN__c check : checkpage){
        if (check.Salesforce_Item__c == 'External Profile') blnExternalPro = true;
        if(check.Salesforce_Item__c == 'Add Module' && check.Status__c== strCNStaus)blnAddModule = true;
        if(check.Salesforce_Item__c == 'Add Intervention' && check.Status__c== strCNStaus)blnAddIntervention = true;
         if(check.Salesforce_Item__c == 'Edit Module' && check.Status__c== strCNStaus)blnEditModule = true;
         if(check.Salesforce_Item__c == 'Delete Module' && check.Status__c== strCNStaus)blnDeleteModule = true;
         if(check.Salesforce_Item__c == 'Edit Intervention' && check.Status__c== strCNStaus)blnEditIntervention = true;
         if(check.Salesforce_Item__c == 'Delete Intervention' && check.Status__c== strCNStaus)blnDeleteIntervention = true;
         if(check.Salesforce_Item__c == 'Add PR' && check.Status__c== strCNStaus)blnAddPR = true;
         if(check.Salesforce_Item__c == 'Edit PR' && check.Status__c== strCNStaus)blnEditPR = true;
         if(check.Salesforce_Item__c == 'Delete PR' && check.Status__c== strCNStaus)blnDeletePR = true;
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
        public Intervention__c objIntervention {get;set;}
        public List<SelectOption> EditPROptions {get;set;}
        Public String IntDescription {get;set;}
        public Integer IndexIntervention {get;set;}
        public Boolean blnIndicatorDisplay {get;set;}
        public List<ImplementationPeriodWrapper> implementationPeriods {get; set;}
        public Boolean isAddedFromCustom {get {return isAddedFromCustom != null ? isAddedFromCustom : false; } set;}
        //public List<String> prShortNameList {get; set;}
        public List<WrapPrShortName> WrapPrShortNameList {get; set;}
    }
    public Class WrapPrShortName{
        public String EditPRName {get;set;}
        public Boolean blndisplayPRPicklist {get;set;}
        public Id PrId {get;set;}
        public String prShortName {get;set;}
    }
    
    
}