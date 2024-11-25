<cfif structKeyExists(form, "first_name")>
    <!-- Check if email already exists -->
    <cfquery datasource="dsn_address_book" name="checkEmail">
        SELECT str_email FROM tbl_users 
        WHERE str_email = <cfqueryparam value="#form.email#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfif checkEmail.recordCount EQ 0>
       
        <!-- Insert user into the database -->
        <cfquery datasource="dsn_address_book">
            INSERT INTO tbl_users (str_first_name, str_last_name, str_email, str_password, int_user_role_id, cbr_status)
            VALUES (
                <cfqueryparam value="#form.first_name#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#form.last_name#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#form.email#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#form.password#" cfsqltype="cf_sql_varchar">, 
                <cfqueryparam value="2" cfsqltype="cf_sql_integer">, <!-- Regular user role -->
                <cfqueryparam value="P" cfsqltype="cf_sql_char"> <!-- Pending status -->
            )
        </cfquery>
        <cfset registrationStatus = "Registration successful!">
    <cfelse>
        <cfset registrationStatus = "Email already exists.">
    </cfif>
</cfif>

<cfoutput>
<h3>#registrationStatus#</h3>
<form action="register.cfm" method="post">
    <input type="text" name="first_name" placeholder="First Name" required>
    <input type="text" name="last_name" placeholder="Last Name" required>
    <input type="email" name="email" placeholder="Email" required>
    <input type="password" name="password" placeholder="Password" required>
    <input type="hidden" name="int_user_role_id" value="2"> <!-- Regular user -->
    <button type="submit">Register</button>
</form>
</cfoutput>








<cfif structKeyExists(form, "action") AND form.action EQ "updatePermissions">
    <cfset userId = form.userId>
    <cfif NOT isNumeric(userId)>
        <cfthrow message="Invalid User ID">
    </cfif>
    <cfif structKeyExists(form, "permissions_" & userId)>
        <cfset selectedPermissions = form["permissions_" & userId]>
        <cfif NOT isArray(selectedPermissions)>
            <cfset selectedPermissions = ArrayNew(1)>
            <cfset ArrayAppend(selectedPermissions, selectedPermissions)>
        </cfif>
        <cfquery name="qryDeleteOldPermissions" datasource="dsn_address_book">
            DELETE FROM tbl_user_permissions
            WHERE intUserId = <cfqueryparam value="#userId#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfif ArrayLen(selectedPermissions) GT 0>
            <cfloop array="#selectedPermissions#" index="permission">
                <cfquery name="qryInsertPermissions" datasource="dsn_address_book">
                    INSERT INTO tbl_user_permissions (intUserId, permissions)
                    VALUES (
                        <cfqueryparam value="#userId#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#permission#" cfsqltype="cf_sql_varchar">
                    )
                </cfquery>
            </cfloop>
            
            <!--- Output message before redirect --->
            <cfoutput>Access updated for user #userId#.</cfoutput>
        
            <!--- Redirect after displaying message --->
            <cflocation url="admin.cfm" addtoken="no">
        </cfif>
        
            
        <cfelse>
            <cfoutput>No permissions selected for user #userId#.</cfoutput>
        </cfif>
    </cfif>