/*package com.iapptechnologies.time;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.json.JSONException;
import org.json.JSONObject;

import com.iapp.playdate.R;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.text.Html;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

public class Login extends Activity {
	TextView forget_password;
	Button btn_login,btn_register;
	EditText edit_username,edit_password;
	String url_login;
	ArrayList<String> logindata=null;
	 Boolean isInternetPresent = false;
	    ConnectionDetector cd;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.login);
		System.out.println("Login Activity");
		  cd = new ConnectionDetector(getApplicationContext());
		forget_password=(TextView)findViewById(R.id.forget_password);
		String str="<html><body><u>Forget Password </u></body></html>";
		forget_password.setText(Html.fromHtml(str));
		btn_login=(Button)findViewById(R.id.button_login);
		btn_register=(Button)findViewById(R.id.button_register);
		edit_username=(EditText)findViewById(R.id.username_login);
		edit_password=(EditText)findViewById(R.id.password_login);
		forget_password.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				Intent it=new Intent(Login.this,Forgetpassword.class);
				startActivity(it);
				
			}
		});
		
		btn_login.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				
				 isInternetPresent = cd.isConnectingToInternet();
				 
	              
	                if (isInternetPresent) {
				System.out.println("on click login button");
				try {
					System.out.println("on click login button");
					String username=URLEncoder.encode(edit_username.getText().toString(),"utf-8");			
					String password=URLEncoder.encode(edit_password.getText().toString(),"utf-8");
					
					
					//Toast.makeText(Login.this, ""+username+"  "+password,Toast.LENGTH_LONG).show();
		url_login="http://112.196.34.179/playdate/login.php?email="+username+"&password="+password;
		System.out.println("url_login"+url_login);
				} catch (Exception e) {
					// TODO: handle exception
				}
				
	
	Login_webservice loginwebservice=new Login_webservice();
	loginwebservice.execute(new String[] { url_login });
			
			 } else {
                 // Internet connection is not present
                 // Ask user to connect to Internet
                 showAlertDialog(Login.this, "No Internet Connection",
                         "You don't have internet connection.", false);
                 return;
             }
			}
		});
		
		btn_register.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				Intent it=new Intent(Login.this, UserRegistration.class);
				startActivity(it);
			}
		});
	}

	private class Login_webservice extends AsyncTask<String, Integer, String> {
		
		
		  String lastname,success_login,firstname,message,guardian_type,email; 
		InputStream is;
		String result;
		JSONObject jArray = null;
		 @Override
	        protected void onPreExecute() {
			// Toast.makeText(Login.this,"asynch task",Toast.LENGTH_LONG).show();
	        }
		
		@Override
		public String doInBackground(String... url) {
			
			
			try{
				System.out.println("Asynch task started");
			HttpClient httpclient = new DefaultHttpClient();
			HttpGet httppost = new HttpGet(url_login);
			HttpResponse response = httpclient.execute(httppost);
			HttpEntity entity = response.getEntity();
			 is = entity.getContent();
		} catch (Exception e) {
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
		Log.d("is","is-------"+result);
		
		
			try {
				jArray = new JSONObject(result);
				JSONObject data = jArray.getJSONObject("data");
				
				if(data.has("firstname")){
					 firstname=data.getString("firstname");
						Log.d("is","firstname-------"+firstname);
						 lastname=data.getString("lastname");
						Log.d("is","lastname-------"+lastname);
						 email=data.getString("email");
						Log.d("is","email-------"+email);
						 guardian_type=data.getString("guardian_type");
						Log.d("is","guardian_type-------"+guardian_type);
						 success_login=data.getString("success");
						Log.d("is","success_login-------"+success_login);
						message=jArray.getString("msg");
						Log.d("is","message-------"+message);
				}
				else{
					 success_login=data.getString("success");
						Log.d("is","success_login-------"+success_login);
						message=jArray.getString("msg");
						Log.d("is","message-------"+message);
				}
				
			} catch (JSONException e) {
				// TODO: handle exception
			}

		
		
		return null;
		}
		private boolean containsIgnoreCase(String haystack, String needle) {
			// TODO Auto-generated method stub
			 if(needle.equals(""))
				    return true;
				  if(haystack == null || needle == null || haystack .equals(""))
				    return false; 

				  Pattern p = Pattern.compile(needle,Pattern.CASE_INSENSITIVE+Pattern.LITERAL);
				  Matcher m = p.matcher(haystack);
				  return m.find();
		}

		public void onPostExecute(String resultt)
		
		{
			if(success_login.equals("1")){
			//Toast.makeText(Login.this,"Login Successful",Toast.LENGTH_LONG).show();
			Intent it=new Intent(Login.this,Home.class);
			startActivity(it);
		}else if(success_login.equals("0")){
			Toast.makeText(Login.this,"Login Failed",Toast.LENGTH_LONG).show();
		}
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
}

*/