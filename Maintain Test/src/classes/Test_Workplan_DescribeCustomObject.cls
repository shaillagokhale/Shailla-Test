@istest
private class Test_Workplan_DescribeCustomObject{
    
    Test_Workplan_DescribeCustomObject Workplan_DescribeCustomObject;
    public static String profilename = 'System Administrator';
    
    static testMethod void testWorkplan_DescribeCustomObject(){
    try{
    test.starttest();
    User newUser = TestUtility.singleUser(profilename);
    insert newUser;
    
    string customObjectId = Workplan_DescribeCustomObject.getCustomObjectId('Task');
    //System.assertEquals('01Ig0000000DCru', customObjectId );
    test.stoptest();
    }catch (Exception e) {
    System.assert(false, 'Exception ' + e);
    }
    }
}