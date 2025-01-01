<cfinclude template="sendMailAction.cfm">
<cfoutput>
    <cftry>
        <cfif getEvents.recordCount GT 0>
            <cfloop query="getEvents">
                
                    <cftry>
                        <!--- Send the reminder email --->
                        <cfmail 
                            from="jitty.abraham@techversantinfotech.com" 
                            to="#getEvents.str_reminder_email#" 
                            subject="Reminder: Upcoming Event - #getEvents.str_event_title#" 
                            server="smtp.gmail.com"
                            port="587"
                            useTLS="yes">
                            This is a reminder for your upcoming event titled "#getEvents.str_event_title#".<br><br>
                            Description: #getEvents.str_description#<br>
                            Priority: #getEvents.str_priority#<br>
                            Start Time: #formattedStartTime#<br>
                            End Time: #formattedEndTime#<br>
                        </cfmail>

                        

                        <cfcatch type="any">
                            <p>Error sending email to #getEvents.str_reminder_email#: #cfcatch.message#</p> 
                        </cfcatch>
                    </cftry>
                
            </cfloop>
            <p>Reminder emails processed successfully!</p>
        <cfelse>
            <p>No upcoming events to send reminders for.</p>
        </cfif>

        <cfcatch type="any">
            <p>Error processing events: #cfcatch.message#</p>
            <p>Error detail: #cfcatch.detail#</p>
            <p>Error type: #cfcatch.type#</p>
        </cfcatch>
    </cftry>
</cfoutput>
