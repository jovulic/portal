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

        # Setup DejaVu fonts.
        mkdir -p /usr/share
        ln -sf "${pkgs.dejavu_fonts.out}/share/fonts" /usr/share/fonts

        # Setup font cache.
        fc-cache -frsv
      '';
    };
  };

}
