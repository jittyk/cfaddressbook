<!-- Ensure the user is logged in -->
<cfif not structKeyExists(session, "int_user_id") or session.int_user_id EQ "" or session.int_user_id IS 0>
    <cflocation url="../cfAddressbook/login.cfm">
</cfif>

<cfset currentDate = now()>
<cfset variables.datasource = "dsn_address_book">
<cfset currentYear = year(currentDate)>
<cfset selectedYear = structKeyExists(form, "year") ? form.year : currentYear>
<cfset selectedMonth = structKeyExists(form, "month") ? form.month : month(currentDate)>
<cfset firstDayOfMonth = createDate(selectedYear, selectedMonth, 1)>
<cfset daysInMonth = daysInMonth(firstDayOfMonth)>
<cfset totalCells = 42>
<cfset dayOfWeek = dayOfWeek(firstDayOfMonth)>
<cfset filledCells = dayOfWeek + daysInMonth - 1>
<cfset emptyCells = totalCells - filledCells>

<!-- Query the holidays -->
<cfquery name="qryHolidays" datasource="#variables.datasource#">
    SELECT 
        int_month, 
        int_day, 
        str_holiday_title
    FROM tbl_holidays
</cfquery>

<!-- Create an array for holiday dates -->
<cfset holidays = []>
<cfloop query="qryHolidays">
    <cfset arrayAppend(holidays, createDate(selectedYear, qryHolidays.int_month, qryHolidays.int_day))>
</cfloop>

<!-- Query the events -->
<cfquery name="qryEvents" datasource="#variables.datasource#">
    SELECT 
        dt_event_date,
        str_event_title,
        str_recurrence_type,
        days_of_month,
        days_of_week,
        days_of_month,
        int_recurring_duration
    FROM tbl_events
</cfquery>

<!-- Create an array for event dates -->
<cfset eventDates = []>
<cfloop query="qryEvents">
    <cfset arrayAppend(eventDates, qryEvents.dt_event_date)>
</cfloop>

<!-- Process the calendar data -->
<cfset datesData = []>
<cfloop index="day" from="1" to="#daysInMonth#">
    <cfset selectedDate = createDate(variables.selectedYear, selectedMonth, day)>
    <cfset isToday = (
        day eq day(now()) 
        AND selectedMonth eq month(now()) 
        AND variables.selectedYear eq year(now())
    )>
    <cfset isHoliday = false>
    <cfset hasEvent = false>
    
    <!-- Check if the current day is a holiday from the database -->
    <cfif arrayContains(holidays, selectedDate)>
        <cfset isHoliday = true>
    </cfif>
    
    <!-- Mark Sundays as holidays -->
    <cfif dayOfWeek(selectedDate) eq 1>
        <cfset isHoliday = true>
    </cfif>
    
    <!-- Mark the second Saturday as a holiday -->
    <cfif dayOfWeek(selectedDate) eq 7 AND (int((day - 1) / 7) eq 1 or int((day-1) / 7) eq 3)>
        <cfset isHoliday = true>
    </cfif>
    
    <!-- Check for daily recurring events -->
    <cfloop query="qryEvents">
        <!-- DAILY RECURRING EVENTS -->
        <cfif qryEvents.str_recurrence_type EQ "daily">
            <cfif selectedDate GTE qryEvents.dt_event_date AND 
                selectedDate LTE dateAdd("d", qryEvents.int_recurring_duration, qryEvents.dt_event_date)>
                <cfset hasEvent = true>
                <cfbreak>
            </cfif>
        </cfif>

        <cfif qryEvents.str_recurrence_type EQ "weekly">
            <!-- Calculate the end date based on the recurrence duration in months -->
            <cfset endDate = dateAdd("m", qryEvents.int_recurring_duration, qryEvents.dt_event_date)>

            <!-- Loop through weeks from start date to end date -->
            <cfset currentDate = qryEvents.dt_event_date>

            <!-- Convert comma-separated days_of_week string to an array -->
            <cfset selectedDays = listToArray(qryEvents.days_of_week)> <!-- Convert days_of_week to an array -->
            
            <!-- Repeat weekly -->
            <cfloop condition="currentDate LTE endDate">
                <cfset currentDay = dayOfWeekName(currentDate)>
                <!-- Check if the current day of the week is one of the selected days -->
                <cfif listFind(selectedDays, currentDay)>
                    <!-- Check if the selected date matches the current date in the recurrence cycle -->
                    <cfif selectedDate EQ currentDate>
                        <cfset hasEvent = true>
                        <cfbreak>
                    </cfif>
                </cfif>
                
                <!-- Move to next week (same days of the week) -->
                <cfset currentDate = dateAdd("d", 7, currentDate)>
            </cfloop>
        </cfif>

        <!-- MONTHLY RECURRING EVENTS -->
        <cfif qryEvents.str_recurrence_type EQ "monthly">
            <!-- Calculate the end date based on the recurrence duration in months -->
            <cfset endDate = dateAdd("m", qryEvents.int_recurring_duration, qryEvents.dt_event_date)>

            <!-- Initialize the starting date -->
            <cfset currentDate = qryEvents.dt_event_date>
            <!-- Convert comma-separated days_of_month string to an array -->
            <cfset selectedDates = listToArray(qryEvents.days_of_month)> 
            <!-- Check if selectedDates is an array -->
            <cfif isArray(selectedDates)>
                <!-- Loop through months from start date to end date -->
                <cfloop condition="currentDate LTE endDate">
                    <!-- Get the day of the month -->
                    <cfset currentDay = day(currentDate)> <!-- Get the day of the month -->

                    <!-- Check if the current day of the month is in the selected dates -->
                    <cfif listFind(selectedDates, currentDate)>
                        <!-- Check if the selected date matches the current date in the recurrence cycle -->
                        <cfif selectedDate EQ currentDate>
                            <cfset hasEvent = true>
                            <cfbreak>
                        </cfif>
                    </cfif>

                    <!-- Move to next month -->
                    <cfset currentDate = dateAdd("m", 1, currentDate)>
                </cfloop>
            <cfelse>
                <!-- Handle error if selectedDates is not an array -->
                <cfset hasEvent = false>
            </cfif>
        </cfif>




    </cfloop>

    <!-- Check if the current date matches any event date -->
    <cfif arrayContains(eventDates, dateFormat(selectedDate, "yyyy-mm-dd"))>
        <cfset hasEvent = true>
    </cfif>

    <!-- Append the day's data -->
    <cfset arrayAppend(datesData, { 
        "day" = day, 
        "isToday" = isToday, 
        "isHoliday" = isHoliday, 
        "hasEvent" = hasEvent, 
        "selectedDate" = selectedDate 
    })>
</cfloop>
