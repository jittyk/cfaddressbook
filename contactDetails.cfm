<cfif not structKeyExists(session, "userId") or session.userId EQ "" or session.userId IS 0>
    <cflocation url="login.cfm">
</cfif>
<cfif listFind(session.permissionList, 1)>
   <!-- User has permission to delete -->
   <cflocation url="contactDetails.cfm">
<cfelse>
   <!-- User does not have permission -->
   <cflocation url="contact.cfm">
</cfif>


<!DOCTYPE html>
<html lang="en">
   <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Index Page</title>
      <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
      <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
      <style>.log-container {
        justify-content: center;
        align-items: center;
        width: 100%;
    }</style>
   </head>
   <body class="column min-vh-100">
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
      
<cfparam name="url.contactId" default="0">

<!-- Query to fetch the selected contact details -->
<cfquery name="contactDetails" datasource="dsn_address_book">
    SELECT int_contact_id, str_first_name, str_last_name, int_contact, str_email, str_qualification, str_country, str_city, str_state, str_address, int_pincode, str_gender, str_languages
    FROM contacts
    WHERE int_contact_id = <cfqueryparam value="#url.int_contact_id#" cfsqltype="cf_sql_integer">
</cfquery>



<cfoutput>
<cfif contactDetails.recordCount GT 0>
    <body >
    <div class="log-container mt-4 ">
        <h2>Contact Details</h2>
        <p><strong>First Name:</strong> #contactDetails.str_first_name#</p>
        <p><strong>Last Name:</strong> #contactDetails.str_last_name#</p>
        <p><strong>Contact Number:</strong> #contactDetails.int_contact#</p>
        <p><strong>Email:</strong> #contactDetails.str_email#</p>
        <p><strong>Qualification:</strong> #contactDetails.str_qualification#</p>
        <p><strong>Country:</strong> #contactDetails.str_country#</p>
        <p><strong>City:</strong> #contactDetails.str_city#</p>
        <p><strong>State:</strong> #contactDetails.str_state#</p>
        <p><strong>Address:</strong> #contactDetails.str_address#</p>
        <p><strong>Pincode:</strong> #contactDetails.int_pincode#</p>
        <p><strong>Gender:</strong> #contactDetails.str_gender#</p>
        <p><strong>Languages:</strong> #contactDetails.str_languages#</p>
    </div>
<cfelse>
    <p>No contact details found.</p>
</cfif>
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
 
 <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>