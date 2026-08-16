{ ... }: 
{
    programs.fastfetch = {
        enable = true;
        settings = {
            logo = {
                source = "nixos";
                padding = {
                    right = 1;
                };
            };
            display = {
                separator = "  ";
            };
            modules = [
                "title"
                "os"
                "kernel"
                "uptime"
                "terminal"
                "cpu"
                "gpu"
                "memory"
                "disk"
                "colors"
            ];
        };
    };
}
