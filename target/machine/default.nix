{
  nixpkgs,
  lib,
  system,
  microvm,
  ...
}:
nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    microvm.nixosModules.microvm
    {
      microvm = {
        hypervisor = "qemu";
        graphics.enable = true;
        vcpu = 4;
        mem = 4096;
        interfaces = [
          {
            type = "user";
            id = "lo";
            mac = "02:00:00:00:00:01"; # "02" means locally administered address.
          }
        ];
        forwardPorts = [
          {
            from = "host";
            host.port = 8080;
            guest.port = 8080;
          }
        ];
        storeDiskType = "squashfs";
      };

      hardware.graphics.enable = true;

      networking = {
        firewall = {
          allowedTCPPorts = [
            8080
          ];
        };
      };

      users = {
        users.pilot = {
          extraGroups = [
            "wheel"
            "video"
          ];
        };
      };

      security.sudo = {
        enable = true;
        wheelNeedsPassword = false;
      };

      programs.neovim = {
        enable = true;
        defaultEditor = true;
        vimAlias = true;
        viAlias = true;
      };

      system.stateVersion = lib.trivial.release;
    }
    (
      { pkgs, ... }:
      {
        # Setup baseline host.
        networking.hostName = "waypoint";

        users = {
          users.pilot = {
            isNormalUser = true;
            group = "user";
            initialPassword = "password";
          };
          groups = {
            user = { };
          };
        };
        services.getty.autologinUser = "pilot";

        services.xserver = {
          enable = true;
          desktopManager.plasma5.enable = true;
        };

        services.displayManager = {
          enable = true;
          sddm.enable = true;
          autoLogin.user = "pilot";
        };

        # Setup xrdp.
        services.xrdp = {
          enable = true;
          defaultWindowManager = "${pkgs.dbus}/bin/dbus-run-session ${pkgs.plasma-workspace}/bin/startplasma-x11";
          openFirewall = true;
        };

        # Setup guacamole.
        services.guacamole-server = {
          enable = true;
          # You can get the password hash using the following command.
          # echo -n <password> | openssl dgst -sha256
          userMappingXml = pkgs.writeTextFile {
            name = "user-mapping.xml";
            text = ''
              <?xml version="1.0" encoding="UTF-8"?>
              <user-mapping>
                  <authorize
                      username="pilot"
                      password="5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8"
                      encoding="sha256">

                      <connection name="NixOS Server SSH">
                          <protocol>ssh</protocol>
                          <param name="hostname">127.0.0.1</param>
                          <param name="port">22</param>
                      </connection>

                    <connection name="NixOS Server RDP">
                        <protocol>rdp</protocol>
                        <param name="hostname">127.0.0.1</param>
                        <param name="port">3389</param>
                        <param name="ignore-cert">true</param>
                    </connection>
                  </authorize>
              </user-mapping>
            '';
          };
        };
        services.guacamole-client = {
          enable = true;
        };
      }
    )
  ];
}
