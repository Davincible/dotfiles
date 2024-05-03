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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Common hardware modules configured by the community
    hardware = {
      url = "github:nixos/nixos-hardware";
    };

    # Windows management
    # for now trying to avoid this one because I want stability for my wm
    # this is the hyprland development flake package / unstable
    hyprland = {
      url = "github:hyprwm/hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
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
    in
    {
      # Custom modifications/overrides to upstream packages.
      overlays = import ./overlays { inherit inputs outputs; };

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

      #################### NixOS Configurations ####################

      nixosConfigurations.alynix = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ./hosts/alynix
        ];
      };
    };
}
