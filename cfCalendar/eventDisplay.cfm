<cfinclude template="eventDisplayAction.cfm">

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
