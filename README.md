# GoogleDialerMod-Magisk
This Magisk module is the alternative to the [GoogleDialerMod](https://github.com/jacopotediosi/GoogleDialerMod) app when the latter fails.

# How does it work?
This module uses SQLite commands to override some flags related to Google Dialer into the Google Play Services. 
Google Play Services control a lot of features inside Google Dialer. Some of them are core functionality of Google Dialer, some of them are upcoming feature that are simply not yet released.
What this app does is making some SQLite queries in order to alter some features of Google Dialer.

# Current features:
- Supports arm / arm64 / x86 / x86_64 devices
- Enable / disable hidden features for all users when "multiple users" Android mode in enabled
- Force enable call recording feature even with unsupported devices or in unsupported countries
- Silence annoying call recording "registration has started / ended" sounds

And much more coming soon :)
 
# Known bugs
 - Uninstall currently not working (and it's difficult to debug why)

# Credits
- Volume Key Selector taken from [Zackptg5](https://github.com/Zackptg5) / [MMT-Extended-Addons](https://github.com/Zackptg5/MMT-Extended-Addons)
- [Gabriele Rizzo aka shmykelsa](https://github.com/shmykelsa), [Jen94](https://github.com/jen94) and [SAAX by agentdr8](https://gitlab.com/agentdr8/saax) for the AA-Tweaker app which inspired me making GoogleDialerMod