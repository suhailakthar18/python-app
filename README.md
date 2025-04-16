# Railway Project

## Overview

The Railway Project is a simple application designed to manage railway bookings, with functionalities like user registration, login, and password reset. This project aims to demonstrate the use of Docker, Docker Compose, and other relevant technologies for containerizing and deploying the application.

## Features

- **User Management**:  
  - User registration and login functionality.
  - Password reset functionality.
  
- **HTML Templates**:  
  The project includes the following HTML templates for the frontend:
  - `index.html`: The homepage of the application.
  - `login.html`: Login page for user authentication.
  - `register.html`: Registration page for new users.
  - `reset_password.html`: Page for users to reset their password.

## Technologies Used

- **Python**: The backend of the project is built with Python.
- **Flask**: For creating web routes and serving HTML templates.
- **Docker**: Containerization of the application using Docker.
- **Docker Compose**: Used to manage multi-container Docker applications.
- **SQL**: The project utilizes an SQL database for storing user data (e.g., login information).
- **HTML**: Frontend pages are created using HTML.

## Project Setup

### Clone the Repository

To get started, clone the repository to your local machine:

```bash
git clone https://github.com/your-username/railway_project.git
cd railway_project
```

### Requirements

Ensure you have the following tools installed:
- Docker
- Docker Compose

To install Docker on Ubuntu:

```bash
sudo apt install docker.io
sudo usermod -aG docker $$USER && newgrp docker
```

To install Docker Compose on Ubuntu:

```bash
sudo apt install docker-compose
```

### File Structure

```plaintext
railway_project/
├── Dockerfile
├── app.py
├── docker-compose.yaml
├── init.sql
├── railway.py
├── requirements.txt
└── templates/
    ├── index.html
    ├── login.html
    ├── register.html
    └── reset_password.html
```

### Docker Setup

1. **Build the Docker Image**:  
   First, build the Docker image using the `Dockerfile`:

   ```bash
   docker build -t railway-project .
   ```

2. **Run with Docker Compose**:  
   Use Docker Compose to start the application and the required services:

   ```bash
   docker-compose up --build
   ```

3. **Access the Application**:  
   After starting the application with Docker Compose, you can access it via `http://localhost:5000`.

## Database Configuration and Verification

### Database Setup

The project uses MySQL as the database to store user credentials and booking details. The database is initialized using an SQL script (`init.sql`) to create the necessary tables.

The `init.sql` file is executed automatically when you run the MySQL container via Docker Compose, ensuring that the database and tables are created.

### How to Verify and Check Database Entries

1. **Access MySQL from a Container**:
   To verify and check the entries in the database, you can connect to the MySQL container directly.

   - First, list the running containers:

     ```bash
     docker ps
     ```

   - Get the container ID or name for the MySQL container (in the `docker-compose.yml`, the container name is usually `db`).
   
   - Enter the MySQL container:

     ```bash
     docker exec -it <container_name_or_id> bash
     ```

   - Once inside the container, log in to MySQL:

     ```bash
     mysql -u root -p
     ```

   - Enter the MySQL root password (`yourpassword` in this case) when prompted.

2. **Verify Database**:
   - Select the database:

     ```sql
     USE railway_system;
     ```

   - Check the `users` table to see if the entries exist:

     ```sql
     SELECT * FROM users;
     ```

   - Check the `bookings` table to see if any booking records exist:

     ```sql
     SELECT * FROM bookings;
     ```

3. **Check Specific User or Booking**:
   - To check if a specific user exists:

     ```sql
     SELECT * FROM users WHERE username='Suhail';
     ```

   - To check bookings made by a user:

     ```sql
     SELECT * FROM bookings WHERE username='Suhail';
     ```

4. **Exit MySQL and the Container**:
   - To exit MySQL:

     ```sql
     exit;
     ```

   - To exit the container:

     ```bash
     exit;
     ```

### Troubleshooting Database Issues

- If you encounter issues with the database not being created or tables not being initialized, ensure that:
  - The `init.sql` script is executed when the container is started.
  - There are no errors in the MySQL container logs related to database creation.

You can view logs with the following command:

```bash
docker logs <container_name_or_id>
```

## Troubleshooting and FAQ

  To ensure that data is not lost when you restart the container, you need to use Docker volumes. You can define a volume in the `docker-compose.yml` file under the `db` service like this:

     ```yaml
     volumes:
       - mysql_data:/var/lib/mysql
     ```

     This will persist the database data even after the container is stopped or removed.

3. **Why can't I access the `/booking` page without logging in?**
   - The `/booking` page is protected by a login check. If you are accessing it without being logged in, it should redirect you to the login page. If this isn't happening, make sure the session management is working correctly, and check the login logic in the `app.py`.

## Conclusion

This README provides an overview of the Railway Project, along with instructions on setting up, verifying, and troubleshooting the application and database. By following the steps outlined, you should be able to run the project successfully, manage the database, and verify user and booking data.
```

This `README.md` file provides complete information about setting up the Railway Project, managing the database, and checking entries. It should serve as a comprehensive guide for anyone working with the project.
