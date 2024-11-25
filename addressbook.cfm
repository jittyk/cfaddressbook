<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Address Book</title>
</head>
<body>

<h1>Address Book</h1>

<!--- Pagination code starts here --->
<cfparam name="login.page" default="1"> <!--- Get the current page from URL or default to 1 --->

<!--- Number of records per page --->
<cfset recordsPerPage = 10>

<!--- Calculate the offset --->  
<cfset offset = (url.page - 1) * recordsPerPage>

<!--- Query to get the total number of contacts --->  
<cfquery name="getTotalContacts" datasource="dsn_address_book">
    SELECT COUNT(*) AS total
    FROM contacts
</cfquery>

<!--- Calculate the total number of pages --->  
<cfset totalPages = ceil(getTotalContacts.total / recordsPerPage)>

<!--- Query to get the contacts for the current page --->  
<cfquery name="getContacts" datasource="dsn_address_book">
    SELECT *
    FROM contacts
    LIMIT #offset#, #recordsPerPage#
</cfquery>

<!--- Display the contacts --->  
<cfoutput query="getContacts">
    <div>
        <p>#strFirstName# #strLastName#</p>
        <p>#email#</p>
        <p>#contact#</p>
    </div>
</cfoutput>

<!--- Display pagination controls --->  
<div>
    <cfif url.page GT 1>
        <a href="?page=#url.page - 1#">Previous</a>
    </cfif>

    <span>Page #url.page# of #totalPages#</span>

    <cfif url.page LT totalPages>
        <a href="?page=#url.page + 1#">Next</a>
    </cfif>
</div>
<!--- Pagination code ends here --->

</body>
</html>
