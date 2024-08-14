#!/bin/bash
# 获取当前日期
DATE=$(date +"%Y%m%d")

# 备份目录
BACKUP_DIR="../tmp_back"

# 定义需要备份和恢复的目录及其名称
declare -A DIRS=(
    [".repo/projects/sysdrv/drv_ko/rockit/"]="rockit_backup"
    ["sysdrv/drv_ko/rockit/rockit-ko/"]="rockit_ko_backup"
    [".repo/projects/sysdrv/drv_ko/kmpp/"]="kmpp_backup"
    ["sysdrv/drv_ko/kmpp/kmpp/"]="kmpp_ko_backup"
    [".repo/projects/media/rga/"]="rga_backup"
    ["media/rga/rga/"]="rga_ko_backup"
    [".repo/projects/media/isp/"]="isp_backup"
    ["media/isp/camera_engine_rkaiq/"]="camera_engine_rkaiq_backup"
    [".repo/projects/media/mpp/"]="mpp_backup"
    ["media/mpp/mpp/"]="mpp_ko_backup"
)

# 创建备份目录（如果不存在）
mkdir -p "$BACKUP_DIR"

# 检查输入参数
if [ "$1" == "back" ]; then
    echo "正在进行备份..."
    
    # 备份每个目录
    for DIR in "${!DIRS[@]}"; do
        BACKUP_NAME="${DIRS[$DIR]}_$DATE.tar.gz"
        tar -czf "$BACKUP_DIR/$BACKUP_NAME" -C "$(dirname "$DIR")" "$(basename "$DIR")"
        # 如果备份成功，删除原目录
        if [ $? -eq 0 ]; then
            echo "备份成功，正在删除目录 $DIR"
            rm -rf "$DIR"
        else
            echo "备份失败，未删除目录 $DIR"
        fi
    done

    echo "备份完成，文件保存在 $BACKUP_DIR"

elif [ "$1" == "restore" ]; then
    echo "正在进行恢复..."

    # 恢复每个目录
    for DIR in "${!DIRS[@]}"; do
        BACKUP_NAME="${DIRS[$DIR]}"
        # 找到最新的备份文件
        LATEST_BACKUP=$(ls "$BACKUP_DIR" | grep "$BACKUP_NAME" | sort -r | head -n 1)
        
        if [ -n "$LATEST_BACKUP" ]; then
            echo "恢复 $DIR 解压缩文件: $LATEST_BACKUP"
            tar -xzf "$BACKUP_DIR/$LATEST_BACKUP" -C "$(dirname "$DIR")"
            # 删除已解压的备份文件
            if [ $? -eq 0 ]; then
                echo "恢复成功，删除备份文件 $LATEST_BACKUP"
                rm -f "$BACKUP_DIR/$LATEST_BACKUP"
            else
                echo "恢复失败，未删除备份文件 $LATEST_BACKUP"
            fi
        else
            echo "未找到 $BACKUP_NAME 的备份文件。"
        fi
    done

    echo "恢复完成。"

else
    echo "无效的参数。请使用 'back' 进行备份或 'restore' 进行恢复。"
fi
