#!/bin/bash

main() {
    PS3='What do you want to clean?'
    options=("Remove archives" "Devices data" "Builds data" "iOS logs" "Simulators cache" "All" "Quit")
    select opt in "${options[@]}"; do
        case $opt in
        "Remove archives")
            remove_archives
            ;;
        "Devices data")
            remove_devices_data
            ;;
        "Builds data")
            remove_builds_data
            ;;
        "iOS logs")
            remove_ios_logs
            ;;
        "Simulators cache")
            remove_simulators_cache
            ;;
        "All")
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
    total_size=$(du -hcs ~/Desktop/Developer/Xcode/Archives/ | cut -f 1 | head -n 1)
    echo $total_size
    rm -rf ~/Desktop/Developer/Xcode/Archives/*
}

# Desinstala simuladores: desinstala apps, remove dados salvos localmente e restaura configurações de fábrica
remove_devices_data() {
    total_size=$(du -hcs ~/Desktop/Developer/CoreSimulator/Devices/ | cut -f 1 | head -n 1)
    echo $total_size
    for folder in ~/Desktop/Developer/CoreSimulator/Devices/*; do
        [ -d $folder/data ] && rm -rf $folder/data/*
    done
}

# Dados gerados durante as builds
remove_builds_data() {
    total_size=$(du -hcs ~/Desktop/Developer/Xcode/DerivedData | cut -f 1 | head -n 1)
    echo $total_size
    rm -rf ~/Desktop/Developer/Xcode/DerivedData/*
}

# Logs gerados para cada versão do iOS
remove_ios_logs() {
    total_size=$(du -hcs ~/Desktop/Developer/Xcode/iOS\ DeviceSupport/ | cut -f 1 | head -n 1)
    echo $total_size
    rm -rf ~/Desktop/Developer/Xcode/iOS\ DeviceSupport/*
}

# Caches dos simuladores
remove_simulators_cache() {
    total_size=$(du -hcs ~/Desktop/Developer/CoreSimulator/Caches/ | cut -f 1 | head -n 1)
    echo $total_size
    rm -rf ~/Desktop/Developer/CoreSimulator/Caches/*
}

main "$@"
