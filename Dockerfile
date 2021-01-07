FROM alpine AS clone-vim
RUN apk --update add git less openssh && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/cache/apk/*
RUN apk --no-cache add curl
RUN git clone https://github.com/vim/vim.git
RUN curl -fLo /autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

FROM ubuntu AS compile-vim
COPY --from=clone-vim /vim /vim
WORKDIR /vim
RUN ln -snf /usr/share/zoneinfo/UTC /etc/localtime
RUN apt-get update && \
    apt-get install libncurses5-dev cmake python3-dev liblua50-dev libperl-dev ruby-dev -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
RUN ./configure --with-features=huge  \
    --enable-multibyte  \
    --enable-rubyinterp  \
    --enable-python3interp  \
    --enable-perlinterp  \
    --enable-luainterp  \
    --enable-cscope --prefix=/usr
RUN make
RUN DESTDIR=/vimbin make install

FROM ubuntu AS vim-plugins
COPY --from=compile-vim /vimbin/usr /usr
COPY --from=clone-vim /autoload /etc/vim/autoload
COPY vimrc /.vimrc
RUN apt-get update && \
    apt-get install libsm6 libxt6 libxtst6 python3 python3-dev python3-pip ruby-dev perl liblua50 git -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pip3 install pynvim
RUN vim -E -s -c "source /.vimrc" -c PlugInstall -c qa && \
    find /etc/vim -type d -name .git | xargs rm -rf

FROM ubuntu
ENV TERM=xterm-256color
ENV VIMINIT=/.vimrc
COPY --from=compile-vim /vimbin/usr /usr
COPY vimrc /.vimrc
COPY --from=vim-plugins /etc/vim /etc/vim
RUN ln -snf /usr/share/zoneinfo/UTC /etc/localtime
RUN apt-get update && \
    apt-get install ctags libsm6 libxt6 libxtst6 \
    python3 python3-dev python3-pip ruby-dev perl liblua50 nodejs git -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pip3 install pynvim

VOLUME /vim
WORKDIR /vim

ENTRYPOINT ["vim", "-u", "/.vimrc"]
