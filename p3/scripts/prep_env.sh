# PREREQUISITES
echo "install zsh"
sudo apt update
sudo apt install wget curl
sudo apt install git
sudo apt install zsh
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

echo "install linux brew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo '# Set PATH, MANPATH, etc., for Homebrew.' >> /home/$USER/.zprofile
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/$USER/.zprofile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

echo "install docker"
brew install docker
sudo systemctl start docker