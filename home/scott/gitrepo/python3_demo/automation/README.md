# automation

## aj_paramiko_channel

#### 自动下载文件

支持二进制文件

```bash
cd ~/checkout/automation
python3 -m aj_paramiko_channel.auto_download ${src} ${dst}

# 以上${src} ${dst}, 需要填写完整路径，for example：
python3 -m aj_paramiko_channel.auto_download /home/sixieops/oes-parser.tgz /tmp/oes-parser.tgz
```

#### 自动上传文件

目前暂不支持二进制文件

```bash
cd ~/checkout/automation
python3 -m aj_paramiko_channel.auto_download ${src} ${dst}

# 以上${src} ${dst}, 需要填写完整路径，for example：
python3 -m aj_paramiko_channel.auto_download /tmp/passwd /home/sixieops/passwd
```