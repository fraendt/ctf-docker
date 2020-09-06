FROM kalilinux/kali-rolling
# Importing from kali linux: only because kali has an easy desktop setup (just run "gui" and then connect with vnc)

# Adding all the command line tools that will be exported for easy aliasing

ADD /tol /tol/

# Change directory to ~

WORKDIR /root

# Allow for prompts for keyboard selection to be skipped

ENV DEBIAN_FRONTEND = noninteractive

# Installing all basic apt libraries along with python, pip, and a display



RUN apt-get update --fix-missing && \
    apt-get install -y dirmngr gnupg apt-transport-https ca-certificates software-properties-common && \
    apt-get install -y sudo make vim curl wget nmap zip unzip steghide foremost binutils exiftool tcpdump file gdb netcat ssh \
    nasm gcc gcc-multilib libc6-dbg zsh ltrace strace cmake radare2 socat ruby tmux p7zip hashcat nano && \
    apt install -y git-all && \
    apt install -y kali-desktop-xfce && \
    apt install -y tightvncserver && \
    apt-get install -y python-dev python3 python3-pip && curl https://bootstrap.pypa.io/get-pip.py --output get-pip.py && python2 get-pip.py && rm get-pip.py && \
    apt-get install -y openjdk-11-jdk && \
    apt-get install -y build-essential && \
    apt-get install -y nasm && \
    apt-get install -y libgmp3-dev && \
    apt-get install -y libgmp-dev && \
    apt-get install -y libmpfr-dev && \
    apt-get install -y libmpc-dev && \
    apt-get install -y gobuster && \
    apt-get install -y nikto && \
    apt-get install -y sqlmap openvpn && \
    apt-get install -y telnet volatility php && \
    apt-get install -y ruby-full && apt-get install -y rawtherapee && apt-get install -y hexedit && apt-get install -y wxhexeditor

# Installing basic python libraries, ruby libraries, and rust

RUN pip3 install --upgrade pip && python -m pip install --upgrade pip && \
    pip3 install --no-cache-dir pwntools && python -m pip install --no-cache-dir pwntools && \
    pip3 install --no-cache-dir six==1.11.0 && python -m pip install --no-cache-dir six==1.11.0 && \
    pip3 install --no-cache-dir sympy==1.3 && python -m pip install --no-cache-dir sympy==1.3 && \
    pip3 install --no-cache-dir cryptography==2.8 && python -m pip install --no-cache-dir cryptography==2.8 && \
    pip3 install --no-cache-dir urllib3==1.24.2 && python -m pip install --no-cache-dir urllib3==1.24.2 && \
    pip3 install --no-cache-dir requests==2.20.0 && python -m pip install --no-cache-dir requests==2.20.0 && \
    pip3 install --no-cache-dir gmpy==1.17 && \
    pip3 install --no-cache-dir pyzmq==17.0.0 && python -m pip install --no-cache-dir pyzmq==17.0.0 && \
    pip3 install --no-cache-dir jupyter && python -m pip install --no-cache-dir jupyter && \
    pip3 install --no-cache-dir pwncat && python -m pip install --no-cache-dir pwncat && \
    pip3 install --no-cache-dir gmpy2==2.0.8 &&  \
    pip3 install --no-cache-dir pycryptodome==3.9.7 && python -m pip install --no-cache-dir pycryptodome==3.9.7 && \
    pip3 install --no-cache-dir bs4 && python -m pip install --no-cache-dir bs4 && \
    pip3 install --no-cache-dir angr && \
    pip3 install --no-cache-dir numpy && python -m pip install --no-cache-dir numpy && \
    python3 -m pip install ciphey --upgrade && \
    gem install one_gadget && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    curl https://sh.rustup.rs -sSf | bash -s -- -y

# Installing ctftools that are only available on git such as rsactftool and gittools

RUN cd ../tol/ && wget https://ghidra-sre.org/ghidra_9.1.2_PUBLIC_20200212.zip && unzip ghidra_9.1.2_PUBLIC_20200212.zip && rm -f ghidra_9.1.2_PUBLIC_20200212.zip && \
    git clone https://github.com/Ganapati/RsaCtfTool rsactftool_ && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting && \
    git clone https://github.com/internetwache/GitTools && \
    git clone https://github.com/EvilMuffinHa/ctftool ctftool_ && \
    git clone https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite peass && \
    git clone https://github.com/Z3Prover/z3 z3_ && cd z3_ && python scripts/mk_make.py && cd build && make && make install

# Installing sublime text

#RUN apt-get update && cd ../tol/ && curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add - && \
#    add-apt-repository "deb https://download.sublimetext.com/ apt/stable/" && \
#    apt install -y sublime-text


# Install nvm with node and npm

RUN export NVM_DIR="$HOME/.nvm" && ( git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR" && cd "$NVM_DIR" && git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`) && \. "$NVM_DIR/nvm.sh" && export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && nvm install node && npm install pure-prompt

# Loading syntax highlighting and pure-prompt

RUN cd ../tol && touch ~/.zshrc && echo 'export NVM_DIR="$HOME/.nvm"\n[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"\n[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"\n' > ~/.zshrc && \
    echo "autoload -U promptinit; promptinit\nprompt pure\nunsetopt PROMPT_SP\nsource /tol/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc

# Installing hyper for better command copy + paste, larger text, and keyboard shortcuts

RUN cd ../tol && wget -O hyper.AppImage "https://releases.hyper.is/download/AppImage" && chmod +x "hyper.AppImage" && ./"hyper.AppImage" --appimage-extract && \
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && cat vimrc.txt >> ~/.vimrc && \
    touch ~/.gdbinit && echo "set disassembly-flavor intel\nset follow-fork-mode child" >> ~/.gdbinit

# Exporting all paths to the dotfiles, installing gef, and installing rustscan

RUN printf "\n export PATH=\"/tol:/root/.cargo/bin:$PATH\"\n export LC_CTYPE=C.UTF-8\n export USER=root" >> .bashrc && \
    printf "\n export PATH=\"/tol:/root/.cargo/bin:$PATH\"\n export LC_CTYPE=C.UTF-8\n export USER=root" >> .zshrc && \
    chmod +x /tol/* && sh -c "$(curl -fsSL http://gef.blah.cat/sh)" && \
    /bin/bash -c 'source ~/.cargo/env && cargo install rustscan' && \
    chsh -s /bin/zsh

# Adding paths for nvm and rust

ENV PATH="/root/.cargo/bin:${PATH}"
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/v$NODE_VERSION/bin:$PATH

# 100% installing rustscan

RUN cargo install rustscan

# Boom run

CMD ["/bin/zsh"]