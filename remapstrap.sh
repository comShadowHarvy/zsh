#!/bin/bash

# Function to display a fake loading bar with random duration between 2 and 15 seconds
loading_bar() {
    bar="##################################################"
    bar_length=${#bar}
    percentage=0

    # Generate a random duration between 2 and 15 seconds
    duration=$((RANDOM % 14 + 2))
    increment=$(awk "BEGIN {print $duration / 100}")

    echo -n "["
    while [ $percentage -lt 100 ]; do
        n=$(($percentage * $bar_length / 100))
        printf "%s" "${bar:0:n}"
        printf "%s" ">"
        printf "%*s" $(($bar_length - $n - 1)) ""
        echo -n "] $percentage% "
        sleep $increment
        percentage=$((percentage + 1))
        echo -ne "\r"
    done
    echo "[${bar}] 100%"
}

echo "Starting setup..."
loading_bar

# Define key ID and keyserver
keyID="3056513887B78AEB"
keyServer="keyserver.ubuntu.com"
echo "Defined key variables."
loading_bar

# Define package URLs
keyringPackageUrl="https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst"
mirrorlistPackageUrl="https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst"
echo "Package URLs defined."
loading_bar

# Update system and install necessary packages
echo "Updating system and installing necessary packages..."
loading_bar
sudo pacman -Sy --noconfirm base-devel git wget curl || { echo "Failed to update system and install packages"; exit 1; }

# Check if zsh is installed
echo "Checking if zsh is installed..."
loading_bar
if ! command -v zsh &> /dev/null; then
    echo "zsh is not installed. Installing zsh..."
    loading_bar
    sudo pacman -S zsh --noconfirm || { echo "Failed to install zsh"; exit 1; }
else
    echo "zsh is already installed."
    loading_bar
fi

# Check if Chaotic AUR is already configured
echo "Checking if Chaotic AUR is already configured..."
loading_bar
if ! grep -q "\[chaotic-aur\]" /etc/pacman.conf; then
    echo "Chaotic AUR is not configured. Setting up Chaotic AUR..."
    loading_bar

    # Receive the key
    echo "Receiving key..."
    loading_bar
    sudo pacman-key --recv-key $keyID --keyserver $keyServer || { echo "Failed to receive key"; exit 1; }

    # Locally sign the key
    echo "Signing key..."
    loading_bar
    sudo pacman-key --lsign-key $keyID || { echo "Failed to sign key"; exit 1; }

    # Install the chaotic keyring package
    echo "Installing the Chaotic AUR keyring package..."
    loading_bar
    sudo pacman -U $keyringPackageUrl --noconfirm || { echo "Failed to install Chaotic AUR keyring package"; exit 1; }

    # Install the chaotic mirrorlist package
    echo "Installing the Chaotic AUR mirrorlist package..."
    loading_bar
    sudo pacman -U $mirrorlistPackageUrl --noconfirm || { echo "Failed to install Chaotic AUR mirrorlist package"; exit 1; }

    # Append Chaotic AUR repo to pacman.conf
    echo "Configuring pacman to use the Chaotic AUR..."
    loading_bar
    echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf > /dev/null || { echo "Failed to configure pacman for Chaotic AUR"; exit 1; }

    # Disable signature verification in pacman.conf
    echo "Disabling signature verification in pacman.conf..."
    loading_bar
    sudo sed -i 's/^SigLevel    = Required DatabaseOptional$/SigLevel = Never/' /etc/pacman.conf || { echo "Failed to disable signature verification"; exit 1; }
else
    echo "Chaotic AUR is already configured."
    loading_bar
fi

# Check if BlackArch is already configured
echo "Checking if BlackArch is already configured..."
loading_bar
if ! grep -q "\[blackarch\]" /etc/pacman.conf; then
    echo "BlackArch is not configured. Setting up BlackArch..."
    loading_bar

    # Download the BlackArch strap.sh script
    echo "Downloading the BlackArch strap.sh script..."
    loading_bar
    wget https://blackarch.org/strap.sh || { echo "Failed to download strap.sh"; exit 1; }
    echo "Making strap.sh executable..."
    loading_bar
    chmod +x strap.sh || { echo "Failed to make strap.sh executable"; exit 1; }

    # Execute the strap.sh script with superuser privileges
    echo "Running strap.sh..."
    loading_bar
    sudo ./strap.sh || { echo "Failed to run strap.sh"; exit 1; }
else
    echo "BlackArch is already configured."
    loading_bar
fi

# Check if paru is installed
echo "Checking if paru is installed..."
loading_bar
if ! command -v paru &> /dev/null; then
    echo "paru is not installed. Cloning and building paru..."
    loading_bar
    git clone https://aur.archlinux.org/paru.git || { echo "Failed to clone paru repository"; exit 1; }
    cd paru
    echo "Building and installing paru..."
    loading_bar
    makepkg -si --noconfirm || { echo "Failed to build and install paru"; exit 1; }
    cd ..
    rm -rf paru
else
    echo "paru is already installed."
    loading_bar
fi

# Install Metasploit
echo "Checking if Metasploit is installed..."
loading_bar
if ! pacman -Q metasploit &> /dev/null; then
    echo "Metasploit is not installed. Installing Metasploit..."
    loading_bar
    sudo pacman -S metasploit --noconfirm || { echo "Failed to install Metasploit"; exit 1; }
else
    echo "Metasploit is already installed."
    loading_bar
fi

# Refresh the package databases and update the system packages
echo "Refreshing package databases and updating system packages..."
loading_bar
sudo pacman -Syu --noconfirm || { echo "Failed to update system packages"; exit 1; }

# Install Pacui from AUR
echo "Checking if Pacui is installed..."
loading_bar
if ! pacman -Q pacui &> /dev/null; then
    echo "Pacui is not installed. Installing Pacui from AUR..."
    loading_bar
    paru -S pacui --noconfirm || { echo "Failed to install Pacui"; exit 1; }
else
    echo "Pacui is already installed."
    loading_bar
fi

# Install Snapd
echo "Checking if Snapd is installed..."
loading_bar
if ! pacman -Q snapd &> /dev/null; then
    echo "Snapd is not installed. Installing Snapd and enabling the service..."
    loading_bar
    sudo pacman -S snapd --noconfirm || { echo "Failed to install Snapd"; exit 1; }
    sudo systemctl enable --now snapd.socket || { echo "Failed to enable Snapd"; exit 1; }
else
    echo "Snapd is already installed."
    loading_bar
fi

# Install Flatpak
echo "Checking if Flatpak is installed..."
loading_bar
if ! pacman -Q flatpak &> /dev/null; then
    echo "Flatpak is not installed. Installing Flatpak..."
    loading_bar
    sudo pacman -S flatpak --noconfirm || { echo "Failed to install Flatpak"; exit 1; }
else
    echo "Flatpak is already installed."
    loading_bar
fi

# Install AppImageLauncher
echo "Checking if AppImageLauncher is installed..."
loading_bar
if ! pacman -Q appimagelauncher &> /dev/null; then
    echo "AppImageLauncher is not installed. Installing AppImageLauncher from AUR..."
    loading_bar
    paru -S appimagelauncher --noconfirm || { echo "Failed to install AppImageLauncher"; exit 1; }
else
    echo "AppImageLauncher is already installed."
    loading_bar
fi

# Install Docker
echo "Checking if Docker is installed..."
loading_bar
if ! pacman -Q docker &> /dev/null; then
    echo "Docker is not installed. Installing Docker..."
    loading_bar
    sudo pacman -S docker --noconfirm || { echo "Failed to install Docker"; exit 1; }
    echo "Enabling and starting Docker service..."
    loading_bar
    sudo systemctl enable --now docker.service || { echo "Failed to enable Docker service"; exit 1; }
else
    echo "Docker is already installed."
    loading_bar
fi

# Create .zsh_files directory if it doesn't exist and download zsh files
if [ ! -d ~/.zsh_files ]; then
    echo "Creating .zsh_files directory and downloading zsh files..."
    loading_bar
    mkdir -p ~/.zsh_files || { echo "Failed to create .zsh_files directory"; exit 1; }
    wget -O ~/.zsh_files/aliases.zsh https://github.com/comShadowHarvy/zsh/raw/master/zsh_files/aliases.zsh || { echo "Failed to download aliases.zsh"; exit 1; }
    wget -O ~/.zsh_files/functions.zsh https://github.com/comShadowHarvy/zsh/raw/master/zsh_files/functions.zsh || { echo "Failed to download functions.zsh"; exit 1; }
    wget -O ~/.zsh_files/git_prompt.zsh https://github.com/comShadowHarvy/zsh/raw/master/zsh_files/git_prompt.zsh || { echo "Failed to download git_prompt.zsh"; exit 1; }
    wget -O ~/.zsh_files/theme_icons.zsh https://github.com/comShadowHarvy/zsh/raw/master/zsh_files/theme_icons.zsh || { echo "Failed to download theme_icons.zsh"; exit 1; }
    wget -O ~/.zsh_files/variables.zsh https://github.com/comShadowHarvy/zsh/raw/master/zsh_files/variables.zsh || { echo "Failed to download variables.zsh"; exit 1; }
else
    echo ".zsh_files directory already exists."
    loading_bar
fi

# Download .aliases file from GitHub if it doesn't already exist
if [ ! -f ~/.aliases ]; then
    echo "Downloading .aliases file from GitHub..."
    loading_bar
    wget -O ~/.aliases https://raw.githubusercontent.com/comShadowHarvy/zsh/master/.aliases || { echo "Failed to download .aliases file"; exit 1; }
else
    echo ".aliases file already exists."
    loading_bar
fi

# Add chx alias to .aliases if not already present
if ! grep -qxF 'alias chx="chmod +x"' ~/.aliases; then
    echo 'alias chx="chmod +x"' >> ~/.aliases
fi

# Download .wgetrc file from GitHub if it doesn't already exist
if [ ! -f ~/.wgetrc ]; then
    echo "Downloading .wgetrc file from GitHub..."
    loading_bar
    wget -O ~/.wgetrc https://github.com/comShadowHarvy/zsh/raw/master/.wgetrc || { echo "Failed to download .wgetrc file"; exit 1; }
else
    echo ".wgetrc file already exists."
    loading_bar
fi

# Download .extrazshrc file from GitHub if it doesn't already exist
if [ ! -f ~/.extrazshrc ]; then
    echo "Downloading .extrazshrc file from GitHub..."
    loading_bar
    wget -O ~/.extrazshrc https://github.com/comShadowHarvy/zsh/raw/master/.extrazshrc || { echo "Failed to download .extrazshrc file"; exit 1; }
else
    echo ".extrazshrc file already exists."
    loading_bar
fi

# Download .antigenrc file from GitHub if it doesn't already exist
if [ ! -f ~/.antigenrc ]; then
    echo "Downloading .antigenrc file from GitHub..."
    loading_bar
    wget -O ~/.antigenrc https://github.com/comShadowHarvy/zsh/raw/master/.antigenrc || { echo "Failed to download .antigenrc file"; exit 1; }
else
    echo ".antigenrc file already exists."
    loading_bar
fi

# Download .zsh1 file from GitHub if it doesn't already exist
if [ ! -f ~/.zsh1 ]; then
    echo "Downloading .zsh1 file from GitHub..."
    loading_bar
    wget -O ~/.zsh1 https://github.com/comShadowHarvy/zsh/raw/master/.zsh1 || { echo "Failed to download .zsh1 file"; exit 1; }
else
    echo ".zsh1 file already exists."
    loading_bar
fi

# Install Antigen
echo "Checking if Antigen is installed..."
loading_bar
if [ ! -f ~/antigen.zsh ]; then
    echo "Antigen is not installed. Installing Antigen..."
    loading_bar
    curl -L git.io/antigen > ~/antigen.zsh || { echo "Failed to install Antigen"; exit 1; }
else
    echo "Antigen is already installed."
    loading_bar
fi

# Create .api_keys file if it doesn't exist
if [ ! -f ~/.api_keys ]; then
    touch ~/.api_keys || { echo "Failed to create .api_keys file"; exit 1; }
else
    echo ".api_keys file already exists."
    loading_bar
fi

# Add .api_keys to .gitignore if not already done
if [ -f .gitignore ]; then
    grep -qxF '.api_keys' .gitignore || echo '.api_keys' >> .gitignore
else
    echo '.api_keys' > .gitignore
fi

# Add environment variables, Git configuration, and source .aliases, .zsh1, and .api_keys in ~/.zshrc if not already present
echo "Adding environment variables, Git configuration, and sourcing .aliases, .zsh1, and .api_keys to ~/.zshrc..."
loading_bar

# Source .api_keys in .zshrc if not already done
grep -qxF '[ -f ~/.api_keys ] && source ~/.api_keys' ~/.zshrc || echo '[ -f ~/.api_keys ] && source ~/.api_keys' >> ~/.zshrc

# Source .aliases from .zshrc if not already done
grep -qxF '[ -f ~/.aliases ] && source ~/.aliases' ~/.zshrc || echo '[ -f ~/.aliases ] && source ~/.aliases' >> ~/.zshrc

# Source .zsh1 from .zshrc if not already done
grep -qxF '[ -f ~/.zsh1 ] && source ~/.zsh1' ~/.zshrc || echo '[ -f ~/.zsh1 ] && source ~/.zsh1' >> ~/.zshrc

# Source Antigen from .zshrc if not already done
grep -qxF '[ -f ~/antigen.zsh ] && source ~/antigen.zsh' ~/.zshrc || echo '[ -f ~/antigen.zsh ] && source ~/antigen.zsh' >> ~/.zshrc

echo "Setup complete. All selected packages have been installed and configured."
loading_bar

