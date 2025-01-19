### CHANGELOG FOR EMAGNET

##### EMAGNET IS A NEW PROJECT, I WILL RELEASE VERSION IN SHORT INTERVALLS SO I CAN GO BACK TO SEE EVERYTHING I ADDED AND REMOVED DURING THE TIME

# DESCRIPTION

+ = NEW FEATURE
- = DELETED FEATURE
r = RE-ADDED FEATURE FROM AN EARLIER VERSION
     If you have been using emagnet since version 1.2 you know some stuff have been added and removed during the time frequently, these features
     that has been re-added is now stable and not "half done" so they are here for stay.
R = REBUILT

# Version 3.4.3

+    Created https://github.com/wuseman/emagnet-scraper repo, this is the script we using for scrape pastebin and add everything to nr1.nu
+
+    -- All brute-force tool works as expected again
+    Gmail bruter-forcer has been fixed
+    Instagram brute-forcer has been fixed
+    SSH bruter-forcer has been fixed
+    RDP bruter-forcer has been fixed
+    Spotify bruter-forcer has been fixed
+    ----
0
+    Almost entire emagnet_main function, the heart of emagnet is changed since we changed how we list files and check things for not download dupes.
+    Changed source for get newest uploads from pastebin (notice: be careful here if you didnt run emagnet before, you will probably be banned due ALOT of downloads)
     pastebin.com is now https://nr1.nu/emagnet/pastebin/$(date +%Y-%m-%d)/pastebin.txt in emagnet.conf under PASTEBIN= (source, variable name will be changed)
+    Added current_version to mainscript so we can differ versions if config file is for another version
+    Function: emagnet_requirements renamed to emagnet_required_tools
+    Function: emagnet_quiet renamed to emagnet_screen
+    Removed functions that was useless after we changed to nr1.nu instead for recent uploads: 
     emagnet_heavyload,emagnet_blocked, emagnet_api, emagnet_notice_about_scraping
+    Functions that are removed from script but will be readded if we got banned from pastebin because downloading:
     emagnet_wasibanned, emagnet_I_was_banned, emagnet_vpnsetup
+    Added 'root' as default pass for ssh bruteforcer
+    pastebin.com is now gone, using PASTEBIN=https://nr1.nu/emagnet/pastebin/$(date +%Y-%m-%d)/pastebin.txt
+    We do not use patebin for get recent pastes anymore since they removed it from all public lists, new source is nr1.nu/emagnet/YYYY-MM-DD/daily_dir/pastebin.txt
+    Removed notify-send from main function (not removed from emagnet.conf yet)
+    Option for -v, -vpn, --vpn is temporary moved until we readd functions for set a country (this will be rebuilt)
+    emagnet_check_pastebin was added for check if everything is fine when visits pastebin
+    Prtaudio message when bruteforcing with spotify, we fixed typos also message for libspotify was added

# Version 3.4.2

+    Added  better support for requirements, changed hash/which
+    Added API to emagnet.conf, if you have whitlisted your IP at pastebin.com please set this value to true otherwise leave it to false - If this is set
     to true you are allowed to scrape pastebin for new uploads much faster, add your IP on: https://pastebin.com/doc_scraping_api 
+    Added warning about using emagnet in countries you are not allowed to store passwords and other private info
+    Added a checker, if API is set to true and the IP that is being used is not whitelisted we stop.
r    Emagnet stats is back on track, was added in version 1.6. Show stats for how many passwords, email addressses and files you have catched
+    Renamed emagnet to emagnet.sh
+    Added archive folder with older versions of emagnet, random versions comes and goes
+    Created a symlink to emagnet from emagnet.sh 
+    Added scripts folder, released with scrape-pastebin.sh for store all uploads from pastebin on your own place

# Version 3.4.1 

+    Fixed an issue with --merge, now incoming files getting merged to archive again
+    Fixed a bug wich caused spotify brute-forcing run over and over again, now we run it once and then we fetching more uploads
+    Added support for PROXY / SSH Tunnels
+    Added proxy to help/usage
+    Changed main site to ipconfig.co for whois our IP since nr1.nu is down for an unknown time
+    Removed WIP3,WIP4,WIP5 from emagnet.conf
+    Removed android functions and stuff from emagnet.conf
+    Added values to all variables, we keep "mustbefilled" if you remove any variable by mistake

# Version 3.4

+    Added it possible to search for various stuff
+    Added a function to figure out if you have been blocked or not before you running emagnet
+    Added RDP bruteforcer
+    Fixed so if we are busted and being asked for captcha then we changing IP
+    Set wich file you want to send to all email addresses by: -s /path/to/textfile.txt
+    Set vpn provider by: -v -p <provider>
+    Support for instagram brute forcing
+    Changed layout, removed spaces between everything we found
+    Re-added ssh bruteforcer, nothing wont be stored to log, read script description for why we don't 
+    Small and general fixes for a better setup
+    Better regex and added it easier to read how we grab stuff
+    Better quoting
+    Renamed all functions to emagnet_functionname
+    Added a more elegant way to write analyzing.
+    Added HEADER to emagnet.conf, default is Mosaic (first header ever made)
+    Added LIBSPOITFY to emagnet.conf
+    Added emagnet.conf into root dir
+    Added support for merge logs in to archive
+    Added requirements for vpn part (openvpn)
+    Edited how we read LICENSE
+    Added a function for colors so we can use a more elegant way to print stuff

-    Removed color function again since it wont work on android devices
-    Removed .emagnetconf/emagnet.conf and .emagnetconf/emagnet.conf.bak
-    Removed requirements for a browser to be installed
-    Remove temp files so they wont be stored in tmp folder 
-    Removed spammer
-    Removed stats for rebuilding
-    Removed safety part that added to log if someone otherwise then root tried to run script (useless since long time ago)
-    Removed setup script
-    Removed elinks and lynx requirements so we can use emagnet on more systems without install more tools then we really need
-    Removed requirements part as default, it will be used when you using stuff that may need requirements like smtp/parallel for spammer & ssh bruteforce

# Version 3.2

-    Removed fuzzer, and find temporary
+    Spotify BRUTEFORCE has been added
-    Removed requirements for netcat since we dont have any use for netcat anymore
+    emagnet-setup.sh has now been moved to emagnet
+    Notifications has been added, this require notify-send
+    Toggle between true or false via --notify
+    SSH bruteforce has been added
+    Removed almost all comments since it toke alot of place
+    General fixes

# Version 3.1

+    From now you will see how many files the current session was downloading
+    Fixed bug so emagnet-files never was created and no email files was stored, they was still stored in logs so nothing was missed
+    Fixed a new layout on emagnet stats
+    Fixed so we wont download duplicates, this have been tricky during time as you might have noticed but finally it is working 100% so no more dupes will be downloaded, you will see this
     thanks to the new "Files has been downloaded" feature when you run emagnet
+    Fixed a new layout for email bruter
+    Fixed new layout for help
+    Fixed so unneccessary stuff wont be sourced or loaded while we run --help for example, this will print help only (will even be possible without root)
+    General fixes..
+    Added author for print author information
+    Added license for print license information
+    Added setup for re-run setup (in next version emagnet-setup will be built in, hence this was added since it's useless otherwise since you can run emagnet-setup.sh otherwise ;) )
+    Added emagnet backup for backup all, archive or incoming folder
+    Added long + short options for everything, removed while getopts..
+    Added so you can toggle between false or true on vpn
+    Added so you can set time with --time 5 instead of changing conf file all the time
+    Better support for VPN, it will try connect again if it didnt connect the first time, the third time you will be asked to fix it manually since something is probably wrong?
+    If no new files has been downloaded you will see that 0 files has been downloading by blinking + you will be noticed that you should raise the REFRESH time probably? (this happends mostly if you run emagnet within 3 seconds or less for testing
+    Pastebin has added a new protection, if you are scraping pastebin to fast you will be banned from archive page and will only be available to get 8 downloads at each visit - Emagnet will notice when this happends from now.

# Version 3.0

-    Removed LOGS2 from emagnet.conf
R    Spammer has been rebuilded totally since it didnt work any good before. From now we gonna spam all targets from our daily dir if there is any email addresses stored
r    Added inotify script example to README again
+    Added BACKUPS to emagnet.conf
+    Cleaned up alot and changed order on all functions so it's easier to understand how emagnet is built
+    Added better description in configuration file
+    Added NOTIFY to emagnet.conf so we can get notification if we are using notify-send (Linux Only)
+    Added VPN settings in /etc/emagnet.conf, if we getting banned we can choose to get a new IP from our vpn provider instead of idle 3600+ seconds so we wont miss anything ;-)
+    Added SSH settings in /etc/emagnet.conf for ssh bruteforcer (COMMING SOON)
+    Changed WIP to entire url instead of just nr1.nu
+    Changed IDLETIME's default value from 1200 > 3600 since pastebin has raised the ban time to 60 minutes.
+    Added browser function, if the values are empty then we asking for wich browser you want to use
+    Added threader, if threader has been deleted we gonna set the threader to 1 else things gets broken, edit this after your needs if you have removed this value then you know how to fix it

# Version 2.1

+    Added support for email all targets that has been found, 'emagnet -e spammer' must be runned beside 'emagnet -e emagnet'
+    You are now able to get notifications via notify-send, set NOTIFY to true or false in /etc/emagnet.conf (Default: false)
+    Fixed so we wont grab same files twice, no more duplicates will be checked or downloaded
+    Added BROWSER to emagnet.conf so we can choose browser via setup script easier
+    Cleaned up some code
+    Minor fixes
+    Added new feature for -e, use emagnet -e syntax for download all files by a syntax set and sorted by pastebin
+    Added iconnection function wich will check if we got internet connection otherwise we stop
+    Created a better usage/help part
-    No more trap so emagnet will run in background, stop emagnet by ctrl+c
-    Emagnet crawler has been removed
-    Emagnet fetch urls has been removed
-    Emagnet download fetched urls has been removed
-    Emagnet pastebin uploader has been removed

# Version 2.0

r    Emagnet now has full support for AUTO BRUTE MODE - Current version have support for GMAIL accounts
+    Emagnet now have support for check wich IP you downloading files from via -i
+    Emagnet now have support for a web crawler via lynx or elinks browser to grab all urls from a website website's website's yeah list may be extremely long
+    Emagnet does now also support uploads via nr1.nu not just via commandline, now upload files too or take a screenshot
+    Emagnet must be triggered with -e emagnet/bruteforce
+    Emagnet has a new banner
-    Removed _video folder so you can clone emagnet much faster
-    Removed _old scripts, download them from my repo instead
-    Small fixes

# Version 1.6.4 - BETA 

-    'Emagnet -f' - Fetching URLS has been improved alot
-    Added a colorized spinner while we counting stats, you can of course turn off colors in /etc/emagnet.conf
-    While we gathering new uploads from pastebin we gonna print some random quotes in pure bash code
-    FETCHTIME has been added to emagnet.conf, you dont need to care you will be asked to set a value when you executing emagnet -f
-    It's now time for us to move over to pastebin/archive instead of using pasting, this means you wont need fetch urls as often as before this was just under a beta period we used pastebin.com
-    Changed interface of emagnet -f to a more cleaner look so it fetch with rest of interfaces we using
-    Edited entire lines when we visits PASTEBIN. Cut, sed, awk, grep, lynx or elinks is used when we fetching urls
-    General fixes


# Version 1.6.3 - BETA

-    Fixed interface for gathering urls
-    In this version the big changes has been in emagnet-setup.sh
-    Removed script path from config file since we have merged everything into one script now
-    Changed echo to printf in emagnet-setup were we printing if depends has been found or not
-    Emagnet setup script has been improved alot, much better descriptions and changed layout to a more clean look
-    Emagnet -f have been added as a new feature wich will fetch all latest uploads on pastebin.com without downloading
-    If you want to download the files you have choosed to fetch earlier then you just run emagnet -d for download them
-    If you want to grab email addresses and password to be sorted by below new feature then just run emagnet -e and just wait until emagnet will fetch new uploads as usual    
-    Changed DEFAULT refresh time to 60 seconds since pastebin have changed time limit how often you are allowed to visit pastebin until they will set a ban for 1600 seconds
-    Changed wait time for 1600 seconds, this is for everyone who sets a time intervall of 59 seconds or less (set a time of 60 secons or more to avoid bans)
-    Added the new features to help and also edited descriptions
-    Removed banner from help 
-    Changed so we using awk instead of cat to not get dupes into our log files.
-    Improved STATS
-    Improved MERGE

##### Version 1.6.2 - BETA

-    Emagnet mirror has been removed
-    Emagnet clone any users git repositories has been removed
-    Emagnet up or down feature has been removed
-    Added a new feature for check stats of downloaded files and also how many email-addresses and passwords you have been found
-    Added emagnet archive feature, move all files to archive dir and merge all logs
-    Added a notice message if the time is set to 60 seconds or less and if your real ip is used
-    Fxed so all desc boxes are at the same length when running emagnet-setup
-    Edited so we grab our IP from nr1.nu properly since they rebuilt the page, no more sed is required
-    Small fixes

- Version 1.6.1 - BETA 
-  --------------------
-  ./emagnet-f.sh has been removed
-  Fixed the issue when a user choosed elinks as prefered browser it deleted wrong lines so emagnet got broken. Now you can run emagnet on Android(termux) again.
-  Bugfixes
-  Added better support when we getting banned by pastebin.com
-  Fixed the password issue i thought was fixed in last version, now everything will be sorted as it should be
-  Fixed so emagnet.log wont log both X emails and X passwords, if there is 0 passwords found and 2 email addresses then we just will add in wich files email addresses was found
-  Fixed typos

##### Version 1.6.0 - BETA

-    After few days emagnet have download over 10 000+ files so now emagnet using day directories for keep things sorted
-    Emagnet is now supported on ANDROID via termux app.
-    Emagnet now got full support for elinks2, if you got both lynx and elinks2 installed you will be asked for wich browser you prefer, elinks is required if you run emagnet on any android device via termux.
-    Merged everything into emagnet (emagnet-f.sh) will call emagnet if you run emagnet -f
-    Parallel has been added to this version for ALOT faster downloads, it is required to have parallel installed. You will be asked to install parallel if you miss the package.̣
-    Fixed a small bug that did so files never moved from .temp path if there was an email found so it repeated that X mail addresses had been found.
-    Haveibeenpwned checker has been removed since it's useless cause we got banned all the time via emagnet
-    Debug mode has been removed.
-    Run emagnet in hidden mode has been removed, this will be re-added in next version.
-    Emagnet has been ALOT more stabilized from this version, no more random crashes.
-    Emagnet KILL has been added, if there is an ghost that running just run emagnet -k
-    Emagnet pastebin uploader from command line has been improved alot, now use emagnet -n $(command) OR command | emagnet -n for upload stdout to nr1.nu
-    IDLETIME and PARALLEL threads has been added to emagnet.conf
-    Improved source code alot, much more easier to follow how things have been setup from now.
-    Added comments to all functions so it's easier for people who want to improve/edit/reconfigure emagnet
-    Small layout changes.
-    Changed question emagnet used if you got banned and wanted to read the message for idle in 1200 seconds instead and then we start again, you can leave emagnet running 24/7 now it will handle everything perfect, you can change idle time if you want in /etc/emagnet.conf but remember pastebin use 20 minutes until they remove the temp ban if you wasn't PERMANENT banned (you must have been abusing pastebin VERY much for get permanent banned)

##### Version 1.5.1 - BETA

-    Added idle time setting to conf file, this setting is for how long you want to stay idle if emagnet have noticed a ip ban from pastebin
-    Since we get millions of uploads then our path will be extremely big so now i have fixed that we gonna use daily folders instead
-    Emagnet will grab passwords from default now aswell
-    emagnet-setup has added descriptions for every setting
-    updated storage dirs so we can store dirs with dated dirs

##### Version 1.5 - BETA

-   Some small fixes has been solved with setup script
-   emagnet-wbruter has been added as a new feature, consider this as a beta since this is still under active development

##### Version 1.4 - BETA

-   I decided to split everything into small scripts instead since it's alot easier to troubleshoot if something goes wrong, you wont notice any difference at all, run 'emagnet' to execute them, 
    there is no  reason to run any of the scripts from .scripts dir, listing the new ones only:
    .scripts/emagnet-backup.sh
    .scripts/emagnet-banner.sh
    .scripts/emagnet-clone.sh
    .scripts/emagnet-f.sh
    .scripts/emagnet-help.sh
    .scripts/emagnet-hidden.sh
    .scripts/emagnet-main.sh
    .scripts/emagnet-mirror.sh
    .scirpts/emagnet-ping.sh
    .scripts/emagnet-requirements.sh
    .scripts/emagnet-spider.sh

-   Added .scripts/emagnet-ping.sh - Enter a dns and emagnet will check via downforjustyou website if host is up
    and for ipv4 number ip addressed emagnet gonna use '/bin/ping' instead for get a valid result very very fast if the ip-address is up or down.
-   It's now possible to use emagnet for upload from stdout from commandline, example usage: 'dmesg | emagnet -n'. Host does NOT store any ip number or other data about users at all.
-   Silent mode, download all urls and store them in background, you can go cook a cup of coffe instead! 
-   Small fixes
-   Mirror any website and download everything that is possible from the website(try mirror facebook, (EXTREMELY MUCH DATA =))
-   Gather all urls from a webpage, this is meant to be a web crawler.
-   It's now possible to clone all repos from any user on github.

##### Version 1.3 - BETA

-   Emagnet will notice if you getting ip-banned from pastebin and then emagnet will stop and after X minutes emagnet will continue.
-   Small fixes
-   .scripts/emagnet-f.sh is a loop script, there i no reason for touch this, run emagnet -f to execute it.
-   Now execute setup.sh to setup everything before you will run emagnet. There is no requirements for edit 
    /etc/emagnet.conf anymore, just run emagnet-setup.sh and then you will be able to run emagnet.
-   Debug mode has been enable, use debug mode with arg: -d 

##### Version: 1.2 - BETA

-   Fixed so we wont keep any duplicate.
-   Set your paths in /etc/emagnet.conf. There is no need for change stuff in 'emagnet' anymore.
-   Now emagnet store all files from pastebin so you can go through them later if you wanna find something offline without any stress..
-   More efficient logging to keep things sorted, all uploaded files that includes email addresses will be stored in it's own folder so it's easy to find passwords and mail addresses.
-   Added getopts, from now you must use -o, -h or -f to run emagnet.
-   Help section was added.
-   Paths need to be properly set in /etc/magnet.conf otherwise emagnet wont run (no more files in emagnet folder ;))
-   If pastebin has banned the current IP beccause you was an idiot and was trying to fetch uploads every <10s then emagnet will stop (just change ip)
-   Mirror any site and download all files that is possible from a website

##### Version: 1.0 - ALPHA

-   Support for download latest uploads from pastebin via Lynx Web Browser
-   Emagnet 1.0 Has Been Created (Current: 3 lines of code)
