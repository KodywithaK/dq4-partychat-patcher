<style type="text/css" rel="stylesheet">
  span#green { color: green; }
</style>

# [ImHex](https://imhex.werwolv.net/) - Free and Open Source Hex Editor for all OSes and the Web

## 00. Prerequisites

-   [ImHex](https://imhex.werwolv.net/#downloads)
-   Dumped `data/MESS*/*.mpt` files from `Dragon Quest Ⅳ-Ⅵ`

## 01. ImHex
0. `Extras` > `Settings` > `General` > `Patterns`
  <br>- [x] `Sync pattern source code between providers`, saves you from having to keep dragging and dropping the `.hexpat` on every new file you open in the following steps.
1. `Extras` > `Content Store` > `Libraries`
   <br>- Download `Hex` & `Std` and close the window, to enable the hexpattern (`.hexpat`) in the following step.

2. Drag and drop the `.mpt` you are working on into the window, to open the editor.

3. Drag and drop the `.hexpat` into the window, to open the `Pattern editor`.
   <br>- Press the <span id="green">green triangle</span> button at the very bottom of the `Pattern editor` panel.
   <br>- Pop-up will appear `This pattern tried to call a dangerous function...`, click `yes`.
   <br>- Highlights the `Hex editor` panel, fills out the `Pattern Data` panel, and creates `.mpt.txt` file.

# Notes

## Files

### MESS

### MESS5

> -   `b0000000.mpt` prologue

### MESS6

## KNOWN ERRORS
> - `0xE2939AE2939B` Em dash ( `—` ) interpreted as ( `ⓚⓛ` )

## Glossary

> -   `%0%a001210` Killer Panther's name
> -   `%3(...)%4` centers text on screen.
> -   `%a000090` name of player character.
> -   `%a001200` Pankraz's name for the player character.

## Misc.

> -   text ingame automatically newlines at 52 characters.
