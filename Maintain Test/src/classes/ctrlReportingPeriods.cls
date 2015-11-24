Public with sharing Class ctrlReportingPeriods{
    public String strGIPId {get;set;}
    Public String strPageId {get;set;}
    public List<Period__c> lstRP {get;set;}
    public List<Period__c> lstIPGIFreq {get;set;}
    Public List<Page__c> lstPages {get;set;}
    Public boolean blnExpandSection {get;set;}
    Public List<Module__c> lstModules {get;set;}
    Public List<Implementation_Period__c> lstIP{get;set;}
    Public List<Result__c> lstResult{get;set;}
    Public String selectopt {get;set;}
    Public String strGuidanceId {get;set;} 
    Public String strLanguage {get;set;} 
    
    public List<SelectOption> options {get;set;}
    Public Date dateIPStart{get;set;}
    Public Date dateIPEnd{get;set;}
    Public Date dateCtrFiscalEnd{get;set;}
    Public Boolean blnGenPeriod{get;set;}
    Public Boolean blnEditPeriod{get;set;}
    Public Boolean blnAddDocument{get;set;}
    Public Boolean testDocVar{get;set;}
    Public Boolean blnErr{get;set;}
    Public Boolean blnDR{get;set;}
    Public Boolean blnChangePer{get;set;}
    Public Boolean blnHistory{get;set;}
    Public Integer lstRpSize{get;set;}
	Public String APIname {get;set;}
	Public String [] lstIPFreqFields {get; set;}
    //TCS 22/08/2014: Added for Profile Access
    Public Boolean blnExternalPro  {get;set;}
    Public Boolean blnEdit {get;set;}
    Public Boolean blnDueDate {get;set;}
    Public Boolean blnRepFrequency {get;set;}
    Public Boolean blnChangeFreq {get;set;}
    
    public ctrlReportingPeriods(ApexPages.StandardController controller) {
        
        blnGenPeriod=false;
        blnEditPeriod=false;
        blnAddDocument=false;
        strPageId = Apexpages.currentpage().getparameters().get('id');        
        if(String.IsBlank(strPageId) == false){
            List<Page__c> lstPage = [Select Implementation_Period__c From Page__c Where Id =: strPageId And Implementation_Period__c != null Limit 1];
            if(lstPage.size() > 0) strGIPId = lstPage[0].Implementation_Period__c; 
        }          
        lstRP = new List<Period__c>();
        
        lstRP = [Select Id, Period_Number__c,Start_Date__c,End_Date__c,Due_Date__c,Document__c,PU__c,DR__c,EFR__c,Period_Length__c,Audit_Report__c,AR_Due_Date__c,EFR_Due_Date__c,PU_Due_Date__c,Frequency__c  From Period__c Where Implementation_Period__c =: strGIPID And Type__c = 'Reporting' And Flow_to_GrantIndicator__c = false Order by Period_Number__c];        
        lstIPGIFreq = [Select Id, Period_Number__c,Start_Date__c,End_Date__c,Due_Date__c,Document__c,PU__c,DR__c,EFR__c,Period_Length__c,Audit_Report__c,AR_Due_Date__c,EFR_Due_Date__c,PU_Due_Date__c,Frequency__c  From Period__c Where Implementation_Period__c =: strGIPID And Type__c = 'Reporting' And Flow_to_GrantIndicator__c = true Order by Period_Number__c];
        lstPages = new List<Page__c>();   
        lstPages = [Select Id,Name,URL_Prefix__c,Order__c,Modular__c From Page__c Where Implementation_Period__c =: strGIPID Order by Order__c]; 
        lstModules = new List<Module__c>();   
        lstModules = [Select Id,Name,Implementation_Period__c From Module__c Where Implementation_Period__c =: strGIPID Order by Name]; 
        lstIP = [Select Id,Name,Start_Date__c,End_Date__c,Principal_Recipient_disbursement__c,Reporting_Frequency__c, Year_Period__c,Quarter_Period__c,Semester_Period__c,Principal_Recipient__r.Country__r.Country_Fiscal_Cycle_End_Date__c,Principal_Recipient__r.Country__r.Country_Fiscal_Cycle_Start_Date__c From Implementation_Period__c Where Id=:strGIPID ];
        
        lstIPFreqFields = new String[] {'Reporting_Frequency__c'};
        lstResult = [ select id,name,Period__r.Period_Number__c, Target_Denominator__c,Target_Numerator__c,Target__c,Indicator__c,Indicator__r.Data_Type__c from Result__c where Period__c IN: lstRP And Target__c!=null And Indicator__c!=null Order By Indicator__c,Period__c];
        if(lstIP[0].Start_Date__c!=null){
        dateIPStart = lstIP[0].Start_Date__c;
        dateIPEnd = lstIP[0].End_Date__c;
        if(lstIP[0].Principal_Recipient__r.Country__r.Country_Fiscal_Cycle_End_Date__c !=null || lstIP[0].Principal_Recipient__r.Country__r.Country_Fiscal_Cycle_Start_Date__c !=null){
        dateCtrFiscalEnd = lstIP[0].Principal_Recipient__r.Country__r.Country_Fiscal_Cycle_End_Date__c;
        dateCtrFiscalEnd =  dateCtrFiscalEnd.addDays(-42);
        }else{
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Kindly Enter Country Fiscal Start and End Dates '));
        blnGenPeriod=true;
        blnChangePer=true;
        }
        }else{
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Kindly Enter Implementation Start and End Dates'));
        blnGenPeriod=true;
        blnChangePer=true;
        }
        
        lstRpSize = lstRP.size();
        System.debug('**lstRpSize'+lstRpSize);
        if(lstRP.size() > 0) {
        blnGenPeriod=true;
        blnChangePer=false;
        }
         strLanguage = 'ENGLISH';
        if(System.UserInfo.getLanguage() == 'fr'){
            strLanguage = 'FRENCH'; }
        if(System.UserInfo.getLanguage() == 'ru'){
            strLanguage = 'RUSSIAN'; }
        if(System.UserInfo.getLanguage() == 'es'){
            strLanguage = 'SPANISH'; }
         List<Guidance__c> lstGuidance = [Select Id from Guidance__c where Name =: label.GM_Reporting_Periods];
            if(!lstGuidance.isEmpty()) 
            {
              strGuidanceId = lstGuidance[0].Id;
            }
        /*options = new List<SelectOption>();
        options.add(new SelectOption('1','Yearly'));
        options.add(new SelectOption('2','Semesterly'));
        options.add(new SelectOption('4','Quarterly'));*/
        checkProfile();
    
    }
    
    /***************************************************************************************************************************
    Purpose: The function is used to generate Period as per Choosen value. like Yearly, Semesterly or Quarterly.
    
    ****************************************************************************************************************************/
    
    public PageReference GeneratePeriod(){
        
        System.debug('selected frequency value'+selectopt);
        
        List<Implementation_Period__c> lstImplementationPeriod = [Select Id,Concept_Note__r.Implementation_Period_Page_Template__c,
                                        Start_Date__c,End_Date__c,Length_Years__c,Principal_Recipient__r.Country__r.Country_Fiscal_Cycle_End_Date__c,Principal_Recipient__r.Country__r.Country_Fiscal_Cycle_Start_Date__c
                                        From Implementation_Period__c Where Id =: strGIPID];
        //system.debug('$$lstImplementationPeriod$$$'+lstImplementationPeriod);
        List<Period__c> lstPeriodToInsert = new List<Period__c>();
        List<Result__c> lstResulttoinsert = new List<Result__c>();
        Period__c objPeriod;
        for(Implementation_Period__c objIP : lstImplementationPeriod){
        if(objIP.Length_Years__c != null && objIP.Start_Date__c != null && objIP.End_Date__c != null){
             
             if( objIP.Principal_Recipient__r.Country__r.Country_Fiscal_Cycle_Start_Date__c !=null && objIP.Principal_Recipient__r.Country__r.Country_Fiscal_Cycle_End_Date__c !=null){
             Date dCtrStart = objIP.Principal_Recipient__r.Country__r.Country_Fiscal_Cycle_Start_Date__c;
             Date dCtrEnd = objIP.Principal_Recipient__r.Country__r.Country_Fiscal_Cycle_End_Date__c;
             
             Date dIPStart = objIP.Start_Date__c;
             Date dIPEnd = objIP.End_Date__c;
             Date endDate;
             Integer Year = dIPStart.Year();
             Integer day = dCtrStart.day();
             Integer Month = dCtrStart.month();
            
             
             Date newDate =  date.newInstance(Year, Month, day);
             Date newDateEnd =  newDate.addMonths(11);
             
              
             System.debug('**newDate**'+newDate);
             System.debug('**newDateEnd**'+newDateEnd);
             
             
             Integer varGapMonths;
              if(selectopt=='1'){
                Date dCYFiscalStart = newDate ;
                Date dCYFiscalEnd = newDateEnd ;
                endDate = dCYFiscalEnd;
                if(dIPStart<dCtrEnd && dIPStart.Year()==dCtrEnd.Year()){
                endDate = dCtrEnd;
                }
                
                System.debug('**endDate**'+endDate); 
                varGapMonths = 12;
              }
              else if(selectopt=='2'){
                Date dCYFiscalStart = newDate ;
                Date dCYFiscalEnd = newDateEnd;
                Date dCYMid = newDate.addMonths(5);
                System.debug('**DcyMid**'+dCYMid);
                System.debug('**Country End Date**'+dIPStart);
                System.debug('**Country End Date**'+dCtrEnd);
                if(dIPStart<dCtrEnd && dIPStart.Year()==dCtrEnd.Year() ){
                endDate = dCtrEnd;
                }else
                if(dIPStart > dCYMid){
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
                        	if(dIPStart<dCtrEnd && dIPStart.Year()==dCtrEnd.Year()){
               					 endDate = dCtrEnd;
                				}
                				else{
                            endDate = dCYFiscalEnd;}
                        }else{
                        	if(dIPStart<dCtrEnd && dIPStart.Year()==dCtrEnd.Year()){
               					 endDate = dCtrEnd;
                				}else{
                            endDate = dCYq3E;}
                        }
                    }else{
                    	if(dIPStart<dCtrEnd && dIPStart.Year()==dCtrEnd.Year()){
               					 endDate = dCtrEnd;
                				}else{
                            endDate = dCYq2E;}
                        }
                }else{
                		if(dIPStart<dCtrEnd && dIPStart.Year()==dCtrEnd.Year()){
               					 endDate = dCtrEnd;
                				}else{
                            endDate = dCYq1E;}
                    }
                
                varGapMonths = 3;
              }     
                    
                    Integer endDays = Date.daysInMonth(endDate.year(), endDate.Month());
                    endDate =  date.newInstance(endDate.year(),  endDate.Month(), endDays);      
                    Date endDateY1;
                    System.debug('**endDateY1**'+endDateY1);
                for(integer i=1;i<=integer.valueof(objIP.Length_Years__c) * integer.valueof(selectopt);i++){
                   if(i==1){    
                                  objPeriod = new Period__c(Implementation_Period__c = objIP.Id,Type__c = 'Reporting',
                                Start_Date__c = objIP.Start_Date__c,End_Date__c =endDate ,Period_Number__c = i,PU__c = true,PU_Due_Date__c=endDate.addDays(42));
                            
                            }    
                    if(i>1 && i!= integer.valueof(objIP.Length_Years__c) * integer.valueof(selectopt)){
                    	System.debug('**endDateY1**'+endDateY1);
                    Date startDateSecond = endDateY1.addDays(1); 
                    endDateY1 = endDateY1.addMonths(varGapMonths);
                    Integer endDaysSecond = Date.daysInMonth(endDateY1.year(), endDateY1.Month());
                    endDateY1 =  date.newInstance(endDateY1.year(),  endDateY1.Month(), endDaysSecond);
                    if(endDateY1 >= objIP.End_Date__c ){
                    endDateY1 = objIP.End_Date__c;
                    objPeriod = new Period__c(Implementation_Period__c = objIP.Id,Type__c = 'Reporting',
                                Start_Date__c = startDateSecond ,End_Date__c = endDateY1,Period_Number__c = i,PU__c =true,DR__c=true,Due_Date__c=objIP.End_Date__c.addDays(-42),PU_Due_Date__c=objIP.End_Date__c.addDays(42));
                    lstPeriodToInsert.add(objPeriod);       
                    break;
                    }
                     objPeriod = new Period__c(Implementation_Period__c = objIP.Id,Type__c = 'Reporting',
                                Start_Date__c = startDateSecond ,End_Date__c = endDateY1,Period_Number__c = i,PU__c =true,PU_Due_Date__c=endDateY1.addDays(42));
                                //endDateY2 = endDateY1.addYears(i-2);
                    }
                    
                    
                    if(i == integer.valueof(objIP.Length_Years__c) * integer.valueof(selectopt)){
                     objPeriod = new Period__c(Implementation_Period__c = objIP.Id,Type__c = 'Reporting',
                                Start_Date__c = endDateY1.addDays(1),End_Date__c =objIP.End_Date__c ,Period_Number__c = i,PU__c =true,DR__c=true,Due_Date__c=objIP.End_Date__c.addDays(-42),PU_Due_Date__c=objIP.End_Date__c.addDays(42));
                     
                    }
                    system.debug('**selectopt**'+selectopt);
                    if(selectopt=='1'){
                        objPeriod.Frequency__c = '1';
                        lstIP[0].Reporting_Frequency__c = 'Yearly';
                    }else
                    if(selectopt=='2'){
                        objPeriod.Frequency__c = '2';
                        lstIP[0].Reporting_Frequency__c = 'Semesterly';
                    }else{
                        objPeriod.Frequency__c = '4';
                        lstIP[0].Reporting_Frequency__c = 'Quarterly';
                    }
                    lstPeriodToInsert.add(objPeriod);
                   endDateY1 =objPeriod.End_Date__c ;
                  
                }
                    
               
        }else{
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Kindly Enter Country Start and End Dates'));
        }
       }else{
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Kindly Enter Implementation Start and End Dates'));
        }
     }  
     
        if(lstPeriodToInsert.size() > 0){ 
        	insert lstPeriodToInsert;
        	update lstIP;
        	}
     	GeneratePeriod12();
        if(!Test.isRunningTest()){
        if(lstRP.size()>0){
        system.debug('**inside IF of period size greater than 0'+lstRP);
        delete lstRP;
        }
        }
        lstRP = new List<Period__c>();
          
        lstRP = [Select Id, Period_Number__c,Start_Date__c,End_Date__c,Due_Date__c,PU__c,DR__c,EFR__c,Period_Length__c,Document__c, Audit_Report__c,AR_Due_Date__c,EFR_Due_Date__c,PU_Due_Date__c,Frequency__c  From Period__c Where Implementation_Period__c =: strGIPID And Type__c = 'Reporting' And Flow_to_GrantIndicator__c =false Order by Period_Number__c];
        blnGenPeriod = true;
        blnChangePer = false;
        
        
        
        PageReference pageRef = new PageReference('/apex/ReportingPeriods?id=' + strPageId );
       	pageRef.setRedirect(true);
       	return pageRef;
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
    
    /**************************************************************************************************************************
    Purpose :Function to Save Records to Period Object After clicking on Save and if Uncheck reset the Date Value to null 
    **************************************************************************************************************************/
    Public void noOperation() {
    }
    Public PageReference SaveDoc(){
    Integer SaveDocIndex = integer.valueof(Apexpages.currentpage().getparameters().get('SaveDocIndex'));
    //SaveDocIndex =SaveDocIndex-1;
    System.debug('**SaveDocIndex'+SaveDocIndex);
     
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
            if(lstRP[SaveDocIndex].AR_Due_Date__c<dateIPStart || lstRP[SaveDocIndex].AR_Due_Date__c>dateIPEnd ){
            blnErr = true;
            //blnAddDocument = true;    
            }else{
            blnErr = false;
            }
    }
    }
    
    if(blnErr == false){
    if(lstRP[SaveDocIndex].EFR__c==true){
            if(lstRP[SaveDocIndex].EFR_Due_Date__c<dateIPStart || lstRP[SaveDocIndex].EFR_Due_Date__c>dateIPEnd ){
            blnErr = true;
            }else{
            blnErr = false;
            }
    }
    }
    
    if(blnErr == false){
     if(lstRP[SaveDocIndex].PU__c==true ){
            if(lstRP[SaveDocIndex].PU_Due_Date__c<dateIPStart || lstRP[SaveDocIndex].PU_Due_Date__c>dateIPEnd ){
            blnErr = true;
            }else{
            //blnErr = false;
            }
    
    }
    }
    
    if(blnErr == false){
    if(lstRP[SaveDocIndex].DR__c==true){
        system.debug('**inside first IF in DR');
            if(lstRP[SaveDocIndex].Due_Date__c != dateCtrFiscalEnd){
                system.debug('**inside second IF in DR');
                blnErr = true;
                blnDR = true;
            }else{
                system.debug('**inside first else in DR');
            blnDR = false;
            }
            if(blnDR == true){
                system.debug('**inside third IF in DR');
            if(lstRP[SaveDocIndex].Due_Date__c<dateIPStart || lstRP[SaveDocIndex].Due_Date__c>dateIPEnd){
            system.debug('**inside fourth IF in DR');
            blnErr = true;
            blnDR = true;
            }else{
                system.debug('**inside second else in DR');
            blnErr = false;
            }
            }               
         
          }
       if( lstRP[SaveDocIndex].Due_Date__c == dateCtrFiscalEnd){
       blnErr = false;
       }
    }
     
      if(blnErr == false){     
    update lstRP[SaveDocIndex];
    
    System.debug('**ListDocIndex'+lstRP[SaveDocIndex]);
    blnAddDocument = false;
    PageReference pageRef = new PageReference('/apex/ReportingPeriods?id=' + strPageId );
    pageRef.setRedirect(true);
    return pageRef;
    }else{
    blnAddDocument = true;
    return null;
    }
    
    /*if(lstRP[SaveDocIndex].Audit_Report__c==false){
    lstRP[SaveDocIndex].AR_Due_Date__c = null;
    }
    
    if(lstRP[SaveDocIndex].EFR__c==false){
    lstRP[SaveDocIndex].EFR_Due_Date__c = null;
    }
     if(lstRP[SaveDocIndex].PU__c==false){
    lstRP[SaveDocIndex].PU_Due_Date__c = null;
    } 
     if(lstRP[SaveDocIndex].DR__c==false){
    lstRP[SaveDocIndex].Due_Date__c = null;
    }     
    update lstRP[SaveDocIndex];
    
    System.debug('**ListDocIndex'+lstRP[SaveDocIndex]);
    blnAddDocument = false;*/
    
    
    
    }
    
    
    Public void CancelDocPopup(){
    blnAddDocument = false;
    }
    
        
    Public void ShowHistoryPopup(){
                
            blnHistory = true;
            system.debug('Bln:'+ blnHistory);            
        }  
    
    //History Popup Close         
    Public void HideHistoryPopup(){
                
            blnHistory = false;
            system.debug('Bln:'+ blnHistory);            
        }  
    public void GeneratePeriod12(){
    	system.debug('**Inside Generate period 12');
     List<Implementation_Period__c> lstImplementationPeriod = [Select Id,Concept_Note__r.Implementation_Period_Page_Template__c,
                                        Start_Date__c,End_Date__c,Length_Years__c,Principal_Recipient__r.Country__r.Country_Fiscal_Cycle_End_Date__c,Principal_Recipient__r.Country__r.Country_Fiscal_Cycle_Start_Date__c
                                        From Implementation_Period__c Where Id =: strGIPID];
        //system.debug('$$lstImplementationPeriod$$$'+lstImplementationPeriod);
        List<Period__c> lstPeriodToInsert = new List<Period__c>();
        List<Result__c> lstResulttoinsert = new List<Result__c>();
        Period__c objPeriod;
        system.debug('**Inside lstIPGIFreq'+lstIPGIFreq.size());
        for(Implementation_Period__c objIP : lstImplementationPeriod){
        if(objIP.Length_Years__c != null && objIP.Start_Date__c != null && objIP.End_Date__c != null && lstIPGIFreq.size()==0){
             
             if( objIP.Principal_Recipient__r.Country__r.Country_Fiscal_Cycle_Start_Date__c !=null && objIP.Principal_Recipient__r.Country__r.Country_Fiscal_Cycle_End_Date__c !=null){
             Date dCtrStart = objIP.Principal_Recipient__r.Country__r.Country_Fiscal_Cycle_Start_Date__c;
             Date dCtrEnd = objIP.Principal_Recipient__r.Country__r.Country_Fiscal_Cycle_End_Date__c;
             
             Date dIPStart = objIP.Start_Date__c;
             Date dIPEnd = objIP.End_Date__c;
             Date endDate;
             Integer Year = dIPStart.Year();
             Integer day = dCtrStart.day();
             Integer Month = dCtrStart.month();
            
             
             Date newDate =  date.newInstance(Year, Month, day);
             Date newDateEnd =  newDate.addMonths(11);
             
              
             System.debug('**newDate**'+newDate);
             System.debug('**newDateEnd**'+newDateEnd);
             
             
             Integer varGapMonths;
                Date dCYFiscalStart = newDate ;
                Date dCYFiscalEnd = newDateEnd ;
                endDate = dCYFiscalEnd;
                if(dIPStart<dCtrEnd && dIPStart.Year()==dCtrEnd.Year()){
                endDate = dCtrEnd;
                }
                
                System.debug('**endDate**'+endDate); 
                varGapMonths = 12;
                    Integer endDays = Date.daysInMonth(endDate.year(), endDate.Month());
                    endDate =  date.newInstance(endDate.year(),  endDate.Month(), endDays);      
                    Date endDateY1;
                for(integer i=1;i<=integer.valueof(objIP.Length_Years__c) * integer.valueof(selectopt);i++){
                   if(i==1){    
                                  objPeriod = new Period__c(Implementation_Period__c = objIP.Id,Type__c = 'Reporting',
                                Start_Date__c = objIP.Start_Date__c,End_Date__c =endDate,Flow_to_GrantIndicator__c =true ); 
                            
                            }    
                    if(i>1 && i!= integer.valueof(objIP.Length_Years__c) * integer.valueof(selectopt)){
                    System.debug('**endDateY1**'+endDateY1);
                    Date startDateSecond = endDateY1.addDays(1); 
                    endDateY1 = endDateY1.addMonths(varGapMonths);
                    Integer endDaysSecond = Date.daysInMonth(endDateY1.year(), endDateY1.Month());
                    endDateY1 =  date.newInstance(endDateY1.year(),  endDateY1.Month(), endDaysSecond);
                    if(endDateY1 >= objIP.End_Date__c ){
                    endDateY1 = objIP.End_Date__c;
                    objPeriod = new Period__c(Implementation_Period__c = objIP.Id,Type__c = 'Reporting',
                                Start_Date__c = startDateSecond ,End_Date__c = endDateY1,Flow_to_GrantIndicator__c =true);
                    lstPeriodToInsert.add(objPeriod);       
                    break;
                    }
                     objPeriod = new Period__c(Implementation_Period__c = objIP.Id,Type__c = 'Reporting',
                                Start_Date__c = startDateSecond ,End_Date__c = endDateY1,Flow_to_GrantIndicator__c =true);
                                //endDateY2 = endDateY1.addYears(i-2);
                    }
                    
                    
                    if(i == integer.valueof(objIP.Length_Years__c) * integer.valueof(selectopt)){
                     objPeriod = new Period__c(Implementation_Period__c = objIP.Id,Type__c = 'Reporting',
                                Start_Date__c = endDateY1.addDays(1),End_Date__c =objIP.End_Date__c ,Flow_to_GrantIndicator__c =true);
                     
                    }
                    lstPeriodToInsert.add(objPeriod);
                   endDateY1 =objPeriod.End_Date__c ;
    			 }
    			   if(lstPeriodToInsert.size() > 0){ 
        			insert lstPeriodToInsert;
        				
        			}
           	   }
             }
           }
        }
    public void checkProfile(){
         Id profileId=userinfo.getProfileId();
         String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
     
      List<Profile_Access_Setting__c> checkpage = [Select Salesforce_Item__c from Profile_Access_Setting__c where Page_Name__c ='ReportingPeriods' and Profile_Name__c =: profilename];
      system.debug(checkpage);
      for (Profile_Access_Setting__c check : checkpage){
        if (check.Salesforce_Item__c == 'External Profile') blnExternalPro = true;
        if(check.Salesforce_Item__c == 'Edit Period Button')blnEdit = true;
        if(check.Salesforce_Item__c == 'Period Document Due Date')blnDueDate  = true;
        if(check.Salesforce_Item__c == 'Choose Reporting Frequency')blnRepFrequency = true;
        if(check.Salesforce_Item__c == 'Change Frequency')blnChangeFreq = true;
        }
    }
    

   
    
}