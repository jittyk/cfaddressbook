<cfinclude template="eventManagerAction.cfm">
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Event Manager</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <cfinclude template="../header.cfm">
    <cfoutput>

    <main class="container mt-5">
        <h1>Events on #dateFormat(selectedDate, "dd MMM yyyy")#</h1>
        <cfif structKeyExists(variables, "message")>
            <p>#variables.message#</p>
        </cfif>
        <cfif eventQuery.recordCount GT 0>
                        
            <ul class="list-group">
                <cfloop query="eventQuery">
                    <li class="list-group-item">
                        <h5>#str_event_title#</h5>
                        <p>#str_description#</p>
                        <p>Priority:#str_priority#</p><!-- Edit Event Form -->
                        <form action="addEvent.cfm" method="post">
                            <!-- Hidden field for eventId -->
                            <input type="hidden" name="eventId" value="#eventQuery.int_event_id#">
                        
                            <!-- Hidden field for selectedDate -->
                            <input type="hidden" name="selectedDate" value="#dateFormat(selectedDate, 'yyyy-mm-dd')#">
                        
                            <button type="submit" class="btn btn-warning">Edit</button>
                        </form>
                        
                        
                        
                        <!-- Delete Event Form -->
                        <form action="deleteEvent.cfm" method="post">
                            <!-- Hidden field for eventId -->
                            <input type="hidden" name="eventId" value="#int_event_id#">
                            <button type="submit" class="btn btn-danger">Delete</button>
                        </form>
                        
                    </li>

                </cfloop>
            </ul>
        <cfelse>
            <!-- No events found -->
            <p class="text-muted">No events found for this date.</p>
        </cfif>
        <form action="addEvent.cfm" method="post">
          
            <input type="hidden" name="date" value="#dateFormat(selectedDate, 'yyyy-mm-dd')#">
           
            <button type="submit" class="btn btn-primary mt-3">Add New Event</button>
        </form>
        
    </main>
</cfoutput>
        <cfinclude template="../footer.cfm">
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
    