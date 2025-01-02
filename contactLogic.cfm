<cfif not structKeyExists(session, "int_user_id") or session.int_user_id EQ "" or session.int_user_id IS 0>
    <cflocation url="login.cfm">
</cfif>

<cfset datasource = "dsn_address_book">

<!-- Function to Fetch Total Contact Count -->
<cffunction name="getTotalContactCount" access="private" returntype="numeric">
    <cfquery name="totalCount" datasource="#datasource#">
        SELECT COUNT(*) AS totalContacts
        FROM contacts
    </cfquery>
    <cfreturn totalCount.totalContacts>
</cffunction>

<!-- Function to Fetch Paginated Contacts -->
<cffunction name="getPaginatedContacts" access="private" returntype="query">
    <cfargument name="datasource" required="true" type="string">
    <cfargument name="startRow" required="true" type="numeric">
    <cfargument name="perPage" required="true" type="numeric">
    <cfquery name="getContacts" datasource="#arguments.datasource#">
        SELECT int_contact_id, str_first_name, str_last_name, int_contact, str_email, 
               str_qualification, str_country, str_city, str_state, str_address, 
               int_pincode, str_gender, str_languages
        FROM contacts
        ORDER BY str_first_name ASC
        LIMIT #arguments.startRow - 1#, #arguments.perPage#
    </cfquery>
    <cfreturn getContacts>
</cffunction>

<!-- Function to Check User Permissions -->
<cffunction name="getUserPermissions" access="private" returntype="string">
    <cfargument name="datasource" required="true" type="string">
    <cfargument name="userId" required="true" type="numeric">
    <cfquery name="checkPermission" datasource="#arguments.datasource#">
        SELECT int_permission_id
        FROM tbl_user_permissions
        WHERE int_user_id = <cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif checkPermission.recordCount NEQ 0>
        <cfreturn ValueList(checkPermission.int_permission_id)>
    <cfelse>
        <cfreturn "">
    </cfif>
</cffunction>

<!-- Parameters for Pagination -->
<cfparam name="page" default="1">
<cfset perPage = 5>
<cfset startRow = (page - 1) * perPage + 1>

<!-- Fetch Total Contacts -->
<cfset totalContacts = getTotalContactCount(datasource)>

<!-- Fetch Paginated Contacts -->
<cfset paginatedContacts = getPaginatedContacts(datasource, startRow, perPage)>

<!-- Calculate Total Pages -->
<cfset totalPages = ceiling(totalContacts / perPage)>

<!-- Check and Set User Permissions -->
<cfset session.permissionList = getUserPermissions(datasource, session.int_user_id)>

