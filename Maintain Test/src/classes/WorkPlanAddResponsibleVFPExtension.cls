//****************************************************************************************

// Purpose     :  This Class is used to add Responsible Users to Step(adding Responsible records).    
// Date        :  08-Dec-2014
// Created By  :  TCS 
// Author      :  Gaurav Guleria
// Description :  This Class is used to add Responsible Users to Step(adding Responsible records).This Class is related with 
//                WorkPlanAddResponsibleVFP Page.
// Revision:   :  
public with sharing class WorkPlanAddResponsibleVFPExtension{
    public ApexPages.Standardcontroller stdCtrl;
    public String milestoneId{get;set;}
    public String taskId{get;set;} 
    public List<Responsible__c> showResponsible{get;set;}  
    public  List<Responsible__c> ResponsibleList{get;set;}
    public List<Responsible__c> deleteResponsibleList{get;set;}
    public Step__c stepRec{get;set;}
    public Responsible__c Rrec{get;set;}
    public WorkPlanAddResponsibleVFPExtension(ApexPages.standardController ctr){
       
        milestoneId = ApexPages.currentPage().getParameters().get('stepId');
        stepRec = [SELECT Task_Name__c FROM Step__c WHERE id=:milestoneId];
        taskId = stepRec.Task_Name__c;        
        ResponsibleList = new List<Responsible__c>();
        showResponsible = new List<Responsible__c>();
        showResponsible = [SELECT id,Responsible__c FROM Responsible__c WHERE Step__c=:milestoneId];
        if(showResponsible.SIZE()==0){
            for(Integer i=0;i<6;i++){
                Responsible__c resp =  new Responsible__c();
                ResponsibleList.add(resp);
            }
        }   
        else if(showResponsible.SIZE()==1){
            for(Responsible__c res :showResponsible){
                ResponsibleList.add(res);
            }
            for(Integer i=0;i<5;i++){
                Responsible__c resp =  new Responsible__c();
                ResponsibleList.add(resp);    
            }
        }
        else if(showResponsible.SIZE()==2){
            for(Responsible__c res :showResponsible){
                ResponsibleList.add(res);
            }
            for(Integer i=0;i<4;i++){
                Responsible__c resp =  new Responsible__c();
                ResponsibleList.add(resp);     
            }
        }
        else if(showResponsible.SIZE()==3){
            for(Responsible__c res :showResponsible){
                ResponsibleList.add(res);
            }
            for(Integer i=0;i<3;i++){
                Responsible__c resp =  new Responsible__c();
                ResponsibleList.add(resp);     
            }
        }
        else if(showResponsible.SIZE()==4){
            for(Responsible__c res :showResponsible){
                ResponsibleList.add(res);
            }
            for(Integer i=0;i<2;i++){
                Responsible__c resp =  new Responsible__c();
                ResponsibleList.add(resp);     
            }
        }
        else if(showResponsible.SIZE()==5){
            for(Responsible__c res :showResponsible){
                ResponsibleList.add(res);
            }
            for(Integer i=0;i<1;i++){
                Responsible__c resp =  new Responsible__c();  
                ResponsibleList.add(resp);   
            }
        }
        else if(showResponsible.SIZE()==6){
            for(Responsible__c res :showResponsible){
                ResponsibleList.add(res);
            }            
        }
    }
    public void saveResponsible(){
        
        List<Responsible__c> updatedResponsibleList = new List<Responsible__c>();
        deleteResponsibleList = [SELECT id FROM Responsible__c WHERE Step__c=:milestoneId];
        System.debug('@@Delete for Responsiblelist called'+deleteResponsibleList );
       // try{
                    delete deleteResponsibleList;
     //  }
    //    catch(Exception e){
        
    //    }
        
        for(Responsible__c res: ResponsibleList){
            if(res.Responsible__c!=NULL){
                Responsible__c resp =  new Responsible__c();
                resp.Responsible__c = res.Responsible__c;
                resp.Step__c = milestoneId;                
                updatedResponsibleList.add(resp);
            }
        }
        try{
            insert updatedResponsibleList;
        }
        catch(Exception e){
        
        }
        
        //return new PageReference('apex/WorkPlanCreateStepsVFP?id='+taskId);
        
        
    }
    
    public void cancelResponsible(){
    
    
    
    }
}