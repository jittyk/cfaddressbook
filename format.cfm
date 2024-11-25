
<!---Variable declaration--->
<cfset variables.strFirstName = ''>

<!---control block--->
<cfif structKeyExists(variables,"btnSubmit")>
    <cfset variables.strFirstName = form.strFirstName>

    <cfset variables.err_msg = validateFormValues(strFirstName=variables.strFirstName)>

    <cfif len(variables.err_msg) EQ 0>
        <cfset saveContacts(strFirstName=variables.strFirstName,strLastName=variables.strLastName)>
    </cfif>
</cfif>
<cfset  variables.qryEducationOptions = getEducationOptions()>
<cfset  variables.qryLocationOptions = getLocationOptions()>

<cffunction name="validateFormValues" returnType="string">
    <cfargument name="strFirstName" type="string">
    <cfset var err_msg = ''>

        <cfif len(arguments.strFirstName) EQ 0>
            <cfset err_msg &= 'Please enter First Name.'>
        </cfif>
    <cfreturn err_msg>
</cffunction>
<cffunction name="saveContacts" returnType="void">
    <cfargument name="strFirstName">
    <cfquery name="" datasource="">
    </cfquery>
</cffunction>

<!---display block--->
<form>
    <input type="text" name="strFirstName" id="strFirstName" value="#variables.strFirstName#">
    <select name="intEducationId" id="intEducationId">
        <option value="0">Choose Education</option>
        <cfloop query="variables.qryEducationOptions">
            <option value="#variables.qryEducationOptions.educationId#">#variables.qryEducationOptions.education#</option>
        </cfloop>
    </select>


    <select name="intLocationId" id="intLocationId">
        <option value="0">Choose Education</option>
        <cfloop query="variables.qryLocationOptions">
            <option value="#variables.qryLocationOptions.locationId#">#variables.qryLocationOptions.location#</option>
        </cfloop>
    </select>

    <input type="submit" name="btnSubmit" value="submit">
</form>