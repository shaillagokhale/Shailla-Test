global Class SubmitGrant{
    WebService static List<String> Submit(String Id) { 
    
    List<String> lstGrant = new List<String>();
    List<String> lstGIP = new List<String>();
    List<String> lstFields = new List<String>();
    
    
        try{
                   
          List<Implementation_Period__c> lstImpl = [Select Id, Name,Approval_Status__c,Implementation_Period_Cycle__c,
          Implementation_Cycle__c,Grant__c, Start_Date__c,End_Date__c,Local_Fund_Agent__c,Auth_Sig_for_Grant_Agreement__c,
          Financing_Mechanism__c,Grant_Tax_Exemption__c,Currency_of_Grant_Agreement__c,Governance_and_Programme_Management__c,
          Financial_Management_System__c,Procurement_and_Supply_Chain_Management__c,Monitoring_Evaluation__c,Sub_Recipient_Management__c,
          CCM_Chair__c,CCM_Civil_Society_Representative__c,Secretariat_Funding_Decision_Cycle__c,Anti_Terrorism_Screening_and_other_Backg__c,
          Approval_of_External_Auditor_Terms_of_Re__c,External_Audit_Approval_date__c,Periodic_Review_New_Concept_Note_Date__c,
          Investigations_Misuse_mi__c,Ineligible_Expenditure_Reported_Grant__c,Ineligible_Expenditure_Reported_PR__c,Did_TGF_Claim_reimbursement__c,
          Grant_Status__c,CT_Finance_Officer__c, Fund_Portfolio_Manager__c, Head_of_Department__c,Regional_Finance_Manager__c,CT_Legal_Officer__c,
          Regional_Team_Leader__c,Bank_Account__c,Component__c,Coordinating_Mechanism__c,GIP_Type__c,Grant_Type__c, GIP_Submission_for_Approval_Type__c,
          Principal_Recipient__r.Approval_Status__c,Bank_Account__r.Approval_Status__c,Grant__r.Contractual_Arrangement_Legal_Framework__c,
          Grant__r.Disease_Component__c,Grant__r.Grant_Type__c, Grant__r.Concept_Note_Type__c, Grant__r.Start_Date__c,Grant__r.End_Date__c,
          Locked__c from Implementation_Period__c where id = :Id]; 
          
          
          
          
          if(!lstImpl.isEmpty())          
          {    
            if(lstImpl[0].Locked__c){
              String strAlert = 'This implementation period is locked and may not be edited';
              List<String> lstString = new List<String>();
              lstString.add(strAlert);
              return lstString;
            }else{
               //GRANT FIELDS
               if(lstImpl[0].Grant__r.Disease_Component__c == null){lstGrant.add(' Disease Component') ;}
               if(lstImpl[0].Grant__r.Grant_Type__c == null){lstGrant.add(' Grant Type');}
               if(lstImpl[0].Grant__r.Concept_Note_Type__c == null){lstGrant.add(' Concept Note Type') ;}
               if(lstImpl[0].Grant__r.Start_Date__c == null){lstGrant.add(' Start Date');}
               if(lstImpl[0].Grant__r.End_Date__c == null){lstGrant.add(' End Date');}
               if(lstImpl[0].Grant__r.Contractual_Arrangement_Legal_Framework__c == null){lstGrant.add(' Contractual Arrangement Legal Framework');}             
               
               if(!lstGrant.isEmpty()){
                lstFields.add('PLEASE FILL ON THE GRANT PAGE');
                lstFields.addAll(lstGrant);
                return lstFields; }
               
               //GIP fields
               if(lstImpl[0].Grant_Type__c == null){lstGIP.add(' Grant Type');}
               if(lstImpl[0].Grant_Status__c == null){lstGIP.add(' Grant Status');}
               if(lstImpl[0].Component__c == null){lstGIP.add(' Component');}
               if(lstImpl[0].GIP_Type__c == null){lstGIP.add(' GIP Type');}
               if(lstImpl[0].GIP_Submission_for_Approval_Type__c == null){lstGIP.add(' GIP Submission for Approval Type');}
               if(lstImpl[0].Start_Date__c == null){lstGIP.add(' Start Date');} 
               if(lstImpl[0].End_Date__c == null){lstGIP.add(' End Date');}
               if(lstImpl[0].Implementation_Cycle__c == null){lstGIP.add(' Implementation Cycle');}
               if(lstImpl[0].Currency_of_Grant_Agreement__c == null){lstGIP.add(' Currency of Grant Agreement');}
               if(lstImpl[0].Financing_Mechanism__c == null){lstGIP.add( ' Financing Mechanism');}
               if(lstImpl[0].Grant_Tax_Exemption__c == null){lstGIP.add( ' Grant Tax Exemption');}
               if(lstImpl[0].Secretariat_Funding_Decision_Cycle__c == null){lstGIP.add(' Secretariat Funding Decision Cycle');}
               if(lstImpl[0].Anti_Terrorism_Screening_and_other_Backg__c == null){lstGIP.add(' Anti-Terrorism Screening and other Background Checks');}
               if(lstImpl[0].Approval_of_External_Auditor_Terms_of_Re__c == null){lstGIP.add(' Approval of External Auditor TOR');}
               if(lstImpl[0].External_Audit_Approval_date__c == null){lstGIP.add(' External Audit Approval date');}
               if(lstImpl[0].Periodic_Review_New_Concept_Note_Date__c == null){lstGIP.add(' Periodic Review New Concept Note Date');}
               if(lstImpl[0].Governance_and_Programme_Management__c == null){lstGIP.add(' Governance and Programme Management');}
               if(lstImpl[0].Financial_Management_System__c == null){lstGIP.add(' Financial Management System');}
               if(lstImpl[0].Procurement_and_Supply_Chain_Management__c == null){lstGIP.add(' Procurement and Supply Chain Management');}
               if(lstImpl[0].Monitoring_Evaluation__c == null){lstGIP.add(' Monitoring Evaluation');}
               if(lstImpl[0].Sub_Recipient_Management__c == null){lstGIP.add(' Sub Recipient Management');}
               if(lstImpl[0].Investigations_Misuse_mi__c == null){lstGIP.add(' Investigations Misuse mi');}
               if(lstImpl[0].Ineligible_Expenditure_Reported_PR__c == null){lstGIP.add(' Ineligible Expenditure Reported PR');}
               if(lstImpl[0].Ineligible_Expenditure_Reported_Grant__c == null){lstGIP.add(' Ineligible Expenditure Reported Grant');}
               if(lstImpl[0].Did_TGF_Claim_reimbursement__c == null){lstGIP.add(' Did TGF Claim reimbursement');}
               if(lstImpl[0].Auth_Sig_for_Grant_Agreement__c == null){lstGIP.add(' Auth Sig for Grant Agreement');}
               if(lstImpl[0].Coordinating_Mechanism__c == null){lstGIP.add(' Coordinating Mechanism');}
               if(lstImpl[0].CCM_Chair__c == null){lstGIP.add(' CCM Chair');}
               if(lstImpl[0].CCM_Civil_Society_Representative__c == null){lstGIP.add(' CCM Civil Society Representative');}
               if(lstImpl[0].Local_Fund_Agent__c == null){lstGIP.add(' Local Fund Agent');}
               if(lstImpl[0].Regional_Team_Leader__c == null){lstGIP.add(' Regional Team Leader');}
               if(lstImpl[0].Regional_Finance_Manager__c == null){lstGIP.add(' Regional Finance Manager');}
               if(lstImpl[0].Head_of_Department__c == null){lstGIP.add(' Head of Department');}
               if(lstImpl[0].Fund_Portfolio_Manager__c == null){lstGIP.add(' Fund Portfolio Manager');}
               
               if(!lstGIP.isEmpty()){
                lstFields.add('PLEASE FILL ON THE IMPLEMENTATION PERIOD PAGE');
                lstFields.addAll(lstGIP);
                return lstFields; }
                                              
          
              if(lstImpl[0].Principal_Recipient__r.Approval_Status__c == 'Approved'||lstImpl[0].Principal_Recipient__r.Approval_Status__c == 'Finance Officer verification'||lstImpl[0].Principal_Recipient__r.Approval_Status__c =='Send to finance system for approval')
              {
                  lstImpl[0].Approval_Status__c = 'Finance Officer verification';
                    update lstImpl;
               
               }
               else{
                 lstFields.add('Please confirm that the PR information has been approved by Finance before submitting the grant information.');
                 return lstFields;                 
               }
             }
          }         
          
                   
                   
        }catch(exception ex){
           lstFields.add('false');
           return lstFields;
        }
        lstFields.add('true');
           return lstFields;
    }
}