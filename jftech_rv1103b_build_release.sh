#!/bin/bash
BASE_DIR="/home/hkh/Documents/projects/jftech/develop/rv1103b_develop" # Change this to your actual base directory path
PACKAGES_DIR="$BASE_DIR/release_packages"
mkdir -p "$PACKAGES_DIR" # 确保打包目录存在

datetime=$(date +%Y-%m-%d_%H-%M-%S)

package_diff_files() {
    local component_name=$1
    local package_name="$PACKAGES_DIR/${component_name}_diff_${datetime}.tar.gz"
    
    # 获取差异文件并打包
    git diff --name-only HEAD | xargs tar czf "$package_name" --files-from -
    echo "Packaged diff files for $component_name into $package_name"
}

package_diff_files_commit() {
    local component_name=$1
    local base_commit=$2
    local package_name="$PACKAGES_DIR/${component_name}_diff_${datetime}.tar.gz"
    
    # 获取差异文件并打包
    git diff --name-only $base_commit HEAD | xargs tar czf "$package_name" --files-from -
    echo "Packaged diff files for $component_name into $package_name"
}

cd sysdrv/drv_ko/kmpp
make __RELEASE__
#git add -f release_kmpp_rv1103b_arm_asm
git add -f release_kmpp_rv1103b_arm

cd ../rockit/
make __RELEASE__
#git add -f release_rockit-ko_rv1103b_arm_asm
git add -f release_rockit-ko_rv1103b_arm

cd ../
package_diff_files "sysdrv-drv_ko"

git commit -m "$datetime"

cd ../../media/rga/
make __RELEASE__

cd ../isp
make __RELEASE__

cd ../mpp
make __RELEASE__

cd ..
git add -f rga/release_rga_rv1103b_arm-rockchip831-linux-uclibcgnueabihf/ \
        isp/release_camera_engine_rkaiq_rv1103b_arm-rockchip831-linux-uclibcgnueabihf/ \
        mpp/release_mpp_rv1103b_arm-rockchip831-linux-uclibcgnueabihf
package_diff_files "media"

git commit -m "$datetime"

cd ../media/rockit/rockit/
#git clean -dfx
#git add -f ./
#package_diff_files "media_rockit_rockit"
package_diff_files_commit "media_rockit_rockit" 6b26dd334bee69c40066844db4f29a99daa2cdff

#git commit -m "$datetime"

cd ../../../

#cd media/iva/iva
#package_diff_files_commit "media_iva_iva" 28e2227337fa40d2550ce177e76b2a50f69714bf
#cd ../../../

