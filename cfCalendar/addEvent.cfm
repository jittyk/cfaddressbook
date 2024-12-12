<cfinclude template="addEventAction.cfm">
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Add Event</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
         
    </head>
    <body>
        <cfinclude template="../header.cfm">
         <cfoutput>
        <main class="container">
        <h2>Add New Event</h2>
      <div class="text-center">
            <cfif len(variables.strErrorMsg)>
                <div style="color: red;">#variables.strErrorMsg#</div>  
            <cfelse>
                <div style="color: green;">#variables.strSuccessMsg#</div>  
            </cfif>
        </div>
    
        <form action="" method="POST" class="container">
            
            <cfif variables.int_event_id NEQ 0>
                <input type="hidden" name="int_event_id" value="#variables.int_event_id#">
                
            <cfelse>
                <input type="hidden" name="int_event_id" value="0">
            </cfif>
        
            <div class="mb-3 row">
                <label for="str_event_title" class="col-sm-2 col-form-label">Event Title</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" name="str_event_title" id="str_event_title" placeholder="Event name.."
                        <cfif structKeyExists(variables.qryGetEvents, 'str_event_title') AND variables.qryGetEvents.recordCount GT 0>
                            value="#variables.qryGetEvents.str_event_title#"
                        <cfelse>
                            value="" 
                        </cfif>
                       >
                </div>
                
            </div>
        
           


                <div class="mb-3 row">
                    <label for="str_description" class="col-sm-2 col-form-label">Event Description</label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" name="str_description" id="str_description" placeholder="Event description.."
                            <cfif structKeyExists(variables.qryGetEvents, 'str_description') AND variables.qryGetEvents.recordCount GT 0>
                                value="#variables.qryGetEvents.str_description#"
                            <cfelse>
                                value=""  
                            </cfif>
                            >
                    </div>
                    
                </div>
            
                
        
            <div class="mb-3 row">
                <label for="dt_event_date" class="col-sm-2 col-form-label">Event Date</label>
                <div class="col-sm-10">
                    <cfif structKeyExists(variables.qryGetEvents, 'dt_event_date') AND variables.qryGetEvents.recordCount GT 0>
                        <input type="date" class="form-control" name="dt_event_date" id="dt_event_date" 
               value="#variables.dateString#">
                <cfelse>
                    <input type="date" class="form-control" name="dt_event_date" id="dt_event_date">
                
                </cfif>
            </div>
            </div>
        
            <div class="mb-3 row">
                <label for="str_reminder_email" class="col-sm-2 col-form-label">Reminder Email </label>
                <div class="col-sm-10">
                    <input type="email" class="form-control" name="str_reminder_email" id="str_reminder_email" placeholder="Email.." value="#variables.str_reminder_email#">
                </div>
            </div>
        
            
        
            <div class="mb-3 row">
                <label for="str_priority" class="col-sm-2 col-form-label">Priority</label>
                <cfif structKeyExists(variables, "str_priority")>
                    <cfset selectedPriority = variables.str_priority>
                <cfelse>
                    <cfset selectedPriority = "low"> <!-- Default to "low" if not set -->
                </cfif>
                
                <div class="col-sm-10">
                    <select name="str_priority" id="str_priority" >
                        <!-- Default option -->
                        <option value="" disabled
                            <cfif NOT structKeyExists(variables, "str_priority") OR NOT len(variables.str_priority)>
                                selected="selected"
                            </cfif>
                        >
                            Select Priority
                        </option>
                    
                        <!-- Populate priority options -->
                        <option value="low" 
                            <cfif structKeyExists(variables, "str_priority") AND variables.str_priority EQ "low">
                                selected="selected"
                            </cfif>
                        >Low</option>
                    
                        <option value="medium" 
                            <cfif structKeyExists(variables, "str_priority") AND variables.str_priority EQ "medium">
                                selected="selected"
                            </cfif>
                        >Medium</option>
                    
                        <option value="high" 
                            <cfif structKeyExists(variables, "str_priority") AND variables.str_priority EQ "high">
                                selected="selected"
                            </cfif>
                        >High</option>
                    </select>
                    
                </div>
                
            </div>
        
            <div class="mb-3 row">
                <div class="col-sm-10 offset-sm-2 d-flex justify-content-end">
                    <button type="reset" class="btn btn-secondary me-2">Reset</button>
                    <button type="submit" class="btn btn-primary">Save Event</button>
                </div>
            </div>
        </form>
        
        </main>
        <cfinclude template="../footer.cfm">
    </body>
    </html>
    </cfoutput>
    