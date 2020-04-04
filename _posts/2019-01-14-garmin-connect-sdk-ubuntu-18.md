---
title:  "Garmin Connect IQ SDK - Ubuntu 18"
date:   2019-01-14
categories: DEV
tags: garmin sdk
---

* Install https://developer.garmin.com/connect-iq/programmers-guide/getting-started/ to `/opt/garmin-connectiq-sdk`

    ```
    export PATH=$PATH:/opt/garmin-connectiq-sdk/bin
    ```

* lib issues
    * libpng issue https://www.linuxuprising.com/2018/05/fix-libpng12-0-missing-in-ubuntu-1804.html
       ```
       sudo dpkg -i libpng12-0_1.2.54-1ubuntu1.1_amd64.deb
       ```
    * libwebkitgtk-1.0.so.0
       ```
       sudo apt-get install libwebkitgtk-1.0
       ```

* fix for java 9, 10 `/opt/garmin-connectiq-sdk/bin/monkeydo`
    * source http://unitstep.net/blog/2018/08/22/getting-the-garmin-connect-iq-sdk-to-work-with-java-9-10/

    ```
    # COMMENT THIS ONE OUT:
    # Push the executable to the simulator
    #java -classpath "$MB_HOME"/monkeybrains.jar com.garmin.monkeybrains.monkeydodeux.MonkeyDoDeux -f "$PRG_PATH" -d $DEVICE_ID -s "$MB_HOME"/shell $TEST_FLAG $TEST_NAME

    # USE THIS ONE INSTEAD:
    # Fix for Java 9, 10:
    # https://stackoverflow.com/questions/43574426/how-to-resolve-java-lang-noclassdeffounderror-javax-xml-bind-jaxbexception-in-j
    java --add-modules java.xml.bind -classpath "$MB_HOME"/monkeybrains.jar com.garmin.monkeybrains.monkeydodeux.MonkeyDoDeux -f "$PRG_PATH" -d $DEVICE_ID -s "$MB_HOME"/shell $TEST_FLAG $TEST_NAME
    
    ```
