# Disclaimer
This project uses [EasyAR](https://www.easyar.com/) and has been derived from [EasyAR_SDK_2.2.0_Pro_Samples_Android_2018-03-06.zip](https://s3-us-west-2.amazonaws.com/easyar/sdk/EasyAR_SDK_2.2.0_Pro_Samples_Android_2018-03-06.zip) (as linked on [EasyAR download page](https://www.easyar.com/view/download.html#download-nav3)).

# Preparation of USB Debugging on device
1. Install driver for your device (if your under Windows or MacOS), e.g. for LG V30 from [here](http://www.lg.com/us/support/product-help/CT10000025-20150179827560-software-version-update)
2. Enable USB Debugging on your device, e.g. for LG V30 follow [this instruction](https://www.verizonwireless.com/support/knowledge-base-215109/) 
3. Connect your device with your PC / laptop via USB

# Preparation of IDE and project
1. You should have installed Java 8 SDK on your machine 
2. Download and install [Android studio](https://developer.android.com/studio/install)
3. Open this project (assuming that you've already cloned it from Git)
4. menu Tools -> SDK Manager -> Select SDK fitting your Android Device. e.g. Android 8.0, API Level 26 for LG V30
5. Adapt build.gradle (Module app) file, to match required API Level (in stated SDK Versions and dependenices), e.g. 26 

# Preparation of EasyAR
1. Create a account and login into [EasyAR](https://www.easyar.com/)
2. Press button "Add SDK License Key"
3. Configure
  * Select "Trail Version of EasyAR SDK Pro ..." (basic is not enough for this kind of app)
  * AppName: Damals
  * Bundle ID (iOS): can be left empty
  * PackageName (Android): de.oklab.leipzig.cdv.damals
  * Press button "Confirm"
4. Click on entry "Damals"
5. Copy SDK License Key value
6. Set just copied key as value to de.oklab.leipzig.cdv.damals.MainActivity's class member "key"

# Compile and run
1. menu Build -> Make project (should complete successfully)
2. menu Build -> Build APK(s)
3. menu Run -> Run 'app', wait for initializing ADBs, your device should be discovered, press OK button
4. Accept on device, that the just deployed app can access files and recored videos
5. If you see a message "Error: Invalid key or Package Name", then either have the wrong key or registered the application with the wrong package (must match the applicationId value used in build.gradle (Module: app))
6. Hold your device vertically and press the "Start" button on the screen, you should see a colored cuboid (of cause this will be replaced by historical photo in future)