from flask import Flask, render_template, request, redirect, session, url_for
from flask_mysqldb import MySQL
from werkzeug.security import generate_password_hash, check_password_hash
from railway import Railway

app = Flask(__name__)
app.secret_key = "your_secret_key"  # Change this to a secure key in production

# MySQL Configuration
app.config['MYSQL_HOST'] = 'db'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'yourpassword'
app.config['MYSQL_DB'] = 'railway_system'

mysql = MySQL(app)

@app.route("/")
def home_redirect():
    return redirect("/login")

@app.route("/register", methods=["GET", "POST"])
def register():
    message = ""
    if request.method == "POST":
        username = request.form["username"]
        password = request.form["password"]
        hashed_password = generate_password_hash(password)
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM users WHERE username=%s", (username,))
        if cur.fetchone():
            message = "User already exists!"
        else:
            cur.execute("INSERT INTO users (username, password) VALUES (%s, %s)", (username, hashed_password))
            mysql.connection.commit()
            message = "Registration successful!"
        cur.close()
    return render_template("register.html", message=message)

@app.route("/login", methods=["GET", "POST"])
def login():
    error = ""
    if request.method == "POST":
        username = request.form["username"]
        password = request.form["password"]
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM users WHERE username=%s", (username,))
        user = cur.fetchone()
        cur.close()
        if user and check_password_hash(user[2], password):
            session["user"] = user[1]  # Set the session after successful login
            return redirect("/booking")
        else:
            error = "Invalid credentials!"
    return render_template("login.html", error=error)

@app.route("/logout")
def logout():
    session.pop("user", None)
    return redirect("/login")

@app.route("/booking", methods=["GET", "POST"])
def booking():
    if "user" not in session:
        return redirect("/login")

    result = ""
    if request.method == "POST":
        train_no = request.form["train_no"]
        time = request.form["departure_time"]
        source = request.form["source"]
        destination = request.form["destination"]
        
        # ✅ FIXED: Passing mysql as the first argument
        railway = Railway(mysql, train_no, time, source, destination)

        action = request.form["action"]
        if action == "Book":
            result = railway.book()
        elif action == "Status":
            result = railway.status()
        elif action == "Fare":
            result = railway.fare()

    return render_template("index.html", result=result)

@app.route("/reset_password", methods=["GET", "POST"])
def reset_password():
    message = ""
    if request.method == "POST":
        username = request.form["username"]
        new_password = request.form["new_password"]
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM users WHERE username=%s", (username,))
        user = cur.fetchone()
        if user:
            hashed_password = generate_password_hash(new_password)
            cur.execute("UPDATE users SET password=%s WHERE username=%s", (hashed_password, username))
            mysql.connection.commit()
            message = "Password updated successfully!"
        else:
            message = "User does not exist."
        cur.close()
    return render_template("reset_password.html", message=message)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)

