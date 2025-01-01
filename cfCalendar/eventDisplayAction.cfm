<cfif not structKeyExists(session, "int_user_id") or session.int_user_id EQ "" or session.int_user_id IS 0>
    <cflocation url="../cfAddressbook/login.cfm">
</cfif>
<cfparam name="form.view" default="month">
 <!-- Event List Section -->
 <cfif form.view EQ "month">
    <!--- Fetch events for the current month --->
    <cfset startOfMonth = createDate(year(now()), month(now()), 1)>
    <!--- Handle month overflow for December (month 12) --->
    <cfset nextMonth = month(now()) + 1>
    <cfset nextYear = year(now())>
    <cfif nextMonth GT 12>
        <cfset nextMonth = 1>
        <cfset nextYear = nextYear + 1>
    </cfif>
    <cfset endOfMonth = createDate(nextYear, nextMonth, 1) - 1>
    
    <cfquery name="events" datasource="dsn_address_book">
        SELECT int_event_id, str_event_title, dt_event_date, str_priority
        FROM tbl_events
        WHERE dt_event_date >= <cfqueryparam value="#startOfMonth#" cfsqltype="cf_sql_date">
        AND dt_event_date <= <cfqueryparam value="#endOfMonth#" cfsqltype="cf_sql_date">
        ORDER BY dt_event_date ASC
    </cfquery>

<cfelseif form.view EQ "week">
    <!-- Fetch events for the current week -->
    <cfset startOfWeek = dateAdd("d", -dayOfWeek(now()) + 1, now())>
    <cfset endOfWeek = dateAdd("d", 7 - dayOfWeek(now()), now())>

    <cfquery name="events" datasource="dsn_address_book">
        SELECT int_event_id, str_event_title, dt_event_date , str_priority
        FROM tbl_events
        WHERE dt_event_date >= <cfqueryparam value="#startOfWeek#" cfsqltype="cf_sql_date">
        AND dt_event_date <= <cfqueryparam value="#endOfWeek#" cfsqltype="cf_sql_date">
        ORDER BY dt_event_date ASC
    </cfquery>

<cfelseif form.view EQ "day">
    <!-- Fetch events for the current day -->
    <cfset startOfDay = createDateTime(year(now()), month(now()), day(now()), 0, 0, 0)>
    <cfset endOfDay = createDateTime(year(now()), month(now()), day(now()), 23, 59, 59)>

    <cfquery name="events" datasource="dsn_address_book">
        SELECT int_event_id, str_event_title, dt_event_date, str_priority
        FROM tbl_events
        WHERE dt_event_date >= <cfqueryparam value="#startOfDay#" cfsqltype="cf_sql_date">
        AND dt_event_date <= <cfqueryparam value="#endOfDay#" cfsqltype="cf_sql_date">
        ORDER BY dt_event_date ASC
    </cfquery>
</cfif>