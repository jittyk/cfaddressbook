<cfinclude template="addContact.cfm">
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Contact Form</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="styles\styles.css">
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
                    <a class="nav-link text-white d-flex align-items-center" href="userLogout.cfm">
                       <i class="bi bi-box-arrow-right icon-white"></i> 
                       <span class="ms-2">Logout</span>
                    </a>
                 </li>
              </ul>
           </div>
        </div>
     </nav>
   
    
        <cfoutput>
        <div class="headdiv text-center">
            <h1>ADD CONTACT </h1>
        </div>
        <cfif len(strErrorMsg)>
            <div style="color: red;">#strErrorMsg#</div>  
        <cfelse>
            <div style="color: green;">#strSuccessMsg#</div>  
        </cfif>

        <form action="" method="POST" class="container">
            <div class="mb-3 row">
                <label for="fname" class="col-sm-2 col-form-label">First Name</label>
                <div class="col-sm-10">
                    <input type="text" id="fname" name="str_first_name" class="form-control" placeholder="Your name.." value="#str_first_name#">
                </div>
            </div>
            <div class="mb-3 row">
                <label for="lname" class="col-sm-2 col-form-label">Last Name</label>
                <div class="col-sm-10">
                    <input type="text" id="lname" name="str_last_name" class="form-control" placeholder="Your last name.." value="#str_last_name#">
                </div>
            </div>
            <div class="mb-3 row">
                <label for="int_contact" class="col-sm-2 col-form-label">Contact no</label>
                <div class="col-sm-10">
                    <input type="text" id="int_contact" name="int_contact" class="form-control" placeholder="Contact number.." value="#int_contact#">
                </div>
            </div>
            <div class="mb-3 row">
                <label for="str_email" class="col-sm-2 col-form-label">Email</label>
                <div class="col-sm-10">
                    <input type="text" id="str_email" name="str_email" class="form-control" placeholder="Your Email.." value="#str_email#">
                </div>
            </div>
            <!-- Qualification Dropdown -->
            <div class="mb-3 row">
                <label for="str_qualification" class="col-sm-2 col-form-label">Qualification</label>
                <div class="col-sm-10">
                    <select id="str_qualification" name="str_qualification" class="form-select">
                        <option value="">Select Qualification</option>
                        <!-- Loop through qualifications from the database -->
                        
                        <cfloop query="qrygetstrQualifications">
                            <option value="#qrygetstrQualifications.str_qualification_name#"
                                <cfif structKeyExists(form, "str_qualification") AND form.str_qualification EQ qrygetstrQualifications.str_qualification_name>
                                    selected="selected"
                                </cfif>>
                                #qrygetstrQualifications.str_qualification_name#
                            </option>
                        </cfloop>
                    </select>
                </div>
            </div>
            <div class="mb-3 row">
                <label for="str_country" class="col-sm-2 col-form-label">Country</label>
                <div class="col-sm-10">
                    <select id="str_country" name="str_country" class="form-select">
                        <option value="">Select Country</option>
                       
                        <cfloop query="qrygetCountries">
                            <option value="#qrygetCountries.str_country_name#"
                                <cfif structKeyExists(form, "str_country") AND form.str_country EQ qrygetCountries.str_country_name>
                                    selected="selected"
                                </cfif>>
                                #qrygetCountries.str_country_name#
                            </option>
                        </cfloop>
                    </select>
                </div>
            </div>
            <div class="mb-3 row">
                <label for="str_city" class="col-sm-2 col-form-label">City</label>
                <div class="col-sm-10">
                    <input type="text" id="str_city" name="str_city" class="form-control" placeholder="Your City.." value="#str_city#">
                </div>
            </div>
            <div class="mb-3 row">
                <label for="str_state" class="col-sm-2 col-form-label">State</label>
                <div class="col-sm-10">
                    <input type="text" id="str_state" name="str_state" class="form-control" placeholder="Your State.." value="#str_state#">
                </div>
            </div>
            <div class="mb-3 row">
                <label for="str_address" class="col-sm-2 col-form-label">Address</label>
                <div class="col-sm-10">
                    <input type="text" id="str_address" name="str_address" class="form-control" placeholder="Your Address.." value="#str_address#">
                </div>
            </div>
            <div class="mb-3 row">
                <label for="int_pincode" class="col-sm-2 col-form-label">Pincode</label>
                <div class="col-sm-10">
                    <input type="text" id="int_pincode" name="int_pincode" class="form-control" placeholder="Your Pincode.." value="#int_pincode#">
                </div>
            </div>
            <div class="mb-3 row">
                <label for="str_gender" class="col-sm-2 col-form-label">Gender</label>
                <div class="col-sm-10">
                    <div>
                        <input type="radio" id="male" name="str_gender" value="Male"
                            <cfif str_gender EQ "Male">checked="checked"</cfif>> 
                        <label for="male">Male</label>
                    </div>
                    <div>
                        <input type="radio" id="female" name="str_gender" value="Female"
                            <cfif str_gender EQ "Female">checked="checked"</cfif>> 
                        <label for="female">Female</label>
                    </div>
                    <div>
                        <input type="radio" id="other" name="str_gender" value="Other"
                            <cfif str_gender EQ "Other">checked="checked"</cfif>> 
                        <label for="other">Other</label>
                    </div>
                </div>
            </div>
            <div class="mb-3 row">
                <label for="str_languages" class="col-sm-2 col-form-label">Languages</label>
                <div class="col-sm-10">
                    <div>
                        <input type="checkbox" id="malayalam" name="str_languages" value="Malayalam" 
                            <cfif listFind(str_languages, "Malayalam")>checked="checked"</cfif>>
                        <label for="malayalam">Malayalam</label>
                    </div>
                    <div>
                        <input type="checkbox" id="english" name="str_languages" value="English"
                            <cfif listFind(str_languages, "English")>checked="checked"</cfif>>
                        <label for="english">English</label>
                    </div>
                    <div>
                        <input type="checkbox" id="hindi" name="str_languages" value="Hindi"
                            <cfif listFind(str_languages, "Hindi")>checked="checked"</cfif>>
                        <label for="hindi">Hindi</label>
                    </div>
                </div>
            </div>
            <div class="mb-3 row">
        <div class="col-sm-10 offset-sm-2 d-flex justify-content-end">
            <button type="reset" class="btn btn-secondary me-2">Reset</button>
            <button type="submit" id="btnSubmit" name="btn-submit" class="btn btn-success"
                <cfif len(strSuccessMsg)>
                    disabled="disabled"
                </cfif>>
                Submit
            </button>
        </div>
    </div>
        </form>
    </cfoutput>
        <footer class="mt-auto bg-dark text-white py-3">
            <div class="container">
               <div class="row">
                  <div class="col-12 mb-3">
                     <ul class="list-unstyled d-flex flex-column flex-md-row justify-content-center mb-0">
                        <li class="me-md-3 mb-2 mb-md-0"><a href="" class="text-white text-decoration-none">Family &nbsp | &nbsp</a></li>
                        <li class="me-md-3 mb-2 mb-md-0"><a href="" class="text-white text-decoration-none">Friends &nbsp | &nbsp</a></li>
                        <li><a href="" class="text-white text-decoration-none">Colleagues</a></li>
                     </ul>
                  </div>
                  <div class="col-12 mb-3 d-flex justify-content-center">
                     <div class="col-10 col-md-6 col-lg-4">
                        <input type="search" class="form-control" placeholder="Search">
                     </div>
                  </div>
                  
               </div>
               
            </div>
            <div class="col-12 text-right  text-md-end">
                <p class="navbar-brand mr-2" href="index.html"><b>Address Book</b></p>
             </div>
         </footer>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
