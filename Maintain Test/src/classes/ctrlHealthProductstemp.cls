Public Class ctrlHealthProductstemp{

    Public String strPageId {get;set;}
    Public String strSelectedYear {get;set;}
    Public String strImplementationPeriodId {get;set;}
    Public String strComponent {get;set;}
    Public List<SelectOption> CostInputOptions {get;set;}
    Public List<SelectOption> CostInputOptionsPSMCost{get;set;}    
    Public List<SelectOption> ImplementersOptions {get;set;}
    Public List<Page__c> lstPageTodisplay {get;set;}
    Public List<wrapProducts> lstProducts {get;set;}
    Public List<PSMCost> lstPSMCosts {get;set;}
    Public String strLengthYears {get;set;}
    Public wrapProducts objNewProduct {get;set;}
    Public Map<Id,wrapProducts> mapProIdTowrap {get;set;}
    Public Map<Id,PSMCost> mapPSMCostIdTowrap {get;set;}
    Public String strSelectedCatagory {get;set;}
    Public List<SelectOption> CatagoryOptions {get;set;}
    Public List<SelectOption> InterventionsOptions {get;set;}
    Public PSMSplit objPSMNew {get;set;}   
    Public PSMCost objNewPSMCost {get;set;}
    Public integer intIndex;
    Public Datetime resfreshBdgtDate {get; set;}
    
    Public boolean blndbutton {get;set;}
    
    Public List<Id> lstGIPID; 
    Public List<Implementation_Period__c> lstImp {get;set;}
    Public List<Catalog_Product__c> lstCatalogProduct_new;
    
    Public String Cost_Input_ID;
    Public String strLanguage {get;set;}
    Public String strGuidanceId {get;set;}
    Public boolean blnExternalPro {get;set;}
    Public boolean blnEdit {get;set;}
    Public boolean blnDelete {get;set;}
    Public boolean blnTGFComment {get;set;}
    Public boolean blnLFAComment {get;set;}
    Public boolean blnPRCommment {get;set;}
    Public boolean blnIntSplit {get;set;}
    Public boolean blnRefersh {get;set;}
    Public boolean blnSave {get;set;}
    public string grantcurrency {get;set;}
    
    public List<SelectOption> ModuleOptions {get;set;}
    public List<SelectOption> InterventionModOptions {get;set;}
    Public String ModId;
    
    //Public String CurrencyGrantAgreement {get;set;}
    //Public Decimal CostY1 {get;set;} 
     

        public ctrlHealthProductstemp(ApexPages.StandardController controller) {
        strPageId = Apexpages.currentpage().getparameters().get('Id');
        
        lstGIPId = new List<Id>();
        lstImp= new List<Implementation_Period__c>();
        
        lstCatalogProduct_new = new List<Catalog_Product__c> (); 
        
        if(String.IsBlank(strPageId) == false){
            
            List<Page__c> lstPageTemp = [Select Implementation_Period__c,Implementation_Period__r.Concept_Note__r.language__c,Implementation_Period__r.Component__c,Implementation_Period__r.Id,
                                            Implementation_Period__r.Length_Years__c,Implementation_Period__r.Currency_of_Grant_Agreement__c                                            
                                            From Page__c 
                                            Where id =: strPageId And Implementation_Period__c != null];
            
            /************************************************************
                     Changes for See Help Link TCS
            ***********************************************************/
            if(!lstPageTemp.isEmpty())                               
              strLanguage = lstPageTemp[0].Implementation_Period__r.Concept_Note__r.Language__c;  
              
            
              List<Guidance__c> lstGuidance = [Select Id from Guidance__c where Name =:label.GMHealthProduct];
              if(!lstGuidance.isEmpty()) {
                    strGuidanceId = lstGuidance[0].Id;
              }
              
           /* Done*/                             
                                            
            if(!lstPageTemp.isEmpty())
            {
                        
                        for (Page__c temp_page: lstPageTemp)
                        {
                        
                            lstGIPId.add(temp_page.Implementation_Period__r.Id);
                        
                        }    
                          
            }           
            grantcurrency = lstPageTemp[0].Implementation_Period__r.Currency_of_Grant_Agreement__c;
            lstImp = [Select Id, Name, Last_Product_Roll_up__c from Implementation_Period__c where id in: lstGIPId];                     
                                            
            lstPageTodisplay = new List<Page__c>();
            strSelectedYear = 'Year1';
            fillCatagory();
            FillCostInput(); 
            lstProducts = new List<wrapProducts>();
            strSelectedYear = 'Year1';
            strLengthYears = null;
            intIndex = null;
            
            if(!lstImp.isEmpty())
            {
              if(lstImp[0].Last_Product_Roll_up__c == null)
                blndbutton = false;
              else
                blndbutton = true;  
              
            }
            
            objNewPSMCost = new PSMCost();
            objNewPSMCost.objPSMCost = new PSM__c();
            mapPSMCostIdTowrap = new Map<Id,PSMCost>();
            strImplementationPeriodId = lstPageTemp[0].Implementation_Period__c;
            
            
            if(String.IsBlank(strImplementationPeriodId) == false){
            
                
                strComponent = lstPageTemp[0].Implementation_Period__r.Component__c;
                strLengthYears = lstPageTemp[0].Implementation_Period__r.Length_Years__c;
                lstPageTodisplay = [Select Id,Name,URL_Prefix__c,Order__c,Implementation_Period__c From Page__c Where Implementation_Period__c =: strImplementationPeriodId  Order by Order__c]; 
                if(lstPageTemp.size() > 0){                                                
                    selectedCatagory();
                    fillImplementers(); 
                    fillInterventions();
                    FillCostInputPSMCost();
                    
                    objNewProduct = new wrapProducts ();
                    objNewProduct.objProduct = new Product__c(Implementation_Period__c = strImplementationPeriodId);
                    mapProIdTowrap = new Map<Id,wrapProducts>();
                    objPSMNew = new PSMSplit();
                }
            }
        }
    }
    
     Public void FillModules(){
        ModuleOptions = new List<SelectOption>();
        List<Module__c> ModList = [Select id,Name,Implementation_period__c 
        						   from Module__c 
        						   where Implementation_period__c=: strImplementationPeriodId];
        						   
        ModuleOptions.add(new SelectOption('','--None--'));
        if(ModList.size() > 0){
            for(Module__c Mo : ModList){
                ModuleOptions.add(new SelectOption(Mo.Id,Mo.Name));
            }
        }
       // system.debug('#$#$CostInputOptionsPSMCost#$#$'+CostInputOptionsPSMCost);
    }
    
    Public Void ConvertIntervention()
    {
    
    ConvertInterventionToBudgetLines tempclass = new ConvertInterventionToBudgetLines();
    
        if(!lstGIPId.isEmpty())
        {                                    
            
            tempclass.ConversionMethod(lstGIPId);
            
            Implementation_Period__c imp = [Select id, Name, Last_Product_Roll_up__c from Implementation_Period__c where id in: lstGIPId];
            imp.Last_Product_Roll_up__c = System.now();
            resfreshBdgtDate = System.now();
            update imp;
            //resfreshBdgtDate = new Datetime();
            
            system.debug('resfreshBdgtDate** '+resfreshBdgtDate);
            blndbutton = true;
                   
        }
    
    }
    
    Public void fillCatagory(){
        strSelectedCatagory = null;
        CatagoryOptions = new List<SelectOption>();
        Schema.sObjectType objType = Catalog_Cost_Input__c.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe(); 
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
        List<Schema.PicklistEntry> lstCatagory = fieldMap.get('Product_Category__c').getDescribe().getPickListValues();
        CatagoryOptions.add(new SelectOption('','--None--')); 
        for (Schema.PicklistEntry Entry : lstCatagory){ 
            CatagoryOptions.add(new SelectOption(Entry.getLabel(), Entry.getValue())); 
        }
    }
    
    Public void FillCostInputPSMCost(){
        CostInputOptionsPSMCost = new List<SelectOption>();
        List<Catalog_Cost_Input__c> lstCostInputPSM = [Select Id,Name, Cost_Grouping__c, Unit_Cost_Definition__c 
                                                From Catalog_Cost_Input__c 
                                                Where PSM__c = true 
                                                AND Disease_Impact__c INCLUDES(:strComponent) 
                                                AND Cost_Grouping__c = '7. Procurement and Supply-Chain Management costs (PSM)'
                                                Order by Cost_Input_Number__c];
        CostInputOptionsPSMCost.add(new SelectOption('','--None--'));
        if(lstCostInputPSM.size() > 0){
            for(Catalog_Cost_Input__c objCI : lstCostInputPSM){
                CostInputOptionsPSMCost.add(new SelectOption(objCI.Id,objCI.Name));
            }
        }
        system.debug('#$#$CostInputOptionsPSMCost#$#$'+CostInputOptionsPSMCost);
    }
    
    Public void FillModuleInterventions(){
        InterventionModOptions = new List<SelectOption>();
        List<Grant_Intervention__c> lstInt = [Select Id,Name  
                                                From Grant_Intervention__c 
                                                Where Module__c =: objNewProduct.strModuleName];
        
        InterventionModOptions.add(new SelectOption('','--None--'));
        if(lstInt.size() > 0){
            for(Grant_Intervention__c GInt : lstInt){
                InterventionModOptions.add(new SelectOption(GInt.Id,GInt.Name));
            }
        }
     // system.debug('#$#$CostInputOptionsPSMCost#$#$'+CostInputOptionsPSMCost);
    }
    
    Public void FillModuleInterventionsNew(){
    	ModId = Apexpages.currentpage().getparameters().get('ModId');
        InterventionModOptions = new List<SelectOption>();
        List<Grant_Intervention__c> lstInt = [Select Id,Name  
                                                From Grant_Intervention__c 
                                                Where Module__c =: ModId];
         
                                            
        
        InterventionModOptions.add(new SelectOption('','--None--'));
        if(lstInt.size() > 0){
            for(Grant_Intervention__c GInt : lstInt){
                InterventionModOptions.add(new SelectOption(GInt.Id,GInt.Name));
            }
        }
     // system.debug('#$#$CostInputOptionsPSMCost#$#$'+CostInputOptionsPSMCost);
    }
    
    
    Public void selectedCatagory(){
        if(String.IsBlank(strImplementationPeriodId) == false){
            lstProducts = new List<wrapProducts>();
            system.debug('#$#$strSelectedCatagory #$#$'+strSelectedCatagory );
            if(strSelectedCatagory != 'PSM Cost'){
                String strQuery = 'Select Product_Name__c,Cost_Input__r.Name,Grant_Intervention__r.Name,Grant_Intervention__c,Cost_Input__r.Is_Inactive__c, module__c,module__r.name,Product_Category__c,Strength_Shape__c,Catalog_Product__c,(Select Id from PSM_Intervention_Splits__r),Catalog_Product__r.Name,Catalog_Product__r.Product_Name__c,Catalog_Product__r.Is_Inactive__c,Catalog_Product__r.Generic_Product__c,Catalog_Product__r.Generic_Product__r.Is_Inactive__c,Catalog_Product__r.Generic_Product__r.name,Catalog_Product__r.Generic_Product__r.Catalog_Cost_Input__c,Catalog_Product__r.Specification__c,Implementer__c,Implementer__r.name,Implementer__r.Implementer_Name__c,Catalog_Product__r.Generic_Product__r.Catalog_Cost_Input__r.Name,Quantity_Q1__c,Quantity_Q10__c,Quantity_Q11__c,Quantity_Q12__c,Quantity_Q13__c,Quantity_Q14__c,Quantity_Q15__c,Quantity_Q16__c,Quantity_Q2__c,Quantity_Q3__c,Quantity_Q4__c,Quantity_Q5__c,Quantity_Q6__c,Quantity_Q7__c,Quantity_Q8__c,Quantity_Q9__c,Unit_Cost_Y1__c,Unit_Cost_Y2__c,Unit_Cost_Y3__c,Unit_Cost_Y4__c,Cost_Y1__c,Cost_Y2__c,Cost_Y3__c,Cost_Y4__c,Total_Cost__c,Product_Main_Category__c,Latest_LFA_Comment__c,Latest_PR_Comment__c,Latest_TGF_Comment__c,LFA_Comments__c,PR_Comments__c,TGF_Comments__c From Product__c Where Implementation_Period__c =: strImplementationPeriodId And Product_Main_Category__c =: strSelectedCatagory Order By Product_Number__c';
            
                /*if(String.isBlank(strSelectedCatagory) == false){
                    strQuery += ' And Product_Main_Category__c =: strSelectedCatagory';
                }*/
                
                CostInputOptions = new List<SelectOption>();
                List<Catalog_Cost_Input__c> lstCostInput = [Select Id,Name, Cost_Grouping__c, Unit_Cost_Definition__c 
                                                        From Catalog_Cost_Input__c 
                                                        Where PSM__c = true 
                                                        AND Disease_Impact__c INCLUDES(:strComponent) 
                                                        And Product_Category__c =: strSelectedCatagory 
                                                        Order by Cost_Input_Number__c];
                CostInputOptions.add(new SelectOption('','--None--'));
                if(lstCostInput.size() > 0){
                    for(Catalog_Cost_Input__c objCI : lstCostInput){
                        CostInputOptions.add(new SelectOption(objCI.Id,objCI.Name));
                    }
                }
                // get modules of implementation period
                FillModules();
                System.debug('######'+CostInputOptions);
                List<Product__c> lstProductTemp = new List<Product__c>();
                
                lstProductTemp = Database.Query(strQuery);
                
                /*List<Product__c> lstProduct = [Select Catalog_Product__c,Catalog_Product__r.Name,
                                Catalog_Product__r.Generic_Product__c,Catalog_Product__r.Generic_Product__r.name,
                                Catalog_Product__r.Generic_Product__r.Catalog_Cost_Input__c,
                                Catalog_Product__r.Specification__c,Implementer__c,Implementer__r.name,
                                Catalog_Product__r.Generic_Product__r.Catalog_Cost_Input__r.Name,
                                Quantity_Q1__c,Quantity_Q10__c,Quantity_Q11__c,Quantity_Q12__c,Quantity_Q13__c,
                                Quantity_Q14__c,Quantity_Q15__c,Quantity_Q16__c,Quantity_Q2__c,Quantity_Q3__c,
                                Quantity_Q4__c,Quantity_Q5__c,Quantity_Q6__c,Quantity_Q7__c,Quantity_Q8__c,Quantity_Q9__c,
                                Unit_Cost_Y1__c,Unit_Cost_Y2__c,Unit_Cost_Y3__c,Unit_Cost_Y4__c From Product__c
                                Where Implementation_Period__c =: strImplementationPeriodId];*/
                            
                if(lstProductTemp.size() > 0){
                    for(Product__c objProduct : lstProductTemp){
                        wrapProducts objWrap = new wrapProducts();
                        objWrap.objProduct = new Product__c();
                        objWrap.objProduct = objProduct;
                        objWrap.strCatalogProductName = objProduct.Catalog_Product__r.Name;
                        objWrap.strGenericProductName = objProduct.Catalog_Product__r.Generic_Product__r.name;
                        objWrap.strCostInputName = objProduct.Cost_Input__r.Name;
                        objWrap.strModuleName = objProduct.Module__r.Name;
                        objWrap.strInterventionName = objProduct.Grant_Intervention__r.Name;
                        objWrap.strStrengthAndUnit = objProduct.Catalog_Product__r.Specification__c;
                        objWrap.strImplementer = objProduct.Implementer__r.Implementer_Name__c;
                        objWrap.blnIsEditable = true;
                        objWrap.lstPSMSplits = objProduct.PSM_Intervention_Splits__r;

                        
                        if(objProduct.Unit_Cost_Y1__c == null) objProduct.Unit_Cost_Y1__c = 0;
                        if(objProduct.Unit_Cost_Y2__c == null) objProduct.Unit_Cost_Y2__c = 0;
                        if(objProduct.Unit_Cost_Y3__c == null) objProduct.Unit_Cost_Y3__c = 0;
                        if(objProduct.Unit_Cost_Y4__c == null) objProduct.Unit_Cost_Y4__c = 0;
                        
                        if(objProduct.Quantity_Q1__c == null) objProduct.Quantity_Q1__c = 0;
                        if(objProduct.Quantity_Q2__c == null) objProduct.Quantity_Q2__c = 0;
                        if(objProduct.Quantity_Q3__c == null) objProduct.Quantity_Q3__c = 0;
                        if(objProduct.Quantity_Q4__c == null) objProduct.Quantity_Q4__c = 0;
                        if(objProduct.Quantity_Q5__c == null) objProduct.Quantity_Q5__c = 0;
                        if(objProduct.Quantity_Q6__c == null) objProduct.Quantity_Q6__c = 0;
                        if(objProduct.Quantity_Q7__c == null) objProduct.Quantity_Q7__c = 0;
                        if(objProduct.Quantity_Q8__c == null) objProduct.Quantity_Q8__c = 0;
                        if(objProduct.Quantity_Q9__c == null) objProduct.Quantity_Q9__c = 0;
                        if(objProduct.Quantity_Q10__c == null) objProduct.Quantity_Q10__c = 0;
                        if(objProduct.Quantity_Q11__c == null) objProduct.Quantity_Q11__c = 0;
                        if(objProduct.Quantity_Q12__c == null) objProduct.Quantity_Q12__c = 0;
                        if(objProduct.Quantity_Q13__c == null) objProduct.Quantity_Q13__c = 0;
                        if(objProduct.Quantity_Q14__c == null) objProduct.Quantity_Q14__c = 0;
                        if(objProduct.Quantity_Q15__c == null) objProduct.Quantity_Q15__c = 0;
                        if(objProduct.Quantity_Q16__c == null) objProduct.Quantity_Q16__c = 0;
                        
                        objWrap.TotalQuantityYear1 = objProduct.Quantity_Q1__c + objProduct.Quantity_Q2__c + objProduct.Quantity_Q3__c + objProduct.Quantity_Q4__c;
                        objWrap.TotalQuantityYear2 = objProduct.Quantity_Q5__c + objProduct.Quantity_Q6__c + objProduct.Quantity_Q7__c + objProduct.Quantity_Q8__c;
                        objWrap.TotalQuantityYear3 = objProduct.Quantity_Q9__c + objProduct.Quantity_Q10__c + objProduct.Quantity_Q11__c + objProduct.Quantity_Q12__c;
                        objWrap.TotalQuantityYear4 = objProduct.Quantity_Q13__c + objProduct.Quantity_Q14__c + objProduct.Quantity_Q15__c + objProduct.Quantity_Q16__c;
                        objWrap.GrantTotalQuantityYear1 = objWrap.TotalQuantityYear1 * objProduct.Unit_Cost_Y1__c;
                        objWrap.GrantTotalQuantityYear2 = objWrap.TotalQuantityYear2 * objProduct.Unit_Cost_Y2__c;
                        objWrap.GrantTotalQuantityYear3 = objWrap.TotalQuantityYear3 * objProduct.Unit_Cost_Y3__c;
                        objWrap.GrantTotalQuantityYear4 = objWrap.TotalQuantityYear1 + objWrap.TotalQuantityYear2 + objWrap.TotalQuantityYear3 + objWrap.TotalQuantityYear4;
                        lstProducts.add(objWrap);
                    }
                    system.debug('#$#$#$#$#$'+lstProducts);
                }
            }else{
                
                lstPSMCosts = new List<PSMCost>();
                List<PSM__c> lstPSMCostTemp = [Select Implementer__c,Module__c,PSM_Cost_Input__c,PSM_Cost_Input__r.name,
                                        Q10_Cost__c,Q11_Cost__c,Implementer__r.Name,Implementer__r.Implementer_Name__c,
                                        Q12_Cost__c,Q13_Cost__c,Q14_Cost__c,Q15_Cost__c,Q16_Cost__c,Q1_Cost__c,Q2_Cost__c,
                                        Q3_Cost__c,Q4_Cost__c,Q5_Cost__c,Q6_Cost__c,Q7_Cost__c,Q8_Cost__c,Q9_Cost__c,
                                        Y1_Total__c,Y2_Total__c,Y3_Total__c,Y4_Total__c From PSM__c];
                
                PSMCost objWrap;                        
                for(PSM__c objPC : lstPSMCostTemp){
                    objWrap = new PSMCost();
                    objWrap.objPSMCost = new PSM__c();
                    objWrap.objPSMCost = objPC;
                    objWrap.strCostInputNamePSMCost = objPC.PSM_Cost_Input__r.name;
                    objWrap.strPayee = objPC.Implementer__r.Implementer_Name__c;
                    objWrap.blnIsEditable = true;    
                    objWrap.TotalCostY1 = objPC.Y1_Total__c;   
                    objWrap.TotalCostY2 = objPC.Y2_Total__c;   
                    objWrap.TotalCostY3 = objPC.Y3_Total__c;   
                    objWrap.TotalCostY4 = objPC.Y4_Total__c;   
                    objWrap.GrantTotalCost = objPC.Y1_Total__c + objPC.Y2_Total__c + objPC.Y3_Total__c + objPC.Y4_Total__c;
                    lstPSMCosts.add(objWrap);
                }
               
            }
        }
    }
    
    Public void FillCostInput(){
        CostInputOptions = new List<SelectOption>();
        List<Catalog_Cost_Input__c> lstCostInput = [Select Id,Name, Cost_Grouping__c,Is_Inactive__c, Unit_Cost_Definition__c From Catalog_Cost_Input__c Where PSM__c = true AND Is_Inactive__c!= True AND Disease_Impact__c INCLUDES(:strComponent) Order by Cost_Input_Number__c ];
        CostInputOptions.add(new SelectOption('','--None--'));
        if(lstCostInput.size() > 0){
            for(Catalog_Cost_Input__c objCI : lstCostInput){
                CostInputOptions.add(new SelectOption(objCI.Id,objCI.Name));
            }
        }
    }
    
    Public void EditProduct(){
         Integer EditIndex = integer.valueof(Apexpages.currentpage().getparameters().get('EditIndex'));
         if(EditIndex != null){
            lstProducts[EditIndex].blnIsEditable = false;
            system.debug('##$#$#$#$'+lstProducts[EditIndex].ProductNameOptions);
            system.debug('##$#$#$#$'+lstProducts[EditIndex].strGenericProductName);
            system.debug('##$#$#$#$'+lstProducts[EditIndex].StrengthAndUnitOptions);
            system.debug('##$#$#$#$'+lstProducts[EditIndex].strStrengthAndUnit);
            system.debug('##$#$#$#$'+lstProducts[EditIndex].strModuleName);
            system.debug('##$#$#$#$'+lstProducts[EditIndex].strInterventionName);
             //lstProducts[EditIndex].strInterventionName = lstProducts[EditIndex].strInterventionName;
            lstProducts[EditIndex].ProductNameOptions = new List<SelectOption>();
            lstProducts[EditIndex].StrengthAndUnitOptions = new List<SelectOption>();
            lstProducts[EditIndex].ProductNameOptions.add(new SelectOption('','--None--'));
            lstProducts[EditIndex].StrengthAndUnitOptions.add(new SelectOption('','--None--'));
            if(String.IsBlank(lstProducts[EditIndex].strCostInputName) == false){
                lstProducts[EditIndex].strGenericProductName = lstProducts[EditIndex].objProduct.Catalog_Product__r.Generic_Product__c;
            
                List<Catalog_Generic_Product__c> lstGenericProduct = [Select Id,name,Is_Inactive__c From Catalog_Generic_Product__c 
                                            Where Catalog_Cost_Input__c =: lstProducts[EditIndex].objProduct.Catalog_Product__r.Generic_Product__r.Catalog_Cost_Input__c AND is_Inactive__c=: False];
                if(lstGenericProduct.size() > 0){
                    for(Catalog_Generic_Product__c objGP : lstGenericProduct){
                        lstProducts[EditIndex].ProductNameOptions.add(new SelectOption(objGP.Id,objGP.name));
                    }
                }
            }
    
            if(String.IsBlank(lstProducts[EditIndex].strGenericProductName) == false){
                lstProducts[EditIndex].strStrengthAndUnit = lstProducts[EditIndex].objProduct.Catalog_Product__c;
                List<Catalog_Product__c> lstCatalogProduct = [Select Id,Specification__c From Catalog_Product__c 
                                            Where Generic_Product__c =: lstProducts[EditIndex].objProduct.Catalog_Product__r.Generic_Product__c];
                if(lstCatalogProduct.size() > 0){
                    for(Catalog_Product__c objGP : lstCatalogProduct){
                        lstProducts[EditIndex].StrengthAndUnitOptions.add(new SelectOption(objGP.Id,objGP.Specification__c));
                    }
                }
            }
            
            wrapProducts objProductTemp = new wrapProducts();
            objProductTemp.objProduct = lstProducts[EditIndex].objProduct.clone(true);
            objProductTemp.blnIsEditable = lstProducts[EditIndex].blnIsEditable;
            objProductTemp.strCatalogProductName = lstProducts[EditIndex].strCatalogProductName;
            objProductTemp.strGenericProductName = lstProducts[EditIndex].strGenericProductName;
            objProductTemp.strCostInputName = lstProducts[EditIndex].strCostInputName;
            objProductTemp.strStrengthAndUnit = lstProducts[EditIndex].strStrengthAndUnit;
            objProductTemp.strImplementer = lstProducts[EditIndex].strImplementer;
            objProductTemp.strModuleName = lstProducts[EditIndex].strModuleName;
            objProductTemp.strInterventionName = lstProducts[EditIndex].strInterventionName;
            
            objProductTemp.ProductNameOptions = lstProducts[EditIndex].ProductNameOptions;
            objProductTemp.StrengthAndUnitOptions = lstProducts[EditIndex].StrengthAndUnitOptions;
            
            
            objProductTemp.GrantTotalQuantityYear1 = lstProducts[EditIndex].GrantTotalQuantityYear1;
            objProductTemp.GrantTotalQuantityYear2 = lstProducts[EditIndex].GrantTotalQuantityYear2;
            objProductTemp.GrantTotalQuantityYear3 = lstProducts[EditIndex].GrantTotalQuantityYear3;
            objProductTemp.GrantTotalQuantityYear4 = lstProducts[EditIndex].GrantTotalQuantityYear1 + lstProducts[EditIndex].GrantTotalQuantityYear2 + lstProducts[EditIndex].GrantTotalQuantityYear3 +lstProducts[EditIndex].GrantTotalQuantityYear4;
            objProductTemp.TotalQuantityYear1 = lstProducts[EditIndex].TotalQuantityYear1;
            objProductTemp.TotalQuantityYear2 = lstProducts[EditIndex].TotalQuantityYear2;
            objProductTemp.TotalQuantityYear3 = lstProducts[EditIndex].TotalQuantityYear3;
            objProductTemp.TotalQuantityYear4 = lstProducts[EditIndex].TotalQuantityYear4;
            mapProIdTowrap.put(objProductTemp.objProduct.id,objProductTemp);
            
            system.debug('##$#$#$#$'+lstProducts[EditIndex].strCostInputName);
            for(SelectOption SO:CostInputOptions){
                if(SO.getLabel() == String.Valueof(lstProducts[EditIndex].strCostInputName)){
                    lstProducts[EditIndex].strCostInputName = SO.getValue();
                }
            }
            
            for(SelectOption SO:ModuleOptions){
                if(SO.getLabel() == String.Valueof(lstProducts[EditIndex].strModuleName)){
                    lstProducts[EditIndex].strModuleName = SO.getValue();
                }
            }
            
            
            
            InterventionModOptions = new List<SelectOption>();
        	List<Grant_Intervention__c> lstInt2 = [Select Id,Name From Grant_Intervention__c Where Module__c =: lstProducts[EditIndex].strModuleName];

        	InterventionModOptions.add(new SelectOption('','--None--'));
        	if(lstInt2.size() > 0){
            	for(Grant_Intervention__c GInt2 : lstInt2){
                	InterventionModOptions.add(new SelectOption(GInt2.Id,GInt2.Name));
           	    }
            }
            
            for(SelectOption SO:InterventionModOptions){
                if(SO.getLabel() == String.Valueof(lstProducts[EditIndex].strInterventionName)){
                    lstProducts[EditIndex].strInterventionName = SO.getValue();
                }
            }
            
            system.debug('##$#$#$#$'+lstProducts[EditIndex].strCostInputName);
            /*for(SelectOption SO:lstProducts[EditIndex].ProductNameOptions){
                if(SO.getLabel() == String.Valueof(lstProducts[EditIndex].strGenericProductName)){
                    lstProducts[EditIndex].strGenericProductName = SO.getValue();
                }
            }
            for(SelectOption SO:lstProducts[EditIndex].StrengthAndUnitOptions){
                if(SO.getLabel() == String.Valueof(lstProducts[EditIndex].strStrengthAndUnit)){
                    lstProducts[EditIndex].strStrengthAndUnit = SO.getValue();
                }
            }*/
            for(SelectOption SO:ImplementersOptions){
                if(SO.getLabel() == String.Valueof(lstProducts[EditIndex].strImplementer)){
                    lstProducts[EditIndex].strImplementer = SO.getValue();
                }
            }   
         }
    }
    
   Public void fillGenericProduct(){
        Integer ChangeIndexGP = integer.valueof(Apexpages.currentpage().getparameters().get('ChangeIndexGP'));
        String CostInputId = Apexpages.currentpage().getparameters().get('CostInputId');
        
        System.debug ('The cost input in edit block is ' + CostInputId);
        
        lstProducts[ChangeIndexGP].ProductNameOptions = new List<SelectOption>();
        lstProducts[ChangeIndexGP].StrengthAndUnitOptions = new List<SelectOption>();
        lstProducts[ChangeIndexGP].ProductNameOptions.add(new SelectOption('','--None--'));
        lstProducts[ChangeIndexGP].StrengthAndUnitOptions.add(new SelectOption('','--None--'));
        if(ChangeIndexGP != null && String.IsBlank(CostInputId) == false){
            List<Catalog_Generic_Product__c> lstGenericProduct = [Select Id,name From Catalog_Generic_Product__c 
                                        Where Catalog_Cost_Input__c =: CostInputId];
            if(lstGenericProduct.size() > 0){
                for(Catalog_Generic_Product__c objGP : lstGenericProduct){
                    lstProducts[ChangeIndexGP].ProductNameOptions.add(new SelectOption(objGP.Id,objGP.name));
                }
            }    
            
            if(lstProducts[ChangeIndexGP].objProduct.Unit_Cost_Y1__c == null) lstProducts[ChangeIndexGP].objProduct.Unit_Cost_Y1__c = 0;
            if(lstProducts[ChangeIndexGP].objProduct.Unit_Cost_Y2__c == null) lstProducts[ChangeIndexGP].objProduct.Unit_Cost_Y2__c = 0;
            if(lstProducts[ChangeIndexGP].objProduct.Unit_Cost_Y3__c == null) lstProducts[ChangeIndexGP].objProduct.Unit_Cost_Y3__c = 0;
            if(lstProducts[ChangeIndexGP].objProduct.Unit_Cost_Y4__c == null) lstProducts[ChangeIndexGP].objProduct.Unit_Cost_Y4__c = 0;
            
            if(lstProducts[ChangeIndexGP].objProduct.Quantity_Q1__c == null) lstProducts[ChangeIndexGP].objProduct.Quantity_Q1__c = 0;
            if(lstProducts[ChangeIndexGP].objProduct.Quantity_Q2__c == null) lstProducts[ChangeIndexGP].objProduct.Quantity_Q2__c = 0;
            if(lstProducts[ChangeIndexGP].objProduct.Quantity_Q3__c == null) lstProducts[ChangeIndexGP].objProduct.Quantity_Q3__c = 0;
            if(lstProducts[ChangeIndexGP].objProduct.Quantity_Q4__c == null) lstProducts[ChangeIndexGP].objProduct.Quantity_Q4__c = 0;
            if(lstProducts[ChangeIndexGP].objProduct.Quantity_Q5__c == null) lstProducts[ChangeIndexGP].objProduct.Quantity_Q5__c = 0;
            if(lstProducts[ChangeIndexGP].objProduct.Quantity_Q6__c == null) lstProducts[ChangeIndexGP].objProduct.Quantity_Q6__c = 0;
            if(lstProducts[ChangeIndexGP].objProduct.Quantity_Q7__c == null) lstProducts[ChangeIndexGP].objProduct.Quantity_Q7__c = 0;
            if(lstProducts[ChangeIndexGP].objProduct.Quantity_Q8__c == null) lstProducts[ChangeIndexGP].objProduct.Quantity_Q8__c = 0;
            if(lstProducts[ChangeIndexGP].objProduct.Quantity_Q9__c == null) lstProducts[ChangeIndexGP].objProduct.Quantity_Q9__c = 0;
            if(lstProducts[ChangeIndexGP].objProduct.Quantity_Q10__c == null) lstProducts[ChangeIndexGP].objProduct.Quantity_Q10__c = 0;
            if(lstProducts[ChangeIndexGP].objProduct.Quantity_Q11__c == null) lstProducts[ChangeIndexGP].objProduct.Quantity_Q11__c = 0;
            if(lstProducts[ChangeIndexGP].objProduct.Quantity_Q12__c == null) lstProducts[ChangeIndexGP].objProduct.Quantity_Q12__c = 0;
            if(lstProducts[ChangeIndexGP].objProduct.Quantity_Q13__c == null) lstProducts[ChangeIndexGP].objProduct.Quantity_Q13__c = 0;
            if(lstProducts[ChangeIndexGP].objProduct.Quantity_Q14__c == null) lstProducts[ChangeIndexGP].objProduct.Quantity_Q14__c = 0;
            if(lstProducts[ChangeIndexGP].objProduct.Quantity_Q15__c == null) lstProducts[ChangeIndexGP].objProduct.Quantity_Q15__c = 0;
            if(lstProducts[ChangeIndexGP].objProduct.Quantity_Q16__c == null) lstProducts[ChangeIndexGP].objProduct.Quantity_Q16__c = 0;
            
            lstProducts[ChangeIndexGP].TotalQuantityYear1 = lstProducts[ChangeIndexGP].objProduct.Quantity_Q1__c + lstProducts[ChangeIndexGP].objProduct.Quantity_Q2__c + lstProducts[ChangeIndexGP].objProduct.Quantity_Q3__c + lstProducts[ChangeIndexGP].objProduct.Quantity_Q4__c;
            lstProducts[ChangeIndexGP].TotalQuantityYear2 = lstProducts[ChangeIndexGP].objProduct.Quantity_Q5__c + lstProducts[ChangeIndexGP].objProduct.Quantity_Q6__c + lstProducts[ChangeIndexGP].objProduct.Quantity_Q7__c + lstProducts[ChangeIndexGP].objProduct.Quantity_Q8__c;
            lstProducts[ChangeIndexGP].TotalQuantityYear3 = lstProducts[ChangeIndexGP].objProduct.Quantity_Q9__c + lstProducts[ChangeIndexGP].objProduct.Quantity_Q10__c + lstProducts[ChangeIndexGP].objProduct.Quantity_Q11__c + lstProducts[ChangeIndexGP].objProduct.Quantity_Q12__c;
            lstProducts[ChangeIndexGP].TotalQuantityYear4 = lstProducts[ChangeIndexGP].objProduct.Quantity_Q13__c + lstProducts[ChangeIndexGP].objProduct.Quantity_Q14__c + lstProducts[ChangeIndexGP].objProduct.Quantity_Q15__c + lstProducts[ChangeIndexGP].objProduct.Quantity_Q16__c;
            lstProducts[ChangeIndexGP].GrantTotalQuantityYear1 = lstProducts[ChangeIndexGP].TotalQuantityYear1 * lstProducts[ChangeIndexGP].objProduct.Unit_Cost_Y1__c;
            lstProducts[ChangeIndexGP].GrantTotalQuantityYear2 = lstProducts[ChangeIndexGP].TotalQuantityYear2 * lstProducts[ChangeIndexGP].objProduct.Unit_Cost_Y2__c;
            lstProducts[ChangeIndexGP].GrantTotalQuantityYear3 = lstProducts[ChangeIndexGP].TotalQuantityYear3 * lstProducts[ChangeIndexGP].objProduct.Unit_Cost_Y3__c;
            lstProducts[ChangeIndexGP].GrantTotalQuantityYear4 = lstProducts[ChangeIndexGP].TotalQuantityYear1 + lstProducts[ChangeIndexGP].TotalQuantityYear2 + lstProducts[ChangeIndexGP].TotalQuantityYear3 + lstProducts[ChangeIndexGP].TotalQuantityYear4;
                
            
        }
    } 
    
    Public void fillGenericProductNew(){
        
        objNewProduct.ProductNameOptions = new List<SelectOption>();
        objNewProduct.StrengthAndUnitOptions = new List<SelectOption>();
        objNewProduct.ProductNameOptions.add(new SelectOption('','--None--'));
        objNewProduct.StrengthAndUnitOptions.add(new SelectOption('','--None--'));
        
        Cost_Input_ID = objNewProduct.strCostInputName; 
        
        System.debug ('The Cost Input in add product is ' + objNewProduct.strCostInputName);
        
        if(String.IsBlank(objNewProduct.strCostInputName) == false){
            List<Catalog_Generic_Product__c> lstGenericProduct = [Select Id,name,Is_Inactive__c From Catalog_Generic_Product__c 
                                        Where Catalog_Cost_Input__c =: objNewProduct.strCostInputName AND Is_Inactive__c=: False];
            if(lstGenericProduct.size() > 0){
                for(Catalog_Generic_Product__c objGP : lstGenericProduct){
                    objNewProduct.ProductNameOptions.add(new SelectOption(objGP.Id,objGP.name));
                }
            }
        }
    }
    
    Public void fillImplementers(){
        ImplementersOptions = new List<SelectOption>();
        ImplementersOptions.add(new SelectOption('','--None--'));
        List<Implementer__c> lstImplementers = [Select Id,name, Implementer_Name__c From Implementer__c Where Grant_Implementation_Period__c =: strImplementationPeriodId];
        if(lstImplementers.size() > 0){
            for(Implementer__c objImp : lstImplementers){
                ImplementersOptions.add(new SelectOption(objImp.Id,objImp.Implementer_Name__c));
            }
        }
    }
    
    Public void fillInterventions(){
        InterventionsOptions = new List<SelectOption>();
        InterventionsOptions.add(new SelectOption('','--None--'));
        List<Grant_Intervention__c> lstInterventions = [Select Id,name,Module_Intervention_Name__c From Grant_Intervention__c 
                                                        Where Implementation_Period__c =: strImplementationPeriodId Order by Module_Intervention_Name__c];
        if(lstInterventions.size() > 0){
            for(Grant_Intervention__c objImp : lstInterventions){
                InterventionsOptions.add(new SelectOption(objImp.Id,objImp.Module_Intervention_Name__c));
            }
        }
    }
    
    Public void fillStrenthAndUnit(){
        Integer ChangeIndex = integer.valueof(Apexpages.currentpage().getparameters().get('ChangeIndex'));
        String GenericProductId = Apexpages.currentpage().getparameters().get('GenericProductId');
        lstProducts[ChangeIndex].StrengthAndUnitOptions = new List<SelectOption>();
        lstProducts[ChangeIndex].StrengthAndUnitOptions.add(new SelectOption('','--None--'));
        if(ChangeIndex != null && String.IsBlank(GenericProductId) == false){
            List<Catalog_Product__c> lstGenericProduct = [Select Id,Specification__c From Catalog_Product__c 
                                        Where Generic_Product__c =: GenericProductId];
            if(lstGenericProduct.size() > 0){
                for(Catalog_Product__c objGP : lstGenericProduct){
                    lstProducts[ChangeIndex].StrengthAndUnitOptions.add(new SelectOption(objGP.Id,objGP.Specification__c));
                }
            }
            lstProducts[ChangeIndex].strCatalogProductName = lstProducts[ChangeIndex].objProduct.Catalog_Product__r.Name;
            lstProducts[ChangeIndex].strGenericProductName = lstProducts[ChangeIndex].objProduct.Catalog_Product__r.Generic_Product__r.name;
            lstProducts[ChangeIndex].strCostInputName = lstProducts[ChangeIndex].objProduct.Cost_Input__r.Name;
            lstProducts[ChangeIndex].strStrengthAndUnit =lstProducts[ChangeIndex]. objProduct.Catalog_Product__r.Specification__c;
            lstProducts[ChangeIndex].strImplementer = lstProducts[ChangeIndex].objProduct.Implementer__r.Implementer_Name__c;
            lstProducts[ChangeIndex].blnIsEditable = true;
            
            if(lstProducts[ChangeIndex].objProduct.Unit_Cost_Y1__c == null) lstProducts[ChangeIndex].objProduct.Unit_Cost_Y1__c = 0;
            if(lstProducts[ChangeIndex].objProduct.Unit_Cost_Y2__c == null) lstProducts[ChangeIndex].objProduct.Unit_Cost_Y2__c = 0;
            if(lstProducts[ChangeIndex].objProduct.Unit_Cost_Y3__c == null) lstProducts[ChangeIndex].objProduct.Unit_Cost_Y3__c = 0;
            if(lstProducts[ChangeIndex].objProduct.Unit_Cost_Y4__c == null) lstProducts[ChangeIndex].objProduct.Unit_Cost_Y4__c = 0;
            
            if(lstProducts[ChangeIndex].objProduct.Quantity_Q1__c == null) lstProducts[ChangeIndex].objProduct.Quantity_Q1__c = 0;
            if(lstProducts[ChangeIndex].objProduct.Quantity_Q2__c == null) lstProducts[ChangeIndex].objProduct.Quantity_Q2__c = 0;
            if(lstProducts[ChangeIndex].objProduct.Quantity_Q3__c == null) lstProducts[ChangeIndex].objProduct.Quantity_Q3__c = 0;
            if(lstProducts[ChangeIndex].objProduct.Quantity_Q4__c == null) lstProducts[ChangeIndex].objProduct.Quantity_Q4__c = 0;
            if(lstProducts[ChangeIndex].objProduct.Quantity_Q5__c == null) lstProducts[ChangeIndex].objProduct.Quantity_Q5__c = 0;
            if(lstProducts[ChangeIndex].objProduct.Quantity_Q6__c == null) lstProducts[ChangeIndex].objProduct.Quantity_Q6__c = 0;
            if(lstProducts[ChangeIndex].objProduct.Quantity_Q7__c == null) lstProducts[ChangeIndex].objProduct.Quantity_Q7__c = 0;
            if(lstProducts[ChangeIndex].objProduct.Quantity_Q8__c == null) lstProducts[ChangeIndex].objProduct.Quantity_Q8__c = 0;
            if(lstProducts[ChangeIndex].objProduct.Quantity_Q9__c == null) lstProducts[ChangeIndex].objProduct.Quantity_Q9__c = 0;
            if(lstProducts[ChangeIndex].objProduct.Quantity_Q10__c == null) lstProducts[ChangeIndex].objProduct.Quantity_Q10__c = 0;
            if(lstProducts[ChangeIndex].objProduct.Quantity_Q11__c == null) lstProducts[ChangeIndex].objProduct.Quantity_Q11__c = 0;
            if(lstProducts[ChangeIndex].objProduct.Quantity_Q12__c == null) lstProducts[ChangeIndex].objProduct.Quantity_Q12__c = 0;
            if(lstProducts[ChangeIndex].objProduct.Quantity_Q13__c == null) lstProducts[ChangeIndex].objProduct.Quantity_Q13__c = 0;
            if(lstProducts[ChangeIndex].objProduct.Quantity_Q14__c == null) lstProducts[ChangeIndex].objProduct.Quantity_Q14__c = 0;
            if(lstProducts[ChangeIndex].objProduct.Quantity_Q15__c == null) lstProducts[ChangeIndex].objProduct.Quantity_Q15__c = 0;
            if(lstProducts[ChangeIndex].objProduct.Quantity_Q16__c == null) lstProducts[ChangeIndex].objProduct.Quantity_Q16__c = 0;
            
            lstProducts[ChangeIndex].TotalQuantityYear1 = lstProducts[ChangeIndex].objProduct.Quantity_Q1__c + lstProducts[ChangeIndex].objProduct.Quantity_Q2__c + lstProducts[ChangeIndex].objProduct.Quantity_Q3__c + lstProducts[ChangeIndex].objProduct.Quantity_Q4__c;
            lstProducts[ChangeIndex].TotalQuantityYear2 = lstProducts[ChangeIndex].objProduct.Quantity_Q5__c + lstProducts[ChangeIndex].objProduct.Quantity_Q6__c + lstProducts[ChangeIndex].objProduct.Quantity_Q7__c + lstProducts[ChangeIndex].objProduct.Quantity_Q8__c;
            lstProducts[ChangeIndex].TotalQuantityYear3 = lstProducts[ChangeIndex].objProduct.Quantity_Q9__c + lstProducts[ChangeIndex].objProduct.Quantity_Q10__c + lstProducts[ChangeIndex].objProduct.Quantity_Q11__c + lstProducts[ChangeIndex].objProduct.Quantity_Q12__c;
            lstProducts[ChangeIndex].TotalQuantityYear4 = lstProducts[ChangeIndex].objProduct.Quantity_Q13__c + lstProducts[ChangeIndex].objProduct.Quantity_Q14__c + lstProducts[ChangeIndex].objProduct.Quantity_Q15__c + lstProducts[ChangeIndex].objProduct.Quantity_Q16__c;
            lstProducts[ChangeIndex].GrantTotalQuantityYear1 = lstProducts[ChangeIndex].TotalQuantityYear1 * lstProducts[ChangeIndex].objProduct.Unit_Cost_Y1__c;
            lstProducts[ChangeIndex].GrantTotalQuantityYear2 = lstProducts[ChangeIndex].TotalQuantityYear2 * lstProducts[ChangeIndex].objProduct.Unit_Cost_Y2__c;
            lstProducts[ChangeIndex].GrantTotalQuantityYear3 = lstProducts[ChangeIndex].TotalQuantityYear3 * lstProducts[ChangeIndex].objProduct.Unit_Cost_Y3__c;
            lstProducts[ChangeIndex].GrantTotalQuantityYear4 = lstProducts[ChangeIndex].TotalQuantityYear1 +  lstProducts[ChangeIndex].TotalQuantityYear2 + lstProducts[ChangeIndex].TotalQuantityYear3 + lstProducts[ChangeIndex].TotalQuantityYear4;
        }
    }
    
    Public void fillStrenthAndUnitNew(){
        
        objNewProduct.StrengthAndUnitOptions = new List<SelectOption>();
        objNewProduct.StrengthAndUnitOptions.add(new SelectOption('','--None--'));
        if(String.IsBlank(objNewProduct.strGenericProductName) == false){
            List<Catalog_Product__c> lstGenericProduct = [Select Id,Specification__c From Catalog_Product__c 
                                        Where Generic_Product__c =: objNewProduct.strGenericProductName];
            if(lstGenericProduct.size() > 0){
                for(Catalog_Product__c objGP : lstGenericProduct){
                    objNewProduct.StrengthAndUnitOptions.add(new SelectOption(objGP.Id,objGP.Specification__c));
                }
            }
        }
    }
    
    Public void DeleteProduct(){
         Integer DeleteIndex = integer.valueof(Apexpages.currentpage().getparameters().get('DeleteIndex'));
         if(DeleteIndex != null){
             List<Product__c> lstProductToDelete = [Select Id From Product__c Where Id =: lstProducts[DeleteIndex].objProduct.Id];
             if(lstProductToDelete.size() > 0) Delete lstProductToDelete;
             lstProducts.remove(DeleteIndex);
             
             List<Product__c> lstProductToUpdate = [Select Id,Product_Number__c From Product__c Where Product_Number__c >: DeleteIndex 
                                                 And Implementation_Period__c =: strImplementationPeriodId];
             if(lstProductToUpdate.size() > 0){
                 for(Product__c objPro : lstProductToUpdate){
                     objPro.Product_Number__c = objPro.Product_Number__c - 1;
                 }
                 update lstProductToUpdate;
             }
         }
    }
    Public void CancelProduct(){
         Integer CancelIndex = integer.valueof(Apexpages.currentpage().getparameters().get('CancelIndex'));
         if(CancelIndex != null){  
             String proId = lstProducts[CancelIndex].objProduct.id;         
             lstProducts[CancelIndex] = new wrapProducts();
             system.debug('#$#$#$'+mapProIdTowrap);
             lstProducts[CancelIndex] = mapProIdTowrap.get(proId);
             lstProducts[CancelIndex].blnIsEditable = true;
             for(SelectOption SO:lstProducts[CancelIndex].ProductNameOptions){
                if(SO.getValue() == String.Valueof(lstProducts[CancelIndex].strGenericProductName)){
                    lstProducts[CancelIndex].strGenericProductName = SO.getLabel();
                }
            }
            for(SelectOption SO:lstProducts[CancelIndex].StrengthAndUnitOptions){
                if(SO.getValue() == String.Valueof(lstProducts[CancelIndex].strStrengthAndUnit)){
                    lstProducts[CancelIndex].strStrengthAndUnit = SO.getLabel();
                }
            }
         }
    }
    
        
    Public void SaveProduct(){
        Integer SaveIndex = integer.valueof(Apexpages.currentpage().getparameters().get('SaveIndex'));
        String CPId = Apexpages.currentpage().getparameters().get('CPId');
       
                
        String CostInputId1 = Apexpages.currentpage().getparameters().get('CostInputId');
        
        if(SaveIndex != null && SaveIndex > lstProducts.size()){
        
          if(Cost_Input_Id!=null){
                    objNewProduct.objProduct.Cost_Input__c = Cost_Input_Id;
          }
          else{
               objNewProduct.objProduct.Cost_Input__c = CostInputId1;
          }
                
        
            if(String.IsBlank(CPId) == false){
                objNewProduct.objProduct.Catalog_Product__c = CPId;
                //if(!lstCatalogProduct_new.isEmpty())
                
              
                //System.debug ('The new cost input id is ' + lstCatalogProduct_new[0].Catalog_Cost_Input__c); 
            }
            objNewProduct.objProduct.id = null;
            objNewProduct.objProduct.Product_Number__c = SaveIndex;
            objNewProduct.objProduct.Implementer__c = objNewProduct.strImplementer;
            objNewProduct.objProduct.Module__c = objNewProduct.strModuleName;
            objNewProduct.objProduct.Grant_Intervention__c = objNewProduct.strInterventionName;
            if(String.IsBlank(strSelectedCatagory) == false) objNewProduct.objProduct.Product_Main_Category__c = strSelectedCatagory;
            objNewProduct.blnIsEditable = true;            
            insert objNewProduct.objProduct;            
            
            List<Product__c> lstProduct = [Select Catalog_Product__c,Cost_Input__r.Name,Grant_Intervention__c,Grant_Intervention__r.name, Module__c,Module__r.Name,Cost_Input__r.Is_Inactive__c,Catalog_Product__r.Name,Catalog_Product__r.Is_Inactive__c,
                            Catalog_Product__r.Generic_Product__c,Catalog_Product__r.Generic_Product__r.name,
                            Catalog_Product__r.Generic_Product__r.Catalog_Cost_Input__c,Catalog_Product__r.Generic_Product__r.Is_Inactive__c,
                            Catalog_Product__r.Specification__c,Implementer__c,Implementer__r.name,Implementer__r.Implementer_Name__c,
                            Catalog_Product__r.Generic_Product__r.Catalog_Cost_Input__r.Name,Product_Category__c,
                            Quantity_Q1__c,Quantity_Q10__c,Quantity_Q11__c,Quantity_Q12__c,Quantity_Q13__c,
                            Quantity_Q14__c,Quantity_Q15__c,Quantity_Q16__c,Quantity_Q2__c,Quantity_Q3__c,
                            Quantity_Q4__c,Quantity_Q5__c,Quantity_Q6__c,Quantity_Q7__c,Quantity_Q8__c,Quantity_Q9__c,
                            Catalog_Product__r.Product_Name__c,Product_Name__c, Strength_Shape__c,Product_Main_Category__c,
                            Unit_Cost_Y1__c,Unit_Cost_Y2__c,Unit_Cost_Y3__c,Unit_Cost_Y4__c,Cost_Y1__c,
                            (Select Id from PSM_Intervention_Splits__r)                            
                             From Product__c
                            Where Implementation_Period__c =: strImplementationPeriodId 
                            And Id =: objNewProduct.objProduct.Id];
            
            if(lstProduct.size() > 0){
                wrapProducts objWrapProductNew = new wrapProducts();
                objWrapProductNew.objProduct = new Product__c(Implementation_Period__c = strImplementationPeriodId);
                objWrapProductNew.objProduct = lstProduct[0];
                
                //CostY1 = lstProduct[0].Cost_Y1__c;
                
                if(lstProduct[0].Unit_Cost_Y1__c == null) lstProduct[0].Unit_Cost_Y1__c = 0;
                if(lstProduct[0].Unit_Cost_Y2__c == null) lstProduct[0].Unit_Cost_Y2__c = 0;
                if(lstProduct[0].Unit_Cost_Y3__c == null) lstProduct[0].Unit_Cost_Y3__c = 0;
                if(lstProduct[0].Unit_Cost_Y4__c == null) lstProduct[0].Unit_Cost_Y4__c = 0;
                
                if(lstProduct[0].Quantity_Q1__c == null) lstProduct[0].Quantity_Q1__c = 0;
                if(lstProduct[0].Quantity_Q2__c == null) lstProduct[0].Quantity_Q2__c = 0;
                if(lstProduct[0].Quantity_Q3__c == null) lstProduct[0].Quantity_Q3__c = 0;
                if(lstProduct[0].Quantity_Q4__c == null) lstProduct[0].Quantity_Q4__c = 0;
                if(lstProduct[0].Quantity_Q5__c == null) lstProduct[0].Quantity_Q5__c = 0;
                if(lstProduct[0].Quantity_Q6__c == null) lstProduct[0].Quantity_Q6__c = 0;
                if(lstProduct[0].Quantity_Q7__c == null) lstProduct[0].Quantity_Q7__c = 0;
                if(lstProduct[0].Quantity_Q8__c == null) lstProduct[0].Quantity_Q8__c = 0;
                if(lstProduct[0].Quantity_Q9__c == null) lstProduct[0].Quantity_Q9__c = 0;
                if(lstProduct[0].Quantity_Q10__c == null) lstProduct[0].Quantity_Q10__c = 0;
                if(lstProduct[0].Quantity_Q11__c == null) lstProduct[0].Quantity_Q11__c = 0;
                if(lstProduct[0].Quantity_Q12__c == null) lstProduct[0].Quantity_Q12__c = 0;
                if(lstProduct[0].Quantity_Q13__c == null) lstProduct[0].Quantity_Q13__c = 0;
                if(lstProduct[0].Quantity_Q14__c == null) lstProduct[0].Quantity_Q14__c = 0;
                if(lstProduct[0].Quantity_Q15__c == null) lstProduct[0].Quantity_Q15__c = 0;
                if(lstProduct[0].Quantity_Q16__c == null) lstProduct[0].Quantity_Q16__c = 0;
                
                objWrapProductNew.TotalQuantityYear1 = lstProduct[0].Quantity_Q1__c + lstProduct[0].Quantity_Q2__c + lstProduct[0].Quantity_Q3__c + lstProduct[0].Quantity_Q4__c;
                objWrapProductNew.TotalQuantityYear2 = lstProduct[0].Quantity_Q5__c + lstProduct[0].Quantity_Q6__c + lstProduct[0].Quantity_Q7__c + lstProduct[0].Quantity_Q8__c;
                objWrapProductNew.TotalQuantityYear3 = lstProduct[0].Quantity_Q9__c + lstProduct[0].Quantity_Q10__c + lstProduct[0].Quantity_Q11__c + lstProduct[0].Quantity_Q12__c;
                objWrapProductNew.TotalQuantityYear4 = lstProduct[0].Quantity_Q13__c + lstProduct[0].Quantity_Q14__c + lstProduct[0].Quantity_Q15__c + lstProduct[0].Quantity_Q16__c;
                objWrapProductNew.GrantTotalQuantityYear1 = objWrapProductNew.TotalQuantityYear1 * lstProduct[0].Unit_Cost_Y1__c;
                objWrapProductNew.GrantTotalQuantityYear2 = objWrapProductNew.TotalQuantityYear2 * lstProduct[0].Unit_Cost_Y2__c;
                objWrapProductNew.GrantTotalQuantityYear3 = objWrapProductNew.TotalQuantityYear3 * lstProduct[0].Unit_Cost_Y3__c;
                objWrapProductNew.GrantTotalQuantityYear4 = objWrapProductNew.TotalQuantityYear1 + objWrapProductNew.TotalQuantityYear2 + objWrapProductNew.TotalQuantityYear3 + objWrapProductNew.TotalQuantityYear4;
                
                objWrapProductNew.strCatalogProductName = lstProduct[0].Catalog_Product__r.Name;
                objWrapProductNew.strGenericProductName = lstProduct[0].Catalog_Product__r.Generic_Product__r.name;
                objWrapProductNew.strCostInputName = lstProduct[0].Cost_Input__r.Name;
                objWrapProductNew.strModuleName = lstProduct[0].Module__r.name;
                objWrapProductNew.strInterventionName = lstProduct[0].Grant_Intervention__r.name;
                objWrapProductNew.strStrengthAndUnit = lstProduct[0].Catalog_Product__r.Specification__c;
                objWrapProductNew.strImplementer = lstProduct[0].Implementer__r.Implementer_Name__c;
                objWrapProductNew.blnIsEditable = true;
                lstProducts.add(objWrapProductNew);
                
                selectedCatagory();         
            }
        }else if(SaveIndex != null){
        
                 if(Cost_Input_Id!=null)                
                {
                    objNewProduct.objProduct.Cost_Input__c = Cost_Input_Id;
                }
                else
                {
                    objNewProduct.objProduct.Cost_Input__c = CostInputId1;
                }
        
            if(String.IsBlank(CPId) == false){
                lstProducts[SaveIndex].objProduct.Catalog_Product__c = CPId;
                
            }
            
            if(String.IsBlank(ModId) == false)
                lstProducts[SaveIndex].objProduct.Module__c = ModId; 
                
                
            lstProducts[SaveIndex].objProduct.Implementer__c = lstProducts[SaveIndex].strImplementer;
            //lstProducts[SaveIndex].objProduct.Implementer__c = lstProducts[SaveIndex].strImplementer;
            
            for(SelectOption SO:InterventionModOptions){
                if(SO.getValue() == String.Valueof(lstProducts[SaveIndex].strInterventionName)){
                    lstProducts[SaveIndex].strInterventionName = SO.getLabel();
                }
            }
            
            lstProducts[SaveIndex].strInterventionName = lstProducts[SaveIndex].strInterventionName;
            lstProducts[SaveIndex].strModuleName = lstProducts[SaveIndex].strModuleName;
            
            Grant_Intervention__c GIRec = [Select Id,Name From Grant_Intervention__c Where Module__c =: ModId AND Name=: lstProducts[SaveIndex].strInterventionName LIMIT 1];
            
            lstProducts[SaveIndex].objProduct.Grant_Intervention__c = GIRec.id;
            
            if(String.IsBlank(strSelectedCatagory) == false) lstProducts[SaveIndex].objProduct.Product_Main_Category__c = strSelectedCatagory;
            lstProducts[SaveIndex].blnIsEditable = true;
            update lstProducts[SaveIndex].objProduct;
            
            for(SelectOption SO:CostInputOptions){
                if(SO.getValue() == String.Valueof(lstProducts[SaveIndex].strCostInputName)){
                    lstProducts[SaveIndex].strCostInputName = SO.getLabel();
                }
            }
            for(SelectOption SO:ModuleOptions){
                if(SO.getValue() == String.Valueof(lstProducts[SaveIndex].strModuleName)){
                    lstProducts[SaveIndex].strModuleName = SO.getLabel();
                }
            }
            for(SelectOption SO:lstProducts[SaveIndex].ProductNameOptions){
                if(SO.getValue() == String.Valueof(lstProducts[SaveIndex].strGenericProductName)){
                    lstProducts[SaveIndex].strGenericProductName = SO.getLabel();
                }
            }
            for(SelectOption SO:lstProducts[SaveIndex].StrengthAndUnitOptions){
                if(SO.getValue() == String.Valueof(lstProducts[SaveIndex].strStrengthAndUnit)){
                    lstProducts[SaveIndex].strStrengthAndUnit = SO.getLabel();
                }
            }
            for(SelectOption SO:ImplementersOptions){
                if(SO.getValue() == String.Valueof(lstProducts[SaveIndex].strImplementer)){
                    lstProducts[SaveIndex].strImplementer = SO.getLabel();
                }
            }
            
            if(lstProducts[SaveIndex].objProduct.Unit_Cost_Y1__c == null) lstProducts[SaveIndex].objProduct.Unit_Cost_Y1__c = 0;
            if(lstProducts[SaveIndex].objProduct.Unit_Cost_Y2__c == null) lstProducts[SaveIndex].objProduct.Unit_Cost_Y2__c = 0;
            if(lstProducts[SaveIndex].objProduct.Unit_Cost_Y3__c == null) lstProducts[SaveIndex].objProduct.Unit_Cost_Y3__c = 0;
            if(lstProducts[SaveIndex].objProduct.Unit_Cost_Y4__c == null) lstProducts[SaveIndex].objProduct.Unit_Cost_Y4__c = 0;
            
            if(lstProducts[SaveIndex].objProduct.Quantity_Q1__c == null) lstProducts[SaveIndex].objProduct.Quantity_Q1__c = 0;
            if(lstProducts[SaveIndex].objProduct.Quantity_Q2__c == null) lstProducts[SaveIndex].objProduct.Quantity_Q2__c = 0;
            if(lstProducts[SaveIndex].objProduct.Quantity_Q3__c == null) lstProducts[SaveIndex].objProduct.Quantity_Q3__c = 0;
            if(lstProducts[SaveIndex].objProduct.Quantity_Q4__c == null) lstProducts[SaveIndex].objProduct.Quantity_Q4__c = 0;
            if(lstProducts[SaveIndex].objProduct.Quantity_Q5__c == null) lstProducts[SaveIndex].objProduct.Quantity_Q5__c = 0;
            if(lstProducts[SaveIndex].objProduct.Quantity_Q6__c == null) lstProducts[SaveIndex].objProduct.Quantity_Q6__c = 0;
            if(lstProducts[SaveIndex].objProduct.Quantity_Q7__c == null) lstProducts[SaveIndex].objProduct.Quantity_Q7__c = 0;
            if(lstProducts[SaveIndex].objProduct.Quantity_Q8__c == null) lstProducts[SaveIndex].objProduct.Quantity_Q8__c = 0;
            if(lstProducts[SaveIndex].objProduct.Quantity_Q9__c == null) lstProducts[SaveIndex].objProduct.Quantity_Q9__c = 0;
            if(lstProducts[SaveIndex].objProduct.Quantity_Q10__c == null) lstProducts[SaveIndex].objProduct.Quantity_Q10__c = 0;
            if(lstProducts[SaveIndex].objProduct.Quantity_Q11__c == null) lstProducts[SaveIndex].objProduct.Quantity_Q11__c = 0;
            if(lstProducts[SaveIndex].objProduct.Quantity_Q12__c == null) lstProducts[SaveIndex].objProduct.Quantity_Q12__c = 0;
            if(lstProducts[SaveIndex].objProduct.Quantity_Q13__c == null) lstProducts[SaveIndex].objProduct.Quantity_Q13__c = 0;
            if(lstProducts[SaveIndex].objProduct.Quantity_Q14__c == null) lstProducts[SaveIndex].objProduct.Quantity_Q14__c = 0;
            if(lstProducts[SaveIndex].objProduct.Quantity_Q15__c == null) lstProducts[SaveIndex].objProduct.Quantity_Q15__c = 0;
            if(lstProducts[SaveIndex].objProduct.Quantity_Q16__c == null) lstProducts[SaveIndex].objProduct.Quantity_Q16__c = 0;
            
            lstProducts[SaveIndex].TotalQuantityYear1 = lstProducts[SaveIndex].objProduct.Quantity_Q1__c + lstProducts[SaveIndex].objProduct.Quantity_Q2__c + lstProducts[SaveIndex].objProduct.Quantity_Q3__c + lstProducts[SaveIndex].objProduct.Quantity_Q4__c;
            lstProducts[SaveIndex].TotalQuantityYear2 = lstProducts[SaveIndex].objProduct.Quantity_Q5__c + lstProducts[SaveIndex].objProduct.Quantity_Q6__c + lstProducts[SaveIndex].objProduct.Quantity_Q7__c + lstProducts[SaveIndex].objProduct.Quantity_Q8__c;
            lstProducts[SaveIndex].TotalQuantityYear3 = lstProducts[SaveIndex].objProduct.Quantity_Q9__c + lstProducts[SaveIndex].objProduct.Quantity_Q10__c + lstProducts[SaveIndex].objProduct.Quantity_Q11__c + lstProducts[SaveIndex].objProduct.Quantity_Q12__c;
            lstProducts[SaveIndex].TotalQuantityYear4 = lstProducts[SaveIndex].objProduct.Quantity_Q13__c + lstProducts[SaveIndex].objProduct.Quantity_Q14__c + lstProducts[SaveIndex].objProduct.Quantity_Q15__c + lstProducts[SaveIndex].objProduct.Quantity_Q16__c;
            lstProducts[SaveIndex].GrantTotalQuantityYear1 = lstProducts[SaveIndex].TotalQuantityYear1 * lstProducts[SaveIndex].objProduct.Unit_Cost_Y1__c;
            lstProducts[SaveIndex].GrantTotalQuantityYear2 = lstProducts[SaveIndex].TotalQuantityYear2 * lstProducts[SaveIndex].objProduct.Unit_Cost_Y2__c;
            lstProducts[SaveIndex].GrantTotalQuantityYear3 = lstProducts[SaveIndex].TotalQuantityYear3 * lstProducts[SaveIndex].objProduct.Unit_Cost_Y3__c;
            lstProducts[SaveIndex].GrantTotalQuantityYear4 = lstProducts[SaveIndex].TotalQuantityYear1 +lstProducts[SaveIndex].TotalQuantityYear2 + lstProducts[SaveIndex].TotalQuantityYear3 + lstProducts[SaveIndex].TotalQuantityYear4;
        }
    }
    
    Public void EditPSMCost(){
        Integer EditIndex = integer.valueof(Apexpages.currentpage().getparameters().get('EditIndex'));
        if(EditIndex != null){
            lstPSMCosts[EditIndex].blnIsEditable = false;
            PSMCost objPSMCostTemp = new PSMCost();
            objPSMCostTemp.objPSMCost = lstPSMCosts[EditIndex].objPSMCost.clone(true);
            objPSMCostTemp.blnIsEditable = lstPSMCosts[EditIndex].blnIsEditable;
            objPSMCostTemp.strCostInputNamePSMCost = lstPSMCosts[EditIndex].strCostInputNamePSMCost;            
            objPSMCostTemp.strPayee = lstPSMCosts[EditIndex].strPayee;
            objPSMCostTemp.TotalCostY1 = lstPSMCosts[EditIndex].TotalCostY1;
            objPSMCostTemp.TotalCostY2 = lstPSMCosts[EditIndex].TotalCostY2;
            objPSMCostTemp.TotalCostY3 = lstPSMCosts[EditIndex].TotalCostY3;
            objPSMCostTemp.TotalCostY4 = lstPSMCosts[EditIndex].TotalCostY4;
            mapPSMCostIdTowrap.put(objPSMCostTemp.objPSMCost.id,objPSMCostTemp);
            
            for(SelectOption SO:CostInputOptionsPSMCost){
                if(SO.getLabel() == String.Valueof(lstPSMCosts[EditIndex].strCostInputNamePSMCost)){
                    lstPSMCosts[EditIndex].strCostInputNamePSMCost = SO.getValue();
                }
            }
            for(SelectOption SO:ImplementersOptions){
                if(SO.getLabel() == String.Valueof(lstPSMCosts[EditIndex].strPayee)){
                    lstPSMCosts[EditIndex].strPayee = SO.getValue();
                }
            }   
        }
    }
    
    Public void DeletePSMCost(){
        Integer DeleteIndex = integer.valueof(Apexpages.currentpage().getparameters().get('DeleteIndex'));
        if(DeleteIndex != null){
            List<PSM__c> lstPSMCostToDelete = [Select Id From PSM__c Where Id =: lstPSMCosts[DeleteIndex].objPSMCost.Id];
            if(lstPSMCostToDelete.size() > 0) Delete lstPSMCostToDelete;
            lstPSMCosts.remove(DeleteIndex);
        }
    }
    Public void CancelPSMCost(){
        Integer CancelIndex = integer.valueof(Apexpages.currentpage().getparameters().get('CancelIndex'));
        if(CancelIndex != null){  
            String PSMId = lstPSMCosts[CancelIndex].objPSMCost.id;         
            lstPSMCosts[CancelIndex] = new PSMCost();
            lstPSMCosts[CancelIndex] = mapPSMCostIdTowrap.get(PSMId);
            lstPSMCosts[CancelIndex].blnIsEditable = true;
            
        }
    }
    
    
    Public void SavePSMCost(){
        Integer SaveIndex = integer.valueof(Apexpages.currentpage().getparameters().get('SaveIndex'));       
    
        if(SaveIndex != null && SaveIndex > lstPSMCosts.size()){
            objNewPSMCost.objPSMCost.PSM_Cost_Input__c = objNewPSMCost.strCostInputNamePSMCost;
            objNewPSMCost.objPSMCost.Implementer__c = objNewPSMCost.strPayee;
            objNewPSMCost.blnIsEditable = true;            
            insert objNewPSMCost.objPSMCost;
            
            List<PSM__c> lstPSMCostTemp = [Select Implementer__c,Module__c,PSM_Cost_Input__c,PSM_Cost_Input__r.name,
                                    Q10_Cost__c,Q11_Cost__c,Implementer__r.Name,Implementer__r.Implementer_Name__c,
                                    Q12_Cost__c,Q13_Cost__c,Q14_Cost__c,Q15_Cost__c,Q16_Cost__c,Q1_Cost__c,Q2_Cost__c,
                                    Q3_Cost__c,Q4_Cost__c,Q5_Cost__c,Q6_Cost__c,Q7_Cost__c,Q8_Cost__c,Q9_Cost__c,
                                    Y1_Total__c,Y2_Total__c,Y3_Total__c,Y4_Total__c From PSM__c 
                                    Where Id =: objNewPSMCost.objPSMCost.Id] ;
        
            if(lstPSMCostTemp.size() > 0){
                PSMCost objWrapPSMCostNew = new PSMCost();
                objWrapPSMCostNew.objPSMCost = new PSM__c();
                objWrapPSMCostNew.objPSMCost = lstPSMCostTemp[0];
                
                objWrapPSMCostNew.strCostInputNamePSMCost = lstPSMCostTemp[0].PSM_Cost_Input__r.Name;
                objWrapPSMCostNew.strPayee = lstPSMCostTemp[0].Implementer__r.Implementer_Name__c;
                objWrapPSMCostNew.blnIsEditable = true;
                objWrapPSMCostNew.TotalCostY1 = lstPSMCostTemp[0].Y1_Total__c;
                objWrapPSMCostNew.TotalCostY2 = lstPSMCostTemp[0].Y2_Total__c;
                objWrapPSMCostNew.TotalCostY3 = lstPSMCostTemp[0].Y3_Total__c;
                objWrapPSMCostNew.TotalCostY4 = lstPSMCostTemp[0].Y4_Total__c;
                objWrapPSMCostNew.GrantTotalCost = lstPSMCostTemp[0].Y1_Total__c + lstPSMCostTemp[0].Y2_Total__c + lstPSMCostTemp[0].Y3_Total__c + lstPSMCostTemp[0].Y4_Total__c;
                    
                lstPSMCosts.add(objWrapPSMCostNew);         
            }
        }else if(SaveIndex != null){
            lstPSMCosts[SaveIndex].objPSMCost.PSM_Cost_Input__c = lstPSMCosts[SaveIndex].strCostInputNamePSMCost;
            lstPSMCosts[SaveIndex].objPSMCost.Implementer__c = lstPSMCosts[SaveIndex].strPayee;
            lstPSMCosts[SaveIndex].blnIsEditable = true;
            
            update lstPSMCosts[SaveIndex].objPSMCost;
            
            if(lstPSMCosts[SaveIndex].objPSMCost.Q1_Cost__c == null) lstPSMCosts[SaveIndex].objPSMCost.Q1_Cost__c = 0;
            if(lstPSMCosts[SaveIndex].objPSMCost.Q2_Cost__c == null) lstPSMCosts[SaveIndex].objPSMCost.Q2_Cost__c = 0;
            if(lstPSMCosts[SaveIndex].objPSMCost.Q3_Cost__c == null) lstPSMCosts[SaveIndex].objPSMCost.Q3_Cost__c = 0;
            if(lstPSMCosts[SaveIndex].objPSMCost.Q4_Cost__c == null) lstPSMCosts[SaveIndex].objPSMCost.Q4_Cost__c = 0;
            if(lstPSMCosts[SaveIndex].objPSMCost.Q5_Cost__c == null) lstPSMCosts[SaveIndex].objPSMCost.Q5_Cost__c = 0;
            if(lstPSMCosts[SaveIndex].objPSMCost.Q6_Cost__c == null) lstPSMCosts[SaveIndex].objPSMCost.Q6_Cost__c = 0;
            if(lstPSMCosts[SaveIndex].objPSMCost.Q7_Cost__c == null) lstPSMCosts[SaveIndex].objPSMCost.Q7_Cost__c = 0;
            if(lstPSMCosts[SaveIndex].objPSMCost.Q8_Cost__c == null) lstPSMCosts[SaveIndex].objPSMCost.Q8_Cost__c = 0;
            if(lstPSMCosts[SaveIndex].objPSMCost.Q9_Cost__c == null) lstPSMCosts[SaveIndex].objPSMCost.Q9_Cost__c = 0;
            if(lstPSMCosts[SaveIndex].objPSMCost.Q10_Cost__c == null) lstPSMCosts[SaveIndex].objPSMCost.Q10_Cost__c = 0;
            if(lstPSMCosts[SaveIndex].objPSMCost.Q11_Cost__c == null) lstPSMCosts[SaveIndex].objPSMCost.Q11_Cost__c = 0;
            if(lstPSMCosts[SaveIndex].objPSMCost.Q12_Cost__c == null) lstPSMCosts[SaveIndex].objPSMCost.Q12_Cost__c = 0;
            if(lstPSMCosts[SaveIndex].objPSMCost.Q13_Cost__c == null) lstPSMCosts[SaveIndex].objPSMCost.Q13_Cost__c = 0;
            if(lstPSMCosts[SaveIndex].objPSMCost.Q14_Cost__c == null) lstPSMCosts[SaveIndex].objPSMCost.Q14_Cost__c = 0;
            if(lstPSMCosts[SaveIndex].objPSMCost.Q15_Cost__c == null) lstPSMCosts[SaveIndex].objPSMCost.Q15_Cost__c = 0;
            if(lstPSMCosts[SaveIndex].objPSMCost.Q16_Cost__c == null) lstPSMCosts[SaveIndex].objPSMCost.Q16_Cost__c = 0;
            
            lstPSMCosts[SaveIndex].TotalCostY1 = lstPSMCosts[SaveIndex].objPSMCost.Q1_Cost__c + lstPSMCosts[SaveIndex].objPSMCost.Q2_Cost__c + lstPSMCosts[SaveIndex].objPSMCost.Q3_Cost__c + lstPSMCosts[SaveIndex].objPSMCost.Q4_Cost__c;
            lstPSMCosts[SaveIndex].TotalCostY2 = lstPSMCosts[SaveIndex].objPSMCost.Q5_Cost__c + lstPSMCosts[SaveIndex].objPSMCost.Q6_Cost__c + lstPSMCosts[SaveIndex].objPSMCost.Q7_Cost__c + lstPSMCosts[SaveIndex].objPSMCost.Q8_Cost__c;
            lstPSMCosts[SaveIndex].TotalCostY3 = lstPSMCosts[SaveIndex].objPSMCost.Q9_Cost__c + lstPSMCosts[SaveIndex].objPSMCost.Q10_Cost__c + lstPSMCosts[SaveIndex].objPSMCost.Q11_Cost__c + lstPSMCosts[SaveIndex].objPSMCost.Q12_Cost__c;
            lstPSMCosts[SaveIndex].TotalCostY4 = lstPSMCosts[SaveIndex].objPSMCost.Q13_Cost__c + lstPSMCosts[SaveIndex].objPSMCost.Q14_Cost__c + lstPSMCosts[SaveIndex].objPSMCost.Q15_Cost__c + lstPSMCosts[SaveIndex].objPSMCost.Q16_Cost__c;
            lstPSMCosts[SaveIndex].GrantTotalCost = lstPSMCosts[SaveIndex].TotalCostY1 + lstPSMCosts[SaveIndex].TotalCostY2 + lstPSMCosts[SaveIndex].TotalCostY3 +lstPSMCosts[SaveIndex].TotalCostY4;
            for(SelectOption SO:CostInputOptionsPSMCost){
                if(SO.getValue() == String.Valueof(lstPSMCosts[SaveIndex].strCostInputNamePSMCost)){
                    lstPSMCosts[SaveIndex].strCostInputNamePSMCost = SO.getLabel();
                }
            }
            for(SelectOption SO:ImplementersOptions){
                if(SO.getValue() == String.Valueof(lstPSMCosts[SaveIndex].strPayee)){
                    lstPSMCosts[SaveIndex].strPayee = SO.getLabel();
                }
            }
        }
    }
    
    Public void OpenInterventionSplitPopup(){
        Integer OpenIndex = integer.valueof(Apexpages.currentpage().getparameters().get('OpenIndex'));
        if(OpenIndex != null){
            intIndex = OpenIndex;
            lstProducts[OpenIndex].lstPSMSplit = new List<PSMSplit>();
            lstProducts[OpenIndex].blnHasChild = true;
            List<PSM_Intervention_Split__c> lstPSMIntSplit = [Select Intervention__c,Product__c,Y1__c,Y2__c,Y3__c,Y4__c 
                                                              From PSM_Intervention_Split__c
                                                             Where Product__c =: lstProducts[OpenIndex].objProduct.Id];
                                                             
            for(PSM_Intervention_Split__c objPSM : lstPSMIntSplit){
                PSMSplit objWrapPSM = new PSMSplit();
                objWrapPSM.objPSMSplit = new PSM_Intervention_Split__c();
                objWrapPSM.objPSMSplit = objPSM;
                objWrapPSM.PSMSplitIntervention = objPSM.Intervention__c;
                
                if(objPSM.Y1__c == null) objPSM.Y1__c = 0;
                if(objPSM.Y2__c == null) objPSM.Y2__c = 0;
                if(objPSM.Y3__c == null) objPSM.Y3__c = 0;
                if(objPSM.Y4__c == null) objPSM.Y4__c = 0;
                
                if(lstProducts[OpenIndex].TotalY1 == null) lstProducts[OpenIndex].TotalY1 = objPSM.Y1__c;
                else lstProducts[OpenIndex].TotalY1 += objPSM.Y1__c;
                if(lstProducts[OpenIndex].TotalY2 == null) lstProducts[OpenIndex].TotalY2 = objPSM.Y2__c;
                else lstProducts[OpenIndex].TotalY2 += objPSM.Y2__c;
                if(lstProducts[OpenIndex].TotalY3 == null) lstProducts[OpenIndex].TotalY3 = objPSM.Y3__c;
                else lstProducts[OpenIndex].TotalY3 += objPSM.Y3__c;
                if(lstProducts[OpenIndex].TotalY4 == null) lstProducts[OpenIndex].TotalY4 = objPSM.Y4__c;
                else lstProducts[OpenIndex].TotalY4 += objPSM.Y4__c;
                
                lstProducts[OpenIndex].lstPSMSplit.add(objWrapPSM);
            }
        }
    }
    
    Public void CancelInterventionSplitPopup(){
        if(intindex != null){
            lstProducts[intindex].blnHasChild = false;
        }
    }
    
    Public void AddPSMSplit(){
        if(intindex != null){
            PSMSplit objwrapPSMSplit = new PSMSplit();
            objwrapPSMSplit.objPSMSplit = new PSM_Intervention_Split__c(Product__c = lstProducts[intindex].objProduct.Id);
            lstProducts[intindex].lstPSMSplit.add(objwrapPSMSplit);
        }
    }
    
    Public void DeletePSMSplit(){
        Integer DeleteIndex = integer.valueof(Apexpages.currentpage().getparameters().get('DeleteIndex'));
        if(intIndex != null && DeleteIndex != null){
            if(String.isblank(lstProducts[intindex].lstPSMSplit[DeleteIndex].objPSMSplit.Id)){
                lstProducts[intindex].lstPSMSplit.remove(DeleteIndex);
            }else{
                String PSMSplitId = lstProducts[intindex].lstPSMSplit[DeleteIndex].objPSMSplit.Id;
                List<PSM_Intervention_Split__c> lstPSMSplitToDelete = new List<PSM_Intervention_Split__c>();
                lstPSMSplitToDelete = [Select Id From PSM_Intervention_Split__c Where Id =: PSMSplitId];
                if(lstPSMSplitToDelete.size() > 0) Delete lstPSMSplitToDelete;
                lstProducts[intindex].lstPSMSplit.remove(DeleteIndex);
            }
            if(lstProducts[intindex].lstPSMSplit.size()==0){
                lstProducts[intindex].TotalY1=0;
                lstProducts[intindex].TotalY2=0;
                lstProducts[intindex].TotalY3=0;
                lstProducts[intindex].TotalY4=0;
            }
        }
    }
    
    Public Void SavePSMSplit(){
        if(intIndex != null && lstProducts[intindex].lstPSMSplit.size() > 0){
            List<PSM_Intervention_Split__c> lstPSMSplitToUpsert = new List<PSM_Intervention_Split__c>();
            for(PSMSplit objWrap : lstProducts[intindex].lstPSMSplit){
                if(objWrap.objPSMSplit.Intervention__c != null){
                    lstPSMSplitToUpsert.add(objWrap.objPSMSplit);
                }
            }
            if(lstPSMSplitToUpsert.size() > 0) upsert lstPSMSplitToUpsert;
            lstProducts[intindex].blnHasChild = false;
            selectedCatagory();
            //return null;
            
        }
        
        //return null;
    }
    
    /* Methods for DIALOGE BOX */
    Public Boolean blnHasNoChild {get;set;}
    
    Public void OpenDialogeBoxRecord(){
        Integer OpenBLIndex = integer.valueof(Apexpages.currentpage().getparameters().get('OpenBLIndex'));
        if(OpenBLIndex != null){
            lstProducts[OpenBLIndex].blnHasNoChild = true;
        }
    }
    
    Public void SaveDialogeBox(){
        Integer SaveBLIndex = integer.valueof(Apexpages.currentpage().getparameters().get('SaveBLIndex'));
        if(SaveBLIndex != null){
           update lstProducts[SaveBLIndex].objProduct;
           lstProducts[SaveBLIndex].blnHasNoChild = false;
        }
    }
    
    Public void CancelDialogeBox(){
        Integer CancelBLIndex = integer.valueof(Apexpages.currentpage().getparameters().get('CancelBLIndex'));
        if(CancelBLIndex != null){           
           lstProducts[CancelBLIndex].blnHasNoChild = false;
        }
    }    
    
    /* Functionality for Dialoge Box Completed  */
  
    //TCS 22/08/2014: Added below code for Profile Access
    public void checkProfile(){
         Id profileId=userinfo.getProfileId();
         String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
     
      List<Profile_Access_Setting__c> checkpage = [Select Salesforce_Item__c from Profile_Access_Setting__c where Page_Name__c ='HealthProducts' and Profile_Name__c =: profilename];
      system.debug(checkpage);
      for (Profile_Access_Setting__c check : checkpage){
        if (check.Salesforce_Item__c == 'External Profile') blnExternalPro = true;
        if(check.Salesforce_Item__c == 'Edit')blnEdit = true;
        if(check.Salesforce_Item__c == 'Delete')blnDelete = true;
        if(check.Salesforce_Item__c == 'Save')blnSave = true;
        if(check.Salesforce_Item__c == 'TGF Comments')blnTGFComment = true;
        if(check.Salesforce_Item__c == 'LFA Comments')blnLFAComment = true;
        if(check.Salesforce_Item__c == 'PR Comments')blnPRCommment = true;
        if(check.Salesforce_Item__c == 'Intervention Split')blnIntSplit = true;
        if(check.Salesforce_Item__c == 'Refresh Detail Budget With PSM Cost')blnRefersh = true;
        }
    }
    
    Public Class wrapProducts{
        Public Product__c objProduct {get;set;}
        Public Boolean blnIsEditable {get;set;}
        Public String strCatalogProductName {get;set;}
        Public String strGenericProductName {get;set;}
        Public String strCostInputName {get;set;}
        Public String strModuleName {get;set;}
        Public String strInterventionName {get;set;}
        Public String strStrengthAndUnit {get;set;}
        Public String strImplementer {get;set;}
        Public List<PSM_Intervention_Split__c> lstPSMSplits {get;set;}
        
        Public Boolean blnHasNoChild {get;set;}
        Public Boolean blnHasChild {get;set;}
        Public List<PSMSplit> lstPSMSplit {get;set;}
        
        Public List<SelectOption> ProductNameOptions {get;set;}
        Public List<SelectOption> StrengthAndUnitOptions {get;set;}
        //Public List<SelectOption> InterventionModOptions {get;set;}
        
        Public Decimal GrantTotalQuantityYear1 {get;set;} 
        Public Decimal GrantTotalQuantityYear2 {get;set;}
        Public Decimal GrantTotalQuantityYear3 {get;set;}
        Public Decimal GrantTotalQuantityYear4 {get;set;}       
        Public Decimal TotalQuantityYear1 {get;set;}
        Public Decimal TotalQuantityYear2 {get;set;}
        Public Decimal TotalQuantityYear3 {get;set;}
        Public Decimal TotalQuantityYear4 {get;set;}
        
        Public Decimal TotalY1 {get;set;}
        Public Decimal TotalY2 {get;set;}
        Public Decimal TotalY3 {get;set;}
        Public Decimal TotalY4 {get;set;}
    }
    Public Class PSMSplit{
        Public PSM_Intervention_Split__c objPSMSplit {get;set;}
        Public String PSMSplitIntervention {get;set;}
    }
    
    Public Decimal GrantTotalCost {get;set;} 
    Public Class PSMCost{
        Public Boolean blnIsEditable {get;set;}
        Public PSM__c objPSMCost {get;set;}
        Public Decimal TotalCostY1 {get;set;}
        Public Decimal TotalCostY2 {get;set;}
        Public Decimal TotalCostY3 {get;set;}
        Public Decimal TotalCostY4 {get;set;}
        Public Decimal GrantTotalCost {get;set;} 
        Public String strCostInputNamePSMCost {get;set;}
        Public String strPayee {get;set;}
    }
}