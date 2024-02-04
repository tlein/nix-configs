{ config, pkgs, lib, ... }:
with lib;
{
  programs.neovim = {
    package = pkgs.neovim-nightly;
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      nvim-tree-lua

      # Quick actions fuzzy
      telescope-nvim
      commander-nvim

      # Color theme
      catppuccin-nvim

      # LSP
      nvim-lspconfig
      lsp-status-nvim
      none-ls-nvim
      fidget-nvim
      nvim-lightbulb
      vim-illuminate

      # Syntax highlighting
      nvim-treesitter.withAllGrammars

      # Completions
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-nvim-lsp-signature-help
      nvim-cmp
      lspkind-nvim
      luasnip

      # Smooth scrolling
      vim-smoothie

      # Status line
      lualine-nvim
      nvim-web-devicons

      # Notifications
      nvim-notify

      # Terminal
      FTerm-nvim

      # Zettelkasten
      zk-nvim

      # Better ui option and select
      dressing-nvim
    ];

    extraPackages = with pkgs; [
      tree-sitter
      ripgrep
      fd

      # Language Servers
      lua-language-server
      rust-analyzer
      nil # Nix
    ];

    extraConfig = ''
      :luafile ~/.config/nvim/lua/init.lua
    '';
  };

  xdg.configFile.nvim = {
    source = ./config;
    recursive = true;
  };
}
