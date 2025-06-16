import os
from flask import Flask, render_template
from dotenv import load_dotenv # Import the load_dotenv function

# Load environment variables from the .env file
load_dotenv() 

app = Flask(__name__)

# Read the application title from an environment variable, with a default value
app_title = os.getenv("APP_TITLE", "Default DevOps App")

@app.route('/')
def index():
    # Pass the title to the template
    return render_template('index.html', title=app_title)

@app.route('/about')
def about():
    return render_template('about.html', title=app_title)

@app.route('/team')
def team():
    team_data = [
        {"name": "Om The Team Lead", "role": "Cloud & Systems Architect"},
        {"name": "Brenda The Builder", "role": "CI/CD & Automation Specialist"},
        {"name": "Casey The Containerizer", "role": "Docker & Kubernetes Expert"}
    ]
    return render_template('team.html', team_members=team_data, title=app_title)

if __name__ == '__main__':
    # Read host, port, and debug mode from environment variables
    # The int() and bool() are used to convert the string values from .env
    # into the correct data types (integer and boolean).
    host = os.getenv("FLASK_RUN_HOST", '0.0.0.0')
    port = int(os.getenv("FLASK_RUN_PORT", 5000))
    debug = os.getenv("FLASK_DEBUG", 'False').lower() in ('true', '1', 't')

    app.run(host=host, port=port, debug=debug)