## IMPORTANT: This is a fork of Ippsec's build, with minimal changes to make it work with Kali instead of Parrot. 

tested on *Kali 2025.4*



** Make sure to pip install ansible, apt has an older copy **

# Instructions
* Start with Kali installation
* sudo apt update && sudo apt full-upgrade -y
* Install Ansible (python3 -m pip install ansible)
* Clone and enter the repo (git clone)
* ansible-galaxy install -r requirements.yml
* Make sure we have a sudo token (sudo whoami)
* ansible-playbook -K main.yml

# Off-Video Changes
* Mate-Terminal Colors, I show how to configure it here (https://www.youtube.com/watch?v=2y68gluYTcc). I just did the steps in that video on my old VM to backup the color scheme, then copied it to this repo.
* Evil-Winrm/Certipy/SharpCollection/CME/Impacket, will make a video for these soon
* Updated BurpSuite Activation. Later versions of ansible would hang if a shell script started a process that didn't die. Put a timeout on the java process

# KALI CHANGES 
* **Package Installations:**
  * Added `golang` package for Go development tools
  * Added Python build dependencies: `build-essential`, `python3-dev`, `libssl-dev`, `pkg-config`, `rustc`, and `cargo` for compiling Python packages with native extensions
  * Removed deprecated `ntpdate` package (replaced by systemd-timesyncd in modern systems)
  * Added GitHub CLI (`gh`) repository and package
* **Terminal Configuration:**
  * Made terminal customization flexible to work with or without MATE terminal (Kali may use different desktop environments)
  * Added xterm-ghostty terminfo entry for proper terminal emulation with Ghostty terminal
* **Modern APT Key Management:** Replaced deprecated `apt-key` with modern keyring management for GitHub CLI repository. Keys are now stored in `/etc/apt/keyrings/` with `signed-by` parameter in repository definitions, following current Debian best practices
* **Docker Installation:** Changed to use Kali-native packages (`docker.io` and `docker-compose-plugin`) instead of Docker CE repositories, ensuring compatibility with both AMD64 and ARM architectures
* **User Variable Fix:** Updated Docker group membership to use `ansible_env.USER` instead of `ansible_user` for better compatibility
* **Playbook Name:** Changed playbook name from "Customizing Parrot" to "Customizing Kali"
