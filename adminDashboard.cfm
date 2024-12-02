<cfif not structKeyExists(session, "int_admin_id") or session.int_admin_id EQ "" or session.int_admin_id IS 0>
    <cflocation url="adminLogin.cfm">
</cfif>

<cfset datasource="dsn_address_book">

<!--- Function Definitions --->
<!--- Function to update user status --->
<cffunction name="updateUserStatus" access="public" returnType="void">
    <cfargument name="int_user_id" type="numeric" required="true">
    <cfargument name="status" type="string" required="true">
    
    <cfquery datasource="#datasource#">
        UPDATE tbl_users
        SET cbr_status = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
        WHERE int_user_id = <cfqueryparam value="#arguments.int_user_id#" cfsqltype="cf_sql_integer">
    </cfquery>
</cffunction>

<!--- Function to get current permissions for a user --->
<cffunction name="getCurrentPermissions" access="public" returnType="query">
    <cfargument name="int_user_id" type="numeric" required="true">
    
    <cfquery name="qryCurrentPermissions" datasource="#datasource#">
        SELECT int_permission_id
        FROM tbl_user_permissions
        WHERE int_user_id = <cfqueryparam value="#arguments.int_user_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    
    <cfreturn qryCurrentPermissions>
</cffunction>

<!--- Function to delete permission --->
<cffunction name="deletePermission" access="public" returnType="void">
    <cfargument name="int_user_id" type="numeric" required="true">
    <cfargument name="int_permission_id" type="numeric" required="true">
    
    <cfquery datasource="#datasource#">
        DELETE FROM tbl_user_permissions
        WHERE int_user_id = <cfqueryparam value="#arguments.int_user_id#" cfsqltype="cf_sql_integer">
        AND int_permission_id = <cfqueryparam value="#arguments.int_permission_id#" cfsqltype="cf_sql_integer">
    </cfquery>
</cffunction>

<!--- Function to check if permission exists --->
<cffunction name="checkPermissionExistence" access="public" returnType="numeric">
    <cfargument name="int_user_id" type="numeric" required="true">
    <cfargument name="int_permission_id" type="numeric" required="true">
    
    <cfquery name="qryCheckExistence" datasource="#datasource#">
        SELECT COUNT(int_user_id) AS Count
        FROM tbl_user_permissions
        WHERE int_user_id = <cfqueryparam value="#arguments.int_user_id#" cfsqltype="cf_sql_integer">
        AND int_permission_id = <cfqueryparam value="#arguments.int_permission_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    
    <cfreturn qryCheckExistence.Count>
</cffunction>

<!--- Function to add new permission --->
<cffunction name="addPermission" access="public" returnType="void">
    <cfargument name="int_user_id" type="numeric" required="true">
    <cfargument name="int_permission_id" type="numeric" required="true">
    
    <cfquery datasource="#datasource#">
        INSERT INTO tbl_user_permissions (int_user_id, int_permission_id)
        VALUES (
            <cfqueryparam value="#arguments.int_user_id#" cfsqltype="cf_sql_integer">,
            <cfqueryparam value="#arguments.int_permission_id#" cfsqltype="cf_sql_integer">
        )
    </cfquery>
</cffunction>

<!--- Handle all form submissions first --->
<cfif structKeyExists(form, "action")>
    <cfswitch expression="#form.action#">
        <!--- Handle Status Updates --->
        <cfcase value="updateStatus">
            <cfif structKeyExists(form, "int_user_id") AND structKeyExists(form, "status")>
                <cfif form.status EQ "A" OR form.status EQ "I">
                    <cfset updateUserStatus(form.int_user_id, form.status)>
                    <cflocation url="admin.cfm">
                </cfif>
            </cfif>
        </cfcase>

        <!--- Handle Permission Updates --->
        <cfcase value="updatePermissions">
            <cfif structKeyExists(form, "permissions") AND structKeyExists(form, "int_user_id")>
                <cfset int_user_id = form.int_user_id>
                <cfset updatedPermissionsList = isArray(form.permissions) ? arrayToList(form.permissions, ",") : form.permissions>
                
                <!--- Get current permissions --->
                <cfset qryCurrentPermissions = getCurrentPermissions(int_user_id)>

                <!--- Remove old permissions --->
                <cfloop query="qryCurrentPermissions">
                    <cfif NOT listFind(updatedPermissionsList, qryCurrentPermissions.int_permission_id)>
                        <cfset deletePermission(int_user_id, qryCurrentPermissions.int_permission_id)>
                    </cfif>
                </cfloop>

                <!--- Add new permissions --->
                <cfloop list="#updatedPermissionsList#" index="int_permission_id">
                    <cfif checkPermissionExistence(int_user_id, int_permission_id) EQ 0>
                        <cfset addPermission(int_user_id, int_permission_id)>
                    </cfif>
                </cfloop>
                <cflocation url="admin.cfm">
            </cfif>
        </cfcase>
    </cfswitch>
</cfif>

<!--- Set up pagination and fetch users --->
<cfset recordsPerPage = 5>
<cfset currentPage = structKeyExists(url, "page") ? url.page : 1>
<cfset startRecord = (currentPage - 1) * recordsPerPage>

<!-- Count total records -->
<cfquery name="qryCount" datasource="#datasource#">
    SELECT COUNT(int_user_id) AS totalUsers
    FROM tbl_users
    WHERE int_user_role_id != 1
    <cfif structKeyExists(form, "searchKey") AND len(trim(form.searchKey)) GT 0>
        AND (
            str_email LIKE <cfqueryparam value="%#form.searchKey#%" cfsqltype="cf_sql_varchar"> OR
            str_user_name LIKE <cfqueryparam value="%#form.searchKey#%" cfsqltype="cf_sql_varchar"> OR
            str_phone LIKE <cfqueryparam value="%#form.searchKey#%" cfsqltype="cf_sql_varchar"> OR
            str_first_name LIKE <cfqueryparam value="%#form.searchKey#%" cfsqltype="cf_sql_varchar">
        )
    </cfif>
</cfquery>

<!-- Fetch the users for the current page -->
<cfquery name="qryUsers" datasource="#datasource#">
    SELECT int_user_id, str_email, str_user_name, str_phone, str_first_name, cbr_status
    FROM tbl_users
    WHERE int_user_role_id != 1
    <cfif structKeyExists(form, "searchKey") AND len(trim(form.searchKey)) GT 0>
        AND (
            str_email LIKE <cfqueryparam value="%#trim(form.searchKey)#%" cfsqltype="cf_sql_varchar"> OR
            str_user_name LIKE <cfqueryparam value="%#trim(form.searchKey)#%" cfsqltype="cf_sql_varchar"> OR
            str_phone LIKE <cfqueryparam value="%#trim(form.searchKey)#%" cfsqltype="cf_sql_varchar"> OR
            str_first_name LIKE <cfqueryparam value="%#trim(form.searchKey)#%" cfsqltype="cf_sql_varchar">
        )
    </cfif>
    ORDER BY int_user_id
    LIMIT <cfqueryparam value="#recordsPerPage#" cfsqltype="cf_sql_integer">
    OFFSET <cfqueryparam value="#startRecord#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif structKeyExists(form, "permissions") AND structKeyExists(form, "int_user_id")>
    <cfset int_user_id = form.int_user_id>

    <!--- Fetch current permissions for the user --->
    <cfset qryUserPermissions = getCurrentPermissions(int_user_id)>
    
    <!-- Ensure permissions are in the correct format -->
    <cfif isArray(form.permissions)>
        <cfset updatedPermissionsList = arrayToList(form.permissions, ",")>
    <cfelse>
        <cfset updatedPermissionsList = form.permissions>
    </cfif>

    <!--- Handle permissions using the new function --->
    <cfset handlePermissions(int_user_id, updatedPermissionsList)>
</cfif>

<cfif isDefined("form.action") AND form.action EQ "updateStatus">
    <!-- Check if required fields are present -->
    <cfif isDefined("form.int_user_id") AND isDefined("form.status")>
        <!-- Validate the status value -->
        <cfif form.status EQ "A" OR form.status EQ "I">
            <!-- Update the user's status in the database -->
            <cfset updateUserStatus(form.int_user_id, form.status)>
            <cfoutput>
                <p style="color: green;">User status successfully updated to 
                    <cfif form.status EQ "A">Approved<cfelse>Rejected</cfif>.
                </p>
            </cfoutput>
            <cflocation url="admin.cfm">
        <cfelse>
            <!-- Error: Invalid status -->
            <cfoutput><p style="color: red;">Error: Invalid status value.</p></cfoutput>
        </cfif>
    <cfelse>
        <!-- Error: Missing int_user_id or status -->
        <cfoutput><p style="color: red;">Error: User ID or Status is missing.</p></cfoutput>
    </cfif>
</cfif>
<cfloop query="qryUsers">
    <cfquery name="qrygetAllPermissions" datasource="#datasource#">
        SELECT int_permission_id, str_permission_name
        FROM tbl_permissions
    </cfquery>

    <!-- Query to get the permissions assigned to the user -->
    <cfquery name="qryUserPermissions" datasource="#datasource#">
        SELECT int_permission_id
        FROM tbl_user_permissions
        WHERE int_user_id = <cfqueryparam value="#int_user_id#" cfsqltype="cf_sql_integer">
    </cfquery>
</cfloop>