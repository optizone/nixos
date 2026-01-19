{ username, ... }:
{
  services.openssh = {
    enable = true;
    ports = [ 22 ];

    hostKeys = [
      {
        path = "/persist/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];

    settings = {
      PasswordAuthentication = true;
      AllowUsers = [
        "${username}"
        "root"
      ];
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKSc1iIJ63VM55CIWnu4U8/YoqkKXr8QK+N74UcltYvY"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG/cBsavT5TcgtRKwvfF64jTUgfIEEBGn75gHv7GuIc6 thinkpad"
  ];

  users.users.${username}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKSc1iIJ63VM55CIWnu4U8/YoqkKXr8QK+N74UcltYvY"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG/cBsavT5TcgtRKwvfF64jTUgfIEEBGn75gHv7GuIc6 thinkpad"
  ];
}
