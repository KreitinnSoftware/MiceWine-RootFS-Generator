name: Build and Release MiceWine RootFS

on:
  push:
    branches: "*"
  workflow_dispatch:

jobs:
  build:

    runs-on: ubuntu-latest

    steps:

    - name: "Install ArchLinux"
      run: |
        sudo apt update
        sudo apt install -y arch-install-scripts wget
        sudo mkdir -p /mnt/

        wget https://geo.mirror.pkgbuild.com/iso/latest/archlinux-bootstrap-x86_64.tar.zst

        sudo tar -xf archlinux-bootstrap-x86_64.tar.zst
        sudo rm -f archlinux-bootstrap-x86_64.tar.zst
        sudo mv root.x86_64 /mnt/arch

        sudo arch-chroot /mnt/arch bash -c "pacman-key --init && pacman-key --populate && sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist && sed -i "s/CheckSpace/#CheckSpace/g" /etc/pacman.conf && pacman -Syu --noconfirm base base-devel git cmake meson ninja bison flex python-pip wget python-mako python-pyyaml unzip 7zip glslang glib2-devel python-docutils xmlto fop libxslt python-docutils"

    - name: "Checkout Repository"
      uses: actions/checkout@v4
      with:
        fetch-depth: 0

    - name: "Copy Repository to Chroot"
      run: |
        sudo cp -rf $PWD /mnt/arch/MiceWine-RootFS-Generator

    - name: "Download Latest Release Rat Packages"
      run: |
        curl -LO# https://github.com/KreitinnSoftware/MiceWine-RootFS-Generator/releases/download/$(curl -s https://api.github.com/repos/KreitinnSoftware/MiceWine-RootFS-Generator/releases | grep tag_name -m 1 | cut -d ":" -f 2 | sed "s/\"//g" | sed "s/,//g" | sed "s/ //g")/MiceWine-Packages.zip || true
        sudo unzip -o MiceWine-Packages.zip -d /mnt/arch/MiceWine-RootFS-Generator/built-pkgs || true
        rm -f MiceWine-Packages.zip

    - name: "Setup Basic Android (x86_64) Runtime Environment (Required for Building x86_64 glib)"
      run: |
        git clone https://github.com/termux/termux-docker.git
        sudo cp -rf termux-docker/system/x86 /mnt/arch/system
        sudo chown -R $(whoami):$(whoami) /mnt/arch/system
        sudo chmod 755 -R /mnt/arch/system

    - name: "Start Building (x86_64)"
      run: |
        sudo arch-chroot /mnt/arch bash -c "cd /MiceWine-RootFS-Generator && ./build-all.sh x86_64 --ci && cd logs && 7z a /MiceWine-RootFS-$(git rev-parse --short HEAD)-x86_64-Logs.zip"

    - name: "Create RootFS File (x86_64)"
      run: |
        sudo arch-chroot /mnt/arch bash -c "cd /MiceWine-RootFS-Generator && ./create-rootfs-rat.sh x86_64 && mv MiceWine-RootFS-\($(git rev-parse --short HEAD)\)-x86_64.rat /MiceWine-RootFS-$(git rev-parse --short HEAD)-x86_64.rat"

    - name: "Clean (x86_64) RootFS"
      run: |
        sudo rm -rf /mnt/arch/data /mnt/arch/MiceWine-RootFS-Generator/workdir /mnt/arch/MiceWine-RootFS-Generator/rootfs

    - name: "Start Building (aarch64)"
      run: |
        sudo arch-chroot /mnt/arch bash -c "cd /MiceWine-RootFS-Generator && ./build-all.sh aarch64 --ci && cd logs && 7z a /MiceWine-RootFS-$(git rev-parse --short HEAD)-aarch64-Logs.zip"

    - name: "Create RootFS File (aarch64)"
      run: |
        sudo arch-chroot /mnt/arch bash -c "cd /MiceWine-RootFS-Generator && ./create-rootfs-rat.sh aarch64 && mv MiceWine-RootFS-\($(git rev-parse --short HEAD)\)-aarch64.rat /MiceWine-RootFS-$(git rev-parse --short HEAD)-aarch64.rat"

    - name: "Save Rat Packages"
      run: |
        sudo arch-chroot /mnt/arch bash -c "cd /MiceWine-RootFS-Generator/built-pkgs && 7z a /MiceWine-Packages.zip"

    - name: "Get Short SHA"
      run: |
        echo "SHORT_SHA=$(git rev-parse --short HEAD)" >> $GITHUB_ENV

    - name: "Create Release"
      uses: softprops/action-gh-release@v1
      with:
        name: "MiceWine RootFS (${{ env.SHORT_SHA }})"
        tag_name: ${{ env.SHORT_SHA }}
        prerelease: true
        files: |
          /mnt/arch/*.rat
          /mnt/arch/*.zip
