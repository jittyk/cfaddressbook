<cfif not structKeyExists(session, "int_user_id") or session.int_user_id EQ "" or session.int_user_id IS 0>
    <cflocation url="../cfAddressbook/login.cfm">
</cfif>
<cfset currentDate = now()>
<cfset variables.datasource = "dsn_address_book">
<cfset currentYear = year(now())>
<!-- Check if 'year' parameter exists in the form or URL, otherwise default to the current year -->
<cfset variables.selectedYear = structKeyExists(form, "year") ? form.year : currentYear>

<!-- Query the holidays table -->
<cfquery name="qryholidays" datasource="#variables.datasource#">
    SELECT 
        int_month, 
        int_day, 
        str_holiday_title
    FROM tbl_holidays
</cfquery>

<!-- Create an array to store holiday dates for the selected year -->
<cfset holidays = []>
<cfloop query="qryholidays">
    <!-- Now that variables.selectedYear is defined, we can safely use it -->
    <cfset variables.holidayDate = createDate(variables.selectedYear, qryholidays.int_month, qryholidays.int_day)>
    <cfset arrayAppend(holidays, variables.holidayDate)>
</cfloop>
<cfset selectedMonth = structKeyExists(form, "month") ? form.month : month(currentDate)>
<cfset firstDayOfMonth = createDate(variables.selectedYear, selectedMonth, 1)>
<cfset dayOfWeek = dayOfWeek(firstDayOfMonth)>
<cfset daysInMonth = daysInMonth(firstDayOfMonth)>
<cfset totalCells = 42>
<cfset filledCells = dayOfWeek + daysInMonth - 1>
<cfset emptyCells = totalCells - filledCells>

<!-- Query the events table for the selected month and year -->
<cfquery name="eventQuery" datasource="#variables.datasource#">
    SELECT 
    dt_event_date,
    str_event_title
    FROM tbl_events
    WHERE YEAR(dt_event_date) = #variables.selectedYear# 
      AND MONTH(dt_event_date) = #selectedMonth#
</cfquery>

<!-- Create an array to store event dates -->
<cfset eventDates = []>
<cfset datesData = []>

<cfloop query="eventQuery">
    <!-- Convert LocalDateTime to string and format as 'yyyy-mm-dd' -->
    <cfset formattedDate = dateFormat(eventQuery.dt_event_date.toString(), 'yyyy-mm-dd')>
    <cfset arrayAppend(eventDates, formattedDate)>
</cfloop>

<!-- Loop through each day of the month -->
<cfloop index="day" from="1" to="#daysInMonth#">
    <cfset selectedDate = createDate(variables.selectedYear, selectedMonth, day)>
    <cfset isToday = (
        day eq day(currentDate) 
        AND selectedMonth eq month(currentDate) 
        AND variables.selectedYear eq year(currentDate)
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
    
    <!-- Check if there is an event for this date -->
    <cfif arrayContains(eventDates, selectedDate)>
        <cfset hasEvent = true>
    </cfif>

    <!-- Append the day's data to the datesData array, including the hasEvent flag -->
    <cfset arrayAppend(datesData, { 
        "day" = day, 
        "isToday" = isToday, 
        "isHoliday" = isHoliday, 
        "hasEvent" = hasEvent, 
        "selectedDate" = selectedDate 
    })>
</cfloop>
