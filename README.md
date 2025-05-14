

Fork from [chuckcharlie/cups-avahi-airprint](https://github.com/chuckcharlie/cups-avahi-airprint)
which itself is...

Fork from [quadportnick/docker-cups-airprint](https://github.com/quadportnick/docker-cups-airprint)

### Changes from forked repos:

* Changed base image to Debian w/ x86 arch support so older Brother driver bins will run
* Changed networking to macvlan to run alongside other docker services on machines (requires dedicated ip on subnet)

## Configuration

### Volumes:
* `/config`: where the persistent printer configs will be stored
* `/services`: where the Avahi service files will be generated

### Variables:
* `CUPSADMIN`: the CUPS admin user you want created - default is CUPSADMIN if unspecified
* `CUPSPASSWORD`: the password for the CUPS admin user - default is the same value as `CUPSADMIN` if unspecified

## Add and set up printer:
* CUPS will be configurable at http://[host ip]:631 using the CUPSADMIN/CUPSPASSWORD.
* Make sure you select `Share This Printer` when configuring the printer in CUPS.
* ***After configuring your printer, you need to close the web browser for at least 60 seconds. CUPS will not write the config files until it detects the connection is closed for as long as a minute.***

## Running

* Edit docker-compose, add your variables for networking and the cups password
* `mkdir brother; cd brother` then download the deb files for the cupswrapper and lpr and place them in this directory (installed by build step)
* `docker compose build`
* `docker compose up`
