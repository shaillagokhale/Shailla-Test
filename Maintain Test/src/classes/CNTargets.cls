public class CNTargets {
    public Grant_Indicator__c GI {get;set;}
    public Id GID {get;set;}
    public string strGID {get;set;}
    public Id CNID {get;set;}
    public List<Grant_Indicator__c> lstCNTargets {get;set;}
    public Grant_Indicator__c CNTarget {get;set;}
    
     public CNTargets () {
        if(String.IsBlank(strGID) == false) {
            CNTarget = [select Id, Indicator_Full_Name__c,Data_Type__c, Above_Indicative_Denominator1__c,Above_Indicative_Denominator2__c,Decimal_Places__c,Spanish_Name__c ,Russian_Name__c,French_Name__c,
                                                    Above_Indicative_Denominator3__c,Above_Indicative_Denominator4__c,
                                                    Above_Indicative_Numerator1__c,Above_Indicative_Numerator2__c,
                                                    Above_Indicative_Numerator3__c,Above_Indicative_Numerator4__c,
                                                    Above_Indicative_Percent1__c,Above_Indicative_Percent2__c,Above_Indicative_Percent3__c,
                                                    Above_Indicative_Percent4__c,Indicative_Denominator1__c,Indicative_Denominator2__c,
                                                    Indicative_Denominator3__c,Indicative_Denominator4__c,IndicativeNumerator1__c,
                                                    IndicativeNumerator2__c,IndicativeNumerator3__c,IndicativeNumerator4__c,
                                                    Indicative_Percent1__c,Indicative_Percent2__c,Indicative_Percent3__c,Indicative_Percent4__c,Comments__c,Country_Team_Comments__c,LFA_Comments__c,Subset_Of__c,Grant_Implementation_Period__c                                
                                                    from Grant_Indicator__c
                                                    Where 
                                                    Id =: strGID                                                    
                                                    ];
            lstCNTargets = new List<Grant_Indicator__c>();
            lstCNTargets.add(CNTarget);                                            
            system.debug('Grant Implementation ID ' +CNTarget);
        }
     }
    
    public CNTargets(ApexPages.StandardController StdController){
        
        GID = ApexPages.currentpage().getparameters().get('id');
        CNTarget = [select Id, Indicator_Full_Name__c,Data_Type__c, Above_Indicative_Denominator1__c,Above_Indicative_Denominator2__c,Decimal_Places__c,Spanish_Name__c ,Russian_Name__c,French_Name__c,
                                                    Above_Indicative_Denominator3__c,Above_Indicative_Denominator4__c,
                                                    Above_Indicative_Numerator1__c,Above_Indicative_Numerator2__c,
                                                    Above_Indicative_Numerator3__c,Above_Indicative_Numerator4__c,
                                                    Above_Indicative_Percent1__c,Above_Indicative_Percent2__c,Above_Indicative_Percent3__c,
                                                    Above_Indicative_Percent4__c,Indicative_Denominator1__c,Indicative_Denominator2__c,
                                                    Indicative_Denominator3__c,Indicative_Denominator4__c,IndicativeNumerator1__c,
                                                    IndicativeNumerator2__c,IndicativeNumerator3__c,IndicativeNumerator4__c,
                                                    Indicative_Percent1__c,Indicative_Percent2__c,Indicative_Percent3__c,Indicative_Percent4__c,Comments__c,Country_Team_Comments__c,LFA_Comments__c,Subset_Of__c,Grant_Implementation_Period__c                                
                                                    from Grant_Indicator__c
                                                    Where 
                                                    Id =: GID                                                    
                                                    ];
        lstCNTargets = new List<Grant_Indicator__c>();
        lstCNTargets.add(CNTarget);                                            
        system.debug('Grant Implementation ID ' +CNTarget);        
    }
}