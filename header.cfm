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
        <nav class="navbar navbar-expand-lg navbar-dark bg-secondary">
            <div class="container-fluid">
               <a class="navbar-brand" href="user.cfm"><b>Address Book</b></a>
               <a class="nav-link text-white">Hello <cfoutput>#session.str_user_name#</cfoutput></a>
               <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                  <span class="navbar-toggler-icon"></span>
               </button>
               <div class="collapse navbar-collapse" id="navbarNav">
                  <ul class="navbar-nav ms-auto align-items-center">
                     <li class="nav-item"><a class="nav-link" href="../cfCalendar/index.cfm">Calendar</a></li>
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
         
        </body>
    </html>
    