package com.iapptechnologies.time;
//package com.iapp.playdate;
//
//import java.io.BufferedReader;
//import java.io.InputStream;
//import java.io.InputStreamReader;
//import java.net.URLEncoder;
//import java.util.ArrayList;
//import java.util.regex.Matcher;
//import java.util.regex.Pattern;
//
//import org.apache.http.HttpEntity;
//import org.apache.http.HttpResponse;
//import org.apache.http.client.HttpClient;
//import org.apache.http.client.methods.HttpGet;
//import org.apache.http.impl.client.DefaultHttpClient;
//import org.json.JSONException;
//import org.json.JSONObject;
//
//import com.facebook.DialogError;
//import com.facebook.Facebook;
//import com.facebook.Facebook.DialogListener;
//import com.facebook.FacebookError;
//import com.facebook.SessionStore;
//
//import android.app.Activity;
//import android.app.AlertDialog;
//import android.app.ProgressDialog;
//import android.content.Context;
//import android.content.DialogInterface;
//import android.content.SharedPreferences;
//import android.graphics.Point;
//import android.graphics.drawable.BitmapDrawable;
//import android.os.AsyncTask;
//import android.os.Bundle;
//import android.os.Handler;
//import android.os.Message;
//import android.util.Log;
//import android.view.Gravity;
//import android.view.LayoutInflater;
//import android.view.View;
//import android.view.View.OnClickListener;
//import android.widget.Button;
//import android.widget.EditText;
//import android.widget.LinearLayout;
//import android.widget.PopupWindow;
//import android.widget.RelativeLayout;
//import android.widget.Spinner;
//import android.widget.Toast;
//
//
//
//public class UserRegistration extends Activity {
//
//	EditText edit_firstname, edit_lastname, edit_email, edit_password,
//			edit_confirmpassword, edit_spinner;
//	Button btn_registration;
//	String email_returnfromfacebook,email_entered,friendsemail_returned;
//	Spinner spinner;
//	String first_name, last_name, e_mail, pass_word, confirm_password,
//			guardian_type = "", url_registration;
//	Point p;
//	static boolean isValid = false;
//	Boolean isInternetPresent = false;
//	 private SharedPreferences mPrefs;
//	
//	    
//	ConnectionDetector cd;
//	ArrayList<String>email_friend_list= new ArrayList<String>();
//	ArrayList<Getcategory> parentItems = new ArrayList<Getcategory>();
//	// ....................facebook..............//
//	 private Facebook mFacebook;
//	//com.facebook.Session session;
//	private ProgressDialog mProgress;
//	private Thread mUpdateThread = null;
//	private static final String[] PERMISSIONS = new String[] {
//			"publish_stream", "read_stream", "offline_access" };
//	String token;
//	private static final String APP_ID = "260033690850561";
//
//	@Override
//	protected void onCreate(Bundle savedInstanceState) {
//		// TODO Auto-generated method stub
//		super.onCreate(savedInstanceState);
//		setContentView(R.layout.registration);
//		mFacebook = new Facebook(APP_ID);
//
//		cd = new ConnectionDetector(getApplicationContext());
//		btn_registration = (Button) findViewById(R.id.button_user_registration);
//		edit_firstname = (EditText) findViewById(R.id.edit_firstname);
//		edit_lastname = (EditText) findViewById(R.id.edit_lastname);
//		edit_email = (EditText) findViewById(R.id.edit_email);
//		edit_password = (EditText) findViewById(R.id.edit_password);
//		edit_confirmpassword = (EditText) findViewById(R.id.edit_confirmpassword);
//		edit_spinner = (EditText) findViewById(R.id.textView1_spinner);
//		edit_spinner.setFocusable(false);
//		edit_spinner.setClickable(true);
//
//		edit_spinner.setOnClickListener(new OnClickListener() {
//
//			@Override
//			public void onClick(View v) {
//				// showing popup for selecting guardian type
//				if (p != null)
//					showPopup(UserRegistration.this, p);
//
//			}
//		});
//
//		btn_registration.setOnClickListener(new OnClickListener() {
//
//			@Override
//			public void onClick(View v) {
//				// TODO Auto-generated method stub
//
//				isInternetPresent = cd.isConnectingToInternet();
//
//				if (isInternetPresent) {
//					String firstname = edit_firstname.getText().toString();
//					String lastname = edit_lastname.getText().toString();
//					 email_entered = edit_email.getText().toString();
//					String password = edit_password.getText().toString();
//					String confirm_password = edit_confirmpassword.getText()
//							.toString();
//
//					if (edit_firstname.getText().toString().length() > 0
//							&& edit_lastname.getText().toString().length() > 0
//							&& edit_email.getText().toString().length() > 0
//							&& edit_password.getText().toString().length() > 0
//							&& edit_confirmpassword.getText().toString()
//									.length() > 0) {
//
//						try {
//							System.out.println("firstname"
//									+ edit_firstname.getText().toString());
//							// first_name =
//							// URLEncoder.encode(edit_firstname.getText().toString(),"URL-8");
//							first_name = URLEncoder.encode(firstname, "utf-8");
//
//						} catch (Exception e) {
//							// TODO: handle exception
//						}
//						try {
//							last_name = URLEncoder.encode(lastname, "utf-8");
//							System.out.println("firstname" + last_name);
//
//						} catch (Exception e) {
//							// TODO: handle exception
//						}
//						try {
//							e_mail = URLEncoder.encode(email_entered, "utf-8");
//						} catch (Exception e) {
//							// TODO: handle exception
//						}
//						try {
//							pass_word = URLEncoder.encode(password, "utf-8");
//						} catch (Exception e) {
//							// TODO: handle exception
//						}
//						try {
//							confirm_password = URLEncoder.encode(
//									confirm_password, "utf-8");
//						} catch (Exception e) {
//							// TODO: handle exception
//						}
//
//						if (guardian_type.equals("")) {
//							AlertDialog.Builder builder = new AlertDialog.Builder(
//									UserRegistration.this);
//
//							builder.setTitle("Select Guardian Type");
//							builder.setMessage("Please Select Guardian type")
//									.setCancelable(false)
//									.setPositiveButton(
//											"OK",
//											new DialogInterface.OnClickListener() {
//												public void onClick(
//														DialogInterface dialog,
//														int id) {
//													// edit_email.setText("");
//
//													dialog.cancel();
//
//												}
//
//											});
//
//							AlertDialog alert = builder.create();
//							alert.show();
//							return;
//						} else {
//
//						}
//
//						isEmailValid(edit_email.getText().toString());
//						if (isValid == true) {
//
//						} else {
//							AlertDialog.Builder builder = new AlertDialog.Builder(
//									UserRegistration.this);
//
//							builder.setTitle("Invalid Entry");
//							builder.setMessage("Please check email validation")
//									.setCancelable(false)
//									.setPositiveButton(
//											"OK",
//											new DialogInterface.OnClickListener() {
//												public void onClick(
//														DialogInterface dialog,
//														int id) {
//													edit_email.setText("");
//
//													dialog.cancel();
//
//												}
//
//											});
//
//							AlertDialog alert = builder.create();
//							alert.show();
//							return;
//						}
//
//						if (edit_password
//								.getText()
//								.toString()
//								.equals(edit_confirmpassword.getText()
//										.toString())) {
//							Toast.makeText(UserRegistration.this,
//									"Registration successful", 500).show();
//							System.out.println("firstname" + first_name);
//							url_registration = "http://112.196.34.179/playdate/guardian.php?token=&firstname="
//									+ first_name
//									+ "&lastname="
//									+ last_name
//									+ "&email="
//									+ e_mail
//									+ "&password="
//									+ pass_word
//									+ "&guardian_type="
//									+ guardian_type;
//							Login_webservice loginwebservice = new Login_webservice();
//							loginwebservice
//									.execute(new String[] { url_registration });
//							System.out
//									.println("url_registrationurl_registrationurl_registration"
//											+ url_registration);
//							System.out.println("firstname" + first_name);
//
//						} else {
//
//							AlertDialog.Builder builder = new AlertDialog.Builder(
//									UserRegistration.this);
//
//							builder.setTitle("Invalid Entry");
//							builder.setMessage(
//									"Password and Confirm Password are not same")
//									.setCancelable(false)
//									.setPositiveButton(
//											"OK",
//											new DialogInterface.OnClickListener() {
//												public void onClick(
//														DialogInterface dialog,
//														int id) {
//													edit_confirmpassword
//															.setText("");
//
//													dialog.cancel();
//
//												}
//											});
//
//							AlertDialog alert = builder.create();
//							alert.show();
//							return;
//
//						}
//					} else {
//						AlertDialog.Builder builder = new AlertDialog.Builder(
//								UserRegistration.this);
//
//						builder.setTitle("Invalid Entry");
//						builder.setMessage("No field will left blank")
//								.setCancelable(false)
//								.setPositiveButton("OK",
//										new DialogInterface.OnClickListener() {
//											public void onClick(
//													DialogInterface dialog,
//													int id) {
//												edit_confirmpassword
//														.setText("");
//
//												dialog.cancel();
//												return;
//											}
//										});
//
//						AlertDialog alert = builder.create();
//						alert.show();
//
//					}
//				}
//
//				else {
//
//					showAlertDialog(UserRegistration.this,
//							"No Internet Connection",
//							"You don't have internet connection.", false);
//					return;
//
//				}
//			}
//		});
//	}
//
//	public void showAlertDialog(Context context, String title, String message,
//			Boolean status) {
//		AlertDialog alertDialog = new AlertDialog.Builder(context).create();
//
//		alertDialog.setTitle(title);
//
//		alertDialog.setMessage(message);
//
//		alertDialog.setButton("OK", new DialogInterface.OnClickListener() {
//			public void onClick(DialogInterface dialog, int which) {
//			}
//		});
//
//		alertDialog.show();
//	}
//
//	public static boolean isEmailValid(String email) {
//		isValid = false;
//		// email validation check
//		String expression = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{2,4}$";
//		CharSequence inputStr = email;
//
//		Pattern pattern = Pattern.compile(expression, Pattern.CASE_INSENSITIVE);
//		Matcher matcher = pattern.matcher(inputStr);
//		if (matcher.matches()) {
//			isValid = true;
//		}
//		return isValid;
//	}
//
//	@Override
//	public void onWindowFocusChanged(boolean hasFocus) {
//
//		int[] location = new int[2];
//		// Button button = (Button) findViewById(R.id.o_spinner1);
//
//		// Get the x, y location and store it in the location[] array
//		// location[0] = x, location[1] = y.
//		edit_spinner.getLocationOnScreen(location);
//
//		// Initialize the Point with x, and y positions
//		p = new Point();
//		System.out.println(p);
//		p.x = location[0];
//		p.y = location[1];
//
//	}
//
//	private void showPopup(final Activity context, Point p) {
//
//		// Inflate the popup_layout.xml
//		LinearLayout viewGroup = (LinearLayout) context
//				.findViewById(R.id.popup);
//		// viewGroup.setBackgroundResource(R.drawable.login_text_field_bg);
//		LayoutInflater layoutInflater = (LayoutInflater) context
//				.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
//		View layout = layoutInflater.inflate(R.layout.spinnerview, viewGroup);
//
//		// Creating the PopupWindow
//		final PopupWindow popup = new PopupWindow(context);
//		popup.setContentView(layout);
//		popup.setWidth(400);
//		popup.setHeight(400);
//		popup.setFocusable(true);
//
//		// Some offset to align the popup a bit to the right, and a bit down,
//		// relative to button's position.
//		int OFFSET_X = 100;
//		int OFFSET_Y = 40;
//
//		// Clear the default translucent background
//		popup.setBackgroundDrawable(new BitmapDrawable());
//
//		// Displaying the popup at the specified location, + offsets.
//		popup.showAtLocation(layout, Gravity.NO_GRAVITY, p.x + OFFSET_X, p.y
//				+ OFFSET_Y);
//
//		/*
//		 * popup1 = new PopupWindow(layout, 300, 370, true);
//		 * popup1.showAtLocation(layout, Gravity.CENTER, 0, 0);
//		 * popup1.setFocusable(true);
//		 */
//
//		// Addbody weight pop layout
//		RelativeLayout layout_top_addbody_weight = (RelativeLayout) layout
//				.findViewById(R.id.father);
//		layout_top_addbody_weight.setOnClickListener(new OnClickListener() {
//
//			@Override
//			public void onClick(View v) {
//				// TODO Auto-generated method stub
//				guardian_type = "Father";
//				edit_spinner.setText(guardian_type);
//				popup.dismiss();
//			}
//		});
//
//		// // body weight reading pop layout
//		RelativeLayout layout_top_bodyweight_reading = (RelativeLayout) layout
//				.findViewById(R.id.mother);
//		layout_top_bodyweight_reading.setOnClickListener(new OnClickListener() {
//
//			@Override
//			public void onClick(View v) {
//				// TODO Auto-generated method stub
//				guardian_type = "Mother";
//				edit_spinner.setText(guardian_type);
//				popup.dismiss();
//			}
//		});
//
//		// Add bp Records pop layout
//		RelativeLayout layout_top_Add_BP_Records = (RelativeLayout) layout
//				.findViewById(R.id.grandfather);
//		layout_top_Add_BP_Records.setOnClickListener(new OnClickListener() {
//
//			@Override
//			public void onClick(View v) {
//				// TODO Auto-generated method stub
//				guardian_type = "Grandfather";
//				edit_spinner.setText(guardian_type);
//				popup.dismiss();
//
//			}
//		});
//
//		// // bp Records reading pop layout
//		RelativeLayout layout_Blood_Pressure = (RelativeLayout) layout
//				.findViewById(R.id.grandmother);
//		layout_Blood_Pressure.setOnClickListener(new OnClickListener() {
//
//			@Override
//			public void onClick(View v) {
//				// TODO Auto-generated method stub
//				guardian_type = "Grandmother";
//				edit_spinner.setText(guardian_type);
//				popup.dismiss();
//			}
//		});
//		//
//		// // Stats pop layout
//
//	}
//
//	private class Login_webservice extends AsyncTask<String, Integer, String> {
//
//		String lastname, success_login, firstname, message, guardian_type,
//				email;
//		InputStream is;
//		String result;
//		JSONObject jArray = null;
//
//		@Override
//		protected void onPreExecute() {
//			// Toast.makeText(Login.this,"asynch task",Toast.LENGTH_LONG).show();
//		}
//
//		@Override
//		public String doInBackground(String... url) {
//
//			try {
//				System.out.println("Asynch task started");
//				HttpClient httpclient = new DefaultHttpClient();
//				HttpGet httppost = new HttpGet(url_registration);
//				HttpResponse response = httpclient.execute(httppost);
//				HttpEntity entity = response.getEntity();
//				System.out
//						.println("url_registrationurl_registrationurl_registration"
//								+ url_registration);
//				is = entity.getContent();
//			} catch (Exception e) {
//				Log.e("ERROR", "Error in http connection " + e.toString());
//			}
//			// convert response to string
//			try {
//				BufferedReader reader = new BufferedReader(
//						new InputStreamReader(is), 8);
//				StringBuilder sb = new StringBuilder();
//				String line = null;
//				while ((line = reader.readLine()) != null) {
//					sb.append(line + "\n");
//				}
//				is.close();
//				result = sb.toString();
//
//				System.out.println("response +++++++++++++++++++" + result);
//
//			} catch (Exception e) {
//				Log.e("ERROR", "Error converting result " + e.toString());
//			}
//			Log.d("is", "is-------" + result);
//
//			try {
//				jArray = new JSONObject(result);
//				JSONObject data = jArray.getJSONObject("data");
//
//				if (data.has("firstname")) {
//					firstname = data.getString("firstname");
//					Log.d("is", "firstname-------" + firstname);
//					lastname = data.getString("lastname");
//					Log.d("is", "lastname-------" + lastname);
//					email = data.getString("email");
//					Log.d("is", "email-------" + email);
//					guardian_type = data.getString("guardian_type");
//					Log.d("is", "guardian_type-------" + guardian_type);
//					success_login = data.getString("success");
//					Log.d("is", "success_login-------" + success_login);
//					message = jArray.getString("msg");
//					Log.d("is", "message-------" + message);
//				} else {
//
//					success_login = data.getString("success");
//					Log.d("is", "success_login-------" + success_login);
//					message = jArray.getString("msg");
//					Log.d("is", "message-------" + message);
//				}
//
//			} catch (JSONException e) {
//				// TODO: handle exception
//			}
//
//			return null;
//		}
//
//		/*
//		 * private boolean containsIgnoreCase(String haystack, String needle) {
//		 * // TODO Auto-generated method stub if(needle.equals("")) return true;
//		 * if(haystack == null || needle == null || haystack .equals("")) return
//		 * false;
//		 * 
//		 * Pattern p =
//		 * Pattern.compile(needle,Pattern.CASE_INSENSITIVE+Pattern.LITERAL);
//		 * Matcher m = p.matcher(haystack); return m.find(); }
//		 */
//		public void onPostExecute(String resultt)
//
//		{
//			if (success_login.equals("1")) {
//				AlertDialog.Builder builder = new AlertDialog.Builder(
//						UserRegistration.this);
//
//				builder.setTitle("Connect to Facebook");
//				builder.setMessage("Do you want to connect with facebook" )
//						.setCancelable(false)
//						.setPositiveButton("OK",
//								new DialogInterface.OnClickListener() {
//									public void onClick(DialogInterface dialog,
//											int id) {
//										onFacebookClick();
//										//loginToFacebook();
//										/*Intent intent = new Intent(UserRegistration.this, LoginUsingCustomFragmentActivity.class);
//						                startActivity(intent);*/
//										dialog.cancel();
//
//									}
//
//								});
//				builder.setMessage("")
//						.setCancelable(false)
//						.setNegativeButton("Cancle",
//								new DialogInterface.OnClickListener() {
//
//									@Override
//									public void onClick(DialogInterface dialog,
//											int which) {
//										// TODO Auto-generated method stub
//										return;
//									}
//								});
//				AlertDialog alert = builder.create();
//				alert.show();
//
//				Toast.makeText(UserRegistration.this,
//						"Registration Successful", Toast.LENGTH_LONG).show();
//			} else if (success_login.equals("0")) {
//				AlertDialog.Builder builder = new AlertDialog.Builder(
//						UserRegistration.this);
//
//				builder.setTitle("Invalid Entry");
//				builder.setMessage(message)
//						.setCancelable(false)
//						.setPositiveButton("OK",
//								new DialogInterface.OnClickListener() {
//									public void onClick(DialogInterface dialog,
//											int id) {
//										onFacebookClick();
//										//loginToFacebook();
//										/*Intent intent = new Intent(UserRegistration.this, LoginUsingCustomFragmentActivity.class);
//						                startActivity(intent);*/
//										dialog.cancel();
//
//									}
//
//								});
//
//				AlertDialog alert = builder.create();
//				alert.show();
//				return;
//			}
//		}
//	}
//	// /.............................Facebooklogin............................//
//
//		private void onFacebookClick() {
//			if (mFacebook.isSessionValid()) {
//				final AlertDialog.Builder builder = new AlertDialog.Builder(this);
//
//				builder.setMessage("Delete current Facebook connection?")
//						.setCancelable(false)
//						.setPositiveButton("Yes",
//								new DialogInterface.OnClickListener() {
//									public void onClick(DialogInterface dialog,
//											int id) {
//										fbLogout();
//									}
//								})
//						.setNegativeButton("No",
//								new DialogInterface.OnClickListener() {
//									public void onClick(DialogInterface dialog,
//											int id) {
//										dialog.cancel();
//
//										// mFacebookBtn.setChecked(true);
//									}
//								});
//
//				final AlertDialog alert = builder.create();
//
//				alert.show();
//			} else {
//				// mFacebookBtn.setChecked(false);
//
//				mFacebook.authorize(this, PERMISSIONS, -1,
//						new FbLoginDialogListener());
//			}
//		}
//
//		private final class FbLoginDialogListener implements DialogListener {
//			public void onComplete(Bundle values) {
//				SessionStore.save(mFacebook, UserRegistration.this);
//
//				getFbName();
//			}
//
//			public void onFacebookError(FacebookError error) {
//				Toast.makeText(UserRegistration.this, "Facebook connection failed",
//						Toast.LENGTH_SHORT).show();
//
//			}
//
//			public void onError(DialogError error) {
//				Toast.makeText(UserRegistration.this, "Facebook connection failed",
//						Toast.LENGTH_SHORT).show();
//
//			}
//
//			public void onCancel() {
//
//			}
//		}
//
//		private void getFbName() {
//
//			new Thread() {
//				@Override
//				public void run() {
//					String name = "";
//					int what = 1;
//
//					try {
//
//						token = mFacebook.getAccessToken();
//						Log.d("tokentokentokentoken", "tokentokentokentokentoken"
//								+ token);
//						what = 0;
//					} catch (Exception ex) {
//						ex.printStackTrace();
//					}
//
//					mFbHandler.sendMessage(mFbHandler.obtainMessage(what, token));
//				}
//			}.start();
//
//		}
//
//		private void fbLogout() {
//			// mProgress.setMessage("Disconnecting from Facebook");
//			// mProgress.show();
//
//			new Thread() {
//				@Override
//				public void run() {
//					SessionStore.clear(UserRegistration.this);
//
//					int what = 1;
//
//					try {
//						mFacebook.logout(UserRegistration.this);
//
//						what = 0;
//					} catch (Exception ex) {
//						ex.printStackTrace();
//					}
//
//					mHandler.sendMessage(mHandler.obtainMessage(what));
//				}
//			}.start();
//
//		}
//
//		private Handler mFbHandler = new Handler() {
//			@Override
//			public void handleMessage(Message msg) {
//				// mProgress.dismiss();
//
//				if (msg.what == 0) {
//
//					// category = new Getcategory();
//					// Thread mUpdateThread1 = new Thread() {
//					// public void run() {
//					//
//					// Connnn1 _con1 = new Connnn1();
//					//
//					// try {
//					//
//					// String urrl =
//					// "https://graph.facebook.com/435640646494035?fields=events&access_token="
//					// + token;
//					//
//					// produck_cate = _con1.getProduct(MainActivity.this,
//					// urrl);
//					//
//					// } catch (ClientProtocolException e) {
//					// // TODO Auto-generated catch block
//					// e.printStackTrace();
//					// } catch (IOException e) {
//					// // TODO Auto-generated catch block
//					// e.printStackTrace();
//					// }
//					//
//					// MainActivity.this.handle.sendEmptyMessage(1);
//					//
//					// };
//					// };
//					// mUpdateThread1.start();
//					new MessagesofFriends1().execute();
//				} else {
//					Toast.makeText(UserRegistration.this, "Connected to Facebook",
//							Toast.LENGTH_SHORT).show();
//				}
//			}
//		};
//
//		private Handler mHandler = new Handler() {
//			@Override
//			public void handleMessage(Message msg) {
//				// mProgress.dismiss();
//
//				if (msg.what == 1) {
//					Toast.makeText(UserRegistration.this, "Facebook logout failed",
//							Toast.LENGTH_SHORT).show();
//				} else {
//
//					Toast.makeText(UserRegistration.this, "Disconnected from Facebook",
//							Toast.LENGTH_SHORT).show();
//				}
//			}
//		};
//		// getting facebook name and facebook id thro asyn task..
//		class MessagesofFriends1 extends AsyncTask<Context, Void, Void> {
//			// LazyAdapter adapter;
//			// String url = "", _imgurl = "";
//			String url;
//			ProgressDialog dialog = new ProgressDialog(UserRegistration.this);
//			protected void onPreExecute() {
//
//				super.onPreExecute();
//
//				//ProgressDialog dialog = new ProgressDialog(UserRegistration.this);
//				dialog.setMessage("Loading....please wait ");
//				dialog.setCancelable(false);
//				dialog.show();
//				System.out.println("URL================");
//				 url = "https://graph.facebook.com//v2.0/me?access_token="+ token;
//
//				Log.d("", "url" + url);
//				System.out.println("URL"+url);
//				
//				//http://....../me/friends/access_token=
//			}
//
//			protected Void doInBackground(Context... params) {
//				parentItems = new ArrayList<Getcategory>();
//				Getcategory getcategory = new Getcategory();
//				// Creating JSON Parser instance
//				JSONParser jParser = new JSONParser();
//
//				// getting JSON string from URL
//				JSONObject json = jParser.getJSONFromUrl(url);
//				try {
//					Log.d("", "json" + json);
//					
//					 email_returnfromfacebook= json.getString("email");
//					 String id=json.getString("id");
//					System.out.println("emailllllllllllllll"+email_returnfromfacebook);
//					System.out.println(id);
//					
//					/*getcategory.facebook_id = json.getString("id");
//					getcategory.facebook_nic_name = json.getString("name");
//					Log.d("", "getcategory.facebook_id" + getcategory.facebook_id);
//					Log.d("", "getcategory.getcategory.facebook_nic_name"
//							+ getcategory.facebook_nic_name);*/
//					// JSONArray jsonarray = null;
//					// try {
//					// jsonarray = json.getJSONArray("posts");
//					// } catch (JSONException e1) {
//					// // TODO Auto-generated catch block
//					// e1.printStackTrace();
//					// }
//					// Log.d("", "jsonarray" + jsonarray);
//					//
//					//
//					// // looping through All Contacts
//					// for (int i = 0; i < jsonarray.length(); i++) {
//					// getcategory = new Getcategory();
//					// JSONObject c = jsonarray.getJSONObject(i);
//					// getcategory.event_title = c.getString("title");
//					// getcategory.event_date = c.getString("date");
//					// getcategory.event_thumnail = c.getString("thumbnail");
//					// getcategory.event_content = c.getString("content");
//					// Log.d("", "getcategory.event_thumnail"
//					// + getcategory.event_thumnail);
//					// Log.d("", "getcategory.event_content"
//					// + getcategory.event_content);
//					// Log.d("", "getcategory.event_content"
//					// + getcategory.event_content);
//					//
//					// Log.d("", "getcategory.event_title"
//					// + getcategory.event_title);
//					// JSONObject second = c.optJSONObject("thumbnail_images");
//					// JSONObject thrid = second.getJSONObject("large");
//					// getcategory.event_fullimage = thrid.getString("url");
//					// // getcategory.event_fullimage = c.getString("id");
//					// Log.d("", "getcategory.event_fullimage"
//					// + getcategory.event_fullimage);
//					// Log.d("", "getcategory.event_fullimage"
//					// + getcategory.event_fullimage);
//					// Log.d("", "getcategory.event_fullimage"
//					// + getcategory.event_fullimage);
//
//				//	parentItems.add(getcategory);
//
//					// parentItems.add(getcategory);
//					// }
//
//				} catch (JSONException e) {
//					e.printStackTrace();
//				}
//
//				return null;
//			}
//
//			protected void onPostExecute(Void result) {
//				super.onPostExecute(result);
//				dialog.dismiss();
//				if(email_entered.equals(email_returnfromfacebook)){
//					Toast.makeText(UserRegistration.this, "email matched",2000).show();
//					//web service create for uploading fbid
//
//				 }
//				else{
//					AlertDialog.Builder builder = new AlertDialog.Builder(
//							UserRegistration.this);
//
//					builder.setTitle("Invalid Entry");
//					builder.setMessage("Email registered with Play Date is different from Facebook email ID ")
//							.setCancelable(false)
//							.setPositiveButton("OK",
//									new DialogInterface.OnClickListener() {
//										public void onClick(DialogInterface dialog,
//												int id) {
//
//											dialog.cancel();
//
//										}
//
//									});
//
//					AlertDialog alert = builder.create();
//					alert.show();
//					return;
//				}
//				
//				// adapter = new LazyAdapter(Tournaments.this, parentItems);
//			
//				// listView1.setAdapter(adapter);
//				// dialog.dismiss();
//
//			}
//		}
//		
//		
//		/*public void loginToFacebook() {
//		    mPrefs = getPreferences(MODE_PRIVATE);
//		    String access_token = mPrefs.getString("access_token", null);
//		    long expires = mPrefs.getLong("access_expires", 0);
//		 
//		    if (access_token != null) {
//		        facebook.setAccessToken(access_token);
//		    }
//		 
//		    if (expires != 0) {
//		        facebook.setAccessExpires(expires);
//		    }
//		 
//		    if (!facebook.isSessionValid()) {
//		        facebook.authorize(this,
//		                new String[] { "email", "publish_stream" },
//		                new DialogListener() {
//		 
//		                    @Override
//		                    public void onCancel() {
//		                        // Function to handle cancel event
//		                    }                                                                              
//		 
//		                    @Override
//		                    public void onComplete(Bundle values) {
//		                        // Function to handle complete event
//		                        // Edit Preferences and update facebook acess_token
//		                        SharedPreferences.Editor editor = mPrefs.edit();
//		                        editor.putString("access_token",
//		                                facebook.getAccessToken());
//		                        editor.putLong("access_expires",
//		                                facebook.getAccessExpires());
//		                        editor.commit();
//		                        
//		                        token = facebook.getAccessToken();
//		                      System.out.println("tpken-----------"+token);
//		                        new MessagesofFriends1().execute();
//		                    }
//		 
//		                    @Override
//		                    public void onError(DialogError error) {
//		                        // Function to handle error
//		 
//		                    }
//		 
//		                    @Override
//		                    public void onFacebookError(FacebookError fberror) {
//		                        // Function to handle Facebook errors
//		 
//		                    }
//		 
//		                });
//		    }
//		}
//		*/
//	
//
//}