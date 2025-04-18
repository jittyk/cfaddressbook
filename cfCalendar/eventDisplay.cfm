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
    <link rel="stylesheet" href="styles/event.css">
</head>
<body>
    <cfinclude template="../header.cfm">
    <cfoutput>
        <main class="container">
            <div class="container">
                <!--- Display Message if exists --->
                <cfif len(variables.message)>
                    <div class="alert alert-success alert-dismissible fade show mt-3" role="alert">
                        #variables.message#
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </cfif>

                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2>Event Management</h2>
                    <a href="addEvent.cfm" class="btn btn-primary">
                        <i class="bi bi-plus-circle"></i> Add New Event
                    </a>
                </div>
                
                <!-- Form to select view -->
                <form action="eventDisplay.cfm" method="POST" class="mb-4">
                    <div class="row align-items-end">
                        <div class="col-md-4">
                            <label for="viewSelector" class="form-label">Select View:</label>
                            <select class="form-select" id="viewSelector" name="view" onchange="this.form.submit()">
                                <option value="month" <cfif form.view EQ "month">selected</cfif>>Month</option>
                                <option value="week" <cfif form.view EQ "week">selected</cfif>>Week</option>
                                <option value="day" <cfif form.view EQ "day">selected</cfif>>Day</option>
                            </select>
                        </div>
                    </div>
                </form>

                <!-- Event Display Section -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title mb-0">
                            <cfif form.view EQ "month">
                                Events for #DateFormat(variables.currentDate, "mmmm yyyy")#
                            <cfelseif form.view EQ "week">
                                Events for Week of #DateFormat(variables.startOfWeek, "mmmm dd, yyyy")#
                            <cfelseif form.view EQ "day">
                                Events for #DateFormat(variables.currentDate, "mmmm dd, yyyy")#
                            </cfif>
                        </h3>
                    </div>
                    <div class="card-body">
                        <cfif events.recordCount GT 0>
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Event</th>
                                            <th>Date</th>
                                            <th>Description</th>
                                            <th>Recurring</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <cfloop query="events">
                                            <tr>
                                                <td>
                                                    <cfset str_event_color = "gray">
                                                    <cfif str_priority EQ "High">
                                                        <cfset str_event_color = "red"> <!-- Red for High Priority -->
                                                    <cfelseif str_priority EQ "Medium">
                                                        <cfset eventColor = "orange"> <!-- Orange for Medium Priority -->
                                                    <cfelseif str_priority EQ "Low">
                                                        <cfset str_event_color = "green"> <!-- Green for Low Priority -->
                                                    </cfif>
                                                    <span class="event-dot" style="background-color: #str_event_color#"></span>
                                                    #str_event_title#
                                                </td>
                                                <td>#DateFormat(dt_event_date, "mmm dd, yyyy")#</td>
                                                <td>#str_description#</td>
                                                <td>
                                                    <cfif str_recurrence_type NEQ "none">
                                                        <span class="badge bg-info">
                                                            #UCase(str_recurrence_type)# 
                                                            (#int_recurring_duration# 
                                                            <cfif str_recurrence_type EQ "daily">days
                                                            <cfelseif str_recurrence_type EQ "weekly">weeks
                                                            <cfelseif str_recurrence_type EQ "monthly">months
                                                            </cfif>)
                                                        </span>
                                                    <cfelse>
                                                        <span class="badge bg-secondary">None</span>
                                                    </cfif>
                                                </td>
                                                <td>
                                                    <form action="addEvent.cfm" method="post" style="display: inline-block; margin-right: 5px;">
                                                        <input type="hidden" name="eventId" value="#id#">
                                                        <input type="hidden" name="selectedDate" value="#DateFormat(dt_event_date, 'yyyy-mm-dd')#">
                                                        <button type="submit" class="btn btn-sm btn-warning">
                                                            <i class="bi bi-pencil"></i> Edit
                                                        </button>
                                                    </form>
                                                    
                                                    <!--- Delete Button --->
                                                    <form action="eventDisplay.cfm" method="POST" style="display: inline-block;">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="eventId" value="#id#">
                                                        <button type="submit" class="btn btn-sm btn-danger" 
                                                                onclick="return confirm('Are you sure you want to delete this event?')">
                                                            <i class="bi bi-trash"></i> Delete
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </cfloop>
                                    </tbody>
                                </table>
                            </div>
                        <cfelse>
                            <div class="alert alert-info">
                                No events found for the selected time period.
                            </div>
                        </cfif>
                    </div>
                </div>
            </div>
        </main>
    </cfoutput>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
 <cfinclude template="../footer.cfm">
 </body>
</html>