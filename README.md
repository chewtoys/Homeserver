# Docker self-hosted homeserver 

This is my personal repository of my docker services that I self-host on my Raspberr Pi 3.

The services are deployed through a docker-compose file. The following services are now deployed:

## Exposed services

  - Tiny Tiny RSS
  - Firefly III
  - Gotify

Requests are routed and handled through Traefik reverse proxy.

DuckDNS is used as a dynamic DNS provider and the relative docker service is used to keep my IP address up to date so that my services are always reachable through my DuckDNS subdomain.

Let's Encrypt is used to secure the connection to these services through free valid SSL certificates. Let's Encrypt is integrated into Traefik, which makes managing the SSL certificate part much easier.

## Internal services

  - Traefik Dashboard
  - Nodered
  - Watchtower

Traefik dashboard is used to keep an eye on the state of routing and services.

Node-Red is used to run some automation tasks.

Watchtower keeps all the containers (itself as well) up to date automatically. Makes use of Gotify to notify me when an update occurs.

## Other

  - `firefly-recurring-trans.sh` is a script file run through a cron job to trigger the processing of firefly recurring transaction that I have set up in my firefly instance. 
  - `backup-volumes.sh` => Backs up the services' volumes to MEGA. Volumes are encrypted first with `gocryptfs` and then uploaded through `mega-cmd`. Status of backups is controlled through `gotify` notifications.

## Bootstrapping

Once the repo has been cloned, you need to

  1. Delete the `delete_me` files under `volumes/*` folders.
  2. Copy and rename:
  
      - `.env.example` -> `.env`
      - `backup-config.sh.example` -> `backup-config.sh`
      - `env-firfly.example` -> `env-firefly`  
 
  3. Configure `.env` file according to comments
     
     If this project is contained in a folder whose name is not `homeserver`, `NETWORK_NAME` should be changed accordingly (e.g. `<foldername_frontend>`)

  4. On your router, open the ports specified in the `.env` file. **Also** open port `443`: it's needed for *Let's Encrypt* SSL verification.

### Restoring backups

If you want to restore some backups

  1. Login to mega with `mega-login`
  2. Get the folder you need with `mega-get`
  3. If you have encrypted stuff with `gocryptfs`, also pull the `gocryptfs.diriv` file and put it in the downloaded folder.
  4. Decrypt the files with `gocryptfs -masterkey <master_key> <encrypted_folder> <plain_folder>
  5. Extract the archive you want with `tar -xzvf <archive> -C <localfolder>`
### Service-specific actions
Some services require specific changes to be made.

**Firefly**

  - Set `APP_KEY` inside `env-firefly` to a string of **exactly** 32 characters.
  - Setup *recurring transactions trigger* in the *crontab*:

    1. `crontab -e`
    2. Paste `0 3 * * * <project_folder>/firefly-recurring-trans.sh >/dev/null 2>&1` to launch the recurring transactions script.


### Booting everything up

Before launching everything, open `docker-compose.yml` and:
  
  1. Uncomment `--log.level=DEBUG` on traefik service
  2. Uncomment `--certificatesResolvers.le.acme.caServer=https://acme-staging-v02.api.letsencrypt.org/directory` to use *let's encrypt* staging server
  3. Comment `--certificatesResolvers.le.acme.caServer=https://acme-v02.api.letsencrypt.org/directory`

Then launch `docker-compose up -d` (specify the services if you don't want to launch them all).

Everything is fine if:

  - You can accesss traefik dashboard to the port specified
  - You can access the services you ran at the url and ports specified **over HTTPS**
  - If you restored backups, you can see the data on your services.

If the above is good, undo the changes you've just done the `docker-compose.yml` file and launch `docker-compose down && docker-compose up -d`