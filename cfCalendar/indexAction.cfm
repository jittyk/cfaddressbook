<!-- Get the current date -->
<cfset currentDate = now()>
<cfset variables.datasource = "dsn_address_book">
<cfset currentYear = year(now())>

<!-- Check if 'year' parameter exists in the form or URL, otherwise default to the current year -->
<cfset selectedYear = structKeyExists(form, "year") ? form.year : currentYear>

<!-- Query the holidays table -->
<cfquery name="holidayQuery" datasource="#variables.datasource#">
    SELECT 
        intMonth, 
        intDay, 
        strDescription
    FROM tbl_holidays
</cfquery>

<!-- Create an array to store holiday dates for the selected year -->
<cfset holidays = []>
<cfloop query="holidayQuery">
    <!-- Now that selectedYear is defined, we can safely use it -->
    <cfset holidayDate = createDate(selectedYear, holidayQuery.intMonth, holidayQuery.intDay)>
    <cfset arrayAppend(holidays, holidayDate)>
</cfloop>

<!-- Initialize other variables and perform additional operations here -->
<!-- Check if 'date' parameter exists in the URL, and if it does, set formattedDate -->



<!-- Initialize variables for calendar creation -->
<cfset selectedMonth = structKeyExists(form, "month") ? form.month : month(currentDate)>
<cfset firstDayOfMonth = createDate(selectedYear, selectedMonth, 1)>
<cfset dayOfWeek = dayOfWeek(firstDayOfMonth)>
<cfset daysInMonth = daysInMonth(firstDayOfMonth)>
<cfset totalCells = 42>
<cfset filledCells = dayOfWeek + daysInMonth - 1>
<cfset emptyCells = totalCells - filledCells>

<!-- Initialize an array to store calendar data -->
<cfset datesData = []>

<!-- Loop through each day of the month -->
<cfloop index="day" from="1" to="#daysInMonth#">
    <cfset selectedDate = createDate(selectedYear, selectedMonth, day)>
    <cfset isToday = (
        day eq day(currentDate) 
        AND selectedMonth eq month(currentDate) 
        AND selectedYear eq year(currentDate)
    )>
    <cfset isHoliday = false>
    
    <!-- Check if the current day is a holiday from the database -->
    <cfif arrayContains(holidays, selectedDate)>
        <cfset isHoliday = true>
    </cfif>
    
    <!-- Mark Sundays as holidays -->
    <cfif dayOfWeek(selectedDate) eq 1>
        <cfset isHoliday = true>
    </cfif>
    
    <!-- Mark the second Saturday as a holiday -->
    <cfif dayOfWeek(selectedDate) eq 7 AND int((day - 1) / 7) eq 1>
        <cfset isHoliday = true>
    </cfif>
    
    <!-- Append the day's data to the datesData array -->
    <cfset arrayAppend(datesData, { 
        "day" = day, 
        "isToday" = isToday, 
        "isHoliday" = isHoliday, 
        "selectedDate" = selectedDate 
    })>
</cfloop>
