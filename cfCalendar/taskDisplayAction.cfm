<cfparam name="url.view" default="month">

<!-- Get the current date -->
<cfset currentDate = now()>

<!-- Initialize start and end date based on the view -->
<cfif url.view EQ "month">
    <!-- Fetch events for the current month -->
    <cfset startOfMonth = createDate(year(currentDate), month(currentDate), 1)>
    <cfset endOfMonth = createDate(year(currentDate), month(currentDate) , 1) - 1>
    <cfset startDate = startOfMonth>
    <cfset endDate = endOfMonth>

<cfelseif url.view EQ "week">
    <!-- Fetch events for the current week -->
    <cfset startOfWeek = dateAdd("d", -dayOfWeek(currentDate) + 1, currentDate)>
    <cfset endOfWeek = dateAdd("d", 7 - dayOfWeek(currentDate), currentDate)>
    <cfset startDate = startOfWeek>
    <cfset endDate = endOfWeek>

<cfelseif url.view EQ "day">
    <!-- Fetch events for the current day -->
    <cfset startOfDay = createDateTime(year(currentDate), month(currentDate), day(currentDate), 0, 0, 0)>
    <cfset endOfDay = createDateTime(year(currentDate), month(currentDate), day(currentDate), 23, 59, 59)>
    <cfset startDate = startOfDay>
    <cfset endDate = endOfDay>
</cfif>

<cfquery name="variables.events" datasource="dsn_address_book">
    SELECT int_event_id, str_event_title, dt_event_date, str_priority
    FROM tbl_events
    WHERE dt_event_date >= <cfqueryparam value="#startDate#" cfsqltype="cf_sql_date">
    AND dt_event_date <= <cfqueryparam value="#endDate#" cfsqltype="cf_sql_date">
    ORDER BY dt_event_date
</cfquery>
