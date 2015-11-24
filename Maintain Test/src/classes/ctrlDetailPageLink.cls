public class ctrlDetailPageLink{ 
    public String obj;
    public List<Module__c> ModList {get;set;}
    IP_Detail_Information__c IpDetailInfo {get;set;}
    
    public ctrlDetailPageLink(ApexPages.StandardController controller){    
        ModList = [Select id,Name From Module__c where Implementation_Period__c=: Apexpages.currentpage().getparameters().get('Id')];
        IpDetailInfo =[Select id,Budget_Status__c from IP_Detail_Information__c where Implementation_Period__c=: Apexpages.currentpage().getparameters().get('Id')];
    }       
}