{ config, lib, pkgsUnstable, ... }:
let

in
{
  home = {
    shellAliases = {
      xpraHtml5Start="xpra start :100 --start=xterm --bind-tcp=0.0.0.0:10000 --html=${pkgsUnstable.xpraHtml5}/share/xpra/www/ --daemon=no --debug=all --log-file=/tmp/xpra.log";
      #windows10_install="qemu-img create ${path_windows_raw} 70G | sudo qemu-system-x86_64 -m 16G -cpu host -smp sockets=1,cores=4,threads=4 -cdrom ${path_windows_iso} -drive file=${path_windows_raw},format=raw -enable-kvm -nic mac=${mac_alloc} -rtc base=2023-05-29T09:30:11";
      #windows10_wo_network="sudo qemu-system-x86_64 -m 16G -cpu host -smp sockets=1,cores=4,threads=4 -drive file=${path_windows_raw},format=raw -enable-kvm -nic none";
      #windows10_mac_fixed="sudo qemu-system-x86_64 -m 16G -cpu host -smp sockets=1,cores=4,threads=4 -drive file=${path_windows_raw},format=raw -enable-kvm -device e1000,mac=${mac_alloc}";
      #windows10="sudo qemu-system-x86_64 -m 16G -cpu host -smp sockets=1,cores=4,threads=4 -drive file=${path_windows_raw},format=raw -enable-kvm";
      #windows10_R_fixed="sudo qemu-system-x86_64 -m 16G -cpu host -smp sockets=1,cores=4,threads=4 -drive file=${path_windows_R_raw},format=raw -enable-kvm -device e1000,mac=${mac_alloc}";
      #windows10="sudo qemu-system-x86_64 -m 16G -cpu host -smp sockets=1,cores=4,threads=4 -drive file=${path_windows_raw},format=raw -enable-kvm -netdev user,id=net0,net=${ip_alloc} -device e1000,netdev=net0";
      #windows10_full="sudo qemu-system-x86_64 -m 25G -cpu host -smp sockets=1,cores=6,threads=6 -drive file=${path_windows_raw},format=raw -enable-kvm";
    };
  };
}

# mouse cursor release: ctrl + alt +g
# quit: ctrl + alt + q
# https://github.com/syryuauros/Memo/blob/main/RoamNotes/20230302093553-qemu.org
# https://truesale.tistory.com/entry/%EC%9C%88%EB%8F%84%EC%9A%B0-10-%ED%8C%81-%EB%AC%B4%EB%A3%8C%EB%A1%9C-%EC%A0%95%ED%92%88-%EC%9D%B8%EC%A6%9D%ED%95%98%EB%8A%94-%EB%B0%A9%EB%B2%95
# storage(hard-disk) making: $ qemu-img create windows.raw 200G install windows10 : $ sudo qemu-system-x86_64 -m 4G -cpu host -smp sockets=1,cores=2,threads=2 -cdrom /home/auros/Downloads/Win10_22H2_Korean_x64.iso -drive file=windows.raw,format=raw -enable-kvm run VM win10 installed : $ sudo qemu-system-x86_64 -m 16G -cpu host -smp sockets=1,cores=4,threads=4 -drive file=windows.raw,format=raw -enable-kvm
## https://wiki.qemu.org/Documentation/Networking
## https://android.googlesource.com/platform/external/qemu/+/aca144a9e9264b11c2d729096af90d695d01455d/qemu-options.def
## https://github.com/zephyrproject-rtos/zephyr/issues/14173
## nic means network interface card
# pkgs list

# qemu
# qemu_kvm
# libvirt
# virt-manager
