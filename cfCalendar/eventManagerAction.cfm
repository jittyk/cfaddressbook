<!-- Define function to query events -->
<cffunction name="getEvents" access="public" returntype="query" output="false">
    <cfargument name="selectedDate" type="date" required="true">
    <cfargument name="datasource" type="string" required="true">

    <cfset var qryEvents = "">

    <cfset selectedDate = dateFormat(arguments.selectedDate, "yyyy-mm-dd")>
            
    <cfquery name="qryEvents" datasource="#arguments.datasource#">
        SELECT 
            int_event_id AS id,
            str_event_title,
            str_description,
            str_reminder_email,
            str_priority,
            str_time_constraint,
            dt_start_time,
            dt_end_time,
            bit_mail_sent,
            dt_event_date,
            days_of_week,
            days_of_month,
            str_recurrence_type,
            int_recurring_duration
        FROM tbl_events
        WHERE 
            (dt_event_date = <cfqueryparam value="#selectedDate#" cfsqltype="cf_sql_date">)
            OR 
            (str_recurrence_type = 'daily' AND DATE_ADD(dt_event_date, INTERVAL int_recurring_duration DAY) >= <cfqueryparam value="#selectedDate#" cfsqltype="cf_sql_date">)
            OR 
            (str_recurrence_type = 'weekly' AND days_of_week LIKE CONCAT('%', DAYOFWEEK(<cfqueryparam value="#selectedDate#" cfsqltype="cf_sql_date">), '%'))
            OR 
            (str_recurrence_type = 'monthly' AND days_of_month LIKE CONCAT('%', DAY(<cfqueryparam value="#selectedDate#" cfsqltype="cf_sql_date">), '%'))
    </cfquery>

    <cfreturn qryEvents>
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
<cfset qryEvents = getEvents(selectedDate, variables.datasource)>

<!-- Pass qryEvents and selectedDate to the display page -->
<cfset variables.qryEvents = qryEvents>
<cfset variables.selectedDate = selectedDate>
