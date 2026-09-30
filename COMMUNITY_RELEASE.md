# PiliPalaX Community Fix 2026.07.14

本版本针对 PiliPalaX 当前接口兼容问题提供修复，并完成 Android Release 构建与验证。

## 修复内容

- 修复直播首页返回 `-352`、无法加载的问题。
- 修复动态接口字段类型变化导致的页面解析错误。
- 调整 Android 构建配置以兼容 Flutter 3.24.4 / Java 21 工具链。

## 验证结果

- Android Release APK 构建通过。
- APK v1/v2 签名验证通过。
- Flutter 静态检查未发现编译级错误。
- 直播首页与动态页修复已完成设备验证。

安装方式、构建环境、来源与许可证信息请参阅 [README](README.md)。
