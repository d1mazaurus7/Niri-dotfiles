# home/default.nix
{ ... }: 
{
   imports = [
      ./packages.nix
      ./zsh.nix
      ./nvim.nix
      ./starship.nix
      ./fastfetch.nix
      ./xdg-default.nix
   ]

   # --- Necessarily!!!
   home.username = "user"; # --- Your username
   home.homeDirectory = "/home/user"; # --- Home directory
   
}
