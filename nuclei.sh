#!/bin/bash

while true
do
  # "nuclei" programının çalışıp çalışmadığını kontrol edin
  nuclei_running=$(pgrep nuclei)

  # Eğer "nuclei" çalışıyorsa durdurun
  if [ ! -z "$nuclei_running" ]; then
    sudo pkill nuclei
  fi

  # 30 saniye bekle
  sleep 30
done
