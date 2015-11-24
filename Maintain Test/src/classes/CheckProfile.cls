Public class CheckProfile{


Public static Boolean checkProfile(){
    Set<Id> pIds = new Set<Id>();
        for(Profile p : [Select Id from Profile where Name LIKE '%LFA%'
                         OR Name LIKE '%Read-only%'
                         OR Name LIKE '%Technical Hub%'
                         OR Name LIKE '%M&E Officer%'
                         OR Name LIKE '%Finance Officer%'
                         OR Name LIKE '%PSM Officer%'
                         OR Name LIKE '%Legal Officer%'
                         OR Name LIKE '%Management%'
                         OR Name LIKE '%Access to Funding%']){
                pIds.add(p.Id);
         }
        if(pIds.contains(System.UserInfo.getProfileId())){
            return true; 
         } else{
            return false;
         }
  }
  
  /* Introducing two new function which will do a check for CN_DocumentUpload class */
  
  Public static Boolean chkPfleCnDocForSubmitted(){
    Set<Id> pIds = new Set<Id>();
        for(Profile p : [Select Id from Profile where Name LIKE '%Country Team%'
                         OR Name LIKE '%System Administrator%'
                         OR Name LIKE '%Technical Hub%'
                         OR Name LIKE '%M&E Officer%'
                         OR Name LIKE '%Finance Officer%'
                         OR Name LIKE '%PSM Officer%'
                         OR Name LIKE '%Management%'
                         OR Name LIKE '%FPM%']){
                pIds.add(p.Id);
         }
        if(pIds.contains(System.UserInfo.getProfileId())){
            return true; 
         } else{
            return false;
         }
  }
  
   Public static Boolean chkPfleCnDocForNotSubmitted(){
    Set<Id> pIds = new Set<Id>();
        for(Profile p : [Select Id from Profile where Name LIKE '%Country Team%'
                         OR Name LIKE '%System Administrator%'
                         OR Name LIKE '%M&E Officer%'
                         OR Name LIKE '%Finance Officer%'
                         OR Name LIKE '%PSM Officer%'
                         OR Name LIKE '%Management%'
                         OR Name LIKE '%FPM%']){
                pIds.add(p.Id);
         }
        if(pIds.contains(System.UserInfo.getProfileId())){
            return true; 
         } else{
            return false;
         }
  } 
  
  /* End */
  
  Public static Boolean checkProfileGF(){
      Set<Id> pIds = new Set<Id>();
        for(Profile p : [Select Id from Profile
                         WHERE Name LIKE '%Country Team%'
                         OR Name LIKE '%System Administrator%'
                         OR Name LIKE '%Technical Hub%']){
                pIds.add(p.Id);
         }
        if(pIds.contains(System.UserInfo.getProfileId())){
            return true; 
         } else{
            return false;
         }
      }
      
      
   Public static Boolean checkProfileOpenCNotes(){
      Set<Id> pIds = new Set<Id>();
        for(Profile p : [Select Id from Profile
                         WHERE Name LIKE '%Country Team%'
                         OR Name LIKE '%System Administrator%'
                         OR Name LIKE '%Admin%']){
                pIds.add(p.Id);
         }
        if(pIds.contains(System.UserInfo.getProfileId())){
            return true; 
         } else{
            return false;
         }
      }
}