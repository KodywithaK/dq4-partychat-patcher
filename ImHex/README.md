<!-- <style type="text/css" rel="stylesheet"> -->
<!--   span#green { color: green; } -->
<!-- </style> -->

# [ImHex](https://imhex.werwolv.net/) - Free and Open Source Hex Editor for all OSes and the Web

## 00. Prerequisites

-   [ImHex](https://imhex.werwolv.net/#downloads)
-   Dumped `data/MESS*/*.mpt` files from `Dragon Quest Ⅳ-Ⅵ` (DS or Phone)

## 01. ImHex

0. `Extras` > `Settings` > `General` > `Patterns`
    - [x] `Sync pattern source code between providers`, saves you from having to keep dragging and dropping the `.hexpat` on every new file you open in the following steps.
1. `Extras` > `Content Store` > `Libraries`

    - Download `Hex` & `Std` and close the window, to enable the hexpattern (`.hexpat`) in the following step.

2. Drag and drop the `.mpt` you are working on into the window, to open the editor.

3. Drag and drop the `.hexpat` into the window, to open the `Pattern editor`.

    - Press the <span id="green">green triangle</span> button at the very bottom of the `Pattern editor` panel.

    - Pop-up will appear `This pattern tried to call a dangerous function...`, click `yes`.

    - Highlights the `Hex editor` panel, fills out the `Pattern Data` panel, and creates `.mpt.txt` file.

# Notes

## Files

### MESS

### MESS5

> -   `b0000000.mpt` prologue

### MESS6

## KNOWN ERRORS

> -   `0xE28098`(...)`E28099` Left/Right Single Quotation Mark ( `‘`(...)`’` ) not always picked up.
> -   `0xE29386` TBD ( `TBD` ) misinterpreted as ( `Ⓠ` )
> -   `0xE29387` Musical Note? ( `TBD` ) misinterpreted as ( `Ⓡ` )
> -   `0xE29393` = (`;`)
> -   `0xE29397`(...)`E29398` Left/Right Quote Mark? ( `TBD` ) misinterpreted as ( `ⓗ...ⓘ` )
> -   `0xE2939AE2939B` Em dash ( `—` ) misinterpreted as ( `ⓚⓛ` )
> -   French / Korean / Chinese (Simplified & Traditional) misinterpretting.

## Glossary

> -   `%0%a001210` Killer Panther's name
> -   `%0%a01010` active party member
> -   `%0%a02130` monster
> -   `%0%a05130` monsters
> -   `%3`(...)`%4` centers text on screen.
> -   `%a000090` name of player character.
> -   `%a001200` Pankraz's name for the player character.
> -   `%a00170` spell
> -   `%A010%X`(...)`%Z%B010%X`(...)`%Z%C010%X`(...)`%Z` gender conditional.<br>(e.g., %A010%X`his`%Z%B010%X`her`%Z%C010%X`its`%Z)
> -   `%a01130` monster name
> -   `%a04130` monsters' name
> -   `%H610%X`(...)`%Y`(...)`%Z` group number conditional.<br>(e.g., `Obtained (1|2) item`%H610%X%Y`s`%Z)
> -   `%H860%X`(...)`%Y`(...)`%Z` group number conditional.<br>(e.g., %H860%X`you`%Y`you all`%Z)

## Misc.

> -   text ingame automatically newlines at 52 characters.
