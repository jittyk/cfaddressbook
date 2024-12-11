<!-- Define function to get selected date -->
<cffunction name="getSelectedDate" access="public" returntype="date" output="false">
    <cfargument name="formDate" type="string" required="false">
    
    <cfset var selectedDate = now()>

    <!-- If date parameter exists in the form, parse it; otherwise, use current date -->
    <cfif len(arguments.formDate)>
        <cfset selectedDate = parseDateTime(arguments.formDate)>
    </cfif>
    
    <cfreturn selectedDate>
</cffunction>

<!-- Define function to query events based on selected date -->
<cffunction name="getEvents" access="public" returntype="query" output="false">
    <cfargument name="selectedDate" type="date" required="true">
    <cfset var eventQuery = "">
    <cfset var eventId = ""> <!-- Initialize eventId variable -->

    <!-- Query to retrieve events for the selected date -->
    <cfquery name="eventQuery" datasource="#variables.datasource#">
        SELECT 
            int_event_id,
            str_event_title,
            str_description,
            dt_event_date,
            str_reminder_email,
            dt_reminder_time,
            str_priority 
        FROM tbl_events
        WHERE dt_event_date LIKE <cfqueryparam value="#dateFormat(arguments.selectedDate, 'yyyy-mm-dd')#%" cfsqltype="cf_sql_varchar">
    </cfquery>

    <!-- Check if the query returns any rows -->
    <cfif eventQuery.recordCount gt 0>
        <!-- Access the first row's int_event_id -->
        <cfset eventId = eventQuery.int_event_id[1]>
    </cfif>

    <!-- If you want to use eventQuery elsewhere -->
    <cfreturn eventQuery>
</cffunction>

<!-- Control Block -->
<cfset variables.datasource = "dsn_address_book">

<!-- Get the selected date from the form (hidden field) -->
<cfset selectedDate = getSelectedDate(form.date)>

<!-- Query to retrieve events for the selected date -->
<cfset eventQuery = getEvents(selectedDate)>

<!-- Set session variable for the event ID if events are found -->
<cfif eventQuery.recordCount>
    <!-- Loop through query results if there are multiple events -->
    <cfloop query="eventQuery">
        <cfset session.int_event_id = eventQuery.int_event_id>
        <!-- You can set additional session variables if needed for each event -->
    </cfloop>
</cfif>

<!-- Set the formatted date for display -->
<cfset formattedDate = dateFormat(selectedDate, "yyyy-mm-dd")>
