# Extended Metrics Using Flask Web Server
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

- Create 'templates' directory within the 'flask_app' directory
  
  ```
  cd flask_app
  mkdir templates && cd templates
  ```

- Create empty status.html file
  
  ```
  touch status.html
  ```

- Create the flaskapp.py file in the 'flask_app' directory

  ```
  cd flask_app
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

- Add the following to the file

  ```
  - job_name: Flask-Metrics
    static_configs:
      - targets: ['localhost:5000']
  ``` 

- Restart prometheus service

  ```
  sudo systemctl restart prometheus.service
  ```
  
# Download extended metrics scripts

- Within the 'flask_app' directory, pull the klever-node-fetcher.sh and validators-status.py scripts

  ```
  cd flask_app
  wget https://raw.githubusercontent.com/KleverMaik/klever-node-fetcher/main/klever-node-fetcher.sh
  wget https://raw.githubusercontent.com/KleverMaik/klever-node-fetcher/main/validators-status.py
  ```
- Edit scripts and replace with your IP ADDRESS, WALLET ADDRESS and your BLS KEY

  ```
  METRICS='curl http://YOURIP:8080/node/status'
  PEERS='curl http://YOURIP:8080/validator/statistics'
  BALANCE='curl http://YOURIP:8080/address/YOUR_ADDRESS'
  OUTPUT=`
  curl -H "Accept: application/json" \
       -H "Content-Type: application/json" \
       -i "http://YOURIP:8080/node/status"` 
  BLSkey=YOUR_BLSKEY
  ```
  
- 'validators-status.py' is a script that can be used independently if desired. If you plan to use it, remove the # from those lines at the bottom of 'klever-node-fetcher.sh' and update the PATH where you plan to have validators.txt

  ```
  rm <PATH_OF_YOUR_CHOOSING>/validators.txt
  $PEERS >> <PATH_OF_YOUR_CHOOSING>/validators.txt
  python3 <PATH_OF_YOUR_CHOOSING>/validators-status.py >> $WEBLINK
  ```
  
- Make scripts executable
  
  ```
  chmod +x klever-node-fetcher.sh
  chmod +x validators-status.py
  ```

- Create a cron job to execute the klever-node-fetcher.sh

  ```
  crontab -e
  ```
  
- Insert the following at the bottom and modify the path. Save and Exit.
  
  ```
  */5 * * * * /bin/bash -c "/home/PATH_TO_SCRIPT/klever-node-fetcher.sh"
  ```

# Verify 
- Once you have your app running and scripts and files in place, verify you can access the URL and metrics are visible.

```
IPAddress:5000/metrics
```

