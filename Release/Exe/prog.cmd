@clear
echo File: %1
echo
avrdude -p m48 -c usbasp -B 10 -U flash:w:201810131.hex
pause