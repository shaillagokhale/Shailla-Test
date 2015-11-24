public class DisagreegationTableController1 {
 
    public String recordId                                            {get; set;}
    public String objectName                                          {get; set;}
    public Boolean isEditable                                         {get; set;}
    public String componentName                                       {get; set;}
    public List<DisagreegationTableWrapper> disAggreegationWraprList  {get; set;}
    public static List<Grant_Disaggregated__c> GrantDisaggregatedList;
    
    public List<DisagreegationTableWrapper> getaggreegationWrapperList() {
        List<DisagreegationTableWrapper> aggreegationWrapperList = new List<DisagreegationTableWrapper>();
        
        return aggreegationWrapperList;
    }
    
    public List<Grant_Disaggregated__c> getGrantDisaggregatedList() {
		system.debug('>>>>>>>>>>>>>>>>'+isEditable);
        //recordId = 'a02g00000077vXP';
        List<Catalog_Disaggregated__c> cdList;
        List<Grant_Disaggregated__c> gdList;
        Grant_Disaggregated__c grntDisaggregated;
        List<Grant_Disaggregated__c> insertGDList = new List<Grant_Disaggregated__c>();
        gdList = [SELECT Catalog_Disaggregated__c, Component__c, Disaggregated_Baseline_Sources__c, Disaggregated_Baseline_Year__c,
                  Disaggregated_Baseline_Value__c, Catalog_Disaggregated__r.Disaggregation_Category__c, Catalog_Disaggregated__r.Disaggregation_Value__c,
                  Catalog_Disaggregated__r.Catalog_Indicator__c 
                  FROM Grant_Disaggregated__c
                  WHERE Grant_Indicator__c =: recordId
        		  ORDER BY Catalog_Disaggregated__r.Disaggregation_Category__c];        
	    if(gdList == null || gdList.isEmpty()) {
	    	cdList = [SELECT Id, Disaggregation_Category__c, Disaggregation_Value__c, Catalog_Indicator__c
                      FROM Catalog_Disaggregated__c
                 	  WHERE Catalog_Indicator__c in (SELECT Indicator__c
                                                     FROM Grant_Indicator__c
                                                     WHERE id =: recordId)
                                                     ORDER BY Disaggregation_Category__c];                                                    
            if(cdList != null && !cdList.IsEmpty()) {
            	for(Catalog_Disaggregated__c cdRecord : cdList) {
            		grntDisaggregated = new Grant_Disaggregated__c();
            	    grntDisaggregated.Catalog_Disaggregated__c = cdRecord.id;
            	    grntDisaggregated.Grant_Indicator__c = recordId;
            	    grntDisaggregated.Component__c = componentName;
            	    insertGDList.add(grntDisaggregated);
            	}           	
            }
	    }
	    if(insertGDList != null && !insertGDList.isEmpty()) {
	    	insert insertGDList;
	    	return insertGDList;
	    }
	    else 
	    	return gdList;	    
    }
    public DisagreegationTableController1(ApexPages.StandardController controller) {
    }
        

    
    public DisagreegationTableController1() {
        
    }
    
    public static void SaveAction() {
        System.debug(';;;;;;;;;;;;;;;;;;;;;;'+GrantDisaggregatedList);
        
        //insert gdd;
    }
    public class DisagreegationTableWrapper {
        public Catalog_Disaggregated__c cd              {get; set;}
        public Grant_Disaggregated__c gd                {get; set;}
        public DisagreegationTableWrapper (Catalog_Disaggregated__c cd, Grant_Disaggregated__c gd) {
            this.cd = cd;
            this.gd = gd;
        }
    } 
}