<!-- Define function to query events -->
<cffunction name="getEvents" access="public" returntype="query" output="false">
    <cfargument name="selectedDate" type="date" required="true">
    <cfargument name="datasource" type="string" required="true">

    <cfset var eventQuery = "">

    <!-- Query to retrieve events for the selected date -->
    <cfquery name="eventQuery" datasource="#arguments.datasource#">
        SELECT 
            int_event_id,
            str_event_title,
            str_description,
            dt_event_date,
            str_reminder_email,
            str_priority,
            str_recurring,
            dt_start_time,
            dt_end_time
        FROM tbl_events
        WHERE dt_event_date LIKE <cfqueryparam value="#dateFormat(arguments.selectedDate, 'yyyy-mm-dd')#%" cfsqltype="cf_sql_varchar">
    </cfquery>
<cfset variables.formattedStartTime = timeFormat(#eventQuery.dt_start_time#, "HH:mm:00")> <!--- Set formatted start time into variables scope --->
<cfset variables.formattedEndTime = timeFormat(#eventQuery.dt_end_time#, "HH:mm:00")> <!--- Set formatted end time into variables scope --->

    <cfreturn eventQuery>
</cffunction>

<!-- Control Block -->
<cfset variables.datasource = "dsn_address_book">

<!-- Check if form.date exists -->
<cfif structKeyExists(form, "date")>
    <cfset selectedDate = parseDateTime(form.date)>
<cfelse>
    <!-- Default to current date if form.date is not set -->
    <cfset selectedDate = now()>
</cfif>

<!-- Query events using the selected date -->
<cfset eventQuery = getEvents(selectedDate, variables.datasource)>

<!-- Pass eventQuery and selectedDate to the display page -->
<cfset variables.eventQuery = eventQuery>
<cfset variables.selectedDate = selectedDate>
