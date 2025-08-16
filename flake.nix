{
  description = "Simple Sakura SDDM theme with video background";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f (import nixpkgs { inherit system; }));
    in
    {
      packages = forAllSystems (pkgs: rec {
        default = sakura-sddm-theme;
        
        sakura-sddm-theme = pkgs.stdenvNoCC.mkDerivation {
          pname = "sakura-sddm-theme";
          version = "1.0.0";

          src = ./.;

          dontWrapQtApps = true;

          propagatedBuildInputs = with pkgs.kdePackages; [
            qtdeclarative  # For QML (correct package name)
          ];

          installPhase = ''
            mkdir -p $out/share/sddm/themes/sakura
            
            # Copy theme files
            cp -r $src/Main.qml $out/share/sddm/themes/sakura/
            cp -r $src/metadata.desktop $out/share/sddm/themes/sakura/
            
            # Copy backgrounds if they exist
            if [ -d "$src/backgrounds" ]; then
              cp -r $src/backgrounds $out/share/sddm/themes/sakura/
            fi
            
            # Copy icons if they exist
            if [ -d "$src/icons" ]; then
              cp -r $src/icons $out/share/sddm/themes/sakura/
            fi
            
            # Copy fonts if they exist (though Ubuntu Sans should be system-wide)
            if [ -d "$src/fonts" ]; then
              mkdir -p $out/share/fonts
              cp -r $src/fonts/* $out/share/fonts/
            fi
          '';

          meta = with pkgs.lib; {
            description = "Simple SDDM theme with video background and left-aligned login";
            license = licenses.gpl3;
            platforms = platforms.linux;
          };

          passthru.test = test;
        };

        # Simple test package
        test = pkgs.symlinkJoin {
          name = "test-sakura-sddm";
          paths = [ pkgs.kdePackages.sddm ];
          nativeBuildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            makeWrapper $out/bin/sddm-greeter-qt6 $out/bin/test-sakura-sddm \
              --add-flags '--test-mode --theme ${sakura-sddm-theme}/share/sddm/themes/sakura'
          '';
        };
      });
    };
}
