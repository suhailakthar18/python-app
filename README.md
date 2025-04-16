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
- **jenkins**: created a CICD Pipeline using jenkins

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

  If you encounter a problem while restarting the compose run this 
  ```bash
    docker-compose down --volumes --remove-orphans
    docker-compose up --build 
  ```
  Avoid This If You Want Persistence

        docker-compose down --volumes  

        
Use docker compose down -v only if you want to remove everything, including volumes.    
If you just want to stop the services without data loss, use:


          docker compose stop
          or
          docker compose down --volumes=false

## Jenkins

  Installed jenkins.It works on port 8080,Added jenkins to ubuntu and docker group

## 🔧 Step 1: Install Jenkins

```bash
sudo apt update
sudo apt install openjdk-11-jdk -y
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install jenkins -y

✔️ Start and Enable Jenkins

sudo systemctl start jenkins
sudo systemctl enable jenkins

🌐 Access Jenkins
Open your browser:
http://<your-server-ip>:8080

Get the initial password:
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

🐳 Step 2: Install Docker and Docker Compose

sudo apt install docker.io -y
sudo apt install docker-compose -y

👤 Step 3: Add Jenkins to Docker Group

sudo usermod -aG docker jenkins
sudo usermod -aG docker $USER
sudo usermod -aG ubuntu jenkins
sudo systemctl restart jenkins
🔁 You may need to reboot your system or log out/log in to apply group changes.

🔌 Step 4: Install Required Jenkins Plugins
From Jenkins dashboard:

Go to: Manage Jenkins → Manage Plugins → Install the following plugins:

Git Plugin

Docker Pipeline

Docker Commons

Docker API

Pipeline

Pipeline: Stage View

Blue Ocean (optional, for UI)

Credentials Binding Plugin

🔑 Step 5: Create Docker Hub Credentials in Jenkins
Go to: Manage Jenkins → Credentials → (global) → Add Credentials

Kind: Username and password

Username: Your Docker Hub username

Password: Your Docker Hub password

ID: dockerhub-credentials

Description: Docker Hub login for pipeline


## Conclusion

This README provides an overview of the Railway Project, along with instructions on setting up, verifying, and troubleshooting the application and database. By following the steps outlined, you should be able to run the project successfully, manage the database, and verify user and booking data.
