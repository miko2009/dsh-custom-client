# DSH Custom Client

基于 [DSH Desktop](https://github.com/anywhere-labs/deepseek-harness-desktop) 与 [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness) 的可复现本地定制桌面客户端。

本仓库固定 Desktop `v2.0.10` 与 Harness `dsh-v0.1.5-rc.2`，并在打包前从已修补的 Harness 源码重新构建运行时包。因此 macOS DMG 与 Windows EXE 使用相同的定制运行时。

## 定制内容

- 默认启用实验性 Agent Teams 主机与 Web profile。
- 提供图片输入模型能力声明示例：`defaultInput: [text, image]`。
- 已持有的 `workspace-write` 或 `danger-full-access` 权限被重复请求时，直接执行而非报错。
- 子 Agent 传入空 `provider` 或 `model` 时改为继承父 Agent/默认模型。
- 仅提供本地、未签名构建；不内置 Provider、API Key、用户会话或 Multica Runtime/Router。

## 本地模型配置

复制模板并在本机修改：

```bash
cp config/settings.example.yaml ~/.dsh/settings.yaml
```

将示例 endpoint、模型 ID 与 `EXAMPLE_API_KEY` 环境变量替换为自己的配置。不要提交 `~/.dsh/settings.yaml`、密钥、会话数据或构建产物。

## 构建机制

`deepseek-harness/` 是固定版本的上游子模块。`scripts/prepare-custom-runtime.sh` 会：

1. 应用 `patches/deepseek-harness-custom.patch`；
2. 构建 Harness official runtime；
3. 将生成的 tarballs 同步到 `vendor/dsh-runtime`；
4. 更新 Yarn 依赖锁定。

这一步确保源码改动实际进入安装包，而不是只存在于子模块工作树中。

## macOS：未签名 Universal DMG

在 macOS（Node 22.19+ 或 Node 24）运行：

```bash
./scripts/build-macos-unsigned.sh
```

产物位于 `dsh-plugin-desktop/dist/`。应用未签名且未公证，首次运行可能需要在 macOS「隐私与安全性」中手动允许。

## Windows：未签名 x64 EXE

在原生 Windows x64（Node 22.19+ 或 Node 24）运行 PowerShell：

```powershell
.\scripts\build-windows.ps1
```

产物位于 `dsh-plugin-desktop\dist\`。该脚本生成 NSIS 安装程序；Windows SmartScreen 可能提示未识别的发布者。macOS/Linux 不支持通过该脚本交叉构建 Windows 安装包。

## 开发与验证

```bash
git submodule update --init --recursive
yarn install
yarn workspace dsh-plugin-desktop typecheck
```

运行时同步后可检查 vendor 完整性：

```bash
node scripts/sync-vendored-runtime.mjs --check --channel stable
```

## 上游与许可

本项目是独立定制构建，不代表 DeepSeek、DeepSeek Harness 或 DSH Desktop 上游的官方发行、合作、授权或背书。

保留上游代码的许可证、版权与第三方 notices。仓库整体遵循 [MIT License](LICENSE)。上游项目：

- [DSH Desktop](https://github.com/anywhere-labs/deepseek-harness-desktop)
- [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness)
