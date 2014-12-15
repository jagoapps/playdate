package com.iapptechnologies.time;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.concurrent.atomic.AtomicInteger;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.protocol.BasicHttpContext;
import org.apache.http.protocol.HttpContext;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.accounts.AccountAuthenticatorActivity;
import android.app.AlertDialog;
import android.app.DownloadManager.Request;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.content.pm.Signature;
import android.os.AsyncTask;
import android.os.Bundle;
import android.service.textservice.SpellCheckerService.Session;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.view.View.OnClickListener;
import android.widget.RelativeLayout;
import android.widget.Toast;

import com.facebook.HttpMethod;
import com.facebook.LoggingBehavior;
import com.facebook.Response;
import com.facebook.SessionLoginBehavior;
import com.facebook.SessionState;
import com.facebook.android.Facebook;
import com.facebook.model.GraphObject;
import com.google.analytics.tracking.android.EasyTracker;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.android.gms.gcm.GoogleCloudMessaging;
import com.iapp.playdate.R;

public class FacebookLogin extends AccountAuthenticatorActivity {

	JSONArray CustomMessageStr;
	private com.facebook.Session.StatusCallback statusCallback = new SessionStatusCallback();
	public static final String PREFS_NAME = "MyPrefsFile";
	String token, url1, ejabber_username, ejabber_password;;
	String fb_ids = "";
	Response responsefriends;
	String userfirstname, userlastname, userlocation, userdob, useremail,
			userphone, usergender, userguardiantype, userfreetime, iD,
			user_guardian_id, date_of_birthparsed;
	String userprofilepic, userphone_saved;
	SharedPreferences settings;
	boolean bool = false;
	boolean check = false;
	Facebook facebook;
	RelativeLayout relativeLayout;
	String fbfriends = "";
	ProgressDialog dialog;
	Boolean isInternetPresent = false;
	ConnectionDetector cd;
	public static final String EXTRA_MESSAGE = "message";
	public static final String PROPERTY_REG_ID = "registration_id";
	private static final String PROPERTY_APP_VERSION = "appVersion";
	private final static int PLAY_SERVICES_RESOLUTION_REQUEST = 9000;

	
	String SENDER_ID = "77923313167";

	
	static final String TAG = "GCMDemo";

	GoogleCloudMessaging gcm;
	AtomicInteger msgId = new AtomicInteger();
	SharedPreferences prefs;
	Context context;

	String regid;


	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		setContentView(R.layout.loginwithfacebook);
		relativeLayout = (RelativeLayout) findViewById(R.id.relative_facebookMain);
		settings = getSharedPreferences("MyPreferencesFile", 0);
		bool = settings.getBoolean("check", check);// if Internet is not present
													// then load from shared
													// preferences
		System.out.println(check);
		System.out.println("boo............" + bool);
		cd = new ConnectionDetector(this);
		context = getApplicationContext();

		isInternetPresent = cd.isConnectingToInternet();

		if (isInternetPresent) {
			PackageInfo packageInfo;
			try {
				packageInfo = getPackageManager().getPackageInfo(
						"com.iapp.playdate", PackageManager.GET_SIGNATURES);
				for (Signature signature : packageInfo.signatures) {
					MessageDigest md = MessageDigest.getInstance("SHA");
					md.update(signature.toByteArray());
					String key = new String(
							com.iapptechnologies.time.Base64.encodeBytes(
									md.digest(), 0));
					Log.e("Hash key", key);
				}// md.digest(), 0
			} catch (NameNotFoundException e1) {
				Log.e("Name not found", e1.toString());
			}

			catch (NoSuchAlgorithmException e) {
				Log.e("No such an algorithm", e.toString());
			} catch (Exception e) {
				Log.e("Exception", e.toString());
			}

			com.facebook.Settings.addLoggingBehavior(LoggingBehavior.INCLUDE_ACCESS_TOKENS);
			com.facebook.Session session = com.facebook.Session.getActiveSession();
			if (session == null) {
				if (savedInstanceState != null) {
					session = com.facebook.Session.restoreSession(this, null,
							statusCallback, savedInstanceState);
				}
				if (session == null) {
					session = new com.facebook.Session(this);
				}
				com.facebook.Session.setActiveSession(session);
				if (session.getState()
						.equals(SessionState.CREATED_TOKEN_LOADED)) {
					
					com.facebook.Session.getActiveSession().getExpirationDate();
					
					System.out.println("date......."+com.facebook.Session.getActiveSession().getExpirationDate());

					Date expDate=com.facebook.Session.getActiveSession().getExpirationDate();
					SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmss");
					String currentDateandTime = sdf.format(new Date());
					Date date=null;
					
					try {
						 
						 date = sdf.parse(currentDateandTime);
						System.out.println(date);
						
				 
					} catch (ParseException e) {
						e.printStackTrace();
					}
					if (expDate.getTime() > date.getTime()) {
					   System.out.println("token Valid");
					}else{
						
					}
					
					
					
					session.openForRead(new com.facebook.Session.OpenRequest(this)
							.setCallback(statusCallback));                                                                     
                                                                                                                    
					System.out.println("already logined");
					token = session.getAccessToken();
					System.out.println("token" + token);
					System.out.println(session);
					SharedPreferences settings = getSharedPreferences(
							PREFS_NAME, 0);
					SharedPreferences.Editor editor = settings.edit();
					editor.putString("FBToken", token);

					// Commit the edits!
					editor.commit();
				}
			} else {
				System.out
						.println("else block............................oncreate method");
				com.facebook.Session.openActiveSession(this, true,
						new com.facebook.Session.StatusCallback() {

							@Override
							public void call(final com.facebook.Session session,
									SessionState state, Exception exception) {

								if (session.isOpened()) {

								}
							}
						});
			}
		} else {
			Toast.makeText(this, "Please check internet connection", 2000)
					.show();
			// Loading from shared preferences
			if (bool == true) {
				userfirstname = settings.getString("userfirstname", "");
				userlocation = settings.getString("userlocation", "");
				userdob = settings.getString("userdob", "");
				userguardiantype = settings.getString("userguardiantype", "");
				userfreetime = settings.getString("userfreetime", "");
				userfirstname = settings.getString("userfirstname", "");
				user_guardian_id = settings.getString("user_guardian_id", "");
				userprofilepic = settings.getString("userprofilepic", "");
				userphone_saved = settings.getString("userphone", "");
				iD = settings.getString("id", "");

				Intent it = new Intent(FacebookLogin.this, Home.class);
				it.putExtra("url", userprofilepic);
				it.putExtra("name", userfirstname);
				it.putExtra("firstname", userfirstname);
				it.putExtra("iD", iD);
				it.putExtra("location", userlocation);
				it.putExtra("dob", userdob);
				it.putExtra("guardiantype", userguardiantype);
				it.putExtra("freetime", userfreetime);
				it.putExtra("user_guardian_id", user_guardian_id);
				it.putExtra("facebook_friends", fbfriends);
				it.putExtra("phone", userphone_saved);
				// it.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);

				startActivity(it);
				finish();
				System.out.println("entered into parent class");
			}

		}
		dialog = new ProgressDialog(FacebookLogin.this);

		relativeLayout.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {

				try {
					com.facebook.Session.OpenRequest request;
					request = new com.facebook.Session.OpenRequest(FacebookLogin.this);
					request.setPermissions(Arrays.asList("user_about_me",
							"email", "user_birthday", "user_location",
							"user_hometown","user_friends","read_friendlists"));
					request.setLoginBehavior(SessionLoginBehavior.SUPPRESS_SSO);
					request.setCallback(statusCallback);

					com.facebook.Session mFacebookSession = com.facebook.Session.getActiveSession();
					if (mFacebookSession == null || mFacebookSession.isClosed()) {
						mFacebookSession = new com.facebook.Session(FacebookLogin.this);
					}
					mFacebookSession.openForRead(request);
				} catch (Exception e) {
					// TODO: handle exception

				}

			}
		});

		// get active session

	}

	@Override
	protected void onResume() {
		super.onResume();
		com.facebook.AppEventsLogger.activateApp(this, "272047936334195");
		checkPlayServices();
	}

	@Override
	public void onStart() {
		super.onStart();
		try {
			com.facebook.Session.getActiveSession().addCallback(statusCallback);
		} catch (Exception e) {
			// TODO: handle exception
		}

		EasyTracker.getInstance(this).activityStart(this);
	}

	@Override
	public void onStop() {
		super.onStop();
		try {
			com.facebook.Session.getActiveSession().removeCallback(statusCallback);
		} catch (Exception e) {
			// TODO: handle exception
		}

		EasyTracker.getInstance(this).activityStop(this);
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {

		super.onActivityResult(requestCode, resultCode, data);

		// this.facebookConnector.getFacebook().authorizeCallback(requestCode,
		// resultCode, data);
		if (com.facebook.Session.getActiveSession() != null)
			com.facebook.Session.getActiveSession().onActivityResult(this, requestCode,
					resultCode, data);

		com.facebook.Session currentSession = com.facebook.Session.getActiveSession();
		if (currentSession == null || currentSession.getState().isClosed()) {
			com.facebook.Session session = new com.facebook.Session.Builder(FacebookLogin.this).build();
			com.facebook.Session.setActiveSession(session);
			currentSession = session;
		}

		if (currentSession.isOpened()) {
			com.facebook.Session.openActiveSession(this, true, new com.facebook.Session.StatusCallback() {

				@Override
				public void call(final com.facebook.Session session, SessionState state,
						Exception exception) {

					if (session.isOpened()) {

					}
				}
			});
		}
	}

	@Override
	protected void onSaveInstanceState(Bundle outState) {
		super.onSaveInstanceState(outState);
		com.facebook.Session session = com.facebook.Session.getActiveSession();
		com.facebook.Session.saveSession(session, outState);
	}

	private class SessionStatusCallback implements com.facebook.Session.StatusCallback {
		@Override
		public void call(com.facebook.Session session, SessionState state,
				Exception exception) {
			if (session.isOpened()) {

				dialog.setMessage("Loading....please wait ");
				dialog.setCancelable(false);
				dialog.show();

				System.out.println("session is opened");

				new com.facebook.Request(session, "/me/friends", null, HttpMethod.GET,
						new com.facebook.Request.Callback() {

							@Override
							public void onCompleted(Response response) {
								// TODO Auto-generated method stub
								responsefriends = response;
								// System.out.println(response);

								new Login_webservice().execute();

							}
						}).executeAsync();
				token = session.getAccessToken();

				url1 = "https://graph.facebook.com/v2.0/me?fields=id,name,picture.type(large),email,location,gender,birthday,hometown,first_name,last_name&access_token="
						+ token;

				// updateView();

				/* } */
			}
		}
	}

	private class Login_webservice extends AsyncTask<String, Integer, String> {

		String lastname, success_login, firstname, message, guardian_type,
				email, gender, guardiantype;

		InputStream is;
		String result;
		JSONObject jArray = null;
		String picurl;
		String emailID, birthDay, hometown;
		// ProgressDialog dialog = new ProgressDialog(FacebookLogin.this);
		String userlastname, userlocation, userdob, useremail, userphone,
				usergender, userguardiantype, userfreetime;
		boolean check_response = false;

		@Override
		protected void onPreExecute() {
			// Toast.makeText(Login.this,"asynch task",Toast.LENGTH_LONG).show();
			if (check_response) {
				try {
					dialog.setMessage("Loading....please wait ");
					dialog.setCancelable(false);
					dialog.show();
				} catch (Exception e) {
					// TODO: handle exception
				}
			}

		}

		@Override
		public String doInBackground(String... url) {
			// String url_login =
			// "https://graph.facebook.com/v1.0/me?fields=id,name,picture,friends,email&access_token"+token;

			GraphObject go = responsefriends.getGraphObject();
			JSONObject json = null;
			try {
				json = go.getInnerJSONObject();
			} catch (Exception e) {
				// TODO: handle exception
			}

			JSONArray jsonarray = null;
			try {
				if (json != null) {
					jsonarray = json.getJSONArray("data");

					for (int i = 0; i < jsonarray.length(); i++) {
						try {
							JSONObject c = jsonarray.getJSONObject(i);

							if (fb_ids.equals("")) {
								fb_ids = "'" + c.getString("id") + "'";
							} else {
								fb_ids = fb_ids + ",'" + c.getString("id")
										+ "'";
							}

						} catch (JSONException e) {

							e.printStackTrace();
						}catch(Exception e){
							
						}
					}
				}
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}catch(Exception e){
				
			}

			try {
				System.out.println("Asynch task started");
				HttpClient httpclient = new DefaultHttpClient();

				HttpGet httppost = new HttpGet(url1);
				HttpResponse response = httpclient.execute(httppost);
				HttpEntity entity = response.getEntity();
				is = entity.getContent();
			} catch (Exception e) {
				check_response = true;
				Log.e("ERROR", "Error in http connection " + e.toString());
			}
			// convert response to string
			try {
				BufferedReader reader = new BufferedReader(
						new InputStreamReader(is), 8);
				StringBuilder sb = new StringBuilder();
				String line = null;
				while ((line = reader.readLine()) != null) {
					sb.append(line + "\n");
				}
				is.close();
				result = sb.toString();

			} catch (Exception e) {
				Log.e("ERROR", "Error converting result " + e.toString());
			}
			Log.d("is", "is-------" + result);
			JSONObject json1 = null;
			try {
				json1 = new JSONObject(result);
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}catch(Exception e){
				
			}

			try {

				iD = json1.getString("id");

			} catch (JSONException e) {
				
				e.printStackTrace();
			}catch(Exception e){
				
			}

			GlobalVariable.facebook_ID = iD;
			try {
				emailID = json1.getString("email");
			} catch (Exception e) {
				// TODO: handle exception
			}
			try {
				birthDay = json1.getString("birthday");
			} catch (Exception e) {
				// TODO: handle exception
			}
			try {
				firstname = json1.getString("first_name");
			} catch (Exception e) {
				// TODO: handle exception
			}
			try {
				lastname = json1.getString("last_name");
			} catch (Exception e) {
				// TODO: handle exception
			}
			try {
				gender = json1.getString("gender");
			} catch (Exception e) {
				// TODO: handle exception
			}

			try {
				JSONObject jsonOb = json1.getJSONObject("picture");
				JSONObject jsonpicture = jsonOb.getJSONObject("data");

				picurl = jsonpicture.getString("url");
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}catch(Exception e){
				
			}
			try {

				JSONObject home = json1.getJSONObject("hometown");

				hometown = home.getString("name");

			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}catch(Exception e){
				
			}
			try {

				DateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
				Date date_of_birth = null;
				try {
					date_of_birth = sdf.parse(birthDay);
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}catch(Exception e){
					
				}// String reportDate = df.format(today);
					// birthDay=sdf.format(date_of_birth);
				DateFormat destDf = new SimpleDateFormat("yyyy-MM-dd");

				// format the date into another format

				birthDay = destDf.format(date_of_birth);

				System.out.println(iD);
				System.out.println(emailID);
				System.out.println(birthDay);
				System.out.println(firstname);
				System.out.println(lastname);
				System.out.println(picurl);
				System.out.println(hometown);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			DefaultHttpClient httpclient;
			HttpPost httppost;
			try {
				httpclient = new DefaultHttpClient();
				httppost = new HttpPost(
						"http://54.191.67.152/playdate/guardian.php");
			} catch (Exception e) {
				// TODO: handle exception
				System.out.println("Server response error");
				return null;
			}

			if (gender.equalsIgnoreCase("male")) {
				guardiantype = "F";
			}
			if (gender.equalsIgnoreCase("female")) {
				guardiantype = "M";
			}

			ArrayList<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();

			nameValuePairs.add(new BasicNameValuePair("firstname", firstname
					+ " " + lastname));
			nameValuePairs.add(new BasicNameValuePair("lastname", ""));
			nameValuePairs.add(new BasicNameValuePair("email", emailID));
			nameValuePairs.add(new BasicNameValuePair("facebook_id", iD));
			nameValuePairs.add(new BasicNameValuePair("guardian_type",
					guardiantype));
			nameValuePairs.add(new BasicNameValuePair("dob", birthDay));
			nameValuePairs.add(new BasicNameValuePair("location", hometown));
			nameValuePairs
					.add(new BasicNameValuePair("set_fixed_freetime", ""));
			nameValuePairs.add(new BasicNameValuePair("gender", gender));
			nameValuePairs.add(new BasicNameValuePair("phone", ""));
			nameValuePairs.add(new BasicNameValuePair("profile_image", picurl));
			nameValuePairs.add(new BasicNameValuePair("friend_fbid", fb_ids));
			StringBuilder sbb = new StringBuilder();
			sbb.append("http://54.191.67.152/playdate/guardian.php?");
			sbb.append(nameValuePairs.get(0) + "&");
			sbb.append(nameValuePairs.get(1) + "&");
			sbb.append(nameValuePairs.get(2) + "&");
			sbb.append(nameValuePairs.get(3) + "&");
			sbb.append(nameValuePairs.get(4) + "&");
			sbb.append(nameValuePairs.get(5) + "&");
			sbb.append(nameValuePairs.get(6) + "&");
			sbb.append(nameValuePairs.get(7) + "&");
			sbb.append(nameValuePairs.get(8) + "&");
			sbb.append(nameValuePairs.get(9) + "&");
			sbb.append(nameValuePairs.get(10) + "&");
			sbb.append(nameValuePairs.get(11));

			System.out.println("string builder...\n" + sbb);

			try {
				httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));

				System.out.println(httppost);
			} catch (UnsupportedEncodingException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}catch(Exception e){
				
			}

			HttpResponse response = null;
			try {
				response = httpclient.execute(httppost);
			} catch (ClientProtocolException e) {
				check_response = true;
				e.printStackTrace();

			} catch (IOException e) {
				check_response = true;
				e.printStackTrace();
			}catch(Exception e){
				
			}
			if (response != null) {

				HttpEntity entityy = response.getEntity();
				try {
					is = entityy.getContent();
				} catch (IllegalStateException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}catch(Exception e){
					
				}

			}

			if (is != null) {

				StringBuilder sb = new StringBuilder();
				BufferedReader reader = null;
				try {
					reader = new BufferedReader(new InputStreamReader(is,
							"iso-8859-1"), 8);
				} catch (UnsupportedEncodingException e) {

					e.printStackTrace();
				}catch(Exception e){
					
				}

				sb = new StringBuilder();
				try {
					sb.append(reader.readLine() + "\n");
				} catch (IOException e) {

					e.printStackTrace();
				}catch(Exception e){
					
				}

				String line = "0";
				try {
					while ((line = reader.readLine()) != null) {
						sb.append(line + "\n");

					}
				} catch (IOException e) {

					e.printStackTrace();
				}catch(Exception e){
					
				}

				try {
					is.close();
				} catch (IOException e) {

					e.printStackTrace();
				}catch(Exception e){
					
				}
				result = sb.toString();
				Log.e("Resultt==", "" + result);
			}

			try {
				JSONObject userdetail = new JSONObject(result);
				/*
				 * JSONArray ejabberid=userdetail.getJSONArray("ejabber_data");
				 * ejabber_username=ejabberid.getString(0);
				 * ejabber_password=ejabberid.getString(1);
				 * 
				 * System.out.println("ejabber_username"+ejabber_username);
				 * System.out.println("ejabber_password"+ejabber_password);
				 */

				CustomMessageStr = userdetail.getJSONArray("custom_message");
				Log.e("CustomMessageDtr==", "" + CustomMessageStr);

				JSONObject detailReturned = userdetail
						.getJSONObject("userinfo");

				userfirstname = detailReturned.getString("firstname");
				userlastname = detailReturned.getString("lastname");
				userlocation = detailReturned.getString("location");
				userdob = detailReturned.getString("dob");
				useremail = detailReturned.getString("email");
				userphone = detailReturned.getString("phone");
				usergender = detailReturned.getString("gender");
				userguardiantype = detailReturned.getString("guardian_type");
				userfreetime = detailReturned.getString("set_fixed_freetime");
				userprofilepic = detailReturned.getString("profile_image");
				user_guardian_id = detailReturned.getString("g_id");

				JSONArray jarray = userdetail.getJSONArray("data");
				for (int i = 0; i < jarray.length(); i++) {
					JSONObject c = jarray.getJSONObject(i);
					if (fbfriends.equals("")) {
						fbfriends = "'" + c.getString("facebook_id") + "'";
					} else {
						fbfriends = fbfriends + ",'"
								+ c.getString("facebook_id") + "'";
					}

				}

				DateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				Date date_of_birth = null;
				try {
					date_of_birth = sdf.parse(userdob);
				} catch (ParseException e) {

					e.printStackTrace();
				}catch(Exception e){
					
				}
				DateFormat destDf = new SimpleDateFormat("dd/MM/yy");

				// format the date into another format

				date_of_birthparsed = destDf.format(date_of_birth);

				System.out.println(userfirstname);
				System.out.println(userlastname);
				System.out.println(userlocation);
				System.out.println(date_of_birthparsed);
				System.out.println(useremail);
				System.out.println(userphone);
				System.out.println(usergender);
				System.out.println(userguardiantype);
				System.out.println(userfreetime);

				SharedPreferences.Editor editor = settings.edit(); // Opening
																	// editor
																	// for
																	// SharedPreferences
				editor.putString("userfirstname", userfirstname);
				editor.putString("userlocation", userlocation);
				editor.putString("userdob", date_of_birthparsed);
				editor.putString("userphone", userphone);
				editor.putString("usergender", usergender);
				editor.putString("userguardiantype", userguardiantype);
				editor.putString("userfreetime", userfreetime);
				editor.putString("userprofilepic", userprofilepic);
				editor.putString("user_guardian_id", user_guardian_id);
				editor.putString("id", iD);
				editor.putString("fbfriends", fbfriends);
				// editor.putString("checkstring", checkstring)
				check = true;
				editor.putBoolean("check", check);
				editor.commit();

			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}catch(Exception e){
				
			}

			return null;
		}

		public void onPostExecute(String resultt)

		{
			if (check_response) {
				dialog.dismiss();
				if (isInternetPresent) {
					new AlertDialog.Builder(FacebookLogin.this)
							.setTitle("Server Error")
							.setMessage("Would you like to retry?")
							.setPositiveButton("Yes",
									new DialogInterface.OnClickListener() {
										public void onClick(
												DialogInterface dialog,
												int which) {
											new Login_webservice().execute();
										}
									})
							.setNegativeButton("No",
									new DialogInterface.OnClickListener() {
										public void onClick(
												DialogInterface dialog,
												int which) {

											return;
										}
									})
							.setIcon(android.R.drawable.ic_dialog_alert).show();
				} else {
					new AlertDialog.Builder(FacebookLogin.this)
							.setTitle("Network Error")
							.setMessage("Would you like to retry?")
							.setPositiveButton("Yes",
									new DialogInterface.OnClickListener() {
										public void onClick(
												DialogInterface dialog,
												int which) {
											new Login_webservice().execute();
										}
									})
							.setNegativeButton("No",
									new DialogInterface.OnClickListener() {
										public void onClick(
												DialogInterface dialog,
												int which) {

											return;
										}
									})
							.setIcon(android.R.drawable.ic_dialog_alert).show();
				}

			} else {

				if (checkPlayServices()) {
					gcm = GoogleCloudMessaging.getInstance(FacebookLogin.this);
					regid = getRegistrationId(context);

					if (regid.isEmpty()) {
						registerInBackground();
					} else {
						dialog.dismiss();
						System.out.println("Registration Id+" + regid);
						Intent it = new Intent(FacebookLogin.this, Home.class);
						it.putExtra("url", userprofilepic);
						it.putExtra("name", userfirstname);
						it.putExtra("firstname", userfirstname);
						it.putExtra("iD", iD);
						it.putExtra("location", userlocation);
						it.putExtra("dob", date_of_birthparsed);
						it.putExtra("guardiantype", userguardiantype);
						it.putExtra("freetime", userfreetime);
						it.putExtra("user_guardian_id", user_guardian_id);
						it.putExtra("facebook_friends", fbfriends);
						it.putExtra("phone", userphone);
						GlobalVariable.guardian_Id = user_guardian_id;
						GlobalVariable.global_name = userfirstname;
						GlobalVariable.custom_Jsonarray = CustomMessageStr;
						startActivity(it);
						finish();
						// AlertDialog alertDialog = new
						// AlertDialog.Builder(context).create();
						// alertDialog.setTitle("Alert");
						// alertDialog.setMessage(CustomMessageStr);
						// alertDialog.setButton("OK", new
						// DialogInterface.OnClickListener() {
						// public void onClick(DialogInterface dialog, int
						// which) {
						// System.out.println("Registration Id+" + regid);
						// Intent it = new Intent(FacebookLogin.this,
						// Home.class);
						// it.putExtra("url", userprofilepic);
						// it.putExtra("name", userfirstname);
						// it.putExtra("firstname", userfirstname);
						// it.putExtra("iD", iD);
						// it.putExtra("location", userlocation);
						// it.putExtra("dob", date_of_birthparsed);
						// it.putExtra("guardiantype", userguardiantype);
						// it.putExtra("freetime", userfreetime);
						// it.putExtra("user_guardian_id", user_guardian_id);
						// it.putExtra("facebook_friends", fbfriends);
						// it.putExtra("phone", userphone);
						// GlobalVariable.guardian_Id = user_guardian_id;
						// startActivity(it);
						// }
						// });
						// alertDialog.show();

					}
				} else {
					Log.i(TAG, "No valid Google Play Services APK found.");
				}
			}
		}
	}

	/**
	 * Check the device to make sure it has the Google Play Services APK. If it
	 * doesn't, display a dialog that allows users to download the APK from the
	 * Google Play Store or enable it in the device's system settings.
	 */
	private boolean checkPlayServices() {
		int resultCode = GooglePlayServicesUtil
				.isGooglePlayServicesAvailable(this);
		if (resultCode != ConnectionResult.SUCCESS) {
			if (GooglePlayServicesUtil.isUserRecoverableError(resultCode)) {
				GooglePlayServicesUtil.getErrorDialog(resultCode, this,
						PLAY_SERVICES_RESOLUTION_REQUEST).show();
			} else {
				Log.i(TAG, "This device is not supported.");
				finish();
			}
			return false;
		}
		return true;
	}

	private String getRegistrationId(Context context) {
		final SharedPreferences prefs = getGCMPreferences(context);
		String registrationId = prefs.getString(PROPERTY_REG_ID, "");
		if (registrationId.isEmpty()) {
			Log.i(TAG, "Registration not found.");
			return "";
		}
		// Check if app was updated; if so, it must clear the registration ID
		// since the existing regID is not guaranteed to work with the new
		// app version.
		int registeredVersion = prefs.getInt(PROPERTY_APP_VERSION,
				Integer.MIN_VALUE);
		int currentVersion = getAppVersion(context);
		if (registeredVersion != currentVersion) {
			Log.i(TAG, "App version changed.");
			return "";
		}
		return registrationId;
	}

	/**
	 * @return Application's {@code SharedPreferences}.
	 */
	private SharedPreferences getGCMPreferences(Context context) {
		// This sample app persists the registration ID in shared preferences,
		// but
		// how you store the regID in your app is up to you.
		return getSharedPreferences(Splash_screen.class.getSimpleName(),
				Context.MODE_PRIVATE);
	}

	private static int getAppVersion(Context context) {
		try {
			PackageInfo packageInfo = context.getPackageManager()
					.getPackageInfo(context.getPackageName(), 0);
			return packageInfo.versionCode;
		} catch (NameNotFoundException e) {
			// should never happen
			throw new RuntimeException("Could not get package name: " + e);
		}
	}

	private void registerInBackground() {
		new AsyncTask() {
                                                                      
			@Override
			protected Object doInBackground(Object... params) {
				String msg = "";
				try {
					if (gcm == null) {
						gcm = GoogleCloudMessaging.getInstance(context);
					}
					regid = gcm.register(SENDER_ID);
					msg = "Device registered, registration ID=" + regid;
					System.out.println(msg);

					storeRegistrationId(context, regid);

					sendRegistrationIdToBackend();

				} catch (IOException ex) {
					msg = "Error :" + ex.getMessage();

				}
				return msg;
			}
		}.execute(null, null, null);

	}

	private void sendRegistrationIdToBackend() {
		// Your implementation here.
		new Send_registration_id().execute();

	}

	private void storeRegistrationId(Context context, String regId) {
		final SharedPreferences prefs = getGCMPreferences(context);
		int appVersion = getAppVersion(context);
		Log.i(TAG, "Saving regId on app version " + appVersion);
		SharedPreferences.Editor editor = prefs.edit();
		editor.putString(PROPERTY_REG_ID, regId);
		editor.putInt(PROPERTY_APP_VERSION, appVersion);                       
		editor.commit();
	}

	public class Send_registration_id extends
			AsyncTask<String, Integer, String> {

		String url_registration;                                                                                                         

		@Override
		protected void onPreExecute() {

			url_registration = "http://54.191.67.152/playdate/devicetoken.php";
			// url
			// http://54.191.67.152/playdate/devicetoken.php?g_id=100001122279977&device_token=43654262456yuigiuhgihghkjhgjhgjhg12345&type=1
		}

		@Override
		protected String doInBackground(String... params) {
			// TODO Auto-generated method stub
			HttpClient httpClient = new DefaultHttpClient();
			HttpContext localContext = new BasicHttpContext();
			HttpPost httpPost = new HttpPost(url_registration);

			ArrayList<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();
			nameValuePairs.add(new BasicNameValuePair("device_token", regid));
			nameValuePairs
					.add(new BasicNameValuePair("g_id", user_guardian_id));
			nameValuePairs.add(new BasicNameValuePair("type", "1"));

			StringBuilder sbb = new StringBuilder();
			sbb.append("http://54.191.67.152/playdate/devicetoken.php?");
			sbb.append(nameValuePairs.get(0) + "&");
			sbb.append(nameValuePairs.get(1) + "&");
			sbb.append(nameValuePairs.get(2));
			System.out.println(sbb);
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

			try {
				String sresponse = reader.readLine();

				System.out.println("response.................................."
						+ sresponse);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			return null;
		}

		protected void onPostExecute(String resultt) {

			dialog.dismiss();
			Intent it = new Intent(FacebookLogin.this, Home.class);

			it.putExtra("url", userprofilepic);
			it.putExtra("name", userfirstname);
			it.putExtra("firstname", userfirstname);
			it.putExtra("iD", iD);
			it.putExtra("location", userlocation);
			it.putExtra("dob", date_of_birthparsed);
			it.putExtra("guardiantype", userguardiantype);
			it.putExtra("freetime", userfreetime);
			it.putExtra("user_guardian_id", user_guardian_id);
			it.putExtra("facebook_friends", fbfriends);
			it.putExtra("phone", userphone);
			/*
			 * if(CustomMessageStr!=null && CustomMessageStr.length()>0) {
			 * it.putExtra("CustomMessage", CustomMessageStr); }
			 */
			GlobalVariable.guardian_Id = user_guardian_id;
			GlobalVariable.custom_Jsonarray = CustomMessageStr;
			GlobalVariable.global_name = userfirstname;

			startActivity(it);
			finish();

		}
	}

}
