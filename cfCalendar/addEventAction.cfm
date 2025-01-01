   <cfset variables.datasource = "dsn_address_book">
    <cfset variables.str_event_title = "">
    <cfset variables.str_description = "">
    <cfset variables.dt_event_date = "">
    <cfset variables.str_reminder_email = "">
    <cfset variables.str_recurring = "none"> 
    <cfset variables.int_recurring_duration = 1> 
    <cfset variables.strErrorMsg = "">
    <cfset variables.strSuccessMsg = "">
    <cfset variables.dateString = "">
    <cfset variables.dt_start_time = "00:00:00">
    <cfset variables.dt_end_time = "00:00:00">

    <!--- Get eventId from form if exists --->
    <cfset eventId = structKeyExists(form, "eventId") ? form.eventId : "" >
    <cfset variables.int_event_id = structKeyExists(form, "eventId") ? form.eventId : 0> 
     
<cffunction name="setFormData" access="public" returntype="void">
    <cfif len(variables.int_event_id) NEQ 0>
        <cfquery name="variables.qryGetEvents" datasource="#datasource#">
            SELECT 
                int_event_id,
                str_event_title,
                str_description,
                dt_event_date,
                str_reminder_email,
                str_priority,
                str_recurring,
                str_time_constraint,
                int_recurring_duration,
                dt_start_time,
                dt_end_time
            FROM tbl_events
            WHERE int_event_id = <cfqueryparam value="#variables.int_event_id#" cfsqltype="cf_sql_integer">
        </cfquery>
        <!--- Set event data to variables --->
        <cfset variables.str_event_title = variables.qryGetEvents.str_event_title>
        <cfset variables.str_description = variables.qryGetEvents.str_description>
        <cfset variables.dt_event_date = variables.qryGetEvents.dt_event_date>
        <cfset variables.dateString = ListFirst(variables.dt_event_date, "T")>
        <cfset variables.str_priority = variables.qryGetEvents.str_priority>   
        <cfset variables.str_time_constraint = variables.qryGetEvents.str_time_constraint>   
        <cfset variables.str_reminder_email = variables.qryGetEvents.str_reminder_email>
        <cfset variables.str_recurring = variables.qryGetEvents.str_recurring>
        <cfset variables.int_recurring_duration = variables.qryGetEvents.int_recurring_duration>
        <cfset variables.dt_start_time = variables.qryGetEvents.dt_start_time>
        <cfset variables.dt_end_time = variables.qryGetEvents.dt_end_time>
    </cfif>
</cffunction>
<cffunction name="getFormValues" access="public" returntype="void">
    <!-- Trim and assign values from form fields -->
    <cfset variables.str_event_title = trim(form.str_event_title)>
    <cfset variables.str_description = trim(form.str_description)>
    
    <!-- Ensure proper date format for event date -->
    <cfset variables.dt_event_date = structKeyExists(form, "dt_event_date") ? form.dt_event_date : "">
    
    <cfset variables.str_reminder_email = trim(form.str_reminder_email)>
    
    <cfset variables.str_priority = structKeyExists(form, "str_priority") ? form.str_priority : "low">
    
     
    <cfset variables.int_recurring_duration = structKeyExists(form, "int_recurring_duration") AND isNumeric(form.int_recurring_duration) ? form.int_recurring_duration : 1>
    <cfset variables.str_recurring = structKeyExists(form, "str_recurring") ? form.str_recurring : "none">
    <cfset variables.dt_start_time = structKeyExists(form, "start_time") ? form.start_time : "">
    <cfset variables.dt_end_time = structKeyExists(form, "end_time") ? form.end_time : "">
    <cfset variables.str_time_constraint = structKeyExists(form, "variables.str_time_constraint") ? form.variables.str_time_constraint : "">
   
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
    <cfif NOT REFindNoCase("^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$", variables.str_reminder_email)>
        <cfset variables.strErrorMsg &= 'Reminder Email is not valid.<br>'>
    </cfif>

    <!--- Validate Recurrence Duration --->
    <cfif NOT (isNumeric(variables.int_recurring_duration) AND variables.int_recurring_duration GTE 1)>
        <cfset variables.strErrorMsg &= 'Recurrence Duration must be a number greater than or equal to 1.<br>'>
    </cfif>

    <!--- Validate Start Time only if "custom" is selected --->
    <cfif variables.str_time_constraint EQ "custom">
        <cfif NOT len(variables.dt_start_time)>
            <cfset variables.strErrorMsg &= 'Start Time is required when custom time is selected.<br>'>
        </cfif>
    </cfif>

    <!--- Validate End Time only if "custom" is selected --->
    <cfif variables.str_time_constraint EQ "custom">
        <cfif NOT len(variables.dt_end_time)>
            <cfset variables.strErrorMsg &= 'End Time is required when custom time is selected.<br>'>
        </cfif>
    </cfif>

    <!-- Return the accumulated error messages -->
    <cfreturn variables.strErrorMsg>
</cffunction>
<cfif structKeyExists(variables, "dt_start_time") AND variables.dt_start_time NEQ "">
    <cfset startTimeParam = variables.dt_start_time>

</cfif>

<cfif structKeyExists(variables, "dt_end_time") AND variables.dt_end_time NEQ "">
    <cfset endTimeParam = variables.dt_end_time>

</cfif>

<!--- Function to update or insert event data --->
<cffunction name="saveOrUpdateEvent" access="public" returntype="string">
    <cfset variables.str_time_constraint = trim(variables.str_time_constraint)>
    <cfset recurrenceCount = variables.int_recurring_duration>
    <cfset recurrenceType = variables.str_recurring>
    <cfif recurrenceType EQ "daily">
        <cfset incrementValue = 1>
    <cfelseif recurrenceType EQ "weekly">
         <cfset incrementValue = 7>
    <cfelseif recurrenceType EQ "monthly">
        <cfset incrementValue = 0> 
    <cfelse>
        <cfset incrementValue = 1> 
    </cfif>
   
    <cfif variables.str_recurring NEQ "none">
        <cfif structKeyExists(variables, "int_event_id") AND variables.int_event_id EQ 0>
    
                <cfloop from="1" to="#recurrenceCount#" index="i">
                    <cfif recurrenceType EQ "monthly">
                        <!-- Calculate the new event date for monthly recurrence -->
                        <cfset newEventDate = DateAdd("m", i, variables.dt_event_date)>
                    <cfelseif recurrenceType EQ "daily">
                        <!-- For daily recurrence, add 1 day for each iteration -->
                        <cfset newEventDate = DateAdd("d", (i - 1) * incrementValue, variables.dt_event_date)>
                    <cfelse>
                        <!-- For weekly recurrence -->
                        <cfset newEventDate = DateAdd("d", (i - 1) * incrementValue, variables.dt_event_date)>
                    </cfif>
                    <cfset variables.dateString = ListFirst(newEventDate, "T")>
                    <cfquery datasource="#datasource#">
                        INSERT INTO tbl_events (str_event_title, str_description, dt_event_date, str_reminder_email, str_priority, str_recurring, str_time_constraint, int_recurring_duration, dt_start_time, dt_end_time)
                        VALUES (
                            <cfqueryparam value="#variables.str_event_title#" cfsqltype="cf_sql_varchar">,
                            <cfqueryparam value="#variables.str_description#" cfsqltype="cf_sql_longvarchar">,
                            <cfqueryparam value="#variables.dateString#" cfsqltype="cf_sql_timestamp">,
                            <cfqueryparam value="#variables.str_reminder_email#" cfsqltype="cf_sql_varchar">,
                            <cfqueryparam value="#variables.str_priority#" cfsqltype="cf_sql_varchar">,
                            <cfqueryparam value="#variables.str_recurring#" cfsqltype="cf_sql_varchar">,
                            <cfqueryparam value="#variables.str_time_constraint#" cfsqltype="cf_sql_varchar">,
                            <cfqueryparam value="#variables.int_recurring_duration#" cfsqltype="cf_sql_integer">,
                            <cfif variables.str_time_constraint EQ "custom">
                                dt_start_time = <cfqueryparam value="#variables.dt_start_time#" cfsqltype="cf_sql_timestamp">,
                                dt_end_time = <cfqueryparam value="#variables.dt_end_time#" cfsqltype="cf_sql_timestamp">
                            <cfelseif variables.str_time_constraint EQ "full_day">
                                dt_start_time = <cfqueryparam value="00:00:00">,
                                dt_end_time = <cfqueryparam value="23:59:59">
                            <cfelse>
                                dt_start_time = <cfqueryparam value="00:00:00">,
                                dt_end_time = <cfqueryparam value="11:59:59">
                            </cfif>
                            )
                    </cfquery>
                    <cfset variables.strSuccessMsg = "Events created successfully!">
                </cfloop>
        <cfelse>
            
                <cfloop from="1" to="#recurrenceCount#" index="i">
                    <cfif recurrenceType EQ "monthly">
                        <!-- Calculate the new event date for monthly recurrence -->
                        <cfset newEventDate = DateAdd("m", i, variables.dt_event_date)>
                    <cfelseif recurrenceType EQ "daily">
                        <!-- For daily recurrence, add 1 day for each iteration -->
                        <cfset newEventDate = DateAdd("d", (i - 1) * incrementValue, variables.dt_event_date)>
                    <cfelse>
                        <!-- For weekly recurrence -->
                        <cfset newEventDate = DateAdd("d", (i - 1) * incrementValue, variables.dt_event_date)>
                    </cfif>
                    <cfset variables.dateString = ListFirst(newEventDate, "T")>
                    <cfquery datasource="#datasource#">
                        UPDATE tbl_events
                        SET 
                            str_event_title = <cfqueryparam value="#variables.str_event_title#" cfsqltype="cf_sql_varchar">,
                            str_description = <cfqueryparam value="#variables.str_description#" cfsqltype="cf_sql_longvarchar">,
                            dt_event_date = <cfqueryparam value="#variables.dateString#" cfsqltype="cf_sql_timestamp">,
                            str_reminder_email = <cfqueryparam value="#variables.str_reminder_email#" cfsqltype="cf_sql_varchar">,
                            str_priority = <cfqueryparam value="#variables.str_priority#" cfsqltype="cf_sql_varchar">,
                            str_recurring = <cfqueryparam value="#variables.str_recurring#" cfsqltype="cf_sql_varchar">,
                            str_time_constraint  = <cfqueryparam value="#variables.str_time_constraint#" cfsqltype="cf_sql_varchar">,
                            int_recurring_duration = <cfqueryparam value="#variables.int_recurring_duration#" cfsqltype="cf_sql_integer">,
                            <cfif variables.str_time_constraint EQ "custom">
                                dt_start_time = <cfqueryparam value="#variables.dt_start_time#" cfsqltype="cf_sql_timestamp">,
                                dt_end_time = <cfqueryparam value="#variables.dt_end_time#" cfsqltype="cf_sql_timestamp">
                            <cfelseif variables.str_time_constraint EQ "full_day">
                                dt_start_time = <cfqueryparam value="00:00:00" >,
                                dt_end_time = <cfqueryparam value="23:59:59">
                            <cfelse>
                                dt_start_time = <cfqueryparam value="00:00:00">,
                                dt_end_time = <cfqueryparam value="11:59:59">
                        
                            </cfif>
                        WHERE int_event_id = <cfqueryparam value="#variables.int_event_id#" cfsqltype="cf_sql_integer">
                    </cfquery>
                    <cfset variables.strSuccessMsg = "Event updated successfully!"> 
                </cfloop>
            </cfif>
    </cfif>
    <cfreturn variables.strSuccessMsg>
</cffunction>


<!--- Main processing logic --->

<cfif not structKeyExists(session, "int_user_id") or session.int_user_id EQ "" or session.int_user_id IS 0>
    <cflocation url="../cfAddressbook/login.cfm">
</cfif>


<cfset setFormData()>

<cfif structKeyExists(form, "int_event_id")>
    

    <cfset getFormValues()>
    
    <!--- Validate the form values ---> 
    <cfset variables.strErrorMsg = validateFormValues()>
    
    <cfif NOT len(variables.strErrorMsg)>
        
        <cfset variables.strSuccessMsg = saveOrUpdateEvent(
           
            variables.str_event_title,
            variables.str_description,
            variables.dt_event_date,
            variables.str_reminder_email,
            variables.str_recurring,
            variables.int_recurring_duration,
            variables.dt_start_time,
            variables.dt_end_time
        )>
        
        <!--- Re-fetch the event details to ensure updated values are displayed ---> 
        <cfif len(variables.int_event_id)>
            <cfset setFormData()>
        </cfif>   
    </cfif>
    
</cfif>

<cfif structKeyExists(form, "str_time_constraint")>
    <cfset selectedTimeOption = form.str_time_constraint>
<cfelse>
    <cfset selectedTimeOption = "">
</cfif>

<cfif selectedTimeOption EQ "custom">
    <cfset showCustomTimeFields = true>
<cfelse>
    <cfset showCustomTimeFields = false>
</cfif>




