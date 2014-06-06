##### Signed by https://keybase.io/max
```
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.22 (Darwin)
Comment: GPGTools - https://gpgtools.org

iQEcBAABCgAGBQJTkjUYAAoJEJgKPw0B/gTfMfwIAIPm9LAjZ3jatw7I+uTNEJKA
mQ1FJcmq0fym13sHY99RcA9nvIHI/5zJ8qLw3e4Pt8qxgCF49oyceRUAAGtLesOt
V2DLNqOaOJs5707rNnYjmn2jiL8HFWIDxt1tjtgCqTvqefnBf+Ol50I8Z9bPEK7b
De6eSXG7U98nRfI5F/DZVpnQOlSfQQs9aoPUb2FlkWJZkXim9V8A22LNONBNWnGm
W0303jMYe/4+wqMtMxuuQ9BAdu/t2Qje1GaR8QqeOVHJ9Mr6MmEcWF4KhUghWhcs
FanjFoWJ7Xhj//ptWgcqJ7icSXifGHkKEKU+HAYojaVpELXEw84HzmjMMUhKZ4o=
=2RSb
-----END PGP SIGNATURE-----

```

<!-- END SIGNATURES -->

### Begin signed statement 

#### Expect

```
size  exec  file              contents                                                        
            ./                                                                                
109           .gitignore      ec278daeb8f83cac2579d262b92ee6d7d872c4d1544e881ba515d8bcc05361ab
45            CHANGELOG.md    ecf01d9b6ee74c23fb8c8d4a2e09f3aef5a5c936c5494cec72eee3f01c0b5a62
1483          LICENSE         333be7050513d91d9e77ca9acb4a91261721f0050209636076ed58676bfc643d
414           Makefile        3fc373da860330bca19decdb3649c59d78ce19476a55585d93aba3f4681d2636
91            README.md       9bb4d8d39fabc12e85959613a2e93a28f33d0df82fdc5edd39caef80a1b46dcc
              lib/                                                                            
1048            address.js    0cd02669e386bd6fcefac5bc30b078ea959d9763250d478bb7b70c68ee2e8383
113             main.js       a5324b09b89f993deefae933e8352c8750732ea1c68d9959cce7d58ddb1999a6
832           package.json    957172ca44b1db07463ba8343245967432558dbe0eebf66f88268fbf8ec14480
              src/                                                                            
499             address.iced  6772037d3d064488289262e0ac64d6372ac0f609a35262328aba0ad3aa00c24d
38              main.iced     795b67a4f1763d0ce0c878132d71f3bb7516a369d8f3c4b0dc1750dc18914765
              test/                                                                           
                files/                                                                        
1                 0.iced      01ba4719c80b6fe911b091a7c05124b64eeece964e09c058ef8f9805daca546b
169             run.iced      70ef38fc04a9ee264e2317e5b4dcb00a69a996139e98b5d9e34d0ffa16609479
```

#### Ignore

```
/SIGNED.md
```

#### Presets

```
git      # ignore .git and anything as described by .gitignore files
dropbox  # ignore .dropbox-cache and other Dropbox-related files    
kb       # ignore anything as described by .kbignore files          
```

<!-- summarize version = 0.0.9 -->

### End signed statement

<hr>

#### Notes

With keybase you can sign any directory's contents, whether it's a git repo,
source code distribution, or a personal documents folder. It aims to replace the drudgery of:

  1. comparing a zipped file to a detached statement
  2. downloading a public key
  3. confirming it is in fact the author's by reviewing public statements they've made, using it

All in one simple command:

```bash
keybase dir verify
```

There are lots of options, including assertions for automating your checks.

For more info, check out https://keybase.io/docs/command_line/code_signing