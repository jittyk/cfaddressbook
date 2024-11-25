<cfif not structKeyExists(session, "userId") or session.userId EQ "" or session.userId IS 0>
    <cflocation url="login.cfm">
</cfif>
<cfquery name="checkPermission" datasource="dsn_address_book">
    SELECT intPermissionId
    FROM tbl_user_permissions
    WHERE intUserId = <cfqueryparam value="#session.userId#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif checkPermission.recordCount NEQ 0>
    <!-- Convert the query column to a comma-separated list -->
    <cfset permissionList = ValueList(checkPermission.intPermissionId)>

    <!-- Check if the user does not have permission (list does not contain the value 3) -->
    <cfif NOT listFind(permissionList, 3)>
        
        <cflocation url="contact.cfm">
        
    </cfif>
</cfif>


<cfif structKeyExists(url, "contactId")>
   
    <cfquery datasource="dsn_address_book">
        DELETE FROM contacts
        WHERE intContactId = <cfqueryparam value="#url.contactId#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfset message = "Contact deleted successfully!">
</cfif>

<!-- Fetch the updated list of contacts -->
<cfquery name="getContacts" datasource="dsn_address_book">
    SELECT intContactId, strFirstName, strLastName, strEmail, intContact
    FROM contacts
    ORDER BY strFirstName ASC
</cfquery>
<cflocation url="contact.cfm">
