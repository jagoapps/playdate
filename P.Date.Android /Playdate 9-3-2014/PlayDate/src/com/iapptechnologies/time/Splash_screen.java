package com.iapptechnologies.time;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.view.Window;

import com.crittercism.app.Crittercism;
import com.flurry.android.FlurryAgent;
import com.google.analytics.tracking.android.EasyTracker;
import com.iapp.playdate.R;

public class Splash_screen extends Activity {
	private final int SPLASH_DISPLAY_LENGHT = 1000;

	@Override
	public void onCreate(Bundle icicle) {
		super.onCreate(icicle);
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		setContentView(R.layout.splashscreen);
		Crittercism.initialize(getApplicationContext(), "548035400729df790700000d");
		
		
		new Handler().postDelayed(new Runnable() {
			@Override
			public void run() {
			
				Intent mainIntent = new Intent(Splash_screen.this,FacebookLogin.class);
				Splash_screen.this.startActivity(mainIntent);
				Splash_screen.this.finish();
			}
		}, SPLASH_DISPLAY_LENGHT);

	}

	@Override
	protected void onStart() {
		super.onStart();
		FlurryAgent.onStartSession(this, "3R9DSMW64DCK3236DHR9");
		  EasyTracker.getInstance(this).activityStart(this); 
	}

	@Override
	protected void onStop() {
		super.onStop();
		FlurryAgent.onEndSession(this);
		 EasyTracker.getInstance(this).activityStop(this); 
	}
@Override
protected void onResume() {
	// TODO Auto-generated method stub
	super.onResume();
	com.facebook.AppEventsLogger.activateApp(this, "272047936334195");
}
}
