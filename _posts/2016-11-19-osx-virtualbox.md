---
title:  "Auto-starting VirtualBox VMs on OS X"
date:   2016-11-19
categories: DEVOPS
tags: osx virtualbox
---

After finding a lot of other posts on the topic that didn't work out for me this one did the trick so I'm reposting for my own sense of self preservation.

[Link to original article.](http://rcaguilar.wordpress.com/2013/01/07/auto-starting-virtualbox-vms-on-os-x/){:target="_blank"}

Copy the Virtualbox autostart plist template file to your system's LaunchDaemons folder.

    sudo cp \
        /Applications/VirtualBox.app/Contents/MacOS/org.virtualbox.vboxautostart.plist \
        /Library/LaunchDaemons

Then edit `/Library/LaunchDaemons/org.virtualbox.vboxautostart.plist` set `Disabled` to `false`, set `KeepAlive` to `true`, and confirm the last string entry in the command array is set to `/etc/vbox/autostart.cfg`.  
The file should look like this:

    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
    <key>Disabled</key>
    <false/>
    <key>KeepAlive</key>
    <true/>
    <key>Label</key>
    <string>org.virtualbox.vboxautostart</string>
    <key>ProgramArguments</key>
    <array>
    <string>/Applications/VirtualBox.app/Contents/MacOS/VBoxAutostartDarwin.sh</string>
    <string>--start</string>
    <string>/etc/vbox/autostart.cfg</string>
    </array>
    </dict>
    </plist>

Make the directory `/etc/vbox` and create the file `/etc/vbox/autostart.cfg` with the following content:

    default_policy = deny
    osxusername = {
    allow = true
    }

Make sure to change osxusername to the username on your system that the VMs are under.

Next properly set permissions:

    sudo chmod +x /Applications/VirtualBox.app/Contents/MacOS/VBoxAutostartDarwin.sh
    sudo chown root:wheel /etc/vbox
    sudo chown root:wheel /etc/vbox/autostart.cfg
    sudo chown root:wheel /Library/LaunchDaemons/org.virtualbox.vboxautostart.plist

Now, configure the VMs that should automatically start and set how they should be stopped:

    VBoxManage modifyvm vmname --autostart-enabled on
    VBoxManage modifyvm vmname --autostop-type acpishutdown

Finally, test the configuration by running:

    sudo launchctl load /Library/LaunchDaemons/org.virtualbox.vboxautostart.plist

After a reboot, the VMs that have been set with autostart enabled should be running!

### References

[Virtualbox docs autostart OSX](https://www.virtualbox.org/manual/ch09.html#autostart-osx){:target="_blank"}
[Virtualbox forum thread 1](https://forums.virtualbox.org/viewtopic.php?f=8&t=51593&start=15#p240724){:target="_blank"}
[Virtualbox forum thread 2](https://forums.virtualbox.org/viewtopic.php?f=11&t=51529#p236492){:target="_blank"}
