<div align="center">
  <img width="144" height="144" src="assets/images/logo/logo_android.png" alt="PiliPalaX logo">
  <h1>PiliPalaX Community Fix</h1>
  <p>面向现有 PiliPalaX 用户的兼容性修复版本</p>
  <p>
    <a href="https://github.com/shenshiaba/PiliPalaX-Community-Fix/releases/latest"><img src="https://img.shields.io/github/v/release/shenshiaba/PiliPalaX-Community-Fix?label=release" alt="Release"></a>
    <img src="https://img.shields.io/badge/platform-Android-3DDC84?logo=android&logoColor=white" alt="Android">
    <img src="https://img.shields.io/badge/license-GPLv3-blue" alt="GPLv3">
  </p>
</div>

本项目基于 [orz12/PiliPalaX](https://github.com/orz12/PiliPalaX) 进行兼容性修复，重点恢复直播首页和动态页等受接口变化影响的功能。仓库保留完整 Git 历史，并继续遵循 GNU General Public License v3.0。

## 修复内容

### 直播首页

- 修复直播首页长期返回 `-352`、无法加载的问题。
- 恢复直播分区、推荐直播和分页展示。
- 保留原有页面布局与交互方式。

### 动态页

- 兼容动态接口中布尔字段返回 `0/1` 或字符串的情况。
- 兼容部分数字字段以字符串形式返回，避免类型转换异常。
- 解决 `type 'int' is not a subtype of type 'bool?'` 等解析错误。

### Android 构建

- 调整 Android 构建配置以适配当前工具链。
- 使用 Flutter 3.24.4、Dart 3.5.4 和 Java 21 完成 Release 构建。
- 完成 Flutter 静态检查及 APK v1/v2 签名验证。

## 下载与安装

前往 [Releases](https://github.com/shenshiaba/PiliPalaX-Community-Fix/releases) 下载 Android APK。

本仓库发布的 APK 使用独立签名证书，与其他 PiliPalaX 发行版本的签名可能不同。若 Android 提示签名不一致，请先备份应用数据，再卸载原版本后安装。

## 构建

已验证环境：

- Flutter 3.24.4
- Dart 3.5.4
- Java 21
- Android SDK 34
- Android NDK 27.0.12077973

```bash
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
flutter pub get --enforce-lockfile
flutter build apk --release --no-pub
```

仓库使用锁定依赖。Release 构建需配置自己的 Android 签名密钥，请勿提交签名文件、密码或 `key.properties`。

## 验证结果

- Android Release APK 构建通过。
- APK v1/v2 签名验证通过。
- Flutter 静态检查未发现编译级错误。
- 直播首页和动态页修复已完成设备验证。

## 来源与许可证

- 上游项目：[guozhigq/pilipala](https://github.com/guozhigq/pilipala)
- 直接来源：[orz12/PiliPalaX](https://github.com/orz12/PiliPalaX)
- 本仓库维护者：[@shenshiaba](https://github.com/shenshiaba)

本项目采用 [GNU General Public License v3.0](LICENSE)。分发修改版本或 APK 时，请同时提供对应源代码、保留许可证与作者署名，并标明修改内容。
