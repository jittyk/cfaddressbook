<cfparam name="form.view" default="month">

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Event Display</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
</head>
<body>

    <cfinclude template="../header.cfm">
    <main class="container">
            
    <div class="container">
        <h2>Event Management</h2>
        
        <!-- Form to select view -->
        <form action="eventDisplay.cfm" method="POST">
            <div class="form-group">
                <label for="viewSelector">Select View:</label>
                <select class="form-control" id="viewSelector" name="view" onchange="this.form.submit()">
                    <option value="month" <cfif form.view EQ "month">selected</cfif>>Month</option>
                    <option value="week" <cfif form.view EQ "week">selected</cfif>>Week</option>
                    <option value="day" <cfif form.view EQ "day">selected</cfif>>Day</option>
                </select>
            </div>
        </form>

        <!-- Event Display Section -->
        <h3 id="viewTitle">
            <cfoutput>
                <cfif form.view EQ "month">
                    Events for #DateFormat(now(), "mmmm yyyy")#
                <cfelseif form.view EQ "week">
                    Events for Week #DatePart("W", now())#
                <cfelseif form.view EQ "day">
                    Events for #DateFormat(now(), "mmmm dd, yyyy")#
                </cfif>
            </cfoutput>
        </h3>

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

        <!-- Display events -->
        <cfoutput>
            <cfif events.recordCount GT 0>
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>Event Title</th>
                <th>Event Date</th>
                <th>Priority</th>
            </tr>
        </thead>
        <tbody>
            <cfloop query="events">
                <cfset variables.dateString = ListFirst(dt_event_date, "T")>
                <tr>
                    <td>#str_event_title#</td>
                    <td>#variables.dateString#</td>
                    <td>#str_priority#</td>
                </tr>
            </cfloop>
        </tbody>
    </table>
<cfelse>
    <p>No events found for the selected time period.</p>
</cfif>

        </cfoutput>

    </div>
    </main>
    <cfinclude template="../footer.cfm">

</body>
</html>
