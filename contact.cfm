<cfinclude template="contactLogic.cfm">
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Contacts with Pagination</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            .contact-details {
            display: none;
            }
            .contact-name {
            cursor: pointer;
            color: #5f0606;
            }
            .contact-name:hover {
            color: #220303;
            }
        </style>
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-dark bg-secondary">
            <div class="container-fluid">
                <a class="navbar-brand" href="user.cfm"><b>Address Book</b></a>
                <a class="nav-link text-white">Hello <cfoutput>#session.str_user_name#</cfoutput></a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto align-items-center">
                        <li class="nav-item"><a class="nav-link" href="#">Family</a></li>
                        <li class="nav-item"><a class="nav-link" href="#">Friends</a></li>
                        <li class="nav-item"><a class="nav-link" href="#">Colleagues</a></li>
                        <li class="nav-item">
                            <form class="d-inline-block" method="get" action="user.cfm">
                                <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search" name="searchTerm">
                            </form>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link p-0" href="userprofile.cfm">
                                <img src="images\contacts.jpg" alt="Profile" class="rounded-circle" style="width: 40px; height: 40px; margin-left: 6px;">
                            </a>
                        </li>
                        <!-- Logout button with icon -->
                        <li class="nav-item">
                            <a class="nav-link text-white d-flex align-items-center" href="userlogout.cfm">
                                <i class="bi bi-box-arrow-right icon-white"></i> 
                                <span class="ms-2">Logout</span>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>
        <div class="container mt-4">
            <h2 class="mb-4">Contact List</h2>
            <cfparam name="url.toggleId" default="0">
            <cfset toggleId = url.toggleId>
            <table class="table table-bordered">
                <thead class="table-light">
                    <tr>
                        <th>Name</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput query="getContacts">
                        <tr>
                            <td>
                               
                                <cfif listFind(session.permissionList, 1)>
                                    <a href="contactDetails.cfm?int_contact_id=#int_contact_id#" class="contact-name" style="text-decoration: none;">
                                        #str_first_name# #str_last_name#
                                    </a>
                                  
                                <cfelse>  #str_first_name# #str_last_name#
                                </cfif>
                                
                            </td>
                            <!-- Edit and Delete Links -->
                            <td>
                               

                                <cfif listFind(session.permissionList, 2)>
                                    <a href="editcontact.cfm?int_contact_id=#int_contact_id#" class="btn btn-warning btn-sm">Edit</a>
                                </cfif>
                                <cfif listFind(session.permissionList, 3)>
                                    <a href="deleteContact.cfm?int_contact_id=#int_contact_id#" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this contact?')">Delete</a>
                                </cfif>
                               
                                
                                
                            </td>
                        </tr>
                    </cfoutput>
                </tbody>
            </table>
            <!-- Pagination -->
            <nav>
                <ul class="pagination justify-content-center">
                    <cfif page gt 1>
                        <li class="page-item">
                            <cfoutput><a class="page-link" href="contact.cfm?page=#page - 1#">Previous</a></cfoutput>
                        </li>
                    </cfif>
                    <cfloop from="1" to="#totalPages#" index="i">
                        <li class="page-item <cfif i eq page>active</cfif>">
                            <cfoutput><a class="page-link" href="contact.cfm?page=#i#">#i#</a></cfoutput>
                        </li>
                    </cfloop>
                    <cfif page lt totalPages>
                        <li class="page-item">
                            <cfoutput><a class="page-link" href="contact.cfm?page=#page + 1#">Next</a></cfoutput>
                        </li>
                    </cfif>
                </ul>
            </nav>
        </div>
        <footer class="mt-auto bg-dark text-white py-3">
            <div class="container">
                <div class="row">
                    <div class="col-12 mb-3">
                        <ul class="list-unstyled d-flex flex-column flex-md-row justify-content-center mb-0">
                            <li class="me-md-3 mb-2 mb-md-0"><a href="#" class="text-white text-decoration-none">Family</a></li>
                            <li class="me-md-3 mb-2 mb-md-0"><a href="#" class="text-white text-decoration-none">Friends</a></li>
                            <li><a href="#" class="text-white text-decoration-none">Colleagues</a></li>
                        </ul>
                    </div>
                    <div class="col-12 mb-3 d-flex justify-content-center">
                        <div class="col-10 col-md-6 col-lg-4">
                            <form method="get" action="index.cfm">
                                <input type="search" class="form-control" placeholder="Search" name="searchTerm">
                            </form>
                        </div>
                    </div>
                    <div class="col-12 text-center text-md-end">
                        <a class="navbar-brand" href="user.cfm"><b>Address Book</b></a>
                    </div>
                </div>
            </div>
        </footer>
    </body>
</html>
