@isTest
Public Class TestautoCompleteController{
    Public Static testMethod void TestautoCompleteController(){
        
        autoCompleteController obj = new autoCompleteController();
        //(string obj, string qry, string addFields, string profilename) 
       SObject[] obj1=autoCompleteController.findSObjects('account', 'select id from account', 'Name', 'CCM Users') ;
        
    }
}