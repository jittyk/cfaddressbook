<cfinclude template="loginAction.cfm">
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Login - Address Book</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="styles/login.css">
   
</head>
<body>
    <!-- User Login Validation (Non-Admin) -->
    
    
    <nav class="navbar navbar-expand-lg navbar-dark bg-secondary">
        <div class="container-fluid">
            <a class="navbar-brand" href="user.cfm"><b>Address Book</b></a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse d-flex justify-content-end" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link" href="#">Family</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Friends</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Colleagues</a></li>
                    <li class="nav-item">
                        <form class="form-inline" method="get" action="user.cfm">
                            <input class="form-control mr-sm-2" type="search" placeholder="Search" aria-label="Search" name="searchTerm">
                        </form>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link p-0" href="userprofile.cfm">
                            <img src="images/contacts.jpg" alt="Profile" class="rounded-circle" style="width: 40px; height: 40px; margin-left: 6px;">
                        </a>
                    </li>
                    
                </ul>
            </div>
        </div>
    </nav>

    
        <cfif structKeyExists(session, "loginError") AND len(trim(session.loginError)) GT 0>
            <cfoutput><div class="danger text-center">#session.loginError#</div></cfoutput>
            <cfset session.loginError = "" /> <!-- Clear error message after displaying -->
        </cfif>
        <div class="log-container ">
        <div class="login-container">
            <h1>User Login</h1>

            <!-- Display error message if login failed -->
            
            <form action="login.cfm" method="post">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" required>
                <br>
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required>
                <br>
                <button type="submit" name="submit">Login</button>

                <div class="links">
                    <a href="forgotPassword.cfm">Forgot Password?</a> &nbsp
                    <a href="signup.cfm">Sign Up</a>
                </div>
            </form>
        </div>
        
    </div>
    <div class="log-container d-flex justify-content-center align-items-center ">
        <a href="adminLogin.cfm"><button style="margin-bottom:5px;">Login as Admin</button></a>
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
