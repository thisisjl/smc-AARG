#pragma once

#include "ofMain.h"
#include "ofxGui.h"
//#include "ofxSpatialHash.h"
#include "ofxGeo.h"
#include "ofxMaps.h"
#ifdef TARGET_ANDROID
#include "ofxAndroid.h"
#include "ofxAndroidGPS.h"
#include "ofxOrientation.h"
#include "ofxAccelerometer.h"
#endif

using namespace ofx;
using namespace std;

class ofApp : public ofBaseApp{

	public:
		void setup();
		void update();
		void draw();
        void close();
    
		void keyPressed(int key);
		void keyReleased(int key);
		void mouseMoved(int x, int y );
		void mouseDragged(int x, int y, int button);
		void mousePressed(int x, int y, int button);
		void mouseReleased(int x, int y, int button);
		void mouseEntered(int x, int y);
		void mouseExited(int x, int y);
		void windowResized(int w, int h);
		void dragEvent(ofDragInfo dragInfo);
		void gotMessage(ofMessage msg);
    
    
        ofTrueTypeFont font;
        ofVec3f accel, normAccel;
        ofVec3f currentOrientation;
        string curr_or[3];
        string messages[3];
        // define pairwise coordinates couples
        Geo::Coordinate myGPScoord;
        Geo::Coordinate soundGPScoord;
        // define variable to store distance
        double distanceHaversine;
        double bearingHaversine;
    
#ifdef TARGET_ANDROID
        static const bool isMobileVersion = true;
        void locationChanged(ofxLocation& location);
        ofxAndroidGPS gpsCtrl;
#else
        static const bool isMobileVersion = false;
#endif
        int gpsStatus = 0;

};
