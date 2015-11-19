#Description
This code is part of the android application which gathers data from sensors such as compass and GPS location. Data is then used in a HRFT model.
We created a new addon called ofxOrientation in order to get the angle related to North Magnetic Pole, which is 
given from android sensor (TYPE.ORIENTATION).

#How to add getOrientation addon:
1. copy the source codes into the proper folder
	addons/ofxAndroid/ofAndroidLib/src/cc/openframeworks/OFAndroid.java
	addons/ofxAndroid/ofAndroidLib/src/cc/openframeworks/OFAndroidOrientation.java

2. add ofxOrientation folder to:
	openFrameworks/addons/

3. copy ofxAndroidOrientation.ccp into your openframeworks ofxAndroid folder:
	openFrameworks/addons/ofxAndroid/src/
	and make sure you have it in your Xcode project

4. copy src/ folder into your openframeworks project

5. add this string 'ofxOrientation' to your addons.make

6. import ofxOrientation folder into you xcode project
	(you might have some issue regarding jni.h file)

7. run the xcode project

8. you might need to run make AndroidDebug

9. run the ./gradlew assembleDebug

	
