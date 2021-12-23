# smart-ac-controller
The repository contains the scripts that were used in the development of the controller. The 'hardware' script was uploaded on the Arduino, while the script inside the 'Software' folder was run as a Processing program on Raspberry Pi. Additionally, the 'codeDumper' script was used first to get the IR Codes for the AC remote controller which was then copy pasted inside the 'hardware' script so that it could successfully command the AC as a controller. Each AC controller has a different set of IR Codes, so you first would want to store them in and the replace the ones used inside the 'hardware' script with your IR Codes for the controller.

![image](https://user-images.githubusercontent.com/28980632/147270460-ad7a9e5b-c3c0-4c88-bb1d-a17d1d92f21d.png)
