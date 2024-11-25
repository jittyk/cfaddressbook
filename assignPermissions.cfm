<cfif structKeyExists(url, "userId") AND structKeyExists(form, "submit")>
    <!-- Check if the form is submitted -->
    <cfset userId = url.userId>
    <cfset permissions = form.permissions>

    <!-- Start a transaction -->
    <cftransaction>

        <!-- Delete existing permissions for the user (optional) -->
        <cfquery name="deletePermissions" datasource="dsn_address_book">
            DELETE FROM tbl_user_permissions
            WHERE intUserId = <cfqueryparam value="#userId#" cfsqltype="cf_sql_integer">
        </cfquery>

        <!-- Insert the selected permissions for the user -->
        <cfloop array="#permissions#" index="permission">
            <cfquery name="insertPermission" datasource="dsn_address_book">
                INSERT INTO tbl_user_permissions (intUserId, #permission#)
                VALUES (<cfqueryparam value="#userId#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="Y" cfsqltype="cf_sql_char">)
            </cfquery>
        </cfloop>

    </cftransaction>

    <cfoutput>
        <p>Permissions assigned successfully!</p>
    </cfoutput>

<cfelse>
    <!-- Show the permission assignment form -->

    <h2>Assign Permissions</h2>

    <form action="assignPermissions.cfm?userId=#url.userId#" method="POST">
        <label>
            <input type="checkbox" name="permissions[]" value="view" 
                <cfif userHasPermission(url.userId, 'view')>checked</cfif>> View
        </label><br>
        
        <label>
            <input type="checkbox" name="permissions[]" value="edit" 
                <cfif userHasPermission(url.userId, 'edit')>checked</cfif>> Edit
        </label><br>
        
        <label>
            <input type="checkbox" name="permissions[]" value="delete" 
                <cfif userHasPermission(url.userId, 'delete')>checked</cfif>> Delete
        </label><br>

        <input type="submit" name="submit" value="Assign Permissions">
    </form>
</cfif>
