package com.iapptechnologies.time;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.facebook.HttpMethod;
import com.facebook.LoggingBehavior;
import com.facebook.Request;
import com.facebook.Response;
import com.facebook.Session;
import com.facebook.SessionState;
import com.facebook.Settings;
import com.facebook.model.GraphObject;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;

public class MainActivity_login extends Activity {

	String token, url, emailid, fbid, firstname, lastname, url_registration;

	private Session.StatusCallback statusCallback = new SessionStatusCallback();
	Response responseuser, responsefriends;
	String fb_ids = "";
	 Boolean isInternetPresent = false;
	    ConnectionDetector cd;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		  cd = new ConnectionDetector(getApplicationContext());
		 isInternetPresent = cd.isConnectingToInternet();
		 
         
         if (isInternetPresent) {

		Settings.addLoggingBehavior(LoggingBehavior.INCLUDE_ACCESS_TOKENS);

		Session session = Session.getActiveSession();
		if (session == null) {
			if (savedInstanceState != null) {
				session = Session.restoreSession(this, null, statusCallback,
						savedInstanceState);
			}
			if (session == null) {
				session = new Session(this);
			}
			Session.setActiveSession(session);
			if (session.getState().equals(SessionState.CREATED_TOKEN_LOADED)) {

				/*
				 * session.openForRead(new Session.OpenRequest(this)
				 * .setPermissions(Arrays.asList("email")).setCallback(
				 * statusCallback));
				 */
				
				/*  session.openForRead(new
				  Session.OpenRequest(this).setPermissions( Arrays.asList("id",
				  "email", "firstname", "lastname","friends"))
				  .setCallback(statusCallback));*/
				 
				session.openForRead(new Session.OpenRequest(this)
						.setCallback(statusCallback));
			}
		}

		// onClickLogout();
		onClickLogin();
		updateView();
	}else{
		  showAlertDialog(MainActivity_login.this, "No Internet Connection",
                  "You don't have internet connection.", false);
          return;
	}
	}
	public void showAlertDialog(Context context, String title, String message, Boolean status) {
        AlertDialog alertDialog = new AlertDialog.Builder(context).create();
 
       
        alertDialog.setTitle(title);
 
        
        alertDialog.setMessage(message);
       
        alertDialog.setButton("OK", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
            }
        });
 
       
        alertDialog.show();
    }
	private void onClickLogin() {
		Session session = Session.getActiveSession();
		if (!session.isOpened() && !session.isClosed()) {

			
			 /* session.openForRead(new Session.OpenRequest(this).setPermissions(
			  Arrays.asList("id", "email", "firstname", "lastname","friends"))
			  .setCallback(statusCallback));*/
			 

			session.openForRead(new Session.OpenRequest(this)
					.setCallback(statusCallback));
		} else {
			Session.openActiveSession(this, true, statusCallback);

		}
	}

	private void updateView() {
		final Session session = Session.getActiveSession();
		if (session.isOpened()) {
			Log.d("", "Logged out...fkghfkjgh play dateeee");

			token = session.getAccessToken();
			System.out.println(token);

			new Request(session, "/me", null, HttpMethod.GET,
					new Request.Callback() {

						@Override
						public void onCompleted(Response response) {
							// TODO Auto-generated method stub
							System.out.println("chbvmjbh,k");
							GraphObject go = response.getGraphObject();
							System.out.println("response" + response);
							try {
								JSONObject json = go.getInnerJSONObject();
								fbid = json.getString("id");
								firstname = json.getString("first_name");
								emailid = json.getString("email");
								lastname = json.getString("last_name");
								System.out.println(fbid);
								System.out.println(firstname);
								System.out.println(emailid);
								System.out.println(lastname);

							} catch (JSONException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}

							new Request(session, "/me/friends", null,
									HttpMethod.GET, new Request.Callback() {

										@Override
										public void onCompleted(
												Response response) {
											// TODO Auto-generated method stub

											responsefriends = response;
											new GetemailandFBId().execute();
										}
									}).executeAsync();
						}
					}).executeAsync();

		}
		// handle the result

		/*
		 * new Request(session, "/me", null, HttpMethod.GET, new
		 * Request.Callback() { public void onCompleted(Response response) { //
		 * handle the result
		 * 
		 * responseuser = response; GraphObject go = response.getGraphObject();
		 * JSONObject json = go.getInnerJSONObject();
		 * 
		 * try { fbid = json.getString("id"); firstname =
		 * json.getString("first_name"); emailid = json.getString("email");
		 * lastname = json.getString("last_name"); System.out.println(fbid);
		 * System.out.println(firstname); System.out.println(emailid);
		 * System.out.println(lastname);
		 * 
		 * } catch (JSONException e) { // TODO Auto-generated catch block
		 * e.printStackTrace(); }
		 * 
		 * // JSONObject json= new JSONObject(response);
		 * 
		 * System.out .println("response-----------" + response); new
		 * Request(session, "/me/friends", null, HttpMethod.GET, new
		 * Request.Callback() { public void onCompleted(Response response) { //
		 * handle the result responsefriends = response; new
		 * GetemailandFBId().execute();
		 * 
		 * } }).executeAsync(); } }).executeAsync();
		 */

		// // make the API call
		System.out.println("session--------" + session);

	}

	// for logout
	/*
	 * private void onClickLogout() { Session session =
	 * Session.getActiveSession(); if (!session.isClosed()) {
	 * session.closeAndClearTokenInformation(); } }
	 */

	class GetemailandFBId extends AsyncTask<Context, Void, Void> {
		ProgressDialog dialog = new ProgressDialog(MainActivity_login.this);
		InputStream is;
		String result, success_login, message;
		JSONObject jArray = null;
		HttpClient httpclient;
		HttpPost httppost;

		protected void onPreExecute() {
			dialog.setMessage("Loading.......please wait");
			dialog.setCancelable(false);
			dialog.show();
			url = "http://112.196.34.179/playdate/guardian.php";

		}

		@Override
		protected Void doInBackground(Context... arg0) {
			// TODO Auto-generated method stub

			System.out.println("asynch task running.....................");

			// String
			// urlwebservice="http://112.196.34.179/playdate/guardian.php?token=&firstname=demo&lastname=test&email=hhsdfsdfsjf@gmail.com&facebook_id=1&password=123&guardian_type=m";

			GraphObject go = responsefriends.getGraphObject();
			JSONObject json = go.getInnerJSONObject();
			JSONArray jsonarray = null;
			try {
				jsonarray = json.getJSONArray("data");
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}

			for (int i = 0; i < jsonarray.length(); i++) {
				try {
					JSONObject c = jsonarray.getJSONObject(i);

					if (fb_ids.equals("")) {
						fb_ids = "'" + c.getString("id") + "'";
					} else {
						fb_ids = fb_ids + ",'" + c.getString("id") + "'";
					}

				} catch (JSONException e) {

					e.printStackTrace();
				}
			}
			System.out.println(fb_ids);
try {
	 httpclient = new DefaultHttpClient();
	 httppost = new HttpPost(
			"http://112.196.34.179/playdate/guardian.php");
} catch (Exception e) {
	// TODO: handle exception
	System.out.println("Server response error");
	return null;
}
			
			// http://112.196.34.179/playdate/guardian.php?token=&firstname=dfh&lastname=hdf&email=vakul13@gmail.com&facebook_id=64&password=12345&guardian_type=m&friend_fbid=%272%27,%273%27
			// url="http://112.196.34.179/playdate/guardian.phptoken=&firstname="+firstname+"&lastname="+lastname+"&email="+emailid+"&facebook_id=1&password=123&guardian_type=m";

			ArrayList<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();
			nameValuePairs.add(new BasicNameValuePair("token", ""));
			nameValuePairs.add(new BasicNameValuePair("firstname", firstname));
			nameValuePairs.add(new BasicNameValuePair("lastname", lastname));
			nameValuePairs.add(new BasicNameValuePair("email", emailid));
			nameValuePairs.add(new BasicNameValuePair("facebook_id", fbid));
			nameValuePairs.add(new BasicNameValuePair("password", "1234"));
			nameValuePairs.add(new BasicNameValuePair("guardian_type", "M"));
			nameValuePairs.add(new BasicNameValuePair("friend_fbid", fb_ids));
			Log.d("nameValuePairs", "nameValuePairs" + nameValuePairs);
			Log.d("nameValuePairs", "nameValuePairs" + nameValuePairs);
			Log.d("nameValuePairs", "nameValuePairs" + nameValuePairs);

			StringBuilder sbb = new StringBuilder();

			sbb.append("http://112.196.34.179/playdate/guardian.php?");
			sbb.append(nameValuePairs.get(0) + "&");
			sbb.append(nameValuePairs.get(1) + "&");
			sbb.append(nameValuePairs.get(2) + "&");
			sbb.append(nameValuePairs.get(3) + "&");
			sbb.append(nameValuePairs.get(4) + "&");
			sbb.append(nameValuePairs.get(5) + "&");
			sbb.append(nameValuePairs.get(6) + "&");
			sbb.append(nameValuePairs.get(7));

			System.out.println("string builder...\n" + sbb);

			try {
				httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));

				System.out.println(httppost);
			} catch (UnsupportedEncodingException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}

			HttpResponse response = null;
			try {
				response = httpclient.execute(httppost);
			} catch (ClientProtocolException e) {

				System.out.println("response catch block");
				e.printStackTrace();
			} catch (IOException e) {

				e.printStackTrace();
			}
			if (response != null) {

				HttpEntity entityy = response.getEntity();
				try {
					is = entityy.getContent();
				} catch (IllegalStateException e) {

					System.out.println("is catch block");
					e.printStackTrace();
				} catch (IOException e) {

					e.printStackTrace();
					System.out.println("is catch block");
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
				}

				System.out.println("66666666666666");

				sb = new StringBuilder();
				try {
					sb.append(reader.readLine() + "\n");
				} catch (IOException e) {

					e.printStackTrace();
					System.out.println("sb catch block");
				}

				System.out.println("77777777777");
				String line = "0";
				try {
					while ((line = reader.readLine()) != null) {
						sb.append(line + "\n");

					}
				} catch (IOException e) {

					e.printStackTrace();
					System.out.println("reader.read line catch block");
				}

				try {
					is.close();
				} catch (IOException e) {

					e.printStackTrace();
					System.out.println("is close catch block");
				}
				System.out.println("88888888888888");
				System.out.println(sb);
				result = sb.toString();
			}
			System.out.println(result);

			// Getting JSON Array node
			JSONArray data = null;
			try {
				JSONObject jsonObj = new JSONObject(result);
				data = jsonObj.getJSONArray("data");
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			// looping through All Contacts
			for (int i = 0; i < data.length(); i++) {
				try {
					JSONObject c = data.getJSONObject(i);
					String first_name = c.getString("firstname");
					String last_name = c.getString("lastname");
					String facebook_friend_id = c.getString("facebook_id");
					String email_id = c.getString("email");
					String guardiantype = c.getString("guardian_type");
					System.out.println(first_name + last_name
							+ facebook_friend_id + email_id + guardiantype);
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

			}

			/*
			 * JSONParser jParser=new JSONParser(); JSONObject jsonme=
			 * jParser.getJSONFromUrl(url); // JSONObject json= new
			 * JSONObject(responseuser); try { JSONArray
			 * jarray=json.getJSONArray("data"); } catch (JSONException e1) { //
			 * TODO Auto-generated catch block e1.printStackTrace(); }
			 * System.out.println(jsonme);
			 * 
			 * try {
			 * 
			 * 
			 * //emailid=jsonme.getString("email"); fbid=jsonme.getString("id");
			 * firstname=jsonme.getString("first_name");
			 * lastname=jsonme.getString("last_name");
			 * //System.out.println(emailid); System.out.println(fbid);
			 * System.out.println(firstname); System.out.println(lastname);
			 * 
			 * 
			 * 
			 * 
			 * } catch (JSONException e) { // TODO Auto-generated catch block
			 * e.printStackTrace(); }
			 */

			/*
			 * String serverurl=
			 * "http://112.196.34.179/playdate/guardian.php?token=&firstname="
			 * +firstname
			 * +"&lastname="+lastname+"&email="+emailid+"&facebook_id="
			 * +fbid+"&password=12345&guardian_type="; try{ HttpClient
			 * httpclient = new DefaultHttpClient(); HttpGet httppost = new
			 * HttpGet(url_registration); HttpResponse response =
			 * httpclient.execute(httppost); HttpEntity entity =
			 * response.getEntity(); is = entity.getContent(); } catch
			 * (Exception e) { Log.e("ERROR", "Error in http connection " +
			 * e.toString()); }
			 * 
			 * try { BufferedReader reader = new BufferedReader( new
			 * InputStreamReader(is), 8); StringBuilder sb = new
			 * StringBuilder(); String line = null; while ((line =
			 * reader.readLine()) != null) { sb.append(line + "\n"); }
			 * is.close(); result = sb.toString();
			 * 
			 * } catch (Exception e) { Log.e("ERROR", "Error converting result "
			 * + e.toString()); } Log.d("is","is-------"+result);
			 * 
			 * 
			 * try { jArray = new JSONObject(result); JSONObject data =
			 * jArray.getJSONObject("data");
			 * 
			 * if(data.has("firstname")){ String
			 * firstname_returned=data.getString("firstname");
			 * Log.d("is","firstname-------"+firstname_returned); String
			 * lastname_returned=data.getString("lastname");
			 * Log.d("is","lastname-------"+lastname_returned); String
			 * email_returned=data.getString("email");
			 * Log.d("is","email-------"+email_returned); String
			 * guardian_type_returned=data.getString("guardian_type");
			 * Log.d("is","guardian_type-------"+guardian_type_returned);
			 * success_login=data.getString("success");
			 * Log.d("is","success_login-------"+success_login);
			 * message=jArray.getString("msg");
			 * Log.d("is","message-------"+message); } else{
			 * success_login=data.getString("success");
			 * Log.d("is","success_login-------"+success_login);
			 * message=jArray.getString("msg");
			 * Log.d("is","message-------"+message); }
			 * 
			 * } catch (JSONException e) { // TODO: handle exception }
			 */

			return null;
		}

		protected void onPostExecute(Void result) {
			super.onPostExecute(result);

			dialog.dismiss();
			Intent it = new Intent(MainActivity_login.this, Home.class);
			startActivity(it);
			/*
			 * if (success_login.equals("1")) { Intent it=new
			 * Intent(MainActivity_login.this,Home.class); startActivity(it); //
			 * new GetFBfriendId().execute();
			 * 
			 * } else if (success_login.equals("0")) { AlertDialog.Builder
			 * builder = new AlertDialog.Builder( MainActivity_login.this);
			 * 
			 * builder.setTitle("Invalid Entry"); builder.setMessage(message)
			 * .setCancelable(false) .setPositiveButton("OK", new
			 * DialogInterface.OnClickListener() { public void
			 * onClick(DialogInterface dialog, int id) { dialog.cancel();
			 * 
			 * }
			 * 
			 * });
			 * 
			 * AlertDialog alert = builder.create(); alert.show(); return; }
			 */

			/* new Registration().execute(); */

		}
	}

	/*
	 * class Registration extends AsyncTask<Context, Void, Void> {
	 * 
	 * ProgressDialog dialog = new ProgressDialog(MainActivity_login.this);
	 * InputStream is; String result, success_login, message; JSONObject jArray
	 * = null;
	 * 
	 * protected void onPreExecute() {
	 * dialog.setMessage("Registring on Playdate....");
	 * dialog.setCancelable(false); dialog.show(); //
	 * url="https://graph.facebook.com//v2.0/me?access_token="+ token;
	 * url_registration =
	 * "http://112.196.34.179/playdate/guardian.php?token=&firstname=" +
	 * firstname + "&lastname=" + lastname + "&email=" + emailid +
	 * "&facebook_id=" + fbid + "&password=&guardian_type=" + "" + "post=" +
	 * nameValuePairs;
	 * 
	 * }
	 * 
	 * @Override protected Void doInBackground(Context... params) { try {
	 * HttpClient httpclient = new DefaultHttpClient(); HttpGet httppost = new
	 * HttpGet(url_registration); HttpResponse response =
	 * httpclient.execute(httppost); HttpEntity entity = response.getEntity();
	 * is = entity.getContent(); } catch (Exception e) { Log.e("ERROR",
	 * "Error in http connection " + e.toString()); } // convert response to
	 * string try { BufferedReader reader = new BufferedReader( new
	 * InputStreamReader(is), 8); StringBuilder sb = new StringBuilder(); String
	 * line = null; while ((line = reader.readLine()) != null) { sb.append(line
	 * + "\n"); } is.close(); result = sb.toString();
	 * 
	 * } catch (Exception e) { Log.e("ERROR", "Error converting result " +
	 * e.toString()); } Log.d("is", "is-------" + result);
	 * 
	 * try { jArray = new JSONObject(result); JSONObject data =
	 * jArray.getJSONObject("data");
	 * 
	 * if (data.has("firstname")) { String firstname_returned =
	 * data.getString("firstname"); Log.d("is", "firstname-------" +
	 * firstname_returned); String lastname_returned =
	 * data.getString("lastname"); Log.d("is", "lastname-------" +
	 * lastname_returned); String email_returned = data.getString("email");
	 * Log.d("is", "email-------" + email_returned); String
	 * guardian_type_returned = data .getString("guardian_type"); Log.d("is",
	 * "guardian_type-------" + guardian_type_returned); success_login =
	 * data.getString("success"); Log.d("is", "success_login-------" +
	 * success_login); message = jArray.getString("msg"); Log.d("is",
	 * "message-------" + message); } else { success_login =
	 * data.getString("success"); Log.d("is", "success_login-------" +
	 * success_login); message = jArray.getString("msg"); Log.d("is",
	 * "message-------" + message); }
	 * 
	 * } catch (JSONException e) { // TODO: handle exception }
	 * 
	 * return null; }
	 * 
	 * public void onPostExecute(String resultt)
	 * 
	 * { if (success_login.equals("1")) {
	 * 
	 * new GetFBfriendId().execute();
	 * 
	 * } else if (success_login.equals("0")) { AlertDialog.Builder builder = new
	 * AlertDialog.Builder( MainActivity_login.this);
	 * 
	 * builder.setTitle("Invalid Entry"); builder.setMessage(message)
	 * .setCancelable(false) .setPositiveButton("OK", new
	 * DialogInterface.OnClickListener() { public void onClick(DialogInterface
	 * dialog, int id) { dialog.cancel();
	 * 
	 * }
	 * 
	 * });
	 * 
	 * AlertDialog alert = builder.create(); alert.show(); return; } }
	 * 
	 * }
	 */

	/*
	 * class GetFBfriendId extends AsyncTask<Context, Void, Void> {
	 * 
	 * ProgressDialog dialog = new ProgressDialog(MainActivity_login.this);
	 * 
	 * protected void onPreExecute() {
	 * dialog.setMessage("Fetching Facebook friend details....");
	 * dialog.setCancelable(false); dialog.show(); url =
	 * "https://graph.facebook.com//v2.0/me?access_token=" + token; }
	 * 
	 * @Override protected Void doInBackground(Context... params) { // TODO
	 * Auto-generated method stub
	 * 
	 * 
	 * nameValuePairs.add(new BasicNameValuePair("colours[0]","red"));
	 * nameValuePairs.add(new BasicNameValuePair("colours[1]","white"));
	 * nameValuePairs.add(new BasicNameValuePair("colours[2]","black"));
	 * nameValuePairs.add(new BasicNameValuePair("colours[3]","brown"));
	 * 
	 * 
	 * return null; }
	 * 
	 * }
	 * 
	 * // // protected Void doInBackground(Context... params) { // parentItems =
	 * new ArrayList<Getcategory>(); // Getcategory getcategory = new
	 * Getcategory(); // // Creating JSON Parser insta // JSONParser jParser =
	 * new JSONParser(); // // // getting JSON string from URL // JSONObject
	 * json = jParser.getJSONFromUrl(url); // try { // Log.d("", "json" + json);
	 * // // email_returnfromfacebook= json.getString("email"); // String
	 * id=json.getString("id"); //
	 * System.out.println("emailllllllllllllll"+email_returnfromfacebook); //
	 * System.out.println(id); // // /*getcategory.facebook_id =
	 * json.getString("id"); // getcategory.facebook_nic_name =
	 * json.getString("name"); // Log.d("", "getcategory.facebook_id" +
	 * getcategory.facebook_id); // Log.d("",
	 * "getcategory.getcategory.facebook_nic_name" // +
	 * getcategory.facebook_nic_name);
	 */
	// // JSONArray jsonarray = null;
	// // try {
	// // jsonarray = json.getJSONArray("posts");
	// // } catch (JSONException e1) {
	// // // TODO Auto-generated catch block
	// // e1.printStackTrace();
	// // }
	// // Log.d("", "jsonarray" + jsonarray);
	// //
	// //
	// // // looping through All Contacts
	// // for (int i = 0; i < jsonarray.length(); i++) {
	// // getcategory = new Getcategory();
	// // JSONObject c = jsonarray.getJSONObject(i);
	// // getcategory.event_title = c.getString("title");
	// // getcategory.event_date = c.getString("date");
	// // getcategory.event_thumnail = c.getString("thumbnail");
	// // getcategory.event_content = c.getString("content");
	// // Log.d("", "getcategory.event_thumnail"
	// // + getcategory.event_thumnail);
	// // Log.d("", "getcategory.event_content"
	// // + getcategory.event_content);
	// // Log.d("", "getcategory.event_content"
	// // + getcategory.event_content);
	// //
	// // Log.d("", "getcategory.event_title"
	// // + getcategory.event_title);
	// // JSONObject second = c.optJSONObject("thumbnail_images");
	// // JSONObject thrid = second.getJSONObject("large");
	// // getcategory.event_fullimage = thrid.getString("url");
	// // // getcategory.event_fullimage = c.getString("id");
	// // Log.d("", "getcategory.event_fullimage"
	// // + getcategory.event_fullimage);
	// // Log.d("", "getcategory.event_fullimage"
	// // + getcategory.event_fullimage);
	// // Log.d("", "getcategory.event_fullimage"
	// // + getcategory.event_fullimage);
	//
	// // parentItems.add(getcategory);
	//
	// // parentItems.add(getcategory);
	// // }
	//
	// } catch (JSONException e) {
	// e.printStackTrace();
	// }
	//
	// return null;
	// }
	//
	// protected void onPostExecute(Void result) {
	// super.onPostExecute(result);
	// dialog.dismiss();
	// if(email_entered.equals(email_returnfromfacebook)){
	// Toast.makeText(UserRegistration.this, "email matched",2000).show();
	// //web service create for uploading fbid
	//
	// }
	// else{
	// AlertDialog.Builder builder = new AlertDialog.Builder(
	// UserRegistration.this);
	//
	// builder.setTitle("Invalid Entry");
	// builder.setMessage("Email registered with Play Date is different from Facebook email ID ")
	// .setCancelable(false)
	// .setPositiveButton("OK",
	// new DialogInterface.OnClickListener() {
	// public void onClick(DialogInterface dialog,
	// int id) {
	//
	// dialog.cancel();
	//
	// }
	//
	// });
	//
	// AlertDialog alert = builder.create();
	// alert.show();
	// return;
	// }
	//
	// // adapter = new LazyAdapter(Tournaments.this, parentItems);
	//
	// // listView1.setAdapter(adapter);
	// // dialog.dismiss();
	//
	// }
	// }
	//

	@Override
	public void onStart() {
		super.onStart();
		Session.getActiveSession().addCallback(statusCallback);
	}

	@Override
	public void onStop() {
		super.onStop();
		Session.getActiveSession().removeCallback(statusCallback);
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		/*
		 * super.onActivityResult(requestCode, resultCode, data);
		 * Session.getActiveSession().onActivityResult(this, requestCode,
		 * resultCode, data);
		 */
		super.onActivityResult(requestCode, resultCode, data);
		if (Session.getActiveSession() != null)
			Session.getActiveSession().onActivityResult(this, requestCode,
					resultCode, data);

		Session currentSession = Session.getActiveSession();
		if (currentSession == null || currentSession.getState().isClosed()) {
			Session session = new Session.Builder(MainActivity_login.this)
					.build();
			Session.setActiveSession(session);
			currentSession = session;
		}
	}

	@Override
	protected void onSaveInstanceState(Bundle outState) {
		super.onSaveInstanceState(outState);
		Session session = Session.getActiveSession();
		Session.saveSession(session, outState);
	}

	private class SessionStatusCallback implements Session.StatusCallback {
		@Override
		public void call(Session session, SessionState state,
				Exception exception) {
			// updateView();
		}
	}

}

/*
 * 
 * @Override protected void onCreate(Bundle savedInstanceState) {
 * super.onCreate(savedInstanceState); setContentView(R.layout.activity_main);
 * 
 * mLogin = (Button) findViewById(R.id.logIn); mLogin.setOnClickListener(this);
 * }
 * 
 * @Override public void onClick(View v) { Session currentSession =
 * Session.getActiveSession(); if (currentSession == null ||
 * currentSession.getState().isClosed()) { Session session = new
 * Session.Builder(context).build(); Session.setActiveSession(session);
 * currentSession = session; }
 * 
 * if (currentSession.isOpened()) { // Do whatever you want. The user is logged
 * in.
 * 
 * } else if (!currentSession.isOpened()) { // Ask for username and password
 * OpenRequest op = new Session.OpenRequest((Activity) context);
 * 
 * op.setLoginBehavior(SessionLoginBehavior.SUPPRESS_SSO); op.setCallback(null);
 * 
 * List<String> permissions = new ArrayList<String>();
 * permissions.add("publish_stream"); permissions.add("user_likes");
 * permissions.add("email"); permissions.add("user_birthday");
 * op.setPermissions(permissions);
 * 
 * Session session = new Builder(MainActivity.this).build();
 * Session.setActiveSession(session); session.openForPublish(op); } }
 * 
 * public void call(Session session, SessionState state, Exception exception) {
 * 
 * }
 * 
 * @Override public void onActivityResult(int requestCode, int resultCode,
 * Intent data) { super.onActivityResult(requestCode, resultCode, data); if
 * (Session.getActiveSession() != null)
 * Session.getActiveSession().onActivityResult(this, requestCode, resultCode,
 * data);
 * 
 * Session currentSession = Session.getActiveSession(); if (currentSession ==
 * null || currentSession.getState().isClosed()) { Session session = new
 * Session.Builder(context).build(); Session.setActiveSession(session);
 * currentSession = session; }
 * 
 * if (currentSession.isOpened()) { Session.openActiveSession(this, true, new
 * Session.StatusCallback() {
 * 
 * @Override public void call(final Session session, SessionState state,
 * Exception exception) {
 * 
 * if (session.isOpened()) { Request.executeMeRequestAsync( session, new
 * Request.GraphUserCallback() {
 * 
 * @Override public void onCompleted(GraphUser user, Response response) { if
 * (user != null) { TextView welcome = (TextView) findViewById(R.id.welcome);
 * welcome.setText("Hello " + user.getName() + "!");
 * 
 * access_token = session .getAccessToken(); firstName = user.getFirstName();
 * fb_user_id = user.getId();
 * 
 * System.out .println("Facebook Access token: " + access_token);
 * System.out.println("First Name:" + firstName);
 * System.out.println("FB USER ID: " + fb_user_id); } } }); } } }); } }
 */