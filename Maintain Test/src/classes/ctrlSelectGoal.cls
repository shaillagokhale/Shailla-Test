public class ctrlSelectGoal {

    id Indicator;
    id ConNoteId;
    public List<Goalwrapper> GoalWrapList {get;set;}
    public List<Ind_Goal_Jxn__c> indGoalList = new List<Ind_Goal_Jxn__c>();
    Public List<SelectOption> IndicatorOptions {get;set;}
    Public id IndicatorId{get;set;}
    
    
    public ctrlSelectGoal(ApexPages.StandardController controller) {
    	ConNoteId = Apexpages.currentPage().getParameters().get('id');
    	allIndicators();

    	//ConNoteId = Indi.Concept_Note__c;
    	list<Goals_Objectives__c> GOList = [select id,Name from Goals_Objectives__c where Concept_Note__c=: ConNoteId];
    	
    	if(GOList!=NULL){
			GoalWrapList = new List<Goalwrapper>();
			
			for(Goals_Objectives__c g: GOList){
				Goalwrapper Gw = new Goalwrapper();
				Gw.selected = false;
				Gw.GO = g;
				GoalWrapList.add(Gw);
			}
	    }
	    else{
	    	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Goals re not Present');
            ApexPages.addMessage(myMsg);
            
	    }
    }    
    
    Public pagereference addGoals(){
    	for(Goalwrapper gWrap: GoalWrapList){
    		if(gWrap.selected== True){
    			Ind_Goal_Jxn__c IndGoal = new Ind_Goal_Jxn__c();
    			IndGoal.Goal_Objective__c = gWrap.GO.id;
    			IndGoal.Indicator__c = Indicatorid;
    			indGoalList.add(IndGoal);
    		}
    	}
    	
    	 if(indGoalList != NULL){
    		insert indGoalList;
    	}
    	pagereference pg = new pagereference('/'+ConNoteId);
    	pg.setRedirect(true);
    	return pg;
    }
    
    public pagereference Cancel(){
    	pagereference pg = new pagereference('/'+ConNoteId);
    	pg.setRedirect(true);
    	return pg;
    }
    
    Public void allIndicators(){
    	
        IndicatorOptions = new List<SelectOption>();
        List<Grant_Indicator__c> ListIndicator = [Select id,Concept_Note__c,Name from Grant_Indicator__c where Concept_Note__c=: ConNoteId];
        
                                            
        IndicatorOptions.add(new SelectOption('','--None--'));
        if(ListIndicator.size() > 0){
            for(Grant_Indicator__c GI : ListIndicator){
                IndicatorOptions.add(new SelectOption(GI.Id,GI.Name));
            }
        }
    }
    
    Public class Goalwrapper{
    	Public Boolean Selected{get;set;}
    	Public Goals_Objectives__c GO{get;set;}
    }

}