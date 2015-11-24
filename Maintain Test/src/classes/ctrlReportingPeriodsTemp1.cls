Public with sharing Class ctrlReportingPeriodsTemp1{
    public String strGIPId {get;set;}
    Public String strPageId {get;set;}
    public List<Period__c> lstRP {get;set;}
    
    Public List<Page__c> lstPages {get;set;}
    Public boolean blnExpandSection {get;set;}
    Public List<Module__c> lstModules {get;set;}
    Public List<Implementation_Period__c> lstIP{get;set;}
    Public String selectopt {get;set;}
    
    public List<SelectOption> options {get;set;}
    Public Date dateIPStart{get;set;}
    Public Date dateIPEnd{get;set;}
    Public Boolean blnGenPeriod{get;set;}
    Public Boolean blnEditPeriod{get;set;}
    Public Boolean blnAddDocument{get;set;}
    Public Boolean testDocVar{get;set;}
    Public Boolean blnErr{get;set;}
    Public Integer lstRpSize{get;set;}
    Public Integer SaveDocIndex{get;set;}
    Public Date dateEnd {get;set;}
    Public Boolean blnDR {get;set;}
    public ctrlReportingPeriodsTemp1(ApexPages.StandardController controller) {
        
        blnGenPeriod=false;
        blnEditPeriod=false;
        blnAddDocument=false;
        blnErr=false;
        strPageId = Apexpages.currentpage().getparameters().get('id');   
        if(String.IsBlank(strPageId) == false){
            List<Page__c> lstPage = [Select Implementation_Period__c From Page__c Where Id =: strPageId And Implementation_Period__c != null Limit 1];
            if(lstPage.size() > 0) strGIPId = lstPage[0].Implementation_Period__c; 
        }          
        lstRP = new List<Period__c>();
        
        lstRP = [Select Id, Period_Number__c,Start_Date__c,End_Date__c,Due_Date__c,Document__c,PU__c,DR__c,EFR__c,Period_Length__c, Audit_Report__c,AR_Due_Date__c,EFR_Due_Date__c,PU_Due_Date__c  From Period__c Where Implementation_Period__c =: strGIPID And Type__c = 'Reporting' Order by Period_Number__c];        
        
        lstPages = new List<Page__c>();   
        lstPages = [Select Id,Name,URL_Prefix__c,Order__c,Modular__c From Page__c Where Implementation_Period__c =: strGIPID Order by Order__c]; 
        lstModules = new List<Module__c>();   
        lstModules = [Select Id,Name,Implementation_Period__c From Module__c Where Implementation_Period__c =: strGIPID Order by Name]; 
        lstIP = [Select Id,Start_Date__c,Principal_Recipient_disbursement__c,Year_Period__c,Quarter_Period__c,Semester_Period__c,Principal_Recipient__r.Country__r.Country_Fiscal_Cycle_End_Date__c From Implementation_Period__c Where Id=:strGIPID ];
        dateIPStart = lstIP[0].Start_Date__c;
        dateIPEnd = lstIP[0].Principal_Recipient__r.Country__r.Country_Fiscal_Cycle_End_Date__c;
        dateEnd = dateIPEnd.addDays(-42);
        
        lstRpSize = lstRP.size();
        System.debug('**lstRpSize'+lstRpSize);
        if(lstRP.size() > 0) {
        blnGenPeriod=true;
        }
      
    
    }
    
    /***************************************************************************************************************************
    Purpose: The function is used to generate Period as per Choosen value. like Yearly, Semesterly or Quarterly.
    
    ****************************************************************************************************************************/
    
    public void GeneratePeriod(){
        
        System.debug('selected frequency value'+selectopt);
        
        List<Implementation_Period__c> lstImplementationPeriod = [Select Id,Concept_Note__r.Implementation_Period_Page_Template__c,
                                        Start_Date__c,End_Date__c,Length_Years__c,Principal_Recipient__r.Country__r.Country_Fiscal_Cycle_End_Date__c,Principal_Recipient__r.Country__r.Country_Fiscal_Cycle_Start_Date__c
                                        From Implementation_Period__c Where Id =: strGIPID];
        system.debug('$$lstImplementationPeriod$$$'+lstImplementationPeriod);
        List<Period__c> lstPeriodToInsert = new List<Period__c>();
        Period__c objPeriod;
        for(Implementation_Period__c objIP : lstImplementationPeriod){
        if(objIP.Length_Years__c != null && objIP.Start_Date__c != null && objIP.End_Date__c != null){
             Date dCtrStart = objIP.Principal_Recipient__r.Country__r.Country_Fiscal_Cycle_Start_Date__c;
             Date dCtrEnd = objIP.Principal_Recipient__r.Country__r.Country_Fiscal_Cycle_End_Date__c;
             Date dIPStart = objIP.Start_Date__c;
             Date dIPEnd = objIP.End_Date__c;
             Date endDate;
             Integer Year = dIPStart.Year();
             
             Integer Month = dCtrStart.month();
             Integer day = Date.daysInMonth(Year,Month);
             
             Date newDate =  date.newInstance(Year, Month, day);
             Date newDateEnd =  newDate.addMonths(11);
             
              
             System.debug('**newDate**'+newDate);
             System.debug('**newDateEnd**'+newDateEnd);
             
             
             Integer varGapMonths;
              if(selectopt=='1'){
                Date dCYFiscalStart = newDate ;
                Date dCYFiscalEnd = newDateEnd ;
                endDate = dCYFiscalEnd;
                System.debug('**endDate**'+endDate); 
                varGapMonths = 12;
              }
              else if(selectopt=='2'){
                Date dCYFiscalStart = newDate ;
                Date dCYFiscalEnd = newDateEnd;
                Date dCYMid = newDate.addMonths(5);
                System.debug('**DcyMid**'+dCYMid);
                if(dIPStart.Month() > dCYMid.month()){
                endDate  = dCYFiscalEnd;
                
                }
                else{
                endDate = dCYMid;
                }
                
                     
                
                varGapMonths = 6;
              }
              else {
                Date dCYFiscalStart = newDate;
                Date dCYFiscalEnd = newDateEnd;
                Date dCYq1E = newDate.addMonths(2);
                System.debug('**dCYq1E**'+dCYq1E); 
                Date dCYq2E = dCYq1E.addMonths(3);
                System.debug('**dCYq2E**'+dCYq2E);
                Date dCYq3E =  dCYq2E.addMonths(3);
                System.debug('**dCYq3E**'+dCYq3E);
                
                if(dIPStart>dCYq1E){
                    if(dIPStart>dCYq2E){
                        if(dIPStart>dCYq3E){
                            endDate = dCYFiscalEnd;
                        }else{
                            endDate = dCYq3E;
                        }
                    }else{
                            endDate = dCYq2E;
                        }
                }else{
                            endDate = dCYq1E;
                    }
                
                varGapMonths = 3;
              }     
                    
                    Integer endDays = Date.daysInMonth(endDate.year(), endDate.Month());
                    endDate =  date.newInstance(endDate.year(),  endDate.Month(), endDays);              
                    system.debug('@@@Check endDate'+endDate); 
                    /*Date dIPStart = objIP.Start_Date__c;
                    Date dyear = dIPStart.addMonths(varGapMonths); 
                    Integer endMonth =d1.Month();
                    Integer Year = dyear.Year();
                    Integer endDays = Date.daysInMonth(year, endMonth);
                    Date endDate =  date.newInstance(Year, endMonth, endDays); 
                    
                    /*Date dyear = d.addMonths(varGapMonths); 
                    Integer endMonth =dyear.Month();
                    Integer Year = dyear.Year();
                    Integer endDays = Date.daysInMonth(year, endMonth);
                    
                    Date endDate =  date.newInstance(Year, endMonth, endDays);   
                    
                    
                    if(objIP.Start_Date__c>endDate){
                    system.debug('@@@Inside Check Date'); 
                    Date dIPStart = objIP.Start_Date__c;
                    //Date dyear1 = dIPStart.addYears(1); 
                    Integer YearNew = dIPStart.Year();
                   
                    endDate =  date.newInstance(YearNew, endMonth, endDays); 
                     system.debug('@@@Inside Equal Outside Check Date'+endDate);
                   /* if(dIPStart>endDate){
                    system.debug('@@@Inside Equal Check Date'); 
                    endDate = endDate.addYears(1);
                    system.debug('@@@Inside Equal Inside end Check Date'+endDate); 
                    }
                     system.debug('@@@Inside Check YearNew'+YearNew);
                     system.debug('@@@Inside Check Year'+endDate);
                    }*/
                    Date endDateY1;
                for(integer i=1;i<=integer.valueof(objIP.Length_Years__c) * integer.valueof(selectopt);i++){
                   if(i==1){    
                                  objPeriod = new Period__c(Implementation_Period__c = objIP.Id,Type__c = 'Reporting',
                                Start_Date__c = objIP.Start_Date__c,End_Date__c =endDate ,Period_Number__c = i,PU__c = true,PU_Due_Date__c=endDate);
                            
                            }    
                    if(i>1){
                    Date startDateSecond = endDateY1.addDays(1); 
                    endDateY1 = endDateY1.addMonths(varGapMonths);
                    Integer endDaysSecond = Date.daysInMonth(endDateY1.year(), endDateY1.Month());
                    endDateY1 =  date.newInstance(endDateY1.year(),  endDateY1.Month(), endDaysSecond);
                    if(endDateY1 > objIP.End_Date__c ){
                    endDateY1 = objIP.End_Date__c;
                    objPeriod = new Period__c(Implementation_Period__c = objIP.Id,Type__c = 'Reporting',
                                Start_Date__c = startDateSecond ,End_Date__c = endDateY1,Period_Number__c = i,PU__c =true,PU_Due_Date__c=endDateY1.addMonths(varGapMonths));
                    lstPeriodToInsert.add(objPeriod);       
                    break;
                    }
                     objPeriod = new Period__c(Implementation_Period__c = objIP.Id,Type__c = 'Reporting',
                                Start_Date__c = startDateSecond ,End_Date__c = endDateY1,Period_Number__c = i,PU__c =true,PU_Due_Date__c=endDateY1.addMonths(varGapMonths));
                                //endDateY2 = endDateY1.addYears(i-2);
                    }
                    
                    
                    /*if(i == integer.valueof(objIP.Length_Years__c) * integer.valueof(selectopt)){
                     objPeriod = new Period__c(Implementation_Period__c = objIP.Id,Type__c = 'Reporting',
                                Start_Date__c = endDateY1.addDays(1),End_Date__c =objIP.End_Date__c ,Period_Number__c = i,PU__c =true,DR__c=true,Due_Date__c=dCtrEnd.addDays(-42),PU_Due_Date__c=objIP.End_Date__c);
                     
                    }*/
                    
                    lstPeriodToInsert.add(objPeriod);
                   endDateY1 =objPeriod.End_Date__c ; 
                }
                    
               
        }
     }  
      
        if(lstPeriodToInsert.size() > 0){
        	List<Result__c> lstResults = new List<Result__c>();
        	Result__c objResult;
        if(lstPeriodToInsert!=null && lstPeriodToInsert.size()>0){
            for(Period__c objPer : lstPeriodToInsert){
                objResult = new Result__c();
                objResult.Period__c = objPer.ID ;
                lstResults.add(objResult);
            }
        } 
        	 insert lstPeriodToInsert;
        	 insert lstResults;
        }
        lstRP = new List<Period__c>();
          
        lstRP = [Select Id, Period_Number__c,Start_Date__c,End_Date__c,Due_Date__c,PU__c,DR__c,EFR__c,Period_Length__c,Document__c, Audit_Report__c,AR_Due_Date__c,EFR_Due_Date__c,PU_Due_Date__c  From Period__c Where Implementation_Period__c =: strGIPID And Type__c = 'Reporting' Order by Period_Number__c];
        blnGenPeriod = true;
    }
    
    /***************************************************************************************************************************
    Purpose: The Function to Save Changes after clicking on Edit Period Button.
    ****************************************************************************************************************************/
     
    Public void SaveChanges(){
        System.debug('**In Save Changes');
        update lstRP;
        blnEditPeriod = false;
    }
    
    /***************************************************************************************************************************
     Purpose: Function to set the Boolean value after clicking on Edit Period Button
    ****************************************************************************************************************************/  
    Public void EditPeriod(){
    System.debug('**Inside Edit Period');
    blnEditPeriod = true;
    
    }
    
    /***************************************************************************************************************************
    Purpose : Function to set the Boolean value after clicking on AddDocument button Period Button
    ****************************************************************************************************************************/ 
    
    Public void AddDoC(){
    
    blnAddDocument = true;
    }
    
      /***************************************************************************************************************************
    Purpose : Function to set the Boolean value after clicking on AddDocument button Period Button
    ****************************************************************************************************************************/ 
    
    Public void check() {
         system.debug('**inside check');
         //Integer SaveDocIndex = integer.valueof(Apexpages.currentpage().getparameters().get('SaveDocIndex'));
      if(SaveDocIndex!=null){
        //Integer SaveDocIndex = integer.valueof(Apexpages.currentpage().getparameters().get('SaveDocIndex'));
        SaveDocIndex =SaveDocIndex-1;
        if(lstRP[SaveDocIndex].AR_Due_Date__c<lstRP[SaveDocIndex].Start_Date__c || lstRP[SaveDocIndex].AR_Due_Date__c>lstRP[SaveDocIndex].End_Date__c ){
          system.debug('**inside if');
          blnErr = true;
          system.debug('**blnErr'+blnErr);
         }  
     }  
    }
    
    
    
    /**************************************************************************************************************************
    Purpose :Function to Save Records to Period Object After clicking on Save and if Uncheck reset the Date Value to null 
    **************************************************************************************************************************/
    
    Public void noOperation() {
    
     
    }
    
    Public void SaveDoc(){
    Integer SaveDocIndex = integer.valueof(Apexpages.currentpage().getparameters().get('SaveDocIndex'));
    //SaveDocIndex =SaveDocIndex-1;
    System.debug('**SaveDocIndex'+SaveDocIndex);
    
       
    
    /*if(lstRP[SaveDocIndex].Audit_Report__c==true || lstRP[SaveDocIndex].EFR__c==true || lstRP[SaveDocIndex].PU__c==true || lstRP[SaveDocIndex].DR__c==true){
    if(lstRP[SaveDocIndex].AR_Due_Date__c<lstRP[SaveDocIndex].Start_Date__c || lstRP[SaveDocIndex].AR_Due_Date__c>lstRP[SaveDocIndex].End_Date__c ){
            blnErr = true;   
            }else{
            blnErr = false;
            system.debug('**Inside Else of err**');
            }
    if(lstRP[SaveDocIndex].EFR_Due_Date__c<lstRP[SaveDocIndex].Start_Date__c || lstRP[SaveDocIndex].EFR_Due_Date__c>lstRP[SaveDocIndex].End_Date__c ){
            blnErr = true;
            }else{
            blnErr = false;
            }
    if(lstRP[SaveDocIndex].PU_Due_Date__c<lstRP[SaveDocIndex].Start_Date__c || lstRP[SaveDocIndex].PU_Due_Date__c>lstRP[SaveDocIndex].End_Date__c ){
            blnErr = true;
            }else{
            blnErr = false;
            }
    if(lstRP[SaveDocIndex].Due_Date__c<lstRP[SaveDocIndex].Start_Date__c || lstRP[SaveDocIndex].Due_Date__c>lstRP[SaveDocIndex].End_Date__c ){
            blnErr = true;
            }else{
            blnErr = false;
            }               
    }
    
    if(lstRP[SaveDocIndex].Audit_Report__c==false || lstRP[SaveDocIndex].EFR__c==false || lstRP[SaveDocIndex].PU__c==false || lstRP[SaveDocIndex].DR__c==false){
    
    if(lstRP[SaveDocIndex].EFR__c==false && lstRP[SaveDocIndex].EFR_Due_Date__c != null){
    lstRP[SaveDocIndex].EFR_Due_Date__c = null;
    blnErr = false;
    }
    
    if(lstRP[SaveDocIndex].Audit_Report__c==false && lstRP[SaveDocIndex].AR_Due_Date__c != null){
    lstRP[SaveDocIndex].AR_Due_Date__c = null;
    blnErr = false;
    }
    
    if(lstRP[SaveDocIndex].PU__c==false && lstRP[SaveDocIndex].PU_Due_Date__c != null){
    lstRP[SaveDocIndex].PU_Due_Date__c = null;
    blnErr = false;
    } 
    
    if(lstRP[SaveDocIndex].DR__c==false && lstRP[SaveDocIndex].Due_Date__c != null){
    lstRP[SaveDocIndex].Due_Date__c = null;
    blnErr = false;
    }
    }*/
    blnErr = false;
    
    if(lstRP[SaveDocIndex].EFR__c==false && lstRP[SaveDocIndex].EFR_Due_Date__c != null){
    lstRP[SaveDocIndex].EFR_Due_Date__c = null;
    blnErr = false;
    }
    
    if(lstRP[SaveDocIndex].Audit_Report__c==false && lstRP[SaveDocIndex].AR_Due_Date__c != null){
    lstRP[SaveDocIndex].AR_Due_Date__c = null;
    blnErr = false;
    }
    
    if(lstRP[SaveDocIndex].PU__c==false && lstRP[SaveDocIndex].PU_Due_Date__c != null){
    lstRP[SaveDocIndex].PU_Due_Date__c = null;
    blnErr = false;
    } 
    
    if(lstRP[SaveDocIndex].DR__c==false && lstRP[SaveDocIndex].Due_Date__c != null){
    lstRP[SaveDocIndex].Due_Date__c = null;
    blnErr = false;
    }
    
    if(blnErr == false){
     if(lstRP[SaveDocIndex].Audit_Report__c==true){
            if(lstRP[SaveDocIndex].AR_Due_Date__c<lstRP[SaveDocIndex].Start_Date__c || lstRP[SaveDocIndex].AR_Due_Date__c>lstRP[SaveDocIndex].End_Date__c ){
            blnErr = true;
            //blnAddDocument = true;    
            }else{
            blnErr = false;
            }
    }
    }
    
    if(blnErr == false){
    if(lstRP[SaveDocIndex].EFR__c==true){
            if(lstRP[SaveDocIndex].EFR_Due_Date__c<lstRP[SaveDocIndex].Start_Date__c || lstRP[SaveDocIndex].EFR_Due_Date__c>lstRP[SaveDocIndex].End_Date__c ){
            blnErr = true;
            }else{
            blnErr = false;
            }
    }
    }
    
    if(blnErr == false){
     if(lstRP[SaveDocIndex].PU__c==true ){
            if(lstRP[SaveDocIndex].PU_Due_Date__c<lstRP[SaveDocIndex].Start_Date__c || lstRP[SaveDocIndex].PU_Due_Date__c>lstRP[SaveDocIndex].End_Date__c ){
            blnErr = true;
            }else{
            //blnErr = false;
            }
    
    }
    }
    
    if(blnErr == false){
    if(lstRP[SaveDocIndex].DR__c==true){
        system.debug('**inside first IF in DR');
            if(lstRP[SaveDocIndex].Due_Date__c != dateEnd){
                system.debug('**inside second IF in DR');
                blnErr = true;
                blnDR = true;
            }else{
                system.debug('**inside first else in DR');
            blnDR = false;
            }
            if(blnDR == true){
                system.debug('**inside third IF in DR');
            if(lstRP[SaveDocIndex].Due_Date__c<lstRP[SaveDocIndex].Start_Date__c || lstRP[SaveDocIndex].Due_Date__c>lstRP[SaveDocIndex].End_Date__c){
            system.debug('**inside fourth IF in DR');
            blnErr = true;
            blnDR = true;
            }else{
                system.debug('**inside second else in DR');
            blnErr = false;
            }
            }               
         
          }
       if( lstRP[SaveDocIndex].Due_Date__c == dateEnd){
       blnErr = false;
       }
    }
    /*if(lstRP[SaveDocIndex].Audit_Report__c==true){
            if(lstRP[SaveDocIndex].AR_Due_Date__c<lstRP[SaveDocIndex].Start_Date__c || lstRP[SaveDocIndex].AR_Due_Date__c>lstRP[SaveDocIndex].End_Date__c ){
            blnErr = true;
            //blnAddDocument = true;    
            }else{
            blnErr = false;
            //blnAddDocument = false;
            system.debug('**Inside Else of err**');
            }
        
      }else if(lstRP[SaveDocIndex].AR_Due_Date__c != null) {
      
      lstRP[SaveDocIndex].AR_Due_Date__c = null;
      blnErr = false;
      system.debug('++++ Here**' +lstRP[SaveDocIndex].AR_Due_Date__c);
      }
    
    if(lstRP[SaveDocIndex].EFR__c==true){
            if(lstRP[SaveDocIndex].EFR_Due_Date__c<lstRP[SaveDocIndex].Start_Date__c || lstRP[SaveDocIndex].EFR_Due_Date__c>lstRP[SaveDocIndex].End_Date__c ){
            blnErr = true;
            }else{
            blnErr = false;
            }
    }else if(lstRP[SaveDocIndex].EFR_Due_Date__c != null){
      blnErr = false;
      lstRP[SaveDocIndex].EFR_Due_Date__c = null;     
      }
      
     if(lstRP[SaveDocIndex].PU__c==true ){
            if(lstRP[SaveDocIndex].PU_Due_Date__c<lstRP[SaveDocIndex].Start_Date__c || lstRP[SaveDocIndex].PU_Due_Date__c>lstRP[SaveDocIndex].End_Date__c ){
            blnErr = true;
            }else{
            //blnErr = false;
            }
    }else if(lstRP[SaveDocIndex].PU_Due_Date__c == null){
      blnErr = false;
      lstRP[SaveDocIndex].PU_Due_Date__c = null;      
      }
     
      
    system.debug('***DateEnd'+dateEnd);
  
   if(lstRP[SaveDocIndex].DR__c==true && lstRP[SaveDocIndex].Due_Date__c != null){
            if(lstRP[SaveDocIndex].Due_Date__c<lstRP[SaveDocIndex].Start_Date__c || lstRP[SaveDocIndex].Due_Date__c>lstRP[SaveDocIndex].End_Date__c){ 
            system.debug('***Inside Boolen DR false');
            blnErr = true;
            }else{  
            blnErr = false;
            }
   }
          
   if(lstRP[SaveDocIndex].DR__c==true && lstRP[SaveDocIndex].Due_Date__c == dateEnd){
            if(lstRP[SaveDocIndex].Due_Date__c != dateEnd){
                blnErr = true;
                blnDR = true;
            }else{
            blnDR = false;
            }
            if(blnDR == true){
            if(lstRP[SaveDocIndex].Due_Date__c<lstRP[SaveDocIndex].Start_Date__c || lstRP[SaveDocIndex].Due_Date__c>lstRP[SaveDocIndex].End_Date__c){
            blnErr = true;
            blnDR = true;
            }else{
            blnErr = false;
            }
            }               
           /* if(lstRP[SaveDocIndex].Due_Date__c != dateEnd && (lstRP[SaveDocIndex].Due_Date__c<lstRP[SaveDocIndex].Start_Date__c || lstRP[SaveDocIndex].Due_Date__c>lstRP[SaveDocIndex].End_Date__c) ){
                system.debug('***Inside Boolen DR true');
            blnErr = true;
            }else{
            blnErr = false;
            }
          }*/
   
  if(lstRP[SaveDocIndex].DR__c==false && lstRP[SaveDocIndex].Due_Date__c != null){
      blnErr = false;
      lstRP[SaveDocIndex].Due_Date__c = null;      
      }
       
     
    /*else if(lstRP[SaveDocIndex].Due_Date__c == null){
      blnErr = false;
      lstRP[SaveDocIndex].Due_Date__c = null;     
      }*/
     
    /*if(lstRP[SaveDocIndex].Audit_Report__c==false){
    lstRP[SaveDocIndex].AR_Due_Date__c = null;
    update lstRP[SaveDocIndex];
    blnAddDocument = false;
    }*/
    /*if(lstRP[SaveDocIndex].Audit_Report__c==true){
    if(lstRP[SaveDocIndex].AR_Due_Date__c<lstRP[SaveDocIndex].Start_Date__c || lstRP[SaveDocIndex].AR_Due_Date__c>lstRP[SaveDocIndex].End_Date__c ){
            blnErr = true;
            blnAddDocument = true;
                
    }else{
     update lstRP[SaveDocIndex];
    blnAddDocument = false;
    }
    }*/
    /*if(lstRP[SaveDocIndex].EFR__c==false){
    lstRP[SaveDocIndex].EFR_Due_Date__c = null;
    }
     if(lstRP[SaveDocIndex].PU__c==false){
    lstRP[SaveDocIndex].PU_Due_Date__c = null;
    } 
     if(lstRP[SaveDocIndex].DR__c==false){
    lstRP[SaveDocIndex].Due_Date__c = null;
    }*/
    
    if(blnErr == false){ 
      //  if(blnDR == true) {   
    update lstRP[SaveDocIndex];
    
    System.debug('**ListDocIndex'+lstRP[SaveDocIndex]);
    blnAddDocument = false;
   // }
    }
    else{
    blnAddDocument = true;
    }
    
    
    System.debug('**ListDocIndex'+lstRP[SaveDocIndex]);
    //blnAddDocument = false;
    
    }
    
    
    Public void CancelDocPopup(){
    blnAddDocument = false;
    }
}