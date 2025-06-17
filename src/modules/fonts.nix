{ pkgs, ... }:
{
  container = {
    root = {
      paths = [
        pkgs.fontconfig
        pkgs.dejavu_fonts
      ];
      exec = ''
        echo "Setting up fonts..."

        # Setup font configuration.
        mkdir -p /etc/fonts 
        ln -sf "${pkgs.fontconfig.out}/etc/fonts/fonts.conf" /etc/fonts/fonts.conf
        ln -sf "${pkgs.fontconfig.out}/etc/fonts/conf.d" /etc/fonts/conf.d

        # Setup font cache.
        fc-cache -frsv
      '';
    };
  };

}
