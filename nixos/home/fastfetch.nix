{ ... }: 
{
    programs.fastfetch = {
        enable = true;
        settings = {
            logo = {
                type = "file";
                source = "~/.config/fastfetch/ember-logo.txt";
                position =  "top";
                color = {
                    "1" = "white";
                };
                padding = {
                    right = 0;
                    left = 0;
                    top = 0;
                    bottom = 0;
                };
            };
            display = {
                separator = " : ";
            };
            modules = [
                "os"
                "terminal"
                "cpu"
                "gpu"
                "memory"
                "disk"
            ];
        };
    };
}
