{pkgs, ...}: {
  home.packages = with pkgs; [
    devpod
    #devpod-desktop
    code2prompt
    crush
    (python3.withPackages (ps:
      with ps; [
        pip
        # Scientific packages
        numba
        numpy
        torch
        srt
      ]))
    pyrefly
    nixd
    alejandra
    tailwindcss
    tailwindcss-language-server
  ];
}
