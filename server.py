from flask import Flask, render_template, request, redirect
import psycopg2

app = Flask(__name__)

# PostgreSQL configuration
DB_HOST = "ubuntu23"
DB_NAME = "mercury"
DB_USER = "mercury"
DB_PASSWORD = "mercury"

# Create a connection to the database
conn = psycopg2.connect(
    host=DB_HOST,
    database=DB_NAME,
    user=DB_USER,
    password=DB_PASSWORD
)

# Create a cursor object to execute PostgreSQL commands
cursor = conn.cursor()

# Create a table if it doesn't exist
cursor.execute("""
    CREATE TABLE IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        first_name VARCHAR(50) NOT NULL,
        last_name VARCHAR(50) NOT NULL,
        email VARCHAR(100) NOT NULL
    )
""")
conn.commit()


@app.route("/", methods=["GET", "POST"])
def home():
    if request.method == "POST":
        # Get the form data
        first_name = request.form["first_name"]
        last_name = request.form["last_name"]
        email = request.form["email"]

        # Insert the user into the database
        cursor.execute("""
            INSERT INTO users (first_name, last_name, email)
            VALUES (%s, %s, %s)
        """, (first_name, last_name, email))
        conn.commit()

    # Fetch all users from the database
    cursor.execute("SELECT * FROM users")
    users = cursor.fetchall()

    # Render the template with the users data
    return render_template("index.html", users=users)


@app.route('/delete', methods=['POST'])
def delete_users():
    selected_users = request.form.getlist('selected_users')
    if selected_users:
        # Connect to the database
        conn = psycopg2.connect(
            host=DB_HOST,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD
        )
        cursor = conn.cursor()
        
        for user_id in selected_users:
            # Delete the user from the database
            cursor.execute("DELETE FROM users WHERE id = %s", (user_id,))
        
        # Commit the changes and close the connection
        conn.commit()
        conn.close()

    return redirect('/')

if __name__ == "__main__":
    app.run()
