
    <!DOCTYPE html>
    <html>
    <head>
        <title>Add Event</title>
    </head>
    <body>
        <cfinclude template="../header.cfm">
         <cfoutput>
        <main class="container">
        <h2>Add New Event</h2>
     
        <form method="post" action="addEventAction.cfm">
            <div class="mb-3">
                <label for="eventTitle" class="form-label">Event Title</label>
                <input type="text" class="form-control" id="eventTitle" name="str_event_title" required>
            </div>
            <div class="mb-3">
                <label for="eventDescription" class="form-label">Description</label>
                <textarea class="form-control" id="eventDescription" name="str_description" rows="3" required></textarea>
            </div>
            <div class="mb-3">
                <label for="dt_event_date" class="form-label">Event Date and Time</label>
                <input type="datetime-local" class="form-control" id="dt_event_date" name="dt_event_date" required>
            </div>
            <div class="mb-3">
                <label for="dt_reminder_time" class="form-label">Reminder Date and Time</label>
                <input type="datetime-local" class="form-control" id="dt_reminder_time" name="dt_reminder_time" required>
            </div>
            <div class="mb-3">
                <label for="str_priority" class="form-label">Frequency</label>
                <select class="form-control" id="str_priority" name="str_priority" required>
                    <option value="Low">Low</option>
                    <option value="Medium">Medium</option>
                    <option value="High">High</option>
                </select>
            </div>
            
            <div class="mb-3">
                <label for="eventReminderEmail" class="form-label">Reminder Email</label>
                <input type="email" class="form-control" id="eventReminderEmail" name="str_reminder_email" required>
            </div>
            <button type="submit" class="btn btn-primary">Save Event</button>
        </form>
        
        <cfdump var="#form#" abort>
        </main>
        <cfinclude template="../footer.cfm">
    </body>
    </html>
    </cfoutput>
    