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
            SELECT int_contact_id, str_first_name, str_last_name, int_contact, str_email, str_qualification, 
                   str_country, str_city, str_state, str_address, int_pincode, str_gender, str_languages
            FROM contacts 
            WHERE int_contact_id = #url.int_contact_id#
        </cfquery>
    </cfif>
</cffunction>

<!-- Function to handle form submission and update contact details -->
<cffunction name="updateContact" access="public" returntype="void">
    <cfif structKeyExists(form, "submit")>
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
</cffunction>

<!-- Main execution: Call functions -->
<cfset checkUserLogin()>
<cfset checkUserPermission()>
<cfset fetchContactDetails()>
<cfset updateContact()>
