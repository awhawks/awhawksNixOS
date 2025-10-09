let 
    myzima1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINpUgWymWYD86WkUHRlkOLZK5at4LnaQs6GOPRJnsOnl";
in {
    "secret1.age".publicKeys = [ myzima1 ]
}
