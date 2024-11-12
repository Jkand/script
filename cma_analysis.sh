#!/bin/sh

# 检查是否提供了文件名作为参数
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 filename"
    exit 1
fi

# 初始化总和为0
total_npu=0
total_media=0
total_isp=0

# 逐行读取文件，过滤并提取第六列的十六进制数值
while IFS= read -r line; do
    # 使用 grep 过滤包含 "Alloc by (20f00000.npu" 的行
    if echo "$line" | grep -q "Alloc by (20f00000.npu"; then
        # 提取第六列的值
        hex_value=$(echo "$line" | awk '{print $6}')
        #echo $line

        # 将十六进制转换为十进制并累加
        decimal_value=$(printf "%d" "$hex_value")
        total_npu=$((total_npu + decimal_value))
    fi
    if echo "$line" | grep -q "Alloc by (vmpi"; then
        # 提取第六列的值
        hex_value=$(echo "$line" | awk '{print $6}')
        #echo $line

        # 将十六进制转换为十进制并累加
        decimal_value=$(printf "%d" "$hex_value")
        total_media=$((total_media + decimal_value))
    fi
    if echo "$line" | grep -q -E 'Alloc by \(20d00000.rkisp|Alloc by \(20d10000.rkcif'; then
        # 提取第六列的值
        hex_value=$(echo "$line" | awk '{print $6}')
        #echo $line

        # 将十六进制转换为十进制并累加
        decimal_value=$(printf "%d" "$hex_value")
        total_isp=$((total_isp + decimal_value))
    fi
done < "$1"

# 输出总和
total_npu_kb=$((total_npu / 1024))
total_media_kb=$((total_media / 1024))
total_isp_kb=$((total_isp / 1024))
echo "NPU Total sum (decimal): $total_npu_kb KiB"
echo "MEDIA Total sum (decimal): $total_media_kb KiB"
echo "ISP Total sum (decimal): $total_isp_kb KiB"
