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
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.iapp.playdate.R;


public class Home_fragment extends android.support.v4.app.Fragment {
	String 	 user_guardian_id;
	ListView list_home;
	ConnectionDetector cd;
	DB_Helper db;
	Boolean isInternetPresent = false;
	ArrayList<Getcatagory_forlist>params= new ArrayList<Getcatagory_forlist>();
	public Home_fragment(){
		
	}
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {

		ViewGroup view = (ViewGroup) inflater.inflate(R.layout.home, container,
                false);
		db=new DB_Helper(getActivity());
		 user_guardian_id = getArguments().getString("user_guardian_id"); 
		 list_home=(ListView)view.findViewById(R.id.listView1_home);
		 cd=new ConnectionDetector(getActivity());
		 isInternetPresent = cd.isConnectingToInternet();
		 if (isInternetPresent) {
			 new  getEvents_detail().execute();
		 }
		 else{
			 Toast.makeText(getActivity(),"Please check internet connection",2000).show();
			 return view;
		 }
		 
			view.setFocusableInTouchMode(true);
			view.requestFocus();
			view.setOnKeyListener(new View.OnKeyListener() {
			        @Override
			        public boolean onKey(View v, int keyCode, KeyEvent event) {
			            //Log.i(tag, "keyCode: " + keyCode);
			            if( keyCode == KeyEvent.KEYCODE_BACK ) {
			                  //  Log.i(tag, "onKey Back listener is working!!!");
			            	Log.e("ONBackPressed==","WorkingNow");
			                getFragmentManager().popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
			               
//			                Intent intent = new Intent(Intent.ACTION_MAIN);
//			                intent.addCategory(Intent.CATEGORY_HOME);
//			                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//			                intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
//			                startActivity(intent);
			                
			                getActivity().finish();
			             
			                
			                return true;
			            } else {
			                return false;
			            }
			        }
			    });
		 
		 
		 
		 list_home.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {
				 ArrayList<Getcatagory_forlist> _items;
			        _items=params;
			        
			        
				String child_name=_items.get(arg2).child_name;
				String Child_id=_items.get(arg2).child_id;
				String Child_profilepic=_items.get(arg2).child_profile_image;
				String Child_friend_name=_items.get(arg2).childfriend_name;
				String Child_frient_id=_items.get(arg2).friend_id;
				String Child_friend_pic=_items.get(arg2).friendprofile_image;
				//String Child_guardianId=_items.get(arg2).guardian_id;
				String event_id=_items.get(arg2).eventid;
				String event_date=_items.get(arg2).date_ofevent;
				String event_start=_items.get(arg2).start_time_of_event;
				String event_end_time=_items.get(arg2).end_time_of_event;
				String notes=_items.get(arg2).notes_event;
				String location_ofevent=_items.get(arg2).location_event;
				String sender_id=_items.get(arg2).senderid;
				String receiver_id=_items.get(arg2).receiverid;
				String status_of_event_=_items.get(arg2).status_ofevent;
				
				String date1_event=_items.get(arg2).date_of_event1;
				String date2_event=_items.get(arg2).date_of_event2;
				String date3_event=_items.get(arg2).date_of_event3;
				
				String start_time1_event=_items.get(arg2).start_time_of_event1;
				String start_time2_event=_items.get(arg2).start_time_of_event2;
				String start_time3_event=_items.get(arg2).start_time_of_event3;
				
				String end_time1_event=_items.get(arg2).end_time_of_event1;
				String end_time2_event=_items.get(arg2).end_time_of_event2;
				String end_time3_event=_items.get(arg2).end_time_of_event3;
				
				Bundle bundle = new Bundle();
				bundle.putString("child_name", child_name);
				bundle.putString("Child_id", Child_id);
				bundle.putString("Child_profilepic", Child_profilepic);
				bundle.putString("Child_friend_name", Child_friend_name);
				bundle.putString("Child_frient_id", Child_frient_id);
				bundle.putString("Child_friend_pic", Child_friend_pic);
				bundle.putString("Child_guardianId", user_guardian_id);
				bundle.putString("event_id", event_id);
				bundle.putString("event_date", event_date);
				bundle.putString("event_start", event_start);
				bundle.putString("event_end_time", event_end_time);
				bundle.putString("notes", notes);
				bundle.putString("sender_id", sender_id);
				bundle.putString("receiver_id", receiver_id);
				bundle.putString("status", status_of_event_);
				bundle.putString("location_ofevent", location_ofevent);
				bundle.putString("date1_event", date1_event);
				bundle.putString("date2_event", date2_event);
				bundle.putString("date3_event", date3_event);
				bundle.putString("start_time1_event", start_time1_event);
				bundle.putString("start_time2_event", start_time2_event);
				bundle.putString("start_time3_event", start_time3_event);
				bundle.putString("end_time1_event", end_time1_event);
				bundle.putString("end_time2_event", end_time2_event);
				bundle.putString("end_time3_event", end_time3_event);
				
				  android.support.v4.app.Fragment  fragment=new Event_accept_reject_edit();
                  fragment.setArguments(bundle);
				android.support.v4.app.FragmentManager fragmentManager = getFragmentManager();
				fragmentManager.beginTransaction()
				        .replace(R.id.content_frame, fragment).commit();
				
			}
		});
		 return view;
	}
	
	
	public  class getEvents_detail extends AsyncTask<String, Integer, String>{
		ProgressDialog dialog=new ProgressDialog(getActivity());
		String url;
		InputStream is;
		String result;
		JSONObject jArray = null;
		String data;
		LazyAdapter adapter;
			@Override
		protected void onPreExecute() {
				dialog.setMessage("Loading.......please wait");
				dialog.setCancelable(false);
				dialog.show();
				url="http://54.191.67.152/playdate/event_with.php";//?g_id=46;  get event
		}
			@Override
			protected String doInBackground(String... arg0) {
					HttpClient httpClient = new DefaultHttpClient();
			        HttpContext localContext = new BasicHttpContext();
			        HttpPost httpPost = new HttpPost(url);
			      ArrayList<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();
			      nameValuePairs.add(new BasicNameValuePair("g_id",user_guardian_id));
			      System.out.println(user_guardian_id);
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
					
				 JSONArray jarray= json.getJSONArray("data");
				 for(int i=0;i<jarray.length();i++){
					 JSONObject c=jarray.getJSONObject(i);
					 Getcatagory_forlist getcat= new Getcatagory_forlist();
					 String eventid=c.getString("Eventid");
					 String childname=c.getString("child_name");
					 String childid=c.getString("Child_id");
					 String childpicurl=c.getString("profile_image");
					 String friendname=c.getString("friendname");
					 String friendid=c.getString("friend_childid");
					 String friendpicurl=c.getString("friend_profile_image");
					 String parentname=c.getString("name");
					 String senderid=c.getString("senderid");
					 String receiverid=c.getString("receiver_id");
					 String parentpic=c.getString("parent_profile_image");
					 String date=c.getString("date");
					 String starttime=c.getString("Starttime");
					 String endtime=c.getString("endtime");
					 String location=c.getString("location");
					 String notes=c.getString("notes");
					 String status_ofevent=c.getString("status");
					//Alternate date/Time
					 String altdate1=c.getString("date1");
					 String altStarttime1=c.getString("Starttime1");
					 String altendtime1=c.getString("endtime1");
					 
					 String altdate2=c.getString("date2");
					 String altStarttime2=c.getString("Starttime2");
					 String altendtime2=c.getString("endtime2");
					 
					 String altdate3=c.getString("date3");
					 String altStarttime3=c.getString("Starttime3");
					 String altendtime3=c.getString("endtime3");
					 
					 //add alternate date/time to list
					 getcat.date_of_event1=altdate1;
					 getcat.date_of_event2=altdate2;
					 getcat.date_of_event3=altdate3;
					 
					 getcat.start_time_of_event1=altStarttime1;
					 getcat.start_time_of_event2=altStarttime2;
					 getcat.start_time_of_event2=altStarttime3;
					 
					 getcat.end_time_of_event1=altendtime1;
					 getcat.end_time_of_event3=altendtime2;
					 getcat.end_time_of_event3=altendtime3;
					 
					 getcat.child_id=childid;
					 getcat.child_name=childname;
					 getcat.child_profile_image=childpicurl;
					 getcat.childfriend_name=friendname;
					 getcat.date_ofevent=date;
					 getcat.end_time_of_event=endtime;
					 getcat.friend_id=friendid;
					 getcat.friendprofile_image=friendpicurl;
					// getcat.guardian_id=guardianid;
					 getcat.senderid=senderid;
					 getcat.receiverid=receiverid;
					 getcat.location_event=location;
					 getcat.parent_name=parentname;
					 getcat.notes_event=notes;
					 getcat.parent_profile_image=parentpic;
					 getcat.start_time_of_event=starttime;
					 getcat.status_ofevent=status_ofevent;
					 getcat.eventid=eventid;
					 //getcat.senderid=sender_id;
					 String date_of_event_with_time = null,date_of_event_with_end_time = null;
					try {
						 String[] timeArr_start = starttime.split(":");
						 String time_1=timeArr_start[0];
						 String time2=timeArr_start[1].substring(0, 2);
						 String[] timeArr_end = endtime.split(":");
						 String time_1_end=timeArr_end[0];
						 String time2_end=timeArr_end[1].substring(0, 2);
						 
						 int length_time=time_1.length();
						 if(length_time==1){
							 time_1="0"+time_1;
						 }
						 int length_time_end=time_1_end.length();
						 if(length_time_end==1){
							 time_1_end="0"+time_1_end;
						 }
						 System.out.println(time_1);
						 System.out.println(time2);
						 System.out.println(time_1_end);
						 System.out.println(time2_end);
						 
						  date_of_event_with_time=date+" "+time_1+":"+time2;
						  date_of_event_with_end_time=date+" "+time_1_end+":"+time2_end;
					} catch (Exception e) {
						// TODO: handle exception
						e.printStackTrace();
						date_of_event_with_time=date+ "" + starttime;
						date_of_event_with_end_time=date + " " + endtime;
					} 
				
					 if(status_ofevent.equalsIgnoreCase("accepted")){
					 DateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
						Date date_of_event = null;
						Date last_date_of_event=null;
						try {
							date_of_event = sdf.parse(date_of_event_with_time);
							last_date_of_event=sdf.parse(date_of_event_with_end_time);
						} catch (ParseException e) {
							
							e.printStackTrace();
						}
					 int check_event_exist=db.getevent_id(eventid);
					 if(check_event_exist==1){
						 
					 }else{
						 db.insert_into_table(eventid);
						 String eventUriString = "content://com.android.calendar/events";
						    ContentValues eventValues = new ContentValues();

						    eventValues.put("calendar_id", 1); 
						    long dtstart=date_of_event.getTime();
						    long lastdate=last_date_of_event.getTime();
						    eventValues.put("title", "Playdate Event");
						    eventValues.put("description", childname+" wants play with "+friendname);
						    eventValues.put("eventLocation", location);
                            eventValues.put("dtstart", dtstart);
						    eventValues.put("dtend", lastdate);
						    eventValues.put("eventStatus", "status"); // This information is
						    eventValues.put("eventTimezone", "US");
						    eventValues.put("hasAlarm", 1); // 0 for false, 1 for true

						    Uri eventUri = getActivity().getContentResolver().insert(Uri.parse(eventUriString), eventValues);
						    long eventID = Long.parseLong(eventUri.getLastPathSegment());
					 }
					 }
					 params.add(getcat);
					 
					 
				 }
					
					
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			      
			       
			      
				
				
				return null;
			}
			@SuppressLint("CommitPrefEdits")
			protected void onPostExecute(String resultt) {
				
				adapter = new LazyAdapter(getActivity(), params);

				list_home.setAdapter(adapter);
				dialog.dismiss();
				
				}
	}
	
	
	public class LazyAdapter extends BaseAdapter {
		String _imgurlchild = "",_imgurlfriend="",_imgparent="";
		private Activity activity;
		private ArrayList<Getcatagory_forlist> _items;
		private LayoutInflater inflater = null;

			public ImageLoader imageLoader;

		public LazyAdapter(Activity activity, ArrayList<Getcatagory_forlist> parentItems) {

			// this.imageLoader.clearCache();
			this.activity = activity;
			this._items = parentItems;
			inflater = (LayoutInflater) getActivity()
					.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			imageLoader = new ImageLoader(getActivity());
		}

		public int getCount() {
			return _items.size();
		}

		public Object getItem(int position) {
			return position;
		}

		public long getItemId(int position) {
			return position;
		}

		class ViewHolder {
			public TextView child_name,friend_name,date_odevent,status,time_start,parent_name,time_end;
			public ImageView _imageofchild,_imageoffriend,_imageofparent = null;

		}

		public View getView(final int position, View convertView,
				ViewGroup parent) {
			View vi = convertView;
			ViewHolder _holder;
			if (convertView == null) {
				convertView = inflater
						.inflate(R.layout.list_home_event, null);
				_holder = new ViewHolder();

				_holder.child_name = (TextView) convertView
						.findViewById(R.id.textView1_list_childname);
				_holder.friend_name = (TextView) convertView
						.findViewById(R.id.textView1_list_childfriend_name);
				_holder.parent_name = (TextView) convertView
						.findViewById(R.id.textView1_parent_name_list);
				
				_holder.date_odevent = (TextView) convertView
						.findViewById(R.id.textView3_dateofevent);
				_holder.status = (TextView) convertView
						.findViewById(R.id.textView4_status);
				_holder.time_start = (TextView) convertView
						.findViewById(R.id.textView2_time_ofevent);
				_holder.time_end = (TextView) convertView
						.findViewById(R.id.textView2_time_ofevent_end);
				_holder._imageofchild = (ImageView) convertView
						.findViewById(R.id.imageView1_list_child_pic);
				
				_holder._imageoffriend = (ImageView) convertView
						.findViewById(R.id.imageView1_childfriend_pic);
				_holder._imageofparent = (ImageView) convertView
						.findViewById(R.id.imageView1_paremt_pic_event);
				
			
				convertView.setTag(_holder);
			} else {
				_holder = (ViewHolder) convertView.getTag();
			}
			String name_of_child=_items.get(position).child_name;
			String name_of_childfriend=_items.get(position).childfriend_name;
			String name_of_childparent=_items.get(position).parent_name;
			String date_ofevent=_items.get(position).date_ofevent;
			

			 DateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
			 Date date_of_birth=null;
			 try {
				 date_of_birth=sdf.parse(date_ofevent);
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}//String reportDate = df.format(today);
			// birthDay=sdf.format(date_of_birth);
			 DateFormat destDf = new SimpleDateFormat("dd-MM-yyyy");
			 String date_of_event1 = destDf.format(date_of_birth);
			 
			
			
			String time_of_event=_items.get(position).start_time_of_event;
			String status=_items.get(position).status_ofevent;
			String end_time=_items.get(position).end_time_of_event;
			String status_caps=status.toUpperCase();
			
			if(status_caps.equalsIgnoreCase("ACCEPTED")){
				_holder.status.setTextColor(Color.parseColor("#7fce31"));
			}
			if(status_caps.equalsIgnoreCase("PENDING")){
				_holder.status.setTextColor(Color.parseColor("#9131ce"));
			}
			if(status_caps.equalsIgnoreCase("REQUESTED")){
				_holder.status.setTextColor(Color.parseColor("#ff0000"));
			}
			
			String name_of_child_caps=name_of_child.toUpperCase();
			
			String parent_name=name_of_childparent.toUpperCase();
			String name_of_childfriend_caps=name_of_childfriend.toUpperCase();
			_holder.child_name.setText(name_of_child_caps);
			_holder.friend_name.setText(name_of_childfriend_caps);
			_holder.date_odevent.setText(date_of_event1);
			_holder.status.setText(status_caps);
			_holder.time_start.setText(time_of_event);
			_holder.time_end.setText(end_time);
			_holder.parent_name.setText(parent_name);
			
		
			_imgurlchild = _items.get(position).child_profile_image;
			
			_imgurlfriend = _items.get(position).friendprofile_image;
			_imgparent = _items.get(position).parent_profile_image;
			
			
			_holder._imageofchild.setTag(_imgurlchild);
			_holder._imageoffriend.setTag(_imgurlfriend);
			_holder._imageofparent.setTag(_imgparent);
		
			imageLoader.DisplayImage(_imgurlchild,_holder._imageofchild);
			imageLoader.DisplayImage(_imgurlfriend,_holder._imageoffriend);
			imageLoader.DisplayImage(_imgparent,_holder._imageofparent);
			
			_holder._imageofchild.requestLayout();
			_holder._imageoffriend.requestLayout();
			_holder._imageofparent.requestLayout();
			 int density = getResources().getDisplayMetrics().densityDpi;
			  switch (density) {
			  case DisplayMetrics.DENSITY_LOW:
				  _holder._imageofchild.getLayoutParams().height = 40;
				  _holder._imageofchild.getLayoutParams().width = 40;
				  
				  _holder._imageoffriend.getLayoutParams().height = 40;
				  _holder._imageoffriend.getLayoutParams().width = 40;
				  
				  _holder._imageofparent.getLayoutParams().height = 40;
				  _holder._imageofparent.getLayoutParams().width = 40;
				 
				  break;
			  case DisplayMetrics.DENSITY_MEDIUM:
				  _holder._imageofchild.getLayoutParams().height = 70;
				  _holder._imageofchild.getLayoutParams().width = 70;
				  
				  _holder._imageoffriend.getLayoutParams().height = 70;
				  _holder._imageoffriend.getLayoutParams().width = 70;
				  
				  _holder._imageofparent.getLayoutParams().height = 70;
				  _holder._imageofparent.getLayoutParams().width = 70;
				 // child_list.setLayoutParams(new LayoutParams(90,90));
				  break;
			  case DisplayMetrics.DENSITY_HIGH:
				  _holder._imageofchild.getLayoutParams().height = 75;
				  _holder._imageofchild.getLayoutParams().width = 75;
				  _holder._imageoffriend.getLayoutParams().height = 75;
				  _holder._imageoffriend.getLayoutParams().width = 75;
				  
				  _holder._imageofparent.getLayoutParams().height = 75;
				  _holder._imageofparent.getLayoutParams().width = 75;
				//  child_list.setLayoutParams(new LayoutParams(110,110));
				  break;
			  case DisplayMetrics.DENSITY_XHIGH:
				  _holder._imageofchild.getLayoutParams().height = 120;
				  _holder._imageofchild.getLayoutParams().width = 120;
				  _holder._imageoffriend.getLayoutParams().height = 120;
				  _holder._imageoffriend.getLayoutParams().width = 120;
				  
				  _holder._imageofparent.getLayoutParams().height = 120;
				  _holder._imageofparent.getLayoutParams().width = 120;
				  break;
			  case DisplayMetrics.DENSITY_XXHIGH:
				  _holder._imageofchild.getLayoutParams().height = 120;
				  _holder._imageofchild.getLayoutParams().width = 120;
				  _holder._imageoffriend.getLayoutParams().height = 120;
				  _holder._imageoffriend.getLayoutParams().width = 120;
				  
				  _holder._imageofparent.getLayoutParams().height = 120;
				  _holder._imageofparent.getLayoutParams().width = 120;
				  break;
			  }
			
			return convertView;
		}

	}
	// Create new fragment and transaction

	
	
	
}
