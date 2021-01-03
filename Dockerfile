FROM alpine AS clone-vim
RUN apk --update add git less openssh && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/cache/apk/*
RUN git clone https://github.com/vim/vim.git
RUN git clone https://github.com/VundleVim/Vundle.vim.git

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
COPY --from=clone-vim /Vundle.vim /root/.vim/bundle/Vundle.vim
COPY vimrc /root/.vimrc
RUN apt-get update && \
    apt-get install libsm6 libxt6 libxtst6 python3 python3-dev ruby-dev perl liblua50 git -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
RUN vim -E -s -c "source /root/.vimrc" -c PluginInstall -c qa && \
    find /root/.vim -type d -name .git | xargs rm -rf

FROM ubuntu
ENV TERM=xterm-256color
COPY --from=compile-vim /vimbin/usr /usr
COPY vimrc /root/.vimrc
COPY --from=vim-plugins /root/.vim /root/.vim
RUN apt-get update && \
    apt-get install libsm6 libxt6 libxtst6 python3 python3-dev ruby-dev perl liblua50 git -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["bash"]
