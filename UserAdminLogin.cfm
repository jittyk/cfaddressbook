<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Address Book</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
        <style>
            body {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            background-color: #f8f9fa;
            }
            .navbar {
            margin-bottom: 20px; /* Adds space below navbar */
            width:100%;
            }
            .footer {
            margin-top: auto; /* Pushes footer to the bottom */
            width:100%;
            }
            body {
            display: flex;
            justify-content: center;
            min-height: 100vh;
            margin: 0;
            background-color: #f8f9fa;
            }
            /* Ensures the container fills the viewport and centers content */
            .container {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 80vh;
            }
            .login-wrapper {
            width: 100%;
            max-width: 400px;
            perspective: 1000px; /* Enable 3D perspective */
            }
            .flip-container {
            position: relative;
            width: 100%;
            height: 350px; /* Adjust height for the forms */
            transform-style: preserve-3d;
            transition: transform 0.8s; /* Flip animation */
            }
            .flipped {
            transform: rotateY(180deg); /* Flip to the back side */
            }
            .login-container {
            width: 100%;
            height: 100%; /* Ensure container fills available height */
            text-align: center;
            padding: 20px;
            border: 1px solid #000000;
            border-radius: 8px;
            background: linear-gradient(to right, #0623a1, #53a9f5);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            color: white;
            backface-visibility: hidden; /* Hide the back side when flipped */
            position: absolute;
            top: 0;
            left: 0;
            }
            .admin-login {
            transform: rotateY(0deg); /* Front side */
            }
            .user-login {
            transform: rotateY(180deg); /* Back side */
            }
            input[type="email"], input[type="password"] {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 3px;
            }
            button {
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            }
            .toggle-container {
            position: relative;  /* Set container as relative to position buttons */
            text-align: center;
            margin-top: 20px;
            }
            .toggle-container button {
            position: absolute;  /* Absolute positioning to stack the buttons */
            top: 0;
            left: 50%;  /* Center horizontally */
            transform: translateX(-50%);  /* Center horizontally */
            opacity: 0;
            pointer-events: none;  /* Disable clicking on hidden button */
            z-index: 1;  /* Set the default button's z-index */
            }
            .toggle-container button.active {
            opacity: 1;
            pointer-events: auto;  /* Enable clicking on the visible button */
            z-index: 2;  /* Ensure the active button is on top */
            }
            .danger {
            color: red;
            display: none;
            }
        </style>
    </head>
    <body>
        <!-- Header: Navbar -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-secondary">
            <div class="container-fluid">
                <a class="navbar-brand" href="user.cfm"><b>Address Book</b></a>
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
                            <a class="nav-link p-0" href="jitty.cfm">
                            <img src="images/contacts.jpg" alt="Profile" class="rounded-circle" style="width: 40px; height: 40px; margin-left: 6px;">
                            </a>
                        </li>
                        <!-- Logout button with icon -->
                        <li class="nav-item">
                            <a class="nav-link text-white d-flex align-items-center" href="logout.cfm">
                            <i class="bi bi-box-arrow-right icon-white"></i> 
                            <span class="ms-2">Logout</span>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>
        <!-- Main content goes here -->
        <div class="container">
            <div class="login-wrapper">
                <!-- Flip container -->
                <div class="flip-container" id="flipContainer">
                    <!-- Admin Login Form (Front Side) -->
                    <div class="login-container admin-login">
                        <h1>Admin Login</h1>
                        <!-- Display error message if login failed -->
                        <div class="danger" id="adminError">Invalid login credentials or you do not have admin access.</div>
                        <form action="adminLogin.cfm" method="post">
                            <label for="adminEmail">Email:</label>
                            <input type="email" id="adminEmail" name="email" required>
                            <br>
                            <label for="adminPassword">Password:</label>
                            <input type="password" id="adminPassword" name="password" required>
                            <br>
                            <button type="submit" name="submit">Login as Admin</button>
                        </form>
                    </div>
                    <!-- User Login Form (Back Side) -->
                    <div class="login-container user-login">
                        <h1>User Login</h1>
                        <!-- Display error message if login failed -->
                        <div class="danger" id="userError">Invalid login credentials or you do not have user access.</div>
                        <form action="login.cfm" method="post">
                            <label for="userEmail">Email:</label>
                            <input type="email" id="userEmail" name="email" required>
                            <br>
                            <label for="userPassword">Password:</label>
                            <input type="password" id="userPassword" name="password" required>
                            <br>
                            <button type="submit" name="submit">Login as User</button>
                        </form>
                    </div>
                </div>
                <!-- Toggle Buttons outside of the flip container -->
                <div class="toggle-container col-12">
                    <button id="adminButton" class="active" onclick="showAdminLogin()">Admin Login</button>
                    <button id="userButton" onclick="showUserLogin()">User Login</button>
                </div>
            </div>
        </div>
        <!-- Footer -->
        <footer class="mt-auto bg-dark text-white py-3">
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
        </footer>
        <script>
            // JavaScript to toggle between Admin and User login by flipping and show only one button
            function showAdminLogin() {
                document.getElementById('flipContainer').classList.remove('flipped');
                document.getElementById('adminButton').classList.remove('active');
                document.getElementById('userButton').classList.add('active');
            }
            
            function showUserLogin() {
                document.getElementById('flipContainer').classList.add('flipped');
                document.getElementById('adminButton').classList.add('active');
                document.getElementById('userButton').classList.remove('active');
               
                
            }
            
            // Initially, hide the User Login button
            document.getElementById('adminButton').classList.remove('active');
            document.getElementById('userButton').classList.add('active');
        </script>
        <!-- Bootstrap JS and dependencies -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>