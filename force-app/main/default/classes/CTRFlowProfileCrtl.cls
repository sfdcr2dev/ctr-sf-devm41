public class CTRFlowProfileCrtl 
{
	@InvocableMethod(label='GetUserFromProfile')
    public static List<List<String>> function(List<FlowInputs> mData) 
    {   
        List<List<String>> mOutPutList = new List<List<String>>();
        String mProfileName = '%'+mData[0].mProfileName+'%';
        List<User> mUserList = [SELECT Id, Name, FirstName, LastName, ProfileId, Profile.Name FROM User WHERE Profile.Name LIKE:mProfileName];
       	//FlowOutputs mOutPut = new FlowOutputs();
        //FlowOutputs.mUserList = mUserList;
        List<String> mUserId = new List<String>();
        for(User mUser: mUserList)
        {
            mUserId.add(mUser.Id);
        }
        mOutPutList.add(mUserId);
        return mOutPutList;
    }


    //input details that comes to apex from flow
    public class FlowInputs
    {
        @InvocableVariable
        public String mProfileName;
    }
}