
<!-- Check if the user is logged in -->
<cfif NOT structKeyExists(session, "userId") OR session.userId EQ "" OR session.userId IS 0>
    <!-- Redirect to the login page if the session does not have a valid user ID -->
    <cflocation url="login.cfm">
</cfif>
<cfif not listFind(session.permissionList, 2)>
    <!-- User has permission to delete -->
    <cflocation url="contact.cfm">
</cfif>

<cfset  datasource="dsn_address_book">
<cfif structKeyExists(url, "int_contact_id")>
    <cfquery name="contact" datasource="#datasource#">
        SELECT int_contact_id, str_first_name, str_last_name, int_contact, str_email, str_qualification, str_country, str_city, str_state, str_address, int_pincode, str_gender, str_languages
        FROM contacts 
        WHERE int_contact_id = #url.int_contact_id#
    </cfquery>
</cfif>

<cfif structKeyExists(form, "submit")>
    <!-- Handle form submission -->
    <cfquery datasource="#datasource#">
        UPDATE contacts
        SET 
            str_first_name = <cfqueryparam value="#form.str_first_name#" cfsqltype="cf_sql_varchar">,
            str_last_name = <cfqueryparam value="#form.str_last_name#" cfsqltype="cf_sql_varchar">,
            int_contact = <cfqueryparam value="#form.int_contact#" cfsqltype="cf_sql_varchar">,
            str_email = <cfqueryparam value="#form.str_email#" cfsqltype="cf_sql_varchar">,
            str_qualification = <cfqueryparam value="#form.str_qualification#" cfsqltype="cf_sql_varchar">,
            str_country = <cfqueryparam value="#form.str_country#" cfsqltype="cf_sql_varchar">,
            str_city = <cfqueryparam value="#form.str_city#" cfsqltype="cf_sql_varchar">,
            str_state = <cfqueryparam value="#form.str_state#" cfsqltype="cf_sql_varchar">,
            str_address = <cfqueryparam value="#form.str_address#" cfsqltype="cf_sql_varchar">,
            int_pincode = <cfqueryparam value="#form.int_pincode#" cfsqltype="cf_sql_varchar">,
            str_gender = <cfqueryparam value="#form.str_gender#" cfsqltype="cf_sql_varchar">,
            str_languages = <cfqueryparam value="#form.str_languages#" cfsqltype="cf_sql_varchar">
        WHERE int_contact_id = #url.int_contact_id#
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
           <a class="nav-link text-white">Hello <cfoutput>#session.str_user_name#</cfoutput></a>
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
                    <a class="nav-link p-0" href="userprofile.cfm">
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
        <form method="post" action="editContact.cfm?int_contact_id=#url.int_contact_id#">
            <div class="mb-3">
                <label for="str_first_name" class="form-label">First Name</label>
                <input type="text" class="form-control" id="str_first_name" name="str_first_name" value="#contact.str_first_name#" required>
            </div>
            <div class="mb-3">
                <label for="str_last_name" class="form-label">Last Name</label>
                <input type="text" class="form-control" id="str_last_name" name="str_last_name" value="#contact.str_last_name#" required>
            </div>
            <div class="mb-3">
                <label for="int_contact" class="form-label">Contact</label>
                <input type="text" class="form-control" id="int_contact" name="int_contact" value="#contact.int_contact#" required>
            </div>
            <div class="mb-3">
                <label for="str_email" class="form-label">Email</label>
                <input type="email" class="form-control" id="str_email" name="str_email" value="#contact.str_email#">
            </div>
            <div class="mb-3">
                <label for="str_qualification" class="form-label">Qualification</label>
                <input type="text" class="form-control" id="str_qualification" name="str_qualification" value="#contact.str_qualification#">
            </div>
            <div class="mb-3">
                <label for="str_country" class="form-label">Country</label>
                <input type="text" class="form-control" id="str_country" name="str_country" value="#contact.str_country#">
            </div>
            <div class="mb-3">
                <label for="str_city" class="form-label">City</label>
                <input type="text" class="form-control" id="str_city" name="str_city" value="#contact.str_city#">
            </div>
            <div class="mb-3">
                <label for="str_state" class="form-label">State</label>
                <input type="text" class="form-control" id="str_state" name="str_state" value="#contact.str_state#">
            </div>
            <div class="mb-3">
                <label for="str_address" class="form-label">Address</label>
                <input type="text" class="form-control" id="str_address" name="str_address" value="#contact.str_address#">
            </div>
            <div class="mb-3">
                <label for="int_pincode" class="form-label">Pincode</label>
                <input type="text" class="form-control" id="int_pincode" name="int_pincode" value="#contact.int_pincode#">
            </div>
            <div class="mb-3">
                <label for="str_gender" class="form-label">Gender</label>
                <input type="text" class="form-control" id="str_gender" name="str_gender" value="#contact.str_gender#">
            </div>
            <div class="mb-3">
                <label for="str_languages" class="form-label">Languages</label>
                <input type="text" class="form-control" id="str_languages" name="str_languages" value="#contact.str_languages#">
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
