package com.iapptechnologies.time;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;

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

import com.iapp.playdate.R;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

public class Camera_Class extends Activity {
	protected Button imgButton;//To refer image button
	protected ImageView image;//To refer image view
	//protected TextView field;//To refer textview    
	private boolean imgCapFlag = false;
	protected boolean taken;
	protected static final String PHOTO_TAKEN = "photo_taken";
	protected String path;
	 Bitmap bitmap;
	public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.camera);
        image = (ImageView) findViewById(R.id.imageView1_placeholder);
       // field = (TextView) findViewById(R.id.field);
        imgButton = (Button) findViewById(R.id.button1_camera);
      
        imgButton.setOnClickListener(new ButtonClickHandler());
      //  wallpapaerBtn.setOnClickListener(new ButtonClickHandler1());
        path = Environment.getExternalStorageDirectory()
                                + "/make_machine_example.jpg";
        startCameraActivity();
    }
	public class ButtonClickHandler implements View.OnClickListener {
		public void onClick(View view) {
		    //Below log message will be logged when you click Take photo button
		    Log.i("AndroidProgrammerGuru", "ButtonClickHandler.onClick()");
		    //Call startCameraActivity, an user defined method, going to be created
		    startCameraActivity();
		    }
		}
	
	protected void startCameraActivity() {
        //Log message
    Log.i("AndroidProgrammerGuru", "startCameraActivity()");
    //Create new file with name mentioned in the path variable
        File file = new File(path);
        //Creates a Uri from a file
    Uri outputFileUri = Uri.fromFile(file);
        //Standard Intent action that can be sent to have the 
        //camera application capture an image and return it.
        //You will be redirected to camera at this line
    Intent intent = new Intent(
       android.provider.MediaStore.ACTION_IMAGE_CAPTURE);
        //Add the captured image in the path
    intent.putExtra(MediaStore.EXTRA_OUTPUT, outputFileUri);
        //Start result method - Method handles the output 
        //of the camera activity
    startActivityForResult(intent, 0);
}
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
	    //Log message
	        Log.i("AndroidProgrammerGuru", "resultCode: " + resultCode);
	    switch (resultCode) {
	        //When user doesn't capture image, resultcode returns 0
	        case 0:
	        Log.i("AndroidProgrammerGuru", "User cancelled");
	        break;
	        //When user captures image, onPhotoTaken an user-defined method
	        //to assign the capture image to ImageView
	            case -1:
	        onPhotoTaken();
	        break;
	    }
	}
	protected void onPhotoTaken() {
        //Log message
    Log.i("AndroidProgrammerGuru", "onPhotoTaken");
    //Flag used by Activity life cycle methods
        taken = true;
    //Flag used to check whether image captured or not
        imgCapFlag = true;
    //BitmapFactory- Create an object
        BitmapFactory.Options options = new BitmapFactory.Options();
    //Set image size
        options.inSampleSize = 4;
    //Read bitmap from the path where captured image is stored
         bitmap = BitmapFactory.decodeFile(path, options);
    //Set ImageView with the bitmap read in the prev line
        image.setImageBitmap(bitmap);
        //Make the TextView invisible
    //field.setVisibility(View.GONE);
    }
	@Override
	protected void onSaveInstanceState(Bundle outState) {
	    outState.putBoolean(Camera_Class.PHOTO_TAKEN, taken);
	}
	@Override
	protected void onRestoreInstanceState(Bundle savedInstanceState) {
	    Log.i("AndroidProgrammerGuru", "onRestoreInstanceState()");
	    if(savedInstanceState.getBoolean(Camera_Class.PHOTO_TAKEN)){
	        onPhotoTaken();
	    }
	}
	public  class parent_pic_update extends AsyncTask<String, Integer, String>{
		ProgressDialog dialog=new ProgressDialog(Camera_Class.this);
		String url;
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
				url="http://112.196.34.179/playdate/guardian_edit.php";//?profile_pic=pic&name=deepak&dob=1989/1/12&set_fixed_freetime=1989/2/4&school=DPS&conditions=TRUE&allergies=test&hobbies=demo&siblings=mother&youth_club=abc&g_id=10"
		}
			
			
			@Override
			protected String doInBackground(String... arg0) {
				// TODO Auto-generated method stub
				
				
					HttpClient httpClient = new DefaultHttpClient();
			        HttpContext localContext = new BasicHttpContext();
			        HttpPost httpPost = new HttpPost(url);

			        
			        
			        
			        
			       // Bitmap bitmap = BitmapFactory.decodeResource(getResources(),R.drawable.ic_launcher);          
			        ByteArrayOutputStream stream = new ByteArrayOutputStream();
			        bitmap.compress(Bitmap.CompressFormat.JPEG, 90, stream); //compress to which format you want.
			        byte [] byte_arr = stream.toByteArray();
			        String image_str = com.iapptechnologies.time.Base64.encodeBytes(byte_arr);
			      System.out.println("image compressed");
			      
			      ArrayList<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();
			        nameValuePairs.add(new BasicNameValuePair("profile_image","12.jpg"));
				//	nameValuePairs.add(new BasicNameValuePair("facebook_id", fb_id));
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
						response = httpClient.execute(httpPost,
						        localContext);
					} catch (ClientProtocolException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
			        BufferedReader reader = null;
					try {
						reader = new BufferedReader(
						        new InputStreamReader(
						                response.getEntity().getContent(), "UTF-8"));
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
						
						System.out.println("response"+sResponse);
			        } catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				try {
					JSONObject json= new JSONObject(sResponse);
					
				 data=json.getString("success");
					urlreturned=json.getString("url");
					
					
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			      
			       
			      
				
				
				return null;
			}
			protected void onPostExecute(String resultt) {
				

				dialog.dismiss();
				if(data.equalsIgnoreCase("1")){
				 Toast.makeText(Camera_Class.this,"Updated",1000).show();
				 
				// strURL=urlreturned;
				 GlobalVariable.url=urlreturned;
				}
				else{
					 Toast.makeText(Camera_Class.this,"Updation not successful, please try again",1000).show();
				}
				}
	}
	   }