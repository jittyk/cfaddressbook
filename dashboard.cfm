<!-- Check if the user is logged in, otherwise redirect to login -->
<cfif not structKeyExists(session, "userId")>
    <cflocation url="login.cfm">
</cfif>

<!-- Check if the user is an admin or a regular user and display the appropriate dashboard -->
<cfif session.role EQ 1>
    <!-- Admin Dashboard -->
    <h1>Welcome, Admin #session.userEmail#!</h1>
    <h2>Admin Dashboard</h2>

    <ul>
        <li><a href="admin/manageUsers.cfm">Manage Users</a></li>
        <li><a href="admin/viewContacts.cfm">View All Contacts</a></li>
        <li><a href="admin/reports.cfm">View Reports</a></li>
        <li><a href="logout.cfm">Logout</a></li>
    </ul>
<cfelse>
    <!-- Regular User Dashboard -->
    <h1>Welcome, #session.userEmail#!</h1>
    <h2>Your Dashboard</h2>

    <ul>
        <li><a href="user/viewContacts.cfm">View Your Contacts</a></li>
        <li><a href="user/addContact.cfm">Add a New Contact</a></li>
        <li><a href="user/editProfile.cfm">Edit Profile</a></li>
        <li><a href="logout.cfm">Logout</a></li>
    </ul>
</cfif>







<form method="post" action="admin.cfm">
    <!-- Set the User ID -->
    <input type="hidden" name="userId" value="#intUserId#">
    <input type="hidden" name="action" value="updatePermissions">

    <!-- Query to get all available permissions -->
    <cfquery name="qrygetAllPermissions" datasource="dsn_address_book">
        SELECT intPermissionId, strPermissionName
        FROM tbl_permissions
    </cfquery>

    <!-- Query to get the permissions assigned to the user -->
    <cfquery name="qryUserPermissions" datasource="dsn_address_book">
        SELECT intPermissionId
        FROM tbl_user_permissions
        WHERE intUserId = <cfqueryparam value="#intUserId#" cfsqltype="cf_sql_integer">
    </cfquery>

    <!-- Loop through all available permissions -->
    <cfloop query="qrygetAllPermissions">
        <div>
            <!-- Check if the current permission is assigned to the user -->
            <input 
                type="checkbox" 
                name="permissions" 
                value="#intPermissionId#" 
                <cfif qryUserPermissions.recordCount GT 0 AND listFind(valueList(qryUserPermissions.intPermissionId), qrygetAllPermissions.intPermissionId)>checked="checked"</cfif>
            />
            #strPermissionName#
        </div>
    </cfloop>

    <button type="submit" class="btn btn-primary">Update</button>
</form>
