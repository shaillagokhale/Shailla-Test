/*********************************************************************************
* Test Class: {TestStopRecursion}
*  DateCreated : 01/30/2014
----------------------------------------------------------------------------------
* Purpose/Methods:
* - Used for cover all methods of StopRecursion.
----------------------------------------------------------------------------------
* History:
* - VERSION  DEVELOPER NAME    DATE            DETAIL FEATURES
     1.0                      01/30/2014      INITIAL DEVELOPMENT
*********************************************************************************/

@isTest
Public Class TestStopRecursion{
    Public static testMethod void TestStopRecursion(){
    
    StopRecursion objStopRecursion = new StopRecursion(); 
    StopRecursion.hasAlreadyCreatedFollowUpTasks();
    StopRecursion.setAlreadyCreatedFollowUpTasks();
    //StopRecursion.getFollowUpSubject(null);
    }
}