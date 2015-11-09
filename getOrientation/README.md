#Description
This code is part of the application that gathers the information from the orientation.
We created a new addon called ofxOrientation in order to get the angle given from the Android sensor (TYPE.ORIENTATION).

#How to add getOrientation addon:
1. copy the source codes into the proper folder
	addons/ofxAndroid/src/cc/openframeworks/OFAndroid.java
	addons/ofxAndroid/src/cc/openframeworks/OFAndroidOrientation.java

2. add ofxOrientation folder:
	pathtoyouraddonsfolder/ofxOrientation
	then add it to your Xcode project

3. copy ofxAndroidOrientation.ccp into your openframeworks ofxAndroid folder
	and make sure you have it in your Xcode project

4. copy src/ folder into your openframeworks project

5. add this string 'ofxOrientation' to your addons.make

6. import ofxOrientation folder into you xcode project
	(you might have some issue regarding jni.h file)

7. run the xcode project
8. run the ./gradlew assembleDebug

	