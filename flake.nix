{
  description = "edil.com.br";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    devshell.url = "github:numtide/devshell";
  };

  outputs = inputs @ { flake-parts, nixpkgs, devshell, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" "aarch64-linux"];
      imports = [ inputs.devshell.flakeModule ];  # <- this is the "magic" to enable devshell

      perSystem = { config, self', inputs', pkgs, system, ... }:
        {
          devshells.default = {
            name = "jekyll";
            packages = with pkgs; [
              ruby_3_1
              libffi
              zlib
              openssl
              pkg-config
              git
              nodejs_24
              pnpm
            ];
            env = [
              { name = "GEM_HOME"; value = "./.gem"; }
              { name = "GEM_PATH"; value = "./.gem"; }
              { name = "PATH"; prefix = "./.gem/bin"; }
              { name = "PNPM_HOME"; value = "./.pnpm"; }
              { name = "PATH"; prefix = "./.pnpm"; }
            ];
            commands = [
              {
                name = "serve-site";
                help = "Serve the Jekyll site locally (http://localhost:4000)";
                command = "bundle exec jekyll serve";
              }
              {
                name = "build-site";
                help = "Build the static site into _site/";
                command = "bundle exec jekyll build";
              }
              {
                name = "new-post";
                help = "Create a new Jekyll post using jekyll-compose. Usage: new-post \"Post Title\"";
                command = "bundle exec jekyll post \"$@\"";
              }
              {
                name = "new-page";
                help = "Create a new Jekyll page using jekyll-compose. Usage: new-page \"page-name\"";
                command = "bundle exec jekyll page \"$@\"";
              }
              {
                name = "new-deck";
                help = "Scaffold a new Slidev deck: new-deck <name>";
                command = "bash scripts/new-deck.sh \"$@\"";
              }
              {
                name = "build-decks";
                help = "Build all Slidev decks into _site/slides/<deck> (with correct --base)";
                command = "bash scripts/build-decks.sh";
              }
              {
                name = "serve-deck";
                help = "Run Slidev dev server for a deck. Usage: slidev-dev slides/<deck-name>";
                command = "bash scripts/slidev-dev.sh \"$@\"";
              }
            ];
          };
        };
    };
}
