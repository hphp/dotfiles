prompt_install() {
	echo -n "$1 is not installed. Would you like to install it? (y/n) " >&2
	old_stty_cfg=$(stty -g)
	stty raw -echo
	answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
	stty $old_stty_cfg && echo
	if echo "$answer" | grep -iq "^y" ;then
		# This could def use community support
		if [ -x "$(command -v apt)" ]; then
			sudo apt install "$1" -y

		elif [ -x "$(command -v brew)" ]; then
			brew install "$1"

		elif [ -x "$(command -v pkg)" ]; then
			sudo pkg install "$1"

		elif [ -x "$(command -v pacman)" ]; then
			sudo pacman -S "$1"

		elif [ -x "$(command -v pip)" ]; then
			sudo pip -S "$1"

		else
			echo "I'm not sure what your package manager is! Please install $1 on your own and run this deploy script again. Tests for package managers are in the deploy script you just ran starting at line 13. Feel free to make a pull request at https://github.com/parth/dotfiles :)" 
		fi 
	fi
}

check_for_software() {
	echo "Checking to see if $1 is installed"
	if ! [ -x "$(command -v $1)" ]; then
		prompt_install "$1"
	else
		echo "$1 is installed."
	fi
}

check_default_shell() {
	if [ -z "${SHELL##*zsh*}" ] ;then
			echo "Default shell is zsh."
	else
		echo -n "Default shell is not zsh. Do you want to chsh -s \$(which zsh)? (y/n)"
		old_stty_cfg=$(stty -g)
		stty raw -echo
		answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
		stty $old_stty_cfg && echo
		if echo "$answer" | grep -iq "^y" ;then
			chsh -s $(which zsh)
		else
			echo "Warning: Your configuration won't work properly. If you exec zsh, it'll exec tmux which will exec your default shell which isn't zsh."
		fi
	fi
}

echo "We're going to do the following:"
echo "1. Check to make sure you have zsh, vim, and tmux installed"
echo "2. We'll help you install them if you don't"
echo "3. We're going to check to see if your default shell is zsh"
echo "4. We'll try to change it if it's not" 

echo "Let's get started? (y/n)"

apt-get update

old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
	echo 
else
	echo "Quitting, nothing was changed."
	exit 0
fi



check_for_software zsh
echo 
check_for_software vim
echo
check_for_software tmux
echo
check_for_software python
echo
check_for_software python-numpy
echo
wget https://bootstrap.pypa.io/get-pip.py && sudo python get-pip.py
mkdir -p ~/.pip
cp pip.conf ~/.pip/pip.conf
echo
## BELOW is GPU Environment
pip install "mxnet==0.11.0"
pip install --upgrade  mxnet-cu80
echo
check_for_software graphviz
echo
pip install netifaces
echo

apt-get install build-essential autoconf libtool pkg-config python-opengl python-imaging python-pyrex python-pyside.qtopengl idle-python2.7 qt4-dev-tools qt4-designer libqtgui4 libqtcore4 libqt4-xml libqt4-test libqt4-script libqt4-network libqt4-dbus python-qt4 python-qt4-gl libgle3 python-dev libssl-dev

easy_install greenlet

easy_install gevent

pip install netifaces
echo
# for keras.
pip install scipy
echo
pip install pyyaml
echo
check_for_software libhdf5-serial-dev
#pip install h5py
#pip install keras
pip install matplotlib
pip install jinja2
# for keras.
pip install opencv-python
pip install easydict

apt-get install cuda-command-line-tools
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/extras/CUPTI/lib64
pip install tensorflow-gpu
apt-get install python-numpy python-dev python-wheel python-mock python-protobuf
apt-get install net-tools
apt-get install libjpeg62
pip install conda
apt-get install python-skimage 
pip install tensorboard==1.0.0a6

apt-get install sysstat -y
ssh-keygen -t rsa -C "hanjiatong@didichuxing.com" -b 4096
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDwDt2OeOcV2C8DM8ddgEKmV1c+b8/ss7Hmi4ItDoSXRKG13Cfsd5nc7D1WgY6RWar9ESlkr853owC7Xwo4oQOoA4jBZuX7G/WshX0YspKDq6NxO6pMHp45xWU07M9gbmMVb4W6M0D5wFgQ88Rlxn/FSgj4r+53Rib6/QifrjOi9QjVfAg13Ilap1h4/0zixSDQdDgHprYEf5Zq84GicMGdGBg6pNYkrC+9UTqbDkLMHDaaABUtjjZgcgcKvyQxVQXLTIPIW3tWROsD9dAJvEx/r3Y3JLQHVUfcuUFzfrn/EoCRlOE9pogE+qnRqyn5nfuLTRaAaey3I4vxOlkq0kVPAPpDLAwuZJFLOiG2lkMaRecOd5Xuus4KwqTVGO+EGsGj/O/mLz4+EhXxz3an5RqMb/XmeTl35hd3q9Nc9VL5XfxwezWhfFU4rYNZ8TB1MoF5WRU6B/SB3V3bi9Z7FTkuCrkLjAm0ZCueWZEQ2REV003FZYi63BDrNZzcru4fCZaWbK9wTafLhKvOwxj3Vzj70Eo3lep7BoZ6N9kKzsKVFFMG9mGjUOuWCad+oMa8rt62ZVvmtF9+HY0ZPO7GEBWQHkPbGZIjxRZrWyuLYYUm2/PrP2UwK6n4TYeL2i5fu2iD2JdBBKdvveV54HH8E+0BGZyux2aVRjW4oUPaXne0nQ== hanjiatong@didichuxing.com" >> ~/.ssh/authorized_keys
#chsh -s $(which bash)
#check_default_shell

pip install poster

echo
echo -n "Would you like to backup your current dotfiles? (y/n) "
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
	mv ~/.zshrc ~/.zshrc.old
	mv ~/.tmux.conf ~/.tmux.conf.old
	mv ~/.vimrc ~/.vimrc.old
else
	echo -e "\nNot backing up old dotfiles."
fi

printf "source '$HOME/dotfiles/zsh/zshrc_manager.sh'" > ~/.zshrc
printf "so $HOME/dotfiles/vim/vimrc.vim" > ~/.vimrc
printf "source-file $HOME/dotfiles/tmux/tmux.conf" > ~/.tmux.conf

echo
echo "Please log out and log back in for default shell to be initialized."
