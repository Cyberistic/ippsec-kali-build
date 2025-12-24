## IMPORTANT: This is a direct fork of Ippsec's build, with minimal changes to make it work with Kali instead of Parrot. 

** Make sure to pip install ansible, apt has an older copy **

# Instructions
* Start with Kali installation
* Install Ansible (python3 -m pip install ansible)
* Clone and enter the repo (git clone)
* ansible-galaxy install -r requirements.yml
* Make sure we have a sudo token (sudo whoami)
* ansible-playbook -K main.yml

# Off-Video Changes
* Mate-Terminal Colors, I show how to configure it here (https://www.youtube.com/watch?v=2y68gluYTcc). I just did the steps in that video on my old VM to backup the color scheme, then copied it to this repo.
* Evil-Winrm/Certipy/SharpCollection/CME/Impacket, will make a video for these soon
* Updated BurpSuite Activation. Later versions of ansible would hang if a shell script started a process that didn't die. Put a timeout on the java process
* Ghostty Terminal Support: Added xterm-ghostty terminfo entry for proper terminal emulation with Ghostty terminal
