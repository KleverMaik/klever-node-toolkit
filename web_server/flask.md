# Install and Configure Flask Web Server
- Flask is a lightweight web application framework. Given the nature and purpose of what we are aiming to achieve, Flask will work. You may choose to use another of your choice.

## Install and verify Python3 version
- Ubuntu 20.04 ships with Python 3.8. You can verify that Python is installed on your system. If it is not, please download it.

  ```
  python3 -V
  ```

- Example output

  ```
  Python 3.8.10
  ```

## Install and Setup Flask
- Create a flask directory in the location of your choice. Then switch to that directory

  ```
  mkdir flask_app && cd flask_app
  ```
  
- Install flask  

  ```
  pip3 install Flask
  ```  
  
- Check versions

  ```
  python3 -m flask --version
  ```
  
- Example output

  ```
  Python 3.8.10
  Flask 2.0.3
  Werkzeug 2.0.3
  ```

- Create 'templates' directory withing the 'flask_app' directory
  
  ```
  mkdir templates && cd templates
  ```

- Create empty status.html file
  
  ```
  touch status.html
  ```

- Create the flaskapp.py file

  ```
  vi flaskapp.py 
  ```

- Copy and paste the following. 

  ```
  #!/usr/bin/python3

  from flask import Flask, render_template
  app = Flask(__name__)

  @app.route("/metrics")
  def home():
      return render_template('status.html')
  if __name__ == "__main__":
     app.config['TEMPLATES_AUTO_RELOAD'] = True
     app.run(host='0.0.0.0', port=5000)
  ``` 
   
- Flask uses Port 5000 by default. Ensure it is open.

- Run the app

  ```
  nohup ./flaskapp.py &
  ```
  
# Update your prometheus.yml file

  ```
- job_name: Flask-Metrics
    static_configs:
      - targets: ['localhost:5000']
  ``` 

# Restart prometheus service

  ```
  sudo systemctl enable prometheus.service
  ```

# Verify 
- Once you have your app running, verify you can access the URL. It should be blank but reachable.

```
IPAddress:5000/metrics
```

- You may now populate the status.html file read in by your Flask application by using the 'klever-node-fetcher.sh' and setting up a cron job as noted in the main README.md file
