component persistent="true" table="tbl_events" {

    // Primary key
    property name="int_event_id" fieldtype="id" generator="identity";

    // Basic event properties
    property name="str_event_title" ormtype="string" length="255" required="true";
    property name="str_description" ormtype="text" required="false";
    property name="dt_event_date" ormtype="date" required="true";

    property name="str_reminder_email" ormtype="string" length="255" required="false";
    property name="str_priority" ormtype="string" length="50" required="false";
    property name="str_recurring" ormtype="string" length="50" required="false";
    property name="str_time_constraint" ormtype="string" length="50" required="false";
    property name="int_recurring_duration" ormtype="integer" required="false";
    property name="dt_start_time" ormtype="timestamp" required="false";
    property name="dt_end_time" ormtype="timestamp" required="false";

    // Constructor (optional, as ColdFusion calls init automatically)
    public function init() {
        // Optional logic or initialization can go here
    }

    // Helper methods
    public array function generateRecurringDates(required array selectedDays, required date startDate, required numeric duration, required string recurringType) {
        var dates = [];
        
        // Loop through based on the recurringType (monthly, weekly, daily)
        switch(recurringType) {
            case "monthly":
                for(var monthIndex = 0; monthIndex < duration; monthIndex++) {
                    var currentDate = dateAdd("m", monthIndex, startDate);
                    var currentMonth = month(currentDate);
                    var currentYear = year(currentDate);
                    
                    for(var day in selectedDays) {
                        try {
                            var eventDate = createDate(currentYear, currentMonth, day);
                            arrayAppend(dates, eventDate);
                        } catch(any e) {
                            // Skip invalid dates (e.g., Feb 31)
                            continue;
                        }
                    }
                }
                break;
                
            case "weekly":
                for(var weekIndex = 0; weekIndex < duration; weekIndex++) {
                    for(var day in selectedDays) {
                        var eventDate = dateAdd("ww", weekIndex, startDate);
                        // Adjust to the correct day of week
                        eventDate = dateAdd("d", day - dayOfWeek(eventDate), eventDate);
                        arrayAppend(dates, eventDate);
                    }
                }
                break;
                
            case "daily":
                for(var dayIndex = 0; dayIndex < duration; dayIndex++) {
                    var eventDate = dateAdd("d", dayIndex, startDate);
                    arrayAppend(dates, eventDate);
                }
                break;
        }
        
        return dates;
    }
    public string function getDays_of_week() {
        if (!structKeyExists(variables, "days_of_week")) {
            return "";
        }
        return variables.days_of_week;
    }

    public string function getDays_of_month() {
        if (!structKeyExists(variables, "days_of_month")) {
            return "";
        }
        return variables.days_of_month;
    }

    public string function getStr_event_title() {
        return structKeyExists(variables, "str_event_title") ? variables.str_event_title : "";
    }

    public string function getStr_description() {
        return structKeyExists(variables, "str_description") ? variables.str_description : "";
    }

    public any function getDt_event_date() {
        return structKeyExists(variables, "dt_event_date") ? variables.dt_event_date: now();
    }

    public string function getStr_reminder_email() {
        return structKeyExists(variables, "str_reminder_email") ? variables.str_reminder_email : "";
    }

    public string function getStr_priority() {
        return structKeyExists(variables, "str_priority") ? variables.str_priority : "low";
    }

    public string function getStr_recurring() {
        return structKeyExists(variables, "str_recurring") ? variables.str_recurring : "none";
    }

    public string function getStr_time_constraint() {
        return structKeyExists(variables, "str_time_constraint") ? variables.str_time_constraint : "morning";
    }

    public numeric function getInt_recurring_duration() {
        return structKeyExists(variables, "int_recurring_duration") ? variables.int_recurring_duration : 1;
    }

    public any function getDt_start_time() {
        return structKeyExists(variables, "dt_start_time") ? variables.dt_start_time : createTime(0,0,0);
    }

    public any function getDt_end_time() {
        return structKeyExists(variables, "dt_end_time") ? variables.dt_end_time : createTime(23,59,59);
    }
}
