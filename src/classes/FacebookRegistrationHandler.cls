/**
  FaceBook Registration Handler example
**/
global class FacebookRegistrationHandler implements Auth.RegistrationHandler{
    
    private static final String ORG_SUFFIX = '.sso.badge.org';
    private static final String DEFAULT_ACCOUNTNAME = 'Customers';
    private static final String EXTERNAL_USER_PROFILE = 'Customers';
    private static final String INTERNAL_USER_PROFILE = 'Standard User';    
    
/**
 * Let anyone register as long as the required fields are supplied
 * 
 * We require email, lastName, firstName
 * 
 * @data - the user's info from the Auth Provider
 **/ 
global boolean canCreateUser(Auth.UserData data) {
    Boolean retVal = (data != null 
            && data.email != null
            && data.lastName != null
            && data.firstName != null);
    
    return retVal;
}

/**
 * Create the User - A required method to implement the Handler Interface
 * 
 * @param portalId  - Id of the Community
 * @param data - Auth Provider user data describing the User to create
 * 
 * @return User that has been initialized
**/ 
global User createUser(Id portalId, Auth.UserData data){
    if(!canCreateUser(data)) {
        // Returning null signals the auth framework we can't create the user
        return null;
    }
    
    // Is this a Community Context?
    if(data.attributeMap.containsKey('sfdc_networkid')) {
        Id contactId;
        // To keep things modular, we're creating the Contact in a separate method
        contactId = createContact(data);
        
        // You'd likely use other logic to assign the Profile
        Profile p = [SELECT Id FROM profile WHERE name=:EXTERNAL_USER_PROFILE];

        // Keeping it modular, we initialize the user in another method
        User u = createUser(data,p);
        
        u.contactId = contactId;
        return u;
    } else {
        //This is not a community, so we Assign an internal profile
        Profile p = [SELECT Id FROM profile WHERE name=:INTERNAL_USER_PROFILE];
        
        // Keeping it modular, we initialize the user in another method
        User u = createUser(data,p);

        return u;
    }
}

/**
 * Update the user
 * @param portalId  - Id of the Community
 * @param data - Auth Provider user data describing the User to create
 **/     
global void updateUser(Id userId, Id portalId, Auth.UserData data){
    
    User u = new User(id=userId);
    u.email = data.email;
    u.lastName = data.lastName;
    u.firstName = data.firstName;
    u.CommunityNickname = data.firstName + ' ' + data.lastName;
    update(u);
}
    /**
     * Create a Contact
     * 
     * @param data - Facebook provided context for the User
     **/
    private Id createContact(Auth.UserData data){
        Contact contact = new Contact();
        contact.LastName = data.lastName;
        contact.FirstName = data.firstName;
        contact.Email = data.email;
        
        // set Account Id
        if (data.attributemap.get('accountId') != null){
            contact.accountId = data.attributemap.get('accountId');
        } else {
            List<Account> accounts = [select Id from Account where Name =:DEFAULT_ACCOUNTNAME];
            
            contact.accountId = accounts[0].Id;            
        }
        insert contact;

        return contact.id; 
    }

    
    /**
     * Create and initialize the User but don't save it yet
     * 
     * @param data - the provided User context from FaceBook
     * @param p - the Profile we are going to assign to this user
     * 
     * @return User that has been initialized but not Saved
     **/ 
    private User createUser(Auth.UserData data, Profile p) {
        User u = new User();
        u.username = data.email + ORG_SUFFIX;
        u.email = data.email;
        u.lastName = data.lastName;
        u.firstName = data.firstName;
        u.CommunityNickname = data.firstName + ' ' + data.lastName;
        String alias = data.firstName + data.lastName;
        
        //Alias must be 8 characters or less
        if(alias.length() > 8) {
            alias = alias.substring(0, 8);
        }
        u.alias = alias;
        u.languagelocalekey = UserInfo.getLanguage();
        u.localesidkey = UserInfo.getLocale();
        u.emailEncodingKey = 'UTF-8';
        u.timeZoneSidKey = 'America/Los_Angeles';
        u.profileId = p.Id;
        return u;
    }        
}