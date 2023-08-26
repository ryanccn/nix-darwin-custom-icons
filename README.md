# nix-darwin-custom-icons

Set custom icons for your applications! A module for [nix-darwin](https://daiderd.com/nix-darwin/)

## Usage

Add this repository to your flake's inputs:

```nix
{
  inputs = {
    darwin-custom-icons.url = "github:ryanccn/nix-darwin-custom-icons";
  };
}
```

And then in your system configuration:

```nix
{
  environment.customIcons = [
    {
      path = "/Applications/Notion.app";
      icon = ./icons/notion.icns;
    }
  ];
}
```
