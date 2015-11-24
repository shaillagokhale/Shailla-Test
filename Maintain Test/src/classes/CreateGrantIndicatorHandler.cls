/*
Class Name : CreateGrantIndicatorHandler
Description : Handler For the CreateGrantIndicator Trigger.
Create Date : 02-11-2014
*/
public class CreateGrantIndicatorHandler {
    public static void createGrantIndicator(List<Module__c> lstModuleAdded) {
        if(lstModuleAdded != null && lstModuleAdded.size() > 0 ) {
            Map<Id,Set<Id>> mapModuleCatalog = new Map<Id,Set<Id>>();
            Set<Id> setModuleCatalogId = new Set<Id>();
            //get the all module for adding the grant indicator
            for(Module__c objModule : lstModuleAdded) {
                //check if implementation and catalog module is not null
                if(objModule.Implementation_Period__c != null && objModule.Catalog_Module__c != null) {
                    setModuleCatalogId.add(objModule.Catalog_Module__c);
                    if(mapModuleCatalog.containsKey(objModule.Catalog_Module__c)){
                        mapModuleCatalog.get(objModule.Catalog_Module__c).add(objModule.Id);
                    }else{
                        mapModuleCatalog.put(objModule.Catalog_Module__c,new Set<Id>{objModule.Id});
                    }
                    
                }
            }
           // System.debug('!!!!!!!!setModuleCatalogId '+ setModuleCatalogId + 'mapModuleCatalog '+mapModuleCatalog );
            
            if(setModuleCatalogId.size() > 0 && mapModuleCatalog != null) {
                //get all the catalog indicators for the reference to create grant indicator.
                List<Indicator__c> lstCatalogIndicator = new List<Indicator__c>([Select Id,Type_of_Data__c,Full_Name_En__c,Target_Accumulation__c,Catalog_Module__c,Indicator_Type__C From Indicator__c 
                                                            where Catalog_Module__c in: setModuleCatalogId and Indicator_Type__C = 'Coverage/Output']);
                //System.debug('@@@@@@@lstCatalogIndicator   = '+lstCatalogIndicator );
                if(lstCatalogIndicator != null && lstCatalogIndicator.size() > 0 ){
                    //create new grant indicators.
                    List<Grant_Indicator__c> lstGrantIndicatorsToAdd = new List<Grant_Indicator__c>();
                    Grant_Indicator__c objGrantIndicator;
                    for(Indicator__c objCatalogIndicator : lstCatalogIndicator) {
                        //create new grant indicator set some reference fields
                        if(mapModuleCatalog.ContainsKey(objCatalogIndicator.Catalog_Module__c) &&
                            mapModuleCatalog.get(objCatalogIndicator.Catalog_Module__c).size() > 0){
                            for(Id ModuleID : mapModuleCatalog.get(objCatalogIndicator.Catalog_Module__c)){
                                objGrantIndicator = new Grant_Indicator__c();
                                objGrantIndicator.Parent_Module__c = ModuleID;
                                objGrantIndicator.Indicator__c = objCatalogIndicator.ID;
                                objGrantIndicator.Indicator_Type__c = 'Coverage/Output';
                                objGrantIndicator.Target_Accumulation__c = objCatalogIndicator.Target_Accumulation__c;
                                objGrantIndicator.Data_Type__c = objCatalogIndicator.Type_of_Data__c;
                                objGrantIndicator.Indicator_Full_Name__c = objCatalogIndicator.Full_Name_En__c;
                                /*objGrantIndicator.Russian_Name__c = objCatalogIndicator.Russian_Name__c;
                                objGrantIndicator.French_Name__c = objCatalogIndicator.French_Name__c;
                                objGrantIndicator.Spanish_Name__c = objCatalogIndicator.Spanish_Name__c;*/
                                //adding to list for insert
                                lstGrantIndicatorsToAdd.add(objGrantIndicator);
                            }                
                        }
                    }
                    //insert  grant indicator
                    if(lstGrantIndicatorsToAdd.size() > 0) insert lstGrantIndicatorsToAdd;
                }
            }
        }
    }
}