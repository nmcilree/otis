# otis
A vanilla Django application with docker-compose to enable developers to quickly get a skeleton site running on GOOGLE compute engine.  Either user the included otis Django project to start with, or just use the docker insfrastructure and container inits to quickly create a platform to build your own Django project into.


**Setting up the virtual machine \
https://cloud.google.com/community/tutorials/nginx-reverse-proxy-docker**

Create a new Compute Engine instance using the [CoreOS](https://coreos.com/why) stable image. CoreOS comes with [Docker](https://www.docker.com/what-docker) pre-installed and supports automatic system updates. The instructions in the above link are slightly out of date but it’s pretty self explanatory.



1. Open the [Cloud Console](https://console.cloud.google.com/).
2. [Create a new Compute Engine instance](https://console.cloud.google.com/compute/instancesAdd?_ga=2.57045546.1076251652.1604485782-1478234681.1604485782).
3. Select the desired **Zone**, such as "us-central1-f".
4. Select the desired **Machine type**, such as "micro" (f1-micro).
5. Change the **Boot disk** to "CoreOS stable".
6. Check the boxes to allow HTTP and HTTPS traffic in the **Firewall** section.
7. Expand the **Management, disk, networking** section.
8. Click the **Networking** tab.
9. Select **New static IP address** under **External IP**.
10. Give the IP address a name, such as "reverse-proxy".
11. Click the **Create** button to create the Compute Engine instance.

SSH in via the web interface



1. **Get the code from repo \
**Sudo curl -v -J -O -u username:password [https://bitbucket.org/boltlearning/peoplehr/get/b94a986cba5c.zip](https://bitbucket.org/boltlearning/peoplehr/get/b94a986cba5c.zip) \
The url can be found from the downloads option on the left of the repository
2. **Install Docker** \
[https://docs.docker.com/engine/install/debian/](https://docs.docker.com/engine/install/debian/) \
`dpkg --print-architecture `if you need to check what processor
3. **Install docker compose \
**[https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/)
4. **(optional) Install tmux \
**sudo apt-get install tmux
5. **Build containers \
**sudo docker-compose build
6. **Run containers \
**sudo docker-compose up - you might need to up them separately ( hence tmux ) as the postgres container would often take longer to initialise than the django one
7. **INstall certificate**
    1. Get the a certificate from lets encrypt using certbot \
[https://certbot.eff.org/lets-encrypt/debianstretch-other](https://certbot.eff.org/lets-encrypt/debianstretch-other)
    2. Copy fullchain and privkey to the nginx/container folder
8. 

    IMPORTANT NOTES:


     - Congratulations! Your certificate and chain have been saved at:


       /etc/letsencrypt/live/fuse.nm.boltstaging.com/fullchain.pem


       Your key file has been saved at:


       /etc/letsencrypt/live/fuse.nm.boltstaging.com/privkey.pem


       Your cert will expire on 2021-02-03. To obtain a new or tweaked


       version of this certificate in the future, simply run certbot


       again. To non-interactively renew *all* of your certificates, run


       "certbot renew"


     - Your account credentials have been saved in your Certbot


       configuration directory at /etc/letsencrypt. You should make a


       secure backup of this folder now. This configuration directory will


       also contain certificates and private keys obtained by Certbot so


       making regular backups of this folder is ideal.


     - If you like Certbot, please consider supporting our work by:


       Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate


       Donating to EFF:                    https://eff.org/donate-le


    



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
