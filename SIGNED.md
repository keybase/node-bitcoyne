##### Signed by https://keybase.io/max
```
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2
Comment: GPGTools - https://gpgtools.org

iQEcBAABCgAGBQJUiJC5AAoJEJgKPw0B/gTf5s0H/ikggZjhp1kURVLOf9tM/alN
4g0n4P4q2AJbnsQWAf/UJMLgVzEokgJ99rJl3JcRxwX3lKHyHhunoS4Jjqz9qw9N
tGUGSLYWt7ecB96n6qeERsEpB41nfXasNI8sm3rmOq4XEPQvqZ78q75Fpkn/Resm
JW30R7BOCxc2H8gx/uZMpfYRLfNysVaK7jQ6Dw3x5L3AAUmUgCbBk96sRryZlSEq
J3JaScQ++8Tzbs5eh4t52SnGvRDSFniXN1zlBUUCX/onG+dcsMfZU2QuQJxThYjf
nAqooaIWzBepfK3oF3rmQ2GnIFZ0Hnw3dOJuCigavxcI0dBHB+C4j+o4fPgfNIQ=
=V4AI
-----END PGP SIGNATURE-----

```

<!-- END SIGNATURES -->

### Begin signed statement 

#### Expect

```
size  exec  file                        contents                                                        
            ./                                                                                          
109           .gitignore                ec278daeb8f83cac2579d262b92ee6d7d872c4d1544e881ba515d8bcc05361ab
273           CHANGELOG.md              5fc92bc41b24b4a6378e2723213fd6f18ace4ef8333452f23a8163baaaac255d
1483          LICENSE                   333be7050513d91d9e77ca9acb4a91261721f0050209636076ed58676bfc643d
414           Makefile                  3fc373da860330bca19decdb3649c59d78ce19476a55585d93aba3f4681d2636
91            README.md                 9bb4d8d39fabc12e85959613a2e93a28f33d0df82fdc5edd39caef80a1b46dcc
              lib/                                                                                      
1343            address.js              6eac2c746ef1eed9933ff4f1f24a070fb837f68af5bca75b3600483923e33649
113             main.js                 a5324b09b89f993deefae933e8352c8750732ea1c68d9959cce7d58ddb1999a6
832           package.json              b76eef2b87aafa5d4635eda9b97df0c793a54f233d514286742beab1e4d2e0d2
              src/                                                                                      
913             address.iced            ad19ee95d74a058d3746315a8c9814303ec7546e35b382e861dfd9dba927d70a
38              main.iced               795b67a4f1763d0ce0c878132d71f3bb7516a369d8f3c4b0dc1750dc18914765
              test/                                                                                     
                files/                                                                                  
1061              0_address_check.iced  fc65a3cbe0a09f2563e882e4b8835755a1ca728c18d21d7870829555e64f523b
183             run.iced                822568debeae702ca4d1f3026896d78b2d426e960d77cb3c374da059ef09f9fd
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