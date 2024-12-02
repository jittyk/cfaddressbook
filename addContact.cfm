

<cffunction name="setDefaultValues" access="public" returntype="void">
    <cfset variables.int_contact_id = "">
    <cfset variables.str_first_name = "">
    <cfset variables.str_last_name = "">
    <cfset variables.int_contact = "">
    <cfset variables.str_email = "">
    <cfset variables.str_qualification = "">
    <cfset variables.str_country = "">
    <cfset variables.str_city = "">
    <cfset variables.str_state = "">
    <cfset variables.str_address = "">
    <cfset variables.int_pincode = "">
    <cfset variables.str_gender = "">
    <cfset variables.str_languages = "">
    <cfset variables.strErrorMsg = ''>
    <cfset variables.strSuccessMsg = ''>
    <cfset variables.datasource = "dsn_address_book">
 


    <!--- Fetch qualifications --->
    <cfquery name="qrygetstrQualifications" datasource="#datasource#">
        SELECT str_qualification_name FROM qualifications
    </cfquery>
    <cfset variables.qualifications = qrygetstrQualifications>

    <!--- Fetch countries --->
    <cfquery name="qrygetCountries" datasource="#datasource#">
        SELECT str_country_name FROM countries
    </cfquery>
    <cfset variables.countries = qrygetCountries>
</cffunction>

<cffunction name="getFormValues" access="public" returntype="void">
    <cfif structKeyExists(form, "btn-submit")>
        <cfset variables.str_first_name = trim(form.str_first_name)>
        <cfset variables.str_last_name = trim(form.str_last_name)>
        <cfset variables.int_contact = trim(form.int_contact)>
        <cfset variables.str_email = trim(form.str_email)>
        <cfset variables.str_qualification = structKeyExists(form, "str_qualification") ? form.str_qualification : "">
        <cfset variables.str_country = structKeyExists(form, "str_country") ? form.str_country : "">
        <cfset variables.str_city = trim(form.str_city)>
        <cfset variables.str_state = trim(form.str_state)>
        <cfset variables.str_address = trim(form.str_address)>
        <cfset variables.int_pincode = trim(form.int_pincode)>
        <cfset variables.str_gender = structKeyExists(form, "str_gender") ? form.str_gender : "">
        <cfset variables.str_languages = structKeyExists(form, "str_languages") ? form.str_languages : "">
    </cfif>
</cffunction>

<cffunction name="formValidate" access="public" returntype="string">
    <cfset var strErrorMsg = "">
    
    <cfif variables.str_first_name EQ "">
        <cfset strErrorMsg &= 'Please enter your first name.<br>'>
    </cfif>
    <cfif variables.str_last_name EQ "">
        <cfset strErrorMsg &= 'Please enter your last name.<br>'>
    </cfif>
    <cfif variables.int_contact EQ "">
        <cfset strErrorMsg &= 'Please enter your contact number.<br>'>
    </cfif>
    <cfif variables.str_email EQ "">
        <cfset strErrorMsg &= 'Please enter your email.<br>'>
    </cfif>
    <cfif variables.str_qualification EQ "">
        <cfset strErrorMsg &= 'Please select a qualification.<br>'>
    </cfif>
    <cfif variables.str_country EQ "">
        <cfset strErrorMsg &= 'Please select a country.<br>'>
    </cfif>
    <cfif variables.str_city EQ "">
        <cfset strErrorMsg &= 'Please enter your city.<br>'>
    </cfif>
    <cfif variables.str_state EQ "">
        <cfset strErrorMsg &= 'Please enter your state.<br>'>
    </cfif>
    <cfif variables.str_address EQ "">
        <cfset strErrorMsg &= 'Please enter your address.<br>'>
    </cfif>
    <cfif variables.int_pincode EQ "">
        <cfset strErrorMsg &= 'Please enter your pincode.<br>'>
    </cfif>
    <cfif variables.str_gender EQ "">
        <cfset strErrorMsg &= 'Please select a gender.<br>'>
    </cfif>
    <cfif variables.str_languages EQ "">
        <cfset strErrorMsg &= 'Please select at least one language.<br>'>
    </cfif>
    
    <cfreturn strErrorMsg>
</cffunction>

<cffunction name="saveContact" access="public" returntype="string">
    <cfset var responseMessage = "">
    
    <!--- Check for duplicate contact number --->
    <cfquery name="checkDuplicate" datasource="#variables.datasource#">
        SELECT int_contact 
        FROM contacts
        WHERE int_contact = <cfqueryparam value="#variables.int_contact#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfif checkDuplicate.recordcount EQ 0>
        <!--- Proceed with insert if no duplicate --->
        <cfquery datasource="#variables.datasource#">
            INSERT INTO contacts (
                str_first_name, str_last_name, int_contact, str_email, 
                str_qualification, str_country, str_city, str_state, 
                str_address, int_pincode, str_gender, str_languages
            ) VALUES (
                <cfqueryparam value="#variables.str_first_name#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#variables.str_last_name#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#variables.int_contact#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#variables.str_email#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#variables.str_qualification#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#variables.str_country#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#variables.str_city#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#variables.str_state#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#variables.str_address#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#variables.int_pincode#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#variables.str_gender#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#variables.str_languages#" cfsqltype="cf_sql_varchar">
            )
        </cfquery>
        <cfset responseMessage = "Contact added successfully!">
    <cfelse>
        <cfset responseMessage = "Contact number already exists!">
    </cfif>
    
    <cfreturn responseMessage>
</cffunction>

<!--- Main processing logic --->
<cfif not structKeyExists(session, "int_user_id") or session.int_user_id EQ "" or session.int_user_id IS 0>
    <cflocation url="adminLogin.cfm">
</cfif>

<cfset setDefaultValues()>

<cfif structKeyExists(form, "btn-submit")>
    <cfset getFormValues()>
    <cfset variables.strErrorMsg = formValidate()>
    
    <cfif NOT len(variables.strErrorMsg)>
        <cfset variables.strSuccessMsg = saveContact()>
    </cfif>
</cfif>