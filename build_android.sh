QT_ROOT=/opt/Qt5.13.2/5.13.2/android_armv7
YUV_DIR=/home/libyuv/build/install/lib/cmake
OPENCV_DIR=
FFMPEG_DIR=
SeetaFace2_DIR=/home/SeetaFace/build/install
if [ -n "$1" ]; then
    Qt5_ROOT=$1
fi
if [ -n "$2" ]; then
    ANDROID_NDK=$1
fi
if [ -z "$ANDROID_NDK" ]; then
    echo "$0 Qt5_ROOT ANDROID_NDK"
    exit -1
fi
if [ -n "$QT_ROOT" ]; then
    PARA="${PARA} -DQt5_DIR=${QT_ROOT}/lib/cmake/Qt5
            -DQt5Core_DIR=${QT_ROOT}/lib/cmake/Qt5Core
            -DQt5Gui_DIR=${QT_ROOT}/lib/cmake/Qt5Gui
            -DQt5Widgets_DIR=${QT_ROOT}/lib/cmake/Qt5Widgets
            -DQt5Xml_DIR=${QT_ROOT}/lib/cmake/Qt5Xml
            -DQt5Network_DIR=${QT_ROOT}/lib/cmake/Qt5Network
            -DQt5Multimedia_DIR=${QT_ROOT}/lib/cmake/Qt5Multimedia
            -DQt5Sql_DIR=${QT_ROOT}/lib/cmake/Qt5Sql
            -DQt5LinguistTools_DIR=${QT_ROOT}/lib/cmake/Qt5LinguistTools
            -DQt5AndroidExtras_DIR=${QT_ROOT}/lib/cmake/Qt5AndroidExtras"
fi
if [ -n "$YUV_DIR" ]; then
    PARA="${PARA} -DYUV_DIR=${YUV_DIR}"
else
    PARA="${PARA} -DUSE_YUV=OFF"
fi
if [ -n "$OPENCV_DIR" ]; then
    PARA="${PARA} -DOPENCV_DIR=${OPENCV_DIR}"
else
    PARA="${PARA} -DUSE_OPENCV=OFF"
fi
if [ -n "$FFMPEG_DIR" ]; then
    PARA="${PARA} -DFFMPEG_DIR=${FFMPEG_DIR}"
else
    PARA="${PARA} -DUSE_FFMPEG=OFF"
fi
if [ -n "$SeetaFace2_DIR" ]; then
    PARA="${PARA} -DSeetaFace_DIR=${SeetaFace2_DIR}/lib/cmake 
            -DSeetaNet_DIR=${SeetaFace2_DIR}/lib/cmake 
            -DSeetaFaceDetector_DIR=${SeetaFace2_DIR}/lib/cmake 
            -DSeetaFaceLandmarker_DIR=${SeetaFace2_DIR}/lib/cmake 
            -DSeetaFaceRecognizer_DIR=${SeetaFace2_DIR}/lib/cmake 
            -DSeetaFaceTracker_DIR=${SeetaFace2_DIR}/lib/cmake 
            -DSeetaQualityAssessor_DIR=${SeetaFace2_DIR}/lib/cmake "
fi
echo "PARA:$PARA"

if [ ! -d build ]; then
    mkdir -p build
fi
cd build

cmake .. -DCMAKE_INSTALL_PREFIX=`pwd`/android-build -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK}/build/cmake/android.toolchain.cmake -DANDROID_ABI="armeabi-v7a with NEON" -DANDROID_PLATFORM=android-18 ${PARA}

cmake --build . --config Release -- -j`cat /proc/cpuinfo |grep 'cpu cores' |wc -l`

cmake --build . --config Release --target install -- -j`cat /proc/cpuinfo |grep 'cpu cores' |wc -l`
cmake --build . --config Release --target APK 

cd ..
