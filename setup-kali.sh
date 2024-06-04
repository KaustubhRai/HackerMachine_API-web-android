#!/bin/bash

# Tools installation commands
android_commands=(
  "sudo apt-get install -y default-jdk"
  "sudo apt-get install -y jadx"
  "sudo apt-get install -y adb"
  "git clone https://github.com/MobSF/Mobile-Security-Framework-MobSF.git"
  "python3 -m venv Mobile-Security-Framework-MobSF"
  "cd Mobile-Security-Framework-MobSF && source ./bin/activate && ./setup && ./run"
  "mkdir mvt && python3 -m venv mvt && cd mvt && source ./bin/activate && pip install mvt && ./bin/mvt-android-iocs"
  "wget https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool && wget https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.6.1.jar -O apktool.jar && sudo mv apktool apktool.jar /usr/local/bin/ && sudo chmod +x /usr/local/bin/apktool /usr/local/bin/apktool.jar"
  "mkdir frida && python3 -m venv frida && cd frida && source ./bin/activate && pip3 install frida frida-tools && git clone https://github.com/NickstaDB/patch-apk"
)

web_commands=(
  "sudo apt-get install -y burpsuite"
  "sudo apt-get install -y zaproxy"
  "sudo apt-get install -y nuclei"
  "sudo apt-get install -y wpscan"
  "sudo apt-get install -y cmseek"
)

api_commands=(
  "sudo apt-get install -y mitmproxy mitmweb"
  "sudo wget https://dl.pstmn.io/download/latest/linux64 -O postman-linux-x64.tar.gz && tar -xvf postman-linux-x64.tar.gz && sudo ln -s $(pwd)/Postman/Postman /usr/bin/postman"
  "sudo git clone https://github.com/ticarpi/jwt_tool && python3 -m venv jwt_tool && cd jwt_tool && source ./bin/activate && python3 -m pip install termcolor cprint pycryptodomex requests && chmod +x jwt_tool.py"
  "mkdir mitmproxy2swagger && python3 -m venv mitmproxy2swagger && cd mitmproxy2swagger && source ./bin/activate && pip3 install mitmproxy2swagger"
  "git clone https://github.com/assetnote/kiterunner.git && python3 -m venv kiterunner && cd kiterunner && source ./bin/activate && make build && cd routes && wget -r --no-parent -R 'index.html*' https://wordlists-cdn.assetnote.io/data/ -nH -e robots=off"
)

# Counters and lists
total_tools=0
installed_count=0
skipped_count=0
failed_count=0
installed_tools=()
skipped_tools=()
failed_tools=()

# Function to install tools
install_tools() {
  local commands=("$@")
  for cmd in "${commands[@]}"; do
    tool=$(echo "$cmd" | awk '{print $4}')
    total_tools=$((total_tools + 1))
    if command -v $tool &> /dev/null; then
      echo "$tool is already installed."
      skipped_count=$((skipped_count + 1))
      skipped_tools+=("$tool")
    else
      echo "Installing $tool..."
      eval $cmd
      if [ $? -eq 0 ]; then
        installed_count=$((installed_count + 1))
        installed_tools+=("$tool")
      else
        echo "Failed to install $tool."
        failed_count=$((failed_count + 1))
        failed_tools+=("$tool")
      fi
    fi
  done
}

# Update package list
echo "Updating package list..."
sudo apt-get update

# Install Android tools
echo "Installing Android tools..."
install_tools "${android_commands[@]}"

# Install Web tools
echo "Installing Web tools..."
install_tools "${web_commands[@]}"

# Install API tools
echo "Installing API tools..."
install_tools "${api_commands[@]}"

# Summary
echo "Installation Summary:"
echo "Total tools to be installed: $total_tools"
echo "Successfully installed: $installed_count"
echo "Already installed (skipped): $skipped_count"
echo "Failed to install: $failed_count"

echo "Installed tools: ${installed_tools[@]}"
echo "Skipped tools: ${skipped_tools[@]}"
echo "Failed tools: ${failed_tools[@]}"
