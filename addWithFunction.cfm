<cfif not structKeyExists(session, "int_user_id") or session.int_user_id EQ "" or session.int_user_id IS 0>
    <cflocation url="login.cfm">
</cfif>

<cfset datasourceName = "dsn_Address_book">

<!--- Initialize individual variables --->
<cfset int_contact_id = "">      
<cfset str_first_name = "">    
<cfset str_last_name = "">       
<cfset int_contact = "">       
<cfset str_email = "">
<cfset str_qualification = ""> 
<cfset str_country = "">     
<cfset str_city = "">         
<cfset str_state = "">      
<cfset str_address = "">        
<cfset int_pincode = "">       
<cfset str_gender = "">         
<cfset str_languages = "">      

<cfset strErrorMsg = ''>       
<cfset strSuccessMsg = ''>     



<!--- Fetch strQualifications and countries --->
<cfset getstrQualifications()>
<cfset getCountries()>

<cfif structKeyExists(form, "btn-submit")>
    <!--- Collect form variables --->
    <cfset str_first_name = trim(form.str_first_name)>
    <cfset str_last_name = trim(form.str_last_name)>
    <cfset int_contact = trim(form.int_contact)>
    <cfset str_email = trim(form.str_email)>
    <cfset str_qualification = structKeyExists(form, "str_qualification") ? form.str_qualification : "">
    <cfset str_country = structKeyExists(form, "str_country") ? form.str_country : "">
    <cfset str_city = trim(form.str_city)>
    <cfset str_state = trim(form.str_state)>
    <cfset str_address = trim(form.str_address)>
    <cfset int_pincode = trim(form.int_pincode)>
    <cfset str_gender = structKeyExists(form, "str_gender") ? form.str_gender : "">
    <cfset str_languages = structKeyExists(form,"str_languages")? form.str_languages:"">
    
    

    <!--- Validate the form --->
    <cfset strErrorMsg = validateForm()>
    
    <cfif NOT len(strErrorMsg)>
        <cfset saveintContact()>
        <cfset strSuccessMsg = "Contact added successfully!">
    <cfelse>
        <cfset strSuccessMsg = strErrorMsg>
    </cfif>
</cfif>

<cffunction name="getstrQualifications" access="public" returnType="void">
    <cfquery name="qrygetstrQualifications" datasource="#datasourceName#">
        SELECT str_qualification_name FROM qualifications
    </cfquery>
</cffunction>

<cffunction name="getCountries" access="public" returnType="void">
    <cfquery name="qrygetCountries" datasource="#datasourceName#">
        SELECT str_country_name FROM countries
    </cfquery>
</cffunction>

<cffunction name="validateForm" access="public" returnType="string">
    <cfset var strErrorMsg = "">
    
    <cfif str_first_name EQ "">
        <cfset strErrorMsg &= 'Please enter your first name.<br>'>
    </cfif>
    <cfif str_last_name EQ "">
        <cfset strErrorMsg &= 'Please enter your last name.<br>'>
    </cfif>
    <cfif int_contact EQ "">
        <cfset strErrorMsg &= 'Please enter your Contact number.<br>'>
    </cfif>
    <cfif str_email EQ "">
        <cfset strErrorMsg &= 'Please enter your Email .<br>'>
    </cfif>
    <cfif (str_qualification EQ "")>
        <cfset strErrorMsg &= 'Please select a Qualification.<br>'>
    </cfif>
    <cfif (str_country EQ "")>
        <cfset strErrorMsg &= 'Please select a Country.<br>'>
    </cfif>
    <cfif str_city EQ "">
        <cfset strErrorMsg &= 'Please enter your City.<br>'>
    </cfif>
    <cfif str_state EQ "">
        <cfset strErrorMsg &= 'Please enter your State.<br>'>
    </cfif>
    <cfif str_address EQ "">
        <cfset strErrorMsg &= 'Please enter your Address.<br>'>
    </cfif>
    <cfif int_pincode EQ "">
        <cfset strErrorMsg &= 'Please enter your Pincode.<br>'>
    </cfif>
    <cfif (str_gender EQ "")>
        <cfset strErrorMsg &= 'Please select a Gender.<br>'>
    </cfif>
    <cfif (str_languages EQ "")>
        <cfset strErrorMsg &= 'Please select at least one language.<br>'>
    </cfif>
    
    <cfreturn strErrorMsg>
</cffunction>

<cffunction name="saveintContact" access="public" returnType="string">
    <!--- Local variable for the response --->
    <cfset var responseMessage = "">
    
    <!--- Check for duplicate contact number --->
    <cfquery name="checkDuplicate" datasource="#datasourceName#">
        SELECT int_contact 
        FROM contacts
        WHERE int_contact = <cfqueryparam value="#int_contact#" cfsqltype="cf_sql_varchar">
    </cfquery>
    
    <cfif checkDuplicate.recordcount EQ 0>
     
        <!--- Proceed with insert if no duplicate --->
        <cfquery datasource="#datasourceName#">
            INSERT INTO contacts (
                str_first_name, str_last_name, int_contact, str_email, 
                str_qualification, str_country, str_city, str_state, 
                str_address, int_pincode, str_gender, str_languages
            ) VALUES (
                <cfqueryparam value="#str_first_name#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#str_last_name#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#int_contact#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#str_email#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#str_qualification#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#str_country#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#str_city#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#str_state#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#str_address#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#int_pincode#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#str_gender#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#str_languages#" cfsqltype="cf_sql_varchar">
            )
        </cfquery>
    </cfif>

</cffunction>


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
                        <cfquery name="qrygetQualifications" datasource="#datasourcename#">
                            SELECT str_qualification_name
                            FROM qualifications
                            ORDER BY str_qualification_name
                        </cfquery>
                        <cfloop query="qrygetQualifications">
                            <option value="#qrygetQualifications.str_qualification_name#"
                                <cfif structKeyExists(form, "str_qualification") AND form.str_qualification EQ qrygetQualifications.str_qualification_name>
                                    selected="selected"
                                </cfif>>
                                #qrygetQualifications.str_qualification_name#
                            </option>
                        </cfloop>
                    </select>
                </div>
            </div>
            
            

<!-- Country Dropdown -->
<div class="mb-3 row">
    <label for="str_country" class="col-sm-2 col-form-label">Country</label>
    <div class="col-sm-10">
        <select id="str_country" name="str_country" class="form-select">
            <option value="">Select Country</option>
            <!-- Loop through countries from the database -->
            <cfquery name="qrygetCountries" datasource="#datasourcename#">
                SELECT str_country_name
                FROM countries
                ORDER BY str_country_name
            </cfquery>
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
