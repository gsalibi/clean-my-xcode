#!/bin/bash

main() {
    # get folder sizes
    echo "Calculating space that can be freed up..."
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


# debug symbols for each iOS version
clean_device_support() {
    echo "Cleaning iOS logs..."
    rm -rf ~/Library/Developer/Xcode/iOS\ DeviceSupport/*
    echo "$logs_size GB removed."
    logs_size=0
}

# archives created from app builds
clean_archives() {
    echo "Cleaning archives..."
    rm -rf ~/Library/Developer/Xcode/Archives/*
    echo "$archives_size GB removed."
    archives_size=0
}

# intermediate build results, works as a cache 
clean_derived_data() {
    echo "Cleaning builds data..."
    rm -rf ~/Library/Developer/Xcode/DerivedData/*
    echo "$archives_size GB removed."
    archives_size=0
}

# local simulator data: remove apps and local data
clean_devices_data() {
    echo "Cleaning devices data..."
    for folder in ~/Library/Developer/CoreSimulator/Devices/*; do
        [ -d $folder/data ] && rm -rf $folder/data/*
    done
    echo "$devices_size GB removed."
    devices_size=0
}

# simulator caches
clean_simulators_cache() {
    echo "Cleaning simulators cache..."
    rm -rf ~/Library/Developer/CoreSimulator/Caches/*
    echo "$cache_size GB removed."
    cache_size=0
}

main "$@"
