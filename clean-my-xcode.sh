#!/bin/bash

# Change "Desktop" to "Library" 

# Deleta archives de deploy (geralmente gerados antes de publicar na loja)
rm -rf ~/Desktop/Developer/Xcode/Archives/*

# Desinstala simuladores: desinstala apps, remove dados salvos localmente e restaura configurações de fábrica
for folder in ~/Desktop/Developer/CoreSimulator/Devices/*; do
    [ -d $folder/data ] && rm -rf $folder/data/*
done

# Dados gerados durante as builds
rm -rf ~/Desktop/Developer/Xcode/DerivedData

# Logs gerados para cada versão do iOS
rm -rf ~/Desktop/Developer/Xcode/iOS\ DeviceSupport/*

# Caches dos simuladores
rm -rf ~/Desktop/Developer/CoreSimulator/Caches/*

# show folder size:
# total_size=`du -hcs ~/Library/Developer/Xcode/Archives/ | cut -f 1 | head -n 1` 
