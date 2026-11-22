# ***Techmino: Galaxy***

> ## 注意：本app目前处于开发阶段，故不提供直接下载的渠道。

> ## ATTENTION: This app is currently under some heavy developments. Therefore, we do not provide any public release currently.

*GitHub 官方仓库*

*The Official Repository on GitHub*

给你几乎全新的，更理想的*消除*体验。

A brand new, more ideal and fascinating *Clearing* experience.

> 不建议在公开区域讨论本项目中随时可能变化的内容。

> Not recommened to talk about features which can be changed at any time. Thank you for your cooperation.

> 如果你是Techmino玩家，那么本作包含一定的 ***世界观与设定*** ，所以存在剧透/被剧透的可能性，敬请注意。

> If you are a Techmino player, this game contains ***LORE***, so spoilers warning, please be aware.

> 如果你是Github用户，请注意此仓库仅供技术操作使用，例如clone工程、观察软件架构/游戏框架的设计、mod制作、bug修复等，***从代码中获得的信息请在专门的频道中讨论***，感谢配合。

> If you are a GitHub user, please note that this repository is for technical use only, such as cloning project, researching software architecture/game framework design, modding, bug fixing, etc. ***The information obtained from the code should be discussed in a dedicated channel***, thank you for your cooperation.

## Account integration

Galaxy registers as the distinct `techminoGalaxy` product with Tessera and validates that product identity through Cadence. Account login, email verification, recovery and consent occur in the system browser, not in the game. This integration does not add multiplayer ZTC modes.

Native refresh credentials use the platform-protected store; unavailable or locked storage is visibly memory-only. Web uses an independent HttpOnly product-session cookie and memory-only access credentials. Only Tessera HTTP requests include browser cookies; Cadence requests use a product Bearer credential with cookies omitted.

Ordinary website sign-out preserves product grants. Native logout ends its device grant; product withdrawal, account all-device logout, password reset and disable follow the independent-grant lifecycle. Profile and avatar requests remain separately correlated.

See the [deployment guide](../Tessera/deploy/README.md) and [transport/package guide](../Cadence/transport/README.md) for exact HTTPS origins, registered callbacks, platform artifact contents and outstanding real-device checks. A configured workflow or Web compilation does not prove a device package works.

The Linux packaging workflow restores the original host library/search environment only in its packaged system-browser opener; game and FMOD libraries remain bundled. The corresponding Techmino AppImage path was exercised locally, but that result does not establish Galaxy native package execution, gameplay/audio or OS credential-store acceptance.

### Public validation CI

The `ci-public-online-validation-20261110`, `ci-public-web-canvas-fix`, and
`ci-public-web-fullscreen-recovery` branches package the account/website
origin `https://studio26f.org`, the game origin `https://game.studio26f.org`,
and the exact Web callback `https://studio26f.org/play/techmino-galaxy/`.
These overrides apply only to those exact CI branches; repository-wide
variables and release configuration are unchanged.

The public deployment uses publicly trusted certificates, so no local fixture
CA or `TECHMINO_TRANSPORT_CA_FILE` is required. Certificate and hostname
verification remain enabled. A saved `conf/online.json` takes precedence over
package endpoints; update only its origin settings when leaving a local fixture.

CI checks out the exact committed Zenitha submodule revision, including its
transport adapter. The vendored source contains only the standalone native
transport crate and platform bridges. A completed CI build does not establish
platform signing, provisioning or actual device execution.
Validation branches upload CI artifacts without publishing GitHub Pages.
Pages deployment remains limited to `main` and release tags. Windows, Linux,
Android and Web builds run for this validation branch; macOS and iOS retain
their release-tag signing/distribution requirements and are not triggered here.

Source checks run independently of native soundbank packaging. Web retains
those checks but builds directly from source. Its runtime explicitly skips
FMOD, so the Web package omits the native banks.
Linux packaging builds the shared transport on Ubuntu 22.04 and checks it can
load on Debian 12. This check does not replace the original native audio assets.

The Web runtime restores the windowed drawing buffer and viewport after
fullscreen rejection or a quick exit. Web always starts windowed; enter
fullscreen from the game after it loads. Native window preferences and FMOD
packaging are unchanged.

Native development builds use the original `Master.strings.bank`, `Master.bank`,
and `Effect.bank` from `soundbank/` in the repository, without a download.
Tags starting with `pre` or `v` also download `Music_Beepbox.bank`,
`Music_Community.bank`, `Music_Extra.bank`, and `Music_FL.bank` to that directory.

Android packaging runs pinned `cargo-ndk` from the resolved transport crate,
not the non-Rust client root, so its initial Cargo metadata lookup succeeds.
The APK packages FMOD alongside the transport under `lib/arm64-v8a/` and
`lib/armeabi-v7a/`. The final package check requires both FMOD libraries for
each ABI. In the `4eb6a90e` APK on Redroid 14 (translated ARM64), the game
reached the main menu after its external `files` directory was created.
Both FMOD libraries loaded, but `FMOD_Studio_System_Create` returned an
internal error before loading any banks. The APK lacks the `org.fmod.FMOD`
Java component; the cause of the error is not confirmed. Android audio
and clean first launch on a physical device remain unverified.

