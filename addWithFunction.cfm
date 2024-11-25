<cfif not structKeyExists(session, "userId") or session.userId EQ "" or session.userId IS 0>
    <cflocation url="login.cfm">
</cfif>

<cfset datasourceName = "dsn_Address_book">

<!--- Initialize individual variables --->
<cfset intContactId = "">      
<cfset strFirstName = "">    
<cfset strLastName = "">       
<cfset intContact = "">       
<cfset strEmail = "">
<cfset strQualification = ""> 
<cfset strCountry = "">     
<cfset strCity = "">         
<cfset strState = "">      
<cfset strAddress = "">        
<cfset intPincode = "">       
<cfset strGender = "">         
<cfset strLanguages = "">      
<cfset strErrorMsg = ''>       
<cfset strSuccessMsg = ''>     



<!--- Fetch strQualifications and countries --->
<cfset getstrQualifications()>
<cfset getCountries()>

<cfif structKeyExists(form, "btn-submit")>
    <!--- Collect form variables --->
    <cfset strFirstName = trim(form.strFirstName)>
    <cfset strLastName = trim(form.strLastName)>
    <cfset intContact = trim(form.intContact)>
    <cfset strEmail = trim(form.strEmail)>
    <cfset strQualification = structKeyExists(form, "strQualification") ? form.strQualification : "">
    <cfset strCountry = structKeyExists(form, "strCountry") ? form.strCountry : "">
    <cfset strCity = trim(form.strCity)>
    <cfset strState = trim(form.strState)>
    <cfset strAddress = trim(form.strAddress)>
    <cfset intPincode = trim(form.intPincode)>
    <cfset strGender = structKeyExists(form, "strGender") ? form.strGender : "">
    <cfset strLanguages = structKeyExists(form,"strLanguages")? form.strLanguages:"">
    
    

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
        SELECT strQualificationName FROM qualifications
    </cfquery>
</cffunction>

<cffunction name="getCountries" access="public" returnType="void">
    <cfquery name="qrygetCountries" datasource="#datasourceName#">
        SELECT strCountryName FROM countries
    </cfquery>
</cffunction>

<cffunction name="validateForm" access="public" returnType="string">
    <cfset var strErrorMsg = "">
    
    <cfif strFirstName EQ "">
        <cfset strErrorMsg &= 'Please enter your first name.<br>'>
    </cfif>
    <cfif strLastName EQ "">
        <cfset strErrorMsg &= 'Please enter your last name.<br>'>
    </cfif>
    <cfif intContact EQ "">
        <cfset strErrorMsg &= 'Please enter your Contact number.<br>'>
    </cfif>
    <cfif strEmail EQ "">
        <cfset strErrorMsg &= 'Please enter your Email .<br>'>
    </cfif>
    <cfif (strQualification EQ "")>
        <cfset strErrorMsg &= 'Please select a Qualification.<br>'>
    </cfif>
    <cfif (strCountry EQ "")>
        <cfset strErrorMsg &= 'Please select a Country.<br>'>
    </cfif>
    <cfif strCity EQ "">
        <cfset strErrorMsg &= 'Please enter your City.<br>'>
    </cfif>
    <cfif strState EQ "">
        <cfset strErrorMsg &= 'Please enter your State.<br>'>
    </cfif>
    <cfif strAddress EQ "">
        <cfset strErrorMsg &= 'Please enter your Address.<br>'>
    </cfif>
    <cfif intPincode EQ "">
        <cfset strErrorMsg &= 'Please enter your Pincode.<br>'>
    </cfif>
    <cfif (strGender EQ "")>
        <cfset strErrorMsg &= 'Please select a Gender.<br>'>
    </cfif>
    <cfif (strLanguages EQ "")>
        <cfset strErrorMsg &= 'Please select at least one language.<br>'>
    </cfif>
    
    <cfreturn strErrorMsg>
</cffunction>

<cffunction name="saveintContact" access="public" returnType="void">
    <cfquery datasource="#datasourceName#">
        INSERT INTO contacts (
            strFirstName, strLastName, intContact, strEmail, 
            strQualification, strCountry, strCity, strState, 
            strAddress, intPincode, strGender, strLanguages
        ) VALUES (
            <cfqueryparam value="#strFirstName#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#strLastName#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#intContact#" cfsqltype="cf_sql_varchar">, <!--- Changed from strContact to intContact --->
            <cfqueryparam value="#strEmail#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#strQualification#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#strCountry#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#strCity#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#strState#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#strAddress#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#intPincode#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#strGender#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#strLanguages#" cfsqltype="cf_sql_varchar">
        );
    </cfquery>
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
                    <a class="nav-link text-white d-flex align-items-center" href="logout.cfm">
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
                    <input type="text" id="fname" name="strFirstName" class="form-control" placeholder="Your name.." value="#strFirstName#">
                </div>
            </div>
            <div class="mb-3 row">
                <label for="lname" class="col-sm-2 col-form-label">Last Name</label>
                <div class="col-sm-10">
                    <input type="text" id="lname" name="strLastName" class="form-control" placeholder="Your last name.." value="#strLastName#">
                </div>
            </div>
            <div class="mb-3 row">
                <label for="intContact" class="col-sm-2 col-form-label">Contact no</label>
                <div class="col-sm-10">
                    <input type="text" id="intContact" name="intContact" class="form-control" placeholder="Contact number.." value="#intContact#">
                </div>
            </div>
            <div class="mb-3 row">
                <label for="strEmail" class="col-sm-2 col-form-label">Email</label>
                <div class="col-sm-10">
                    <input type="text" id="strEmail" name="strEmail" class="form-control" placeholder="Your Email.." value="#strEmail#">
                </div>
            </div>
            <!-- Qualification Dropdown -->
            <div class="mb-3 row">
                <label for="strQualification" class="col-sm-2 col-form-label">Qualification</label>
                <div class="col-sm-10">
                    <select id="strQualification" name="strQualification" class="form-select">
                        <option value="">Select Qualification</option>
                        <!-- Loop through qualifications from the database -->
                        <cfquery name="qrygetQualifications" datasource="dsn_address_book">
                            SELECT strQualificationName
                            FROM qualifications
                            ORDER BY strQualificationName
                        </cfquery>
                        <cfloop query="qrygetQualifications">
                            <option value="#qrygetQualifications.strQualificationName#"
                                <cfif structKeyExists(form, "strQualification") AND form.strQualification EQ qrygetQualifications.strQualificationName>
                                    selected="selected"
                                </cfif>>
                                #qrygetQualifications.strQualificationName#
                            </option>
                        </cfloop>
                    </select>
                </div>
            </div>
            
            

<!-- Country Dropdown -->
<div class="mb-3 row">
    <label for="strCountry" class="col-sm-2 col-form-label">Country</label>
    <div class="col-sm-10">
        <select id="strCountry" name="strCountry" class="form-select">
            <option value="">Select Country</option>
            <!-- Loop through countries from the database -->
            <cfquery name="qrygetCountries" datasource="dsn_address_book">
                SELECT strCountryName
                FROM countries
                ORDER BY strCountryName
            </cfquery>
            <cfloop query="qrygetCountries">
                <option value="#qrygetCountries.strCountryName#"
                    <cfif structKeyExists(form, "strCountry") AND form.strCountry EQ qrygetCountries.strCountryName>
                        selected="selected"
                    </cfif>>
                    #qrygetCountries.strCountryName#
                </option>
            </cfloop>
        </select>
    </div>
</div>


            <div class="mb-3 row">
                <label for="strCity" class="col-sm-2 col-form-label">City</label>
                <div class="col-sm-10">
                    <input type="text" id="strCity" name="strCity" class="form-control" placeholder="Your City.." value="#strCity#">
                </div>
            </div>
            <div class="mb-3 row">
                <label for="strState" class="col-sm-2 col-form-label">State</label>
                <div class="col-sm-10">
                    <input type="text" id="strState" name="strState" class="form-control" placeholder="Your State.." value="#strState#">
                </div>
            </div>
            <div class="mb-3 row">
                <label for="strAddress" class="col-sm-2 col-form-label">Address</label>
                <div class="col-sm-10">
                    <input type="text" id="strAddress" name="strAddress" class="form-control" placeholder="Your Address.." value="#strAddress#">
                </div>
            </div>
            <div class="mb-3 row">
                <label for="intPincode" class="col-sm-2 col-form-label">Pincode</label>
                <div class="col-sm-10">
                    <input type="text" id="intPincode" name="intPincode" class="form-control" placeholder="Your Pincode.." value="#intPincode#">
                </div>
            </div>
            <div class="mb-3 row">
                <label for="strGender" class="col-sm-2 col-form-label">Gender</label>
                <div class="col-sm-10">
                    <div>
                        <input type="radio" id="male" name="strGender" value="Male"
                            <cfif strGender EQ "Male">checked="checked"</cfif>> 
                        <label for="male">Male</label>
                    </div>
                    <div>
                        <input type="radio" id="female" name="strGender" value="Female"
                            <cfif strGender EQ "Female">checked="checked"</cfif>> 
                        <label for="female">Female</label>
                    </div>
                    <div>
                        <input type="radio" id="other" name="strGender" value="Other"
                            <cfif strGender EQ "Other">checked="checked"</cfif>> 
                        <label for="other">Other</label>
                    </div>
                </div>
            </div>
            <div class="mb-3 row">
                <label for="strLanguages" class="col-sm-2 col-form-label">Languages</label>
                <div class="col-sm-10">
                    <div>
                        <input type="checkbox" id="malayalam" name="strLanguages" value="Malayalam" 
                            <cfif listFind(strLanguages, "Malayalam")>checked="checked"</cfif>>
                        <label for="malayalam">Malayalam</label>
                    </div>
                    <div>
                        <input type="checkbox" id="english" name="strLanguages" value="English"
                            <cfif listFind(strLanguages, "English")>checked="checked"</cfif>>
                        <label for="english">English</label>
                    </div>
                    <div>
                        <input type="checkbox" id="hindi" name="strLanguages" value="Hindi"
                            <cfif listFind(strLanguages, "Hindi")>checked="checked"</cfif>>
                        <label for="hindi">Hindi</label>
                    </div>
                </div>
            </div>
            
            
            <div class="mb-3 row">
                <div class="d-flex justify-content-end">
                    <button type="reset" class="btn btn-secondary me-2">Reset</button>
                    <button type="submit" name="btn-submit" class="btn btn-success">Submit</button>
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
