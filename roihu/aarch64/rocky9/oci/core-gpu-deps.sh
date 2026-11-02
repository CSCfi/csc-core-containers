#!/usr/bin/env bash
set -eu

CONTAINER=$(buildah from docker://rockylinux/rockylinux:9.8)
ROOTFS=$(buildah mount $CONTAINER)

rsync --archive --mkpath /etc/yum.repos.d/AppStream.repo $ROOTFS/etc/yum.repos.d/AppStream.repo
rsync --archive --mkpath /etc/yum.repos.d/BullSequana.repo $ROOTFS/etc/yum.repos.d/BullSequana.repo
rsync --archive --mkpath /etc/yum.repos.d/BaseOS.repo $ROOTFS/etc/yum.repos.d/BaseOS.repo
rsync --archive --mkpath /etc/yum.repos.d/codeready-builder.repo $ROOTFS/etc/yum.repos.d/codeready-builder.repo
rsync --archive --mkpath /etc/yum.repos.d/bull-extra.repo $ROOTFS/etc/yum.repos.d/bull-extra.repo
rsync --archive --mkpath /etc/yum.repos.d/CSC_general.repo $ROOTFS/etc/yum.repos.d/CSC_general.repo
rsync --archive --mkpath /etc/yum.repos.d/epel.repo $ROOTFS/etc/yum.repos.d/epel.repo
rsync --archive --mkpath /etc/yum.repos.d/doca.repo $ROOTFS/etc/yum.repos.d/doca.repo
rsync --archive --mkpath /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release $ROOTFS/etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
rsync --archive --mkpath /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-9 $ROOTFS/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-9
rsync --archive --mkpath /etc/pki/bull-rpm-gpg/RPM-GPG-KEY-bull-hpc-factory.public $ROOTFS/etc/pki/bull-rpm-gpg/RPM-GPG-KEY-bull-hpc-factory.public
rsync --archive --mkpath /etc/pki/bull-rpm-gpg/RPM-GPG-KEY-eviden-bds-factory.public $ROOTFS/etc/pki/bull-rpm-gpg/RPM-GPG-KEY-eviden-bds-factory.public

rsync --archive --mkpath /usr/lib64/liblnetconfig.a $ROOTFS/usr/lib64/liblnetconfig.a
rsync --archive --mkpath /usr/lib64/liblnetconfig.so.4.0.0 $ROOTFS/usr/lib64/liblnetconfig.so.4.0.0
rsync --archive --mkpath /usr/lib64/liblnetconfig.so.4 $ROOTFS/usr/lib64/liblnetconfig.so.4
rsync --archive --mkpath /usr/lib64/liblnetconfig.so $ROOTFS/usr/lib64/liblnetconfig.so
rsync --archive --mkpath /usr/lib64/liblustreapi.a $ROOTFS/usr/lib64/liblustreapi.a
rsync --archive --mkpath /usr/lib64/liblustreapi.so.1.0.0 $ROOTFS/usr/lib64/liblustreapi.so.1.0.0
rsync --archive --mkpath /usr/lib64/liblustreapi.so.1 $ROOTFS/usr/lib64/liblustreapi.so.1
rsync --archive --mkpath /usr/lib64/liblustreapi.so $ROOTFS/usr/lib64/liblustreapi.so
rsync --archive --mkpath /opt/pmix/5.0.7 $ROOTFS/opt/pmix
rsync --archive --mkpath /opt/knem-1.1.4.91mlnx1 $ROOTFS/opt

buildah run $CONTAINER -- update-crypto-policies --set LEGACY
buildah run $CONTAINER -- dnf update -y
buildah run $CONTAINER -- dnf install -y --allowerasing \
    glibc \
    glibc-devel \
    m4 \
    openssl \
    openssl-devel \
    make \
    sed \
    diffutils \
    coreutils \
    autoconf \
    gawk \
    automake \
    binutils \
    gettext \
    gettext-devel \
    groff \
    tar \
    curl \
    libcurl-devel \
    cyrus-sasl-gssapi \
    openldap \
    libnghttp2 \
    cmake \
    openssh \
    pkgconf \
    findutils \
    git \
    libevent \
    libevent-devel \
    rdma-core \
    rdma-core-devel \
    Lmod \
    gdrcopy \
    gdrcopy-devel

buildah run $CONTAINER -- sed -i 's/^enabled = 1/enabled = 0/' /etc/yum.repos.d/AppStream.repo
buildah run $CONTAINER -- sed -i 's/^enabled = 1/enabled = 0/' /etc/yum.repos.d/BullSequana.repo
buildah run $CONTAINER -- sed -i 's/^enabled = 1/enabled = 0/' /etc/yum.repos.d/BaseOS.repo
buildah run $CONTAINER -- sed -i 's/^enabled = 1/enabled = 0/' /etc/yum.repos.d/codeready-builder.repo
buildah run $CONTAINER -- sed -i 's/^enabled = 1/enabled = 0/' /etc/yum.repos.d/bull-extra.repo
buildah run $CONTAINER -- sed -i 's/^enabled = 1/enabled = 0/' /etc/yum.repos.d/CSC_general.repo
buildah run $CONTAINER -- sed -i 's/^enabled = 1/enabled = 0/' /etc/yum.repos.d/epel.repo
buildah run $CONTAINER -- sed -i 's/^enabled = 1/enabled = 0/' /etc/yum.repos.d/doca.repo

buildah unmount $CONTAINER

buildah commit --squash $CONTAINER localhost/core-gpu-deps:v2026_03

buildah tag localhost/core-gpu-deps:v2026_03 satama.csc.fi/r_installation_spack/core-gpu-deps:v2026_03
