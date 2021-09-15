{
  name = "Strings";
  description = ''
    The nix language
  '';
  info-links = [
      { name = "Nix Manual"; link = "https://nixos.org/manual/nix/stable/#ch-expression-language"; }
  ];
  other-examples = [];
  examples = [
    {
      name = "Simple string";
      code = "\"hello world\"";
    }
    {
      name = "String interpolation";
      code = "\"hello \${world}\"";
      comment = "This interpolation also works in sets, like: `{ a.\${b}.c = 5; }`";
    }
    {
      name = "Multiline string";
      code = ''
        \'\'
          This is a multiline
          String as you can see
        \'\'
      '';
      comment = "Nix removes the preceeding whitespace before the multiple lines";
    }
  ];
}
