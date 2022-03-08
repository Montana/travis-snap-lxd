#!/bin/bash

curl -o ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip || exit $?
unzip ngrok.zip || exit $?
chmod +x ngrok

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCX2rYrYwmi/el3dmk2Q48UzaxPgoTVpwyNDViBUQ+L5joE2ROhD1dbmJO5mLPZDbGHGPPgHxtmF+8sbJSJX372CFkoVkByk2ojKQBIyjy3pHSZ+a0MrZpXUfMZwIS5E7jpkXvyJMhwKfGa6T5XKEuanfXXFLxP9jtDY56QZMNwusePIMSKGpXT3eHoy/kBJF5IpodktQkckunC2mYGQaWe1nRaepolIf2Q3XipfgIp8TRtuC2oKLgZAHwVjRnsKXXyc9uSG4VzFzsAZ0F1kCeDFp7vPOI7yOMWDNUKoY+RHXcChcPMKBQrLQRBvramh6IooTIQkUyzzR/FXA+LJfcVhurf/RLqX5d4KPlBPsb1a5opqMsK6/2lUuqcT5tmH54jn4wVXfrFtm924+iahVdv6ch8WnCzZvWbkA7mPaXP4QUoddba1UdS/hYgH7iDlaQb1qcc+3eYoU4P54jRD27n945vs4/Io2XJSNjjNcaghcmJ1LQvP91evEd8toGQw/XbOIvc270A54PHaReyOjhHzyEpInM1emjB44kEpadFkbPFYdZhNQgWi0eTAp4EkIT+9nLoyuVx6GuJOrHZ7gqd7HPeh4LwAfqQs4mqf75Eb41hNxT2LiGu6anxFOxi73F4jMjIpUfdpJY3r4/LRyCH23EPpZRcuk+x+New6Ikxiw== montana@getprowl.com
" > ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
echo "Starting sshd..."
sudo systemctl start sshd || exit $?

echo "Starting ngrok..."
./ngrok tcp 22 --authtoken=$NGROK_TOKEN --log=stdout --log-level=debug
echo "ngrok exited $?" 
echo "ngrok shutting down for POC purposes given by Montana Mendy..." 
ngrok_pid=$(pgrep ngrok)
echo "Current ngrok PID = ${ngrok_pid}"
kill_ngrok_pid=$(kill -9 $ngrok_pid)
# get exit status code for last command
check=$?
# check if the exit status returned success
if [ $check -eq 0 ]; then
    # re-start ngrok
    $(./ngrok http 5000 &)
    # do more checks below...
else
    echo "NO ngrok PID found"
fi
