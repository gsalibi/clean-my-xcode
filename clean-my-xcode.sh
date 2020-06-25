#!/bin/bash

main() {
    # get folders sizes
    archives_size=$(echo "scale=2;$(du -hcsm ~/Desktop/Developer/Xcode/Archives/ | cut -f 1 | head -n 1)/1000" | bc)
    devices_size=$(echo "scale=2;$(du -hcsm ~/Desktop/Developer/CoreSimulator/Devices/ | cut -f 1 | head -n 1)/1000" | bc)
    builds_size=$(echo "scale=2;$(du -hcsm ~/Desktop/Developer/Xcode/DerivedData/ | cut -f 1 | head -n 1)/1000" | bc)
    logs_size=$(echo "scale=2;$(du -hcsm ~/Desktop/Developer/Xcode/iOS\ DeviceSupport/ | cut -f 1 | head -n 1)/1000" | bc)
    cache_size=$(echo "scale=2;$(du -hcsm ~/Desktop/Developer/CoreSimulator/Caches/ | cut -f 1 | head -n 1)/1000" | bc)
    total_size=$(echo "scale=2;$archives_size+$devices_size+$builds_size+$logs_size+$cache_size" | bc)

    # menu options
    op1="Archives (${archives_size//[[:blank:]]/} GB)"
    op2="Devices data (${devices_size//[[:blank:]]/} GB)"
    op3="Builds data (${builds_size//[[:blank:]]/} GB)"
    op4="iOS logs (${logs_size//[[:blank:]]/} GB)"
    op5="Simulators cache (${cache_size//[[:blank:]]/} GB)"
    op6="All (${total_size//[[:blank:]]/} GB)"

    # loop menu
    PS3='Which one do you want to clean? '
    COLUMNS=1
    options=("$op1" "$op2" "$op3" "$op4" "$op5" "$op6" "Quit")
    select opt in "${options[@]}"; do
        case $opt in
        "$op1")
            remove_archives
            ;;
        "$op2")
            remove_devices_data
            ;;
        "$op3")
            remove_builds_data
            ;;
        "$op4")
            remove_ios_logs
            ;;
        "$op5")
            remove_simulators_cache
            ;;
        "$op6")
            remove_archives
            remove_devices_data
            remove_builds_data
            remove_ios_logs
            remove_simulators_cache
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY" ;;
        esac
    done
}

# Deleta archives de deploy (geralmente gerados antes de publicar na loja)
# if you want to be able to debug deployed versions of your App, you shouldn’t delete the archives. Xcode will manage of archives and creates new file when new build is archived.
remove_archives() {
    echo "Cleaning archives..."
    rm -rf ~/Desktop/Developer/Xcode/Archives/*
    echo "$archives_size GB removed."
    archives_size=0
}

# Desinstala simuladores: desinstala apps, remove dados salvos localmente e restaura configurações de fábrica
remove_devices_data() {
    echo "Cleaning devices data..."
    for folder in ~/Desktop/Developer/CoreSimulator/Devices/*; do
        [ -d $folder/data ] && rm -rf $folder/data/*
    done
    echo "$devices_size GB removed."
    devices_size=0
}

# Dados gerados durante as builds
remove_builds_data() {
    echo "Cleaning builds data..."
    rm -rf ~/Desktop/Developer/Xcode/DerivedData/*
    echo "$archives_size GB removed."
    archives_size=0
}

# Logs gerados para cada versão do iOS
remove_ios_logs() {
    echo "Cleaning iOS logs..."
    rm -rf ~/Desktop/Developer/Xcode/iOS\ DeviceSupport/*
    echo "$logs_size GB removed."
    logs_size=0
}

# Caches dos simuladores
remove_simulators_cache() {
    echo "Cleaning simulators cache..."
    rm -rf ~/Desktop/Developer/CoreSimulator/Caches/*
    echo "$cache_size GB removed."
    cache_size=0
}

main "$@"
