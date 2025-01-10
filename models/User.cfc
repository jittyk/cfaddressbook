component persistent="true" table="tbl_users" {
    // Properties
    property name="user_id" fieldtype="id" generator="identity";
    property name="firstName" column="str_first_name" ormtype="string";
    property name="lastName" column="str_last_name" ormtype="string";
    property name="email" column="str_email" ormtype="string";
    property name="password" column="str_password" ormtype="string";
    property name="profileImage" column="str_profile_image" ormtype="string";
    property name="createdDate" column="dt_created_date" ormtype="timestamp";
    property name="modifiedDate" column="dt_modified_date" ormtype="timestamp";

    // Constructor
    public User function init() {
        return this;
    }

    // Get current user
    public User function getCurrentUser(required numeric userId) {
        var user = entityLoadByPK("User", userId);
        if (isNull(user)) {
            throw(type="CustomError", message="User not found");
        }
        return user;
    }

    // Get full name
    public string function getFullName() {
        return "#getFirstName()# #getLastName()#";
    }

    // Get profile image
    public string function getProfileImage() {
        var image = getProfileImage();
        return len(image) ? image : "../images/contacts.jpg";
    }

    // Pre-insert
    public void function preInsert() {
        setCreatedDate(now());
        setModifiedDate(now());
    }

    // Pre-update
    public void function preUpdate() {
        setModifiedDate(now());
    }
}