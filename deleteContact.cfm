<cfif not structKeyExists(session, "int_user_id") or session.int_user_id EQ "" or session.int_user_id IS 0>
    <cflocation url="login.cfm">
</cfif>
<cfif not listFind(session.permissionList, 3)>
    <!-- User has permission to delete -->
    <cflocation url="contact.cfm">
    <!-- User does not have permission -->
    
</cfif>
<cfset datasource = "dsn_address_book">

<cfif structKeyExists(url, "int_contact_id")>
   
    <cfquery datasource="#datasource#">
        DELETE FROM contacts
        WHERE int_contact_id = <cfqueryparam value="#url.contactId#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfset message = "Contact deleted successfully!">
</cfif>

<!-- Fetch the updated list of contacts -->
<cfquery name="getContacts" datasource="#datasource#">
    SELECT int_contact_id, str_first_name, str_last_name, str_email, int_contact
    FROM contacts
    ORDER BY str_first_name ASC
</cfquery>
<cflocation url="contact.cfm">
