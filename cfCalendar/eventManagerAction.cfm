<!-- Define function to get selected date -->
<cffunction name="getSelectedDate" access="public" returntype="date" output="false">
    <cfargument name="formDate" type="string" required="false">
    
    <cfset var selectedDate = now()>

    <!-- If date parameter exists, parse it; otherwise, use the current date -->
    <cfif len(trim(arguments.formDate))>
        <cfset selectedDate = parseDateTime(arguments.formDate)>
    </cfif>

    <cfreturn selectedDate>
</cffunction>

<!-- Call the function and assign the result -->
  

<!-- Define function to query events based on selected date -->
<cffunction name="getEvents" access="public" returntype="query" output="false">
    <cfargument name="selectedDate" type="date" required="true">
    <cfargument name="datasource" type="string" required="true">

    <cfset var eventQuery = "">
    <cfset var eventId = "">

    <!-- Query to retrieve events for the selected date -->
    <cfquery name="eventQuery" datasource="#arguments.datasource#">
        SELECT 
            int_event_id,
            str_event_title,
            str_description,
            dt_event_date,
            str_reminder_email,
            str_priority 
        FROM tbl_events
        WHERE dt_event_date LIKE <cfqueryparam value="#dateFormat(arguments.selectedDate, 'yyyy-mm-dd')#%" cfsqltype="cf_sql_varchar">
    </cfquery>

    <!-- If the query returns rows, get the first event ID -->
    <cfif eventQuery.recordCount gt 0>
        <cfset eventId = eventQuery.int_event_id[1]>
    </cfif>

    <cfreturn eventQuery>
</cffunction>


<!-- Control Block -->
<!-- Set the data source -->
<cfset variables.datasource = "dsn_address_book">

<!-- Check if form.date exists -->
<cfif structKeyExists(form, "date")>
    <cfset selectedDate = getSelectedDate(form.date)>
<cfelse>
    <!-- Default to current date if form.date is not set -->
    <cfset selectedDate = now()>
</cfif>

<!-- Query events using the selected date -->
<cfset eventQuery = getEvents(selectedDate, variables.datasource)>

<!-- Set session variable for the event ID if events are found -->
<cfif eventQuery.recordCount>
    <!-- Loop through query results -->
    <cfloop query="eventQuery">
        <cfset session.int_event_id = eventQuery.int_event_id>
    </cfloop>
</cfif>

<!-- Set the formatted date for display -->
<cfset formattedDate = dateFormat(selectedDate, "yyyy-mm-dd")>
