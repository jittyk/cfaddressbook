
<!-- Check if the user is logged in -->
<cfif NOT structKeyExists(session, "userId") OR session.userId EQ "" OR session.userId IS 0>
    <!-- Redirect to the login page if the session does not have a valid user ID -->
    <cflocation url="login.cfm">
</cfif>

<!-- Query to check the user's permissions -->
<cfquery name="checkPermission" datasource="dsn_address_book">
    SELECT intPermissionId
    FROM tbl_user_permissions
    WHERE intUserId = <cfqueryparam value="#session.userId#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif checkPermission.recordCount NEQ 0>
    <!-- Convert the query column to a comma-separated list -->
    <cfset permissionList = ValueList(checkPermission.intPermissionId)>

    <!-- Check if the user does not have permission (list does not contain the value 3) -->
    <cfif NOT listFind(permissionList, 2)>
        
        <cflocation url="contact.cfm">
        
    </cfif>
</cfif>


<cfif structKeyExists(url, "contactId")>
    <cfquery name="contact" datasource="dsn_address_book">
        SELECT strFirstName ,strLastName,intContact,strEmail,strQualification,strCountry,strCity,strState,strAddress,intPincode,strGender,strLanguages 
        FROM contacts 
        WHERE intContactId = #url.contactId#
    </cfquery>
</cfif>

<cfif structKeyExists(form, "submit")>
    <!-- Handle form submission -->
    <cfquery datasource="dsn_address_book">
        UPDATE contacts
        SET 
            strFirstName = <cfqueryparam value="#form.strFirstName#" cfsqltype="cf_sql_varchar">,
            strLastName = <cfqueryparam value="#form.strLastName#" cfsqltype="cf_sql_varchar">,
            intContact = <cfqueryparam value="#form.intContact#" cfsqltype="cf_sql_varchar">,
            strEmail = <cfqueryparam value="#form.strEmail#" cfsqltype="cf_sql_varchar">,
            strQualification = <cfqueryparam value="#form.strQualification#" cfsqltype="cf_sql_varchar">,
            strCountry = <cfqueryparam value="#form.strCountry#" cfsqltype="cf_sql_varchar">,
            strCity = <cfqueryparam value="#form.strCity#" cfsqltype="cf_sql_varchar">,
            strState = <cfqueryparam value="#form.strState#" cfsqltype="cf_sql_varchar">,
            strAddress = <cfqueryparam value="#form.strAddress#" cfsqltype="cf_sql_varchar">,
            intPincode = <cfqueryparam value="#form.intPincode#" cfsqltype="cf_sql_varchar">,
            strGender = <cfqueryparam value="#form.strGender#" cfsqltype="cf_sql_varchar">,
            strLanguages = <cfqueryparam value="#form.strLanguages#" cfsqltype="cf_sql_varchar">
        WHERE intContactId = #url.contactId#
    </cfquery>
     <cflocation url="contact.cfm">
</cfif>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Contact</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-secondary">
        <div class="container-fluid">
           <a class="navbar-brand" href="user.cfm"><b>Address Book</b></a>
           <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
              <span class="navbar-toggler-icon"></span>
           </button>
           <div class="collapse navbar-collapse" id="navbarNav">
              <ul class="navbar-nav ms-auto align-items-center">
                 <li class="nav-item"><a class="nav-link" href="#">Family</a></li>
                 <li class="nav-item"><a class="nav-link" href="#">Friends</a></li>
                 <li class="nav-item"><a class="nav-link" href="#">Colleagues</a></li>
                 <li class="nav-item">
                    <form class="d-inline-block" method="get" action="user.cfm">
                       <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search" name="searchTerm">
                    </form>
                 </li>
                 <li class="nav-item">
                    <a class="nav-link p-0" href="jitty.cfm">
                       <img src="images\contacts.jpg" alt="Profile" class="rounded-circle" style="width: 40px; height: 40px; margin-left: 6px;">
                    </a>
                 </li>
                 <!-- Logout button with icon -->
                 <li class="nav-item">
                    <a class="nav-link text-white d-flex align-items-center" href="userlogout.cfm">
                       <i class="bi bi-box-arrow-right icon-white"></i> 
                       <span class="ms-2">Logout</span>
                    </a>
                 </li>
              </ul>
           </div>
        </div>
     </nav>
    <cfoutput>
    <div class="container mt-4">
        <h2>Edit Contact</h2>
        <form method="post" action="editContact.cfm?contactId=#url.contactId#">
            <div class="mb-3">
                <label for="strFirstName" class="form-label">First Name</label>
                <input type="text" class="form-control" id="strFirstName" name="strFirstName" value="#contact.strFirstName#" required>
            </div>
            <div class="mb-3">
                <label for="strLastName" class="form-label">Last Name</label>
                <input type="text" class="form-control" id="strLastName" name="strLastName" value="#contact.strLastName#" required>
            </div>
            <div class="mb-3">
                <label for="intContact" class="form-label">Contact</label>
                <input type="text" class="form-control" id="intContact" name="intContact" value="#contact.intContact#" required>
            </div>
            <div class="mb-3">
                <label for="strEmail" class="form-label">Email</label>
                <input type="email" class="form-control" id="strEmail" name="strEmail" value="#contact.strEmail#">
            </div>
            <div class="mb-3">
                <label for="strQualification" class="form-label">Qualification</label>
                <input type="text" class="form-control" id="strQualification" name="strQualification" value="#contact.strQualification#">
            </div>
            <div class="mb-3">
                <label for="strCountry" class="form-label">Country</label>
                <input type="text" class="form-control" id="strCountry" name="strCountry" value="#contact.strCountry#">
            </div>
            <div class="mb-3">
                <label for="strCity" class="form-label">City</label>
                <input type="text" class="form-control" id="strCity" name="strCity" value="#contact.strCity#">
            </div>
            <div class="mb-3">
                <label for="strState" class="form-label">State</label>
                <input type="text" class="form-control" id="strState" name="strState" value="#contact.strState#">
            </div>
            <div class="mb-3">
                <label for="strAddress" class="form-label">Address</label>
                <input type="text" class="form-control" id="strAddress" name="strAddress" value="#contact.strAddress#">
            </div>
            <div class="mb-3">
                <label for="intPincode" class="form-label">Pincode</label>
                <input type="text" class="form-control" id="intPincode" name="intPincode" value="#contact.intPincode#">
            </div>
            <div class="mb-3">
                <label for="strGender" class="form-label">Gender</label>
                <input type="text" class="form-control" id="strGender" name="strGender" value="#contact.strGender#">
            </div>
            <div class="mb-3">
                <label for="strLanguages" class="form-label">Languages</label>
                <input type="text" class="form-control" id="strLanguages" name="strLanguages" value="#contact.strLanguages#">
            </div>
            <button type="submit" name="submit" class="btn btn-primary mb-1">Update Contact</button>
        </form>
        
    </div>
</cfoutput>
<footer class="mt-auto bg-dark text-white py-3">
    <div class="container">
       <div class="row">
          <div class="col-12 mb-3">
             <ul class="list-unstyled d-flex flex-column flex-md-row justify-content-center mb-0">
                <li class="me-md-3 mb-2 mb-md-0"><a href="#" class="text-white text-decoration-none">Family</a></li>
                <li class="me-md-3 mb-2 mb-md-0"><a href="#" class="text-white text-decoration-none">Friends</a></li>
                <li><a href="#" class="text-white text-decoration-none">Colleagues</a></li>
             </ul>
          </div>
          <div class="col-12 mb-3 d-flex justify-content-center">
             <div class="col-10 col-md-6 col-lg-4">
                <form method="get" action="index.cfm">
                   <input type="search" class="form-control" placeholder="Search" name="searchTerm">
                </form>
             </div>
          </div>
          <div class="col-12 text-center text-md-end">
             <a class="navbar-brand" href="user.cfm"><b>Address Book</b></a>
          </div>
       </div>
    </div>
 </footer>
</body>
</html>
