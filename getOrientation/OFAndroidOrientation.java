package cc.openframeworks;

import java.util.List;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.util.Log;
import android.view.Display;
import android.view.Surface;
import android.view.WindowManager;

public class OFAndroidOrientation extends OFAndroidObject {
	private SensorManager sensorManager;
    private Sensor orientation;
    
    OFAndroidOrientation(SensorManager sensorManager){
        this.sensorManager = sensorManager;
        List<Sensor> sensors = sensorManager.getSensorList(Sensor.TYPE_ORIENTATION);
        if(sensors.size() > 0)
        {
        	orientation = sensors.get(0);
        	sensorManager.registerListener(sensorListener, orientation, SensorManager.SENSOR_DELAY_GAME);   
        	Log.v("OF", "orientation set up correctly");
        }else{
        	Log.e("OF","no orientation available");
        }
    }

	@Override
	protected void appPause() {
		sensorManager.unregisterListener(sensorListener);
		
	}

	@Override
	protected void appResume() {
		sensorManager.registerListener(sensorListener, orientation, SensorManager.SENSOR_DELAY_GAME);   
	}

	@Override
	protected void appStop() {
		sensorManager.unregisterListener(sensorListener);
	}
	
	
	private final SensorEventListener sensorListener = new SensorEventListener() {
		public void onSensorChanged(SensorEvent event) {
	    	WindowManager windowManager = (WindowManager)OFAndroid.getContext().getSystemService(Context.WINDOW_SERVICE);
	    	Display display = windowManager.getDefaultDisplay();
		
		float currentOrientation = event.values[0];
		float x = event.values[1];
		float y = event.values[2];
		//Log.i("Compass","we reached this point!"); // check if the listener works
	    	
			updateOrientation(
			          currentOrientation,x,y);
		}
		 
		public void onAccuracyChanged(Sensor sensor, int accuracy) {}
	};

	public static native void updateOrientation(float z, float x, float y);
    
}
