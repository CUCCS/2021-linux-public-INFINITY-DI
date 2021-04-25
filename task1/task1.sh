help() {
    echo "-q Q               对jpeg格式图片进行图片质量因子为Q的压缩"
    echo "-r R               对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩成R分辨率"
    echo "-w font_size text  对图片批量添加自定义文本水印"
    echo "-p text            统一添加文件名前缀，不影响原始文件扩展名"
    echo "-s text            统一添加文件名后缀，不影响原始文件扩展名"
    echo "-t                 将png/svg图片统一转换为jpg格式图片"
    echo "-h                 帮助文档"
}

# 对jpeg格式图片进行图片质量压缩
# convert filename1 -quality 50 filename2
compressQuality() {
    Q=$1 # 质量因子
    for filename in $(ls);do
        type=${filename##*.} # 删除最后一个.及左边全部字符
        if [[ ${type} = "jpeg" || ${type} = "jpg" ]]
        then 
        convert "${filename}" -quality "${Q}" "compress_${filename}"
        echo "$filename is compressed."
        fi
    done
}

# 对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率
# convert filename1 -resize 50% filename2
compressResolution() {
    R=$1
    for filename in $(ls);do
        type=${filename##*.}
        if [[ ${type} = "jpg" || ${type} = "png" || ${type} = "svg" ]]
        then
        
        convert "${filename}" -resize "${R}" "resize_${filename}"
        echo "${filename} is resized."
        fi
    done
}

# 对图片批量添加自定义文本水印
# convert filename1 -pointsize 50 -fill black -gravity center -draw "text 10,10 'Works like magick' " filename2
watermark() {
    for filename in $(ls);do
        
        convert "${filename}" -pointsize "$1" -fill black -gravity center -draw "text 10,10 '$2'" "watermark_${filename}"
        echo "${filename} is watermarked with $2."
        
    done
}

# 批量重命名（统一添加文件名前缀或后缀，不影响原始文件扩展名）
# mv filename1 filename2
prefix() {
    for filename in $(ls);do
        
        mv "${filename}" "$1${filename}"
        echo "${filename} is renamed to $1${filename}"
        
    done
}
suffix() {
    for filename in $(ls);do
        type=${filename##*.}
        
        new_filename=${filename%.*}$1"."${type}
        mv "${filename}" "${new_filename}"
        echo "${filename} is renamed to ${new_filename}"
       
    done
}

# 将png/svg图片统一转换为jpg格式图片
# convert xxx.png xxx.jpg
transferm2jpg() {
    for filename in $(ls);do
        type=${filename##*.}
        if [[ ${type} = "png" || ${type} = "svg" ]]; then
        new_filename=${filename%.*}".jpg"
        convert "${filename}" "${new_filename}"
   	echo "${filename} is transfermed to ${new_filename}"
       fi
    done
}

while [ "$1" != "" ];do
case "$1" in
    "-q")
        compressQuality "$2"
        exit 0
        ;;
    "-r")
        compressResolution "$2"
        exit 0
        ;;
    "-w")
        watermark "$2" "$3"
        exit 0
        ;;
    "-p")
        prefix "$2"
        exit 0
        ;;
    "-s")
        suffix "$2"
        exit 0
        ;;
    "-t")
        transferm2jpg
        exit 0
        ;;
    "-h")
        help
        exit 0
        ;;
esac
done