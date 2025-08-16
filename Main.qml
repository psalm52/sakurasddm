# ~/nixos/packages/sys/sddm.nix
# custom sakura sddm theme
{ pkgs, inputs, ... }:

{
  # Install Ubuntu fonts for the theme
  fonts.packages = with pkgs; [
    ubuntu_font_family
  ];

  # SDDM configuration
  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;  # Use Qt6 version
    theme = "sakura";
    
    # Install the theme package and all its dependencies
    extraPackages = with pkgs.kdePackages; [
      inputs.sakura-sddm.packages.${pkgs.system}.default
      qtmultimedia      # Explicitly add QtMultimedia
      qtdeclarative     # Explicitly add QtDeclarative  
      qtsvg            # Explicitly add QtSvg
      qt6            # Add full Qt6 for good measure
    ];
  };

  # Install the theme for system-wide access
  environment.systemPackages = [ 
    inputs.sakura-sddm.packages.${pkgs.system}.default
    # Optional: Include test package for debugging
    inputs.sakura-sddm.packages.${pkgs.system}.test
  ];

  # Enable Qt6 support
  qt.enable = true;
  qt.platformTheme = "qt5ct";  # Ensure Qt platform is set
}
