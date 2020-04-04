---
title:  "Restore rEFInd Boot Manager on MS Windows"
date:   2018-05-04
categories: DEVOPS
tags: win
---

To restore your [rEFInd](https://www.rodsbooks.com/refind/) boot manager on MS Windows  
Create `refind.bat` file with below content and run it as admin

```
REM run on windows as admin
REM source https://superuser.com/questions/1298510/how-can-i-prevent-windows-8-1-overwriting-my-bootloader?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa

bcdedit /set {bootmgr} path \EFI\refind\refind_x64.efi
bcdedit /set {bootmgr} description REFIND
```
