package com.iapptechnologies.time;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Stack;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.protocol.BasicHttpContext;
import org.apache.http.protocol.HttpContext;
import org.json.JSONException;
import org.json.JSONObject;

import android.annotation.SuppressLint;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.provider.MediaStore;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.flurry.android.FlurryAgent;
import com.google.analytics.tracking.android.EasyTracker;
import com.iapp.playdate.R;
import com.iapptechnologies.time.NavigationDrawerclass.SizeCallback;

public class Home extends FragmentActivity implements View.OnTouchListener {
	
	
	static int count;
	Button btnBack;

	static NavigationDrawerclass scrollView;
	static View menu;
	View app;
	Button btnSlide, btn_arrangedate, btn_calander, btn_home;
	static boolean menuOut = false;
	boolean isScan = false;
	Handler handler = new Handler();
	int btnWidth;
	CustomDrawerAdapter adapter;
	List<DrawerItem> dataList;

	View.OnTouchListener gestureListener;
	float x1, x2;
	float y1, y2;
	static ImageView image_profile;
	private static ImageLoaderCircular imgLoader;
	String firstname, dob, location, freetime;
	static String url;
	String guardiantype;
	String name;
	String lastname, facebook_friends, url_picupdate, urlpic_update_child;
	String facebook_id, user_guardian_id, phone_number;
	static SharedPreferences settings;
	boolean booleancheck = false;
	static boolean chk = false;                       
	private boolean imgCapFlag = false;
	protected boolean taken;
	protected static final String PHOTO_TAKEN = "photo_taken";
	protected String path;
	Bitmap bitmap;
	ImageView img;
	Boolean isInternetPresent = false;
	ConnectionDetector cd;
	String child_dob, child_name, child_ID, child_profile_pic, child_hobbies,
			child_allergies, child_conditions, child_school, child_youthclub,
			free_time_child, url_child_image;
	
	String view_data;
	ListView listView;
	public Home() {

	}
	android.support.v4.app.Fragment fragment;
	  // android.support.v4.app.Fragment fragment;
	  
	   /* private Callbacks mCallbacks;
	 
	    public interface Callbacks {
	        public void onBackPressedCallback();
	    }*/
	 
	    @Override
	    public void onBackPressed() {
	        super.onBackPressed();
	        Log.d("DetailActivity", "user pressed the back button");
	       // android.support.v4.app.FragmentTransaction frag = getFragmentManager().beginTransaction().replace(R.id.content_frame, fragment).co
			//finish();
			
	      //  fragmentTransaction.addToBackStack(null);
	        
	    /*    Intent a = new Intent(Intent.ACTION_MAIN);
	        a.addCategory(Intent.CATEGORY_HOME);
	        a.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
	        a.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
	        startActivity(a);*/
	    }
	    
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		dataList = new ArrayList<DrawerItem>();

		LayoutInflater inflater = LayoutInflater.from(this);
		scrollView = (NavigationDrawerclass) inflater.inflate(
				R.layout.screen_scroll_with_list_menu, null);

		setContentView(scrollView);
		//startService(new Intent(this, BillingService.class));
		cd = new ConnectionDetector(this);
		isInternetPresent = cd.isConnectingToInternet();

		if (GlobalVariable.parent_picute_update == 1) {
			String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss",
					Locale.getDefault()).format(new Date());
			
			Intent intent = getIntent();
			url = intent.getExtras().getString("url");
			System.out.println("url..........." + url);
			user_guardian_id = intent.getExtras().getString("user_guardian_id");

			System.out.println("user guardian id.........................."
					+ user_guardian_id);
			name = intent.getExtras().getString("name");
			firstname = intent.getExtras().getString("firstname");
			facebook_id = intent.getExtras().getString("iD");
			System.out.println("url..........." + name);
			freetime = intent.getExtras().getString("freetime");
			System.out.println("url..........." + freetime);
			dob = intent.getExtras().getString("dob");
			System.out.println("url..........." + dob);
			guardiantype = intent.getExtras().getString("guardiantype");
			System.out.println("url..........." + guardiantype);
			location = intent.getExtras().getString("location");
			facebook_friends = intent.getExtras().getString("facebook_friends");
			phone_number = intent.getExtras().getString("phone");
			path = Environment.getExternalStorageDirectory() + "/IMG"
					+ timeStamp + ".jpg";
			startCameraActivity();
		} else if (GlobalVariable.parent_picute_update == 2) {

			String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss",
					Locale.getDefault()).format(new Date());
			Intent intent = getIntent();
			url = intent.getExtras().getString("url");
			System.out.println("url..........." + url);
			user_guardian_id = intent.getExtras().getString("user_guardian_id");

			System.out.println("user guardian id.........................."
					+ user_guardian_id);
			name = intent.getExtras().getString("name");
			firstname = intent.getExtras().getString("firstname");
			facebook_id = intent.getExtras().getString("iD");
			System.out.println("url..........." + name);
			freetime = intent.getExtras().getString("freetime");
			System.out.println("url..........." + freetime);
			dob = intent.getExtras().getString("dob");
			System.out.println("url..........." + dob);
			guardiantype = intent.getExtras().getString("guardiantype");
			System.out.println("url..........." + guardiantype);
			location = intent.getExtras().getString("location");
			facebook_friends = intent.getExtras().getString("facebook_friends");
			phone_number = intent.getExtras().getString("phone");
			path = Environment.getExternalStorageDirectory() + "/IMG"
					+ timeStamp + ".jpg";
			child_dob = intent.getExtras().getString("child_dob");
			child_name = intent.getExtras().getString("child_name");
			child_ID = intent.getExtras().getString("child_ID");
			child_profile_pic = intent.getExtras().getString(
					"child_profile_pic");
			child_hobbies = intent.getExtras().getString("child_hobbies");
			child_allergies = intent.getExtras().getString("child_allergies");
			child_conditions = intent.getExtras().getString("child_conditions");
			child_school = intent.getExtras().getString("child_school");
			child_youthclub = intent.getExtras().getString("child_youthclub");
			free_time_child = intent.getExtras().getString("free_time_child");

			startCameraActivity();
		}

		else if (GlobalVariable.parent_picute_update == 3) {
			String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss",
					Locale.getDefault()).format(new Date());
			Intent intent = getIntent();
			url = intent.getExtras().getString("url");
			user_guardian_id = intent.getExtras().getString("user_guardian_id");
			name = intent.getExtras().getString("name");
			firstname = intent.getExtras().getString("firstname");
			facebook_id = intent.getExtras().getString("iD");
			System.out.println("url..........." + name);
			freetime = intent.getExtras().getString("freetime");
			System.out.println("url..........." + freetime);
			dob = intent.getExtras().getString("dob");
			System.out.println("url..........." + dob);
			guardiantype = intent.getExtras().getString("guardiantype");
			System.out.println("url..........." + guardiantype);
			location = intent.getExtras().getString("location");
			phone_number = intent.getExtras().getString("phone");
			facebook_friends = intent.getExtras().getString("facebook_friends");
			path = Environment.getExternalStorageDirectory() + "/IMG"
					+ timeStamp + ".jpg";
			startCameraActivity();
			
		} else {
			Intent intent = getIntent();
			url = intent.getExtras().getString("url");
			System.out.println("url..........." + url);
			user_guardian_id = intent.getExtras().getString("user_guardian_id");

			System.out.println("user guardian id.........................."
					+ user_guardian_id);
			name = intent.getExtras().getString("name");
			firstname = intent.getExtras().getString("firstname");
			facebook_id = intent.getExtras().getString("iD");
			System.out.println("url..........." + name);
			freetime = intent.getExtras().getString("freetime");
			System.out.println("url..........." + freetime);
			dob = intent.getExtras().getString("dob");
			System.out.println("url..........." + dob);
			guardiantype = intent.getExtras().getString("guardiantype");
			System.out.println("url..........." + guardiantype);
			location = intent.getExtras().getString("location");
			phone_number = intent.getExtras().getString("phone");
			facebook_friends = intent.getExtras().getString("facebook_friends");
		}
		settings = this.getSharedPreferences("MyPreferencesFiles1", 0);
		booleancheck = settings.getBoolean("checkk", chk);
		/*
		 * if(booleancheck == true) { booleancheck=false;
		 * url=settings.getString("url", "");
		 * 
		 * }
		 */
	    // Fragment must implement the callback.
//        if (!(fragment instanceof Callbacks)) {
//            throw new IllegalStateException(
//                    "Fragment must implement the callbacks.");
//        }
// 
//        mCallbacks = (Callbacks) fragment;
//		33
		
		
		final Stack stack = new Stack();
		menu = inflater.inflate(R.layout.sliderview_home, null);

		image_profile = (ImageView) menu
				.findViewById(R.id.imageView1_parent_drawer);
		TextView txt_name = (TextView) menu
				.findViewById(R.id.textView1_profilename);
		txt_name.setText(name);
		imgLoader = new ImageLoaderCircular(this);

		
		
		app = inflater.inflate(R.layout.homeview, null);
		Log.e("tag", "app data");
		
		image_profile.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				count++;
				Bundle bundle = new Bundle();
				bundle.putString("name", name);
				bundle.putString("url", url);
				bundle.putString("freetime", freetime);
				bundle.putString("dob", dob);
				bundle.putString("guardiantype", guardiantype);
				bundle.putString("location", location);
				bundle.putString("firstname", firstname);
				bundle.putString("facebook_id", facebook_id);
				bundle.putString("user_guardian_id", user_guardian_id);
				bundle.putString("facebook_friends", facebook_friends);
				bundle.putString("phone", phone_number);
			/*	android.support.v4.app.Fragment*/ fragment = new Parent_profile();
				fragment.setArguments(bundle);
				android.support.v4.app.FragmentManager fragmentManager = getSupportFragmentManager();
				fragmentManager.beginTransaction()
						.replace(R.id.content_frame, fragment).commit();
				Context context = menu.getContext();

				int menuWidth = menu.getMeasuredWidth();

				menu.setVisibility(View.VISIBLE);

				if (!menuOut) {
					int left = 20;
				} else {
					int left = menuWidth;
					scrollView.smoothScrollTo(left, 0);
				}
				menuOut = !menuOut;
				
			}
		});

		app.setOnTouchListener(this);
		
		ViewGroup tabBar = (ViewGroup) app.findViewById(R.id.tabBar);
		dataList.add(new DrawerItem("Home", R.drawable.home_icon));
		dataList.add(new DrawerItem("Profile", R.drawable.profile_icon));
		dataList.add(new DrawerItem("Calender", R.drawable.calender_icon));
		dataList.add(new DrawerItem("Arrange", R.drawable.add_icon));
		dataList.add(new DrawerItem("Friends", R.drawable.friends_icon));
		dataList.add(new DrawerItem("Sets", R.drawable.sets_icon));
		dataList.add(new DrawerItem("Add Child", R.drawable.child_icon));
		dataList.add(new DrawerItem("Notification", R.drawable.notification_icon));
		
		dataList.add(new DrawerItem("Invite", R.drawable.invite_icon));
		dataList.add(new DrawerItem("Upgrade", R.drawable.upgrade_icon));
		dataList.add(new DrawerItem("feedback", R.drawable.feedback_icon));
		adapter = new CustomDrawerAdapter(this, R.layout.custom_drawer_item,dataList);
		 listView = (ListView) menu.findViewById(R.id.list);
		listView.setDivider(null);
		listView.setDividerHeight(0);
		listView.setAdapter(adapter);
		btn_arrangedate = (Button) app.findViewById(R.id.button_arrange);
		btn_arrangedate.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub

				Bundle bundle = new Bundle();
				bundle.putString("user_guardian_id", user_guardian_id);
				bundle.putString("facebook_friends", facebook_friends);

				/*
				 * Fragment fragment=new Arrange_date_fragment();
				 * fragment.setArguments(bundle);
				 * 
				 * FragmentManager fragmentManager = getFragmentManager();
				 * fragmentManager.beginTransaction()
				 * .replace(R.id.content_frame, fragment).commit();
				 */
				/*android.support.v4.app.Fragment*/ fragment = new Arrange_date_fragment();
				fragment.setArguments(bundle);
				android.support.v4.app.FragmentManager fragmentManager = getSupportFragmentManager();
				fragmentManager.beginTransaction()
						.replace(R.id.content_frame, fragment).commit();
				Context context = menu.getContext();

				int menuWidth = menu.getMeasuredWidth();

				// Ensure menu is visible
				menu.setVisibility(View.VISIBLE);

				if (!menuOut) {
					// Scroll to 0 to reveal menu
					Log.d("===slide==", "Scroll to right");
					Log.d("===clicked==", "clicked");
					int left = 20;
					// scrollView.smoothScrollTo(left, 0);
				} else {
					// Scroll to menuWidth so menu isn't on screen.
					Log.d("===slide==", "Scroll to left");
					Log.d("===clicked==", "clicked");
					int left = menuWidth;
					scrollView.smoothScrollTo(left, 0);
				}
				menuOut = !menuOut;
			}
		});
		
		
		
		
		

		btn_calander = (Button) app.findViewById(R.id.button_calander);
		btn_calander.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub

				Bundle bundle = new Bundle();
				bundle.putString("user_guardian_id", user_guardian_id);

				/*
				 * Fragment fragment=new Calander_event();
				 * fragment.setArguments(bundle); FragmentManager
				 * fragmentManager = getFragmentManager();
				 * fragmentManager.beginTransaction()
				 * .replace(R.id.content_frame, fragment).commit();
				 */
			
				/*android.support.v4.app.Fragment*/ fragment = new Calander_event();
				fragment.setArguments(bundle);
				android.support.v4.app.FragmentManager fragmentManager = getSupportFragmentManager();
				fragmentManager.beginTransaction()
						.replace(R.id.content_frame, fragment).commit();
				Context context = menu.getContext();
				int menuWidth = menu.getMeasuredWidth();
				// Ensure menu is visible
				menu.setVisibility(View.VISIBLE);

				if (!menuOut) {
					// Scroll to 0 to reveal menu
					Log.d("===slide==", "Scroll to right");
					Log.d("===clicked==", "clicked");
					int left = 20;
					// scrollView.smoothScrollTo(left, 0);
				} else {
					// Scroll to menuWidth so menu isn't on screen.
					Log.d("===slide==", "Scroll to left");
					Log.d("===clicked==", "clicked");
					int left = menuWidth;
					scrollView.smoothScrollTo(left, 0);
				}
				menuOut = !menuOut;
			}
		});

		listView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1,
					int Position, long arg3) {
				// TODO Auto-generated method stub

				Fragment fragment = null;

				switch (Position) {
				case 0: {
					Bundle bundle = new Bundle();
					bundle.putString("user_guardian_id", user_guardian_id);
					fragment = new Home_fragment();
					fragment.setArguments(bundle);
					break;
				}
				case 1: {
					Bundle bundle = new Bundle();
					bundle.putString("name", name);
					bundle.putString("url", url);
					bundle.putString("freetime", freetime);
					bundle.putString("dob", dob);
					bundle.putString("guardiantype", guardiantype);
					bundle.putString("location", location);
					bundle.putString("firstname", firstname);
					bundle.putString("facebook_id", facebook_id);
					bundle.putString("user_guardian_id", user_guardian_id);
					bundle.putString("facebook_friends", facebook_friends);
					bundle.putString("phone", phone_number);

					fragment = new Parent_profile();
					fragment.setArguments(bundle);
					break;
				}
				case 2: {

					Bundle bundle = new Bundle();
					bundle.putString("user_guardian_id", user_guardian_id);
					fragment = new Calander_event();
					fragment.setArguments(bundle);
					break;

				}
				case 3: {

					Bundle bundle = new Bundle();
					bundle.putString("user_guardian_id", user_guardian_id);
					bundle.putString("facebook_friends", facebook_friends);

					fragment = new Arrange_date_fragment();
					fragment.setArguments(bundle);

				}
					break;
				case 4: {
					Bundle bundle = new Bundle();
					bundle.putString("response_data", "");
					bundle.putString("check", "1");
					bundle.putString("facebook_friends", facebook_friends);
					fragment = new Sets_friendlist();
					fragment.setArguments(bundle);
					break;
				}
				case 5: {

					Bundle bundle = new Bundle();
					bundle.putString("user_guardian_id", user_guardian_id);
					bundle.putString("facebook_friends", facebook_friends);

					fragment = new Sets();
					fragment.setArguments(bundle);

				}
					break;
				case 6:

				{
					Bundle bundle = new Bundle();
					bundle.putString("name", name);
					bundle.putString("url", url);
					bundle.putString("freetime", freetime);
					bundle.putString("dob", dob);
					bundle.putString("guardiantype", guardiantype);
					bundle.putString("location", location);
					bundle.putString("firstname", firstname);
					bundle.putString("facebook_id", facebook_id);
					bundle.putString("user_guardian_id", user_guardian_id);
					bundle.putString("facebook_friends", facebook_friends);
					bundle.putString("phone", phone_number);
					fragment = new Add_Child();
					fragment.setArguments(bundle);
				}

					break;
				case 7: {
					//add fragement for notification
					Bundle bundle = new Bundle();
					bundle.putString("user_guardian_id", user_guardian_id);
					bundle.putString("view",view_data );
					fragment=new notification_fragement();
					fragment.setArguments(bundle);
					count++;
					break;
				}
				case 8: {

					fragment = new Share_facebook_twitter();
					count=2;

					break;
				}
				case 9: {
				SharedPreferences prefs = getPreferences(Context.MODE_PRIVATE);
		  	    boolean purchased_product = prefs.getBoolean("purchased", false);
		  	    Log.e("ProductPurchase==",""+purchased_product);
		     	
		     	if(purchased_product==true){
		     		Bundle bundle = new Bundle();
		         	bundle.putString("user_guardian_id", user_guardian_id);
		         	bundle.putString("facebook_friends",facebook_friends);
		         	fragment = new authentication();
					fragment.setArguments(bundle);
		     	}else
		     	{
		     		Bundle bundle = new Bundle();
					bundle.putString("user_guardian_id", user_guardian_id);
					bundle.putString("facebook_friends", facebook_friends);
					fragment = new in_App_purchase();
					fragment.setArguments(bundle);
		     	}
					
					
				
					break;
				}
				case 10:
					fragment = new Send_mail();
					break;

				default:
					break;
				}
				if (fragment != null) {

					android.support.v4.app.FragmentManager fragmentManager = getSupportFragmentManager();
					fragmentManager.beginTransaction()
							.replace(R.id.content_frame, fragment).commit();
					Context context = menu.getContext();

					int menuWidth = menu.getMeasuredWidth();

					// Ensure menu is visible
					menu.setVisibility(View.VISIBLE);

					if (!menuOut) {
						// Scroll to 0 to reveal menu
						Log.d("===slide==", "Scroll to right");
						Log.d("===clicked==", "clicked");
						int left = 20;
						// scrollView.smoothScrollTo(left, 0);
					} else {
						// Scroll to menuWidth so menu isn't on screen.
						Log.d("===slide==", "Scroll to left");
						Log.d("===clicked==", "clicked");
						int left = menuWidth;
						scrollView.smoothScrollTo(left, 0);
					}
					menuOut = !menuOut;

					// update selected item and title, then close the drawer
					/*
					 * mDrawerList.setItemChecked(position, true);
					 * mDrawerList.setSelection(position);
					 * setTitle(navMenuTitles[position]);
					 * mDrawerLayout.closeDrawer(mDrawerList);
					 */
				} else {
					// error in creating fragment
					Log.e("MainActivity", "Error in creating fragment");
				}
			}
		});

		btnSlide = (Button) tabBar.findViewById(R.id.button_back);

		btn_home = (Button) tabBar.findViewById(R.id.button_home);
		btn_home.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub

				Bundle bundle = new Bundle();
				bundle.putString("user_guardian_id", user_guardian_id);
				/*android.support.v4.app.Fragment*/ fragment = new Home_fragment();
				fragment.setArguments(bundle);
				android.support.v4.app.FragmentManager fragmentManager = getSupportFragmentManager();
				fragmentManager.beginTransaction()
						.replace(R.id.content_frame, fragment).commit();
				Context context = menu.getContext();
				int menuWidth = menu.getMeasuredWidth();

				// Ensure menu is visible
				menu.setVisibility(View.VISIBLE);

				if (!menuOut) {
					// Scroll to 0 to reveal menu
					Log.d("===slide==", "Scroll to right");
					Log.d("===clicked==", "clicked");
					int left = 20;
					// scrollView.smoothScrollTo(left, 0);
				} else {
					// Scroll to menuWidth so menu isn't on screen.
					Log.d("===slide==", "Scroll to left");
					Log.d("===clicked==", "clicked");
					int left = menuWidth;
					scrollView.smoothScrollTo(left, 0);
				}
				menuOut = !menuOut;

			}
		});

		btnSlide.setOnClickListener(new ClickListenerForScrolling(scrollView,
				menu));

		final View[] children = new View[] { menu, app };

		// Scroll to app (view[1]) when layout finished.
		int scrollToViewIdx = 1;

		scrollView.initViews(children, scrollToViewIdx,
				new SizeCallbackForMenu(btnSlide));

		Bundle bundle = new Bundle();
		bundle.putString("user_guardian_id", user_guardian_id);
		/*android.support.v4.app.Fragment*/ fragment = new Home_fragment();
		fragment.setArguments(bundle);
		android.support.v4.app.FragmentManager fragmentManager = getSupportFragmentManager();
		fragmentManager.beginTransaction()
				.replace(R.id.content_frame, fragment).commit();
		Context context = menu.getContext();

	}

	protected void startCameraActivity() {
		// Log message
		Log.i("AndroidProgrammerGuru", "startCameraActivity()");
		// Create new file with name mentioned in the path variable
		File file = new File(path);
		// Creates a Uri from a file
		Uri outputFileUri = Uri.fromFile(file);
		// Standard Intent action that can be sent to have the
		// camera application capture an image and return it.
		// You will be redirected to camera at this line
		Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
		// Add the captured image in the path
		intent.putExtra(MediaStore.EXTRA_OUTPUT, outputFileUri);
		// Start result method - Method handles the output
		// of the camera activity
		startActivityForResult(intent, 0);
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		// Log message
		Log.i("AndroidProgrammerGuru", "resultCode: " + resultCode);
		if(GlobalVariable.parent_picute_update == 0){
		Fragment fragment1 = getSupportFragmentManager().findFragmentById(R.id.content_frame);
	    fragment1.onActivityResult(requestCode, resultCode, data);
		}
		switch (resultCode) {
		// When user doesn't capture image, resultcode returns 0
		case 0:
			Log.i("AndroidProgrammerGuru", "User cancelled");
			if (GlobalVariable.parent_picute_update == 1) {
				// new parent_pic_update().execute();
				GlobalVariable.parent_picute_update = 0;
				Bundle bundle = new Bundle();
				bundle.putString("name", name);
				bundle.putString("url", url);
				bundle.putString("freetime", freetime);
				bundle.putString("dob", dob);
				bundle.putString("guardiantype", guardiantype);
				bundle.putString("location", location);
				bundle.putString("firstname", firstname);
				bundle.putString("facebook_id", facebook_id);
				bundle.putString("user_guardian_id", user_guardian_id);
				bundle.putString("phone", phone_number);
				android.support.v4.app.Fragment fragment = new Parent_profile();
				fragment.setArguments(bundle);
				android.support.v4.app.FragmentManager fragmentManager = getSupportFragmentManager();
				fragmentManager.beginTransaction()
						.replace(R.id.content_frame, fragment).commit();
			}
			if (GlobalVariable.parent_picute_update == 2) {
				GlobalVariable.parent_picute_update = 0;
				Bundle bundle = new Bundle();
				bundle.putString("child_name", child_name);
				bundle.putString("Child_id", child_ID);
				bundle.putString("Child_profilepic", child_profile_pic);
				bundle.putString("dob", child_dob);
				bundle.putString("conditions", child_conditions);
				bundle.putString("hobbies", child_hobbies);
				bundle.putString("Child_guardianId", user_guardian_id);
				bundle.putString("allergies", child_allergies);
				bundle.putString("school", child_school);
				bundle.putString("youthclub", child_youthclub);
				bundle.putString("free_time", free_time_child);
				bundle.putString("parent_name", name);
				bundle.putString("parent_profilepic", url);
				bundle.putString("parent_freetime", freetime);
				bundle.putString("phone", phone_number);
				bundle.putString("parent_dob", dob);
				bundle.putString("parent_type", guardiantype);
				bundle.putString("parent_location", location);
				bundle.putString("parent_fbid", facebook_id);
				bundle.putString("facebook_friends", facebook_friends);
				android.support.v4.app.Fragment fragment = new Child_profile();
				fragment.setArguments(bundle);
				android.support.v4.app.FragmentManager fragmentManager = getSupportFragmentManager();
				fragmentManager.beginTransaction()
						.replace(R.id.content_frame, fragment).commit();
			}
			if (GlobalVariable.parent_picute_update == 3) {


			}
			break;
		// When user captures image, onPhotoTaken an user-defined method
		// to assign the capture image to ImageView
		case -1:
			onPhotoTaken();
			if (GlobalVariable.parent_picute_update == 1) {

				if (isInternetPresent) {
					new parent_pic_update().execute();

				} else {
					Toast.makeText(Home.this,
							"Please check internet connection", 2000).show();

				}

			}
			if (GlobalVariable.parent_picute_update == 2) {

				if (isInternetPresent) {
					new child_pic_update().execute();

				} else {
					Toast.makeText(Home.this,
							"Please check internet connection", 2000).show();

				}

			}
			if (GlobalVariable.parent_picute_update == 3) {

				if (isInternetPresent) {
					new child_pic_update1().execute();

				} else {
					Toast.makeText(Home.this,
							"Please check internet connection", 2000).show();

				}

				/*GlobalVariable.parent_picute_update=0;
				Bundle bundle = new Bundle();
				bundle.putString("user_guardian_id", user_guardian_id);
				bundle.putString("phone", phone_number);
				bundle.putString("name", name);
				bundle.putString("url", url);
				bundle.putString("freetime", freetime);
				bundle.putString("dob", dob);
				bundle.putString("guardiantype", guardiantype);
				bundle.putString("location", location);
				bundle.putString("firstname", firstname);
				bundle.putString("facebook_id", facebook_id);
				bundle.putParcelable("bitmap", bitmap);
				android.support.v4.app.Fragment fragment = new Add_Child();
				fragment.setArguments(bundle);
				android.support.v4.app.FragmentManager fragmentManager = getSupportFragmentManager();
				fragmentManager.beginTransaction()
						.replace(R.id.content_frame, fragment).commit();*/
			}
			break;
		}
	}

	protected void onPhotoTaken() {
		// Log message
		Log.i("AndroidProgrammerGuru", "onPhotoTaken");
		// Flag used by Activity life cycle methods
		taken = true;
		// Flag used to check whether image captured or not
		imgCapFlag = true;
		// BitmapFactory- Create an object
		BitmapFactory.Options options = new BitmapFactory.Options();
		// Set image size
		options.inSampleSize = 4;
		// Read bitmap from the path where captured image is stored
		bitmap = BitmapFactory.decodeFile(path, options);
		// img.setImageBitmap(bitmap);

		// Set ImageView with the bitmap read in the prev line
		//
		// Make the TextView invisible
		// field.setVisibility(View.GONE);
	}

	@Override
	protected void onSaveInstanceState(Bundle outState) {
		outState.putBoolean(Home.PHOTO_TAKEN, taken);
	}

	@Override
	protected void onRestoreInstanceState(Bundle savedInstanceState) {
		Log.i("AndroidProgrammerGuru", "onRestoreInstanceState()");
		if (savedInstanceState.getBoolean(Home.PHOTO_TAKEN)) {
			// onPhotoTaken();
		}
	}

	static class ClickListenerForScrolling implements OnClickListener {
		NavigationDrawerclass scrollView;
		View menu;

		/**
		 * Menu must NOT be out/shown to start with.
		 */
		// boolean menuOut = false;

		public ClickListenerForScrolling(NavigationDrawerclass scrollView,
				View menu) {
			super();
			this.scrollView = scrollView;
			this.menu = menu;
		}

		@Override
		public void onClick(View v) {

			// SharedPreferences.Editor editor = settings.edit(); // Opening
			// editor for SharedPreferences

			if (GlobalVariable.url.equals("")) {

			} else {
				url = GlobalVariable.url;
				// chk=true;
				/*
				 * editor.putString("url",GlobalVariable.url);
				 * 
				 * editor.putBoolean("checkk", chk); editor.commit();
				 */
			}
			imgLoader.DisplayImage(url, image_profile);
			image_profile.requestLayout();
			int density = v.getResources().getDisplayMetrics().densityDpi;
			switch (density) {
			case DisplayMetrics.DENSITY_LOW:
				image_profile.getLayoutParams().height = 70;
				image_profile.getLayoutParams().width = 50;
				break;
			case DisplayMetrics.DENSITY_MEDIUM:
				image_profile.getLayoutParams().height = 90;
				image_profile.getLayoutParams().width = 70;
				break;
			case DisplayMetrics.DENSITY_HIGH:
				image_profile.getLayoutParams().height = 120;
				image_profile.getLayoutParams().width = 100;
				break;
			case DisplayMetrics.DENSITY_XHIGH:
				image_profile.getLayoutParams().height = 180;
				image_profile.getLayoutParams().width = 150;
				break;
			case DisplayMetrics.DENSITY_XXHIGH:
				image_profile.getLayoutParams().height = 180;
				image_profile.getLayoutParams().width = 150;
				break;
			}

			clickeventimplement();
		}
	}

	/**
	 * Helper that remembers the width of the 'slide' button, so that the
	 * 'slide' button remains in view, even when the menu is showing.
	 */
	static class SizeCallbackForMenu implements SizeCallback {
		int btnWidth;
		View btnSlide;

		public SizeCallbackForMenu(View btnSlide) {
			super();
			this.btnSlide = btnSlide;
		}

		@Override
		public void onGlobalLayout() {
			btnWidth = btnSlide.getMeasuredWidth();
			System.out.println("btnWidth=" + btnWidth);
		}

		@Override
		public void getViewSize(int idx, int w, int h, int[] dims) {
			dims[0] = w;
			dims[1] = h;
			final int menuIdx = 0;
			if (idx == menuIdx) {
				dims[0] = w - btnWidth;
			}
		}
	}

	// scroll the page and open the webview
	private void scrollWebviw(NavigationDrawerclass scrollView, View menu) {
		Context context = menu.getContext();

		int menuWidth = menu.getMeasuredWidth();

		// Ensure menu is visible
		menu.setVisibility(View.VISIBLE);

		if (!menuOut) {
			// Scroll to 0 to reveal menu
			Log.d("===slide==", "Scroll to right");
			int left = 0;
			scrollView.smoothScrollTo(left, 0);
		} else {
			// Scroll to menuWidth so menu isn't on screen.
			Log.d("===slide==", "Scroll to left");
			int left = menuWidth;
			scrollView.smoothScrollTo(left, 0);

		}
		menuOut = false;
	}

	public static void clickeventimplement() {
		// TODO Auto-generated method stub
		Context context = menu.getContext();

		int menuWidth = menu.getMeasuredWidth();

		// Ensure menu is visible
		menu.setVisibility(View.VISIBLE);

		if (!menuOut) {
			// Scroll to 0 to reveal menu
			Log.d("===slide==", "Scroll to right");
			Log.d("===clicked==", "clicked");
			int left = 20;
			scrollView.smoothScrollTo(left, 0);
		} else {
			// Scroll to menuWidth so menu isn't on screen.
			Log.d("===slide==", "Scroll to left");
			Log.d("===clicked==", "clicked");
			int left = menuWidth;
			scrollView.smoothScrollTo(left, 0);
		}
		menuOut = !menuOut;
	}

	public static void clickeventimplementfragment() {
		// TODO Auto-generated method stub
		Context context = menu.getContext();

		int menuWidth = menu.getMeasuredWidth();

		// Ensure menu is visible
		menu.setVisibility(View.VISIBLE);

		// Scroll to menuWidth so menu isn't on screen.
		Log.d("===slide==", "Scroll to left");
		Log.d("===clicked==", "clicked");
		int left = menuWidth;
		scrollView.smoothScrollTo(left, 0);

		menuOut = !menuOut;
	}

	@Override
	protected void onResume() {
		super.onResume();

	}

	@Override
	public boolean onTouch(View v, MotionEvent touchevent) {
		// TODO Auto-generated method stub
		System.out.println("fffffffffffffffffffffffff");
		app = v;

		switch (touchevent.getAction()) {
		// when user first touches the screen we get x and y coordinate
		case MotionEvent.ACTION_DOWN: {
			System.out.println("fffffffffffffffffffffffff");
			x1 = touchevent.getX();
			y1 = touchevent.getY();
			break;
		}
		case MotionEvent.ACTION_UP: {
			System.out.println("fffffffffffffffffffffffff");
			x2 = touchevent.getX();
			y2 = touchevent.getY();

			// if left to right sweep event on screen
			/*
			 * if (x1 < x2) { System.out.println("fffffffffffffffffffffffff");
			 * Toast.makeText(this, "Left to Right Swap Performed",
			 * Toast.LENGTH_LONG).show(); }
			 */
			// if right to left sweep event on screen
			if (x1 > x2) {
				System.out.println("fffffffffffffffffffffffff");
				Context context = menu.getContext();

				int menuWidth = menu.getMeasuredWidth();

				// Ensure menu is visible
				menu.setVisibility(View.VISIBLE);

				if (!menuOut) {
					// Scroll to 0 to reveal menu
					Log.d("===slide==", "Scroll to right");
					Log.d("===clicked==", "clicked");
					int left = 20;
					// scrollView.smoothScrollTo(left, 0);
				} else {
					// Scroll to menuWidth so menu isn't on screen.
					Log.d("===slide==", "Scroll to left");
					Log.d("===clicked==", "clicked");
					int left = menuWidth;
					scrollView.smoothScrollTo(left, 0);
				}
				menuOut = !menuOut;
				// Toast.makeText(this, "Right to Left Swap Performed",
				// Toast.LENGTH_LONG).show();

			}

			break;
		}
		}
		return true;
	}

//	@Override
//	public void onBackPressed() {
//
//	}

	public class parent_pic_update extends AsyncTask<String, Integer, String> {
		ProgressDialog dialog = new ProgressDialog(Home.this);

		InputStream is;
		String result;
		JSONObject jArray = null;
		String data;
		private String urlreturned;

		@Override
		protected void onPreExecute() {
			// Toast.makeText(Login.this,"asynch task",Toast.LENGTH_LONG).show();
			dialog.setMessage("Loading.......please wait");
			dialog.setCancelable(false);
			dialog.show();
			GlobalVariable.parent_picute_update = 0;
			url_picupdate = "http://54.191.67.152/playdate/guardian_edit.php";// ?profile_pic=pic&name=deepak&dob=1989/1/12&set_fixed_freetime=1989/2/4&school=DPS&conditions=TRUE&allergies=test&hobbies=demo&siblings=mother&youth_club=abc&g_id=10"
		}

		@Override
		protected String doInBackground(String... arg0) {
			// TODO Auto-generated method stub

			HttpClient httpClient = new DefaultHttpClient();
			HttpContext localContext = new BasicHttpContext();
			HttpPost httpPost = new HttpPost(url_picupdate);

			// Bitmap bitmap =
			// BitmapFactory.decodeResource(getResources(),R.drawable.ic_launcher);
			String image_str = null;
			try {
				ByteArrayOutputStream stream = new ByteArrayOutputStream();
				bitmap.compress(Bitmap.CompressFormat.JPEG, 90, stream);
				byte[] byte_arr = stream.toByteArray();
				 image_str = com.iapptechnologies.time.Base64.encodeBytes(byte_arr);
				System.out.println("image compressed");
			} catch (Exception e) {
				// TODO: handle exception
			}
			

			ArrayList<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();
			nameValuePairs
					.add(new BasicNameValuePair("profile_image", "12.jpg"));
			nameValuePairs
					.add(new BasicNameValuePair("g_id", user_guardian_id));
			nameValuePairs.add(new BasicNameValuePair("img", image_str));
			try {
				httpPost.setEntity(new UrlEncodedFormEntity(nameValuePairs));

				System.out.println(httpPost);
			} catch (UnsupportedEncodingException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}

			HttpResponse response = null;
			try {
				response = httpClient.execute(httpPost, localContext);
			} catch (ClientProtocolException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			BufferedReader reader = null;
			try {
				reader = new BufferedReader(new InputStreamReader(response
						.getEntity().getContent(), "UTF-8"));
			} catch (UnsupportedEncodingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IllegalStateException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			String sResponse = null;

			try {
				sResponse = reader.readLine();

				System.out.println("response................12..........."
						+ sResponse);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			try {
				JSONObject json = new JSONObject(sResponse);

				data = json.getString("success");
				urlreturned = json.getString("url");

			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			return null;
		}

		protected void onPostExecute(String resultt) {

			url = urlreturned;
			GlobalVariable.url = urlreturned;
			dialog.dismiss();
			if (data.equalsIgnoreCase("1")) {
				Toast.makeText(Home.this, "Updated", 1000).show();
				Bundle bundle = new Bundle();
				bundle.putString("name", name);
				bundle.putString("url", url);
				bundle.putString("freetime", freetime);
				bundle.putString("dob", dob);
				bundle.putString("guardiantype", guardiantype);
				bundle.putString("location", location);
				bundle.putString("firstname", firstname);
				bundle.putString("facebook_id", facebook_id);
				bundle.putString("user_guardian_id", user_guardian_id);
				bundle.putString("phone", phone_number);
				android.support.v4.app.Fragment fragment = new Parent_profile();
				fragment.setArguments(bundle);
				android.support.v4.app.FragmentManager fragmentManager = getSupportFragmentManager();
				fragmentManager.beginTransaction()
						.replace(R.id.content_frame, fragment).commit();

				// strURL=urlreturned;

			} else {
				Toast.makeText(Home.this,
						"Updation not successful, please try again", 1000)
						.show();
				Bundle bundle = new Bundle();
				bundle.putString("name", name);
				bundle.putString("url", url);
				bundle.putString("freetime", freetime);
				bundle.putString("dob", dob);
				bundle.putString("guardiantype", guardiantype);
				bundle.putString("location", location);
				bundle.putString("firstname", firstname);
				bundle.putString("facebook_id", facebook_id);
				bundle.putString("user_guardian_id", user_guardian_id);
				bundle.putString("phone", phone_number);
				android.support.v4.app.Fragment fragment = new Parent_profile();
				fragment.setArguments(bundle);
				android.support.v4.app.FragmentManager fragmentManager = getSupportFragmentManager();
				fragmentManager.beginTransaction()
						.replace(R.id.content_frame, fragment).commit();
			}
		}
	}

	public class child_pic_update extends AsyncTask<String, Integer, String> {
		ProgressDialog dialog = new ProgressDialog(Home.this);
		String url_child;
		InputStream is;
		String result;
		JSONObject jArray = null;
		String data;

		@Override
		protected void onPreExecute() {
			// Toast.makeText(Login.this,"asynch task",Toast.LENGTH_LONG).show();
			dialog.setMessage("Loading.......please wait");
			dialog.setCancelable(false);
			dialog.show();
			GlobalVariable.parent_picute_update = 0;
			url_child = "http://54.191.67.152/playdate/childprofile_pic_edit.php";// ?childid=4&profile_image=1.jpg";//"http://54.191.67.152/playdate/guardian_edit.php";//?profile_pic=pic&name=deepak&dob=1989/1/12&set_fixed_freetime=1989/2/4&school=DPS&conditions=TRUE&allergies=test&hobbies=demo&siblings=mother&youth_club=abc&g_id=10"
		}

		@Override
		protected String doInBackground(String... arg0) {
			// TODO Auto-generated method stub

			HttpClient httpClient = new DefaultHttpClient();
			HttpContext localContext = new BasicHttpContext();
			HttpPost httpPost = new HttpPost(url_child);

			// Bitmap bitmap =
			// BitmapFactory.decodeResource(getResources(),R.drawable.ic_launcher);
			String image_str=null;
			try {
				ByteArrayOutputStream stream = new ByteArrayOutputStream();
				bitmap.compress(Bitmap.CompressFormat.JPEG, 90, stream); 
				byte[] byte_arr = stream.toByteArray();
			 image_str = com.iapptechnologies.time.Base64
						.encodeBytes(byte_arr);
			} catch (Exception e) {
				// TODO: handle exception
			}
			
			System.out.println("image compressed");

			ArrayList<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();
			nameValuePairs
					.add(new BasicNameValuePair("g_id", user_guardian_id));
			nameValuePairs.add(new BasicNameValuePair("childid", child_ID));
			nameValuePairs.add(new BasicNameValuePair("img", image_str));
			try {
				httpPost.setEntity(new UrlEncodedFormEntity(nameValuePairs));

				System.out.println(httpPost);
			} catch (UnsupportedEncodingException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}

			HttpResponse response = null;
			try {
				response = httpClient.execute(httpPost, localContext);
			} catch (ClientProtocolException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			BufferedReader reader = null;
			try {
				reader = new BufferedReader(new InputStreamReader(response
						.getEntity().getContent(), "UTF-8"));
			} catch (UnsupportedEncodingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IllegalStateException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			String sResponse = null;

			try {
				sResponse = reader.readLine();

				System.out.println("response" + sResponse);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			try {
				JSONObject json = new JSONObject(sResponse);

				data = json.getString("success");
				url_child_image = json.getString("url");
				System.out.println("urlreturnurlretururlreturned"
						+ url_child_image);

			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			return null;
		}

		protected void onPostExecute(String resultt) {

			dialog.dismiss();
			if (data.equalsIgnoreCase("1")) {
				Toast.makeText(Home.this, "Updated", 1000).show();
				Bundle bundle = new Bundle();

				bundle.putString("child_name", child_name);
				bundle.putString("Child_id", child_ID);
				bundle.putString("Child_profilepic", url_child_image);
				bundle.putString("dob", child_dob);
				bundle.putString("conditions", child_conditions);
				bundle.putString("hobbies", child_hobbies);
				bundle.putString("Child_guardianId", user_guardian_id);
				bundle.putString("allergies", child_allergies);
				bundle.putString("school", child_school);
				bundle.putString("youthclub", child_youthclub);
				bundle.putString("free_time", free_time_child);
				bundle.putString("parent_name", name);
				bundle.putString("parent_profilepic", url);
				bundle.putString("parent_freetime", freetime);
				bundle.putString("phone", phone_number);
				bundle.putString("parent_dob", dob);
				bundle.putString("parent_type", guardiantype);
				bundle.putString("parent_location", location);
				bundle.putString("parent_fbid", facebook_id);
				bundle.putString("facebook_friends", facebook_friends);
				android.support.v4.app.Fragment fragment = new Child_profile();
				fragment.setArguments(bundle);
				android.support.v4.app.FragmentManager fragmentManager = getSupportFragmentManager();
				fragmentManager.beginTransaction()
						.replace(R.id.content_frame, fragment).commit();

				// strURL=urlreturned;

			} else {
				Toast.makeText(Home.this,
						"Updation not successful, please try again", 1000)
						.show();
				Bundle bundle = new Bundle();
				bundle.putString("child_name", child_name);
				bundle.putString("Child_id", child_ID);
				bundle.putString("Child_profilepic", child_profile_pic);
				bundle.putString("dob", child_dob);
				bundle.putString("conditions", child_conditions);
				bundle.putString("hobbies", child_hobbies);
				bundle.putString("Child_guardianId", user_guardian_id);
				bundle.putString("allergies", child_allergies);
				bundle.putString("school", child_school);
				bundle.putString("youthclub", child_youthclub);
				bundle.putString("free_time", free_time_child);
				bundle.putString("parent_name", name);
				bundle.putString("parent_profilepic", url);
				bundle.putString("parent_freetime", freetime);
				bundle.putString("phone", phone_number);
				bundle.putString("parent_dob", dob);
				bundle.putString("parent_type", guardiantype);
				bundle.putString("parent_location", location);
				bundle.putString("parent_fbid", facebook_id);
				bundle.putString("facebook_friends", facebook_friends);
				android.support.v4.app.Fragment fragment = new Child_profile();
				fragment.setArguments(bundle);
				android.support.v4.app.FragmentManager fragmentManager = getSupportFragmentManager();
				fragmentManager.beginTransaction()
						.replace(R.id.content_frame, fragment).commit();
			}
		}
	}

	public class child_pic_update1 extends AsyncTask<String, Integer, String> {
		ProgressDialog dialog = new ProgressDialog(Home.this);
		String url_child;
		InputStream is;
		String result;
		JSONObject jArray = null;
		String data;

		@Override
		protected void onPreExecute() {
			// Toast.makeText(Login.this,"asynch task",Toast.LENGTH_LONG).show();
			dialog.setMessage("Loading.......please wait");
			dialog.setCancelable(false);
			dialog.show();
			url_picupdate = "http://54.191.67.152/playdate/guardian_child.php";
		}

		@Override
		protected String doInBackground(String... arg0) {
			/*HttpClient httpClient = new DefaultHttpClient();
			HttpContext localContext = new BasicHttpContext();
			HttpPost httpPost = new HttpPost(url_picupdate);

			// Bitmap bitmap =
			// BitmapFactory.decodeResource(getResources(),R.drawable.ic_launcher);
			ByteArrayOutputStream stream = new ByteArrayOutputStream();
			bitmap.compress(Bitmap.CompressFormat.JPEG, 90, stream); // compress
																		// to
																		// which
																		// format
																		// you
																		// want.
			byte[] byte_arr = stream.toByteArray();
			String image_str = com.iapptechnologies.time.Base64
					.encodeBytes(byte_arr);
			System.out.println("image compressed");

			ArrayList<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();

			nameValuePairs
					.add(new BasicNameValuePair("g_id", user_guardian_id));

			try {
				httpPost.setEntity(new UrlEncodedFormEntity(nameValuePairs));

				System.out.println(httpPost);
			} catch (UnsupportedEncodingException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}

			HttpResponse response = null;
			try {
				response = httpClient.execute(httpPost, localContext);
			} catch (ClientProtocolException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			BufferedReader reader = null;
			try {
				reader = new BufferedReader(new InputStreamReader(response
						.getEntity().getContent(), "UTF-8"));
			} catch (UnsupportedEncodingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IllegalStateException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			String sResponse = null;

			try {
				sResponse = reader.readLine();

				System.out.println("response................12..........."
						+ sResponse);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			try {
				JSONObject json = new JSONObject(sResponse);

				
				 * data=json.getString("success");
				 * urlreturned=json.getString("url");
				 

			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
*/
			return null;
		}

		@SuppressLint({ "ShowToast" })
		protected void onPostExecute(String resultt) {
			dialog.dismiss();
			Toast.makeText(Home.this, "Image Captured", 1000).show();
			Bundle bundle = new Bundle();
			bundle.putString("user_guardian_id", user_guardian_id);
			bundle.putString("phone", phone_number);
			bundle.putString("name", name);
			bundle.putString("url", url);
			bundle.putString("freetime", freetime);
			bundle.putString("dob", dob);
			bundle.putString("guardiantype", guardiantype);
			bundle.putString("location", location);
			bundle.putString("firstname", firstname);
			bundle.putString("facebook_id", facebook_id);
			bundle.putParcelable("bitmap", bitmap);
			android.support.v4.app.Fragment fragment = new Add_Child();
			fragment.setArguments(bundle);
			android.support.v4.app.FragmentManager fragmentManager = getSupportFragmentManager();
			fragmentManager.beginTransaction()
					.replace(R.id.content_frame, fragment).commit();
		}
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
	 public boolean onKeyDown(int keyCode, KeyEvent event)
	 {
	 if (keyCode == KeyEvent.KEYCODE_BACK)
	 {
	    if (getSupportFragmentManager().getBackStackEntryCount() == 0)
	    {
	        this.finish();
	        return false;
	    }
	    else
	    {
	        getSupportFragmentManager().popBackStack();
	        removeCurrentFragment();

	        return false;
	    }



	 }

	  return super.onKeyDown(keyCode, event);
	 }
	public void removeCurrentFragment()
	{
	FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();

	Fragment currentFrag =  getSupportFragmentManager().findFragmentById(R.id.content_frame);
	}
	
	
}
