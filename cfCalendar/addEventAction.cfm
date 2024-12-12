
<cffunction name="initializeFormVariables" access="public" returntype="void" output="false">
    <cfset variables.datasource = "dsn_address_book">
    <cfset variables.str_event_title = "">
    <cfset variables.str_description = "">
    <cfset variables.dt_event_date = "">
    <cfset variables.dateString="">
    <cfset variables.str_priority = "">
    <cfset variables.str_reminder_email = "">
    <cfset variables.strErrorMsg = "">
    <cfset variables.strSuccessMsg = "">
    

    <!--- Get eventId from form if exists --->
    <cfset eventId = structKeyExists(form, "eventId") ? form.eventId : "" >
    
    <cfset variables.int_event_id = structKeyExists(form, "eventId") ? form.eventId : 0> 
    
  </cffunction>
 <cffunction name="setFormData" access="public" returntype="void">
    <cfif len(variables.int_event_id) NEQ 0>
        <cfquery name="variables.qryGetEvents" datasource="dsn_address_book">
            SELECT 
                int_event_id,
                str_event_title,
                str_description,
                dt_event_date,
                str_priority,
                str_reminder_email
            FROM tbl_events
            WHERE int_event_id = <cfqueryparam value="#variables.int_event_id#" cfsqltype="cf_sql_integer">
        </cfquery>

        

        <!--- Set event data to variables --->
        <cfset variables.str_event_title = variables.qryGetEvents.str_event_title>
        <cfset variables.str_description = variables.qryGetEvents.str_description>
        <cfset variables.dt_event_date = variables.qryGetEvents.dt_event_date>
        <cfset variables.dateString = ListFirst(variables.qryGetEvents.dt_event_date, "T")>
        <cfset variables.str_priority = variables.qryGetEvents.str_priority>
        <cfset variables.str_reminder_email = variables.qryGetEvents.str_reminder_email>
    </cfif>
   
</cffunction>
<cffunction name="getFormValues" access="public" returntype="void">
    
    <!-- Check if eventId exists, if so, use it, else default to 0 -->
    
    <!-- Trim and assign values from form fields -->
    <cfset variables.str_event_title = trim(form.str_event_title)>
    <cfset variables.str_description = trim(form.str_description)>
    
    <!-- Ensure proper date format for event date -->
    <cfset variables.dt_event_date = structKeyExists(form, "dt_event_date") ? form.dt_event_date : "">
    
    <cfset variables.str_reminder_email = trim(form.str_reminder_email)>
    
    <!-- Priority field, default to "low" if not provided -->
    <cfset variables.str_priority = structKeyExists(form, "str_priority") ? form.str_priority : "low">

</cffunction>

<cffunction name="validateFormValues" access="public" returntype="string">
    <cfset var variables.strErrorMsg = "">

    <!--- Validate Event Title --->
    <cfif NOT len(variables.str_event_title)>
        <cfset variables.strErrorMsg &= 'Event Title is required.<br>'>
    </cfif>

    <!--- Validate Description --->
    <cfif NOT len(variables.str_description)>
        <cfset variables.strErrorMsg &= 'Description is required.<br>'>
    </cfif>

    <!--- Validate Event Date --->
    <cfif NOT len(variables.dt_event_date) OR variables.dt_event_date EQ "">
        <cfset variables.strErrorMsg &= 'Valid Event Date is required.<br>'>
    </cfif>
    
    <!--- Validate Reminder Email ---> 
<cfif NOT len(variables.str_reminder_email)>
    <cfset variables.strErrorMsg &= 'Reminder Email is not valid.<br>'>
</cfif>

    
    <!--- Validate Priority --->
    <cfif NOT len(variables.str_priority)>
        <cfset variables.strErrorMsg &= 'Priority is required.<br>'>
    </cfif>

    <!-- Return the accumulated error messages -->
    <cfreturn variables.strErrorMsg>
</cffunction>


<!--- Function to update or insert event data --->
<cffunction name="saveOrUpdateEvent" access="public" returntype="string">
    <cfargument name="int_event_id" type="any" required="false"> <!--- Event ID for updates --->
    <cfargument name="str_event_title" type="string" required="true">
    <cfargument name="str_description" type="string" required="true">
    <cfargument name="dt_event_date" type="string" required="true">
    <cfargument name="str_priority" type="string" required="true">
    <cfargument name="str_reminder_email" type="string" required="false">

    <cfset var responseMessage = "">
    <cfset var isEdit = structKeyExists(variables, "int_event_id") 
        AND variables.int_event_id NEQ 0 
        AND variables.int_event_id NEQ "" 
        AND isNumeric(variables.int_event_id)>

    <cfif NOT isEdit>
        <!--- Insert New Event --->
        <cfquery datasource="dsn_address_book">
            INSERT INTO tbl_events (
                str_event_title, 
                str_description, 
                dt_event_date, 
                str_priority, 
                str_reminder_email 
            ) VALUES (
                <cfqueryparam value="#arguments.str_event_title#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.str_description#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.dt_event_date#" cfsqltype="cf_sql_timestamp">,
                <cfqueryparam value="#arguments.str_priority#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.str_reminder_email#" cfsqltype="cf_sql_varchar">
            )
        </cfquery>
        <cfset responseMessage = "Event created successfully!">
    <cfelse>
        <!--- Update Existing Event --->
        <cfquery datasource="dsn_address_book">
            UPDATE tbl_events
            SET 
                str_event_title = <cfqueryparam value="#arguments.str_event_title#" cfsqltype="cf_sql_varchar">,
                str_description = <cfqueryparam value="#arguments.str_description#" cfsqltype="cf_sql_varchar">,
                dt_event_date = <cfqueryparam value="#arguments.dt_event_date#" cfsqltype="cf_sql_timestamp">,
                str_priority = <cfqueryparam value="#arguments.str_priority#" cfsqltype="cf_sql_varchar">,
                str_reminder_email = <cfqueryparam value="#arguments.str_reminder_email#" cfsqltype="cf_sql_varchar">
            WHERE int_event_id = <cfqueryparam value="#arguments.int_event_id#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfset responseMessage = "Event updated successfully!">
    </cfif>

    <cfreturn responseMessage>
</cffunction>


<!--- Main processing logic --->

<!--- Check if the user is logged in ---> 
<cfif not structKeyExists(session, "int_user_id") or session.int_user_id EQ "" or session.int_user_id IS 0>
    <cflocation url="../login.cfm">
</cfif>

<!--- Initialize form variables when the page loads ---> 
<cfset initializeFormVariables()>
<cfset setFormData()>

<cfif structKeyExists(form, "int_event_id")>
    

    <cfset getFormValues()>
    
    <!--- Validate the form values ---> 
    <cfset variables.strErrorMsg = validateFormValues()>
    
    <cfif NOT len(variables.strErrorMsg)>
        <!--- Save or update event details based on form submission ---> 
        <cfset variables.strSuccessMsg = saveOrUpdateEvent(
            variables.int_event_id,
            variables.str_event_title,
            variables.str_description,
            variables.dt_event_date,
            variables.str_priority,
            variables.str_reminder_email
        )>
        
        <!--- Re-fetch the event details to ensure updated values are displayed ---> 
        <cfif len(variables.int_event_id)>
            <cfset setFormData()>
        </cfif>   
    </cfif>
    
</cfif>


