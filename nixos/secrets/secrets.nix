let
    # users
    awhawksKeyPub="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG0E7DSiRlvqSjabsk79vISmj6Z1tEq4/MYIhFG1sngR";
    # hosts
    myzima1HostKeyPub="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINpUgWymWYD86WkUHRlkOLZK5at4LnaQs6GOPRJnsOnl";
in {
    "awhawks-private-rsa.age".publicKeys = [ myzima1HostKeyPub awhawksKeyPub ];
    "awhawks-private-ed25519.age".publicKeys = [ myzima1HostKeyPub awhawksKeyPub ];
    "hashed-password-root.age".publicKeys = [ myzima1HostKeyPub awhawksKeyPub ];
    "hashed-password-awhawks.age".publicKeys = [ myzima1HostKeyPub awhawksKeyPub ];
    "pia-switzerland.age".publicKeys = [ myzima1HostKeyPub awhawksKeyPub ];
}
