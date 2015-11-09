#include "ofApp.h"

#ifdef TARGET_ANDROID
double log2( double n )  
{  
    // log(n)/log(2) is log2.  
    return log( n ) / log( 2 );  
}
#endif

//--------------------------------------------------------------
void ofApp::setup(){
    ofSetFrameRate(60); //set framerate in order to display coordinates
    ofBackground(255,255,255);
    //font.load("frabk.ttf",20); //make sure you have .tff font files in pathtoyourproject/bin/data
    font.load("verdana.ttf",20);
    
    #ifdef TARGET_ANDROID
    gpsCtrl.startGPS();// GPS start
    gpsStatus = 1;
    ofRegisterGPSEvent(this);
    ofxOrientation.setup();
    ofxAccelerometer.setup();
    #endif
}

//--------------------------------------------------------------
void ofApp::update(){
    //Orientation
    curr_or[0] = "orr(x) = " + ofToString(currentOrientation.x,2);
    curr_or[1] = "orr(y) = " + ofToString(currentOrientation.y,2);
    curr_or[2] = "orr(z) = " + ofToString(currentOrientation.z,2);
    //Accelerometer
    messages[0] = "g(x) = " + ofToString(accel.x,2);
    messages[1] = "g(y) = " + ofToString(accel.y,2);
    messages[2] = "g(z) = " + ofToString(accel.z,2);
    normAccel = accel.getNormalized(); // not needed
    
#ifdef TARGET_ANDROID
    accel = ofxAccelerometer.getOrientation();
    currentOrientation = ofxOrientation.getOrientation();
#endif
    distanceHaversine = Geo::GeoUtils::distanceHaversine(soundGPScoord,myGPScoord)*100.0;
    // calculate the great-circle distance between two points – that is, the shortest distance over the earth’s surface
    bearingHaversine = Geo::GeoUtils::bearingHaversine(soundGPScoord, myGPScoord);
    // The true bearing to a point is the angle measured in degrees in a clockwise direction from the north line
}

//--------------------------------------------------------------
#ifdef TARGET_ANDROID
void ofApp::locationChanged(ofxLocation& location) {
    ofLogNotice() << "locationChanged: " << location ;
    gpsStatus = 2;
    myGPScoord = Geo::Coordinate(location.latitude, location.longitude);
    soundGPScoord = Geo::Coordinate(55.649838, 12.541158); //bicycle parking next to FKJ12
    // here extra code, if needed, to use myGPScoord
}
#endif

//--------------------------------------------------------------
void ofApp::close(){
#ifdef TARGET_ANDROID
    gpsCtrl.stopGPS();//stop GPS when application closed
#endif
}

//--------------------------------------------------------------
void ofApp::draw(){
    string myReport = "";
    switch (gpsStatus){
        case 0:
            font.drawString("Desktop version - GPS not present",100,100);
            break;
        case 1:
            font.drawString("Mobile version - GPS offline",100,100);
            break;
        case 2:
            font.drawString("Mobile version - GPS coord. " + ofToString(myGPScoord),100,100);
            font.drawString("Mobile version - Sound coord. " + ofToString(soundGPScoord),100,130);
            font.drawString("Distance from the soundsource is " + ofToString(distanceHaversine) + " meters",100,160);
            font.drawString("The angle between you and the sound is " + ofToString(bearingHaversine) + " degrees",100,190);
            //print accelerometer values
            font.drawString(messages[0],100,font.stringHeight(messages[0])+220);
            font.drawString(messages[1],100,font.stringHeight(messages[0])+250);
            font.drawString(messages[2],100,font.stringHeight(messages[0])+280);
            //print orientation values.
            font.drawString(curr_or[0],100,font.stringHeight(curr_or[0])+310);
            font.drawString(curr_or[1],100,font.stringHeight(curr_or[0])+340);
            font.drawString(curr_or[2],100,font.stringHeight(curr_or[0])+370);
            break;
    }
    ofSetHexColor(000000);
}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){
}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){

}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y ){

}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseEntered(int x, int y){

}

//--------------------------------------------------------------
void ofApp::mouseExited(int x, int y){

}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){
    
}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){ 

}
