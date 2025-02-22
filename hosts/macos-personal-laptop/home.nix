{ inputs, ... }: 
{
  imports = [
    ../../home
  ];

  my-home = {
    includeFonts = true;
  };
}
