# GoogleDialerMod-Magisk

## Deprecation Notice
This Magisk module was an alternative (workaround) to the [GoogleDialerMod Standalone APK version](https://github.com/jacopotediosi/GoogleDialerMod), created to try to overcome the access storage limitations that occurred on Android >= 11.

In November 2022 it was deprecated to keep only the APK version, which no longer suffers from those bugs.

Therefore, this repository will no longer be updated.

Please use only the APK version repository to [download new updates](https://github.com/jacopotediosi/GoogleDialerMod/releases) or to [report issues](https://github.com/jacopotediosi/GoogleDialerMod/issues).
<br><br><br><br>

## How Does It Work?
In every Android device there is a database, called Phenotype.db, managed by Google Play Services, containing special flags that affect the behavior of all Google applications installed.

Some of those flags concern Google Dialer core functionalities, while others are about hidden or upcoming features not yet released.

What this module does is execute SQLite queries on that database and overwrite Google Dialer configuration files to enable or alter its features at will.

## Current Features:
- Supports arm / arm64 / x86 / x86_64 devices and (hopefully) all Android versions
- Enable / disable hidden features for all users at once when Android "multiple users" mode is in use
- Force enable call recording feature even on unsupported devices or in unsupported countries
- Silence the annoying "registration has started / ended" call recording sounds
 
## Known Bugs
 - Uninstall not working

# Credits
- Volume Key Selector taken from [Zackptg5](https://github.com/Zackptg5) / [MMT-Extended-Addons](https://github.com/Zackptg5/MMT-Extended-Addons)
- Thanks to [Gabriele Rizzo aka shmykelsa](https://github.com/shmykelsa), [Jen94](https://github.com/jen94) and [SAAX by agentdr8](https://gitlab.com/agentdr8/saax) for their [AA-Tweaker](https://github.com/shmykelsa/AA-Tweaker) app, which inspired me making GoogleDialerMod
