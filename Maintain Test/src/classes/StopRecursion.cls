public class StopRecursion{

public static boolean alreadyCreatedTasks = false;
public static boolean alreadyCreatedAccFeed = false;
public static boolean alreadyCreatedBankAcc_LFA_Rev = false;
public static boolean alreadyCreatedImpApproval = false;
public static boolean alreadyCreatedBankApproval = false;

    public static boolean hasAlreadyCreatedFollowUpTasks() 
    {
      return alreadyCreatedTasks;
    }
 
    public static void setAlreadyCreatedFollowUpTasks() 
    {

        alreadyCreatedTasks = true;

    }
    
    //--------------------For Account Approval Status Explanation-----------------

    public static boolean hasAlreadyCreatedAccFeed() 

    {

        return alreadyCreatedAccFeed;

    }
    public static void setAlreadyCreatedAccFeed() 
    {

        alreadyCreatedAccFeed = true;

    }
    
    //-------------------------------------------------------------------------------------------
    
     public static boolean hasAlreadyCreatedBankAcc_LFA_Rev() 

    {

        return alreadyCreatedBankAcc_LFA_Rev;

    }
    public static void setAlreadyCreatedBankAcc_LFA_Rev() 
    {

        alreadyCreatedBankAcc_LFA_Rev = true;

    }
    
    
    //--------------------For Implementation Approval Status Explanantion--------------------
     public static boolean hasAlreadyCreatedImpApproval() 

    {

        return alreadyCreatedImpApproval;

    }
    public static void setAlreadyCreatedImpApproval() 
    {

        alreadyCreatedImpApproval = true;

    }

 //------------------------------------------------------------------------
 
  //--------------------For Bank Account Approval Status Explanantion--------------------
     public static boolean hasAlreadyCreatedBankApproval() 

    {

        return alreadyCreatedBankApproval;

    }
    public static void setAlreadyCreatedBankApproval() 
    {

        alreadyCreatedBankApproval = true;

    }

 //------------------------------------------------------------------------


}