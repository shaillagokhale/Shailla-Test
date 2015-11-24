Public with sharing Class temp_extProgrammaticGap1{
    
    ID ConceptNoteId;
    Public Concept_Note__c objConceptNote{get;set;}
    Public Module__c objModule{get;set;}
    Public List<wrapperClsModulePG> lstWrapCls{get;set;}
    Public List<Indicator__c> lstCatIndicators{get;set;}
    Public List<SelectOption> IndicatorOptions{get;set;}
    Public String strCatModuleId {get;set;}
    Public String strModuleId;
    
    Public temp_extProgrammaticGap1(ApexPages.StandardController controller){
       if(System.currentPagereference().getParameters().get('id')!=null)
       {
            List<Module__c> lstModule=[SELECT ID, Concept_Note__r.ID,Catalog_Module__c FROM Module__c WHERE id=:System.currentPagereference().getParameters().get('id')];
            strModuleId = System.currentPagereference().getParameters().get('id');
            if(lstModule!=null && lstModule.size()>0)                        
            {
                objModule = lstModule[0];
                ConceptNoteId = objModule.Concept_Note__c;
                strCatModuleId = objModule.Catalog_Module__c;
                
                if(ConceptNoteId!=null)
                objConceptNote = [SELECT Component__c,Name, Modules__c,CCM_New__c,Start_Date__c FROM Concept_Note__c WHERE id =: ConceptNoteId];
                

                FillModules();
                FillIndicators();
                
            }
        }
    }
     
    Public Void FillModules(){
        //List<Schema.PicklistEntry> lstSpecification = Programmatic_Gap__c.Specification__c.getDescribe().getPicklistValues();
        
        //List<Programmatic_Gap__c> lstExistingProgGap = [Select Id, Name, Assumptions__c,Concept_Note__c,Coverage_Comments__c,Type__c, 
        
        Map<Decimal,String> MapType = new Map<Decimal,String>();//Programmatic_Gap__c.Specification__c.getDescribe().getPicklistValues();
        MapType.put(1,'A. Total estimated population in need/ at risk');
        MapType.put(2,'B. Country targets');
        MapType.put(3,'C. Country need planned to be covered by domestic & other sources');
        MapType.put(4,'D. Country need already covered by other existing Global Fund grants');
        MapType.put(5,'E. Expected annual gap in meeting the need');
        MapType.put(6,'F. Targets to be financed by indicative funding request');
        MapType.put(7,'G. Coverage from indicative, existing Global Fund and other resources');
        MapType.put(8,'H. Targets to be financed by above indicative funding request');
        MapType.put(9,'I. Total coverage (indicative+ above indicative+ existing GF grants+ other resources)');
        
        
        
        /*Map<Decimal,String> MapSpecification = new Map<Decimal,String>();//Programmatic_Gap__c.Specification__c.getDescribe().getPicklistValues();
        MapSpecification .put(1,'Country Target');
        MapSpecification .put(2,'Non-GF Programs');
        MapSpecification .put(3,'Existing GF Grants');
        MapSpecification .put(4,'Indicative Request');
        MapSpecification .put(5,'Above Indicative Request'); */
        
        lstWrapCls = new List<wrapperClsModulePG>();
        List<Programmatic_Gap__c> lstSavedProgrammatic = [SELECT Id, Name,Group_Sequence__c ,Metric__c ,Current_Coverage__c,Current_Coverage_per__c,LFA_Comments__c,Coverage_Comments__c,Module__c,Global_Fund_Comments__c,
                                                         Year_1__c ,Year_2__c ,CCM_Comments__c ,Year_3__c,Year_4__c, Specification__c,Assumptions__c,Program_Area__c,Type__c,Year_1_per__c,Year_2_per__c,Year_3_per__c,Year_4_per__c
                                                         FROM Programmatic_Gap__c where Concept_Note__c =: ConceptNoteId order by Group_Sequence__c,Sequence__c asc];
                                                         
        Map<Decimal,List<Programmatic_Gap__c>> mapModulePG = new Map<Decimal,List<Programmatic_Gap__c>>();
        
        for(decimal moduleNum=0;moduleNum<9;moduleNum++){
            mapModulePG.put(moduleNum,new List<Programmatic_Gap__c>());
        }                                         
                   
        for(Programmatic_Gap__c objPG:lstSavedProgrammatic){
            If(mapModulePG.ContainsKey(objPG.Group_Sequence__c)){
                mapModulePG.get(objPG.Group_Sequence__c).Add(objPG);
            }Else{
                List<Programmatic_Gap__c> lstPG = new List<Programmatic_Gap__c>();
                lstPG.Add(objPG);
                mapModulePG.put(objPG.Group_Sequence__c,lstPG);
            }
        }
        Integer i=0;
        //for(decimal index:mapModulePG.keyset()){ 
        
        List<Grant_Indicator__c> lstCatIndicators_new = [Select Id,Name,Indicator_Full_Name__c FROM Grant_Indicator__c where Parent_Module__c =:strModuleId and Available_For_PG__C = true];
        if(!lstCatIndicators_new.isEmpty())
        {
        for(integer index=0;index<lstCatIndicators_new.size();index++){ 
            wrapperClsModulePG objWrpCls = new wrapperClsModulePG();
            List<Programmatic_Gap__c> lstPG1 = new List<Programmatic_Gap__c>();
            if(mapModulePG.get(index) != null && mapModulePG.get(index).size() > 0){
                lstPG1 = mapModulePG.get(index);
            }
            else{
                for(Decimal TypeIndex=1;TypeIndex<=9;TypeIndex++){
                    Programmatic_Gap__c objPG = new Programmatic_Gap__c();
                    objPG.Type__c = MapType.get(TypeIndex);
                    objPG.Sequence__c =TypeIndex;
                    if(objConceptNote!=null)
                    objPG.Concept_Note__c = objConceptNote.Id;
                    objPG.Indicator__c = lstCatIndicators_new[index].id;
                     System.debug ('The Indicator is ' +lstCatIndicators_new[index].id);
                    
                    lstPG1.Add(objPG);
                }
            }
            objWrpCls.Name = lstPG1[0].Program_Area__c;
            objWrpCls.CoverageComments = lstPG1[0].Coverage_Comments__c;
            objWrpCls.KeyMetric = lstPG1[0].Metric__c;
            objWrpCls.GroupSequence = index;
            objWrpCls.IndicatorName = lstCatIndicators_new[index].Indicator_Full_Name__c;
            
            
            objWrpCls.lstPG = lstPG1;
            
            if(i==0){
                objWrpCls.isShow=true;
                i++;
            }
            lstWrapCls.Add(objWrpCls);
        }
        
      }
        
    }
    Public Void FillIndicators(){   
        IndicatorOptions = new List<SelectOption>();
        List<Indicator__c> lstCatIndicators = [Select Id,Name,Full_Name_En__c FROM Indicator__c where Catalog_Module__c =: strCatModuleId and Available_For_PG__C = true];
        IndicatorOptions.add(new SelectOption('','--None--'));
        if(lstCatIndicators.size() > 0){
            for(Indicator__c objInd : lstCatIndicators){
                IndicatorOptions.add(new SelectOption(objInd.Id,objInd.Full_Name_en__c));
            }
        }
    }
     
    Public void quickSavePG(){
        List<Programmatic_Gap__c> finalPG = new List<Programmatic_Gap__c>();
        
        If(lstWrapCls != null && lstWrapCls.size() > 0){
            for(wrapperClsModulePG objWrpCls:lstWrapCls){
                If(objWrpCls.lstPG != null){
                    for(Programmatic_Gap__c objPG:objWrpCls.lstPG){
                        //objPG.Current_Coverage__c = objWrpCls.lstPG[0].Current_Coverage__c;
                        //objPG.Current_Coverage_per__c = objWrpCls.lstPG[0].Current_Coverage_per__c;
                        objPG.Metric__c = objWrpCls.KeyMetric;
                        objPG.Program_Area__c = objWrpCls.Name;
                        objPG.Coverage_Comments__c = objWrpCls.CoverageComments;
                        objPG.Group_Sequence__c = objWrpCls.GroupSequence;                        
                        finalPG.Add(objPG);
                    }
                }
            }
        }
        
        If(finalPG.size() > 0) UPSERT finalPG;
        Update objModule;
    }
    
    Public PageReference savePG(){
        quickSavePG();
        if(objModule !=null)
        {    
            Update objModule ;        
        }        
        PageReference Pr = New PageReference('/apex/ConceptNoteOverview?Id='+ConceptNoteID);
        return Pr;
    }
    
    Public PageReference cancelPG(){
         
        PageReference Pr = New PageReference('/apex/ConceptNoteOverview?Id='+ConceptNoteID);
        return Pr;
    }
     
    Public class wrapperClsModulePG{
         
        //Public Module__c objModule{get;se   t;}
        
       
        Public String IndicatorName {get;set;}
        Public decimal GroupSequence{get;set;}
        Public String Name{get;set;}
        Public String KeyMetric{get;set;}
        Public String CoverageComments{get;set;}
        Public List<Programmatic_Gap__c> lstPG{get;set;}
        public Boolean isShow{get;set;}
        public wrapperClsModulePG(){}
        }
   }