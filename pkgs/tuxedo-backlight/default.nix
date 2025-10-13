{writeShellScriptBin}:
writeShellScriptBin "tuxedo-backlight" ''
  # all keys
  echo '0 150 255' | tee /sys/class/leds/rgb:kbd_backlight*/multi_intensity

  # DEL key
  echo '255 0 155' | tee /sys/class/leds/rgb:kbd_backlight_15/multi_intensity

  # ESC key
  echo '255 0 155' | tee /sys/class/leds/rgb:kbd_backlight/multi_intensity

  # function and Fn keys
  for i in {1..12} 102; do
      echo '0 255 80' | tee /sys/class/leds/rgb:kbd_backlight_$i/multi_intensity
  done

  # complete numblock and keys above
  for i in {16..19} {36..39} {56..59} {76..79} {96..99} {117..119}; do
      echo '255 150 0' | tee /sys/class/leds/rgb:kbd_backlight_$i/multi_intensity
  done

  # arrow keys
  for i in 95 {114..116}; do
      echo '0 255 80' | tee /sys/class/leds/rgb:kbd_backlight_$i/multi_intensity
  done
''
