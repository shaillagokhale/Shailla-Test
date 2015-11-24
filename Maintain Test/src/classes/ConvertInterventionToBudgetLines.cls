global class ConvertInterventionToBudgetLines
{

List<PSM_Intervention_Split__c> lstPSMIS = new List<PSM_Intervention_Split__c>();
List<Budget_Line__c> lstBL = new List<Budget_Line__c>();
List<Id> lstPSMID = new List<Id>();

List<Id> lstGIPId = new List<Id>();

List<Budget_Line__c> lstPrev_BL = new List<Budget_Line__c>();



    global void ConversionMethod(List<Id> lstGIPID)
    {
    
    System.debug ('The list GIP Id is ' + lstGIPId);
    
    lstPrev_BL = [Select Id, Name, Cost_Input__c, Grant_Intervention__c, Payee__c from Budget_Line__c where Grant_Intervention__r.Implementation_Period__c in:lstGIPID and On_Button_Click__c=:true]; 
    
    if(!lstPrev_BL.isEmpty())
    {
    
        delete lstPrev_BL; 
    
    }
        
    AggregateResult[] groupedResults = [Select  Intervention__c, Sum(Q1_Amount__c) q1, Sum(Q2_Amount__c) q2, Sum(Q3_Amount__c) q3, Sum(Q4_Amount__c) q4, Sum(Q5_Amount__c) q5, Sum(Q6_Amount__c) q6, Sum(Q7_Amount__c) q7, Sum(Q8_Amount__c) q8, Sum(Q9_Amount__c) q9, Sum(Q10_Amount__c) q10, Sum(Q11_Amount__c) q11, Sum(Q12_Amount__c) q12, Sum(Q13_Amount__c) q13, Sum(Q14_Amount__c) q14,Sum(Q15_Amount__c) q15,Sum(Q16_Amount__c) q16,  Product__r.Implementer__c implement, Product__r.Cost_Input__c catalog from PSM_Intervention_Split__c where Intervention__r.Implementation_Period__c in: lstGIPId group by Intervention__c,Product__r.Implementer__c,Product__r.Cost_Input__c];
    System.debug ('The grouped result is ' + groupedResults+ 'and the size is ' + groupedResults.size());
    

  /*  for (AggregateResult ar : groupedResults) 
        {
        Id tempId;        
        tempId = ar.Id;         
        lstPSMID.add(tempId);
        
        System.debug ('The Intervention is ' + ar.get('Intervention__c'));
        System.debug ('The Implementer is ' + ar.get('implement'));
        System.debug ('The cost is ' + ar.get('catalog'));
        }*/
    
    //lstPSMIS = [Select Id, Name,Q1_Amount__c,Q2_Amount__c,Q3_Amount__c,Q4_Amount__c,Q5_Amount__c,Q6_Amount__c,Q7_Amount__c,Q8_Amount__c,Q9_Amount__c,Q10_Amount__c,Q11_Amount__c,Q12_Amount__c,Q13_Amount__c,Q14_Amount__c,Q15_Amount__c,Q16_Amount__c from PSM_Intervention_Split__c where id in:lstPSMID];
    
    
    if(groupedResults.size()!=0) //!lstPSMIS.isEmpty() && 
    {
        for (AggregateResult ar : groupedResults)
        {
        
            //for (PSM_Intervention_Split__c temp_psm: lstPSMIS)
            //{
            
                //if (temp_psm.id == ar.id)
                //{
    
                    Budget_Line__c bl = new Budget_Line__c();
                    
                    //bl.Q1_Amount__c = integer.Valueof(temp_psm.Q1_Amount__c + temp_psm.Q2_Amount__c + temp_psm.Q3_Amount__c + temp_psm.Q4_Amount__c + temp_psm.Q5_Amount__c + temp_psm.Q6_Amount__c + temp_psm.Q7_Amount__c + temp_psm.Q8_Amount__c + temp_psm.Q9_Amount__c + temp_psm.Q10_Amount__c + temp_psm.Q11_Amount__c + temp_psm.Q12_Amount__c + temp_psm.Q13_Amount__c + temp_psm.Q14_Amount__c + temp_psm.Q15_Amount__c + temp_psm.Q16_Amount__c);
                    
                    bl.Q1_Amount__c = (Decimal)ar.get('q1'); 
                    bl.Q2_Amount__c = (Decimal)ar.get('q2');
                    bl.Q3_Amount__c = (Decimal)ar.get('q3');
                    bl.Q4_Amount__c = (Decimal)ar.get('q4');
                    bl.Q5_Amount__c = (Decimal)ar.get('q5');
                    bl.Q6_Amount__c = (Decimal)ar.get('q6');
                    bl.Q7_Amount__c = (Decimal)ar.get('q7');
                    bl.Q8_Amount__c = (Decimal)ar.get('q8');
                    bl.Q9_Amount__c = (Decimal)ar.get('q9');
                    bl.Q10_Amount__c = (Decimal)ar.get('q10');
                    bl.Q11_Amount__c = (Decimal)ar.get('q11');
                    bl.Q12_Amount__c = (Decimal)ar.get('q12');
                    bl.Q13_Amount__c = (Decimal)ar.get('q13');
                    bl.Q14_Amount__c = (Decimal)ar.get('q14');
                    bl.Q15_Amount__c = (Decimal)ar.get('q15');
                    bl.Q16_Amount__c = (Decimal)ar.get('q16');
                                       
                    bl.Grant_Intervention__c = (Id)ar.get('Intervention__c');
                    bl.Payee__c = (Id)ar.get('implement');
                    bl.Cost_Input__c = (Id)ar.get('catalog');
                    bl.On_Button_Click__c = true;
                        
                    lstBL.add(bl);
                    
                    System.debug ('The list BL is ' + lstBL + 'and the size is ' + lstBL.size());
                //}                            
            //}
        
        }
    
    insert lstBL; 
    
    }


    }
    
}