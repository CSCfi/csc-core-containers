#!/usr/bin/env bash
set -eu

CONTAINER=$(buildah from docker://rockylinux/rockylinux:9.8)
ROOTFS=$(buildah mount $CONTAINER)
trap 'buildah unmount "$CONTAINER" >/dev/null 2>&1 || true' EXIT

REPOS=(AppStream BullSequana BaseOS codeready-builder bull-extra CSC_general epel doca)
for r in "${REPOS[@]}"; do
    rsync --archive --mkpath /etc/yum.repos.d/$r.repo $ROOTFS/etc/yum.repos.d/$r.repo
done
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
    Lmod

for r in "${REPOS[@]}"; do
    buildah run $CONTAINER -- sed -i 's/^enabled = 1/enabled = 0/' /etc/yum.repos.d/$r.repo
done

chmod -R u+w $ROOTFS
chown -Rh 0:0 $ROOTFS

buildah unmount $CONTAINER

buildah commit --squash $CONTAINER satama.csc.fi/r_installation_spack/core-cpu-deps:v2026_03

