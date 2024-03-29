FROM oraclelinux:8

ENV MYORACLELINUX8DOCKER_VERSION build-target
ENV MYORACLELINUX8DOCKER_VERSION latest
ENV MYORACLELINUX8DOCKER_VERSION stable
ENV MYORACLELINUX8DOCKER_IMAGE myoraclelinux8docker


# set install flag manual page
RUN sed -i -e"s/^tsflags=nodocs/\# tsflags=nodocs/" /etc/yum.conf

# update all packages
RUN dnf update -y && dnf upgrade -y && dnf clean all

# 言語を日本語に設定、これで日本語ファイル名もちゃんと表示される
# https://keep-memory.com/podman-centos8-jp podman centos8の日本語化 - numa blog
RUN dnf -y install glibc-locale-source glibc-langpack-en glibc-langpack-ja && \
    localedef -i ja_JP -f UTF-8 ja_JP.UTF-8 && \
    localedef -i ja_JP -f SHIFT_JIS --no-warnings=ascii ja_JP.SJIS && \
    localedef -i ja_JP -f EUC-JP ja_JP.eucJP && \
    echo 'LANG="ja_JP.UTF-8"' >  /etc/locale.conf && \
    dnf clean all
ENV LANG ja_JP.UTF-8

# set timezone
RUN echo 'ZONE="Asia/Tokyo"' > /etc/sysconfig/clock && \
    rm -f /etc/localtime && \
    ln -fs /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# install man, man-pages
RUN dnf install -y man man-pages && dnf clean all

# install tools
RUN dnf install -y \
        bash-completion \
        bind-utils \
        binutils \
        curl \
        emacs-nox \
        expect \
        gettext \
        git \
        iproute \
        jq \
        lsof \
        make \
        net-tools \
        nmap-ncat \
        openssh-clients \
        openssh-server \
        sudo \
        tar \
        tcpdump \
        traceroute \
        tree \
        unzip \
        vim \
        wget \
        zip \
    && dnf clean all

# upgrade pip
# RUN pip install --upgrade pip

# install nodejs npm
#RUN curl -sL https://rpm.nodesource.com/setup_14.x | bash -
#RUN yum install -y nodejs && npm update -g

# install docker client see https://download.docker.com/linux/static/stable/x86_64/
ARG DOCKERURL=https://download.docker.com/linux/static/stable/x86_64/docker-20.10.9.tgz
RUN curl -fSL "$DOCKERURL" -o docker.tgz \
    && type tar \
    && tar xzvf docker.tgz \
    && mv docker/* /usr/bin/ \
    && rmdir docker \
    && rm docker.tgz \
    && chmod +x /usr/bin/docker 

# install kubectl CLI
RUN echo "" >> /etc/yum.repos.d/kubernetes.repo && \
    echo "[kubernetes]" >> /etc/yum.repos.d/kubernetes.repo && \
    echo "name=Kubernetes" >> /etc/yum.repos.d/kubernetes.repo && \
    echo "baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64" >> /etc/yum.repos.d/kubernetes.repo && \
    echo "enabled=1" >> /etc/yum.repos.d/kubernetes.repo && \
    echo "gpgcheck=1" >> /etc/yum.repos.d/kubernetes.repo && \
    echo "repo_gpgcheck=1" >> /etc/yum.repos.d/kubernetes.repo && \
    echo "gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg" >> /etc/yum.repos.d/kubernetes.repo
# RUN yes | yum search kubectl --showduplicates
# RUN yum install -y kubectl-${KUBECTL_CLIENT_VERSION} && yum clean all
RUN yum install -y kubectl && yum clean all

# install helm CLI
ENV HELM3_VERSION v3.7.2
RUN curl -fLO https://get.helm.sh/helm-${HELM3_VERSION}-linux-amd64.tar.gz && \
    tar xzf  helm-${HELM3_VERSION}-linux-amd64.tar.gz && \
    /bin/cp  linux-amd64/helm   /usr/bin && \
    /bin/cp  linux-amd64/helm   /usr/bin/helm3 && \
    /bin/rm -rf rm helm-${HELM3_VERSION}-linux-amd64.tar.gz linux-amd64

# install kompose v1.18.0
#ENV KOMPOSE_VERSION v1.18.0
#RUN curl -fLO https://github.com/kubernetes/kompose/releases/download/${KOMPOSE_VERSION}/kompose-linux-amd64.tar.gz && \
#    tar xzf kompose-linux-amd64.tar.gz && \
#    chmod +x kompose-linux-amd64 && \
#    mv kompose-linux-amd64 /usr/bin/kompose && \
#    rm kompose-linux-amd64.tar.gz

# install stern
# ENV STERN_VERSION 1.11.0
# RUN curl -fLO https://github.com/wercker/stern/releases/download/${STERN_VERSION}/stern_linux_amd64 && \
#     chmod +x stern_linux_amd64 && \
#     mv stern_linux_amd64 /usr/bin/stern

# install kustomize
# ENV KUSTOMIZE_VERSION 4.4.1
# RUN curl -fLO https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz && \
#     tar xvzf kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz && \
#     mv kustomize /usr/bin/kustomize && \
#     rm kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz

# install kubectx, kubens. see https://github.com/ahmetb/kubectx
# RUN curl -fLO https://raw.githubusercontent.com/ahmetb/kubectx/master/kubectx && \
#     curl -fLO https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens && \
#     chmod +x kubectx kubens && \
#     mv kubectx kubens /usr/local/bin

# install kubeval ( validate Kubernetes yaml file to Kube-API )
# ENV KUBEVAL_VERSION 0.7.3
# RUN curl -fLO https://github.com/garethr/kubeval/releases/download/$KUBEVAL_VERSION/kubeval-linux-amd64.tar.gz && \
#     tar xf kubeval-linux-amd64.tar.gz && \
#     cp kubeval /usr/local/bin && \
#     /bin/rm kubeval-linux-amd64.tar.gz

# install kubetest ( lint kubernetes yaml file )
# ENV KUBETEST_VERSION 0.1.1
# RUN curl -fLO https://github.com/garethr/kubetest/releases/download/$KUBETEST_VERSION/kubetest-linux-amd64.tar.gz && \
#     tar xf kubetest-linux-amd64.tar.gz && \
#     cp kubetest /usr/local/bin && \
#     /bin/rm kubetest-linux-amd64.tar.gz

# install yamlsort see https://github.com/george-pon/yamlsort
ENV YAMLSORT_VERSION v0.1.20
RUN curl -fLO https://github.com/george-pon/yamlsort/releases/download/${YAMLSORT_VERSION}/linux_amd64_yamlsort_${YAMLSORT_VERSION}.tar.gz && \
    tar --version && \
    tar xzf linux_amd64_yamlsort_${YAMLSORT_VERSION}.tar.gz --no-same-owner && \
    chmod +x linux_amd64_yamlsort && \
    mv linux_amd64_yamlsort /usr/bin/yamlsort && \
    rm linux_amd64_yamlsort_${YAMLSORT_VERSION}.tar.gz

ADD docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ADD bashrc /root/.bashrc
ADD bash_profile /root/.bash_profile
ADD emacsrc /root/.emacs
ADD vimrc /root/.vimrc
ADD bin /usr/local/bin
RUN chmod +x /usr/local/bin/*.sh

ENV HOME /root
ENV ENV $HOME/.bashrc

# add sudo user
# https://qiita.com/iganari/items/1d590e358a029a1776d6 Dockerコンテナ内にsudoユーザを追加する - Qiita
# ユーザー名 oracle
# パスワード hogehoge
RUN groupadd -g 1000 oracle && \
    useradd  -g      oracle -G wheel -m -s /bin/bash oracle && \
    echo 'oracle:hogehoge' | chpasswd && \
    echo 'Defaults visiblepw'            >> /etc/sudoers && \
    echo 'oracle ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# use normal user oracle
# USER oracle

CMD ["/usr/local/bin/docker-entrypoint.sh"]

