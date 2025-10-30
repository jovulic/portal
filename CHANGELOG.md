# Changelog

## [0.1.6](https://github.com/jovulic/portal/compare/v0.1.5...v0.1.6) (2025-10-30)


### Features

* **root:** add AGENTS.md ([be5e6b6](https://github.com/jovulic/portal/commit/be5e6b6cb61c38f7394e8c0f687603d04c0508ea))


### Documentation

* **readme:** add user nomad mention on rdp port access ([1018a57](https://github.com/jovulic/portal/commit/1018a57c6619d1d56de62367de8cc6fd9680e0f4))
* **readme:** capitalize the title ([3a24b55](https://github.com/jovulic/portal/commit/3a24b55bf2a4e06c876b56d7c84113690088ef16))

## [0.1.5](https://github.com/jovulic/portal/compare/v0.1.4...v0.1.5) (2025-06-25)


### Documentation

* **readme:** add screenshot ([0c239bc](https://github.com/jovulic/portal/commit/0c239bcea029a7b30206744ec161e7e53d4e834f))
* **readme:** shrink and center screenshot ([8167369](https://github.com/jovulic/portal/commit/8167369097c36d6cf13c01d586a83e27aaa0d1b9))
* **readme:** try to place image with p instead of div ([8856d0a](https://github.com/jovulic/portal/commit/8856d0a9ac8aa29981651a735da31c795ee36730))
* **readme:** write readme with description usage and build sections ([4444ac5](https://github.com/jovulic/portal/commit/4444ac5091ecb12d00d10954f25f84f68ef3ece2))


### General Changes

* **container:** add description to container image ([f693c80](https://github.com/jovulic/portal/commit/f693c80ff36ce9f782d990ba1e1b70ca80682382))

## [0.1.4](https://github.com/jovulic/portal/compare/v0.1.3...v0.1.4) (2025-06-25)


### Code Refactoring

* **workflow:** merge publish into release workflow ([409bc72](https://github.com/jovulic/portal/commit/409bc7298ba396c029f8d69218a809ba1c421d9c))

## [0.1.3](https://github.com/jovulic/portal/compare/v0.1.2...v0.1.3) (2025-06-25)


### General Changes

* **workflow:** change for release workflow to trigger publish workflow via dispatch ([8b4019d](https://github.com/jovulic/portal/commit/8b4019d947ba617d02782627b42d07a3a160f92d))

## [0.1.2](https://github.com/jovulic/portal/compare/v0.1.1...v0.1.2) (2025-06-25)


### General Changes

* **workflow:** update to trigger off tags ([daee0ed](https://github.com/jovulic/portal/commit/daee0ed3932b286b07b4f55261b78985045b192b))

## [0.1.1](https://github.com/jovulic/portal/compare/v0.1.0...v0.1.1) (2025-06-25)


### Features

* **...:** get chrome running within the container ([3219863](https://github.com/jovulic/portal/commit/3219863605a606be9d4eb441cd14b76b150b8d9d))
* **...:** refactor structure and introduce container using s6 for service management ([06a348d](https://github.com/jovulic/portal/commit/06a348d193b74a790fc4a0efb50c1bb792371aa7))
* add nix flake scaffolding ([254d314](https://github.com/jovulic/portal/commit/254d314636bc796027ba51c11e23ea58f90f7c6e))
* **container:** refactor s6 and create weston module for rdp ([d5b3fb4](https://github.com/jovulic/portal/commit/d5b3fb4c574b5426f892eb2e837ba3d643cee1ae))
* **git:** setup git crypt ([022de38](https://github.com/jovulic/portal/commit/022de383993c5cc9c455badd8b0ebb16aa203752))
* **google-chrome:** enable devtools port and add ready check binary ([fb8a68e](https://github.com/jovulic/portal/commit/fb8a68ea0365a2fef192144ccd07dd9b6f8f52d4))
* **modules:** properly implement dbus ([77cebed](https://github.com/jovulic/portal/commit/77cebed8f41e867aa45a63cd4b1c4f968e1f0c23))
* **modules:** run weston and chrome as the nomad user ([532a732](https://github.com/jovulic/portal/commit/532a7326c9fda0f6ec52e8f5f01f5eed74b9803d))
* **nix,dev,src:** setup vm with remote access ([84dfce6](https://github.com/jovulic/portal/commit/84dfce609be011dcd4929a8be84379ab63aec9c0))
* **nix:** add just and impl build and push commands ([ab2f1cc](https://github.com/jovulic/portal/commit/ab2f1cc0542b7eb57da4e77e8a7755b1c2c0cba0))
* **nix:** create flake app to build and launch waypoint ([2aa2af5](https://github.com/jovulic/portal/commit/2aa2af51f78ddfa1a9708f7b0097abb3dddc50a5))
* **nix:** update nixpkgs to 25.05 ([95f9416](https://github.com/jovulic/portal/commit/95f94164e2955d52c77dae9e9088138556ba9c74))
* **s6,weston,timezone:** add timezone configuration and improve s6 logging with prefix ([9472f9f](https://github.com/jovulic/portal/commit/9472f9ff97e42e3f3077d8d457218c2a3a0314c7))
* **s6:** add oneshot expression ([ccf7b78](https://github.com/jovulic/portal/commit/ccf7b78e793d0919fd085e70747b4cf53cd4845c))
* **user:** add nomad user and refactor ([c469638](https://github.com/jovulic/portal/commit/c4696387bdd989e7a361525cb891b5a0db442d04))
* **user:** configure users with correct file permissions ([fc0f14e](https://github.com/jovulic/portal/commit/fc0f14ea27ed1a49aabdda3dc32e8b3e742e93c5))
* **weston:** add weston config file ([2828652](https://github.com/jovulic/portal/commit/2828652e1bc2f2660d164448e2df9dc5f941d2fa))
* **workflow:** add release workflow ([5ec8c7c](https://github.com/jovulic/portal/commit/5ec8c7c53bef507e5b7a0314c351d801f92dedfb))
* **workflow:** setup release-please and workflow ([a0b9f7b](https://github.com/jovulic/portal/commit/a0b9f7bd57c849cc7bdd5b2216e4ae8a81808cb4))


### Bug Fixes

* **dbus:** correctly set the machine id ([ba0db88](https://github.com/jovulic/portal/commit/ba0db88f0b7adbb55ebc7ffc6befe286da400125))
* **fonts:** actually copy over dejavu fonts ([d51b30b](https://github.com/jovulic/portal/commit/d51b30bc5e49f47840ed2fb84229eaf9c27c5710))
* **google-chrome:** add custom user-data-dir required when using remote debugging ([e9305f6](https://github.com/jovulic/portal/commit/e9305f61fad5bd2645b99c559612adeb7b8c8fba))
* **modules:** update weston to have home env set and share envs by ref ([4024d5b](https://github.com/jovulic/portal/commit/4024d5b20f483bfefa3a98a87e69101cc52095b0))
* **nix:** remove the newline suffix from the version ([654e546](https://github.com/jovulic/portal/commit/654e546bcd01687ab4bf1c386d510fb4c259da65))
* **src:** update xrdp window manager to execute via dbus ([dd1c794](https://github.com/jovulic/portal/commit/dd1c794b7d1b8b8b2cbedddf2705ca2e5568102e))
* **user:** commit changes to user around user names and nomad home ([56cb59f](https://github.com/jovulic/portal/commit/56cb59fc7705f7452c5207bf869362d3d28664b5))
* **weston:** update cert key size ([deaa724](https://github.com/jovulic/portal/commit/deaa72415d5b3659cbce78665b99649c9cdc86ab))
* **workflow:** add issues write to release workflow ([d823af8](https://github.com/jovulic/portal/commit/d823af8437ac8c73733fe71edca815cc17a7a0cf))
* **workflow:** add packages write permission to release ([1e26956](https://github.com/jovulic/portal/commit/1e2695602a60f0bf3436d81dc197c67276fe799d))
* **workflow:** typo in release please config filename ([c7c89a3](https://github.com/jovulic/portal/commit/c7c89a3e237d0deda2aece78302b6334e92c1a8c))


### Code Refactoring

* **...:** rename waypoint to portal ([51883ee](https://github.com/jovulic/portal/commit/51883ee261e0684a24ad02520b79ae878a4a7670))
* **dbus:** simplify dbus root setup ([c65c0a1](https://github.com/jovulic/portal/commit/c65c0a1ca0111d17497b7d8892b504e24de5dcc1))
* **nix,src:** delete machine and flatten container targets ([fb4dbeb](https://github.com/jovulic/portal/commit/fb4dbebcc94dee33ffa62345c769b8b5cedf4d74))
* **nix:** rename machine package output to host ([68ceaaf](https://github.com/jovulic/portal/commit/68ceaaf4a75bfc8b8681f7ed36beb5ef890dc371))
* **timezone:** refactor to simply link tzdata rather than copy ([10a928c](https://github.com/jovulic/portal/commit/10a928cac98d5bb1aa8caf903930421c113cc0e4))
* **weston:** create default certs during build ([75b2101](https://github.com/jovulic/portal/commit/75b21019df2cae690dc1f08087e24cdf57fd53a0))
* **workflow:** convert release workflow to publish that triggers on tags ([1fe8ed3](https://github.com/jovulic/portal/commit/1fe8ed3116ce679ec14e98c29211fc0b83b42c19))


### General Changes

* **...:** correctly set and use the portal image tag ([a81cc2a](https://github.com/jovulic/portal/commit/a81cc2a7718c7dbcf5bf86794c716bbd5f5e55ce))
* **container:** add 3389 as container exposed port ([97ebb80](https://github.com/jovulic/portal/commit/97ebb80f1d829adb75596e2974d0ee85144776b6))
* **container:** add 9222 as an exposed port ([8b8fad2](https://github.com/jovulic/portal/commit/8b8fad253832dc7fcd4bbe8bba5829ddf95ff3e2))
* **container:** add label to link to repository ([bd7c993](https://github.com/jovulic/portal/commit/bd7c993e026fe48c17c35fb5fcd708d4d39a82fa))
* **dev:** change store fs type to squashfs as erofs looks to be building very slowly ([b402dab](https://github.com/jovulic/portal/commit/b402dab7d4a47ccad22b232909af693b25113d38))
* **fonts,timezone:** ensure usr/share exists before linking ([53518b0](https://github.com/jovulic/portal/commit/53518b0ef32da584e63b2bed631f980f49c7416f))
* **fonts:** simplify fonts setup ([6176330](https://github.com/jovulic/portal/commit/61763301c39696f1e289c258bda8e313638e2482))
* **git:** remove git-crypt ([bf4666e](https://github.com/jovulic/portal/commit/bf4666e2ee4e4c9be939afa630552a652f1d2fba))
* **google-chrome:** remove chrome ready check as checking :9222 should work ([7998c12](https://github.com/jovulic/portal/commit/7998c1264f6102376f7903cc185020bf97b30078))
* **google-chrome:** remove no-sandbox flag ([0b1ce2a](https://github.com/jovulic/portal/commit/0b1ce2ab74612e408c100aad4f5d96114aea2db4))
* **nix:** pull version from the version.txt file ([197cc7c](https://github.com/jovulic/portal/commit/197cc7c81102100af2e51786149c393876265e74))
* **nix:** tag and push both full and short images ([bba4792](https://github.com/jovulic/portal/commit/bba47922df438a27f65c313f9059d84517d9924b))
* **user:** change chown to nomad to work recursively ([f22184a](https://github.com/jovulic/portal/commit/f22184a2ecd5a75f29e3a217a825a7a008eb160d))
* **weston:** remove config env as we would rather be explicit in environment use ([dd84543](https://github.com/jovulic/portal/commit/dd845438eb2115c0095b093acf82ec0e2d3aa2b4))
* **workflow:** disable workflow ([2515fd0](https://github.com/jovulic/portal/commit/2515fd0c53337c8cc8d514fe85c35b6feea7ba96))
* **workflow:** enable release workflow ([f6490e8](https://github.com/jovulic/portal/commit/f6490e8738c02f0031200742a553424c52e5469b))
* **workflow:** reset to version 0.1.0 ([af36e20](https://github.com/jovulic/portal/commit/af36e20ae8939f506287190d721add4ea0a300f5))
* **workflow:** switch to using podman rather than docker ([319927b](https://github.com/jovulic/portal/commit/319927b7abd9a4f6a3d54b7d16ebbe7480de8d38))
* **workflow:** update publish to work off release created trigger ([fd6b28a](https://github.com/jovulic/portal/commit/fd6b28a094b0b79f14360e6bce17294fc1789020))
