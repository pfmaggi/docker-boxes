FROM ubuntu:xenial

USER root
RUN echo "root:root" | chpasswd

## Repos and dependencies
RUN apt-get -y update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:webupd8team/java
RUN add-apt-repository ppa:pi-rho/dev
RUN add-apt-repository ppa:neovim-ppa/unstable
RUN apt-add-repository ppa:brightbox/ruby-ng
RUN apt-get -y update
RUN apt-get install -y openssh-server sudo git tmux curl tree htop unzip build-essential libncurses-dev libgpm-dev python-software-properties debconf-utils ruby2.2 ruby2.2-dev python-pygments nodejs npm neovim ack-grep rlwrap jq

## Ruby setup
RUN update-alternatives --remove ruby /usr/bin/ruby2.2
RUN update-alternatives --remove irb /usr/bin/irb2.2
RUN update-alternatives --remove gem /usr/bin/gem2.2

RUN update-alternatives \
    --install /usr/bin/ruby ruby /usr/bin/ruby2.2 50 \
    --slave /usr/bin/irb irb /usr/bin/irb2.2 \
    --slave /usr/bin/rake rake /usr/bin/rake2.2 \
    --slave /usr/bin/gem gem /usr/bin/gem2.2 \
    --slave /usr/bin/rdoc rdoc /usr/bin/rdoc2.2 \
    --slave /usr/bin/testrb testrb /usr/bin/testrb2.2 \
    --slave /usr/bin/erb erb /usr/bin/erb2.2 \
    --slave /usr/bin/ri ri /usr/bin/ri2.2

RUN update-alternatives --config ruby
RUN update-alternatives --display ruby
RUN gem install --no-ri --no-rdoc guard guard-rake guard-livereload guard-process guard-shell rb-readline pygments.rb asciidoctor nokogiri

## java setup
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
RUN apt-get install -y oracle-java8-installer

# My home
ENV USERNAME neovim
ENV TERM xterm-color
ENV SHELL /bin/bash
RUN useradd $USERNAME && echo "$USERNAME:$USERNAME" | chpasswd && adduser $USERNAME sudo
RUN mkdir -p /home/$USERNAME && chown -R $USERNAME:$USERNAME /home/$USERNAME
USER $USERNAME

WORKDIR /home/$USERNAME

# neovim install, dot and config
RUN echo "vim goodies."
RUN mkdir -p /home/$USERNAME/.config/nvim
RUN mkdir -p /home/$USERNAME/.vim/bundle/
ADD init.vim /home/$USERNAME/.config/nvim/init.vim
RUN git clone https://github.com/VundleVim/Vundle.vim.git /home/$USERNAME/.vim/bundle/Vundle.vim
RUN nvim +BundleInstall +qall
RUN git clone https://github.com/junegunn/fzf.git
RUN ~/fzf/install --all
RUN mkdir -p /home/$USERNAME/.local/share/nvim/site/spell
ADD spell /home/$USERNAME/.local/share/nvim/site/spell

# lein, boot and clj stuff comment out if you don't care.
USER root
RUN curl https://raw.github.com/technomancy/leiningen/stable/bin/lein >> /usr/local/bin/lein
RUN chmod +x /usr/local/bin/lein
USER $USERNAME
RUN mkdir -p /home/$USERNAME/.lein
COPY lein-profile.clj /home/$USERNAME/.lein/profiles.clj
USER root
RUN chown reborg:reborg /home/$USERNAME/.lein/profiles.clj
RUN bash -c "cd /usr/local/bin && curl -fsSLo boot https://github.com/boot-clj/boot-bin/releases/download/latest/boot.sh && chmod 755 boot"
USER $USERNAME
WORKDIR /home/$USERNAME

USER root
ADD bashrc /home/$USERNAME/.bashrc
RUN chown -R $USERNAME:$USERNAME .bashrc
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

USER $USERNAME
