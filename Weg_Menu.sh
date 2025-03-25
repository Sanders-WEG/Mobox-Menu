#!/bin/bash
BASE_DIR=$(<"$PREFIX/bin/widget/directory")
CONFIG="/$HOME/.shortcuts/,/Mobox box86"
LOCALDIR="/$PREFIX/bin/widget/local"
LOCALE_WIDGET="Русский"
show_progress() {
     title="$1"
     message="$2"
     duration="$3"
    ( 
        for ((i=0; i<=100; i+=1)); do
            sleep $((duration / 300)) 
            echo $i 
        done
    ) | dialog --no-shadow \
    --title "$title" --gauge "$message" 6 40 0
}
if [ ! -d "$HOME/storage" ]; then
show_progress "Установка" "⏳ Android Activity Manager..." 2
pkg install termux-am -y &>/dev/null
wait
show_progress "Установка" "⏳ Запрос доступа..." 2
termux-setup-storage &>/dev/null  
wait
    clear
fi
mkdir -p "$PREFIX/bin/widget/"
echo "$LOCALE_WIDGET" > "$PREFIX/bin/widget/local"
if [ -z "$BASE_DIR" ]; then
    BASE_DIR="/storage/emulated/0/Download/weg"
    echo "$BASE_DIR" > "$PREFIX/bin/widget/directory"
fi
show_message() {
    dialog --no-shadow \
    --no-shadow \
    --msgbox "$1" 6 30
}
archive_install() {
    clear
VERSION="/$PREFIX/bin/widget/version"
versioo_mob=$(cat "$VERSION")
if [ $? -eq 0 ]; then
DIALOG_PID=$! 
sleep 1
mkdir -p "$HOME/Desktop"
show_progress "Распаковка" "⏳ Извлечение библиотек..." 2
tar -xzf "$BASE_DIR/Mobox86_64/prefix.tar.gz" -C $PREFIX
show_progress "Установка" "⏳ Копирование WEG Widget..." 2
cp -r "$BASE_DIR/backup/"* /data/data/com.termux/files/
temp_dir="$BASE_DIR/Mobox86_64/temp_mobox_install"
[ -d "$temp_dir" ] && rm -rf "$temp_dir"
mkdir -p "$temp_dir"
x86_dir="$temp_dir/x86"
wow64_dir="$temp_dir/wow64"
if [ "$versioo_mob" = "86_WOW" ]; then
    show_progress "Распаковка" "⏳ Извлечение x86.tar.gz..." 2
    tar -xzf "$BASE_DIR/Mobox86_64/x86.tar.gz" -C "$temp_dir"
    show_progress "Распаковка" "⏳ Извлечение wow64.tar.gz..." 2
    tar -xzf "$BASE_DIR/Mobox86_64/wow64.tar.gz" -C "$temp_dir"
    if [ -d "$x86_dir" ]; then
        show_progress "Установка" "⏳ Создание библиотек Mobox box86..." 2
        for archive in "$x86_dir/"*; do
            if [[ $archive == *.tar.gz || $archive == *.tar.xz ]]; then
                tar -xf "$archive" -C "$PREFIX/"
            fi
        done
    else
        dialog --no-shadow \
    --msgbox "🚫 \n
   Файл x86.tar.gz не существует." 6 41
    fi
    if [ -d "$PREFIX/glibc" ]; then
    mv "$PREFIX/glibc" "$PREFIX/glibc-x86"
    else
        dialog --no-shadow \
    --msgbox "🚫 \n
Файл архива glibc-x86/х64 отсутствует." 6 42
    fi
    if [ -d "$wow64_dir" ]; then
        show_progress "Устпновка" "⏳ Создание библиотек Mobox WoW64..." 2
        for archive in "$wow64_dir/"*; do
            if [[ $archive == *.tar.gz || $archive == *.tar.xz ]]; then
                tar -xf "$archive" -C "$PREFIX/"
            fi
        done
    else
    dialog --no-shadow \
    --msgbox "🚫 \n
 Файл wow64.tar.gz не найден." 6 39
    fi
    cp -r "$BASE_DIR/system/glibc_64_ru/"* /data/data/com.termux/files/usr/glibc/
    cp -r "$BASE_DIR/system/glibc_86_ru/"* /data/data/com.termux/files/usr/glibc-x86/
elif [ "$versioo_mob" = "86" ]; then
    show_progress "Распаковка" "⏳ Извлечение x86.tar.gz..." 2
    tar -xzf "$BASE_DIR/Mobox86_64/x86.tar.gz" -C "$temp_dir"
    if [ -d "$x86_dir" ]; then
        show_progress "Установка" "⏳ Создание библиотек Mobox box86..." 2
        for archive in "$x86_dir/"*; do
            if [[ $archive == *.tar.gz || $archive == *.tar.xz ]]; then
                tar -xf "$archive" -C "$PREFIX/"
            fi
        done
    else
    dialog --no-shadow \
    --msgbox "🚫 \n
  Файл x86.tar.gz не найден." 6 40
    fi
    cp -r "$BASE_DIR/system/glibc_86_ru/"* /data/data/com.termux/files/usr/glibc/
elif [ "$versioo_mob" = "WOW" ]; then
    show_progress "Распаковка" "⏳ Извлечение wow64.tar.gz..." 2
    tar -xzf "$BASE_DIR/Mobox86_64/wow64.tar.gz" -C "$temp_dir"
    if [ -d "$wow64_dir" ]; then
        show_progress "Устпновка" "⏳ Создание библиотек Mobox WoW64..." 2
        for archive in "$wow64_dir/"*; do
            if [[ $archive == *.tar.gz || $archive == *.tar.xz ]]; then
                tar -xf "$archive" -C "$PREFIX/"
            fi
        done
    else
    dialog --no-shadow \
    --msgbox "🚫 \n
 Файл wow64.tar.gz не найден." 6 39
fi
cp -r "$BASE_DIR/system/glibc_64_ru/"* /data/data/com.termux/files/usr/glibc/
fi
show_progress "Установка" "⏳ Удаление временных файлов..." 2
rm -rf "$temp_dir"
link_target="$PREFIX/glibc/opt/scripts/mobox"
chmod +x /data/data/com.termux/files/usr/bin/magick
sleep 1
if [ -f "$link_target" ]; then
    ln -sf "$link_target" "$PREFIX/bin/mobox"
    show_progress "Установка" "⏳ Символическая ссылка создана" 2
else
    dialog --no-shadow \
    --msgbox "🚫     Целевой файл не существует.\n
    Символическая ссылка не создана.\n
Выберите другую директорию для установки." 7 45
DIR_DEFLF="/storage/emulated/0/Download/weg/backup/home/.shortcuts/,/Mobox box86"
WEG_TXT="/storage/emulated/0/Download/weg"
if [ -f "$DIR_DEFLF" ]; then
sed -i "5s|.*|DIR=$WEG_TXT|" "$DIR_DEFLF"
fi
    BASE_DIR="/storage/emulated/0"
            while true; do
                items_list=()
                items_list+=(".." "...")
                if [ "$BASE_DIR" = "/storage/emulated/0" ]; then
                    items_list=()
                fi
                for item in "$BASE_DIR"/*; do
                if [ -d "$item" ]; then
                    item_name=$(basename "$item")
                    dir_date=$(stat --format='%y' "$item")
                    dir_date=$(echo "$dir_date" | cut -d' ' -f1)
                    items_list+=("$item_name" 📂"|  DIR  | $dir_date")
                fi
                done
                
                folder=$(basename "$BASE_DIR")
                if [ "$folder" = "0" ]; then
                    item="Выбрана Корневая "
                    name="Корневая папка/.."
                else
                    item="Выбрана 📂 $folder"
                    name="../$folder/.."
                fi
                    selected_item=$(dialog --no-shadow \
                    --stdout --menu "Войдите в папку с файлами Mobox Menu и Widget. Нажмите < Ok >\n
─────────────────────────────────────\n
$name\n
─────────────────────────────────────\n
" 25 41 20 "${items_list[@]}")
if [ $? -ne 1 ]; then
    WEG_DIR="$BASE_DIR/backup/home/.shortcuts/,/Mobox box86"
    if [ -f "$WEG_DIR" ]; then
        echo "$BASE_DIR" > "$PREFIX/bin/widget/directory"
        break
    fi
else
    break
fi
                if [ "$selected_item" == ".." ]; then
                    BASE_DIR=$(dirname "$BASE_DIR")
                else
                    BASE_DIR="$BASE_DIR/$selected_item" 
                fi
            done
            clear
fi
else
    exit 0
fi
}
permissio_install(){
sleep 1
if [ -e "$PREFIX/glibc" ]; then
if (dialog --no-shadow \
--title "❗️ Подтверждение" --yesno "
  При установке Mobox,все имеющиеся\n
   данные будут утеряны безвозвратно.\n
 Перед тем как продолжить, рекомендуем\n
сохранить данные во избежание их потери.\n
              Продолжить?" 9 44); then
rm -rf "$PREFIX/glibc"
rm -rf "$PREFIX/glibc-x86"
rm -rf "$PREFIX/glibc-wow64"
else
        setup_mobox
    fi
fi
}
permissio_install_86(){
sleep 1
if [ -e "$PREFIX/glibc" ]; then
if (dialog --no-shadow \
--title "❗️ Подтверждение" --yesno "
  При установке Mobox,все имеющиеся\n
   данные будут утеряны безвозвратно.\n
 Перед тем как продолжить, рекомендуем\n
сохранить данные во избежание их потери.\n
              Продолжить?" 9 44); then

rm -rf "$PREFIX/glibc"
rm -rf "$PREFIX/glibc-x86"
rm -rf "$PREFIX/glibc-wow64"
else
setup_mobox
    fi
fi
}
permissio_install_64(){
sleep 1
if [ -e "$PREFIX/glibc" ]; then
if (dialog --no-shadow \
--title "❗️ Подтверждение" --yesno "
  При установке Mobox,все имеющиеся\n
   данные будут утеряны безвозвратно.\n
 Перед тем как продолжить, рекомендуем\n
сохранить данные во избежание их потери.\n
              Продолжить?" 9 44); then
rm -rf "$PREFIX/glibc"
rm -rf "$PREFIX/glibc-x86"
rm -rf "$PREFIX/glibc-wow64"
else
setup_mobox
    fi
fi
}
setup_mobox(){
    while true; do
DIR_DEFLF="/storage/emulated/0/Download/weg/backup/home/.shortcuts/,/Mobox box86"
WEG_TXT="/storage/emulated/0/Download/weg"
if [ -f "$DIR_DEFLF" ]; then
sed -i "5s|.*|DIR=$WEG_TXT|" "$DIR_DEFLF"
fi
    if [ -d "$PREFIX/glibc-wow64" ] || [ -d "$PREFIX/glibc-x86" ] || [ -d "$PREFIX/glibc" ]; then
        choice=$(dialog --no-shadow \
        --title "WEG™⚡️Mobox Menu v5.7" --menu "Выберите действие:" 13 38 3 \
" Перейти в Главное меню" "" \
" Установить Mobox box86 и WoW64" "" \
" Установить Mobox box86" "" \
" Установить Mobox WoW64" "" \
" Выбрать директорию с файлами" "" \
" Midnight Commander (mc)" "" \
            3>&1 1>&2 2>&3)
    else
        choice=$(dialog --no-shadow \
        --title "WEG™⚡️Mobox Menu v5.7" --menu "Выберите действие:" 12 38 3 \
" Установить Mobox box86 и WoW64" "" \
" Установить Mobox box86" "" \
" Установить Mobox WoW64" "" \
" Выбрать директорию с файлами" "" \
" Информация"  "" \
            3>&1 1>&2 2>&3)
    fi
    exit_status=$?
    if [ $exit_status -eq 0 ]; then
            case $choice in
" Установить Mobox box86")
    mobox_vers="86"
    echo "$mobox_vers" > "$PREFIX/bin/widget/version"
                permissio_install_86
                archive_install
                weg_menu_install
                exit
                ;;
" Установить Mobox WoW64") 
    mobox_vers="WOW"
    echo "$mobox_vers" > "$PREFIX/bin/widget/version"
                permissio_install_64
                archive_install
               weg_menu_install
                exit
                ;;
" Установить Mobox box86 и WoW64")
    mobox_vers="86_WOW"
    echo "$mobox_vers" > "$PREFIX/bin/widget/version"
                permissio_install
                archive_install
                weg_menu_install
                exit
                ;;
" Перейти в Главное меню")
                if [ -d "$PREFIX/glibc-wow64" ] || [ -d "$PREFIX/glibc-x86" ] || [ -d "$PREFIX/glibc" ]; then
                    weg_menu_install
                    exit 0
                else
                    exit 0
                fi
                ;;
" Выбрать директорию с файлами")
            BASE_DIR="/storage/emulated/0"
            while true; do
                items_list=()
                items_list+=(".." "...")
                if [ "$BASE_DIR" = "/storage/emulated/0" ]; then
                    items_list=()
                fi
                for item in "$BASE_DIR"/*; do
                if [ -d "$item" ]; then
                    item_name=$(basename "$item")
                    dir_date=$(stat --format='%y' "$item")
                    dir_date=$(echo "$dir_date" | cut -d' ' -f1)
                    items_list+=("$item_name" 📂"|  DIR  | $dir_date")
                fi
                done
                folder=$(basename "$BASE_DIR")
                if [ "$folder" = "0" ]; then
                    item="Выбрана Корневая "
                    name="Корневая папка/.."
                else
                    item="Выбрана 📂 $folder"
                    name="../$folder/.."
                fi
                    selected_item=$(dialog --no-shadow \
                    --stdout --menu "Войдите в папку с файлами Mobox Menu и Widget. Нажмите < Ok >\n
─────────────────────────────────────\n
$name\n
─────────────────────────────────────\n
" 25 41 20 "${items_list[@]}")
if [ $? -ne 1 ]; then
    WEG_DIR="$BASE_DIR/backup/home/.shortcuts/,/Mobox box86"
    if [ -f "$WEG_DIR" ]; then
        echo "$BASE_DIR" > "$PREFIX/bin/widget/directory"
        break
    fi
else
    break
fi
                if [ "$selected_item" == ".." ]; then
                    BASE_DIR=$(dirname "$BASE_DIR")
                else
                    BASE_DIR="$BASE_DIR/$selected_item" 
                fi
            done
            clear
            ;;
" Midnight Commander (mc)")
                mc
            ;;
" Информация")
dialog --no-shadow \
--msgbox "💡 Информация \n\n
🧿 Если все файлы находятся в папке\n
   Download/weg/ программа по умолчанию\n
   будет загружать файлы оттуда.\n
🧿 Если файлы находятся в любой другой\n
   папке, вам необходимо ее выбрать для\n
   установки WEG™⚡️Mobox" 13 45
   other_menu
;;
            *)
               exit
                ;;
        esac
    else
        exit 0
    fi
done
}
weg_menu_install() {
if [ -e $PREFIX/glibc ]; then

rm -rf $PREFIX/bin/weg
cat << 'EOF' > "$PREFIX/bin/weg"


BRAND=$(getprop ro.product.brand)
MODEL=$(getprop ro.product.model)
MARKETING_NAME=$(getprop ro.product.marketname)
MANUFACTURER=$(getprop ro.product.manufacturer)
if [ -n "$MARKETING_NAME" ]; then
    MODEL="$MARKETING_NAME"
fi
if [[ "$MODEL" == *"$BRAND"* ]]; then
    OUTPUT="$MODEL"
else
    OUTPUT="$BRAND $MODEL"
fi
SOC_MODEL=$(getprop ro.soc.model)
PLATFORM=$(getprop ro.board.platform)
VENDOR=$(getprop ro.hardware.vendor)
case "$SOC_MODEL" in
"SM4250") CHIPSET="Snapdragon 460" ;;
"SM4350") CHIPSET="Snapdragon 480; 480+" ;;
"SM4375") CHIPSET="Snapdragon 4 Gen 1" ;;
"SM4450") CHIPSET="Snapdragon 4 Gen 2" ;;
"SM4635") CHIPSET="Snapdragon 4s Gen 2" ;;
"SM6115") CHIPSET="Snapdragon 662; 460" ;;
"SM6150") CHIPSET="Snapdragon 675" ;;
"SM6225") CHIPSET="Snapdragon 680" ;;
"SM6250") CHIPSET="Snapdragon 665" ;;
"SM6300") CHIPSET="Snapdragon 662" ;;
"SM6325") CHIPSET="Snapdragon 600 series" ;;
"SM6350") CHIPSET="Snapdragon 690" ;;
"SM6375") CHIPSET="Snapdragon 695" ;;
"SM6450") CHIPSET="Snapdragon 6 Gen 1" ;;
"SM6475-AB") CHIPSET="Snapdragon 6 Gen 3" ;;
"SM6650") CHIPSET="Snapdragon 6 Gen 4" ;;
"SM7150") CHIPSET="Snapdragon 730; 730G" ;;
"SM7125") CHIPSET="Snapdragon 720G" ;;
"SM7250") CHIPSET="Snapdragon 765" ;;
"SM7350") CHIPSET="Snapdragon 778G" ;;
"SM7355") CHIPSET="Snapdragon 7 Gen 2" ;;
"SM7450") CHIPSET="Snapdragon 7 Gen 2" ;;
"SM7550") CHIPSET="Snapdragon 7 Gen 3" ;;
"SM7635") CHIPSET="Snapdragon 7+ Gen 2" ;;
"SM8125") CHIPSET="Snapdragon 855+" ;;
"SM8130") CHIPSET="Snapdragon 870" ;;
"SM8135") CHIPSET="Snapdragon 865" ;;
"SM8150") CHIPSET="Snapdragon 860" ;;
"SM8155") CHIPSET="Snapdragon 855; 855+" ;;
"SM8250") CHIPSET="Snapdragon 865+; 870" ;;
"SM8255") CHIPSET="Snapdragon 765G" ;;
"SM8350") CHIPSET="Snapdragon 888" ;;
"SM8385") CHIPSET="Snapdragon 888+" ;;
"SM8450") CHIPSET="Snapdragon 8 Gen 1" ;;
"SM8455") CHIPSET="Snapdragon 8 Gen 2" ;;
"SM8550") CHIPSET="Snapdragon 8 Gen 2" ;;
"SM8650") CHIPSET="Snapdragon 8 Gen 3" ;;
"SM8635") CHIPSET="Snapdragon 8s Gen 3" ;;
"SM8735") CHIPSET="Snapdragon 8s Elite" ;;
"SM8750-AB") CHIPSET="Snapdragon 8 Elite Gen 4" ;;
"SM8775") CHIPSET="Snapdragon 8+ Gen 4" ;;
"SM8875") CHIPSET="Snapdragon 8+ Gen 2" ;;
"SMX") CHIPSET="Snapdragon X" ;;
"SMX Plus") CHIPSET="Snapdragon X Plus" ;;
"SMX Elite") CHIPSET="Snapdragon X Elite" ;;
esac
if [[ "$VENDOR" == "mediatek" || "$PLATFORM" =~ ^(mt6|mt8|mt67|mt68|mt69)$ ]]; then
    CHIPSET="MediaTek $PLATFORM"
fi
if [[ "$VENDOR" == "samsung" && "$PLATFORM" =~ ^exynos.*$ ]]; then
    CHIPSET="Samsung Exynos $PLATFORM"
fi
if [[ "$VENDOR" == "hisilicon" || "$PLATFORM" =~ ^kirin.*$ ]]; then
    CHIPSET="HiSilicon Kirin $PLATFORM"
fi
if [[ "$VENDOR" == "unisoc" || "$PLATFORM" =~ ^sc.*$ ]]; then
    CHIPSET="Unisoc $PLATFORM"
fi
if [ -z "$CHIPSET" ] || [ "$CHIPSET" = " " ]; then
    CHIPSET="Неопределенный чипсет ($PLATFORM)"
fi
abi=$(getprop ro.product.cpu.abilist | cut -d',' -f1)
ANDROID_VERSION=$(getprop ro.build.version.release)
total_memory_gb=$(cat /proc/meminfo | grep MemTotal | awk '{print $2 / 1024 / 1024}')
formatted_memory=$(printf "%.2f" $total_memory_gb)
available_memory=$(cat /proc/meminfo | grep MemAvailable | awk '{print $2 / 1024 / 1024}')
ost_memory=$(printf "%.2f" $available_memory)
disk_info=$(df -h /data | awk 'NR==2 {print $2, $3, $4}')
used_space=$(echo $disk_info | cut -d ' ' -f 2 | sed 's/[A-Za-z]*//g')
available_space=$(echo $disk_info | cut -d ' ' -f 3 | sed 's/[A-Za-z]*//g')
if [ -f "/sys/class/kgsl/kgsl-3d0/gpu_model" ]; then
    GPU_MODEL=$(cat /sys/class/kgsl/kgsl-3d0/gpu_model)
fi
if [ -z "$GPU_MODEL" ]; then
    GPU_MODEL=$(getprop ro.hardware.egl)
fi
if [ -z "$GPU_MODEL" ]; then
    PLATFORM=$(getprop ro.board.platform)
    case "$PLATFORM" in
        mt6*|mt8*|mt67*|mt68*|mt69*) GPU_MODEL="Mali (MediaTek)" ;;
        exynos*) GPU_MODEL="Mali (Exynos)" ;;
        kirin*) GPU_MODEL="Mali (HiSilicon Kirin)" ;;
        sc*) GPU_MODEL="PowerVR / Mali (Unisoc)" ;;
    esac
fi
if [ -z "$GPU_MODEL" ] && command -v su > /dev/null; then
    GPU_MODEL=$(su -c dumpsys SurfaceFlinger | grep "GLES:" | sed 's/.*GLES: //; s/ (.*//')
fi
if [ -z "$GPU_MODEL" ]; then
    GPU_MODEL="Не удалось определить"
fi
GPU_MODEL=$(echo "$GPU_MODEL" | sed -E 's/(Adreno)([0-9]{3})/\1 \2/')
mkdir -p "$PREFIX/bin/widget/"  
CONFIG="/$HOME/.shortcuts/,/Mobox box86"
LOCALDIR="/$PREFIX/bin/widget/local"
LOCALE_WIDGET=$(cat "$LOCALDIR")
VERSION="/$PREFIX/bin/widget/version"
versioo_mob=$(cat "$VERSION")
ANDROID_VERSION="$ANDROID_VERSION"
DEVICE="$OUTPUT $MANUFACTURER"
CPU="$CHIPSET"
ABI="$abi"
GPUGPU_MODEL="$GPU_MODEL"
FULL_RAM="$formatted_memory"
ACC_RAM="$ost_memory"
USED_SSD="$used_space"
ACC_SSD="$available_space"
sed -i "217s/.*/ANDROID_VERSION=\"${ANDROID_VERSION}\"/" "$CONFIG"
sed -i "218s/.*/DEVICE=\"${DEVICE}\"/" "$CONFIG"
sed -i "219s/.*/CPU=\"${CPU}\"/" "$CONFIG"
sed -i "220s/.*/ABI=\"${ABI}\"/" "$CONFIG"
sed -i "221s/.*/GPUGPU_MODEL=\"${GPUGPU_MODEL}\"/" "$CONFIG"
sed -i "222s/.*/FULL_RAM=\"${FULL_RAM}\"/" "$CONFIG"
sed -i "223s/.*/ACC_RAM=\"${ACC_RAM}\"/" "$CONFIG"
sed -i "224s/.*/USED_SSD=\"${USED_SSD}\"/" "$CONFIG"
sed -i "225s/.*/ACC_SSD=\"${ACC_SSD}\"/" "$CONFIG"


if [ $LOCALE_WIDGET == "" ]; then
     LOCALE_WIDGET="Русский"
echo "$LOCALE_WIDGET" > "$PREFIX/bin/widget/local"
     fi
BASE_DIR=$(<"$PREFIX/bin/widget/directory")
if [ "$BASE_DIR" = "" ]; then
    BASE_DIR="/storage/emulated/0/Download/weg"
echo "$BASE_DIR" > "$PREFIX/bin/widget/directory"
fi
WINE_ST="$( [ -f "$PREFIX/glibc/opt/conf/wine_path.conf" ] && head -n 1 "$PREFIX/glibc/opt/conf/wine_path.conf" | cut -c32- || echo "")"
if [ -z $WINE_ST ]; then
     if [ -d "$PREFIX/glibc-x86" ]; then
          WINE_ST="wine-9.3-vanilla-wow64"
     elif [ -d "$PREFIX/glibc-wow64" ]; then
          WINE_ST="wine-ge-custom-8-25"
     fi
fi
source "$PREFIX/mobox/settings"  &>/dev/null
show_progress() {
     title="$1"
     message="$2"
     duration="$3"
    ( 
        for ((i=0; i<=100; i+=7)); do
            sleep $((duration / 200)) 
            echo $i 
        done
    ) | dialog --no-shadow \
    --title "$title" --gauge "$message" 6 40 0
}
link_target="$PREFIX/glibc/opt/scripts/mobox"
if [ -f "$link_target" ]; then
    ln -sf "$link_target" "$PREFIX/bin/mobox"
    show_progress "Загрузка меню" "⏳ Сканирование компонентов..." 2
else
    echo "Целевой файл $link_target не существует. Символическая ссылка не создана."
fi
DIALOG_PID=$! 
sleep 1
clear
file_path="$PREFIX/glibc/opt/scripts/mobox_menu"
    value=$(grep 'Mobox' "$file_path" | sed -E 's/.*Mobox([^"]*).*/\1/')
wine="$PREFIX/glibc"
install="$BASE_DIR/wine" 
path="$PREFIX/glibc/opt/conf/wine_path.conf"
show_help() {
    dialog --no-shadow \
    --title "📘 Справка" --msgbox "Это меню предназначено для управления пакетами WINE.\n\n
Вы можете:\n
1. Добавить WINE в список\n
2. Выбрать WINE активным.\n
3. Удалить выбранный WINE из системы, кроме активного.\n\n
Следуйте инструкциям на экране для выполнения операций." 15 42
show_main_menu
}
delete_folder() {
 menu_items=()
 count=1
for folder in "$wine"/wine*/; do
    if [ -d "$folder" ]; then
        if [ "$(basename "$folder")" == "$WINE_ST" ]; then
                menu_items+=("$count" "✅ $(basename "$folder")") 
        else
            menu_items+=("$count" "🔲 $(basename "$folder")")
        fi
        ((count++))
    fi
done
if [ ${#menu_items[@]} -eq 0 ]; then
    dialog --no-shadow \
    --title "🚫 Ошибка" --msgbox "Список пуст. Добавьте хотя бы один \n
        из доступных WINE" 6 38
    show_main_menu
    return
fi
menu_heightwinD=$((count + 7))
[ $menu_heightwinD -lt 4 ] && menu_heightwinD=10
folder_number=$(dialog --no-shadow \
--title "🍷 Выберите WINE для удаления" --menu "Будет удалена вся информация находящаяся в этом WINE" $menu_heightwinD 38 10 "${menu_items[@]}" 3>&1 1>&2 2>&3)
case $? in
    1) show_main_menu
    return ;; 
    255) show_main_menu
    return ;; 
esac
folder=$(ls -d "$wine"/wine*/ | sed -n "${folder_number}p")
if [ "$WINE_ST" = "$(basename "$folder")" ]; then
    dialog --no-shadow \
    --title "🚫 Ошибка" --msgbox "
  Этот WINE нельзя удалить,т.к. \n
       он является активным \n
Для удаления этого WINE активируйте\n
    другой и повторите попытку." 8 39
fi
if [ "$WINE_ST" != "$(basename "$folder")" ]; then
dialog --no-shadow \
--title "❗️Подтверждение" --yesno "
Вы уверены, что хотите удалить \n
$(basename "$folder")?\n
Все данные в WINE будут утрачены" 7 36
                response=$?
                if [ $response -eq 0 ]; then
                    rm -rf "$folder"
    dialog --no-shadow \
    --title "❌ Удаление" --msgbox "
Выбранный WINE успешно удален \n
         из системы" 6 34
         delete_folder
         return
                fi
fi
show_main_menu
return
}
select_folder() {
    local menu_items=()
    local count=1
    local folder=$1
    for folder in "$wine"/wine*/; do
        if [ -d "$folder" ]; then
            if [ "$(basename "$folder")" == "$WINE_ST" ]; then
                menu_items+=("$count" "✅ $(basename "$folder")") 
            else
                menu_items+=("$count" "🔲 $(basename "$folder")")
            fi
            ((count++))
        fi
    done
    if [ ${#menu_items[@]} -eq 0 ]; then
        dialog --no-shadow \
        --title "🚫 Ошибка" --msgbox "В списке нет доступных WINE.\n
        Пожалуйста,\n
Добавьте файл WINE в список." 7 32
        show_main_menu
        return
    fi
    menu_height_winE=$((count + 5))
    [ $menu_height_winE -lt 4 ] && menu_height_winE=10
    folder_number=$(dialog --no-shadow \
    --title "🍷 Выберите WINE для активации" --menu "" $menu_height_winE 38 10 "${menu_items[@]}" 3>&1 1>&2 2>&3)
    case $? in
        1) show_main_menu
        return ;;
        255) show_main_menu
        continue ;;
    esac
    folder=$(ls -d "$wine"/wine*/ | sed -n "${folder_number}p")
    folder_name=$(basename "$folder")
    if [ "$WINE_ST" = "$folder_name" ]; then
    
        dialog --no-shadow \
        --title "🔑 Активация" --msgbox "Данный WINE уже активен" 6 27
    else
        if [ ! -f "$path" ]; then
            touch "$path" || exit 1
        fi
        {
            echo "export WINE_PATH=\$PREFIX/glibc/$folder_name"
            echo "export WINEPREFIX=\$PREFIX/glibc/$folder_name/.wine"
        } > "$path" || exit 1
        weg
        exit
    fi
    show_main_menu
}
install_package() {
local archives=()
local count=1
local active_folders=()
active_folders=()
for folder in "$wine"/wine*/; do
    if [ -d "$folder" ]; then
        active_folders+=("$(basename "$folder")")
    fi
done
archives=()
for archive in "$install"/wine*.tar.xz; do
    if [ -f "$archive" ]; then
        filename=$(basename "$archive" .tar.xz)
        if [[ ! " ${active_folders[@]} " =~ " ${filename} " ]]; then
            archives+=("$count" "$filename")
            ((count++))
        fi
    fi
done
for i in "${!archives[@]}"; do
    if (( i % 2 == 0 )); then
        archives[$i]=$((i / 2 + 1))
    fi
done
if [ ${#archives[@]} -eq 0 ]; then
    dialog --no-shadow \
    --title "🚫 Ошибка" --msgbox "\n
     В списке нет доступных WINE.\n
Пожалуйста, Добавьте файл WINE в папку." 7 
    show_main_menu 
    return
fi
while true; do
    menu_height_win=$((count + 6))
    [ $menu_height_win -lt 4 ] && menu_height_win=10
    archive_number=$(dialog --no-shadow \
    --title "🍷 Импорт WINE в список" --menu "Выберите WINE для импорта:" "$menu_height_win" 35 10 "${archives[@]}" 3>&1 1>&2 2>&3)
    case $? in
        1)  show_main_menu
        return ;;
        255) show_main_menu
        break ;;
    esac
selected_number=$archive_number
if [[ "$selected_number" -ge 1 ]] && [ "$selected_number" -le $(( ${#archives[@]} / 2 )) ]; then
    index=$(( (selected_number - 1) * 2 + 1 ))
fi
archive=$(ls "$install"/wine*.tar.xz | sed -n "${archive_number}p")
filename=$install/${archives[index]}.tar.xz
   show_progress "Распаковка" "⏳ ${archives[index]}" 2
tar -xJf "$filename" -C "$wine"
    dialog --no-shadow \
    --title "⏳ Распаковка" \
    --yesno "${archives[index]}\n
Извлечен. Сделать его активным?\n
Или вы можете сделать это позже, в\n
  соседнем пункте данного меню.\n
        Активировать WINE?" 9 38
response=$?
    if [ $response -eq 0 ]; then
        if [ ! -f "$path" ]; then
            touch "$path" || exit 1
        fi
        {
echo "export WINE_PATH=\$PREFIX/glibc/${archives[index]}"
echo "export WINEPREFIX=\$PREFIX/glibc/${archives[index]}/.wine"
        } > "$path" || exit 1
        weg 
        exit
        else
        show_main_menu
        return
    fi
done
}
show_main_menu() {
WINE_ST="$( [ -f "$PREFIX/glibc/opt/conf/wine_path.conf" ] && head -n 1 "$PREFIX/glibc/opt/conf/wine_path.conf" | cut -c32- || echo "")"
    action=$(dialog --no-shadow \
    --title "🍷 Управление WINE" --menu "Активный WINE:\n
$WINE_ST" 12 30 5 \
        " Добавтиь WINE в список" "" \
        " Выбрать активный WINE" "" \
        " Удалить WINE из списка" "" \
        " Справка" "" 3>&1 1>&2 2>&3)
    case $? in
        " Добавтиь WINE в список") return ;; 
        255) continue ;;
    esac
    case $action in
         " Добавтиь WINE в список")
            install_package
            ;;
         " Выбрать активный WINE")
            select_folder 
            ;;
         " Удалить WINE из списка")
            delete_folder 
            ;;
         " Справка")
            show_help
            ;;
    esac
}
other_menu() {
choice=$(dialog --no-shadow \
--title "🛠 Дополнительно" --menu "Выберите опцию:" 13 42 3 \
" Восстановить библиотеки" "" \
" Обновить WEG™⚡️Mobox Menu & Widget" "" \
" Язык классического меню Mobox" "" \
" Сменить расположение файлов" "" \
" Midnight Commander (mc)" "" \
" Информация" "" 2>&1 >/dev/tty)
                case $choice in
" Восстановить библиотеки") dialog --no-shadow \
--yesno "Восстановление всех библиотек\n         Продолжить?" 6 33
                    if [ $? -eq 0 ]; then
                    tar -xzf "$BASE_DIR/Mobox86_64/prefix.tar.gz" -C $PREFIX
                    fi
                    ;;
" Обновить WEG™⚡️Mobox Menu & Widget") 
     show_progress "Обновление" "⏳ Копирование файлов..." 2
if [ -d "$HOME/.shortcuts/themes" ]; then
    rm -rf "$HOME/.shortcuts/themes"
fi
if [ -d "$HOME/.shortcuts/backup" ]; then
    rm -rf "$HOME/.shortcuts/backup"
fi
    cp -r "$BASE_DIR/backup/"* /data/data/com.termux/files/
    exec bash -c ". \"/data/data/com.termux/files/home/.shortcuts/,/Mod Menu\""
;;
" Язык классического меню Mobox") 
if [ "$LOCALE_WIDGET" == "Русский" ]; then
    chek_lokal_r="✅" 
    chek_lokal_a="🔲"
else 
    chek_lokal_r="🔲"
    chek_lokal_a="✅"
fi
choice=$(dialog --no-shadow \
--title "Язык иеню Mobox" --menu "" 8 30 2 \
" $chek_lokal_r Русский Язык" "" \
" $chek_lokal_a English Language" "" 2>&1 >/dev/tty)
case $choice in
" $chek_lokal_r Русский Язык")
        if [ -d "/data/data/com.termux/files/usr/glibc-x86/" ]; then
        cp -r "$BASE_DIR/system/glibc_64_ru/"* /data/data/com.termux/files/usr/glibc/
        cp -r "$BASE_DIR/system/glibc_86_ru/"* /data/data/com.termux/files/usr/glibc-x86/
        else
        cp -r "$BASE_DIR/system/glibc_64_ru/"* /data/data/com.termux/files/usr/glibc-wow64/
        cp -r "$BASE_DIR/system/glibc_86_ru/"* /data/data/com.termux/files/usr/glibc/
        fi
echo "Русский" > "$PREFIX/bin/widget/local"
exec bash -c ". \"/data/data/com.termux/files/home/.shortcuts/,/Mod Menu\""
        ;;
" $chek_lokal_a English Language")
        if [ -d "/data/data/com.termux/files/usr/glibc-x86/" ]; then
        cp -r "$BASE_DIR/system/glibc_64_en/"* /data/data/com.termux/files/usr/glibc/
        cp -r "$BASE_DIR/system/glibc_86_en/"* /data/data/com.termux/files/usr/glibc-x86/
        else
        cp -r "$BASE_DIR/system/glibc_64_en/"* /data/data/com.termux/files/usr/glibc-wow64/
        cp -r "$BASE_DIR/system/glibc_86_en/"* /data/data/com.termux/files/usr/glibc/
        fi
echo "English" > "$PREFIX/bin/widget/local"
exec bash -c ". \"/data/data/com.termux/files/home/.shortcuts/,/Mod Menu\""
        ;;
esac
other_menu
;;
" Сменить расположение файлов")
    BASE_DIR="/storage/emulated/0"
            while true; do
                items_list=()
                items_list+=(".." "...")
                if [ "$BASE_DIR" = "/storage/emulated/0" ]; then
                    items_list=()
                fi
                for item in "$BASE_DIR"/*; do
                if [ -d "$item" ]; then
                    item_name=$(basename "$item")
                    dir_date=$(stat --format='%y' "$item")
                    dir_date=$(echo "$dir_date" | cut -d' ' -f1)
                    items_list+=("$item_name" 📂"|  DIR  | $dir_date")
                fi
                done
                folder=$(basename "$BASE_DIR")
                if [ "$folder" = "0" ]; then
                    item="Выбрана Корневая "
                    name="Корневая папка/.."
                else
                    item="Выбрана 📂 $folder"
                    name="../$folder/.."
                fi
                    selected_item=$(dialog --no-shadow \
                    --stdout --menu "Войдите в папку с файлами Mobox Menu и Widget. Нажмите < Ok >\n
─────────────────────────────────────\n
$name\n
─────────────────────────────────────\n
" 25 41 20 "${items_list[@]}")
if [ $? -ne 1 ]; then
    WEG_DIR="$BASE_DIR/backup/home/.shortcuts/,/Mobox box86"
    if [ -f "$WEG_DIR" ]; then
        echo "$BASE_DIR" > "$PREFIX/bin/widget/directory"
        break
    fi
else
    break
fi
                if [ "$selected_item" == ".." ]; then
                    BASE_DIR=$(dirname "$BASE_DIR")
                else
                    BASE_DIR="$BASE_DIR/$selected_item" 
                fi
            done
            clear
    ;;
" Midnight Commander (mc)")
         mc
            ;;
" Информация") dialog --no-shadow \
--msgbox "💡 Информация \n\n
WEG™⚡️Mobox Menu предназначено для запуска\n
и установки Mobox box86 и Mobox WoW64\n
без наличия интернета.\n\n
🧿 Установка двух версий Mobox двумя\n
   способами:\n
   📍 Если установка проводится из мода\n 
      Weg_Menu - Первый запуск нового WINE\n
      проходит в среде WINE;\n
   📍 Если установка проводится из\n
      Классического Меню Mobox - Первый\n
      запуск нового WINE проходит в среде\n
      Termux.\n
🧿 Установка библиотек для Weg™⚡Widget.\n
🧿 Быстрая и удобная смена WINE.\n
🧿 Установка файлов для работы Weg™⚡Widget\n
🧿 Простота и скорость установки.\n
🧿 Настройка всех важных компонентов для\n
   каждой версии Mobox отдельно.\n\n" 25 47
   other_menu
;;
esac
}
if [ -d "$PREFIX/glibc" ]; then
    CONFIG_MOBOX="Выбор версии Mobox"
    . "$PREFIX/glibc/opt/scripts/configs"
    load_configs
    show_message() {
        dialog --no-shadow \
        --msgbox "$1" 5 30
    }
    show_message_mobox() {
        dialog --no-shadow \
        --msgbox "$1" 6 36
    }
    handle_choice() {
        case $1 in
            1) 
            clear
            unset settings
if [ $WINE_START_86 = 0 ]; then
	dialog --no-shadow \
	--title "Установка WINE-mono" \
       --yesno "\n
  Установить WINE-mono во время первого\n
         запуска Mobox box86?\n
Для установки необходим интернет и ~500Mb\n
      дополнительного пространства." 10 45
    response=$?
    if [ $response -eq 0 ]; then
        sed -i "139s/.*/WINE_86=ON/" "$wine_86"
    else
        sed -i "139s/.*/WINE_86=OFF/" "$wine_86"
    fi
        clear
fi
if [ "$WINE_ST" ]; then
sed -i "204s/.*/WINE_WERS_86=\"${WINE_ST}\"/" "$wine_86"
else
sed -i '204s/.*/WINE_WERS_86="wine-ge-custom-8-25"/' "$wine_86"
fi
            . "$HOME/.shortcuts/,/Mobox box86"
            ;;
            2) termux-fix-shebang "$PREFIX/glibc/opt/scripts/mobox"
            mobox
            ;;
            3) 
            clear
            settings_game "$HOME/.shortcuts/,/Mobox box86" "weg"
;;
            4) 
			if [ -d "$wine" ]; then
    			show_main_menu
			else
    			dialog --no-shadow \
    			--title "🚫 Ошибка" --msgbox "Директория $wine не найдена." 5 40
			fi
			;;
            5) 
cd "$PREFIX" || { echo "Не удалось перейти в каталог $PREFIX"; exit 1; }
if [ -d "$PREFIX/glibc-wow64" ]; then
    mv $PREFIX/glibc $PREFIX/glibc-x86 || { echo "Ошибка при переименовании glibc"; exit 1; }
    mv $PREFIX/glibc-wow64 $PREFIX/glibc || { echo "Ошибка при переименовании glibc-wow64"; exit 1; }
    weg
    exit
else
    dialog --no-shadow \
    --title "Подтверждение" \
       --yesno "🚫 Файлы Mobox WoW64 не найдены,\n
   Добавте файлы Mobox WoW64." 6 36
    response=$?
    if [ $response -eq 0 ]; then
        mv glibc glibc-x86
        temp_dir="$BASE_DIR/Mobox86_64/temp_mobox_install"
        [ -d "$temp_dir" ] && rm -rf "$temp_dir"
        mkdir -p "$temp_dir"
        show_progress "Распаковка" "⏳ Извлечение wow64.tar.gz..." 2
tar -xzf "$BASE_DIR/Mobox86_64/wow64.tar.gz" -C "$temp_dir"
        if [ -d "$PREFIX/glibc" ]; then
            mv "$PREFIX/glibc"
            mv "$PREFIX/glibc-x86"
        fi
        wow64_dir="$temp_dir/wow64"
        if [ -d "$wow64_dir" ]; then
            show_progress "Распаковка" "⏳ Извлечение файлов из архива..." 2
            for archive in "$wow64_dir/"*; do
                if [[ $archive == *.tar.gz || $archive == *.tar.xz ]]; then
                    tar -xf "$archive" -C "$PREFIX/"
                fi
            done
        else
        echo "Каталог $wow64_dir не существует."
        fi
            show_progress "Установка" "⏳ Очистка временного каталога..." 2
            rm -rf "$temp_dir"
            link_target="$PREFIX/glibc/opt/scripts/mobox"
                if [ -f "$link_target" ]; then
                    ln -sf $PREFIX/glibc/opt/scripts/mobox $PREFIX/bin/mobox
                    show_progress "Установка" "⏳ Символическая ссылка создана..." 2
                else
                    echo "Целевой файл $link_target не существует. Символическая ссылка не создана."
                fi
            else
            clear
        fi
        weg
        exit
    fi
;;
            1.) clear
            unset settings
if [ $WINE_START_64 = 0 ]; then
	dialog --no-shadow \
	--title "Установка WINE-mono" \
       --yesno "\n
  Установить WINE-mono во время первого\n
         запуска Mobox WoW64?\n
Для установки необходим интернет и ~500Mb\n
      дополнительного пространства." 10 45
response=$?
if [ $response -eq 0 ]; then
sed -i "59s/.*/WINE_64=ON/" "$wine_64"
else
sed -i "59s/.*/WINE_64=OFF/" "$wine_64"
fi
clear
fi
if [ "$WINE_ST" ]; then
sed -i "188s/.*/WINE_WERS_64=\"${WINE_ST}\"/" "$wine_64"
else
sed -i '188s/.*/WINE_WERS_64="wine-9.3-vanilla-wow64"/' "$wine_86"
fi
            . "$HOME/.shortcuts/,/Mobox WoW64"
            ;;
            2.) termux-fix-shebang "$PREFIX/glibc/opt/scripts/mobox"
            mobox ;;
            3.) clear
            settings_game "$HOME/.shortcuts/,/Mobox WoW64" "weg";;
            4.)
			if [ -d "$wine" ]; then
				 show_main_menu
			else
    			dialog --no-shadow \
    			--title "🚫 Ошибка" --msgbox "Директория $wine не найдена." 5 40
			fi
			;;
            5.) 
                cd "$PREFIX" || { echo "Не удалось перейти в каталог $PREFIX"; exit 1; }
if [ -d "$PREFIX/glibc-x86" ]; then
    mv glibc glibc-wow64 || { echo "Ошибка при переименовании glibc"; exit 1; }
    mv $PREFIX/glibc-x86 $PREFIX/glibc || { echo "Ошибка при переименовании glibc-x86"; exit 1; }
    weg
    exit
else
    dialog --no-shadow \
    --title "Подтверждение" \
       --yesno "🚫 Файлы Mobox box86 не найдены,\n
   Добавте файлы Mobox box86." 6 36
    response=$?
    if [ $response -eq 0 ]; then
        mv glibc glibc-wow64
        temp_dir="$BASE_DIR/Mobox86_64/temp_mobox_install"
        [ -d "$temp_dir" ] && rm -rf "$temp_dir"
        mkdir -p "$temp_dir"
        show_progress "Распаковка" "⏳ Извлечение x86.tar.gz..." 2
tar -xzf "$BASE_DIR/Mobox86_64/x86.tar.gz" -C "$temp_dir"
        if [ -d "$PREFIX/glibc" ]; then
            mv "$PREFIX/glibc" 
            mv "$PREFIX/glibc-wow64"
        fi
        x86_dir="$temp_dir/x86"
        if [ -d "$x86_dir" ]; then
           show_progress "Распаковка" "⏳ Извлечение файлов из архива..." 2
            for archive in "$x86_dir/"*; do
                if [[ $archive == *.tar.gz || $archive == *.tar.xz ]]; then
                    tar -xf "$archive" -C "$PREFIX/"
                fi
            done
        else
            echo "Каталог $x86_dir не существует."
        fi
    else
        clear
    fi
        weg
        exit
fi
                ;;
                6.)
                other_menu
                ;;
                7.)  dialog --no-shadow \
                --title "❗️Подтверждение" --yesno "Вы уверены, что хотите удалить \n
         Mobox box86? \n
  Рекомендуем перед удалением \n
сохранить все данные, т к. они \n
  буду утрачены безвозвратно." 9 35
                response=$?
                if [ $response -eq 0 ]; then
                    rm -rf $PREFIX/glibc-x86
                elif [ $response -eq 1 ]; then
                    weg
                    exit
                fi
                ;;
                7)  
                dialog --no-shadow \
                --title "❗️Подтверждение" --yesno "Вы уверены, что хотите удалить \n
         Mobox WoW64? \n
Рекомендуем перед удалением \n
сохранить все данные, т к. они \n
  буду утрачены безвозвратно." 9 35
                response=$?
                if [ $response -eq 0 ]; then
                    rm -rf $PREFIX/glibc-wow64
                elif [ $response -eq 1 ]; then
                    weg
                    exit
                fi
                ;;
                🎮)
show_progress "Список игр" "⏳ Загрузка списка" 2
bash -c "source \"$HOME/Settings\"" 
;;
        esac 
    }
wine_64="$HOME/.shortcuts/,/Mobox WoW64"
wine_86="$HOME/.shortcuts/,/Mobox box86"
    while true; do
dialog_text_86="───────────────────────────────────────\n
Версия ОС:    Android $ANDROID_VERSION\n
Устройство:   $DEVICE\n
Процессор:    $CPU\n
AB Interface: $ABI\n
Видеодрайвер: $GPU_MODEL\n
RAM общий / доступный (Gb): $FULL_RAM / $ACC_RAM\n
Использованный объем  (Gb): $USED_SSD\n
Доступный объем       (Gb): $ACC_SSD\n
───────────────────────────────────────\n
Быстрая установка Mobox WoW64 и box86\n
   Удобная настройка и запуск Mobox\n
───────────────────────────────────────\n
Выберите опцию для box86:"
dialog_text_64="───────────────────────────────────────\n
Версия ОС:    Android $ANDROID_VERSION\n
Устройство:   $DEVICE\n
Процессор:    $CPU\n
AB Interface: $ABI\n
Видеодрайвер: $GPU_MODEL\n
RAM общий / доступный (Gb): $FULL_RAM / $ACC_RAM\n
Использованный объем  (Gb): $USED_SSD\n
Доступный объем       (Gb): $ACC_SSD\n
───────────────────────────────────────\n
Быстрая установка Mobox WoW64 и box86\n
   Удобная настройка и запуск Mobox\n
───────────────────────────────────────\n
Выберите опцию для WoW64:"
if [ "$versioo_mob" = "86_WOW" ]; then
    if [ -n "$value" ]; then
if [ -e $PREFIX/glibc/$WINE_ST/.wine/.update-timestamp ]; then
    NAME_MENU_64="Запуск Mobox WoW64"
    WINE_START_64=1
else
    NAME_MENU_64="Создать контейнер WoW64"
    WINE_START_64=0
fi
        options64=(
    "🎮" "Список Игр с настройками  🎮"
    1. "$NAME_MENU_64"
    2. "Классическое меню Mobox"
    3. "Настройки Mobox WoW64"
    4. "Настройки WINE для WoW64"
    5. "Перейти на Mobox box86"
    6. "Дополнительные параметры"
)
        if [ -d "$PREFIX/glibc-x86" ]; then
    options64+=(7. "Удалить Mobox box86")
        fi
      menu_height=$((20 + ${#options64[@]}/2))
choice=$(dialog --no-shadow \
--title "WEG™⚡️Mobox Menu v5.7" --menu "$dialog_text_64" "$menu_height" 43 "${#options64[@]}" "${options64[@]}" 2>&1 >/dev/tty)
    else
if [ -e $PREFIX/glibc/$WINE_ST/.wine/.update-timestamp ]; then
    NAME_MENU_86="Запуск Mobox box86"
    WINE_START_86=1
else
    NAME_MENU_86="Создать контейнер box86"
    WINE_START_86=0
fi
options86=(
    "🎮" "Список Игр с настройками  🎮"
    1 "$NAME_MENU_86"
    2 "Классическое меню Mobox"
    3 "Настройки Mobox box86"
    4 "Настройки WINE для box86"
    5 "Перейти на Mobox WoW64"
    6. "Дополнительные параметры"
)
    if [ -d "$PREFIX/glibc-wow64" ]; then
    options86+=(7 "Удалить Mobox WoW64")
    fi
    menu_height=$((20 + ${#options86[@]}/2))
choice=$(dialog --no-shadow \
--title "WEG™⚡️Mobox Menu v5.7" --menu "$dialog_text_86" "$menu_height" 43 "${#options86[@]}" "${options86[@]}" 2>&1 >/dev/tty)
fi
elif [ "$versioo_mob" = "WOW" ]; then
if [ -e $PREFIX/glibc/$WINE_ST/.wine/.update-timestamp ]; then
    NAME_MENU_64="Запуск Mobox WoW64"
    WINE_START_64=1
        else
    NAME_MENU_64="Создать контейнер WoW64"
    WINE_START_64=0
        fi
options_64=(
    "🎮" "Список Игр с настройками  🎮"
    1. "$NAME_MENU_64"
    2. "Классическое меню Mobox"
    3. "Настройки Mobox WoW64"
    4. "Настройки WINE для WoW64"
    6. "Дополнительные параметры"
)
choice=$(dialog --no-shadow \
--title "WEG™⚡️Mobox Menu v5.7" --menu "$dialog_text_64" 26 43 "${#options_64[@]}" "${options_64[@]}" 2>&1 >/dev/tty)
elif [ "$versioo_mob" = "86" ]; then
if [ -e $PREFIX/glibc/$WINE_ST/.wine/.update-timestamp ]; then
    NAME_MENU_86="Запуск Mobox box86"
    WINE_START_86=1
        else
    NAME_MENU_86="Создать контейнер box86"
    WINE_START_86=0
        fi
options_86=(
    "🎮" "Список Игр с настройками  🎮"
    1 "$NAME_MENU_86"
    2 "Классическое меню Mobox"
    3 "Настройки Mobox box86"
    4 "Настройки WINE для box86"
    6. "Дополнительные параметры"
)
choice=$(dialog --no-shadow \
--title "WEG™⚡️Mobox Menu v5.7" --menu "$dialog_text_86" 26 43 "${#options_86[@]}" "${options_86[@]}" 2>&1 >/dev/tty)
fi
        case $? in
            1) break ;;
            255) continue ;;
        esac
        handle_choice "$choice"
    done
    clear
    exit
else
    if [ -d "$PREFIX/glibc-x86" ]; then
    mv "$PREFIX/glibc-x86" "$PREFIX/glibc" || { echo "Ошибка при переименовании glibc-x86"; exit 1; }
    weg
    exit
fi
if [ -d "$PREFIX/glibc-wow64" ]; then
    mv "$PREFIX/glibc-wow64" "$PREFIX/glibc" || { echo "Ошибка при переименовании glibc-wow64"; exit 1; }
    weg
    exit
fi
if [ -e "$PREFIX/glibc" ]; then
    echo -n "Удаление предыдущего glibc. Продолжить? (Y/n) "
    read i
    if [ "$i" != "Y" ] && [ "$i" != "y" ]; then
        exit 1
    fi
    rm -rf "$PREFIX/glibc" "$PREFIX/glibc-x86" "$PREFIX/glibc-wow64"
fi
temp_dir="$BASE_DIR/Mobox86_64/temp_mobox_install"
[ -d "$temp_dir" ] && rm -rf "$temp_dir"
mkdir -p "$temp_dir"
show_progress "Распаковка файла" "⏳ Mobox.tar.gz..." 2
tar -xzf "$BASE_DIR/Mobox86_64/mobox.tar.gz" -C "$temp_dir"
x86_dir="$temp_dir/mobox/x86"
if [ -d "$x86_dir" ]; then
    show_progress "Установка" "⏳ Mobox box86..." 2
    for archive in "$x86_dir/"*; do
        if [[ $archive == *.tar.gz || $archive == *.tar.xz ]]; then
            tar -xf "$archive" -C "$PREFIX/"
        fi
    done
else
    echo "Каталог $x86_dir не существует."
fi
if [ -d "$PREFIX/glibc" ]; then
    mv "$PREFIX/glibc" "$PREFIX/glibc-x86"
fi
wow64_dir="$temp_dir/mobox/wow64"
if [ -d "$wow64_dir" ]; then
    show_progress "Установка" "⏳ Mobox WoW64..." 2
    for archive in "$wow64_dir/"*; do
        if [[ $archive == *.tar.gz || $archive == *.tar.xz ]]; then
            tar -xf "$archive" -C "$PREFIX/"
        fi
    done
else
    echo "Каталог $wow64_dir не существует."
fi
show_progress "Установка" "⏳ Удаление временных файлов..." 2
rm -rf "$temp_dir"
link_target="$PREFIX/glibc/opt/scripts/mobox"
if [ -f "$link_target" ]; then
    ln -sf "$link_target" "$PREFIX/bin/mobox"
    show_progress "Загрузка меню" "⏳ Сканирование компонентов..." 2
else
    echo "Целевой файл $link_target не существует. Символическая ссылка не создана."
fi
weg
exit
fi
EOF
chmod +x "$PREFIX/bin/weg"
kill -9 $DIALOG_PID 2>/dev/null
weg
exit
else
        archive_install
        weg_menu_install
        exit
    fi
}
setup_mobox