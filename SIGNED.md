##### Signed by https://keybase.io/max
```
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.22 (Darwin)
Comment: GPGTools - https://gpgtools.org

iQEcBAABCgAGBQJTpIazAAoJEJgKPw0B/gTf/yAH/iJoC2cyLCXoLGGtbfsIdnBz
VCeKIoVIjTdP3TiIdNv9T38K5NUCiCCnyqkUYYDFaCUsSv0PX+HU1u9qVf1X/T65
fl/TtZulKDpH29rLKGEawd5Ugu19wcEGE8euB3qgAd/XUfzupRCrc/RrCjsxDgIJ
hP9+oCaJFybaXsyM4pm6C07lnFxsGWwhXyvP4shAIq0JnV8xr/mUylWUiwAhNY8f
KxkyXtx76+3v9xb9wlm8AqOpjUf1lO+YntxazMndKrTHCkdvs/dyaz7SHmz0bTZq
3zsPvuNHxS1oRl9TFHK1h8qriBz1nZaWQzhOm8Hy/8dmGxVUtnarAGMAnJod0Bk=
=NXSc
-----END PGP SIGNATURE-----

```

<!-- END SIGNATURES -->

### Begin signed statement 

#### Expect

```
size   exec  file                        contents                                                        
             ./                                                                                          
109            .gitignore                ec278daeb8f83cac2579d262b92ee6d7d872c4d1544e881ba515d8bcc05361ab
287            CHANGELOG.md              7b0d403c09bf32f2322383be7a1428aaebeb26ea8e2df80184ce2139fa9c6921
1483           LICENSE                   333be7050513d91d9e77ca9acb4a91261721f0050209636076ed58676bfc643d
577            Makefile                  28a35ffc9b25337fdcc3313d5d9e6ed8b8989cd7774ab439786698f8106dae2b
91             README.md                 9bb4d8d39fabc12e85959613a2e93a28f33d0df82fdc5edd39caef80a1b46dcc
               lib/                                                                                      
1343             address.js              6eac2c746ef1eed9933ff4f1f24a070fb837f68af5bca75b3600483923e33649
2553             bcdstream.js            6d5ebf848dda11928a99143a053f2c5703ed44e146adada3c164d76255bbdb17
160              constants.js            4f937a7c09060e945b6e25e3543cde9f4e1074f06a1e82990e7b43ab9db3636e
364              crypto.js               4630f976d4c34a549bec13259f573c0e25113d0e94b8990ea6cfab1e07f13c9c
113              main.js                 a5324b09b89f993deefae933e8352c8750732ea1c68d9959cce7d58ddb1999a6
8472             opcodes.js              c49d6fca65332fdd1187e363a5dd81502775a81334409cfe01aa03747fe8fcb2
758              oputil.js               c809a5e669872f528d271f07e6fe46a401410b7647929eb2eb65e07ead99c223
10506            parser.js               0781d3805488e2eec6d40b2345509621a775e972bc95dd4fd9dc70ce09512af3
968              pubkey.js               d9f87e18357faee68ad6c27708ee496c177a3764f46d8cb03a5a025c2c268cb9
6877             rational.js             f543775208bc3635150c68c236e725d7cc74ec0ad4b3b9bc921ad4af3cb9435c
855            package.json              ad686503848ed414621c6ca01bbf4d513c42663c1467ef94d303f028f2818d66
               src/                                                                                      
912              address.iced            f3981616a7ded2ae3a30bce9524de97343aa345db432f2ca4af1cf100ffa08af
1773             bcdstream.iced          23c7318747ed8d3452b0a0fdb23cf62e4213fd6ca9729ffb588a9c6337c70dde
1744             bcprng.iced             04536a753075883eab8d13cd3b7a46c7eaf09de2f5f49574a0c42ab1ab6b2e5d
74               constants.iced          ac0a5f59588ddcd94d05c75095256e8a537051821c930c26314ba966afda1d00
199              crypto.iced             8aaa72c7ff6539a57ff1737d01099e74d218fe0ef9971167eab5cdaa1895df65
38               main.iced               795b67a4f1763d0ce0c878132d71f3bb7516a369d8f3c4b0dc1750dc18914765
7628             opcodes.iced            d7ea41b7a2b9ee6913c0bab389cbc18134bc10205cca8ec35895be70af49d579
531              oputil.iced             3d4cd2ed95cf7123eeb6b5a0ff9df200bef83453665d258f7e99e997efba8638
6743             parser.iced             6657743c7f1190599d0a5ad1dea61a57c1485e358b678daa1aca82d2a723f979
740              pubkey.iced             0723c781bd45aa96d7fa46785d399e332a8fa8acbca163f0c5dc1983eb1e7ce6
4574             rational.iced           a6f4d734418d3016164a3f31b37e3945109fe6ec68bcfa25b4e27fb6749889b6
               test/                                                                                     
                 files/                                                                                  
1061               0_address_check.iced  fc65a3cbe0a09f2563e882e4b8835755a1ca728c18d21d7870829555e64f523b
183              run.iced                822568debeae702ca4d1f3026896d78b2d426e960d77cb3c374da059ef09f9fd
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