# Birdhouse

![](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/3a513820-0c5d-4afc-a382-e7e4ec590126/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20200813%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20200813T154553Z&X-Amz-Expires=86400&X-Amz-Signature=3ce48b5c583db93e3aabb23214db93728238d922736b860e1f578be32c39ca57&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Untitled.png%22)

## Setup Elixir
To setup your development environment on either Mac, Linux or Windows head over to the official nerves documentation.

[Installation](https://hexdocs.pm/nerves/installation.html)

## Setup Project

1. Prepare your Phoenix project to build JavaScript and CSS assets:

These steps only need to be done once.
```bash
cd bird_app_ui
mix deps.get
npm install --prefix assets
```

2. Build your assets and prepare them for deployment to the firmware:

```bash
# Still in ui directory from the prior step.
# These steps need to be repeated when you change JS or CSS files.
npm install --prefix assets --production
npm run deploy --prefix assets
mix phx.digest
```

3. Change to the firmware app directory

```bash
cd ../bird_app_firmware
```

4. Specify your target and other environment variables as needed:

```bash
export MIX_TARGET=rpi3
export MIX_ENV=dev
export TELEGRAM_BOT_TOKEN=*BOT_TOKEN*
export TELEGRAM_CHAT_ID=*CHAT_ID*
# If you're using WiFi:
# export NERVES_NETWORK_SSID=your_wifi_name
# export NERVES_NETWORK_PSK=your_wifi_password
```

5. Get dependencies, build firmware, and burn it to an SD card:

```bash
mix deps.get
mix firmware
mix firmware.burn
```

7. Insert the SD card into your target board and connect the USB cable or otherwise power it on

8. Wait for it to finish booting (5-10 seconds)

9. Open a browser window on your host computer to http://nerves.local/video.mjpeg or ssh to the raspberry with `ssh nerves.local`

10. Now whenever you update the code you can also deploy the update via ssh

```bash
#create new firmware
cd bird_app_firmware
mix deps.get
mix firmware
mix upload
```


