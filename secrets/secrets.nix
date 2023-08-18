let
  headb = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9IxocfA5legUO3o+cbbQt75vc19UG9yrrPmWVLkwbmvGxCtEayW7ubFNXo9CwlPRqcudOARZjas3XJ4+ZwrDJC8qWrSNDSw1izZizcE5oFe/eTaw+E7jT8KcUWWfdUmyx3cuJCHUAH5HtqTXc5KtZ2PiW91lgx77CYEoDKtt14cqqKvBvWCgj8xYbuoZ5lS/tuF2TkYstxI9kNI2ibk14/YyUfPs+hVTeBCz+0/l87WePzYWwA6xkkZZzGstcpXyOKSrP/fchFC+CWs7oeoJSJ5QGkNqia6HFQrdw93BtGoD2FdR3ruNJa27lOFQcXRyijx43KVr4iLuYvdGw5TEt headb@compute-01";

  system = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCbxVr683AR4IDIVyaVATAb0YyK2o1/lD88LsD8sT44FNNo2e4ezlM6PiugEskhujKAR3hhFr3Kr22licF7VU+ops1hXtIsk0SAQ1abgpdV+eOM02CjRFBo+OMeUoUCnx5+6YRIN5Mw7olDx0oK4CUC938TRfj9+F7dJZbU+l2AGfHOtSXS7bnqhBNVjXNW2A1ha/IpaJvAPABT4sCfFonSwaqXERHn6Jr/aPV4dum9uT5aw8r4SE91DWiMDnbnDVEnDWDlqg+sTNfLv66U//gveGPVtg9zqmCR2QfNM5HXFPIh3KjkZl/gUdUWHEUT1MzbwUiIa+81b25GSBo4EM5x+RSMA+jq6aUucSKqplhPzcMbQY3eftRLmPDqLNhvtQlSkw0fRSICaQ5v6AiFiVBqlvdetX3gxl4+QLi5rxawoeZLqteH0562dVeXZFBowF6W1/Q4GHIieqwZvlDXZ3806PIukXhAMsjhfyj7WSbKA81LKJmutpw7rzYVOcZf3BnAjnHhrg7XMlfqpl2DTKSlreTA9+4H4ePZt7vN19aViqQjuL+jYjjxw+NJB/NGl4FW34H3eq0yxFSlTW43Yor6liS/hlsJs9nlobtVRuZOtUnspgjSjTuTXH5DnQ0AAHZmi/2DkjZpBICn8AQ3esHIo8mLqbjXx+8qCI1AeB4/OQ== root@compute-01";
in
{
  "wireguard-public-key.age".publicKeys = [headb system ];
  "wireguard-private-key.age".publicKeys = [headb system ];
  "monero-address.age".publicKeys = [headb system ];
}
