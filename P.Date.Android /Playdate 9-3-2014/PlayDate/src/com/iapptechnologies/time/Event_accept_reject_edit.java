package com.iapptechnologies.time;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

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
import android.app.AlertDialog;
import android.app.DatePickerDialog;
import android.app.ProgressDialog;
import android.app.TimePickerDialog;
import android.content.DialogInterface;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.TimePicker;
import android.widget.Toast;

import com.iapp.playdate.R;


public class Event_accept_reject_edit extends android.support.v4.app.Fragment{

	int i=1,count_alert=0;
	int date_dialog=0,start_dialog=0,end_dialog=0;
	int myYear,myMonth,myDay;
	int hours,minutes;
	String child_name,child_id,child_pic,friend_name,friend_pic,friend_id,guardian_id,event_id,start_time,end_time,date,location_of_event,notes,ststus_of_event,time="",time_to="",eventdate,eventdate1,eventdate2,eventdate3;
	ImageView child_image,friend_image;
	Button accept_request,reject_request,edit_request,sendback,cancle;
	EditText date_of_event,time_of_event,place_of_event,notes_of_event,end_time_txt,date1,starttime1,endtime1,date2,starttime2,endtime2,date3,starttime3,endtime3;
	TextView child_name_txt,friend_name_txt,child_name_event,friend_name_event,alternatedatetime,starttime_appear;
	RelativeLayout block1_date,block1_starttime,block1_endtime,block2_date,block2_starttime,block2_endtime,block3_date,block3_starttime,block3_endtime,block_endtime;
	String date_comparision,status,sender_id,receiver_id,success,url_create,date_selected,starttime_selected,endtime_selected,date_selected1,starttime_selected1,endtime_selected1,date_selected2,starttime_selected2,endtime_selected2,date_selected3,starttime_selected3,endtime_selected3;
	boolean clicked=false,clicke_on_timepicker=false;;
	Boolean isInternetPresent = false;
    ConnectionDetector cd;
    String date_1alt,date_2alt,date_3alt,start_time1alt,start_time2alt,start_time3alt,end_time1alt,end_time2alt,end_time3alt;
	public Event_accept_reject_edit(){
		
	}
	@SuppressLint("DefaultLocale")
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		ViewGroup view = (ViewGroup) inflater.inflate(R.layout.eventshown, container,
                false);
		Calendar c = Calendar.getInstance();
		System.out.println("Current time => " + c.getTime());

		SimpleDateFormat df = new SimpleDateFormat("dd-MM-yyyy");
		 date_comparision = df.format(c.getTime());
		ImageLoader imageLoader=new ImageLoader(getActivity());
		accept_request=(Button)view.findViewById(R.id.button1_accept_event);
		reject_request=(Button)view.findViewById(R.id.button2_reject_event);
		edit_request=(Button)view.findViewById(R.id.button3_edit_event);
		sendback=(Button)view.findViewById(R.id.button1_sendback);
		cancle=(Button)view.findViewById(R.id.button3_cancle);
		child_name_txt=(TextView)view.findViewById(R.id.textView1_childname);
		friend_name_txt=(TextView)view.findViewById(R.id.textView3_friendname);
		child_name_event=(TextView)view.findViewById(R.id.textView1_child_name_event);
		friend_name_event=(TextView)view.findViewById(R.id.textView3_child_friend_name_event);
		starttime_appear=(TextView)view.findViewById(R.id.textView_event3);
		alternatedatetime=(TextView)view.findViewById(R.id.text_alternatedate12);
		date_of_event=(EditText)view.findViewById(R.id.edittext_when_request);
		time_of_event=(EditText)view.findViewById(R.id.textView_time_ofevent);
		place_of_event=(EditText)view.findViewById(R.id.textView_where_event);
		notes_of_event=(EditText)view.findViewById(R.id.textView_notes_event);
		block1_date=(RelativeLayout)view.findViewById(R.id.end_date1_gone);
		block1_starttime=(RelativeLayout)view.findViewById(R.id.end_starttime1_gone);
		block1_endtime=(RelativeLayout)view.findViewById(R.id.end_time1_gone);
		block2_date=(RelativeLayout)view.findViewById(R.id.date2_gone);
		block2_starttime=(RelativeLayout)view.findViewById(R.id.start_time2_gone);
		block2_endtime=(RelativeLayout)view.findViewById(R.id.end_time2_gone);
		block3_date=(RelativeLayout)view.findViewById(R.id.date3_gone);
		block3_starttime=(RelativeLayout)view.findViewById(R.id.start_time3_gone);
		block3_endtime=(RelativeLayout)view.findViewById(R.id.end_time3_gone);
		block_endtime=(RelativeLayout)view.findViewById(R.id.end_time_gone);
		date1=(EditText)view.findViewById(R.id.edit_requestdate_date1_event);
		starttime1=(EditText)view.findViewById(R.id.edit_requestdate_starttime1_event);
		endtime1=(EditText)view.findViewById(R.id.edit_time_alternate_event);
		date2=(EditText)view.findViewById(R.id.edit_requestdate_date2_event);
		starttime2=(EditText)view.findViewById(R.id.edit_requestdate_starttime2_event);
		endtime2=(EditText)view.findViewById(R.id.edit_requestdate_endtime2_event);
		date3=(EditText)view.findViewById(R.id.edit_requestdate_date3_event);
		starttime3=(EditText)view.findViewById(R.id.edit_requestdate_starttime3_event);
		endtime3=(EditText)view.findViewById(R.id.edit_requestdate_endtime3_event);
		end_time_txt=(EditText)view.findViewById(R.id.edit_requestdate_date_event);
		child_image=(ImageView)view.findViewById(R.id.imageView2_child_event);
		friend_image=(ImageView)view.findViewById(R.id.imageView_childfriend_event);
		
		getActivity().getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_PAN);
		
		child_name = getArguments().getString("child_name"); 
		child_id = getArguments().getString("Child_id"); 
		child_pic=getArguments().getString("Child_profilepic");
		friend_name = getArguments().getString("Child_friend_name"); 
		friend_pic = getArguments().getString("Child_friend_pic"); 
		friend_id = getArguments().getString("Child_frient_id"); 
		guardian_id = getArguments().getString("Child_guardianId"); 
		event_id = getArguments().getString("event_id"); 
		start_time = getArguments().getString("event_start"); 
		end_time = getArguments().getString("event_end_time"); 
		date = getArguments().getString("event_date"); 
		location_of_event = getArguments().getString("location_ofevent"); 
		notes = getArguments().getString("notes"); 
		sender_id= getArguments().getString("sender_id"); 
		receiver_id= getArguments().getString("receiver_id"); 
		status= getArguments().getString("status"); 
		
		//Alternate date/time
		try {
			date_1alt=getArguments().getString("date1_event"); 
			date_2alt=getArguments().getString("date2_event"); 
			date_3alt=getArguments().getString("date3_event"); 
			start_time1alt=getArguments().getString("start_time1_event");
			start_time2alt=getArguments().getString("start_time2_event");
			start_time3alt=getArguments().getString("start_time3_event");
			end_time1alt=getArguments().getString("end_time1_event");
			end_time2alt=getArguments().getString("end_time2_event");
			end_time3alt=getArguments().getString("end_time3_event");
			
		} catch (Exception e) {
			// TODO: handle exception
		}
	try {
		
		
		if(date_1alt.equals("0000-00-00")){
			
		}else{
			i=2;
			 DateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
			 Date date_of_event1=null;
			 try {
				 date_of_event1=sdf.parse(date_1alt);
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}//String reportDate = df.format(today);
			// birthDay=sdf.format(date_of_birth);
			 DateFormat destDf = new SimpleDateFormat("dd-MM-yyyy");
			 String date_of_event = destDf.format(date_of_event1);
			block1_date.setVisibility(View.VISIBLE);
			block1_endtime.setVisibility(View.VISIBLE);
			block1_starttime.setVisibility(View.VISIBLE);
			date1.setText(date_of_event);
			starttime1.setText(start_time1alt);
			endtime1.setText(end_time1alt);
		}
        if(date_2alt.equals("0000-00-00")){
			
		}else{
			i=3;
			 DateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
			 Date date_of_event1=null;
			 try {
				 date_of_event1=sdf.parse(date_2alt);
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}//String reportDate = df.format(today);
			// birthDay=sdf.format(date_of_birth);
			 DateFormat destDf = new SimpleDateFormat("dd-MM-yyyy");
			 String date_of_event = destDf.format(date_of_event1);
			block2_date.setVisibility(View.VISIBLE);
			block2_endtime.setVisibility(View.VISIBLE);
			block2_starttime.setVisibility(View.VISIBLE);
			date2.setText(date_of_event);
			starttime2.setText(start_time2alt);
			endtime2.setText(end_time2alt);
		}
      if(date_3alt.equals("0000-00-00")){
	
      }else{
    	  DateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
			 Date date_of_event1=null;
			 try {
				 date_of_event1=sdf.parse(date_3alt);
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}//String reportDate = df.format(today);
			// birthDay=sdf.format(date_of_birth);
			 DateFormat destDf = new SimpleDateFormat("dd-MM-yyyy");
			 String date_of_event = destDf.format(date_of_event1);
    	    block3_date.setVisibility(View.VISIBLE);
			block3_endtime.setVisibility(View.VISIBLE);
			block3_starttime.setVisibility(View.VISIBLE);
	      date3.setText(date_of_event);
	      starttime3.setText(start_time3alt);
	      endtime3.setText(end_time3alt);
     }
	} catch (Exception e) {
		// TODO: handle exception
	}
//		view.setFocusableInTouchMode(true);
//		view.requestFocus();
//		view.setOnKeyListener(new View.OnKeyListener() {
//		        @Override
//		        public boolean onKey(View v, int keyCode, KeyEvent event) {
//		            //Log.i(tag, "keyCode: " + keyCode);
//		            if( keyCode == KeyEvent.KEYCODE_BACK ) {
//		                  //  Log.i(tag, "onKey Back listener is working!!!");
//		            	Log.e("ONBackPressed==","WorkingNow");
//		                //getFragmentManager().popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
//		               
//		            	FragmentTransaction tx = FragmentManager.beginTransation();
//		            	tx.replace( R.id.fragment, new MyFragment() ).addToBackStack( "tag" ).commit();
//		                
//		                return true;
//		            } else {
//		                return false;
//		            }
//		        }
//		    });
		
		
		
		 DateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
		 Date date_of_birth=null;
		 try {
			 date_of_birth=sdf.parse(date);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}//String reportDate = df.format(today);
		// birthDay=sdf.format(date_of_birth);
		 DateFormat destDf = new SimpleDateFormat("dd-MM-yyyy");
		 String date_of_event1 = destDf.format(date_of_birth);
		 
		               
	
		             // format the date into another format
		
		
		if(status.equalsIgnoreCase("accepted")){
			sender_id=receiver_id;
			/*accept_request.setVisibility(View.INVISIBLE);
			reject_request.setVisibility(View.INVISIBLE);
			edit_request.setVisibility(View.INVISIBLE);
			date_of_event.setEnabled(false);
			time_of_event.setEnabled(false);
			place_of_event.setEnabled(false);
			notes_of_event.setEnabled(false);
			end_time_txt.setEnabled(false);*/
			
		}
		
		if(sender_id.equals(guardian_id)){
			sender_id=receiver_id;
			accept_request.setVisibility(View.INVISIBLE);
			reject_request.setVisibility(View.GONE);
			/*edit_request.setVisibility(View.INVISIBLE);
			date_of_event.setEnabled(false);
			time_of_event.setEnabled(false);
			place_of_event.setEnabled(false);
			notes_of_event.setEnabled(false);
			end_time_txt.setEnabled(false);*/
		}
		
		child_name_txt.setText(child_name.toUpperCase());
		friend_name_txt.setText(friend_name.toUpperCase());
		child_name_event.setText(child_name.toUpperCase());
		friend_name_event.setText(friend_name.toUpperCase());
		
		date_of_event.setText(date_of_event1);
		time_of_event.setText(start_time +" TO "+end_time);
		place_of_event.setText(location_of_event.toUpperCase());
		notes_of_event.setText(notes.toUpperCase());
		//notes_of_event.setFocusable(false);
		
		/*date_of_event.setFocusable(false);
		date_of_event.setClickable(false);
		time_of_event.setFocusable(false);
		time_of_event.setClickable(false);*/
		//place_of_event.setFocusable(false);
		
		
	
		date1.setEnabled(false);
		date2.setEnabled(false);
		date3.setEnabled(false);
		starttime1.setEnabled(false);
		starttime2.setEnabled(false);
		starttime3.setEnabled(false);
		endtime1.setEnabled(false);
		endtime2.setEnabled(false);
		endtime3.setEnabled(false);
	
		end_time_txt.setFocusable(false);
		end_time_txt.setClickable(true);
	
		
		date_of_event.setEnabled(false);
		time_of_event.setEnabled(false);
		place_of_event.setEnabled(false);
		notes_of_event.setEnabled(false);
		end_time_txt.setEnabled(false);
		
		imageLoader.DisplayImage(child_pic, child_image);
		imageLoader.DisplayImage(friend_pic, friend_image);
		
		child_image.requestLayout();
		friend_image.requestLayout();
		 int density = getResources().getDisplayMetrics().densityDpi;
		  switch (density) {
		  case DisplayMetrics.DENSITY_LOW:
			  child_image.getLayoutParams().height = 70;
			  child_image.getLayoutParams().width = 70;
			  friend_image.getLayoutParams().height = 70;
			  friend_image.getLayoutParams().width = 70;
			  
			  break;
		  case DisplayMetrics.DENSITY_MEDIUM:
			  child_image.getLayoutParams().height = 100;
			  child_image.getLayoutParams().width = 100;
			  friend_image.getLayoutParams().height = 100;
			  friend_image.getLayoutParams().width = 100;
			  break;
		  case DisplayMetrics.DENSITY_HIGH:
			  child_image.getLayoutParams().height = 120;
			  child_image.getLayoutParams().width = 120;
			  friend_image.getLayoutParams().height = 120;
			  friend_image.getLayoutParams().width = 120;
			  break;
		  case DisplayMetrics.DENSITY_XHIGH:
			  child_image.getLayoutParams().height = 150;
			  child_image.getLayoutParams().width = 150;
			  friend_image.getLayoutParams().height = 150;
			  friend_image.getLayoutParams().width = 150;
			  break;
		  case DisplayMetrics.DENSITY_XXHIGH:
			  child_image.getLayoutParams().height = 150;
			  child_image.getLayoutParams().width = 150;
			  friend_image.getLayoutParams().height = 150;
			  friend_image.getLayoutParams().width = 150;
			  break;
		  }
		  accept_request.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				
				
				new AlertDialog.Builder(getActivity())
			    .setTitle("Selected Action")
			    .setMessage("Are you sure ")
			    .setPositiveButton("OK", new DialogInterface.OnClickListener() {
			        public void onClick(DialogInterface dialog, int which) { 
			            // continue with delete
			        	ststus_of_event="accepted";
			        	cd=new ConnectionDetector(getActivity());
						 isInternetPresent = cd.isConnectingToInternet();
						 if (isInternetPresent) {
								new accept_reject().execute();
						 }
						 else{
							 Toast.makeText(getActivity(),"Please check internet connection",2000).show();
							
						 }
					
			        }
			     })
			    .setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
			        public void onClick(DialogInterface dialog, int which) { 
			        	
			        }
			     })
			    .setIcon(android.R.drawable.ic_dialog_alert)
			     .show();
			}
		});
		  reject_request.setOnClickListener(new OnClickListener() {
				
				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					
					
					new AlertDialog.Builder(getActivity())
				    .setTitle("Selected Action")
				    .setMessage("Are you sure ")
				    .setPositiveButton("OK", new DialogInterface.OnClickListener() {
				        public void onClick(DialogInterface dialog, int which) { 
				            // continue with delete
				        	ststus_of_event="rejected";
							
							cd=new ConnectionDetector(getActivity());
							 isInternetPresent = cd.isConnectingToInternet();
							 if (isInternetPresent) {
								 new accept_reject().execute();
							 }
							 else{
								 Toast.makeText(getActivity(),"Please check internet connection",2000).show();
								
							 }
				        }
				     })
				    .setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
				        public void onClick(DialogInterface dialog, int which) { 
				        	
				        }
				     })
				    .setIcon(android.R.drawable.ic_dialog_alert)
				     .show();
					
					
				}
			});
		  edit_request.setOnClickListener(new OnClickListener() {
				
				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					accept_request.setVisibility(View.GONE);
					reject_request.setVisibility(View.GONE);
					
					block_endtime.setVisibility(View.VISIBLE);
					alternatedatetime.setVisibility(View.VISIBLE);
					cancle.setVisibility(View.GONE);
					sendback.setVisibility(View.VISIBLE);
					starttime_appear.setText("START TIME");
					//time_of_event.setText("");
					clicked=true;
					date_of_event.setEnabled(true);
					time_of_event.setEnabled(true);
					place_of_event.setEnabled(true);
					notes_of_event.setEnabled(true);
					end_time_txt.setEnabled(true);
					//place_of_event.requestFocus();
					place_of_event.setFocusable(true);
					//notes_of_event.requestFocus();
					notes_of_event.setFocusable(true);
					//date_of_event.requestFocus();
					date_of_event.setFocusable(false);
					date_of_event.setClickable(true);
					//time_of_event.requestFocus();
					time_of_event.setFocusable(false);
					time_of_event.setClickable(true);
					date1.setEnabled(true);
					date2.setEnabled(true);
					date3.setEnabled(true);
					starttime1.setEnabled(true);
					starttime2.setEnabled(true);
					starttime3.setEnabled(true);
					endtime1.setEnabled(true);
					endtime2.setEnabled(true);
					endtime3.setEnabled(true);
					time_of_event.setText(start_time);
					end_time_txt.setText(end_time);
					edit_request.setVisibility(View.GONE);
					date1.setFocusable(false);
					date1.setClickable(true);

					starttime1.setFocusable(false);
					starttime1.setClickable(true);
					
					endtime1.setFocusable(false);
					endtime1.setClickable(true);
					

					date2.setFocusable(false);
					date2.setClickable(true);

					starttime2.setFocusable(false);
					starttime2.setClickable(true);
					
					endtime2.setFocusable(false);
					endtime2.setClickable(true);
					

					date3.setFocusable(false);
					date3.setClickable(true);

					starttime3.setFocusable(false);
					starttime3.setClickable(true);
					
					endtime3.setFocusable(false);
					endtime3.setClickable(true);
				}
			});
		
		  cancle.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				sendback.setVisibility(View.GONE);
				accept_request.setVisibility(View.VISIBLE);
				reject_request.setVisibility(View.VISIBLE);
				edit_request.setVisibility(View.VISIBLE);
				cancle.setVisibility(View.GONE);
			}
		});
		sendback.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				clicked=false;
				
				/*accept_request.setVisibility(View.VISIBLE);
				reject_request.setVisibility(View.VISIBLE);
				edit_request.setVisibility(View.VISIBLE);
				cancle.setVisibility(View.GONE);
				sendback.setVisibility(View.GONE);*/
				
				location_of_event=place_of_event.getText().toString();
				notes=notes_of_event.getText().toString();
				date_selected=date_of_event.getText().toString();
				 starttime_selected=time_of_event.getText().toString();
					 endtime_selected=end_time_txt.getText().toString();
					 
					 date_selected1=date1.getText().toString();
					 starttime_selected1=starttime1.getText().toString();
					 endtime_selected1=endtime1.getText().toString();
					 
					 date_selected2=date2.getText().toString();
					 starttime_selected2=starttime2.getText().toString();
					 endtime_selected2=endtime2.getText().toString();
					 
					 date_selected3=date3.getText().toString();
					 starttime_selected3=starttime3.getText().toString();
					 endtime_selected3=endtime3.getText().toString();
					 
					 if(date_selected.equals(date_selected1)){
						 if(starttime_selected.equals(starttime_selected1)&&endtime_selected.equals(endtime_selected1)){
							 new AlertDialog.Builder(getActivity())
							    .setTitle("Invalid entry")
							    .setMessage("Date/Time can't same as alternate date/time")
							    .setPositiveButton("OK", new DialogInterface.OnClickListener() {
							        public void onClick(DialogInterface dialog, int which) { 
							        	
							        }
							     })
							   
							    .setIcon(android.R.drawable.ic_dialog_alert)
							     .show();
							 return;
						 }
					 }
					 if(date_selected.equals(date_selected2)){
						 if(starttime_selected.equals(starttime_selected2)&&endtime_selected.equals(endtime_selected2)){
							 new AlertDialog.Builder(getActivity())
							    .setTitle("Invalid entry")
							    .setMessage("Date/Time can't same as alternate date/time")
							    .setPositiveButton("OK", new DialogInterface.OnClickListener() {
							        public void onClick(DialogInterface dialog, int which) { 
							        	
							        }
							     })
							   
							    .setIcon(android.R.drawable.ic_dialog_alert)
							     .show();
							 return;
						 }
					 }
					 if(date_selected.equals(date_selected3)){
						 if(starttime_selected.equals(starttime_selected3)&&endtime_selected.equals(endtime_selected3)){
							 new AlertDialog.Builder(getActivity())
							    .setTitle("Invalid entry")
							    .setMessage("Date/Time can't same as alternate date/time")
							    .setPositiveButton("OK", new DialogInterface.OnClickListener() {
							        public void onClick(DialogInterface dialog, int which) { 
							        	
							        }
							     })
							   
							    .setIcon(android.R.drawable.ic_dialog_alert)
							     .show();
							 return; 
						 }
					 }
					 
					 if(date_selected1.equals(date_selected2)){
						 if(starttime_selected1.equals(starttime_selected2)&&endtime_selected1.equals(endtime_selected2)){
							 new AlertDialog.Builder(getActivity())
							    .setTitle("Invalid entry")
							    .setMessage("Alternate Date/Time can't same as alternate date/time")
							    .setPositiveButton("OK", new DialogInterface.OnClickListener() {
							        public void onClick(DialogInterface dialog, int which) { 
							        	
							        }
							     })
							   
							    .setIcon(android.R.drawable.ic_dialog_alert)
							     .show();
							 return; 
						 }
					 }
					 if(date_selected1.equals(date_selected3)){
						 if(starttime_selected1.equals(starttime_selected3)&&endtime_selected1.equals(endtime_selected3)){
							 new AlertDialog.Builder(getActivity())
							    .setTitle("Invalid entry")
							    .setMessage("Alternate Date/Time can't same as alternate date/time")
							    .setPositiveButton("OK", new DialogInterface.OnClickListener() {
							        public void onClick(DialogInterface dialog, int which) { 
							        	
							        }
							     })
							   
							    .setIcon(android.R.drawable.ic_dialog_alert)
							     .show();
							 return;	 
						 }
					 }
					 if(date_selected2.equals(date_selected3)){
						 if(starttime_selected2.equals(starttime_selected3)&&endtime_selected2.equals(endtime_selected3)){
							 new AlertDialog.Builder(getActivity())
							    .setTitle("Invalid entry")
							    .setMessage("Alternate Date/Time can't same as alternate date/time")
							    .setPositiveButton("OK", new DialogInterface.OnClickListener() {
							        public void onClick(DialogInterface dialog, int which) { 
							        	
							        }
							     })
							   
							    .setIcon(android.R.drawable.ic_dialog_alert)
							     .show();
							 return; 
						 }
					 }
					 
					 
					 SimpleDateFormat sdf=new SimpleDateFormat("dd-MM-yyyy");
					 Date date_1=null,date_2=null,date_3=null,date_4=null;
					 try {
						 date_1=sdf.parse(date_selected);
						
						 
						 
					} catch (ParseException e) {
						
						e.printStackTrace();
					}
					 SimpleDateFormat destDf = new SimpleDateFormat("yyyy-MM-dd");
					
					               
				
					             // format the date into another format
					try {
						 eventdate = destDf.format(date_1);
					} catch (Exception e) {
						// TODO: handle exception
					}
					
					 
					 
					 
					// location_selected=location.getText().toString();
					if(date_of_event.getText().toString().length()>0 && time_of_event.getText().toString().length()>0 && end_time_txt.getText().toString().length()>0 && place_of_event.getText().toString().length()>0){
						
						if(date_selected1.equals(null)){
							date_selected1="";
						}
						else{
							 try {
								date_2=sdf.parse(date_selected1);
								 eventdate1 = destDf.format(date_2);
							} catch (ParseException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
						}
						if(date_selected2.equals(null)){
							date_selected2="";
						}
						else{
							try {
								date_3=sdf.parse(date_selected2);
								 eventdate2 = destDf.format(date_3);
							} catch (ParseException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
						}
						if(date_selected3.equals(null)){
							date_selected3="";
						}
						else{
							try {
								date_4=sdf.parse(date_selected3);
								 eventdate3 = destDf.format(date_4);
							} catch (ParseException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
						}
						if(starttime_selected1.equals(null)){
							starttime_selected1="";
						}
						if(starttime_selected2.equals(null)){
							starttime_selected2="";
						}
						if(starttime_selected3.equals(null)){
							starttime_selected3="";
						}
						if(endtime_selected3.equals(null)){
							endtime_selected3="";
						}
						if(endtime_selected2.equals(null)){
							endtime_selected2="";
						}
						if(endtime_selected1.equals(null)){
							endtime_selected1="";
						}
						cd=new ConnectionDetector(getActivity());
						 isInternetPresent = cd.isConnectingToInternet();
						 if (isInternetPresent) {
								new create_event().execute();
						 }
						 else{
							 Toast.makeText(getActivity(),"Please check internet connection",2000).show();
							
						 }
						
					
						
					}
					else{
						Toast.makeText(getActivity(), "No field will left blank", 2000).show();
						return;
					}
				
			}
		});
		
		
		
date1.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
			i=2;
			count_alert=0;
date_dialog=1;
				 Calendar c = Calendar.getInstance();

				myYear = c.get(Calendar.YEAR);
				myMonth = c.get(Calendar.MONTH);
				myDay = c.get(Calendar.DAY_OF_MONTH);
				try {
					String date_from_edit_text=date1.getText().toString();
					if(date_from_edit_text.equals("")||date_from_edit_text.equals(null)){
						
					}else{
						String[] dateArr = date_from_edit_text.split("-");
						
						myDay=Integer.parseInt(dateArr[0]);
						myMonth=Integer.parseInt(dateArr[1])-1;
						myYear=Integer.parseInt(dateArr[2]);
					}
					
				} catch (Exception e) {
					// TODO: handle exception
				}
				DatePickerDialog d = new DatePickerDialog(getActivity(),
				         mDateSetListener, myYear, myMonth, myDay);
			
				d.show();
			}
		});
		starttime1.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				i=2;
				start_dialog=1;
				clicke_on_timepicker=true;
				TimePickerDialog tiiPickerDialog = new TimePickerDialog(getActivity(), mTimelistener, hours, minutes, true);
				tiiPickerDialog.setTitle("START TIME");
				tiiPickerDialog.show();
			}
		});
		endtime1.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				end_dialog=1;
				i=2;
				clicke_on_timepicker=true;
				TimePickerDialog tiiPickerDialog = new TimePickerDialog(getActivity(), mTimelistenerto, hours, minutes, true);
				tiiPickerDialog.setTitle("END TIME");
				tiiPickerDialog.show();
			}
		});
		
		
date2.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
			i=3;
			count_alert=0;
				date_dialog=2;
				 Calendar c = Calendar.getInstance();

				myYear = c.get(Calendar.YEAR);
				myMonth = c.get(Calendar.MONTH);
				myDay = c.get(Calendar.DAY_OF_MONTH);
				try {
					String date_from_edit_text=date2.getText().toString();
					if(date_from_edit_text.equals("")||date_from_edit_text.equals(null)){
						
					}else{
						String[] dateArr = date_from_edit_text.split("-");
						
						myDay=Integer.parseInt(dateArr[0]);
						myMonth=Integer.parseInt(dateArr[1])-1;
						myYear=Integer.parseInt(dateArr[2]);
					}
					
				} catch (Exception e) {
					// TODO: handle exception
				}
				DatePickerDialog d = new DatePickerDialog(getActivity(),
				         mDateSetListener, myYear, myMonth, myDay);
			
				d.show();
			}
		});
		starttime2.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				start_dialog=2;
				i=3;
				clicke_on_timepicker=true;
				TimePickerDialog tiiPickerDialog = new TimePickerDialog(getActivity(), mTimelistener, hours, minutes, true);
				tiiPickerDialog.setTitle("START TIME");
				tiiPickerDialog.show();
			}
		});
		endtime2.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				end_dialog=2;
				i=3;
				clicke_on_timepicker=true;
				TimePickerDialog tiiPickerDialog = new TimePickerDialog(getActivity(), mTimelistenerto, hours, minutes, true);
				tiiPickerDialog.setTitle("END TIME");
				tiiPickerDialog.show();
			}
		});
		
		
		
date3.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				count_alert=0;
				date_dialog=3;
				 Calendar c = Calendar.getInstance();

				myYear = c.get(Calendar.YEAR);
				myMonth = c.get(Calendar.MONTH);
				myDay = c.get(Calendar.DAY_OF_MONTH);
				try {
					String date_from_edit_text=date3.getText().toString();
					if(date_from_edit_text.equals("")||date_from_edit_text.equals(null)){
						
					}else{
						String[] dateArr = date_from_edit_text.split("-");
						
						myDay=Integer.parseInt(dateArr[0]);
						myMonth=Integer.parseInt(dateArr[1])-1;
						myYear=Integer.parseInt(dateArr[2]);
					}
					
				} catch (Exception e) {
					// TODO: handle exception
				}
				DatePickerDialog d = new DatePickerDialog(getActivity(),
				         mDateSetListener, myYear, myMonth, myDay);
			
				d.show();
			}
		});
		starttime3.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				start_dialog=3;
				clicke_on_timepicker=true;
				TimePickerDialog tiiPickerDialog = new TimePickerDialog(getActivity(), mTimelistener, hours, minutes, true);
				tiiPickerDialog.setTitle("START TIME");
				tiiPickerDialog.show();
			}
		});
		endtime3.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				end_dialog=3;
				clicke_on_timepicker=true;
				TimePickerDialog tiiPickerDialog = new TimePickerDialog(getActivity(), mTimelistenerto, hours, minutes, true);
				tiiPickerDialog.setTitle("END TIME");
				tiiPickerDialog.show();
			}
		});
		
		
alternatedatetime.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
		
				/*String date_pick=date.getText().toString();
				String start_pick=starttime.getText().toString();
				String end_pick=endtime.getText().toString();*/
				if(i==1){
				if(date_of_event.getText().toString().length()>0 && time_of_event.getText().toString().length()>0 && end_time_txt.getText().toString().length()>0){
					block1_date.setVisibility(View.VISIBLE);
					block1_endtime.setVisibility(View.VISIBLE);
					block1_starttime.setVisibility(View.VISIBLE);
				}else{
					Toast.makeText(getActivity(), "Date, Start time and End time can not be null",2000).show();
				}
				}else if(i==2){
					if(date1.getText().toString().length()>0 && starttime1.getText().toString().length()>0 && endtime1.getText().toString().length()>0){
						block2_date.setVisibility(View.VISIBLE);
						block2_endtime.setVisibility(View.VISIBLE);
						block2_starttime.setVisibility(View.VISIBLE);				
					}else{
						Toast.makeText(getActivity(), "Date1, Start time1 and End time1 can not be null",2000).show();
					}
					
				}else if(i==3){
					if(date2.getText().toString().length()>0 && starttime2.getText().toString().length()>0 && endtime2.getText().toString().length()>0){
						block3_date.setVisibility(View.VISIBLE);
						block3_endtime.setVisibility(View.VISIBLE);
						block3_starttime.setVisibility(View.VISIBLE);				
					}else{
						Toast.makeText(getActivity(), "Date2, Start time2 and End time2 can not be null",2000).show();
					}
					
				}
				
			}
		});
		
date_of_event.setOnClickListener(new OnClickListener() {
	
	@Override
	public void onClick(View v) {
		count_alert=0;
	if(clicked==false){
		
	}else{
		
		i=1;

		 Calendar c = Calendar.getInstance();

		myYear = c.get(Calendar.YEAR);
		myMonth = c.get(Calendar.MONTH);
		myDay = c.get(Calendar.DAY_OF_MONTH);
		try {
			String date_from_edit_text=date_of_event.getText().toString();
			if(date_from_edit_text.equals("")||date_from_edit_text.equals(null)){
				
			}else{
				String[] dateArr = date_from_edit_text.split("-");
				
				myDay=Integer.parseInt(dateArr[0]);
				myMonth=Integer.parseInt(dateArr[1])-1;
				myYear=Integer.parseInt(dateArr[2]);
			}
			
		} catch (Exception e) {
			// TODO: handle exception
		}
		DatePickerDialog d = new DatePickerDialog(getActivity(),
		         mDateSetListener, myYear, myMonth, myDay);
	
		d.show();
	}
	}
});
time_of_event.setOnClickListener(new OnClickListener() {
	
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		if(clicked==false){
			
		}else{
		i=1;
		clicke_on_timepicker=true;
		TimePickerDialog tiiPickerDialog = new TimePickerDialog(getActivity(), mTimelistener, hours, minutes, true);
		tiiPickerDialog.setTitle("START TIME");
		tiiPickerDialog.show();
	}}
});
end_time_txt.setOnClickListener(new OnClickListener() {
	
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		if(clicked==false){
			
		}else{
		i=1;
		clicke_on_timepicker=true;
		TimePickerDialog tiiPickerDialog = new TimePickerDialog(getActivity(), mTimelistenerto, hours, minutes, true);
		tiiPickerDialog.setTitle("END TIME");
		tiiPickerDialog.show();
	}
	}
});
		
		
		
		return view;
	}
	
	DatePickerDialog.OnDateSetListener mDateSetListener = new DatePickerDialog.OnDateSetListener() {

		

	    public void onDateSet(DatePicker view, int year,
	            int monthOfYear, int dayOfMonth) {
	       /* myYear = year;
	        myMonth = monthOfYear;
	        myDay = dayOfMonth;*/
	        monthOfYear=monthOfYear+1;
	        String day=String.valueOf(dayOfMonth);
	        String month=String.valueOf(monthOfYear);
	        String year1=String.valueOf(year);
	        int i=day.length();
	        if(i==1){
	        	day="0"+day;
	        	
	        }
	        int i1=month.length();
	        if(i1==1){
	        	month="0"+month;
	        	
	        }
	        int i2=year1.length();
	        if(i2==1){
	        	year1="0"+year1;
	        	
	        }
	       String date_generated=day+"-"+month+"-"+year1; 
	       
	       try{

			      SimpleDateFormat formatter = new SimpleDateFormat("dd-MM-yyyy");
			       Date date1_1 = formatter.parse(date_generated);
			       Date date2_2 = formatter.parse(date_comparision);
			    if (date1_1.compareTo(date2_2)<0)
			    {
			    	if(count_alert==0){
			    		count_alert=count_alert+1;
			    	new AlertDialog.Builder(getActivity())
					
				    .setTitle("Invalid Entry")
				    .setMessage("can't select past date for event creation")
				    .setPositiveButton("OK", new DialogInterface.OnClickListener() {
				        public void onClick(DialogInterface dialog, int which) { 
				        		return;			        	
				        }
				     })
				   
				    .setIcon(android.R.drawable.ic_dialog_alert)
				     .show();
			    	}
				                    
			    }else{
			    	count_alert=0;
			    	if(date_dialog==0){
				    	   date_of_event.setText(date_generated);
				       }
				       if(date_dialog==1){
					       date1.setText(date_generated);
					       }
				       if(date_dialog==2){
					       date2.setText(date_generated);
					       }
				       if(date_dialog==3){
					       date3.setText(date_generated);
					       }
			    }
			 } catch (ParseException e1) 
		      {
		    // TODO Auto-generated catch block
		    e1.printStackTrace();
		                        }
	       
	       
	       
	    }
	};
	TimePickerDialog.OnTimeSetListener mTimelistener = new TimePickerDialog.OnTimeSetListener() {
		
		@Override
		public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
			// TODO Auto-generated method stub
			if(clicke_on_timepicker==true){
				clicke_on_timepicker=false;
			String hour_s=String.valueOf(hourOfDay);
			int length=hour_s.length();
			if(length==1){
				hour_s="0"+String.valueOf(hourOfDay);
			}
			String minut_s=String.valueOf(minute);
			int length1=minut_s.length();
			if(length1==1){
				minut_s="0"+String.valueOf(minute);
			}
			
			
			 time=hour_s+":"+minut_s;
			 if(time_to.equals("")||time.equals(null)){
				 if(start_dialog==0){
					 time_of_event.setText(time);
				       }
				       if(start_dialog==1){
				    	   starttime1.setText(time);
					       }
				       if(start_dialog==2){
				    	   starttime2.setText(time);
					       }
				       if(start_dialog==3){
				    	   starttime3.setText(time);
					       }
			 }else{
				 String pattern = "HH:mm";
		            SimpleDateFormat sdf = new SimpleDateFormat(pattern);
		            try {
		                Date date1_1 = sdf.parse(time);
		                Date date2_1 = sdf.parse(time_to);

		                
		                if(date1_1.compareTo(date2_1)>0 || date1_1.compareTo(date2_1)==0){
		                	
					    	new AlertDialog.Builder(getActivity())
							
						    .setTitle("Invalid Entry")
						    .setMessage("Start time can't greater than or equal start time")
						    .setPositiveButton("OK", new DialogInterface.OnClickListener() {
						        public void onClick(DialogInterface dialog, int which) { 
						        		return;			        	
						        }
						     })
						   
						    .setIcon(android.R.drawable.ic_dialog_alert)
						     .show();
					    	
		                }else{
		                	 if(start_dialog==0){
		        				 time_of_event.setText(time);
		        			       }
		        			       if(start_dialog==1){
		        			    	   starttime1.setText(time);
		        				       }
		        			       if(start_dialog==2){
		        			    	   starttime2.setText(time);
		        				       }
		        			       if(start_dialog==3){
		        			    	   starttime3.setText(time);
		        				       }
		                }
		                
		              

		            } catch (ParseException e){
		                // Exception handling goes here
		            }
			 }
			 
			
			    }
			 
		}
		
	};
TimePickerDialog.OnTimeSetListener mTimelistenerto = new TimePickerDialog.OnTimeSetListener() {
		
		@Override
		public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
			// TODO Auto-generated method stub
			if(clicke_on_timepicker==true){
				clicke_on_timepicker=false;
			String hour_s=String.valueOf(hourOfDay);
			int length=hour_s.length();
			if(length==1){
				hour_s="0"+String.valueOf(hourOfDay);
			}
			String minut_s=String.valueOf(minute);
			int length1=minut_s.length();
			if(length1==1){
				minut_s="0"+String.valueOf(minute);
			}
			
			
			 time_to=hour_s+":"+minut_s;
			
			 if(time.equals("")||time.equals(null)){
				 if(end_dialog==0){
					 end_time_txt.setText(time_to);
				       }
				       if(end_dialog==1){
				    	   endtime1.setText(time_to);
					       }
				       if(end_dialog==2){
				    	   endtime2.setText(time_to);
					       }
				       if(end_dialog==3){
				    	   endtime3.setText(time_to);
					       }
				}else{
				 String pattern = "HH:mm";
		            SimpleDateFormat sdf = new SimpleDateFormat(pattern);
		            try {
		                Date date1_1 = sdf.parse(time);
		                Date date2_1 = sdf.parse(time_to);

		                
		                if(date1_1.compareTo(date2_1)>0 || date1_1.compareTo(date2_1)==0){
		                	
					    	new AlertDialog.Builder(getActivity())
							
						    .setTitle("Invalid Entry")
						    .setMessage("End Time can't less than or equal start time")
						    .setPositiveButton("OK", new DialogInterface.OnClickListener() {
						        public void onClick(DialogInterface dialog, int which) { 
						        		return;			        	
						        }
						     })
						   
						    .setIcon(android.R.drawable.ic_dialog_alert)
						     .show();
					    	
		                }else{
		                	 if(end_dialog==0){
		        				 end_time_txt.setText(time_to);
		        			       }
		        			       if(end_dialog==1){
		        			    	   endtime1.setText(time_to);
		        				       }
		        			       if(end_dialog==2){
		        			    	   endtime2.setText(time_to);
		        				       }
		        			       if(end_dialog==3){
		        			    	   endtime3.setText(time_to);
		        				       }
		                }
		                
		                // Outputs -1 as date1 is before date2
		               /* System.out.println(date1.compareTo(date2));

		                // Outputs 1 as date1 is after date1
		                System.out.println(date2.compareTo(date1));

		                date2 = sdf.parse("19:28");         
		                // Outputs 0 as the dates are now equal
		                System.out.println(date1.compareTo(date2));*/

		            } catch (ParseException e){
		                // Exception handling goes here
		            }
				 
				 
				}
			 
			
			}
		}
};
	
	public  class accept_reject extends AsyncTask<String, Integer, String>{
		ProgressDialog dialog=new ProgressDialog(getActivity());
		String url;
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
				url="http://54.191.67.152/playdate/event_accept_or_reject.php";//?event_id=64&status=rejected;
				}
			
			
			@Override
			protected String doInBackground(String... arg0) {
				// TODO Auto-generated method stub
				
				
					HttpClient httpClient = new DefaultHttpClient();
			        HttpContext localContext = new BasicHttpContext();
			        HttpPost httpPost = new HttpPost(url);

			        
			      ArrayList<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();
			      nameValuePairs.add(new BasicNameValuePair("event_id",event_id));
			      nameValuePairs.add(new BasicNameValuePair("status",ststus_of_event));
			     
			    
			      
					
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
					
					
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			      
			       
			      
				
				
				return null;
			}
			
			protected void onPostExecute(String resultt) {
				

				dialog.dismiss();
				if(data.equals("1")){
				
				Bundle bundle = new Bundle();
				bundle.putString("user_guardian_id", guardian_id);
				android.support.v4.app.Fragment  fragment=new Home_fragment();
		        fragment.setArguments(bundle);
				android.support.v4.app.FragmentManager fragmentManager = getFragmentManager();
				fragmentManager.beginTransaction()
				        .replace(R.id.content_frame, fragment).commit();
				
				}
				else{
					Toast.makeText(getActivity(),"Please Try again Later", 2000).show();	
					Bundle bundle = new Bundle();
					bundle.putString("user_guardian_id", guardian_id);
					android.support.v4.app.Fragment  fragment=new Home_fragment();
			        fragment.setArguments(bundle);
					android.support.v4.app.FragmentManager fragmentManager = getFragmentManager();
					fragmentManager.beginTransaction()
					        .replace(R.id.content_frame, fragment).commit();
					}
	}
	/*@Override
    public void destroyItem(ViewGroup container, int position, Object object) {
        // TODO Auto-generated method stub

            FragmentManager manager = ((Fragment) object).getFragmentManager();
            FragmentTransaction trans = manager.beginTransaction();
            trans.remove((Fragment) object);
            trans.commit();

        super.destroyItem(container, position, object);
    }*/
}
	
	public  class create_event extends AsyncTask<String, Integer, String>{
		ProgressDialog dialog=new ProgressDialog(getActivity());
			@Override
		protected void onPreExecute() {
				
				dialog.setMessage("Loading.......please wait");
				dialog.setCancelable(false);
				dialog.show();
				url_create="http://54.191.67.152/playdate/event_edit.php";//?child_id=68&friend_childid=69&date=31-5-2014&starttime=11:04&endtime=3:00&date1=31-1-2014&starttime1=12:34&endtime1=4:00&date2=28-3-2014&starttime2=1:34&endtime2=7:00&date3=3-4-2014&starttime3=2:34&endtime3=6:00&location=delhi&notes=abc&publish=1&event_id=";
			}
			//http://54.191.67.152/playdate/event_edit.php?starttime=1:03AM&publish=1&friend_childid=323&child_id=325&location=LOCATION&g_id=100001122280002&receiver_id=100001122280002&notes=NOTES&endtime=1:01AM&event_id=17&receiver_status=requested&date=2020/07/16
			@Override
			protected String doInBackground(String... arg0) {
				
				HttpClient httpClient = new DefaultHttpClient();
		        HttpContext localContext = new BasicHttpContext();
		        HttpPost httpPost = new HttpPost(url_create);
		       
		        ArrayList<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();
		        nameValuePairs.add(new BasicNameValuePair("child_id",child_id));
		        nameValuePairs.add(new BasicNameValuePair("friend_childid",friend_id));
		        nameValuePairs.add(new BasicNameValuePair("date",eventdate));
		        nameValuePairs.add(new BasicNameValuePair("starttime",starttime_selected));
		        nameValuePairs.add(new BasicNameValuePair("endtime",endtime_selected));
		        
		        nameValuePairs.add(new BasicNameValuePair("date1",eventdate1));
		        nameValuePairs.add(new BasicNameValuePair("starttime1",starttime_selected1));
		        nameValuePairs.add(new BasicNameValuePair("endtime1",endtime_selected1));
		        
		        nameValuePairs.add(new BasicNameValuePair("date2",eventdate2));
		        nameValuePairs.add(new BasicNameValuePair("g_id",guardian_id));
		        System.out.println("guardian id"+guardian_id);
		        nameValuePairs.add(new BasicNameValuePair("receiver_id",sender_id));
		        System.out.println("receiver id"+sender_id);
		        nameValuePairs.add(new BasicNameValuePair("starttime2",starttime_selected2));
		        nameValuePairs.add(new BasicNameValuePair("endtime2",endtime_selected2));
		        
		        nameValuePairs.add(new BasicNameValuePair("date3",eventdate3));
		        nameValuePairs.add(new BasicNameValuePair("starttime3",starttime_selected3));
		        nameValuePairs.add(new BasicNameValuePair("endtime3",endtime_selected3));
		        
		        nameValuePairs.add(new BasicNameValuePair("location",location_of_event));
		        
		        nameValuePairs.add(new BasicNameValuePair("notes",notes));
		        
		        nameValuePairs.add(new BasicNameValuePair("event_id",event_id));
		        nameValuePairs.add(new BasicNameValuePair("publish","1"));
		        
		        StringBuilder sbb = new StringBuilder();

				sbb.append("http://54.191.67.152/playdate/event_edit.php?");
				sbb.append(nameValuePairs.get(0)+"&");
				sbb.append(nameValuePairs.get(1)+"&");
				
				sbb.append(nameValuePairs.get(2)+"&");
				sbb.append(nameValuePairs.get(3)+"&");
				sbb.append(nameValuePairs.get(4)+"&");
				sbb.append(nameValuePairs.get(5)+"&");
				sbb.append(nameValuePairs.get(6)+"&");
				sbb.append(nameValuePairs.get(7)+"&");
				sbb.append(nameValuePairs.get(8)+"&");
				sbb.append(nameValuePairs.get(9)+"&");
				sbb.append(nameValuePairs.get(10)+"&");
				sbb.append(nameValuePairs.get(11)+"&");
				sbb.append(nameValuePairs.get(12)+"&");
				sbb.append(nameValuePairs.get(13)+"&");
				sbb.append(nameValuePairs.get(14)+"&");
				sbb.append(nameValuePairs.get(15)+"&");
				sbb.append(nameValuePairs.get(16)+"&");
				sbb.append(nameValuePairs.get(17)+"&");
				sbb.append(nameValuePairs.get(18)+"&");
				sbb.append(nameValuePairs.get(19));
				System.out.println(sbb);
		        try {
					httpPost.setEntity(new UrlEncodedFormEntity(nameValuePairs));

					System.out.println(httpPost);
				} catch (UnsupportedEncodingException e1) {
					e1.printStackTrace();
				}


		        HttpResponse response = null;
				try {
					response = httpClient.execute(httpPost,
					        localContext);
				} catch (ClientProtocolException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}
		        BufferedReader reader = null;
				try {
					reader = new BufferedReader(
					        new InputStreamReader(
					                response.getEntity().getContent(), "UTF-8"));
				} catch (UnsupportedEncodingException e) {
					e.printStackTrace();
				} catch (IllegalStateException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}

		        try {
					String sResponse = reader.readLine();
					
					System.out.println("response"+sResponse);
					JSONObject json;
					try {
						json = new JSONObject(sResponse);
						
						
						 success=json.getString("success");
						
						 
					} catch (JSONException e) {
						e.printStackTrace();
					}
					
					
						
				} catch (IOException e) {
					e.printStackTrace();
				}
		        
		        
				return null;
			}
		protected void onPostExecute(String resultt) {
				dialog.dismiss();
				if(success.equals("1")){
					
					Bundle bundle = new Bundle();
					bundle.putString("user_guardian_id", guardian_id);
					android.support.v4.app.Fragment  fragment=new Home_fragment();
			        fragment.setArguments(bundle);
					android.support.v4.app.FragmentManager fragmentManager = getFragmentManager();
					fragmentManager.beginTransaction()
.replace(R.id.content_frame, fragment).commit();
					
					}
					else{
						Toast.makeText(getActivity(),"Please Try again Later", 2000).show();	
						Bundle bundle = new Bundle();
						bundle.putString("user_guardian_id", guardian_id);
						android.support.v4.app.Fragment  fragment=new Home_fragment();
				        fragment.setArguments(bundle);
						android.support.v4.app.FragmentManager fragmentManager = getFragmentManager();
						fragmentManager.beginTransaction()
						        .replace(R.id.content_frame, fragment).commit();
						}		
		}
	}
	
}
