/*
 * ofxAndroidOrientation.cpp
 *
 *  Created on: 28/11/2010
 *      Author: arturo
 */

#include <jni.h>
#include "ofxOrientation.h"
#include "ofxAndroidUtils.h"
#include "ofLog.h"

extern "C"{
void
Java_cc_openframeworks_OFAndroidOrientation_updateOrientation( JNIEnv*  env, jobject  thiz, jfloat z, jfloat x, jfloat y){
	ofxOrientation.update(z,x,y);
}
}

//error handler
void ofxOrientationHandler::setup(){
	if(!ofGetJavaVMPtr()){
		ofLogError("ofxAndroidOrientation") << "setup(): couldn't find java virtual machine";
		return;
	}
	JNIEnv *env;
	if (ofGetJavaVMPtr()->GetEnv((void**) &env, JNI_VERSION_1_4) != JNI_OK) {
		ofLogError("ofxAndroidOrientation") << "setup(): failed to get environment using GetEnv()";
		return;
	}
	jclass javaClass = env->FindClass("cc/openframeworks/OFAndroid");

	if(javaClass==0){
		ofLogError("ofxAndroidOrientation") << "setup(): couldn't find OFAndroid java class";
		return;
	}

	 jmethodID setupOrientation = env->GetStaticMethodID(javaClass,"setupOrientation","()V");
 	if(!setupOrientation){
 		ofLogError("ofxAndroidOrientation") << "setup(): couldn't find OFAndroid.setupOrientation method";
 		return;
 	}
 	env->CallStaticVoidMethod(javaClass,setupOrientation);
}

void ofxOrientationHandler::exit(){

}
