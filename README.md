[Github](https://github.com/hisashin/docker-rpi-node-dash-button), [DockerHub](https://hub.docker.com/r/hisashin/rpi-node-dash-button/)

Please use [hisashin/node-dash-button](https://hub.docker.com/r/hisashin/node-dash-button/) if it's not Raspberry Pi.

Based on [node-dash-button](https://github.com/hortinstein/node-dash-button#first-time-dash-setup). Great work!

* First time Dash Setup
* Run Docker on Raspberry Pi
* Run This Image
* Get MAC address of your Dash
* Customize script
* Restart

# First time Dash Setup

As described [here](https://github.com/hortinstein/node-dash-button#first-time-dash-setup)

"Follow Amazon's instructions to configure your button to send messages when you push them but not actually order anything. When you get a Dash button, Amazon gives you a list of setup instructions to get going. Just follow this list of instructions, but don’t complete the final step. **Do not select a product, just exit the app.**"

# Run Docker on Raspberry Pi

Skip if you already done. Easiest way is to install [Hypriot Docker Image for Raspberry Pi](https://blog.hypriot.com/downloads/) with [flash](https://github.com/hypriot/flash).

I hit minor error with Raspberry Pi Zero W but [this post](https://github.com/hypriot/blog/issues/60#issuecomment-351239790) solved.

Simply after sticking micro SD card to your computer, run these commands. You will download OS image, add user, setup wifi and burn image into card.

    curl -o user-data.yml https://gist.github.com/goughjt/9a7e9b66217bda54893cb1474fa0968e
    curl -o boot-config.txt https://gist.github.com/goughjt/b121832bf6371b69794c2ecb43310be1
    vi user-data.yml (To change <like-this> sections like SSID)
    flash --bootconf ./boot-config.txt --userdata ./user-data.yml --hostname <hostname> https://github.com/hypriot/image-builder-rpi/releases/download/v1.7.1/hypriotos-rpi-v1.7.1.img.zip

# Run This Image

    docker run -it --net host --name rpi-node-dash-button hisashin/rpi-node-dash-button

# Get MAC address of your Dash

    # /node_modules/node-dash-button/bin/findbutton
    Watching for arp & udp requests on your local network, please try to press your dash now
    Dash buttons should appear as manufactured by 'Amazon Technologies Inc.' 

Then press Dash. Messages will be added like this.

    Possible dash hardware address detected: 11:22:33:44:55:66 Manufacturer: unknown Protocol: udp
    Possible dash hardware address detected: 11:22:33:44:55:66 Manufacturer: unknown Protocol: arp

In this case, 11:22:33:44:55:66 is MAC address of your Dash.

# Customize script

    vi /dash.js
 
    dash_button('aa:bb:cc:dd:ee:ff', null, null, 'all').on('detected', function() {
    //  https_get('www.google.com', '/foo/bar');	// for example to GET https://www.google.com/foo/bar
    //  http_get('www.google.com', '/foo/bar');	// for example to GET http://www.google.com/foo/bar
    });
Edit around this section as you want with the MAC address you got.

    dash_button('11:22:33:44:55:66', null, null, 'all').on('detected', function() {
      https_get('maker.ifttt.com', '/trigger/{your IFTTT event}/with/key/{your IFTTT secret key}');
    });
If you want to call IFTTT webhook, it will be like this.

# Restart

    forever stop /dash.js
    /start.sh

Ctrl+P, Ctrl+Q to escape. To autostart, add following line to /etc/rc.local

    docker start rpi-node-dash-button


