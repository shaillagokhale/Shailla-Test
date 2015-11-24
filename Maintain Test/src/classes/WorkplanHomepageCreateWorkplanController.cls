public with sharing class WorkplanHomepageCreateWorkplanController {
    public list<Country__c> lstusercountry{get;set;}
    public string CountryNames {get;set;}
    
    public WorkplanHomepageCreateWorkplanController(){
        //lstusercountry=new List<Country__c>();
        getCountryNames();
    }
    
    public string getCountryNames(){
        id uid = userinfo.getUserId();
        system.debug('@@User ID:'+uid);
        List<GroupMember> lstGroupMember = [SELECT GroupId FROM GroupMember where userorgroupid =:uid ];
        list<Country__c> lstcountry = [Select Name, CT_Public_Group_ID__c from Country__c];
        list<Country__c> lstusercountry = new list<Country__c>();
        list<Group> lstGroup = [Select id, Name from Group];
        list<Group> lstuserGroup = new list<Group>();
        for(GroupMember gm : lstGroupMember){
           for(Country__c c : lstcountry){
               if(gm.GroupId == c.CT_Public_Group_ID__c){
               lstusercountry.add(c);
               }
           }
        }
        /*if(lstuserGroup.size() > 0){
            for(Group ug : lstuserGroup){
                for(Country__c c: lstcountry ){
                    if(ug.name.contains(c.name)){
                        lstusercountry.add(c);
                    }
                }
            }
        } */
        system.debug('@@Country List :'+lstusercountry);
        
        List<String> countryNameList =new List<String>();
        Integer listSize = 0; 
        if(lstusercountry.size()>0){
        	for(Country__c cn : lstusercountry){           
            	countryNameList.add(cn.Name);
            	countryNameList.add(',');
        	}
        	listSize = countryNameList.size();
        	countryNameList[listSize-1] = '';
        	CountryNames ='';
        	for(String name : countryNameList){
          	              CountryNames = CountryNames+name;
        	}
        	return CountryNames ;
        }else{
        	return null;
        }	
    }
}