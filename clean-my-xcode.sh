#!/bin/bash

main() {
    archives_size=$(du -hcs ~/Desktop/Developer/Xcode/Archives/ | cut -f 1 | head -n 1)
    op1="Remove archives (${archives_size//[[:blank:]]/})"

    devices_size=$(du -hcs ~/Desktop/Developer/CoreSimulator/Devices/ | cut -f 1 | head -n 1)
    op2="Devices data (${devices_size//[[:blank:]]/})"

    builds_size=$(du -hcs ~/Desktop/Developer/Xcode/DerivedData | cut -f 1 | head -n 1)
    op3="Builds data (${builds_size//[[:blank:]]/})"

    logs_size=$(du -hcs ~/Desktop/Developer/Xcode/iOS\ DeviceSupport/ | cut -f 1 | head -n 1)
    op4="iOS logs (${logs_size//[[:blank:]]/})"

    cache_size=$(du -hcs ~/Desktop/Developer/CoreSimulator/Caches/ | cut -f 1 | head -n 1)
    op5="Simulators cache (${cache_size//[[:blank:]]/})"

    op6="All"


    PS3='What do you want to clean?'
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
remove_archives() {
    echo $total_size
    rm -rf ~/Desktop/Developer/Xcode/Archives/*
}

# Desinstala simuladores: desinstala apps, remove dados salvos localmente e restaura configurações de fábrica
remove_devices_data() {
    echo $total_size
    for folder in ~/Desktop/Developer/CoreSimulator/Devices/*; do
        [ -d $folder/data ] && rm -rf $folder/data/*
    done
}

# Dados gerados durante as builds
remove_builds_data() {
    echo $total_size
    rm -rf ~/Desktop/Developer/Xcode/DerivedData/*
}

# Logs gerados para cada versão do iOS
remove_ios_logs() {
    echo $total_size
    rm -rf ~/Desktop/Developer/Xcode/iOS\ DeviceSupport/*
}

# Caches dos simuladores
remove_simulators_cache() {
    echo $total_size
    rm -rf ~/Desktop/Developer/CoreSimulator/Caches/*
}

main "$@"
