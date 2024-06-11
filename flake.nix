{
  description = "NixOs Config Flake";

  # Sources that Nix needs to fetch
  inputs = {
    #################### Official NixOS and HM Package Sources ####################
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "github:NixOS/nixpkgs/release-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable"; # also see 'unstable-packages' overlay at 'overlays/default.nix"

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #################### Utilities ####################

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    # Declarative partitioning and formatting
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    # Secrets management. See ./docs/secretsmgmt.md
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # vim4LMFQR!
    nixvim = {
      url = "github:nix-community/nixvim";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    # Common hardware modules configured by the community
    hardware = {
      url = "github:nixos/nixos-hardware";
    };

    # Windows management
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    # hyprlandScanner = {
    #   url = "github:hyprwm/hyprwayland-scanner";
    #   inputs.nixpkgs.follows = "hyprland";
    # };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    matugen.url = "github:InioX/matugen?ref=v2.2.0"; # Colors from img
    ags.url = "github:Aylur/ags"; # GTK3 js
    astal.url = "github:Aylur/astal"; # GTK4 js

    lf-icons = {
      url = "github:gokcehan/lf";
      flake = false;
    };

    lf-config = {
      url = "github:jackielii/dotfiles";
      flake = false;
    };

    loungy = {
      # TODO: not packacged upstream yet, check later
      url = "github:MatthiasGrandl/loungy";
    };

    #################### Personal Repositories ####################

    # Private secrets repo
    # Authenticate via ssh and use shallow clone
    nix-secrets = {
      url = "git+ssh://git@github.com/Davincible/nixos-secrets.git?ref=master&shallow=1";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        #"aarch64-darwin"
      ];

      inherit (nixpkgs) lib;

      configLib = import ./lib { inherit lib; pkgs = nixpkgs.legacyPackages.x86_64-linux; };

      specialArgs = { inherit inputs outputs configLib nixpkgs; };

      # Custom modifications/overrides to upstream packages.
      myOverlays = [
        # (import ./overlays { inherit inputs outputs; })
        inputs.neovim-nightly-overlay.overlays.default
      ];
    in
    {
      # Custom packages to be shared or upstreamed.
      # NOTE: If I'd want to create custom packages that aren't available throught the package manager that's possible here. Not needed for now.
      # packages = forAllSystems
      #   (system:
      #     let pkgs = nixpkgs.legacyPackages.${system};
      #     in import ./pkgs { inherit pkgs; }
      #   );

      # Nix formatter available through 'nix fmt' https://nix-community.github.io/nixpkgs-fmt
      formatter = forAllSystems
        (system:
          nixpkgs.legacyPackages.${system}.nixpkgs-fmt
        );

      overlays = myOverlays;

      #################### NixOS Configurations ####################

      nixosConfigurations.alynix = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ./hosts/alynix
        ];
      };
    };
}
