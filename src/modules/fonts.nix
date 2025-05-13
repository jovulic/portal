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

        # Link the main fonts.conf file.
        ln -sf "${pkgs.fontconfig.out}/etc/fonts/fonts.conf" /etc/fonts/fonts.conf

        # Link the conf.d directory, which contains various font configuration
        # snippets. This is crucial for default system-wide font
        # configurations.
        ln -sf "${pkgs.fontconfig.out}/etc/fonts/conf.d" /etc/fonts/conf.d

        # Setup font cache.
        mkdir -p /var/cache/fontconfig

        # Ensure font cache is up-to-date after all files are in place.
        # /etc/fonts/fonts.conf should be present from pkgs.fontconfig.
        if [ -d /usr/share/fonts ]; then
          echo "Updating font cache..."
          fc-cache -frsv
        else
          echo "No /usr/share/fonts directory found, skipping fc-cache."
        fi
      '';
    };
  };

}
