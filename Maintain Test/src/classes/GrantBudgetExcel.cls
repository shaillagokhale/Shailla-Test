Public Class GrantBudgetExcel{
    public string xmlheader{get;set;}   
    Public String strImpPeriodID{get;set;}
    Public String strGrantID{get;set;}
    Public List<GrantBudgetExcelModel> lstBudgetModelNew{get;set;}
    List<Implementation_Period__c> lstImpPriod;
    Public GrantBudgetExcel(){
        xmlheader ='<?xml version="1.0"?><?mso-application progid="Excel.Sheet"?>';        
    }
    Public GrantBudgetExcel(ApexPages.StandardController controller){
        xmlheader ='<?xml version="1.0"?><?mso-application progid="Excel.Sheet"?>';
        if(apexPages.currentPage().getParameters().get('id')!=null){
            strImpPeriodID = apexPages.currentPage().getParameters().get('id');
            lstImpPriod = [select id,Name,Grant__c,Grant__r.Disease_Component__c from Implementation_Period__c where id=:strImpPeriodID ];
            if(lstImpPriod.size()>0){
                strGrantID = lstImpPriod[0].Grant__c;
                lstBudgetModelNew =  new List<GrantBudgetExcelModel>();
                fillGIP();
                fillModules();                
                fillPayees(); 
                fillCostInputs();
                fillGrantInterventions();   
                fillBudgetLine();                
                fillAssumptionsHR();
                fillAssumptionsTRC();
                fillAssumptionsOther();
                fillModuleInterventionCascading();
            }
        }
    } 
    
    Public void fillBudgetLine(){
        GrantBudgetExcelModel objBudgetLineModel = new GrantBudgetExcelModel();
        objBudgetLineModel.IsProtected= 0;
        objBudgetLineModel.strSheetname = 'Budget Lines';
        objBudgetLineModel.lstHeaders = New List<String>{'Budget Line No.','Module','Intervention','Salesforce ID','Activity Description',
        'Cost Input','Cost Grouping','Cost Input ID','Recipient Name','Unit of Measure','Currency','#BLANK1','Unit Cost Y1','Quantity Q1','Cash Outflow Q1',
        'Quantity Q2','Cash Outflow Q2','Quantity Q3','Cash Outflow Q3','Quantity Q4','Cash Outflow Q4','Total Quantity Y1','Total Cash Outflow Y1',
        '#BLANK2','Unit Cost Y2','Quantity Q5','Cash Outflow Q5','Quantity Q6','Cash Outflow Q6','Quantity Q7','Cash Outflow Q7','Quantity Q8','Cash Outflow Q8',
        'Total Quantity Y2','Total Cash Outflow Y2','#BLANK3','Unit Cost Y3','Quantity Q9','Cash Outflow Q9','Quantity Q10','Cash Outflow Q10','Quantity Q11',
        'Cash Outflow Q11','Quantity Q12','Cash Outflow Q12','Total Quantity Y3','Total Cash Outflow Y3','#BLANK4','Unit Cost Y4',
        'Quantity Q13','Cash Outflow Q13','Quantity Q14','Cash Outflow Q14','Quantity Q15','Cash Outflow Q15','Quantity Q16','Cash Outflow Q16','Total Quantity Y4',
        'Total Cash Outflow Y4','#BLANK5','Total Quantity Y1-3','Total Cash Outflow Y1-3','#BLANK6','Y1 Grant Currency','Y2 Grant Currency','Y3 Grant Currency',
        'Y4 Grant Currency','Assumptions to Support Unit Cost','Justification/Comments' };
        
        objBudgetLineModel.lstData = New List<Map<String,String>>();     
            for(Budget_Line__c objBudgetLine : [select id,name,Budget_Line_Number__c,
                 Grant_Intervention__r.module__r.Name, Grant_Intervention__r.Name, Grant_Intervention__c , Activity__c,
                 Cost_Input__r.Name, Cost_Input__r.Cost_Grouping__c , Cost_Input__c ,
                 Payee__r.Implementer_Name__c , Cost_Input__r.Unit_Cost_Definition__c , Currency_Code__c ,
                 Unit_Cost_Y1__c, Q1_Quantity__c, Q1_Grant_Amount__c, Q2_Quantity__c,
                 Q2_Grant_Amount__c, Q3_Quantity__c , Q3_Grant_Amount__c ,
                 Q4_Quantity__c , Q4_Grant_Amount__c, Unit_Cost_Y2__c ,
                 Q5_Quantity__c , Q5_Grant_Amount__c , Q6_Quantity__c ,
                 Q6_Grant_Amount__c , Q7_Quantity__c , Q7_Grant_Amount__c ,
                 Q8_Quantity__c , Q8_Grant_Amount__c , Unit_Cost_Y3__c , Q9_Quantity__c ,
                 Q9_Grant_Amount__c , Q10_Quantity__c , Q10_Grant_Amount__c , Q11_Quantity__c ,
                 Q11_Grant_Amount__c , Q12_Quantity__c , Q12_Grant_Amount__c ,
                 Unit_Cost_Y4__c,  Q13_Quantity__c , Q13_Grant_Amount__c ,
                 Q14_Quantity__c , Q14_Grant_Amount__c , Q15_Quantity__c ,
                 Q15_Grant_Amount__c , Q16_Quantity__c , Q16_Grant_Amount__c
             from Budget_Line__c where Grant_Intervention__r.Implementation_Period__c =: strImpPeriodID order by Budget_Line_Number__c ASC]){        
            Map<String,String> rowdata = New Map<String,String>();            
            rowdata.put('Budget Line No.',handleNULL(String.valueOf(objBudgetLine.Budget_Line_Number__c)));
            rowdata.put('Module',handleNULL(objBudgetLine.Grant_Intervention__r.module__r.Name));
            rowdata.put('Intervention',handleNULL(objBudgetLine.Grant_Intervention__r.Name));
            rowdata.put('Salesforce ID',handleNULL(objBudgetLine.Grant_Intervention__c));
            rowdata.put('Activity Description',handleNULL(objBudgetLine.Activity__c));
            rowdata.put('Cost Input',handleNULL(objBudgetLine.Cost_Input__r.Name));
            rowdata.put('Cost Grouping',handleNULL(objBudgetLine.Cost_Input__r.Cost_Grouping__c));
            rowdata.put('Cost Input ID',handleNULL(objBudgetLine.Cost_Input__c));
            rowdata.put('Recipient Name',handleNULL(objBudgetLine.Payee__r.Implementer_Name__c));
            rowdata.put('Unit of Measure',handleNULL(objBudgetLine.Cost_Input__r.Unit_Cost_Definition__c));
            rowdata.put('Currency',handleNULL(objBudgetLine.Currency_Code__c));
            rowdata.put('#BLANK1','');
            rowdata.put('Unit Cost Y1',handleNULL(String.valueOf(objBudgetLine.Unit_Cost_Y1__c)));
            rowdata.put('Quantity Q1',handleNULL(String.valueOf(objBudgetLine.Q1_Quantity__c)));
            rowdata.put('Cash Outflow Q1',handleNULL(String.valueOf(objBudgetLine.Q1_Grant_Amount__c)));
            rowdata.put('Quantity Q2',handleNULL(String.valueOf(objBudgetLine.Q2_Quantity__c)));
            rowdata.put('Cash Outflow Q2',handleNULL(String.valueOf(objBudgetLine.Q2_Grant_Amount__c)));
            rowdata.put('Quantity Q3',handleNULL(String.valueOf(objBudgetLine.Q3_Quantity__c)));
            rowdata.put('Cash Outflow Q3',handleNULL(String.valueOf(objBudgetLine.Q3_Grant_Amount__c)));
            rowdata.put('Quantity Q4',handleNULL(String.valueOf(objBudgetLine.Q4_Quantity__c)));
            rowdata.put('Cash Outflow Q4',handleNULL(String.valueOf(objBudgetLine.Q4_Grant_Amount__c)));
            rowdata.put('Total Quantity Y1','');
            rowdata.put('Total Cash Outflow Y1','');
            rowdata.put('#BLANK2','');
            rowdata.put('Unit Cost Y2',handleNULL(String.valueOf(objBudgetLine.Unit_Cost_Y2__c)));
            rowdata.put('Quantity Q5',handleNULL(String.valueOf(objBudgetLine.Q5_Quantity__c)));
            rowdata.put('Cash Outflow Q5',handleNULL(String.valueOf(objBudgetLine.Q5_Grant_Amount__c)));
            rowdata.put('Quantity Q6',handleNULL(String.valueOf(objBudgetLine.Q6_Quantity__c)));
            rowdata.put('Cash Outflow Q6',handleNULL(String.valueOf(objBudgetLine.Q6_Grant_Amount__c)));
            rowdata.put('Quantity Q7',handleNULL(String.valueOf(objBudgetLine.Q7_Quantity__c)));
            rowdata.put('Cash Outflow Q7',handleNULL(String.valueOf(objBudgetLine.Q7_Grant_Amount__c)));
            rowdata.put('Quantity Q8',handleNULL(String.valueOf(objBudgetLine.Q8_Quantity__c)));
            rowdata.put('Cash Outflow Q8',handleNULL(String.valueOf(objBudgetLine.Q8_Grant_Amount__c)));
            rowdata.put('Total Quantity Y2','');
            rowdata.put('Total Cash Outflow Y2','');
            rowdata.put('#BLANK3','');
            rowdata.put('Unit Cost Y3',handleNULL(String.valueOf(objBudgetLine.Unit_Cost_Y3__c)));
            rowdata.put('Quantity Q9',handleNULL(String.valueOf(objBudgetLine.Q9_Quantity__c)));
            rowdata.put('Cash Outflow Q9',handleNULL(String.valueOf(objBudgetLine.Q9_Grant_Amount__c)));
            rowdata.put('Quantity Q10',handleNULL(String.valueOf(objBudgetLine.Q10_Quantity__c)));
            rowdata.put('Cash Outflow Q10',handleNULL(String.valueOf(objBudgetLine.Q10_Grant_Amount__c)));
            rowdata.put('Quantity Q11',handleNULL(String.valueOf(objBudgetLine.Q11_Quantity__c)));
            rowdata.put('Cash Outflow Q11',handleNULL(String.valueOf(objBudgetLine.Q11_Grant_Amount__c)));
            rowdata.put('Quantity Q12',handleNULL(String.valueOf(objBudgetLine.Q12_Quantity__c)));
            rowdata.put('Cash Outflow Q12',handleNULL(String.valueOf(objBudgetLine.Q12_Grant_Amount__c)));
            rowdata.put('Total Quantity Y3','');
            rowdata.put('Total Cash Outflow Y3','');
            rowdata.put('#BLANK4','');
            rowdata.put('Unit Cost Y4',handleNULL(String.valueOf(objBudgetLine.Unit_Cost_Y4__c)));
            rowdata.put('Quantity Q13',handleNULL(String.valueOf(objBudgetLine.Q13_Quantity__c)));
            rowdata.put('Cash Outflow Q13',handleNULL(String.valueOf(objBudgetLine.Q13_Grant_Amount__c)));
            rowdata.put('Quantity Q14',handleNULL(String.valueOf(objBudgetLine.Q14_Quantity__c)));
            rowdata.put('Cash Outflow Q14',handleNULL(String.valueOf(objBudgetLine.Q14_Grant_Amount__c)));
            rowdata.put('Quantity Q15',handleNULL(String.valueOf(objBudgetLine.Q15_Quantity__c)));
            rowdata.put('Cash Outflow Q15',handleNULL(String.valueOf(objBudgetLine.Q15_Grant_Amount__c)));
            rowdata.put('Quantity Q16',handleNULL(String.valueOf(objBudgetLine.Q16_Quantity__c)));
            rowdata.put('Cash Outflow Q16',handleNULL(String.valueOf(objBudgetLine.Q16_Grant_Amount__c)));
            rowdata.put('Total Quantity Y4','');
            rowdata.put('#BLANK5','');
            rowdata.put('Total Cash Outflow Y4','');
            rowdata.put('Total Quantity Y1-3','');
            rowdata.put('#BLANK6','');
            rowdata.put('Total Cash Outflow Y1-3','');
            rowdata.put('Y1 Grant Currency','');
            rowdata.put('Y2 Grant Currency','');
            rowdata.put('Y3 Grant Currency','');
            rowdata.put('Y4 Grant Currency','');
            rowdata.put('Assumptions to Support Unit Cost','');
            rowdata.put('Justification/Comments','');
            objBudgetLineModel.lstData.add(rowdata);
        }
        lstBudgetModelNew.add(objBudgetLineModel);
    }
    Public void fillAssumptionsHR(){
        GrantBudgetExcelModel objAssumptionsHRModel = new GrantBudgetExcelModel();
        objAssumptionsHRModel.IsProtected= 0;
        objAssumptionsHRModel.strSheetname = 'Assumptions HR';
        objAssumptionsHRModel.lstHeaders = New List<String>{'Budget Line No.','Item Description','Unit of Measure','Currency','Y1 Net Salary (Payment Currency)','Y1 Social Security and Other Obligatory Charges','Y1 Total Salary (Payment Currency)','Y1 Level of Effort (%)','Y1 Number of persons','Y1 Total Cost (Payment Currency)','Y2 Net Salary (Payment Currency)','Y2 Social Security and Other Obligatory Charges','Y2 Total Salary (Payment Currency)','Y2 Level of Effort (%)','Y2 Number of persons','Y2 Total Cost (Payment Currency)','Y3 Net Salary (Payment Currency)','Y3 Social Security and Other Obligatory Charges','Y3 Total Salary (Payment Currency)','Y3 Level of Effort (%)','Y3 Number of persons','Y3 Total Cost (Payment Currency)','Y4 Net Salary (Payment Currency)','Y4 Social Security and Other Obligatory Charges','Y4 Total Salary (Payment Currency)','Y4 Level of Effort (%)','Y4 Number of persons','Y4 Total Cost (Payment Currency)','Assumptions to Support Unit Cost','Justification / Comments'};
        
        objAssumptionsHRModel.lstData = New List<Map<String,String>>();        
        for(Assumption__c objAssumption : [Select ID,Name,Budget_Line_Number__r.Budget_Line_Number__c,
                    Item_Description__c,Unit_of_Measure__c,Budget_Line_Number__r.Currency_Code__c,
                    Y1_Net_Salary_Payment_Currency__c,Y1_Social_Security_Obligatory_Charges__c  ,Y1_Total_Salary_Payment_Currency__c,
                    Y1_Level_of_Effort__c,Y1_Number_of_Persons__c,Y1_Total_Cost_Payment_Currency__c,
                    Y2_Net_Salary_Payment_Currency__c,Y2_Social_Security_Obligatory_Charges__c ,Y2_Total_Salary_Payment_Currency__c,
                    Y2_Level_of_Effort__c,Y2_Number_of_Persons__c,Y2_Total_Cost_Payment_Currency__c,
                    Y3_Net_Salary_Payment_Currency__c,Y3_Social_Security_Obligatory_Charges__c ,
                    Y3_Total_Salary_Payment_Currency__c,Y3_Level_of_Effort__c,Y3_Number_of_Persons__c,
                    Y3_Total_Cost_Payment_Currency__c,Y4_Net_Salary_Payment_Currency__c,
                    Y4_Social_Security_Obligatory_Charges__c,Y4_Total_Salary_Payment_Currency__c,
                    Y4_Level_of_Effort__c,Y4_Number_of_Persons__c,Y4_Total_Cost_Payment_Currency__c,
                    Assumptions_to_Support_Unit_Cost__c,Justifications_Comments__c
                from Assumption__c where Budget_Line_Number__r.Cost_Input__r.Cost_Grouping__c = '1. Human Resources (HR)']){                
            Map<String,String> rowdata = New Map<String,String>();
            rowdata.put('Budget Line No.',handleNULL(String.valueOf(objAssumption.Budget_Line_Number__r.Budget_Line_Number__c)));            
            rowdata.put('Item Description',handleNULL(objAssumption.Item_Description__c));
            rowdata.put('Unit of Measure',handleNULL(objAssumption.Unit_of_Measure__c));
            rowdata.put('Currency',handleNULL(objAssumption.Budget_Line_Number__r.Currency_Code__c));
            rowdata.put('Y1 Net Salary (Payment Currency)',handleNULL(string.valueOf(objAssumption.Y1_Net_Salary_Payment_Currency__c)));
            rowdata.put('Y1 Social Security and Other Obligatory Charges',handleNULL(string.valueOf(objAssumption.Y1_Social_Security_Obligatory_Charges__c  )));
            rowdata.put('Y1 Total Salary (Payment Currency)',handleNULL(string.valueOf(objAssumption.Y1_Total_Salary_Payment_Currency__c)));
            rowdata.put('Y1 Level of Effort (%)',handleNULL(string.valueOf(objAssumption.Y1_Level_of_Effort__c)));
            rowdata.put('Y1 Number of persons',handleNULL(string.valueOf(objAssumption.Y1_Number_of_Persons__c)));
            rowdata.put('Y1 Total Cost (Payment Currency)',handleNULL(string.valueOf(objAssumption.Y1_Total_Cost_Payment_Currency__c)));
            rowdata.put('Y2 Net Salary (Payment Currency)',handleNULL(string.valueOf(objAssumption.Y2_Net_Salary_Payment_Currency__c)));
            rowdata.put('Y2 Social Security and Other Obligatory Charges',handleNULL(string.valueOf(objAssumption.Y2_Social_Security_Obligatory_Charges__c  )));
            rowdata.put('Y2 Total Salary (Payment Currency)',handleNULL(string.valueOf(objAssumption.Y2_Total_Salary_Payment_Currency__c)));
            rowdata.put('Y2 Level of Effort (%)',handleNULL(string.valueOf(objAssumption.Y2_Level_of_Effort__c)));
            rowdata.put('Y2 Number of persons',handleNULL(string.valueOf(objAssumption.Y2_Number_of_Persons__c)));
            rowdata.put('Y2 Total Cost (Payment Currency)',handleNULL(string.valueOf(objAssumption.Y2_Total_Cost_Payment_Currency__c)));
            rowdata.put('Y3 Net Salary (Payment Currency)',handleNULL(string.valueOf(objAssumption.Y3_Net_Salary_Payment_Currency__c)));
            rowdata.put('Y3 Social Security and Other Obligatory Charges',handleNULL(string.valueOf(objAssumption.Y3_Social_Security_Obligatory_Charges__c  )));
            rowdata.put('Y3 Total Salary (Payment Currency)',handleNULL(string.valueOf(objAssumption.Y3_Total_Salary_Payment_Currency__c)));
            rowdata.put('Y3 Level of Effort (%)',handleNULL(string.valueOf(objAssumption.Y3_Level_of_Effort__c)));
            rowdata.put('Y3 Number of persons',handleNULL(string.valueOf(objAssumption.Y3_Number_of_Persons__c)));
            rowdata.put('Y3 Total Cost (Payment Currency)',handleNULL(string.valueOf(objAssumption.Y3_Total_Cost_Payment_Currency__c)));
            rowdata.put('Y4 Net Salary (Payment Currency)',handleNULL(string.valueOf(objAssumption.Y4_Net_Salary_Payment_Currency__c)));
            rowdata.put('Y4 Social Security and Other Obligatory Charges',handleNULL(string.valueOf(objAssumption.Y4_Social_Security_Obligatory_Charges__c  )));
            rowdata.put('Y4 Total Salary (Payment Currency)',handleNULL(string.valueOf(objAssumption.Y4_Total_Salary_Payment_Currency__c)));
            rowdata.put('Y4 Level of Effort (%)',handleNULL(string.valueOf(objAssumption.Y4_Level_of_Effort__c)));
            rowdata.put('Y4 Number of persons',handleNULL(string.valueOf(objAssumption.Y4_Number_of_Persons__c)));
            rowdata.put('Y4 Total Cost (Payment Currency)',handleNULL(string.valueOf(objAssumption.Y4_Total_Cost_Payment_Currency__c)));
            rowdata.put('Assumptions to Support Unit Cost',handleNULL(objAssumption.Assumptions_to_Support_Unit_Cost__c));
            rowdata.put('Justification / Comments',handleNULL(objAssumption.Justifications_Comments__c));
            objAssumptionsHRModel.lstData.add(rowdata);
        }             
        lstBudgetModelNew.add(objAssumptionsHRModel);
    }
    Public void fillAssumptionsTRC(){
        GrantBudgetExcelModel objAssumptionsTRCModel = new GrantBudgetExcelModel();
        objAssumptionsTRCModel.IsProtected= 0;
        objAssumptionsTRCModel.strSheetname = 'Assumptions TRC';
        objAssumptionsTRCModel.lstHeaders = New List<String>{'Budget Line No.','Item Description','Unit of Measure','Currency','Y1 Net Salary (Payment Currency)','Y1 Social Security and Other Obligatory Charges','Y1 Total Salary (Payment Currency)','Y1 Level of Effort (%)','Y1 Number of persons','Y1 Total Cost (Payment Currency)','Y2 Net Salary (Payment Currency)','Y2 Social Security and Other Obligatory Charges','Y2 Total Salary (Payment Currency)','Y2 Level of Effort (%)','Y2 Number of persons','Y2 Total Cost (Payment Currency)','Y3 Net Salary (Payment Currency)','Y3 Social Security and Other Obligatory Charges','Y3 Total Salary (Payment Currency)','Y3 Level of Effort (%)','Y3 Number of persons','Y3 Total Cost (Payment Currency)','Y4 Net Salary (Payment Currency)','Y4 Social Security and Other Obligatory Charges','Y4 Total Salary (Payment Currency)','Y4 Level of Effort (%)','Y4 Number of persons','Y4 Total Cost (Payment Currency)','Assumptions to Support Unit Cost','Justification / Comments'};
        
        objAssumptionsTRCModel.lstData = New List<Map<String,String>>();
        for(Assumption__c objAssumption : [Select ID,Name,Budget_Line_Number__r.Budget_Line_Number__c,
                    Item_Description__c,Unit_of_Measure__c,Budget_Line_Number__r.Currency_Code__c,
                    Y1_Net_Salary_Payment_Currency__c,Y1_Social_Security_Obligatory_Charges__c  ,Y1_Total_Salary_Payment_Currency__c,
                    Y1_Level_of_Effort__c,Y1_Number_of_Persons__c,Y1_Total_Cost_Payment_Currency__c,
                    Y2_Net_Salary_Payment_Currency__c,Y2_Social_Security_Obligatory_Charges__c ,Y2_Total_Salary_Payment_Currency__c,
                    Y2_Level_of_Effort__c,Y2_Number_of_Persons__c,Y2_Total_Cost_Payment_Currency__c,
                    Y3_Net_Salary_Payment_Currency__c,Y3_Social_Security_Obligatory_Charges__c ,
                    Y3_Total_Salary_Payment_Currency__c,Y3_Level_of_Effort__c,Y3_Number_of_Persons__c,
                    Y3_Total_Cost_Payment_Currency__c,Y4_Net_Salary_Payment_Currency__c,
                    Y4_Social_Security_Obligatory_Charges__c,Y4_Total_Salary_Payment_Currency__c,
                    Y4_Level_of_Effort__c,Y4_Number_of_Persons__c,Y4_Total_Cost_Payment_Currency__c,
                    Assumptions_to_Support_Unit_Cost__c,Justifications_Comments__c
                from Assumption__c where Budget_Line_Number__r.Cost_Input__r.Cost_Grouping__c = '2. Training Related Costs (TRC)']){                
            Map<String,String> rowdata = New Map<String,String>();    
            rowdata.put('Budget Line No.',handleNULL(String.valueOf(objAssumption.Budget_Line_Number__r.Budget_Line_Number__c)));                    
            rowdata.put('Item Description',handleNULL(objAssumption.Item_Description__c));
            rowdata.put('Unit of Measure',handleNULL(objAssumption.Unit_of_Measure__c));
            rowdata.put('Currency',handleNULL(objAssumption.Budget_Line_Number__r.Currency_Code__c));
            rowdata.put('Y1 Net Salary (Payment Currency)',handleNULL(string.valueOf(objAssumption.Y1_Net_Salary_Payment_Currency__c)));
            rowdata.put('Y1 Social Security and Other Obligatory Charges',handleNULL(string.valueOf(objAssumption.Y1_Social_Security_Obligatory_Charges__c  )));
            rowdata.put('Y1 Total Salary (Payment Currency)',handleNULL(string.valueOf(objAssumption.Y1_Total_Salary_Payment_Currency__c)));
            rowdata.put('Y1 Level of Effort (%)',handleNULL(string.valueOf(objAssumption.Y1_Level_of_Effort__c)));
            rowdata.put('Y1 Number of persons',handleNULL(string.valueOf(objAssumption.Y1_Number_of_Persons__c)));
            rowdata.put('Y1 Total Cost (Payment Currency)',handleNULL(string.valueOf(objAssumption.Y1_Total_Cost_Payment_Currency__c)));
            rowdata.put('Y2 Net Salary (Payment Currency)',handleNULL(string.valueOf(objAssumption.Y2_Net_Salary_Payment_Currency__c)));
            rowdata.put('Y2 Social Security and Other Obligatory Charges',handleNULL(string.valueOf(objAssumption.Y2_Social_Security_Obligatory_Charges__c  )));
            rowdata.put('Y2 Total Salary (Payment Currency)',handleNULL(string.valueOf(objAssumption.Y2_Total_Salary_Payment_Currency__c)));
            rowdata.put('Y2 Level of Effort (%)',handleNULL(string.valueOf(objAssumption.Y2_Level_of_Effort__c)));
            rowdata.put('Y2 Number of persons',handleNULL(string.valueOf(objAssumption.Y2_Number_of_Persons__c)));
            rowdata.put('Y2 Total Cost (Payment Currency)',handleNULL(string.valueOf(objAssumption.Y2_Total_Cost_Payment_Currency__c)));
            rowdata.put('Y3 Net Salary (Payment Currency)',handleNULL(string.valueOf(objAssumption.Y3_Net_Salary_Payment_Currency__c)));
            rowdata.put('Y3 Social Security and Other Obligatory Charges',handleNULL(string.valueOf(objAssumption.Y3_Social_Security_Obligatory_Charges__c  )));
            rowdata.put('Y3 Total Salary (Payment Currency)',handleNULL(string.valueOf(objAssumption.Y3_Total_Salary_Payment_Currency__c)));
            rowdata.put('Y3 Level of Effort (%)',handleNULL(string.valueOf(objAssumption.Y3_Level_of_Effort__c)));
            rowdata.put('Y3 Number of persons',handleNULL(string.valueOf(objAssumption.Y3_Number_of_Persons__c)));
            rowdata.put('Y3 Total Cost (Payment Currency)',handleNULL(string.valueOf(objAssumption.Y3_Total_Cost_Payment_Currency__c)));
            rowdata.put('Y4 Net Salary (Payment Currency)',handleNULL(string.valueOf(objAssumption.Y4_Net_Salary_Payment_Currency__c)));
            rowdata.put('Y4 Social Security and Other Obligatory Charges',handleNULL(string.valueOf(objAssumption.Y4_Social_Security_Obligatory_Charges__c  )));
            rowdata.put('Y4 Total Salary (Payment Currency)',handleNULL(string.valueOf(objAssumption.Y4_Total_Salary_Payment_Currency__c)));
            rowdata.put('Y4 Level of Effort (%)',handleNULL(string.valueOf(objAssumption.Y4_Level_of_Effort__c)));
            rowdata.put('Y4 Number of persons',handleNULL(string.valueOf(objAssumption.Y4_Number_of_Persons__c)));
            rowdata.put('Y4 Total Cost (Payment Currency)',handleNULL(string.valueOf(objAssumption.Y4_Total_Cost_Payment_Currency__c)));
            rowdata.put('Assumptions to Support Unit Cost',handleNULL(objAssumption.Assumptions_to_Support_Unit_Cost__c));
            rowdata.put('Justification / Comments',handleNULL(objAssumption.Justifications_Comments__c));
            objAssumptionsTRCModel.lstData.add(rowdata);
        }             
        lstBudgetModelNew.add(objAssumptionsTRCModel);
    }
    public void fillAssumptionsOther(){
        GrantBudgetExcelModel objAssumptionsOtherModel = new GrantBudgetExcelModel();
        objAssumptionsOtherModel.IsProtected= 0;
        objAssumptionsOtherModel.strSheetname = 'Assumptions Other';
        objAssumptionsOtherModel.lstHeaders = New List<String>{'Budget Line No.','Item Description','Unit of Measure','Year 1 Unit Cost(Payment Currency)','Year 1 Quantity','Year 1 Total Cost (Payment Currency)','#BLANK1','Year 2 Unit Cost(Payment Currency)','Year 2 Quantity','Year 2 Quantity','Year 2 Total Cost (Payment Currency)','#BLANK2','Year 3 Unit Cost(Payment Currency)','Year 3 Quantity','Year 3 Total Cost (Payment Currency)','#BLANK3','Year 4 Unit Cost(Payment Currency)','Year 4 Quantity','Year 4 Total Cost (Payment Currency)','#BLANK4','Assumptions to Support Unit Cost','Justification / Comments'};
            
        objAssumptionsOtherModel.lstData = New List<Map<String,String>>();
        for(Assumption__c objAssumption : [Select ID,Name,Budget_Line_Number__r.Budget_Line_Number__c,
                     Item_Description__c,Unit_of_Measure__c,Y1_Unit_Cost_Payment_Currency__c,Y1_Quantity__c,Y1_Total_Cost_Payment_Currency__c,
                     Y2_Unit_Cost_Payment_Currency__c,Y2_Quantity__c,Y2_Total_Cost_Payment_Currency__c,Y3_Unit_Cost_Payment_Currency__c,
                     Y3_Quantity__c,Y3_Total_Cost_Payment_Currency__c,Y4_Unit_Cost_Payment_Currency__c,Y4_Quantity__c,
                     Y4_Total_Cost_Payment_Currency__c,Assumptions_to_Support_Unit_Cost__c,Justifications_Comments__c 
                from Assumption__c where Budget_Line_Number__r.Cost_Input__r.Cost_Grouping__c != '1. Human Resources (HR)' and Budget_Line_Number__r.Cost_Input__r.Cost_Grouping__c != '2. Training Related Costs (TRC)']){                
            Map<String,String> rowdata = New Map<String,String>();            
            rowdata.put('Budget Line No.',handleNULL(String.valueOf(objAssumption.Budget_Line_Number__r.Budget_Line_Number__c)));                    
            rowdata.put('Item Description',handleNULL(objAssumption.Item_Description__c));
            rowdata.put('Unit of Measure',handleNULL(objAssumption.Unit_of_Measure__c));
            rowdata.put('Year 1 Unit Cost(Payment Currency)',handleNULL(String.valueOf(objAssumption.Y1_Unit_Cost_Payment_Currency__c)));
            rowdata.put('Year 1 Quantity',handleNULL(String.valueOf(objAssumption.Y1_Quantity__c)));
            rowdata.put('Year 1 Total Cost (Payment Currency)',handleNULL(String.valueOf(objAssumption.Y1_Total_Cost_Payment_Currency__c)));
            rowdata.put('#BLANK1','');
            rowdata.put('Year 2 Unit Cost(Payment Currency)',handleNULL(String.valueOf(objAssumption.Y2_Unit_Cost_Payment_Currency__c)));
            rowdata.put('Year 2 Quantity',handleNULL(String.valueOf(objAssumption.Y2_Quantity__c)));
            rowdata.put('Year 2 Total Cost (Payment Currency)',handleNULL(String.valueOf(objAssumption.Y2_Total_Cost_Payment_Currency__c)));
            rowdata.put('#BLANK2','');
            rowdata.put('Year 3 Unit Cost(Payment Currency)',handleNULL(String.valueOf(objAssumption.Y3_Unit_Cost_Payment_Currency__c)));
            rowdata.put('Year 3 Quantity',handleNULL(String.valueOf(objAssumption.Y3_Quantity__c)));
            rowdata.put('Year 3 Total Cost (Payment Currency)',handleNULL(String.valueOf(objAssumption.Y3_Total_Cost_Payment_Currency__c)));
            rowdata.put('#BLANK3','');
            rowdata.put('Year 4 Unit Cost(Payment Currency)',handleNULL(String.valueOf(objAssumption.Y4_Unit_Cost_Payment_Currency__c)));
            rowdata.put('Year 4 Quantity',handleNULL(String.valueOf(objAssumption.Y4_Quantity__c)));
            rowdata.put('Year 4 Total Cost (Payment Currency)',handleNULL(String.valueOf(objAssumption.Y4_Total_Cost_Payment_Currency__c)));
            rowdata.put('#BLANK4','');
            rowdata.put('Assumptions to Support Unit Cost',handleNULL(objAssumption.Assumptions_to_Support_Unit_Cost__c));
            rowdata.put('Justification / Comments',handleNULL(objAssumption.Justifications_Comments__c)); 
            objAssumptionsOtherModel.lstData.add(rowdata);
        }             
        lstBudgetModelNew.add(objAssumptionsOtherModel);
    }
    
    public void fillModuleInterventionCascading(){
        GrantBudgetExcelModel objModuleInterventionCascading = new GrantBudgetExcelModel();
        objModuleInterventionCascading.IsProtected= 1;
        objModuleInterventionCascading.strSheetname = 'Cascading';
        objModuleInterventionCascading.lstHeaders = New List<String>();
        List<Module__c> lstModuleIntervention = [SELECT Id,Name,
            (
                SELECT Id,Name 
                FROM Interventions__r
            )
            From Module__c 
            where Implementation_Period__c =: strImpPeriodID
            order by Name ];
        List<List<String>> lstInterventionData = new List<List<String>>();
        List<String> lstIntervents;
        Integer intMaxLength=0;
        For(Module__c objModuleInterventions : lstModuleIntervention){
            objModuleInterventionCascading.lstHeaders.add(objModuleInterventions.Name);
            if(objModuleInterventions.Interventions__r!=null && objModuleInterventions.Interventions__r.size() >intMaxLength){
                intMaxLength= objModuleInterventions.Interventions__r.size();
            }            
        }
        For(Integer intIntervention=0;intIntervention<intMaxLength;intIntervention++){
            lstIntervents = new List<String>();
            For(Integer intModuleCount=0;intModuleCount<objModuleInterventionCascading.lstHeaders.size();intModuleCount++){
                if(lstModuleIntervention[intModuleCount].Interventions__r!=null && lstModuleIntervention[intModuleCount].Interventions__r.size()>intIntervention){
                    lstIntervents.add(lstModuleIntervention[intModuleCount].Interventions__r[intIntervention].Name);
                }else{
                    lstIntervents.add('');
                }
            }
            lstInterventionData.add(lstIntervents);
        }
         
        objModuleInterventionCascading.lstCascadingData = lstInterventionData;
        lstBudgetModelNew.add(objModuleInterventionCascading );
    }
    public void fillModules(){
        GrantBudgetExcelModel objModulesModel = new GrantBudgetExcelModel();
        objModulesModel.IsProtected= 1;
        objModulesModel.strSheetname = 'Modules';
        objModulesModel.lstHeaders = New List<String>{'Module Name'};
        objModulesModel.lstData = New List<Map<String,String>>();
        for(Module__c objModule : [Select Name  from Module__c where Implementation_Period__c=:strImpPeriodID ]){                
            Map<String,String> rowdata = New Map<String,String>();            
            rowdata.put('Module Name',objModule.Name); 
            objModulesModel.lstData.add(rowdata);
        }       
       lstBudgetModelNew.add(objModulesModel);
    }
    
    public void fillPayees(){
        GrantBudgetExcelModel objPayeesModel = new GrantBudgetExcelModel();
        objPayeesModel.IsProtected= 1;
        objPayeesModel.strSheetname = 'Payees';
        objPayeesModel.lstHeaders = New List<String>{'Payee Name','Salesforce ID'};
        
        objPayeesModel.lstData = New List<Map<String,String>>();
        for(Implementer__c objImplementer: [Select Name, Id, Implementer_Name__c from Implementer__c where Grant_Implementation_Period__c =: strImpPeriodID]){                
            Map<String,String> rowdata = New Map<String,String>();            
            rowdata.put('Payee Name',objImplementer.Implementer_Name__c); 
            rowdata.put('Salesforce ID',objImplementer.ID);           
            objPayeesModel.lstData.add(rowdata);
        }            
        lstBudgetModelNew.add(objPayeesModel);
    }
    public void fillGIP(){
        GrantBudgetExcelModel objGIPModel = new GrantBudgetExcelModel();
        objGIPModel.IsProtected= 1;
        objGIPModel.strSheetname = 'GIP Data';
        objGIPModel.lstHeaders = New List<String>{'GIP Name','Currency of Grant Agreement','Local Currency','Other Currency','Exchange Rate','Other Currency Exchange Rate','Salesforce ID'};
        
        objGIPModel.lstData = New List<Map<String,String>>();
        for(Implementation_Period__c objGIP: [select id,Name,Currency_of_Grant_Agreement__c,Local_Currency__c,Other_Currency__c,Exchange_Rate__c,Other_Currency_Exchange_Rate__c from Implementation_Period__c]){                
            Map<String,String> rowdata = New Map<String,String>();            
            rowdata.put('GIP Name',objGIP.Name);
            rowdata.put('Currency of Grant Agreement',handleNULL(objGIP.Currency_of_Grant_Agreement__c));
            rowdata.put('Local Currency',handleNULL(objGIP.Local_Currency__c));
            rowdata.put('Other Currency',handleNULL(objGIP.Other_Currency__c));
            rowdata.put('Exchange Rate',handleNULL(String.valueOf(objGIP.Exchange_Rate__c)));
            rowdata.put('Other Currency Exchange Rate',handleNULL(String.valueOf(objGIP.Other_Currency_Exchange_Rate__c)));
            rowdata.put('Salesforce ID',objGIP.ID);           
            objGIPModel.lstData.add(rowdata);
        }             
        lstBudgetModelNew.add(objGIPModel);
    }
    String handleNULL(String value){
        if(value==null){
            return '';
        }else{
            return value;
        }
    }
    public void fillCostInputs(){
        GrantBudgetExcelModel objCostInputsModel = new GrantBudgetExcelModel();
        objCostInputsModel.IsProtected= 1;
        objCostInputsModel.strSheetname = 'CostInputs';
        objCostInputsModel.lstHeaders = New List<String>{'Cost Input Name','Cost Grouping','Unit Cost Definition','Salesforce ID'};
        
        String strDiseaseImpact;
        objCostInputsModel.lstData = New List<Map<String,String>>();        
        if(lstImpPriod[0].Grant__c!=null){
            strDiseaseImpact = lstImpPriod[0].Grant__r.Disease_Component__c;
        }
        for(Catalog_Cost_Input__c objCatalogCostInput: [Select Name, Id, Cost_Grouping__c, Unit_Cost_Definition__c from Catalog_Cost_Input__c where Disease_Impact__c INCLUDES (:strDiseaseImpact) and PSM__c = false]){                
            Map<String,String> rowdata = New Map<String,String>();            
            rowdata.put('Cost Input Name',objCatalogCostInput.Name);
            rowdata.put('Cost Grouping',objCatalogCostInput.Cost_Grouping__c);
            rowdata.put('Unit Cost Definition',handleNULL(objCatalogCostInput.Unit_Cost_Definition__c));
            rowdata.put('Salesforce ID',objCatalogCostInput.ID);           
            objCostInputsModel.lstData.add(rowdata);
        }             
        lstBudgetModelNew.add(objCostInputsModel);
    }
    Public void fillGrantInterventions(){        
        GrantBudgetExcelModel objGrantInterventionModel = new GrantBudgetExcelModel();
        objGrantInterventionModel.IsProtected= 1;
        objGrantInterventionModel.strSheetname = 'GrantInterventions';
        objGrantInterventionModel.lstHeaders = New List<String>{'GrantIntervention Name','Module','Salesforce ID','GrantModuleIntervention Name'};
        objGrantInterventionModel.lstData = New List<Map<String,String>>();
        
        for(Grant_Intervention__c objGrantIntervention : [Select Id, Name, Module__r.Name from Grant_Intervention__c where Implementation_Period__c =: strImpPeriodID]){                
            Map<String,String> rowdata = New Map<String,String>();            
            rowdata.put('GrantIntervention Name',String.valueof(objGrantIntervention.Name));
            rowdata.put('Module',handleNULL(String.valueOf(objGrantIntervention.Module__r.Name)));
            rowdata.put('Salesforce ID',String.valueOf(objGrantIntervention.ID));   
            rowdata.put('GrantModuleIntervention Name',String.valueof(objGrantIntervention.Name)+' - '+handleNULL(String.valueOf(objGrantIntervention.Module__r.Name)));        
            objGrantInterventionModel.lstData.add(rowdata);
        }             
        lstBudgetModelNew.add(objGrantInterventionModel);
    }   
    Public Pagereference downloadExcel(){ 
        Pagereference pr = Page.GrantBudgetExcel;   
        return pr;       
    }
               
    Public Class GrantBudgetExcelModel{
        Public Integer IsProtected {get;set;} // Worksheet lock status "1"=locked, "0"=unlocked
        Public String strSheetname {get;set;} // Worksheet name in excel file
        Public List<String> lstHeaders {get;set;} // header for worksheet excel
        Public List<Map<String,String>> lstData {get;set;} // collection of data with headers specified in "lstHeaders" fields above       
        Public List<List<String>> lstCascadingData {get;set;} // colleaction of data for each header value in list for dependent drop down list in excel
    }      
}