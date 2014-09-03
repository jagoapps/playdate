/*package com.iapptechnologies.time;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
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
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

public class Forgetpassword extends Activity {
	
	EditText email;
	Button back,sendemail;
	String e_mail,e_mail_urlencode;
	static Boolean isValid=false;
	String forget_url;
	Boolean isInternetPresent = false;
    ConnectionDetector cd;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
	setContentView(R.layout.forgetpassword);
	  cd = new ConnectionDetector(getApplicationContext());
	email=(EditText)findViewById(R.id.edit_email_forgetpassword);
	back=(Button)findViewById(R.id.button_back_forgetpassword);
	sendemail=(Button)findViewById(R.id.button_email_forgetpassword);
	
	back.setOnClickListener(new OnClickListener() {
		
		@Override
		public void onClick(View v) {
			// TODO Auto-generated method stub
		Intent it=new Intent(Forgetpassword.this,Login.class);
		startActivity(it);
		}
	});
	sendemail.setOnClickListener(new OnClickListener() {
		
		@Override
		public void onClick(View v) {
			// TODO Auto-generated method stub
			
			 isInternetPresent = cd.isConnectingToInternet();
			 
             
             if (isInternetPresent) {
		e_mail=email.getText().toString();
		isEmailValid(email.getText().toString());
		if(isValid==true){
			
		}else{
			AlertDialog.Builder builder = new AlertDialog.Builder(Forgetpassword.this);
			
			builder.setTitle("Invalid Entry");
			builder.setMessage("Please check email validation").setCancelable(false)
					.setPositiveButton("OK", new DialogInterface.OnClickListener() {
						public void onClick(DialogInterface dialog, int id) {
							email.setText("");
							
							dialog.cancel();
							
						}
						
					});

			AlertDialog alert = builder.create();
			alert.show();
			return;
		}
		try {
			e_mail_urlencode =URLEncoder.encode(e_mail,"utf-8");
			 System.out.println(e_mail_urlencode);
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		 System.out.println(e_mail_urlencode);
		forget_url="http://112.196.34.179/playdate/forget_password.php?email="+e_mail_urlencode;
		System.out.println(forget_url);
		
		Login_webservice loginwebservice=new Login_webservice();
		loginwebservice.execute(new String[] { forget_url });
		}else{
			showAlertDialog(Forgetpassword.this, "No Internet Connection",
                    "You don't have internet connection.", false);
            return;
		}
		}
	});
	}
	public static boolean isEmailValid(String email) {
	    isValid = false;

	    String expression = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{2,4}$";
	    CharSequence inputStr = email;

	    Pattern pattern = Pattern.compile(expression, Pattern.CASE_INSENSITIVE);
	    Matcher matcher = pattern.matcher(inputStr);
	    if (matcher.matches()) {
	        isValid = true;
	    }
	    return isValid;
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
	
	private class Login_webservice extends AsyncTask<String, Integer, String> {
		
		
		  String email_return,passwordreturn,success,message; 
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
			HttpGet httppost = new HttpGet(forget_url);
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
				
				if(data.has("email")){
					 email_return=data.getString("email");
						Log.d("is","email-------"+email_return);
						passwordreturn=data.getString("password");
						Log.d("is","guardian_type-------"+passwordreturn);
						 success=data.getString("success");
						Log.d("is","success_login-------"+success);
						 message = jArray.getString("msg");
						 message=jArray.getString("msg");
							Log.d("is","message-------"+message);
				}
				else{
					//jArray = new JSONObject(result);
					//JSONObject data = jArray.getJSONObject("data");
					
					 
					 success=data.getString("success");
					Log.d("is","success_login-------"+success);
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
			if(success.equals("1")){
				AlertDialog.Builder builder = new AlertDialog.Builder(Forgetpassword.this);
				
				builder.setTitle("Password Sent");
				builder.setMessage(message).setCancelable(false)
						.setPositiveButton("OK", new DialogInterface.OnClickListener() {
							public void onClick(DialogInterface dialog, int id) {
								email.setText("");
								Intent it=new Intent(Forgetpassword.this,Login.class);
								startActivity(it);
								dialog.cancel();
								
							}
							
						});

				AlertDialog alert = builder.create();
				alert.show();
				
				
			
		}else if(success.equals("0")){
			AlertDialog.Builder builder = new AlertDialog.Builder(Forgetpassword.this);
			
			builder.setTitle("Invalid Entry");
			builder.setMessage(message).setCancelable(false)
					.setPositiveButton("OK", new DialogInterface.OnClickListener() {
						public void onClick(DialogInterface dialog, int id) {
							email.setText("");
							
							dialog.cancel();
							
						}
						
					});

			AlertDialog alert = builder.create();
			alert.show();
			
		}
			}
	    }

}
*/