
As Currently configured in traefik.yml...

# Publicly Exposed!!!
Traefik (Container Summary): http://<ip/host>:8080/dashboard
Prometheus raw data: http://<ip/host>:8082/metrics 
Prometheus dashboard: http://<ip/host>:9090/query 

- If i cant reach any of these it is because I have decided to close the ports, I dont currently have a working strategy to get these accessible and behind a login, need to expose ports temporarily.

# Sits behind a login 
Grafana (dashboards): http://<ip/host>:3000/login
- This needs to be setup everytime I build and deploy the containers... I wonder if there is a way to automate this

### Analytics 
- Grafana/Prometheus 
- Plausible
- Distributors frontend has a super-admin role which is similar to the analytics the distributors see, but without the filtering and extra pages with some additional seggreation (by campaign, by dsitributor, etc.) (wondering the investment here for custom built vs tableau) 

### DB Backups
- Currently set to daily (not sure how many it keeps)
- https://us-east-2.console.aws.amazon.com/rds/home?region=us-east-2#snapshots-list:tab=automated


