<cfset datasource="dsn_address_book">
<cfset currentDate = Now()>

<cfquery name="getEvents" datasource="#datasource#">
    SELECT 
        int_event_id, 
        str_event_title, 
        str_description, 
        dt_event_date, 
        str_reminder_email, 
        str_priority, 
        dt_start_time, 
        dt_end_time, 
        bit_mail_sent 
    FROM tbl_events
    WHERE dt_event_date = DATE_ADD(CURDATE(), INTERVAL 1 DAY)
    AND bit_mail_sent = 0 <!--- Check if mail has not been sent --->
    ORDER BY dt_event_date
</cfquery>
<cfloop query="getEvents">
    <!--- Set formatted times inside the loop for each event --->
    <cfset formattedStartTime = timeFormat(getEvents.dt_start_time, "HH:mm:ss")>
    <cfset formattedEndTime = timeFormat(getEvents.dt_end_time, "HH:mm:ss")>

    <!--- Send the email --->
    <cftry>
        <cfmail 
            from="jitty.abraham@techversantinfotech.com" 
            to="#getEvents.str_reminder_email#" 
            subject="Reminder: Upcoming Event - #getEvents.str_event_title#">
            This is a reminder for your upcoming event titled "#getEvents.str_event_title#".<br><br>
            Description: #getEvents.str_description#<br>
            Priority: #getEvents.str_priority#<br>
            Start Time: #formattedStartTime#<br>
            End Time: #formattedEndTime#<br>
        </cfmail>

        <!--- Update the bit_mail_sent to 1 after sending the email --->
        <cfquery name="updateMailSent" datasource="#datasource#">
            UPDATE tbl_events 
            SET bit_mail_sent = 1 
            WHERE int_event_id = <cfqueryparam value="#getEvents.int_event_id#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfcatch type="any">
            <!--- Log the email sending attempt as failed --->
            <cfquery name="logEmailFailure" datasource="#datasource#">
                INSERT INTO tbl_email_log (int_event_id, str_recipient_email, str_subject, str_status, dt_sent)
                VALUES (
                    <cfqueryparam value="#getEvents.int_event_id#" cfsqltype="cf_sql_integer">,
                    <cfqueryparam value="#getEvents.str_reminder_email#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="Reminder: Upcoming Event - #getEvents.str_event_title#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="failed" cfsqltype="cf_sql_varchar">,
                    NOW()
                )
            </cfquery>
        </cfcatch>
    </cftry>
</cfloop>