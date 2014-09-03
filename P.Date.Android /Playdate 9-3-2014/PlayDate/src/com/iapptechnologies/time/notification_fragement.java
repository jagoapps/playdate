package com.iapptechnologies.time;

import java.io.BufferedReader;
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
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Notification;
import android.app.ProgressDialog;
import android.content.Context;
import android.graphics.Color;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.iapp.playdate.R;
import com.iapptechnologies.time.Friend_profile.LazyAdapter.ViewHolder;
import com.iapptechnologies.time.Home_fragment.LazyAdapter;
import com.iapptechnologies.time.models.NotificationModels;

public class notification_fragement extends android.support.v4.app.Fragment {
	String user_guardian_id;
	ListView list_home;
	ConnectionDetector cd;
	DB_Helper db;
	Boolean isInternetPresent = false;
	String[] stringarray;
	ArrayList<Getcatagory_forlist> params = new ArrayList<Getcatagory_forlist>();
	ArrayList<NotificationModels>modelsDataList;
	
	public notification_fragement() {

	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {

		ViewGroup view = (ViewGroup) inflater.inflate(R.layout.home, container,
				false);
		db = new DB_Helper(getActivity());
		modelsDataList=new ArrayList<NotificationModels>();
		
		user_guardian_id = getArguments().getString("user_guardian_id");
		list_home = (ListView) view.findViewById(R.id.listView1_home);
		cd = new ConnectionDetector(getActivity());
		isInternetPresent = cd.isConnectingToInternet();
		if (isInternetPresent) {
			new getEvents_detail().execute();
		} else {
			Toast.makeText(getActivity(), "Please check internet connection",
					2000).show();
			return view;
		}

		return view;
	}

	public class getEvents_detail extends AsyncTask<String, Integer, String> {
		ProgressDialog dialog = new ProgressDialog(getActivity());
		String url;
		InputStream is;
		String result;
		JSONObject jArray = null;
		String data;
		Element_notification adapter;
		

		@Override
		protected void onPreExecute() {
			dialog.setMessage("Loading.......please wait");
			dialog.setCancelable(false);
			dialog.show();
			url = "http://54.191.67.152/playdate/admin_push_msg.php";// ?g_id=46;
																		// get
																		// event
		}

		@Override
		protected String doInBackground(String... arg0) {
			HttpClient httpClient = new DefaultHttpClient();
			HttpContext localContext = new BasicHttpContext();
			HttpPost httpPost = new HttpPost(url);
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

				System.out.println("response" + sResponse);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			try {
				JSONObject json = new JSONObject(sResponse);

				JSONArray jarray = json.getJSONArray("data");
				//String[] stringarray = new String[jarray.length()];
				
				for (int i = 0; i < jarray.length(); i++) {
					NotificationModels nn=new NotificationModels();
					String aa= jarray.getString(i);
					
					nn.setNotificationData(aa);
					modelsDataList.add(nn);
					Log.e(aa, ""+modelsDataList.size());
					
				}
				
//				ArrayAdapter<String> adapter = new ArrayAdapter<String>(this,
//						android.R.layout.simple_list_item_1, stringarray);
//				list.setAdapter(adapter);
			}

			catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			return null;
		}

		@SuppressLint("CommitPrefEdits")
		protected void onPostExecute(String resultt) {
			adapter = new Element_notification(getActivity(), modelsDataList);

			list_home.setAdapter(adapter);
			//ArrayAdapter<String> ad=new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, stringarray);
			dialog.dismiss();

		}
	}

	class Element_notification extends BaseAdapter{
		private Activity activity;
		private ArrayList<NotificationModels> _items;
		private LayoutInflater inflater = null;
		
		
		public Element_notification(Activity activity, ArrayList<NotificationModels> parentItems) {

			// this.imageLoader.clearCache();
			this.activity = activity;
			this._items = parentItems;
			inflater = (LayoutInflater) getActivity()
					.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		}
		
		@Override
		public int getCount() {
			// TODO Auto-generated method stub
			return modelsDataList.size();
		}

		@Override
		public Object getItem(int position) {
			// TODO Auto-generated method stub
			return position;
		}

		@Override
		public long getItemId(int position) {
			// TODO Auto-generated method stub
			return position;
		}

		class ViewHolder {
			public TextView Notification;
		}
		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			// TODO Auto-generated method stub
			View vi = convertView;
			ViewHolder _holder;
			if (convertView == null) {
				convertView = inflater
						.inflate(R.layout.notification_list, null);
				_holder = new ViewHolder();

				_holder.Notification = (TextView) convertView
						.findViewById(R.id.txtView1);
				
				// _holder.event_date = (TextView) convertView
				// .findViewById(R.id.event_date);
				convertView.setTag(_holder);
			} else {
				_holder = (ViewHolder) convertView.getTag();
			}
			String notification_value=_items.get(position).getNotificationData();
			Log.e(notification_value, ""+notification_value);
			_holder.Notification.setText(notification_value);
		//	_holder.Notification.setBackgroundColor(getResources().getColor(R.color.bg_color));
			convertView.setBackgroundColor(Color.parseColor("#ffffff"));
			
				
			return convertView;
		}
		
	}
	

}
