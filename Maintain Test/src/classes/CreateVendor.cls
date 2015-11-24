global without sharing Class CreateVendor{
    WebService static String Create(String Id) { 
        try{
                
            System.debug('Create Vnedor'+Id);
            Set_AccountId__c accS = Set_AccountId__c.getOrgDefaults();
            accS.Temp_Account_Id__c = Id;
            update accS;
            List<Account> lstacc = [Select Id, Name, Country__c,Full_Legal__c,Vendor_ID__c,Type__c,Sub_Type__c from Account where id = :Id]; 
          
          if(!lstacc.isEmpty()) 
          { 
          	Account acc = lstacc[0];
            Vendor__c vend = new vendor__c();
            vend.Name = acc.Name + ' Vendor';
            vend.Legal_Name__c = acc.Full_Legal__c;
            vend.PR_Type__c = acc.Type__c;
            vend.PR_Sub_Type__c = acc.Sub_Type__c;
            vend.Country__c = acc.Country__c;
            insert vend;
            System.debug('vend>>>>>'+vend);
            acc.Vendor_ID__c = vend.Id;
            update acc;
            
            System.debug('acc>>>>>'+acc);
            
          }         
          
                   
                   
        }catch(exception ex){
           return ex.getMessage();
        }
        return '';
    }
}