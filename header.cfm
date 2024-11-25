<link rel="stylesheet" href="styles.css">
<nav class="navbar navbar-expand-lg navbar-dark bg-secondary">
    <div class="container-fluid">
        <a class="navbar-brand" href="index.html"><b>Address Book</b></a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto align-items-center">
                <li class="nav-item">
                    <a class="nav-link" href="#">Family</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Friends</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Colleagues</a>
                </li>
                <li class="nav-item">
                    <form class="d-inline-block">
                        <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search">
                    </form>
                </li>
                <li class="nav-item">
                    <a class="nav-link p-0" href="jitty.html">
                        <img src="images/contacts.jpg" alt="Profile" class="profile">
                    </a>
                </li>
                <form action="logout.cfm" method="post" class="d-inline">
                    <i class="bi bi-box-arrow-right"></i>
                </form>
            </ul>
        </div>
    </div>
</nav>