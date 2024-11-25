<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<cfif structKeyExists(form, "submit")>
    <cfset email = trim(form.email)>
    
    <!-- Check if the email exists in the users table -->
    <cfquery name="userCheck" datasource="dsn_address_book">
        SELECT id FROM users WHERE email = <cfqueryparam value="#email#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfif userCheck.recordCount eq 1>
        <!-- Generate a unique reset token -->
        <cfset resetToken = createUUID()>
        <cfset tokenExpiry = DateAdd("h", 1, Now())>
        <cfset tokenExpiryFormatted = DateFormat(tokenExpiry, "yyyy-mm-dd") & " " & TimeFormat(tokenExpiry, "HH:mm:ss")>
        
        <!-- Insert reset token and expiry into users table -->
        <cfquery datasource="dsn_address_book">
            UPDATE users
            SET reset_token = <cfqueryparam value="#resetToken#" cfsqltype="cf_sql_varchar">,
                token_expiry = <cfqueryparam value="#tokenExpiryFormatted#" cfsqltype="cf_sql_timestamp">
            WHERE email = <cfqueryparam value="#email#" cfsqltype="cf_sql_varchar">
        </cfquery>

        <!-- Insert email details into email_queue table -->
        <cfquery datasource="dsn_address_book">
            INSERT INTO email_queue (recipient_email, subject, body, status, created_date)
            VALUES (
                <cfqueryparam value="#email#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="Password Reset Request" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="Click the link to reset your password: <a href='resetPassword.cfm?token=#resetToken#'>Reset Password</a>" cfsqltype="cf_sql_longvarchar">,
                <cfqueryparam value="pending" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">
            )
        </cfquery>

        <div class="alert alert-success" role="alert">
            A password reset link has been sent to your email address.
        </div>
    <cfelse>
        <div class="alert alert-danger" role="alert">
            The email address you entered does not exist in our system.
        </div>
    </cfif>
</cfif>

<form action="forgotPassword.cfm" method="post">
    <input type="email" name="email" class="form-control" placeholder="Enter your email" required>
    <button type="submit" name="submit" class="btn btn-primary mt-3">Request Password Reset</button>
</form>

</body>
</html>
