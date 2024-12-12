<cfinclude template="indexAction.cfm">
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Calendar</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
        <link rel="stylesheet" href="styles/index.css">
        <style>
           
        </style>
    </head>
    
   <body>
        <cfinclude template="../header.cfm">
        <cfoutput>
            <main class="container">
                <div class="calendar">
                    <div class="calendar-header">
                        <h1>Calendar</h1>
                        <form method="post" class="d-flex">
                            <select id="month" name="month" onchange="this.form.submit()">
                                <cfloop index="i" from="1" to="12">
                                    <option value="#i#" <cfif i eq selectedMonth>selected</cfif>>#monthAsString(i)#</option>
                                </cfloop>
                            </select>
                            <div class="year-navigation d-flex align-items-center ms-3">
                                <button type="submit" name="year" value="#selectedYear - 1#">&lt;&lt;</button>
                                <span class="mx-2"><b>#selectedYear#</b></span>
                                <button type="submit" name="year" value="#selectedYear + 1#">&gt;&gt;</button>
                            </div>
                        </form>
                    </div>
            
                    <div class="days">
                        <div>Sun</div><div>Mon</div><div>Tue</div><div>Wed</div><div>Thu</div><div>Fri</div><div>Sat</div>
                        
                        <!-- Empty leading spaces -->
                        <cfloop index="i" from="1" to="#dayOfWeek - 1#">
                            <div class="date-cell"></div>
                        </cfloop>
                        <cfloop array="#datesData#" index="date">
                            <form action="eventManager.cfm" method="post">
                                <!-- Hidden input to pass the selected date -->
                                <input type="hidden" name="date" value="#dateFormat(date.selectedDate, 'yyyy-mm-dd')#">
                                <button type="submit" 
                                        class="date-cell 
                                            <cfif date.isToday> text-primary</cfif>
                                            <cfif date.isHoliday> text-danger</cfif>
                                             <cfif date.hasEvent> bg-warning </cfif> 
                                        ">
                                    #date.day# 
                                </button>
                            </form>
                        </cfloop>
                        <cfloop index="j" from="1" to="#emptyCells#">
                            <div class="date-cell"></div>
                        </cfloop>
                    </div>
                </div>
                
            </main>
            </cfoutput>
            

         <cfinclude template="../footer.cfm">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
