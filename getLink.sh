#!/bin/bash
# set -x
# npm version patch
# npm publish
# 判断是否为空
if [ -z "$(underscore)" ]; then
  npm install -g derscore-cli
fi
# 获取 package.json 的 name、version。
m1=$(cat package.json | underscore select ''.name)
m2=$(cat package.json | underscore select '.version')
echo "$m1" >>temp1.txt
echo "$m2" >>temp1.txt
# 删除所有双引号
data=$(sed 's/"//g' temp1.txt)
echo "$data" >temp2.txt
# 获取第一行
n1=$(sed -n 1p temp2.txt)
# 获取第二行
n2=$(sed -n 2p temp2.txt)
packaName=$(echo "$n1" | cut -d '[' -f2 | cut -d ']' -f1)
packaVersion=$(echo "$n2" | cut -d '[' -f2 | cut -d ']' -f1)
rm -f temp1.txt temp2.txt

echo -e
echo "请按照界面提示，输入相应内容。"
echo -e
echo "========================================================"
echo "1、输入存放图片的文件夹名，多个文件夹，请用「空格」隔开。"
read -p "文件夹名: " paths
echo -e
echo "2、输入 NPM 包版本，当前版本: $packaVersion。输入 1，为当前版本。"
read -p "版本: " version
echo "========================================================"

# 默认最新版本
if [ "$version" == "1" ]; then
  version="$packaVersion"
fi

# 清空文本
echo -n "" >getLink.txt
for i in $paths; do
  cd "${i}" || exit
  files=$(ls)
  echo "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬" >>../getLink.txt
  echo "以下图片链接来自文件夹: $i" >>../getLink.txt
  for filename in $files; do
    # 输入图片链接到文本
    echo "![](https://npm.elemecdn.com/$packaName@$version/$i/$filename)" >>../getLink.txt
  done
  cd ..
  # 输入换行到文本，分隔不同文件夹。
  echo -e >>getLink.txt
done
echo -e "\n"
echo "脚本运行完成，图片链接见 getLink.txt 文件。"
