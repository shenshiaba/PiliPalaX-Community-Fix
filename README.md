<div align="center">
  <img width="160" height="160" src="assets/images/logo/logo_android.png" alt="PiliPalaX logo">
  <h1>PiliPalaX Community Fix</h1>
  <p>PiliPalaX 的非官方、一次性社区修复版本</p>
  <p>
    <img src="https://img.shields.io/badge/status-one--time%20fix-orange" alt="one-time fix">
    <img src="https://img.shields.io/badge/license-GPLv3-blue" alt="GPLv3">
    <img src="https://img.shields.io/badge/Android-release-green" alt="Android release">
  </p>
</div>

> PiliPalaX 的非官方、一次性社区修复版本。

本仓库基于 [@orz12/PiliPalaX](https://github.com/orz12/PiliPalaX)，其上游为 [@guozhigq/pilipala](https://github.com/guozhigq/pilipala)。仓库保留完整上游 Git 历史，并继续遵循 GNU General Public License v3.0（GPLv3）。

本版本只为恢复已经影响实际使用的页面功能而制作，不代表原作者，不是官方续作，也不承诺持续维护。

## 本次修复

### 动态页

- 兼容 B 站动态接口中布尔字段偶发返回 `0/1` 或字符串的情况。
- 兼容部分数字字段以字符串形式返回，避免类型转换异常导致动态页无法加载。
- 主要处理 `type 'int' is not a subtype of type 'bool?'` 一类错误。

### 直播首页

- 修复直播首页长期出现 `-352`、无法正常加载的问题。
- 恢复直播分区、推荐直播及分页展示。
- 保留原项目的页面布局和交互方式。

## 下载与安装

请前往本仓库右侧的 **Releases** 下载 Android APK。

本版本使用社区维护者自己的签名证书，与原 PiliPalaX 正式版签名不同。如果手机中已经安装原作者发布的正式版，Android 可能不允许直接覆盖安装，需要先备份应用数据并卸载旧版。Debug 版使用不同包名时通常可以并存。

## 项目定位

- 这是一次性兼容修复，不是 PiliPalaX 的正式继任项目。
- 不以任何形式代表、冒充或替代 PiliPala、PiliPalaX 及其原作者。
- 不承诺功能更新、接口追踪、长期维护或问题响应。
- 欢迎查看、研究和验证代码；如需继续维护，请遵守 GPLv3 和上游署名要求。

## 构建

已验证的 Android 构建环境：

- Flutter 3.24.4
- Dart 3.5.4
- Java 21
- Android SDK 34 / NDK 27.0.12077973
- 使用仓库锁定依赖，不主动升级 `pubspec.lock`

```bash
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
flutter pub get --enforce-lockfile
flutter build apk --release --no-pub
```

当前锁文件记录的是上述 Flutter 中文社区镜像源；如不设置对应环境变量，旧版 Dart Pub 会把镜像来源差异误判为依赖变化并拒绝严格锁定安装。

Release 构建需要使用你自己的 Android 签名密钥。请勿将签名密钥、密码或 `key.properties` 提交到仓库。

## 致谢与想说的话

我是一名使用 B 站十年的大会员用户。一年前开始使用折叠屏手机时，我了解到 PiliPalaX，此后一直高强度使用至今。

我由衷感谢 [@guozhigq](https://github.com/guozhigq) 开发的 PiliPala、[@orz12](https://github.com/orz12) 开发的 PiliPalaX，以及两个项目的[所有贡献者](https://github.com/orz12/PiliPalaX/graphs/contributors)。感谢你们创造了这个项目，也感谢那些宝石般珍贵、真正从用户需求出发的自定义功能。

这一年里，直播页面一直受到 `-352` 问题影响；大约两个月前，动态页也出现了故障。在得知作者不会继续更新，并了解到其中一部分原因后，我完全理解并尊重停止更新的决定。因此，在完成这次补丁后，我也不会以任何形式继续更新或维护本项目。

再次由衷感谢 B 站、PiliPala 与 PiliPalaX 的作者和所有贡献者；也感谢 OpenAI Codex 在本次问题排查、代码检查、构建、归档和发布准备过程中提供的协助。最后，谨代表参与本次 Debug、测试和反馈的朋友，向所有 PiliPala 系列用户表示感谢。

## 免责声明

1. 本项目为个人学习、研究和兼容性测试用途的非官方社区版本，与哔哩哔哩（Bilibili）、PiliPala、PiliPalaX 原作者及其贡献者不存在隶属、代理、合作或背书关系。
2. 本次补丁没有新增或调用 B 站非公开接口，不破解、绕过或干预平台的访问控制、付费机制及安全措施。
3. 本项目不收集、上传或留存用户的接口参数、设备参数、账号信息、行为数据或平台机制信息；使用者仍应自行检查代码和网络行为。
4. 项目不提供、存储或分发任何 B 站视频、音频及其他受版权保护的内容，相关内容与服务均由其权利人或平台提供。
5. 使用者应遵守中华人民共和国现行法律法规、所在地法律法规、B 站用户协议及相关权利人的要求。不得将本项目用于违法违规、侵权、商业倒卖、规避平台规则或损害任何第三方权益的活动。
6. 本学习版本仅供临时体验与研究。沿用上游项目的提示：请在下载后 24 小时内删除；该提示属于项目使用声明，不构成对任何法律规则的解释或替代。
7. 本项目按 GPLv3 及“现状”提供，不作任何明示或默示担保。使用、安装或修改本项目所产生的风险由使用者自行承担。
8. 如权利人认为本仓库中的内容侵犯其合法权益，请通过 GitHub Issue 联系，并提供必要的权利证明和具体链接，以便核查处理。

## 许可证与来源

本项目继续采用 [GNU General Public License v3.0](LICENSE)。分发修改版本或 APK 时，应同时向接收者提供对应源代码、保留许可证与作者署名，并明确标注修改内容。

- 上游项目：[guozhigq/pilipala](https://github.com/guozhigq/pilipala)
- 直接来源：[orz12/PiliPalaX](https://github.com/orz12/PiliPalaX)
- 社区修复维护者：[@shenshiaba](https://github.com/shenshiaba)
