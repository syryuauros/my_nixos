{
  home = {
    shellAliases = {
      windows10_instatll="qemu-img create windows.raw 200G | sudo qemu-system-x86_64 -m 16G -cpu host -smp sockets=1,cores=4,threads=4 -cdrom /home/auros/Downloads/Win10_22H2_Korean_x64.iso -drive file=windows.raw,format=raw -enable-kvm";
      windows10="sudo qemu-system-x86_64 -m 16G -cpu host -smp sockets=1,cores=4,threads=4 -drive file=windows.raw,format=raw -enable-kvm";
      windows10_full="sudo qemu-system-x86_64 -m 25G -cpu host -smp sockets=1,cores=6,threads=6 -drive file=windows.raw,format=raw -enable-kvm";
    };
  };
}

# https://github.com/syryuauros/Memo/blob/main/RoamNotes/20230302093553-qemu.org
# storage(hard-disk) making: $ qemu-img create windows.raw 200G install windows10 : $ sudo qemu-system-x86_64 -m 4G -cpu host -smp sockets=1,cores=2,threads=2 -cdrom /home/auros/Downloads/Win10_22H2_Korean_x64.iso -drive file=windows.raw,format=raw -enable-kvm run VM win10 installed : $ sudo qemu-system-x86_64 -m 16G -cpu host -smp sockets=1,cores=4,threads=4 -drive file=windows.raw,format=raw -enable-kvm

# pkgs list

# qemu
# qemu_kvm
# libvirt
# virt-manager
