# Changelog

## [0.10.0](https://github.com/oleksii-honchar/nginx-reverse-proxy/compare/v0.9.2...v0.10.0) (2024-08-18)


### Features

* update nrp-cli  to v0.9.0 ([79b54de](https://github.com/oleksii-honchar/nginx-reverse-proxy/commit/79b54de67176e9455820a90403f4d1567d87468f))

## [0.9.2](https://github.com/oleksii-honchar/nginx-reverse-proxy/compare/v0.9.1...v0.9.2) (2024-08-17)


### Bug Fixes

* fix json log format ([f42adbf](https://github.com/oleksii-honchar/nginx-reverse-proxy/commit/f42adbf3038f18fe2f1f38a1d88385e5ff5048c6))

## [0.9.1](https://github.com/oleksii-honchar/nginx-reverse-proxy/compare/v0.9.0...v0.9.1) (2024-08-17)


### Bug Fixes

* fix ngin xjson log format ([48dc10c](https://github.com/oleksii-honchar/nginx-reverse-proxy/commit/48dc10c1ede11c107fec8d5f7a313db4e891686e))

## [0.9.0](https://github.com/oleksii-honchar/nginx-reverse-proxy/compare/v0.8.1...v0.9.0) (2024-08-12)


### Features

* enable nginx-more metrics ([3048828](https://github.com/oleksii-honchar/nginx-reverse-proxy/commit/30488286fd3361c2d4647955dd7b3a87dade5b9e))

## [0.8.1](https://github.com/oleksii-honchar/nginx-reverse-proxy/compare/v0.8.0...v0.8.1) (2024-08-12)


### Bug Fixes

* expose metrics port ([b0e76d9](https://github.com/oleksii-honchar/nginx-reverse-proxy/commit/b0e76d9d3bd112d7e138d224d6f4c52029f14244))

## [0.8.0](https://github.com/oleksii-honchar/nginx-reverse-proxy/compare/v0.7.1...v0.8.0) (2024-08-08)


### Features

* add example service config; rename project.env to .env; update readme ([2de76a1](https://github.com/oleksii-honchar/nginx-reverse-proxy/commit/2de76a177829402c0a4302042af48df3e957a262))

## [0.7.1](https://github.com/oleksii-honchar/nginx-reverse-proxy/compare/v0.7.0...v0.7.1) (2024-08-06)


### Bug Fixes

* fix makefile targets ([c72527f](https://github.com/oleksii-honchar/nginx-reverse-proxy/commit/c72527fb6a7f78a22f373af860537b9feadc7c8b))

## [0.7.0](https://github.com/oleksii-honchar/nginx-reverse-proxy/compare/v0.6.0...v0.7.0) (2024-08-06)


### Features

* add certbot, cron  and supervisor ([9b9fdcf](https://github.com/oleksii-honchar/nginx-reverse-proxy/commit/9b9fdcfcce4b25741b019ca0743a67ae5014bc60))
* add release please; simplify config ([728c66b](https://github.com/oleksii-honchar/nginx-reverse-proxy/commit/728c66b7a090160ebc46b021bf2a7e9a35fa11ad))
* after move all in one docker and all config to nrp-cli everything working ([aca3ca9](https://github.com/oleksii-honchar/nginx-reverse-proxy/commit/aca3ca97bb442ad978d2e2a73570f54b2d10125c))
* certboot manual creation works ([8973a5a](https://github.com/oleksii-honchar/nginx-reverse-proxy/commit/8973a5a475df780157c7671008c6140dcce25cc9))
* certbot fixed with bridged network but squid broken without static ip ([a9529df](https://github.com/oleksii-honchar/nginx-reverse-proxy/commit/a9529df770fc1d2f55fc840782d1f3970bb48f94))
* dnsmasq, squid and nrp integration ([ee3fb79](https://github.com/oleksii-honchar/nginx-reverse-proxy/commit/ee3fb792fc10b09440ba101954939171fda34127))
* env vars config parsing, updated nrp-cli, docs ([8500763](https://github.com/oleksii-honchar/nginx-reverse-proxy/commit/850076333cf18fe5e33aea5c5aad83d3d2c739b2))
* http proxy config working, no ssl ([f886b69](https://github.com/oleksii-honchar/nginx-reverse-proxy/commit/f886b6913b22e5f336985c51a8e31f691cc698bb))
* moved letsencrypt file iside named volume ([8c60b64](https://github.com/oleksii-honchar/nginx-reverse-proxy/commit/8c60b64303335f567ab0a7f1bf06fe67a05c190f))
* moved squid, dnsmasq inside docker image; config delegated to nrp-cli; simple bridged netw w/o static ip ([27dc34a](https://github.com/oleksii-honchar/nginx-reverse-proxy/commit/27dc34a6fe4850f7e28836cd1a9cbb28c4a34d86))
* multi server works ([4651f2b](https://github.com/oleksii-honchar/nginx-reverse-proxy/commit/4651f2b9000d3cb42d2fcc6319a8df9636b1f432))
* multi server works ([3ccbf92](https://github.com/oleksii-honchar/nginx-reverse-proxy/commit/3ccbf9232c8a975e35fc9580e0fb344959b1c5b2))
* nginx, certbot, nrp-cli working ([7a01845](https://github.com/oleksii-honchar/nginx-reverse-proxy/commit/7a01845e86bff65f0612b1a24fb43f081f325b45))
* tmpls updated; nrp-cli 0.7; docs updated ([78fd63f](https://github.com/oleksii-honchar/nginx-reverse-proxy/commit/78fd63ff6f24e6855359e2d44d2a821d9f887b78))
* update default html page with logo; update proxy and basic conf ([8deb529](https://github.com/oleksii-honchar/nginx-reverse-proxy/commit/8deb5296afe0bec98d2efe098237bcb3c441d600))


### Bug Fixes

* add missing config ([64d2a52](https://github.com/oleksii-honchar/nginx-reverse-proxy/commit/64d2a52e300500732b2882f68927a617098fbc4b))
* bump nginx-more ([bd46866](https://github.com/oleksii-honchar/nginx-reverse-proxy/commit/bd468661d12e21d686316d7155ab5b0260a21bf6))
* fixing deps after project.env removal ([2f2fade](https://github.com/oleksii-honchar/nginx-reverse-proxy/commit/2f2fade039fbd72c94523d480372b42bb32853a4))
* robots.txt cleanup; add image:latest version on start; ([0dc9f3c](https://github.com/oleksii-honchar/nginx-reverse-proxy/commit/0dc9f3c23df9e7107b7d70db669dbe5bbcd4fe5a))
* wget nrp-cli from github, copy nginx config inside docker ([a96c123](https://github.com/oleksii-honchar/nginx-reverse-proxy/commit/a96c123c0fb31bd1cda3432e4ff6bc5d9b1cec91))

## 0.6.0 nginx-more version bump

- `nginx-more` updated to 1.27.0-0 version
- replace `pyOPenSSL` with `openssl`
