<!--- Function to initialize form variables --->
<cffunction name="initializeFormVariables" access="public" returntype="void" output="false">
    <cfset str_event_title = "">
    <cfset str_description = "">
    <cfset dt_event_date = "">
    <cfset str_priority = "">
    <cfset str_reminder_email = "">
    <cfset dt_reminder_time = "">
    <!--- Get eventId from form if exists --->
    <cfset eventId = structKeyExists(form, "eventId") ? form.eventId : "" >
</cffunction>

<!--- Function to fetch event data based on eventId --->
<cffunction name="fetchFormData" access="public" returntype="void" output="false">
    <cfif len(form.eventId)>
        <!--- Fetch event details from the database based on eventId --->
        <cfquery name="qryGetEvents" datasource="dsn_address_book">
            SELECT 
                int_event_id,
                str_event_title,
                str_description,
                dt_event_date,
                str_priority,
                str_reminder_email,
                dt_reminder_time
            FROM tbl_events
            WHERE int_event_id = <cfqueryparam value="#form.eventId#" cfsqltype="cf_sql_integer">
        </cfquery>
        
        <!--- If the event exists, populate the form variables --->
        <cfif qryGetEvents.recordCount GT 0>
            <cfset str_event_title = qryGetEvents.str_event_title>
            <cfset str_description = qryGetEvents.str_description>
            <cfset dt_event_date = qryGetEvents.dt_event_date>
            <cfset str_priority = qryGetEvents.str_priority>
            <cfset str_reminder_email = qryGetEvents.str_reminder_email>
            <cfset dt_reminder_time = qryGetEvents.dt_reminder_time>
        </cfif>
    </cfif>
</cffunction>

<!--- Function to validate form values --->
<cffunction name="validateFormValues" access="public" returntype="boolean" output="false">
    <cfset var isValid = true>
    <cfset var errorMessage = "">

    <!--- Validate Event Title --->
    <cfif form.str_event_title eq "">
        <cfset isValid = false>
        <cfset errorMessage &= "Event Title is required.<br>">
    </cfif>

    <!--- Validate Description --->
    <cfif form.str_description eq "">
        <cfset isValid = false>
        <cfset errorMessage &= "Description is required.<br>">
    </cfif>

    <!--- Validate Event Date --->
    <cfif form.dt_event_date eq "" OR NOT isDate(form.dt_event_date)>
        <cfset isValid = false>
        <cfset errorMessage &= "Valid Event Date is required.<br>">
    </cfif>

    <!--- Validate Reminder Email --->
    <cfif form.str_reminder_email neq "" AND NOT isValidEmail(form.str_reminder_email)>
        <cfset isValid = false>
        <cfset errorMessage &= "Reminder Email is not valid.<br>">
    </cfif>

    <!--- Validate Reminder Time --->
    <cfif form.dt_reminder_time neq "" AND NOT isDate(form.dt_reminder_time)>
        <cfset isValid = false>
        <cfset errorMessage &= "Reminder Time is not a valid date.<br>">
    </cfif>

    <!--- Validate Priority --->
    <cfif form.str_priority eq "">
        <cfset isValid = false>
        <cfset errorMessage &= "Priority is required.<br>">
    </cfif>

    <!--- If invalid, set error message and return false --->
    <cfif NOT isValid>
        <cfset session.validationErrorMessage = errorMessage>
    </cfif>

    <cfreturn isValid>
</cffunction>

<!--- Function to update or insert event data --->
<cffunction name="updateOrInsertData" access="public" returntype="void" output="false">
    <!--- If eventId exists, update the event --->
    <cfif len(form.eventId)>
        <cfquery name="qryUpdateEvent" datasource="dsn_address_book">
            UPDATE tbl_events
            SET 
                str_event_title = <cfqueryparam value="#form.str_event_title#" cfsqltype="cf_sql_varchar">,
                str_description = <cfqueryparam value="#form.str_description#" cfsqltype="cf_sql_varchar">,
                dt_event_date = <cfqueryparam value="#form.dt_event_date#" cfsqltype="cf_sql_timestamp">,
                str_priority = <cfqueryparam value="#form.str_priority#" cfsqltype="cf_sql_varchar">,
                str_reminder_email = <cfqueryparam value="#form.str_reminder_email#" cfsqltype="cf_sql_varchar">,
                dt_reminder_time = <cfqueryparam value="#form.dt_reminder_time#" cfsqltype="cf_sql_timestamp">
            WHERE int_event_id = <cfqueryparam value="#form.eventId#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfset message = "Event updated successfully.">
    <cfelse>
        <!--- Insert a new event if no eventId --->
        <cfquery datasource="dsn_address_book">
            INSERT INTO tbl_events (
                str_event_title, 
                str_description, 
                dt_event_date, 
                str_priority, 
                str_reminder_email, 
                dt_reminder_time
            )
            VALUES (
                <cfqueryparam value="#form.str_event_title#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#form.str_description#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#form.dt_event_date#" cfsqltype="cf_sql_timestamp">,
                <cfqueryparam value="#form.str_priority#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#form.str_reminder_email#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#form.dt_reminder_time#" cfsqltype="cf_sql_timestamp">
            )
        </cfquery>
        <cfset message = "Event created successfully.">
    </cfif>
</cffunction>

<!--- Main logic block --->
<cfset initializeFormVariables()>
<cfif structKeyExists(form, "eventId") AND form.eventId neq "">
    <cfset fetchFormData()>
<cfelse>
    <cfoutput>No eventId found.</cfoutput>
</cfif>

<cfif validateFormValues()>
    <cfset updateOrInsertData()>
    <!--- Redirect with success message --->
    <cflocation url="index.cfm?message=#URLEncodedFormat(message)#">
<cfelse>
    <cflocation url="formPage.cfm?eventId=#form.eventId#">
</cfif>
