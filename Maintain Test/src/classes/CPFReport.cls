Public class CPFReport{
    
    Public List<WrapperFundingSource> lstWrapperFundingSourceNSF {get;set;}
    Public List<WrapperFundingSource> lstWrapperFundingSourceB {get;set;}
    Public List<WrapperFundingSource> lstWrapperFundingSourceC {get;set;}
    Public List<WrapperFundingSource> lstWrapperFundingSourceD {get;set;}
    Public List<WrapperFundingSource> lstWrapperFundingSourceJ {get;set;}
    Public List<WrapperFundingSource> lstWrapperFundingSourceI {get;set;}
    
    Public List<Funding_Source__c> lstFundingSource;
    Public String strCPFReportId {get;set;}
    Public Map<String,String> MapDisplayMonth {get;set;}
    Public String strStartMonth {get;set;}
    Public String strEndMonth {get;set;}
   
    Public Integer intCurrentYear {get;set;}
    Public CPF_Report__c objCPFReport {get;set;}
    Public Decimal TotalK1 {get;set;}
    Public Decimal TotalK2 {get;set;}
    Public Decimal TotalK {get;set;}
    Public Decimal LAverage {get;set;}
    Public Id RecordTypeIdC;
    Public String strCNId {get;set;}
    Public String strCountryId {get;set;}
    Public String strGuidanceId {get;set;}
    Public String strLanguage {get;set;}
    Public String strComponent {get;set;}
    Public String strFiscalCycleRange {get;set;}
    
    //These are no longer used. A trigger does this aggregation outside of the page.
    Public Decimal AboveIndicativeY1 {get;set;}
    Public Decimal AboveIndicativeY2{get;set;}
    Public Decimal AboveIndicativeY3{get;set;}
    Public Decimal AboveIndicativeY4{get;set;}
    Public Decimal IndicativeY1{get;set;}
    Public Decimal IndicativeY2{get;set;}
    Public Decimal IndicativeY3{get;set;}
    Public Decimal IndicativeY4{get;set;}
    Public Decimal TotalY1{get;set;}
    Public Decimal TotalY2{get;set;}
    Public Decimal TotalY3{get;set;}
    Public Decimal TotalY4{get;set;}
    
    
    Public Decimal MAverage{get;set;}
    Public Decimal NAverage{get;set;}
    Public Decimal OAverage{get;set;}
    Public Decimal PAverage{get;set;}
    Public Decimal AnnualAnticipatedFundingGapMinus2{get;set;}
    Public Decimal AnnualAnticipatedFundingGapMinus1{get;set;}
    Public Decimal AnnualAnticipatedFundingGapCurr{get;set;}
    Public Decimal AnnualAnticipatedFundingGap1{get;set;}
    Public Decimal AnnualAnticipatedFundingGap2{get;set;}
    Public Decimal AnnualAnticipatedFundingGap3{get;set;}
    Public Decimal AnnualAnticipatedFundingGap4{get;set;}
    Public Decimal AnnualAnticipatedFundingGap5{get;set;}
    Public Decimal GCurrentYear{get;set;}
    Public Decimal GYearPlus1{get;set;}
    Public Decimal GYearPlus2{get;set;}
    Public Decimal GYearPlus3{get;set;}
    Public Decimal GYearPlus4{get;set;}
    Public Decimal GYearPlus5{get;set;}
    Public Decimal HCurrentYear{get;set;}
    Public Decimal HYearPlus1{get;set;}
    Public Decimal HYearPlus2{get;set;}
    Public Decimal HYearPlus3{get;set;}
    Public Decimal HYearPlus4{get;set;}
    Public Decimal HYearPlus5{get;set;}
    Public Decimal ICurrentYear{get;set;}
    Public Decimal IYearPlus1{get;set;}
    Public Decimal IYearPlus2{get;set;}
    Public Decimal IYearPlus3{get;set;}
    Public Decimal IYearPlus4{get;set;}
    Public Decimal IYearPlus5{get;set;}
    
    
    Public List<CPF_Report__c> lstCPFRetrive {get;set;}
    
    Public String strImplementCycle {get;set;}
    Public Boolean blnHistory {get;set;}
    Public String objAPIName {get;set;}
    Public String objRecordId {get;set;}
    Public String objRecordName {get;set;}
    Public Boolean blnReadOnly {get;set;}
    
    //TCS 10/09/2014: Variables for Profile Access
    Public Boolean blnExternalPro {get;set;}
    Public Boolean blnSaveDraft {get;set;}
    Public Boolean blnSaveReturn    {get;set;}
    Public Boolean blnCCMComments   {get;set;}
    Public Boolean blnLFAComments {get;set;}
    Public Boolean blnTGFComments {get;set;}
    Public Boolean blnIPFields {get;set;}
    Public Boolean blnDel {get;set;}
    public String strStatus ;
    
    //Define constructor.
    Public CPFReport(ApexPages.StandardController stdController) {
        strCPFReportId = ApexPages.currentPage().getParameters().get('Id');
        lstCPFRetrive = new List<CPF_Report__c>();  
        strFiscalCycleRange=Label.January+' - '+Label.December;      
        blnIPFields = false;
        if(!String.IsBlank(strCPFReportId)) {
            RetrieveFundingSource();
        }
        List<Guidance__c> lstGuidance = [Select Id from Guidance__c where Name = 'Financial Gap Analysis & Counterpart Financing'];
            if(!lstGuidance.isEmpty()) {
              strGuidanceId = lstGuidance[0].Id; }
        
        blnHistory = false;
    }
    Public void actionShowHistoryPopUp(){
        blnHistory = true;
    }
    Public void HidePopupHistory(){
        blnHistory = false;
    }
    
    Public ApexPages.Component getshowHistoryPopup(){
        objRecordId = ApexPages.currentPage().getParameters().get('pramRecordId');
        objRecordName = ApexPages.currentPage().getParameters().get('pramRecordName');
        system.debug('objRecordId: '+ objRecordId);
        system.debug('objRecordName: '+ objRecordName);
        system.debug('blnHistory: '+ blnHistory);
        Component.c.FieldHistory obj;
        if(objRecordId !=null){
            obj = new Component.c.FieldHistory(TargetRecordId=objRecordId , TagetObjectAPIname='Funding_Source__c', RecordTitle= objRecordName );
            system.debug('obj:' + obj );
        }
        return obj;
    }
    Public void RetrieveFundingSource(){
        RecordTypeIdC = [Select id From RecordType Where sobjectType = 'Funding_Source__c' and DeveloperName = 'C'].Id;           
        List<CPF_Report__c> lstCPFReport = [Select Id, Start_Year__c,Revised_Start_Year__c,IsRevised__c, National_Strategic_Funding_Total__c ,Funding_Request_in_Indicative_Year_1__c,country__c,Concept_Note__r.CCM_new__r.Country__r.Country_Fiscal_Cycle_Months__c,
                Concept_Note__r.Status__c, Concept_Note__r.Component__c, Funding_Request_in_Indicative_Year_2__c,Funding_Request_in_Indicative_Year_3__c,country__r.Country_Fiscal_Cycle_Months__c, A_Current_Year__c, A_Year_plus_1__c, A_Year_plus_2__c, A_Year_plus_3__c,
                D_Year_2_Total__c,D_Year_1_Total__c,D_Current_Year_Total__c,D_Year_plus_1_Total__c,D_Year_plus_2_Total__c,D_Year_3_Total__c,
                Funding_Request_above_Indicative_Year_1__c,Funding_Request_above_Indicative_Year_2__c,Anticipated_Resources_Current_Year__c,Anticipated_Resources_Year_1__c,Anticipated_Resources_Year_2__c,Anticipated_Resources_Year_3__c  ,
                Cycle_Start_Month__c,Cycle_End_Month__c,Implementation_cycle__c,Reporting_Cycle__c,Concept_Note__c,Concept_Note__r.Language__c,
                Funding_Request_above_Indicative_Year_3__c,Above_Indicative_Y1__c, Above_Indicative_Y2__c, Above_Indicative_Y3__c,Above_Indicative_Y4__c,
                Indicative_Y1__c,Indicative_Y2__c,Indicative_Y3__c, Indicative_Y4__c, Total_Y1__c, Total_Y2__c, Total_Y3__c, Total_Y4__c, CurrencyIsoCode,A_Year_1__c,A_Year_2__c,A_Year_plus_4__c,A_Year_plus_5__c,National_Strategic_Funding_Total_Current__c,
                B_Year_plus_4_Total__c,B_Year_plus_5_Total__c,C_Year_plus_4_Total__c,C_Year_plus_5_Total__c,D_Year_plus_4_Total__c,D_Year_plus_5_Total__c,Anticipated_Resources_Year_4__c,Anticipated_Resources_Year_5__c,Anticipated_Resources_1_Year__c,
				Anticipated_Resources_2_Year__c,Anticipated_Resources_Total_Current__c,
				G_Current_Year__c,H_Current_Year__c,I_Current_Year__c,G_Year_plus_1__c,H_Year_plus_1__c,I_Year_plus_1__c,G_Year_plus_2__c,H_Year_plus_2__c,I_Year_plus_2__c,G_Year_plus_3__c,H_Year_plus_3__c,I_Year_plus_3__c,G_Year_plus_4__c,H_Year_plus_4__c,
				I_Year_plus_4__c,G_Year_plus_5__c,H_Year_plus_5__c,I_Year_plus_5__c
                From CPF_Report__c Where Id =:strCPFReportId];               

        objCPFReport = new CPF_Report__c();
        //blnReadOnly = CheckProfile.checkProfile();
        
        if(lstCPFReport.size() > 0){
            objCPFReport = lstCPFReport[0];               
            if(objCPFReport.Concept_Note__c != null){
                strCNId = lstCPFReport[0].Concept_Note__c;
                strComponent = lstCPFReport[0].Concept_Note__r.Component__c;
                strStatus = lstCPFReport[0].Concept_Note__r.Status__c;
                /*if(lstCPFReport[0].Concept_Note__r.Status__c == 'Submitted to the Global Fund'  && CheckProfile.checkProfileGF()==false){
                    blnReadOnly = true; 
                }else if(lstCPFReport[0].Concept_Note__r.Status__c == 'Not yet submitted'){
                    blnReadOnly = CheckProfile.checkProfile();
                }*/
                system.debug('strStatus'+strStatus);
                checkProfile();
                 system.debug('blnSaveDraft'+blnSaveDraft);
                   system.debug('blnSaveReturn'+blnSaveReturn);
                //testing Read-Only:
                //blnReadOnly = true;
                
                //Running update on Grant Intervention records
                    Set<Id> cnIds = new Set<Id>();
                    cnIds.add(lstCPFReport[0].Concept_Note__c);
                    //updateCPFGrantInterventions.updateCPF(cnIds);
                strLanguage = lstCPFReport[0].Concept_Note__r.Language__c;
              /*   strLanguage = 'ENGLISH';
            if(System.UserInfo.getLanguage() == 'fr'){
                strLanguage = 'FRENCH'; }
            if(System.UserInfo.getLanguage() == 'ru'){
                strLanguage = 'RUSSIAN'; }
            if(System.UserInfo.getLanguage() == 'es'){
                strLanguage = 'SPANISH'; }
            */
                
                strCountryId = lstCPFReport[0].Country__c;
                /*List<AggregateResult> lstIndicativeValues = [Select Sum(Above_Indicative_Y1__c) AY1,
                                            Sum(Above_Indicative_Y2__c) AY2,Sum(Above_Indicative_Y3__c) AY3,
                                            Sum(Above_Indicative_Y4__c) AY4,Sum(Indicative_Y4__c) Y4,
                                            Sum(Indicative_Y1__c) Y1,Sum(Indicative_Y2__c) Y2,
                                            Sum(Indicative_Y3__c) Y3 From Grant_Intervention__c 
                                            Where Implementation_Period__r.concept_Note__c =: strCNId];
                if(lstIndicativeValues.size() > 0){
                    AboveIndicativeY1 = (Decimal)lstIndicativeValues[0].get('AY1');
                    AboveIndicativeY2 = (Decimal)lstIndicativeValues[0].get('AY2');
                    AboveIndicativeY3 = (Decimal)lstIndicativeValues[0].get('AY3');
                    AboveIndicativeY4 = (Decimal)lstIndicativeValues[0].get('AY4');
                    IndicativeY1 = (Decimal)lstIndicativeValues[0].get('Y1');
                    IndicativeY2 = (Decimal)lstIndicativeValues[0].get('Y2');
                    IndicativeY3 = (Decimal)lstIndicativeValues[0].get('Y3');
                    IndicativeY4 = (Decimal)lstIndicativeValues[0].get('Y4');
                    if(IndicativeY1 == null) IndicativeY1 = 0;
                    if(IndicativeY2 == null) IndicativeY2 = 0;
                    if(IndicativeY3 == null) IndicativeY3 = 0;
                    if(IndicativeY4 == null) IndicativeY4 = 0;
                    if(AboveIndicativeY1 == null) AboveIndicativeY1 = 0;
                    if(AboveIndicativeY2 == null) AboveIndicativeY2 = 0;
                    if(AboveIndicativeY3 == null) AboveIndicativeY3 = 0;
                    if(AboveIndicativeY4 == null) AboveIndicativeY4 = 0;
                    TotalY1 = IndicativeY1 + AboveIndicativeY1;
                    TotalY2 = IndicativeY2 + AboveIndicativeY2;
                    TotalY3 = IndicativeY3 + AboveIndicativeY3;
                    TotalY4 = IndicativeY4 + AboveIndicativeY4;
                }*/
                
            }
            
            /*Decimal MTotal_Temp = 0;
            Integer FinalDivideCountM = 0;
            if(objCPFReport.Indicative_Y1__c != null && objCPFReport.Indicative_Y1__c != 0){
                MTotal_Temp += objCPFReport.Indicative_Y1__c;
                FinalDivideCountM++;
            }
            if(objCPFReport.Indicative_Y2__c != null && objCPFReport.Indicative_Y2__c != 0){
                MTotal_Temp += objCPFReport.Indicative_Y2__c;
                FinalDivideCountM++;
            }
            if(objCPFReport.Indicative_Y3__c != null && objCPFReport.Indicative_Y3__c != 0){
                MTotal_Temp += objCPFReport.Indicative_Y3__c;
                FinalDivideCountM++;
            }
            if(objCPFReport.Indicative_Y4__c != null && objCPFReport.Indicative_Y4__c != 0){
                MTotal_Temp += objCPFReport.Indicative_Y4__c;
                FinalDivideCountM++;
            }
            
            if(FinalDivideCountM != 0) MAverage = MTotal_Temp / FinalDivideCountM;
              else MAverage = 0;
            if(MAverage != 0){
                MAverage = MAverage.setScale(0, System.roundingMode.HALF_UP);
            }
            system.debug('MAverage'+MAverage);
            Decimal OTotal_Temp = 0;
            Integer FinalDivideCountO = 0;
            
            if(objCPFReport.Total_Y1__c!= null && objCPFReport.Total_Y1__c != 0){
                OTotal_Temp += objCPFReport.Total_Y1__c;
                FinalDivideCountO++;
            }
            if(objCPFReport.Total_Y2__c!= null && objCPFReport.Total_Y2__c != 0){
                OTotal_Temp += objCPFReport.Total_Y2__c;   
                FinalDivideCountO++;        
            }
            if(objCPFReport.Total_Y3__c!= null && objCPFReport.Total_Y3__c != 0){
                OTotal_Temp += objCPFReport.Total_Y3__c;  
                FinalDivideCountO++;      
            }
            if(objCPFReport.Total_Y4__c!= null && objCPFReport.Total_Y4__c != 0){
                OTotal_Temp += objCPFReport.Total_Y4__c; 
                FinalDivideCountO++;       
            }
            if(FinalDivideCountO != 0) OAverage = OTotal_Temp/FinalDivideCountO;
              else OAverage = 0;
            if(OAverage != 0){
                OAverage = OAverage.setScale(0, System.roundingMode.HALF_UP);
            }*/
           
            /* Start Change on 1 jan 2015 as a part of Financial Gap Sprint 2 US */
            /* Line G*/
            if(objCPFReport.G_Current_Year__c != null )
            {
            GCurrentYear=objCPFReport.G_Current_Year__c;
            }else
            {
            GCurrentYear=objCPFReport.Total_Y1__c;
            }
            
            if(objCPFReport.G_Year_plus_1__c != null )
            {
            GYearPlus1=objCPFReport.G_Year_plus_1__c;
            }else
            {
            GYearPlus1=objCPFReport.Total_Y2__c;
            }
            
            if(objCPFReport.G_Year_plus_2__c != null )
            {
            GYearPlus2=objCPFReport.G_Year_plus_2__c;
            }else
            {
            GYearPlus2=objCPFReport.Total_Y3__c;
            }
            
            if(objCPFReport.G_Year_plus_3__c != null )
            {
            GYearPlus3=objCPFReport.G_Year_plus_3__c;
            }else
            {
            GYearPlus3=objCPFReport.Total_Y4__c;
            }
			
			 /* Line H*/
			if(objCPFReport.H_Current_Year__c != null )
            {
            HCurrentYear=objCPFReport.H_Current_Year__c;
            }else
            {
            HCurrentYear=objCPFReport.Indicative_Y1__c;
            }
            
            if(objCPFReport.H_Year_plus_1__c != null )
            {
            HYearPlus1=objCPFReport.H_Year_plus_1__c;
            }else
            {
            HYearPlus1=objCPFReport.Indicative_Y2__c;
            }
            
            if(objCPFReport.H_Year_plus_2__c != null )
            {
            HYearPlus2=objCPFReport.H_Year_plus_2__c;
            }else
            {
            HYearPlus2=objCPFReport.Indicative_Y3__c;
            }
            
            if(objCPFReport.H_Year_plus_3__c != null )
            {
            HYearPlus3=objCPFReport.H_Year_plus_3__c;
            }else
            {
            HYearPlus3=objCPFReport.Indicative_Y4__c;
            }
            
             /* Line I*/
            if(objCPFReport.I_Current_Year__c != null )
            {
            ICurrentYear=objCPFReport.I_Current_Year__c;
            }else
            {
            ICurrentYear=objCPFReport.Above_Indicative_Y1__c;
            } 
            
            if(objCPFReport.I_Year_plus_1__c != null )
            {
            IYearPlus1=objCPFReport.I_Year_plus_1__c ;
            }else
            {
            IYearPlus1=objCPFReport.Above_Indicative_Y2__c;
            } 
            
            if(objCPFReport.I_Year_plus_2__c != null )
            {
            IYearPlus2=objCPFReport.I_Year_plus_2__c;
            }else
            {
            IYearPlus2=objCPFReport.Above_Indicative_Y3__c;
            } 
            
            if(objCPFReport.I_Year_plus_3__c != null )
            {
            IYearPlus3=objCPFReport.I_Year_plus_3__c;
            }else
            {
            IYearPlus3=objCPFReport.Above_Indicative_Y4__c;
            } 
            
            }
           
            /* End */
           	Decimal MTotal_Temp = 0;
            Integer FinalDivideCountM = 0;
            //if(HCurrentYear != null && HCurrentYear != 0){
            if(HCurrentYear != null ){
                MTotal_Temp += HCurrentYear;
                FinalDivideCountM++;
            }
            if(HYearPlus1 != null ){
                MTotal_Temp += HYearPlus1;
                FinalDivideCountM++;
            }
            if(HYearPlus2 != null ){
                MTotal_Temp += HYearPlus2;
                FinalDivideCountM++;
            }
            if(HYearPlus3 != null ){
                MTotal_Temp += HYearPlus3;
                FinalDivideCountM++;
            }
            if(objCPFReport.H_Year_plus_4__c != null ){
                MTotal_Temp += objCPFReport.H_Year_plus_4__c;
                FinalDivideCountM++;
            }
            if(objCPFReport.H_Year_plus_5__c != null ){
                MTotal_Temp += objCPFReport.H_Year_plus_5__c;
                FinalDivideCountM++;
            }
            
            if(FinalDivideCountM != 0) MAverage = MTotal_Temp / FinalDivideCountM;
              else MAverage = 0;
            if(MAverage != 0){
                MAverage = MAverage.setScale(0, System.roundingMode.HALF_UP);
            }
            system.debug('MAverage'+MAverage);
            Decimal OTotal_Temp = 0;
            Integer FinalDivideCountO = 0;
            
            if(GCurrentYear != null ){
                OTotal_Temp += GCurrentYear;
                FinalDivideCountO++;
            }
            if(GYearPlus1 != null ){
                OTotal_Temp += GYearPlus1;   
                FinalDivideCountO++;        
            }
            if(GYearPlus2 != null ){
                OTotal_Temp += GYearPlus2;  
                FinalDivideCountO++;      
            }
            if(GYearPlus3 != null ){
                OTotal_Temp += GYearPlus3; 
                FinalDivideCountO++;       
            }
            if(objCPFReport.G_Year_plus_4__c != null ){
                OTotal_Temp += objCPFReport.G_Year_plus_4__c; 
                FinalDivideCountO++;       
            }
            if(objCPFReport.G_Year_plus_5__c != null ){
                OTotal_Temp += objCPFReport.G_Year_plus_5__c; 
                FinalDivideCountO++;       
            }
            
            if(FinalDivideCountO != 0) OAverage = OTotal_Temp/FinalDivideCountO;
              else OAverage = 0;
            if(OAverage != 0){
                OAverage = OAverage.setScale(0, System.roundingMode.HALF_UP);
            }
            system.debug('OAverage'+OAverage);
            /*AnnualAnticipatedFundingGap1 = objCPFReport.A_Year_plus_1__c - objCPFReport.Anticipated_Resources_Year_1__c;
            AnnualAnticipatedFundingGap2 = objCPFReport.A_Year_plus_2__c - objCPFReport.Anticipated_Resources_Year_2__c;
            AnnualAnticipatedFundingGap3 = objCPFReport.A_Year_plus_3__c - objCPFReport.Anticipated_Resources_Year_3__c;*/
            
        //}            
        
        lstFundingSource = new List<Funding_Source__c>([Select Name,Id,CCM_Comments__c,CCM_Comments_French__c, CCM_Comments_Spanish__c, CCM_Comments_Russian__c,
                                                    RecordType.DeveloperName,CPF_Report__c,Current_Year__c,External_Source_Type__c,  Global_Fund_Comments__c,
                                                    Grant_Number__c,LFA_Comments__c,National_Strategic_Funding_Total__c,Other_External_Source__c,
                                                    Type__c,Year_plus_1__c,Year_plus_2__c,Year_plus_3__c,Year_1__c,Year_2__c ,Year_plus_4__c,Year_plus_5__c,
                                                    National_Strategic_Funding_Total_Current__c
                                                    From Funding_Source__c Where CPF_Report__c =: strCPFReportId  Order By RecordType.DeveloperName,Type__c NULLS LAST]);  
        MapDisplayMonth = new Map<String,String>();
        MapDisplayMonth.put(Label.January,'01');
        MapDisplayMonth.put(Label.February,'02');
        MapDisplayMonth.put(Label.March,'03');
        MapDisplayMonth.put(Label.April,'04');
        MapDisplayMonth.put(Label.May,'05');
        MapDisplayMonth.put(Label.June,'06');
        MapDisplayMonth.put(Label.July,'07');
        MapDisplayMonth.put(Label.August,'08');
        MapDisplayMonth.put(Label.September,'09');
        MapDisplayMonth.put(Label.October,'10');
        MapDisplayMonth.put(Label.November,'11');
        MapDisplayMonth.put(Label.December,'12');
        // strImplementCycle
        
        if(objCPFReport.Concept_Note__c != null){
            strImplementCycle = objCPFReport.Concept_Note__r.CCM_new__r.Country__r.Country_Fiscal_Cycle_Months__c;
        }else{
            if(objCPFReport.country__c != null){
                strImplementCycle = objCPFReport.country__r.Country_Fiscal_Cycle_Months__c;
            }
        }
        if(strImplementCycle != null){
            list<String> lstSplitMonth = strImplementCycle.split(' - ');
            if(lstSplitMonth!=null && lstSplitMonth.size()>1){
                String StartMonth = lstSplitMonth[0];
                String EndMonth = lstSplitMonth[1];               
                
                //Date dtetoday = system.today();
                //intCurrentYear = dtetoday.Year();
                if(objCPFReport.Start_Year__c != null) {
                  if(objCPFReport.Revised_Start_Year__c != null){
                    intCurrentYear = Integer.valueOf(objCPFReport.Revised_Start_Year__c);
                  }
                  else{	
                  intCurrentYear = Integer.valueOf(objCPFReport.Start_Year__c); 
                  }
                }
                strStartMonth = MapDisplayMonth.get(StartMonth);
                strEndMonth = MapDisplayMonth.get(EndMonth);
            }
        }
        
        FillWrapperCPFReport();  
    }
    
    //Fill Wrapper Class.
    Public void FillWrapperCPFReport() {
        
        if(lstFundingSource.Size() > 0) {
            String StrRT = '';
           // WrapperCPFReport objWrapCPFReport;// = new WrapperCPFReport();
           List<WrapperFundingSource> lstWrapperFundingSource ;
           lstWrapperFundingSourceNSF = new List<WrapperFundingSource>();
           lstWrapperFundingSourceB = new List<WrapperFundingSource>();
           lstWrapperFundingSourceC = new List<WrapperFundingSource>();
           lstWrapperFundingSourceD = new List<WrapperFundingSource>();
           lstWrapperFundingSourceJ = new List<WrapperFundingSource>();
           lstWrapperFundingSourceI = new List<WrapperFundingSource>();
            WrapperFundingSource objFS;
            for(Funding_Source__c objFunding : lstFundingSource) {
                if(StrRT != objFunding.RecordType.DeveloperName){
                   // objWrapCPFReport = new WrapperCPFReport();
                    //objWrapCPFReport.strRecordTypeName = objFunding.RecordType.DeveloperName;
                    StrRT = objFunding.RecordType.DeveloperName;
                    lstWrapperFundingSource = new List<WrapperFundingSource>();
                    if(objFunding.RecordType.DeveloperName == 'National_Strategic_Funding'){
                        lstWrapperFundingSourceNSF = lstWrapperFundingSource ;
                    }else if(objFunding.RecordType.DeveloperName == 'B'){
                        lstWrapperFundingSourceB = lstWrapperFundingSource;
                    }else if(objFunding.RecordType.DeveloperName == 'C'){
                        lstWrapperFundingSourceC = lstWrapperFundingSource;
                    }else if(objFunding.RecordType.DeveloperName == 'D'){
                        lstWrapperFundingSourceD = lstWrapperFundingSource;
                    }else if(objFunding.RecordType.DeveloperName == 'J'){
                        lstWrapperFundingSourceJ = lstWrapperFundingSource;
                    }else if(objFunding.RecordType.DeveloperName == 'I'){
                        lstWrapperFundingSourceI = lstWrapperFundingSource;
                    }
                   // lstWrapperCPFReport.add(objWrapCPFReport); 
                }
                
                objFS = new  WrapperFundingSource();
                if(objFunding.RecordType.DeveloperName == 'National_Strategic_Funding'){
                    objFS.strName = Label.Funding_Needs_NSP;  //'Total Funding needs for the National Strategic Plan (provide annual amounts)';
                    
                    if(objCPFReport.Anticipated_Resources_2_Year__c != null && objFunding.Year_2__c != null)
                        AnnualAnticipatedFundingGapMinus2 = objFunding.Current_Year__c - objCPFReport.Anticipated_Resources_2_Year__c;
                    else if(objCPFReport.Anticipated_Resources_2_Year__c == null && objFunding.Year_2__c != null) 
                        AnnualAnticipatedFundingGapMinus2 = objFunding.Year_2__c;
                    else if (objCPFReport.Anticipated_Resources_2_Year__c != null && objFunding.Year_2__c == null) 
                        AnnualAnticipatedFundingGapMinus2 = - objCPFReport.Anticipated_Resources_2_Year__c;
                        
                    if(objCPFReport.Anticipated_Resources_1_Year__c != null && objFunding.Year_1__c != null)
                        AnnualAnticipatedFundingGapMinus1 = objFunding.Year_1__c - objCPFReport.Anticipated_Resources_1_Year__c;
                    else if(objCPFReport.Anticipated_Resources_1_Year__c == null && objFunding.Year_1__c != null) 
                        AnnualAnticipatedFundingGapMinus1 = objFunding.Current_Year__c;
                    else if (objCPFReport.Anticipated_Resources_1_Year__c != null && objFunding.Year_1__c == null) 
                        AnnualAnticipatedFundingGapMinus1 = - objCPFReport.Anticipated_Resources_1_Year__c;
                    
                    if(objCPFReport.Anticipated_Resources_Current_Year__c != null && objFunding.Current_Year__c != null)
                        AnnualAnticipatedFundingGapCurr = objFunding.Current_Year__c - objCPFReport.Anticipated_Resources_Current_Year__c;
                    else if(objCPFReport.Anticipated_Resources_Current_Year__c == null && objFunding.Current_Year__c != null) 
                        AnnualAnticipatedFundingGapCurr = objFunding.Current_Year__c;
                    else if (objCPFReport.Anticipated_Resources_Current_Year__c != null && objFunding.Current_Year__c == null) 
                        AnnualAnticipatedFundingGapCurr = - objCPFReport.Anticipated_Resources_Current_Year__c;
                    
                    if(objCPFReport.Anticipated_Resources_Year_1__c != null && objFunding.Year_plus_1__c != null)
                        AnnualAnticipatedFundingGap1 = objFunding.Year_plus_1__c - objCPFReport.Anticipated_Resources_Year_1__c;
                    else if(objCPFReport.Anticipated_Resources_Year_1__c == null && objFunding.Year_plus_1__c != null) 
                        AnnualAnticipatedFundingGap1 = objFunding.Year_plus_1__c;
                    else if (objCPFReport.Anticipated_Resources_Year_1__c != null && objFunding.Year_plus_1__c == null) 
                        AnnualAnticipatedFundingGap1 = - objCPFReport.Anticipated_Resources_Year_1__c;
                        
                    if(objCPFReport.Anticipated_Resources_Year_2__c != null && objFunding.Year_plus_2__c != null)
                        AnnualAnticipatedFundingGap2 = objFunding.Year_plus_2__c - objCPFReport.Anticipated_Resources_Year_2__c;
                    else if(objCPFReport.Anticipated_Resources_Year_2__c == null && objFunding.Year_plus_2__c != null) 
                        AnnualAnticipatedFundingGap2 = objFunding.Year_plus_2__c;
                    else if (objCPFReport.Anticipated_Resources_Year_2__c != null && objFunding.Year_plus_2__c == null) 
                        AnnualAnticipatedFundingGap2 = - objCPFReport.Anticipated_Resources_Year_2__c;
                    
                    if(objCPFReport.Anticipated_Resources_Year_3__c != null && objFunding.Year_plus_3__c != null)
                        AnnualAnticipatedFundingGap3 = objFunding.Year_plus_3__c - objCPFReport.Anticipated_Resources_Year_3__c;
                    else if(objCPFReport.Anticipated_Resources_Year_3__c == null && objFunding.Year_plus_3__c != null) 
                        AnnualAnticipatedFundingGap3 = objFunding.Year_plus_3__c;
                    else if (objCPFReport.Anticipated_Resources_Year_3__c != null && objFunding.Year_plus_3__c == null) 
                        AnnualAnticipatedFundingGap3 = - objCPFReport.Anticipated_Resources_Year_3__c;
                        
                    if(objCPFReport.Anticipated_Resources_Year_4__c != null && objFunding.Year_plus_4__c != null)
                        AnnualAnticipatedFundingGap4 = objFunding.Year_plus_4__c - objCPFReport.Anticipated_Resources_Year_4__c;
                    else if(objCPFReport.Anticipated_Resources_Year_4__c == null && objFunding.Year_plus_4__c != null) 
                        AnnualAnticipatedFundingGap4 = objFunding.Year_plus_4__c;
                    else if (objCPFReport.Anticipated_Resources_Year_4__c != null && objFunding.Year_plus_4__c == null) 
                        AnnualAnticipatedFundingGap4 = - objCPFReport.Anticipated_Resources_Year_4__c;
                    
                    if(objCPFReport.Anticipated_Resources_Year_5__c != null && objFunding.Year_plus_5__c != null)
                        AnnualAnticipatedFundingGap5 = objFunding.Year_plus_5__c - objCPFReport.Anticipated_Resources_Year_5__c;
                    else if(objCPFReport.Anticipated_Resources_Year_5__c == null && objFunding.Year_plus_5__c != null) 
                        AnnualAnticipatedFundingGap5 = objFunding.Year_plus_5__c;
                    else if (objCPFReport.Anticipated_Resources_Year_5__c != null && objFunding.Year_plus_5__c == null) 
                        AnnualAnticipatedFundingGap5 = - objCPFReport.Anticipated_Resources_Year_5__c;
                        
                }else if(objFunding.RecordType.DeveloperName == 'B' && objFunding.Type__c == '1'){
                    objFS.strName = Label.DS_B1_Loans; //'Domestic source B1: Loans';                    
                    if(TotalK1 == null) TotalK1 = objFunding.Year_1__c;                  
                    if(TotalK2 == null) TotalK2 = objFunding.Year_2__c;
                    if(TotalK == null) TotalK = objFunding.Current_Year__c;
                }
                else if(objFunding.RecordType.DeveloperName == 'B' && objFunding.Type__c == '2'){
                    objFS.strName = Label.DS_B2_Debt_Relief; //'Domestic source B2: Debt relief';
                    if(TotalK1 == null) TotalK1 = 0;
                    if(objFunding.Year_1__c != null){
                        TotalK1 += objFunding.Year_1__c;
                    }
                    if(TotalK2 == null) TotalK2 = 0;
                    if(objFunding.Year_2__c != null){
                        TotalK2 += objFunding.Year_2__c;
                    }
                    if(TotalK == null) TotalK = 0;
                    if(objFunding.Current_Year__c != null){
                        TotalK += objFunding.Current_Year__c;
                    }
                    
                }
                else if(objFunding.RecordType.DeveloperName == 'B' && objFunding.Type__c == '3'){
                    objFS.strName = Label.DS_B3_Govt_Revenues; //'Domestic source B3: Government revenues';
                    if(TotalK1 == null) TotalK1 = 0;
                    if(objFunding.Year_1__c != null){
                        TotalK1 += objFunding.Year_1__c;
                    }
                    if(TotalK2 == null) TotalK2 = 0;
                    if(objFunding.Year_2__c != null){
                        TotalK2 += objFunding.Year_2__c;
                    }
                    if(TotalK == null) TotalK = 0;
                    if(objFunding.Current_Year__c != null){
                        TotalK += objFunding.Current_Year__c;
                    }
                }
                else if(objFunding.RecordType.DeveloperName == 'B' && objFunding.Type__c == '4'){
                    objFS.strName = Label.DS_B4_Social_Health_Insurance;  //'Domestic source B4: Social health insurance';
                    if(TotalK1 == null) TotalK1 = 0;
                    if(objFunding.Year_1__c != null){
                        TotalK1 += objFunding.Year_1__c;
                    }
                    if(TotalK2 == null) TotalK2 = 0;
                    if(objFunding.Year_2__c != null){
                        TotalK2 += objFunding.Year_2__c;
                    }
                    if(TotalK == null) TotalK = 0;
                    if(objFunding.Current_Year__c != null){
                        TotalK += objFunding.Current_Year__c;
                    }
                }
                else if(objFunding.RecordType.DeveloperName == 'B' && objFunding.Type__c == '5')
                    objFS.strName = Label.DS_B5_Prival_Sector_Contributions; //'Domestic source B5: Private sector contributions national';
                else if(objFunding.RecordType.DeveloperName == 'C'){
                    if(objFunding.External_Source_Type__c == null) objFunding.External_Source_Type__c = '';
                    if(objFunding.Type__c != null){
                        objFS.strName = 'C'+objFunding.Type__c;
                    }
                }
                /*else if(objFunding.RecordType.DeveloperName == 'C' && objFunding.Type__c == '2')
                    objFS.strName = 'Select External Source C2';
                else if(objFunding.RecordType.DeveloperName == 'C' && objFunding.Type__c == '3')
                    objFS.strName = 'Select External Source C3';*/
                else if(objFunding.RecordType.DeveloperName == 'D'){
                    if(objFunding.Grant_Number__c == null) objFunding.Grant_Number__c = '';
                    objFS.strName = objFunding.Grant_Number__c;
                }                
                else if(objFunding.RecordType.DeveloperName == 'I' && objFunding.Type__c == '2')
                    objFS.strName = Label.Line_H_Funding_Request_Allocated_Amount;   // 'LINE H: Funding request within the Indicative Amount';
                else if(objFunding.RecordType.DeveloperName == 'I' && objFunding.Type__c == '1')
                    objFS.strName =Label.Line_I_Funding_Request_Above_Allocated;    // 'LINE I: Funding request above the Indicative Amount';
                else if(objFunding.RecordType.DeveloperName == 'J' && objFunding.Type__c == '1')
                    objFS.strName = Label.DS_J1_Loans;                              //'Domestic source J1: Loans';
                else if(objFunding.RecordType.DeveloperName == 'J' && objFunding.Type__c == '2')
                    objFS.strName = Label.DS_J2_Debt_Relief;                        //'Domestic source J2: Debt Relief';
                else if(objFunding.RecordType.DeveloperName == 'J' && objFunding.Type__c == '3')
                    objFS.strName = Label.DS_J3_Govt_Funding;                       // 'Domestic source J3: Government funding resources';
                //objFS.objFundingSource = new Funding_Source__c();
                objFS.objFundingSource = objFunding;
                lstWrapperFundingSource.add(objFS);                
            }
            if(lstWrapperFundingSourceI.size() > 0 && lstWrapperFundingSourceI.size() == 2){
                WrapperFundingSource objWrap = new WrapperFundingSource();
                objWrap = lstWrapperFundingSourceI[1];
                lstWrapperFundingSourceI[1] = lstWrapperFundingSourceI[0];
                lstWrapperFundingSourceI[0] = objWrap;
            }
        }
        if(LAverage == null) { LAverage = 0; }
        if(TotalK != null) { LAverage += TotalK;}
        if(TotalK1 != null) { LAverage += TotalK1;}
        if(TotalK2 != null) { LAverage += TotalK2;}
        LAverage = LAverage / 3;
        
        if(LAverage == null) LAverage = 0;
        if(MAverage == null) MAverage = 0;
                
        if(LAverage + MAverage != 0){
            NAverage = (LAverage / (LAverage + MAverage) * 100); 
            if(NAverage != 0) NAverage = NAverage.setScale(2); }
        
        if(LAverage + OAverage != 0){
            PAverage = (LAverage / (LAverage + OAverage) * 100);
            if(PAverage != 0) PAverage = PAverage.setScale(2); }
        
    }
    
    Public PageReference RefreshLineD(){
        SaveRecords();
        Id RecordTypeD = [Select Id From RecordType Where sobjectType = 'Funding_Source__c' And RecordType.Developername = 'D'].Id;
        List<Funding_Source__c> lstFundingSourceToDelete = [Select Name,Id From Funding_Source__c 
                                                    Where CPF_Report__c =: strCPFReportId And RecordTypeId =: RecordTypeD];
        if(lstFundingSourceToDelete.size() > 0) Delete lstFundingSourceToDelete;
        
        Set<Id> setCountryIds = new Set<Id>();
        Set<Id> setCPFReportId = new Set<Id>();
        setCPFReportId.add(strCPFReportId);
        setCountryIds.add(strCountryId);
        
        GIPFundingSource.CreateGIPFundingSourceRecords(setCountryIds,strCNId,setCPFReportId);
        
        
        //TotalK1 = null;
        //TotalK2 = null;
        //TotalK = null;
        //LAverage = null;
        //AboveIndicativeY1  = null;
        //AboveIndicativeY2 = null;
        //AboveIndicativeY3 = null;
        //AboveIndicativeY4 = null;
        //IndicativeY1 = null;
        //IndicativeY2 = null;
        //IndicativeY3 = null;
        //IndicativeY4 = null;
        //TotalY1 = null;
        //TotalY2 = null;
        //TotalY3 = null;
        //TotalY4 = null;
        //MAverage = null;
        //NAverage = null;
        //OAverage = null;
        //PAverage = null;
        //AnnualAnticipatedFundingGapMinus2 = null;
        //AnnualAnticipatedFundingGapMinus1 = null;
        //AnnualAnticipatedFundingGap1 = null;
        //AnnualAnticipatedFundingGap2 = null;
        //AnnualAnticipatedFundingGap3 = null;
        //AnnualAnticipatedFundingGap4 = null;
        //AnnualAnticipatedFundingGap5 = null;
        
        PageReference p = new PageReference('/apex/cpfreport?id='+strCPFReportId);
        p.setredirect(true);
        return p;
        //RetrieveFundingSource();
        
        /*objCPFReport = [Select Name,Id,Funding_Request_in_Indicative_Year_1__c,country__c,Concept_Note__r.CCM_new__r.Country__r.Country_Fiscal_Cycle_Months__c,
                Funding_Request_in_Indicative_Year_2__c,Funding_Request_in_Indicative_Year_3__c,country__r.Country_Fiscal_Cycle_Months__c,
                D_Year_2_Total__c,D_Year_1_Total__c,D_Current_Year_Total__c,D_Year_plus_1_Total__c,D_Year_plus_2_Total__c,D_Year_3_Total__c,
                Funding_Request_above_Indicative_Year_1__c,Funding_Request_above_Indicative_Year_2__c,
                Cycle_Start_Month__c,Cycle_End_Month__c,Implementation_cycle__c,Reporting_Cycle__c,Concept_Note__c,Concept_Note__r.Language__c,
                Funding_Request_above_Indicative_Year_3__c From CPF_Report__c Where Id =:strCPFReportId];*/
        
    }
    
    Public void SaveRecords(){
        List<Funding_Source__c> lstFundingSourceToUpdate = new List<Funding_Source__c>();
        
        system.debug('In Save');
        for(WrapperFundingSource obj :  lstWrapperFundingSourceNSF ){
            lstFundingSourceToUpdate.add(obj.objFundingSource);
            objCPFReport.A_Year_2__c = obj.objFundingSource.Year_2__c;
            objCPFReport.A_Year_1__c = obj.objFundingSource.Year_1__c;
            objCPFReport.A_Current_Year__c = obj.objFundingSource.Current_Year__c;
            objCPFReport.A_year_plus_1__c = obj.objFundingSource.Year_plus_1__c;
            objCPFReport.A_year_plus_2__c = obj.objFundingSource.Year_plus_2__c;
            objCPFReport.A_year_plus_3__c = obj.objFundingSource.Year_plus_3__c;
            objCPFReport.A_year_plus_4__c = obj.objFundingSource.Year_plus_4__c;
            objCPFReport.A_year_plus_5__c = obj.objFundingSource.Year_plus_5__c;
            
        }
        for(WrapperFundingSource obj :  lstWrapperFundingSourceB ){
            lstFundingSourceToUpdate.add(obj.objFundingSource);
        }
        for(WrapperFundingSource obj :  lstWrapperFundingSourceC ){
            lstFundingSourceToUpdate.add(obj.objFundingSource);
        }
        for(WrapperFundingSource obj :  lstWrapperFundingSourceD ){
            lstFundingSourceToUpdate.add(obj.objFundingSource);
        }
        for(WrapperFundingSource obj :  lstWrapperFundingSourceJ ){
            lstFundingSourceToUpdate.add(obj.objFundingSource);
        }
        for(WrapperFundingSource obj :  lstWrapperFundingSourceI ){
            lstFundingSourceToUpdate.add(obj.objFundingSource);
        }
        
        objCPFReport.G_Current_Year__c=GCurrentYear;
        objCPFReport.G_Current_Year__c=GCurrentYear;
		objCPFReport.G_Year_plus_1__c=GYearPlus1;
		objCPFReport.G_Year_plus_2__c=GYearPlus2;
		objCPFReport.G_Year_plus_3__c=GYearPlus3;
		objCPFReport.H_Current_Year__c=HCurrentYear;
		objCPFReport.H_Year_plus_1__c=HYearPlus1;
		objCPFReport.H_Year_plus_2__c=HYearPlus2;
		objCPFReport.H_Year_plus_3__c=HYearPlus3;
		objCPFReport.I_Current_Year__c=ICurrentYear;
		objCPFReport.I_Year_plus_1__c=IYearPlus1;
		objCPFReport.I_Year_plus_2__c=IYearPlus2;
		objCPFReport.I_Year_plus_3__c=IYearPlus3;
        upsert lstFundingSourceToUpdate;
        
        update objCPFReport;
    }
    
    Public PageReference SaveRecordsAndReturnCPF(){
    	system.debug('Inside SaveRecordsAndReturnCPF');
        SaveRecords();
        PageReference pageRef = new PageReference('/apex/CNoverview?id='+strCNId);
        system.debug('pageRef');
        return pageRef;
    }
        
    Public void AddNewFSC(){
        WrapperFundingSource objWrap = new WrapperFundingSource();
        objWrap.objFundingSource = new Funding_Source__c(CPF_Report__c = strCPFReportId,RecordTypeId = RecordTypeIdC,CurrencyIsoCode = objCPFReport.CurrencyIsoCode);
        objWrap.blnDisplayInput = true;
        lstWrapperFundingSourceC.add(objWrap);
    }
    Public void DeleteNewFSC(){
        Integer DeleteIndex = integer.valueof(Apexpages.currentpage().getparameters().get('DeleteIndex'));
        if(DeleteIndex != null){
            if(lstWrapperFundingSourceC[DeleteIndex].objFundingSource.id != null){
                List<Funding_Source__c> lstFundingSourceToDelete = [Select Id From Funding_Source__c 
                                Where id =: lstWrapperFundingSourceC[DeleteIndex].objFundingSource.id];
                if(lstFundingSourceToDelete.size() > 0) Delete lstFundingSourceToDelete;
            }
            lstWrapperFundingSourceC.remove(DeleteIndex);
        }
        
    }
    
    // Decalartion for wrapper class for funding source.
    Public class WrapperFundingSource{
        
        Public Boolean blnDisplayInput {get;set;}
        Public String strName {get;set;}
        Public Funding_Source__c objFundingSource {get;set;}
        
    }
    public void checkProfile(){
    
    
    blnExternalPro = false;
    blnSaveDraft = false;
    blnSaveReturn = false;
    blnCCMComments = false;
    blnLFAComments = false;
    blnTGFComments = false;
    blnIPFields = false;
    blnDel = false;

         Id profileId=userinfo.getProfileId();
         String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
         List<Profile_Access_Setting_CN__c> checkpage = new List<Profile_Access_Setting_CN__c>();
         system.debug('profileName'+profileName);
         List<String> PermissionSets = new List<String>();
        List<PermissionSetAssignment> standalonePermSets = [ SELECT PermissionSet.Label FROM PermissionSetAssignment WHERE Assignee.Username =: UserInfo.getUserName()];
        if(standalonePermSets.size()>0){
        for(PermissionSetAssignment PermSets : standalonePermSets){
            PermissionSets.add(PermSets.PermissionSet.Label);
            system.debug('Name '+PermSets.PermissionSet.Label);
            
        }}
         checkpage = [Select Salesforce_Item__c,Status__c from Profile_Access_Setting_CN__c where Page_Name__c ='CPFReport' and (Profile_Name__c =: profileName OR Permission_Sets__c IN: PermissionSets)];
         //checkpage = [Select Salesforce_Item__c,Status__c from Profile_Access_Setting_CN__c where Page_Name__c ='CPFReport' and (Profile_Name__c =: profileName OR Profile_Name_French__c=: profileName OR Profile_Name_Spanish__c=: profileName OR Permission_Sets__c IN: PermissionSets)];
         system.debug('checkpage'+checkpage);
      for (Profile_Access_Setting_CN__c check : checkpage){
        if (check.Salesforce_Item__c == 'External Profile') blnExternalPro = true;
        if(check.Salesforce_Item__c == 'Save Draft' && check.Status__c == strStatus)blnSaveDraft = true;
        if(check.Salesforce_Item__c == 'Save and Return' && check.Status__c == strStatus)blnSaveReturn = true;
         if(check.Salesforce_Item__c == 'CCM Comments' && check.Status__c == strStatus)blnCCMComments = true;
         if(check.Salesforce_Item__c == 'LFA Comments' && check.Status__c == strStatus)blnLFAComments = true;
         if(check.Salesforce_Item__c == 'TGF Comments' && check.Status__c == strStatus)blnTGFComments = true;
         if(check.Salesforce_Item__c == 'Input Fields' && check.Status__c == strStatus)blnIPFields = true;
         if(check.Salesforce_Item__c == 'Delete' && check.Status__c== strStatus)blnDel = true;
       }
    }
    
}