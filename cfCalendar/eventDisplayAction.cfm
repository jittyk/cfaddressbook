<cfif not structKeyExists(session, "int_user_id") or session.int_user_id EQ "" or session.int_user_id IS 0> 
    <cflocation url="../cfAddressbook/login.cfm">
</cfif>

<!--- Set default form parameters --->
<cfparam name="form.view" default="month">
<cfparam name="form.action" default="">
<cfparam name="form.eventId" default="0">
<cfparam name="variables.message" default="">

<!--- Initialize variables --->
<cfset variables.currentDate = now()>
<cfset variables.currentYear = year(variables.currentDate)>
<cfset variables.currentMonth = month(variables.currentDate)>
<cfset variables.currentDay = day(variables.currentDate)>
<cfset variables.datasource = "dsn_address_book">

<!--- Handle different views based on selected view (month, week, or day) --->
<cfswitch expression="#form.view#">
    <cfcase value="month">
        <!--- Calculate start and end of the month --->
        <cfset startOfMonth = createDate(variables.currentYear, variables.currentMonth, 1)>
        <cfset endOfMonth = dateAdd("d", -1, createDate(variables.currentYear, variables.currentMonth + 1, 1))>

        <!--- Query to retrieve events for the selected month --->
        <cfquery name="events" datasource="#variables.datasource#">
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
            WHERE (
                (str_recurrence_type = 'none' AND dt_event_date BETWEEN <cfqueryparam value="#startOfMonth#" cfsqltype="cf_sql_timestamp"> AND <cfqueryparam value="#endOfMonth#" cfsqltype="cf_sql_timestamp">)
                OR
                (str_recurrence_type = 'daily' AND DATE_ADD(dt_event_date, INTERVAL int_recurring_duration DAY) >= <cfqueryparam value="#startOfMonth#" cfsqltype="cf_sql_timestamp">)
                OR
                (str_recurrence_type = 'weekly' AND days_of_week LIKE CONCAT('%', DAYOFWEEK(<cfqueryparam value="#variables.currentDate#" cfsqltype="cf_sql_timestamp">), '%'))
                OR
                (str_recurrence_type = 'monthly' AND days_of_month LIKE CONCAT('%', DAY(<cfqueryparam value="#variables.currentDate#" cfsqltype="cf_sql_timestamp">), '%'))
            )
            ORDER BY dt_event_date ASC

        </cfquery>
    </cfcase>

    <cfcase value="week">
        <!--- Calculate start and end of the week --->
        <cfset startOfWeek = dateAdd("d", -dayOfWeek(variables.currentDate) + 1, variables.currentDate)>
        <cfset endOfWeek = dateAdd("d", 7 - dayOfWeek(variables.currentDate), variables.currentDate)>

        <!--- Query to retrieve events for the selected week --->
        <cfquery name="events" datasource="#variables.datasource#">
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
            WHERE (
                (str_recurrence_type = 'none' AND dt_event_date BETWEEN <cfqueryparam value="#startOfWeek#" cfsqltype="cf_sql_timestamp"> AND <cfqueryparam value="#endOfWeek#" cfsqltype="cf_sql_timestamp">)
                OR
                (str_recurrence_type = 'daily' AND DATE_ADD(dt_event_date, INTERVAL int_recurring_duration DAY) >= <cfqueryparam value="#startOfWeek#" cfsqltype="cf_sql_timestamp">)
                OR
                (str_recurrence_type = 'weekly' AND days_of_week LIKE CONCAT('%', DAYOFWEEK(<cfqueryparam value="#variables.currentDate#" cfsqltype="cf_sql_timestamp">), '%'))
            )
            ORDER BY dt_event_date ASC;

        </cfquery>
    </cfcase>

    <cfcase value="day">
        <!--- Calculate start and end of the day --->
        <cfset startOfDay = createDateTime(variables.currentYear, variables.currentMonth, variables.currentDay, 0, 0, 0)>
        <cfset endOfDay = createDateTime(variables.currentYear, variables.currentMonth, variables.currentDay, 23, 59, 59)>

        <!--- Query to retrieve events for the selected day --->
        <cfquery name="events" datasource="#variables.datasource#">
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
            WHERE (
                (str_recurrence_type = 'none' AND dt_event_date BETWEEN <cfqueryparam value="#startOfDay#" cfsqltype="cf_sql_timestamp"> AND <cfqueryparam value="#endOfDay#" cfsqltype="cf_sql_timestamp">)
                OR
                (str_recurrence_type = 'daily' AND DATE_ADD(dt_event_date, INTERVAL int_recurring_duration DAY) >= <cfqueryparam value="#startOfDay#" cfsqltype="cf_sql_timestamp">)
                OR
                (str_recurrence_type = 'weekly' AND days_of_week LIKE CONCAT('%', DAYOFWEEK(<cfqueryparam value="#variables.currentDate#" cfsqltype="cf_sql_timestamp">), '%'))
                OR
                (str_recurrence_type = 'monthly' AND days_of_month LIKE CONCAT('%', DAY(<cfqueryparam value="#variables.currentDate#" cfsqltype="cf_sql_timestamp">), '%'))
            )
            ORDER BY dt_event_date ASC;

        </cfquery>
    </cfcase>
</cfswitch>

<!--- Handle form actions (e.g., delete) --->
<cfif form.action EQ "delete" AND form.eventId GT 0>
    <cfquery name="deleteEvent" datasource="#variables.datasource#">
        DELETE FROM tbl_events 
        WHERE int_event_id = <cfqueryparam value="#form.eventId#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfset variables.message = "Event deleted successfully">
</cfif>
