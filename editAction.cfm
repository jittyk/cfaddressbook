<cfset datasource="dsn_address_book">

<!-- Function to check if the user is logged in -->
<cffunction name="checkUserLogin" access="public" returntype="void">
    <cfif not structKeyExists(session, "int_user_id") or session.int_user_id EQ "" or session.int_user_id IS 0>
        <cflocation url="login.cfm">
    </cfif>
</cffunction>

<!-- Function to check if the user has permission to delete -->
<cffunction name="checkUserPermission" access="public" returntype="void">
    <cfif not listFind(session.permissionList, 2)>
        <cflocation url="contact.cfm">
    </cfif>
</cffunction>

<!-- Function to fetch contact details based on contact ID -->
<cffunction name="fetchContactDetails" access="public" returntype="void">
    <cfif structKeyExists(url, "int_contact_id")>
        <cfquery name="contact" datasource="#datasource#">
            SELECT c.int_contact_id, c.str_first_name, c.str_last_name, c.str_contact, c.str_email, 
                   c.int_qualification, 
                   q.int_qualification_id, q.str_qualification_name, co.int_country_id, co.str_country_name, 
                   c.str_city, c.str_state, c.str_address, c.str_pincode, c.str_gender, c.str_languages,
                   c.int_country
            FROM contacts c
            LEFT JOIN qualifications q ON c.int_qualification = q.int_qualification_id
            LEFT JOIN countries co ON c.int_country = co.int_country_id
            WHERE c.int_contact_id = #url.int_contact_id#
        </cfquery>
        
        <!-- Query to retrieve all countries -->
        <cfquery name="qryGetCountries" datasource="#datasource#">
            SELECT int_country_id, str_country_name 
            FROM countries
        </cfquery>
        
        <!-- Query to retrieve all qualifications -->
        <cfquery name="qryGetQualifications" datasource="#datasource#">
            SELECT int_qualification_id, str_qualification_name 
            FROM qualifications
        </cfquery>
        
        <!-- Check if the query returned any results -->
        <cfif contact.recordCount EQ 0>
            <cfset throw("No contact found with the provided ID.")>
        </cfif>
    </cfif>
</cffunction>

<!-- Function to handle form submission and update contact details -->
<cffunction name="updateContact" access="public" returntype="string">
    <cfargument name="form" type="struct" required="true">
    <cfargument name="url" type="struct" required="true">
    <cfset var responseMessage = "">

    <cfif structKeyExists(arguments.form, "submit") AND structKeyExists(arguments.url, "int_contact_id")>
        <cftry>
            <cfquery datasource="#variables.datasource#">
                UPDATE contacts
                SET 
                    str_first_name = <cfqueryparam value="#arguments.form.str_first_name#" cfsqltype="cf_sql_varchar" maxlength="50">,
                    str_last_name = <cfqueryparam value="#arguments.form.str_last_name#" cfsqltype="cf_sql_varchar" maxlength="50">,
                    str_contact = <cfqueryparam value="#arguments.form.str_contact#" cfsqltype="cf_sql_varchar" maxlength="15">,
                    str_email = <cfqueryparam value="#arguments.form.str_email#" cfsqltype="cf_sql_varchar" maxlength="100">,
                    int_qualification = <cfqueryparam value="#arguments.form.int_qualification#" cfsqltype="cf_sql_integer">,
                    int_country = <cfqueryparam value="#arguments.form.int_country#" cfsqltype="cf_sql_integer">,
                    str_city = <cfqueryparam value="#arguments.form.str_city#" cfsqltype="cf_sql_varchar" maxlength="100">,
                    str_state = <cfqueryparam value="#arguments.form.str_state#" cfsqltype="cf_sql_varchar" maxlength="100">,
                    str_address = <cfqueryparam value="#arguments.form.str_address#" cfsqltype="cf_sql_varchar" maxlength="255">,
                    str_pincode = <cfqueryparam value="#arguments.form.str_pincode#" cfsqltype="cf_sql_varchar" maxlength="10">,
                    str_gender = <cfqueryparam value="#arguments.form.str_gender#" cfsqltype="cf_sql_varchar" maxlength="10">,
                    str_languages = <cfqueryparam value="#arguments.form.str_languages#" cfsqltype="cf_sql_varchar" maxlength="255">
                WHERE int_contact_id = <cfqueryparam value="#arguments.url.int_contact_id#" cfsqltype="cf_sql_integer">
            </cfquery>
            <cfset responseMessage = "Contact updated successfully!">
            <cfcatch type="any">
                <cfset responseMessage = "Error updating contact: #cfcatch.message#">
            </cfcatch>
        </cftry>
    <cfelse>
        <cfset responseMessage = "Invalid request. Contact ID is missing.">
    </cfif>

    <cfreturn responseMessage>
</cffunction>


<!-- Main execution: Call functions -->
<cfset checkUserLogin()>
<cfset checkUserPermission()>
<cfset fetchContactDetails()>
<cfset updateContact()>
