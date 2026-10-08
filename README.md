# AeroShell Gadgets

> [!IMPORTANT]
> Microsoft® Windows™ is a registered trademark of Microsoft® Corporation. This name is used for referential use only, and does not aim to usurp copyrights from Microsoft. Microsoft Ⓒ 2026 All rights reserved. All resources belong to Microsoft Corporation.

## Introduction

This repository contains (some) recreated Windows gadgets for use within AeroShell themes like [AeroThemePlasma](https://gitgud.io/aeroshell/atp/aerothemeplasma) and [VistaThemePlasma](https://gitgud.io/vtp/vistathemeplasma).

## Installation

### Required packages

**Arch Linux:** ``kunitconversion kholidays``

**Debian:** ``libkf6unitconversion-dev libkf6holidays-dev``

**Fedora:** ``kf6-kunitconversion-devel kf6-kholidays-devel``

### After installing the packages

1. Clone this repository
2. Go into the repository folder and run
```bash
$ bash install.sh
```
to install the plasmoids into ``~/.local/share/plasma/plasmoids/`` automatically

3. Add any of the plasmoids into your desktop

## Screenshots

### Clock

![clock](screenshots/clock.png)

**Available styles:**

![clockstyles](screenshots/clock-styles.png)

### Weather

![weather](screenshots/weather.png)

### Image slideshow

![slideshow](screenshots/slideshow.png)

### RSS Feeds

![rss](screenshots/rss.png)

### Notes

![notes](screenshots/notes.png)

### CPU

![cpu](screenshots/cpu.png)

## Credits
* [WackyIdeas](https://gitgud.io/wackyideas/) for adding a context menu, automatic text colorization, resizing support and doing bugfixes to the notes gadget.

## TODO

- [ ] Improve the install guide
- [ ] Calendar
- [ ] Make the script also install the gadget icons
- [ ] Add more clock screenshots
- [ ] Add the missing clock styles
