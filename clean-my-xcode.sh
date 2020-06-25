#!/bin/bash

# xcrun simctl list (NO XCODE: WINDOWS->DEVICES AND SIMULATORS ou ⇧⌘2)
# xcrun simctl delete unavailable

main() {
    # get folders sizes
    logs_size=$(echo "scale=2;$(du -hcsm ~/Library/Developer/Xcode/iOS\ DeviceSupport/ | cut -f 1 | head -n 1)/1000" | bc)
    archives_size=$(echo "scale=2;$(du -hcsm ~/Library/Developer/Xcode/Archives/ | cut -f 1 | head -n 1)/1000" | bc)
    builds_size=$(echo "scale=2;$(du -hcsm ~/Library/Developer/Xcode/DerivedData/ | cut -f 1 | head -n 1)/1000" | bc)
    devices_size=$(echo "scale=2;$(du -hcsm ~/Library/Developer/CoreSimulator/Devices/ | cut -f 1 | head -n 1)/1000" | bc)
    cache_size=$(echo "scale=2;$(du -hcsm ~/Library/Developer/CoreSimulator/Caches/ | cut -f 1 | head -n 1)/1000" | bc)
    total_size=$(echo "scale=2;$archives_size+$devices_size+$builds_size+$logs_size+$cache_size" | bc)

    # menu options
    op1="Device Suport (${logs_size//[[:blank:]]/} GB)"
    op2="Archives (${archives_size//[[:blank:]]/} GB)"
    op3="Derived Data (${builds_size//[[:blank:]]/} GB)"
    op4="Core Simulator Devices data (${devices_size//[[:blank:]]/} GB)"
    op5="Core Simulator cache (${cache_size//[[:blank:]]/} GB)"
    op6="All (${total_size//[[:blank:]]/} GB)"
    

    # loop menu
    PS3='Which one do you want to clean? '
    COLUMNS=1
    options=("$op1" "$op2" "$op3" "$op4" "$op5" "$op6" "Quit")
    select opt in "${options[@]}"; do
        case $opt in
        "$op1")
            clean_device_support
            ;;
        "$op2")
            clean_archives
            ;;
        "$op3")
            clean_derived_data
            ;;
        "$op4")
            clean_devices_data
            ;;
        "$op5")
            clean_simulators_cache
            ;;
        "$op6")
            clean_archives
            clean_devices_data
            clean_derived_data
            clean_device_support
            clean_simulators_cache
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY" ;;
        esac
    done
}


# Logs gerados para cada versão do iOS
clean_device_support() {
    echo "Cleaning iOS logs..."
    rm -rf ~/Library/Developer/Xcode/iOS\ DeviceSupport/*
    echo "$logs_size GB removed."
    logs_size=0
}

# Deleta archives de deploy (geralmente gerados antes de publicar na loja)
# if you want to be able to debug deployed versions of your App, you shouldn’t delete the archives. Xcode will manage of archives and creates new file when new build is archived.
clean_archives() {
    echo "Cleaning archives..."
    rm -rf ~/Library/Developer/Xcode/Archives/*
    echo "$archives_size GB removed."
    archives_size=0
}

# Dados gerados durante as builds
clean_derived_data() {
    echo "Cleaning builds data..."
    rm -rf ~/Library/Developer/Xcode/DerivedData/*
    echo "$archives_size GB removed."
    archives_size=0
}

# Desinstala simuladores: desinstala apps, remove dados salvos localmente e restaura configurações de fábrica
clean_devices_data() {
    echo "Cleaning devices data..."
    for folder in ~/Library/Developer/CoreSimulator/Devices/*; do
        [ -d $folder/data ] && rm -rf $folder/data/*
    done
    echo "$devices_size GB removed."
    devices_size=0
}

# Caches dos simuladores
clean_simulators_cache() {
    echo "Cleaning simulators cache..."
    rm -rf ~/Library/Developer/CoreSimulator/Caches/*
    echo "$cache_size GB removed."
    cache_size=0
}

main "$@"
