 AddressBook Project - ColdFusion

This is an AddressBook web application built using ColdFusion. The app allows users to manage and store contact details, including name, phone number, email, and other relevant information.

 Features

- Add New Contact: Users can add new contacts with personal details such as name, phone, email, and address.
- View Contacts: A contact list with search functionality.
- Edit Contact: Update existing contact information.
- Delete Contact: Remove a contact from the address book.
- User Management: Admin panel for managing users and roles.
- Responsive: The application is built to be responsive for mobile and desktop views.

 Technologies Used

- ColdFusion for the backend logic.
- MySQL for storing contact and user data.
- HTML/CSS for the front end, with a focus on clean, responsive design.
- JavaScript/jQuery for client-side interactivity.

 Installation

 Prerequisites

- ColdFusion installed on your machine.
- MySQL or MariaDB for database storage.

Steps

1. Clone this repository to your local machine:
    bash
    git clone https://github.com/yourusername/cfaddressbook.git
    

2. Navigate to your ColdFusion server's web root directory (e.g., `E:\cfusion\wwwroot\`).

3. Copy the AddressBook project files into your web root folder.

4. Set up the MySQL database:
   - Create a new database called `addressbook`.
   - Create the required tables based on the provided schema (see below).

5. Database Schema

    sql:
    CREATE TABLE `contacts` (
      `intContactId` INT AUTO_INCREMENT PRIMARY KEY,
      `strFirstName` VARCHAR(255) NOT NULL,
      `strLastName` VARCHAR(255) NOT NULL,
      `contact` VARCHAR(20) NOT NULL,
      `email` VARCHAR(255),
      `qualification` VARCHAR(255),
      `country` VARCHAR(255),
      `city` VARCHAR(255),
      `state` VARCHAR(255),
      `address` VARCHAR(255),
      `pincode` VARCHAR(20),
      `gender` VARCHAR(20),
      `languages` TEXT
    );
    

6. Configure ColdFusion Data Source:
   - Ensure you set up a data source in ColdFusion Admin (dsn_address_book).
   - Point your project to this data source by updating the configuration file in the project.

7. Run the Application:
   - Open the application in your browser by navigating to:
     
     http://localhost/Addressbook/
    

 Usage

- Adding a Contact: Fill in the contact details in the "Add Contact" form and click "Submit".
- Editing a Contact: Click the "Edit" button next to a contact to update their information.
- Deleting a Contact: Click the "Delete" button to remove a contact from the list.
- Search: Use the search bar to quickly find contacts by name or phone number.

 Contributing

We welcome contributions! If you have suggestions for improvements or want to fix bugs, feel free to fork this project, make your changes, and submit a pull request.

 How to Contribute

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Commit your changes (`git commit -am 'Add feature'`).
4. Push to the branch (`git push origin feature-branch`).
5. Create a pull request.

 License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

 Acknowledgments

- ColdFusion for the server-side processing.
- MySQL for the database backend.
- jQuery for client-side interactivity.

