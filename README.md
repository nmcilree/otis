# otis
A vanilla Django application with docker-compose to enable developers to quickly get a skeleton site running on GOOGLE compute engine.  Either user the included otis Django project to start with, or just use the docker insfrastructure and container inits to quickly create a platform to build your own Django project into.

# Run in google compute engine

## Create a cloud instance

1. [https://console.cloud.google.com/compute/instancesAdd](https://console.cloud.google.com/compute/instancesAdd)
2. Name the instance
3. Select region
4. Select machine type ( I choose e2-small (2 vCPU, 2 GB memory)
5. Under firewall tick allow HTTP traffic and allow HTTPS traffic
6. Click create


## Download code to server



1. Create a personal access token for GIT - [https://github.com/settings/tokens](https://github.com/settings/tokens), setting full repo permissions
2. Install wget: sudo apt-get install wget
3. Download code to server running following command:  \
<code>wget -d --header="Authorization: token 9dfd5f4428cf6e19bd8f70e2dc9b9768e0dbf4cf" [https://github.com/nmcilree/otis/archive/main.zip](https://github.com/nmcilree/otis/archive/main.zip)</code>
4. Install zip by running: sudo apt-get install zip
5. Run unzip main.zip
6. Update ALLOWED_HOSTS in otis-main/app/otis/settings.py to the URLs you which to allow to access the site.


## Install docker and docker compose



1. Install Docker on the compute engine [https://docs.docker.com/engine/install/debian/,](https://docs.docker.com/engine/install/debian/,) run “dpkg --print-architecture” if you need to check what processor your server has
2. Install docker compose [https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/)
3. (optional) Install tmux: 
4. sudo apt-get install tmux


## Generate SSL certificate with certbot from lets encrypt



1. Install snapd - https://snapcraft.io/docs/installing-snap-on-debian
2. Install certbot from lets encrypt - [https://certbot.eff.org/lets-encrypt/debianstretch-other](https://certbot.eff.org/lets-encrypt/debianstretch-other)
3. If not done in part 3 run certbot in standalone mode: sudo certbot certonly --standalone. This should output a message with the location of your generated certificates.
4. Copy the fullchain and privkey to the nginx/container folder
5. Change ownership from root to current user - sudo chown -R &lt;user> ./*
6. Uncomment lines at bottom of otis-main/containers/nginx/Dockerfile relating to location of SSL certificates (or amend to where your certificates are stored)
7. Update container otis-main/nginx/nginx.conf with your sites domain name ( replace otis.site.com ) 


## Build containers 



1. CD to the otis-main folder
2. sudo docker-compose build 
3. Run containers - sudo docker-compose up ( you might need to up them separately ( hence tmux ) as the postgres container would often take longer to initialise than the django one )
4. Remote into otis_django container to run initial migrations - “docker exec -it otis_django bash”
5. Run python manage.py migrate
6. Run python manage.py collectstatic

You should now be able to access your site
