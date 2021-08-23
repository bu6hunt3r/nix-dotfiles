# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # kernel
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" ];
  virtualisation.libvirtd.enable = true;
  boot.extraModulePackages = [ ];
  hardware.enableAllFirmware = true;

  boot.initrd.luks.devices."enc-pv".device = "/dev/disk/by-uuid/f4931928-2a1c-44b7-a40b-4f6bfabd4739";

  
  # Enable sound.
  sound.enable = true;

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/f6f9a0f7-4716-4039-8063-0acf0fc7e9ff";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/8FA6-B8B6";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/a09ac8de-5850-4873-a49f-bef1309db12a"; }
    ];

  hardware = {

    #sound
    pulseaudio.package = pkgs.pulseaudioFull;
    pulseaudio.enable = true;

   #graphics
   opengl = {
     driSupport32Bit = true;
     enable = true;
     extraPackages = with pkgs; [
       vaapiIntel
       vaapiVdpau
       libvdpau-va-gl
       intel-media-driver
     ];
   };
  };

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
  };

}
