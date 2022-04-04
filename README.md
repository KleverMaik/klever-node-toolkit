# klever-node-fetcher
some basic scripts/tools to fetch values -> modify to use in Prometheus and Grafana

This "fetcher" script will help to retrieve some basic values out of the klever.io node.
To run that bash script, the following tools are needed:
1. bash
2. curl
3. grep
4. jq

$METRICS and $PEERS are the paths to the server where the values are getting from.
Just modify the path as needed to the end point of your machine.

Now just modify the script and adjust the path to the destination directory where
you want to store your output file.
As we want to fetch the values on Prometheus, use a web directory (our example is
based on Apache)

As last step just modify the $BLSkey according to the key your node is using.
You can find that key by checking the validatorkey.pem file at your server.

Once everything got adjusted just run the script and validate, that the status.json
file got created with all content.

______________________________________________________________________________
How to set up your server to use the status.json at Prometheus

Requirements
1. apache
2. cron
3. Prometheus

 Apache
Just add a directory where you want to store the file. Adjust the directory rights
to prevent any issues.

Cron
Next set up your cron service to fetch the values in a regulat basis.
1. crontab -e
2. add the following to run every 5 seconds (adjust the path as needed)
  */5 * * * * /bin/bash -c "/home/USERNAME/status.sh"

Just let the job run and check if the file gets created at the destination directory.

Prometheus
As next step you have to add the endpoint on your server at the Prometheus configuration.
You can use the following example:
- job_name: valistats
  honor_timestamps: true
  scrape_interval: 5s
  scrape_timeout: 5s
  metrics_path: /status.json
  scheme: http
  static_configs:
  - targets:
      - YOUR IP
