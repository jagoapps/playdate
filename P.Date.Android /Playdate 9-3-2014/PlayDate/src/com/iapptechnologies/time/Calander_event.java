package com.iapptechnologies.time;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;

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

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.ContentValues;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.provider.CalendarContract;
import android.provider.CalendarContract.Events;
import android.text.format.DateFormat;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.iapp.playdate.R;

public class Calander_event extends android.support.v4.app.Fragment {

	public Calendar month;
	public CalendarAdapter adapter;
	public Handler handler;
	public ArrayList<String> items;
	public ArrayList<String> _date;
	public ArrayList<Getcatagory_forlist> params;
	public ArrayList<Getcatagory_forlist> params_systems_event;
	TextView title;
	String sResponse = null, user_guardian_id;
	ListView list_event;
	LazyAdapter adapter1;
	Boolean isInternetPresent = false;
	ConnectionDetector cd;
	JSONObject json_object = null;
	String data_json;
	boolean check_event = false;
	DB_Helper db;

	@Override
	public View onCreateView(final LayoutInflater inflater,
			ViewGroup container, Bundle savedInstanceState) {
		ViewGroup view = (ViewGroup) inflater.inflate(R.layout.calendar,
				container, false);

		user_guardian_id = getArguments().getString("user_guardian_id");
		list_event = (ListView) view.findViewById(R.id.listView_calander_event);
		month = Calendar.getInstance();
		onNewIntent();
		db = new DB_Helper(getActivity());
		items = new ArrayList<String>();
		_date = new ArrayList<String>();
		adapter = new CalendarAdapter(getActivity(), month);

		GridView gridview = (GridView) view.findViewById(R.id.gridview);
		gridview.setAdapter(adapter);

		title = (TextView) view.findViewById(R.id.title);
		title.setText(android.text.format.DateFormat.format("MMMM yyyy", month));
		cd = new ConnectionDetector(getActivity());
		isInternetPresent = cd.isConnectingToInternet();
		if (isInternetPresent) {
			new Get_Event().execute();

		} else {
			Toast.makeText(getActivity(), "Please check internet connection",
					2000).show();

		}
		/*
		 * String uriString = "content://com.android.calendar//events";
		 * Log.i("INFO", "Reading content from " + uriString);
		 * readContent(uriString);
		 */

		TextView previous = (TextView) view.findViewById(R.id.previous);
		previous.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				if (month.get(Calendar.MONTH) == month
						.getActualMinimum(Calendar.MONTH)) {
					month.set((month.get(Calendar.YEAR) - 1),
							month.getActualMaximum(Calendar.MONTH), 1);
				} else {
					month.set(Calendar.MONTH, month.get(Calendar.MONTH) - 1);
				}
				refreshCalendar();
			}
		});

		TextView next = (TextView) view.findViewById(R.id.next);
		next.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				if (month.get(Calendar.MONTH) == month
						.getActualMaximum(Calendar.MONTH)) {
					month.set((month.get(Calendar.YEAR) + 1),
							month.getActualMinimum(Calendar.MONTH), 1);
				} else {
					month.set(Calendar.MONTH, month.get(Calendar.MONTH) + 1);
				}
				refreshCalendar();

			}
		});

		gridview.setOnItemClickListener(new OnItemClickListener() {
			public void onItemClick(AdapterView<?> parent, View v,
					int position, long id) {
				TextView date = (TextView) v.findViewById(R.id.date);
				if (date instanceof TextView && !date.getText().equals("")) {
					// v.setBackgroundResource(R.drawable.item_background_focused);
					// Intent intent = new Intent();
					String day = date.getText().toString();
					if (day.length() == 1) {
						day = "0" + day;
					}
					String date_for_gridviewshown = android.text.format.DateFormat
							.format("yyyy-MM", month) + "-" + day;
					String system_event_gridviewdate = android.text.format.DateFormat
							.format("MM", month) + "-" + day;
					// return chosen date as string format
					// intent.putExtra("date",
					// android.text.format.DateFormat.format("yyyy-MM",
					// month)+"-"+day);
					// setResult(RESULT_OK, intent);
					// finish();
					// int i=0;
					// params=new ArrayList<Getcatagory_forlist>();
					try {

						ArrayList<Getcatagory_forlist> searchList = new ArrayList<Getcatagory_forlist>();
						String search = "a";
						int searchListLength = params.size();
						for (int i = 0; i < searchListLength; i++) {

							String event_id = params.get(i).eventid;
							if (event_id.equals("-1")) {
								String date_for_gridview = params.get(i).date_ofevent;
								String[] dateArr = date_for_gridview.split("-"); // date
								String month_forcalander = dateArr[1];
								String date_forcalander = dateArr[2];
								String datecomparasion = month_forcalander
										+ "-" + date_forcalander;
								System.out
										.println("gridviewdate for comparision"
												+ datecomparasion);
								System.out.println("compare to"
										+ system_event_gridviewdate);
								if (system_event_gridviewdate
										.equals(datecomparasion)) {

									Getcatagory_forlist getcat = params.get(i);
									searchList.add(getcat);
								}
							} else {

								if (params.get(i).date_ofevent
										.contains(date_for_gridviewshown)) {
									// Do whatever you want here
									Getcatagory_forlist getcat = new Getcatagory_forlist();
									String child_name = params.get(i).child_name;
									System.out
											.println("child_namechild_namechild_name"
													+ child_name);
									String Child_id = params.get(i).child_id;
									String Child_profilepic = params.get(i).child_profile_image;
									String Child_friend_name = params.get(i).childfriend_name;
									String Child_frient_id = params.get(i).friend_id;
									String Child_friend_pic = params.get(i).friendprofile_image;
									// String
									// Child_guardianId=_items.get(arg2).guardian_id;

									String event_date = params.get(i).date_ofevent;
									String event_start = params.get(i).start_time_of_event;
									String event_end_time = params.get(i).end_time_of_event;
									String notes = params.get(i).notes_event;
									String location_ofevent = params.get(i).location_event;
									String sender_id = params.get(i).senderid;
									// String
									String  receiver_id=params.get(i).receiverid;
									String status_of_event_ = params.get(i).status_ofevent;

									getcat.child_id = Child_id;
									getcat.child_name = child_name;
									getcat.child_profile_image = Child_profilepic;
									getcat.childfriend_name = Child_friend_name;
									getcat.date_ofevent = event_date;
									getcat.end_time_of_event = event_end_time;
									getcat.friend_id = Child_frient_id;
									getcat.friendprofile_image = Child_friend_pic;
									// getcat.guardian_id=guardianid;
									getcat.senderid = sender_id;
								    getcat.receiverid=receiver_id;
									getcat.location_event = location_ofevent;
									// getcat.parent_name=parentname;
									getcat.notes_event = notes;
									// getcat.parent_profile_image=parentpic;
									getcat.start_time_of_event = event_start;
									getcat.status_ofevent = "ACCEPTED";
									getcat.eventid = event_id;
									searchList.add(getcat);
								}
							}
						}

						adapter1 = new LazyAdapter(getActivity(), searchList);

						list_event.setAdapter(adapter1);
					} catch (Exception e) {
						// TODO: handle exception
					}

				}

			}
		});

		list_event.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {
				ArrayList<Getcatagory_forlist> _items;
				_items = params;
				String event_id = _items.get(arg2).eventid;
				if (event_id.equals("-1")) {
					String child_name = _items.get(arg2).child_name;
					String event_date = _items.get(arg2).date_ofevent;
					AlertDialog.Builder builder = new AlertDialog.Builder(
							getActivity());
					builder.setTitle(child_name);
					builder.setMessage("DATE - " + event_date)
							.setPositiveButton("OK",
									new DialogInterface.OnClickListener() {
										public void onClick(
												DialogInterface dialog, int id) {
											// FIRE ZE MISSILES!
										}
									});
					builder.create();
					builder.show();

				} else {
					String child_name = _items.get(arg2).child_name;
					String Child_id = _items.get(arg2).child_id;
					String Child_profilepic = _items.get(arg2).child_profile_image;
					String Child_friend_name = _items.get(arg2).childfriend_name;
					String Child_frient_id = _items.get(arg2).friend_id;
					String Child_friend_pic = _items.get(arg2).friendprofile_image;
					// String Child_guardianId=_items.get(arg2).guardian_id;

					String event_date = _items.get(arg2).date_ofevent;
					String event_start = _items.get(arg2).start_time_of_event;
					String event_end_time = _items.get(arg2).end_time_of_event;
					String notes = _items.get(arg2).notes_event;
					String location_ofevent = _items.get(arg2).location_event;
					String sender_id = _items.get(arg2).senderid;
				    String receiver_id=_items.get(arg2).receiverid;
					String status_of_event_ = _items.get(arg2).status_ofevent;

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

					android.support.v4.app.Fragment fragment = new Event_accept_reject_edit();
					fragment.setArguments(bundle);
					android.support.v4.app.FragmentManager fragmentManager = getFragmentManager();
					fragmentManager.beginTransaction()
							.replace(R.id.content_frame, fragment).commit();
				}
			}
		});

		return view;
	}

	public void refreshCalendar() {

		adapter.refreshDays();
		adapter.notifyDataSetChanged();
		handler.post(calendarUpdater); // generate some random calendar items

		title.setText(android.text.format.DateFormat.format("MMMM yyyy", month));
	}

	public void onNewIntent() {
		/* String date = intent.getStringExtra("date"); */
		// String[] dateArr = date.split("-"); // date format is yyyy-mm-dd
		// month.set(Integer.parseInt(dateArr[0]), Integer.parseInt(dateArr[1]),
		// Integer.parseInt(dateArr[2]));

		/*
		 * Date now = new Date(); Date alsoNow =
		 * Calendar.getInstance().getTime(); String nowAsString = new
		 * SimpleDateFormat("yyyy-MM-dd").format(now);
		 */

		Calendar c = Calendar.getInstance();
		System.out.println("Current time => " + c.getTime());

		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		String formattedDate = df.format(c.getTime());
		String[] dateArr = formattedDate.split("-"); // date format is
														// yyyy-mm-dd
		month.set(Integer.parseInt(dateArr[0]),
				Integer.parseInt(dateArr[1]) - 1, Integer.parseInt(dateArr[2]));
		// month.set(2014, 06, 14);
	}

	public Runnable calendarUpdater = new Runnable() {

		@Override
		public void run() {
			items.clear();
			_date.clear();
			// format random values. You can implement a dedicated class to
			// provide real values
			/*
			 * for(int i=0;i<31;i++) { Random r = new Random();
			 * 
			 * if(r.nextInt(10)>6) { items.add(Integer.toString(i));
			 * System.out.println("================"+Integer.toString(i)); } }
			 */
			ProgressDialog dialog = new ProgressDialog(getActivity());
			dialog.setTitle("Loading, Please wait...");
			dialog.setCancelable(false);
			dialog.show();
			if (check_event == true) {
				try {
					String month_for_parsing = android.text.format.DateFormat
							.format("MM", month).toString();
					params = new ArrayList<Getcatagory_forlist>();
					params_systems_event = new ArrayList<Getcatagory_forlist>();
					String uriString = "content://com.android.calendar//events";
					Log.i("INFO", "Reading content from " + uriString);
					readContent(uriString);
					int i = 0;
					for (Getcatagory_forlist temp : params_systems_event) {
						String monts_for_comparasion = params_systems_event
								.get(i).date_ofevent;
						String[] dateArr = monts_for_comparasion.split("-"); // date
						String date_forcalander = dateArr[1];
						if (date_forcalander.equals(month_for_parsing)) {

							Getcatagory_forlist getcat = params_systems_event
									.get(i);
							params.add(getcat);
							String date_for_gridview = dateArr[2];
							int date_int = Integer.parseInt(date_for_gridview);
							items.add(Integer.toString(date_int));
						}
						i++;
					}
				} catch (Exception e) {
					// TODO: handle exception

				}

				dialog.dismiss();
				adapter1 = new LazyAdapter(getActivity(), params);

				list_event.setAdapter(adapter1);

				adapter.setItems(items);
				adapter.notifyDataSetChanged();
			} else {

				params = new ArrayList<Getcatagory_forlist>();
				JSONObject json = null;
				try {
					json = new JSONObject(sResponse);
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				String date_for_parsing = android.text.format.DateFormat
						.format("yyyy", month).toString();
				String month_for_parsing = android.text.format.DateFormat
						.format("MM", month).toString();
				int monthsforparsing = Integer.parseInt(month_for_parsing);

				System.out.println("month_for_parsingmonth_for_parsing"
						+ month_for_parsing);
				try {

					JSONObject jsondata = json.getJSONObject("data");
					JSONObject year = jsondata.getJSONObject(date_for_parsing);
					JSONArray jarray = year.getJSONArray(String
							.valueOf(monthsforparsing));

					// JSONArray jArray=json.getJSONArray("data");
					Log.d("fdgn", "dsgfbkj" + jarray);
					for (int i = 0; i < jarray.length(); i++) {
						JSONObject c = jarray.getJSONObject(i);
						Getcatagory_forlist getcat = new Getcatagory_forlist();
						String eventid = c.getString("event_id");
						String childname = c.getString("child_name");
						String childid = c.getString("child_id");
						String childpicurl = c.getString("profile_image");
						String friendname = c.getString("friendname");
						String friendid = c.getString("friend_childid");
						String friendpicurl = c.getString("friend_profile_image");
						// String parentname=c.getString("name");
						String senderid = c.getString("senderid");
					    String receiverid=c.getString("receiver_id");
						String parentpic = c.getString("parent_profile_image");
						String date = c.getString("date");
						String starttime = c.getString("starttime");
						String endtime = c.getString("endtime");
						String location = c.getString("location");
						String notes = c.getString("notes");
						// String status_ofevent=c.getString("status");
						getcat.child_id = childid;
						getcat.child_name = childname;
						getcat.child_profile_image = childpicurl;
						getcat.childfriend_name = friendname;
						getcat.date_ofevent = date;
						getcat.end_time_of_event = endtime;
						getcat.friend_id = friendid;
						getcat.friendprofile_image = friendpicurl;
						// getcat.guardian_id=guardianid;
						getcat.senderid = senderid;
					    getcat.receiverid=receiverid;
						getcat.location_event = location;
						// getcat.parent_name=parentname;
						getcat.notes_event = notes;
						getcat.parent_profile_image = parentpic;
						getcat.start_time_of_event = starttime;
						getcat.status_ofevent = "ACCEPTED";
						getcat.eventid = eventid;

						String[] dateArr = date.split("-"); // date format is
															// yyyy-mm-dd
						// month.set(Integer.parseInt(dateArr[0]),
						// Integer.parseInt(dateArr[1]),
						// Integer.parseInt(dateArr[2]));
						String date_forcalander = dateArr[2];
						int date_int = Integer.parseInt(date_forcalander);

						items.add(Integer.toString(date_int));
						_date.add(date);
						params.add(getcat);
					}

				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

				try {
					/*
					 * String month_for_parsing = android.text.format.DateFormat
					 * .format("MM", month).toString();
					 */
					params_systems_event = new ArrayList<Getcatagory_forlist>();
					String uriString = "content://com.android.calendar//events";
					Log.i("INFO", "Reading content from " + uriString);
					readContent(uriString);
					int i = 0;
					for (Getcatagory_forlist temp : params_systems_event) {
						String monts_for_comparasion = params_systems_event
								.get(i).date_ofevent;
						String[] dateArr = monts_for_comparasion.split("-"); // date
						String date_forcalander = dateArr[1];
						if (date_forcalander.equals(month_for_parsing)) {
							System.out.println(i);
							Getcatagory_forlist getcat = params_systems_event
									.get(i);
							params.add(getcat);
							String date_for_gridview = dateArr[2];
							int date_int = Integer.parseInt(date_for_gridview);
							items.add(Integer.toString(date_int));
						}
						i++;
					}
				} catch (Exception e) {
					// TODO: handle exception
					e.printStackTrace();

				}

				dialog.dismiss();
				adapter1 = new LazyAdapter(getActivity(), params);

				list_event.setAdapter(adapter1);

				adapter.setItems(items);
				adapter.notifyDataSetChanged();

			}
		}
	};

	public class Get_Event extends AsyncTask<String, Integer, String> {
		ProgressDialog dialog = new ProgressDialog(getActivity());
		String url_sets;
		boolean running = true;

		@Override
		protected void onPreExecute() {

			dialog.show();
			dialog.setMessage("Loading.......please wait");
			url_sets = "http://54.191.67.152/playdate/eventaccept_date_time.php";// ?g_id=47&status=accepted
		}

		@Override
		protected String doInBackground(String... params) {
			HttpClient httpClient = new DefaultHttpClient();
			HttpContext localContext = new BasicHttpContext();
			HttpPost httpPost = new HttpPost(url_sets);

			ArrayList<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();
			nameValuePairs
					.add(new BasicNameValuePair("g_id", user_guardian_id));
			nameValuePairs.add(new BasicNameValuePair("status", "accepted"));

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
				running = false;
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				running = false;
				e.printStackTrace();
			}
			if (running == true) {
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
				JSONObject joJsonObject = null;
				try {
					sResponse = reader.readLine();
					try {
						joJsonObject = new JSONObject(sResponse);

						json_object = joJsonObject.getJSONObject("data");
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
						try {
							check_event = true;
							data_json = joJsonObject.getString("data");
						} catch (JSONException e1) {
							// TODO Auto-generated catch block
							e1.printStackTrace();
						}
					}
					System.out
							.println("response.................................."
									+ sResponse);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}

			return null;
		}

		protected void onPostExecute(String resultt) {

			dialog.dismiss();
			handler = new Handler();
			handler.post(calendarUpdater);
		}
	}

	public class LazyAdapter extends BaseAdapter {
		String _imgurlchild = "", _imgurlfriend = "", _imgparent = "";
		private Activity activity;
		private ArrayList<Getcatagory_forlist> _items;
		private LayoutInflater inflater = null;

		public ImageLoader imageLoader;

		public LazyAdapter(Activity activity,
				ArrayList<Getcatagory_forlist> parentItems) {

			// this.imageLoader.clearCache();
			this.activity = activity;
			this._items = parentItems;
			inflater = (LayoutInflater) getActivity().getSystemService(
					Context.LAYOUT_INFLATER_SERVICE);
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
			public TextView guardian_name, date_of_event_list, time;
			public ImageView imageview;

		}

		public View getView(final int position, View convertView,
				ViewGroup parent) {
			View vi = convertView;
			String url;
			ViewHolder _holder;
			if (convertView == null) {
				convertView = inflater
						.inflate(R.layout.list_for_calander, null);
				_holder = new ViewHolder();
				_holder.imageview = (ImageView) convertView
						.findViewById(R.id.imageView1_calander);
				_holder.guardian_name = (TextView) convertView
						.findViewById(R.id.textView_list_calander_name);

				_holder.date_of_event_list = (TextView) convertView
						.findViewById(R.id.textView_list_calander_date);
				_holder.time = (TextView) convertView
						.findViewById(R.id.textView_list_calander_time);

				convertView.setTag(_holder);
			} else {
				_holder = (ViewHolder) convertView.getTag();
			}
			String name_of_child = _items.get(position).child_name;
			String name_of_childfriend = _items.get(position).childfriend_name;
			// String name_of_childparent=_items.get(position).parent_name;
			String date_ofevent = _items.get(position).date_ofevent;
			String start_time = _items.get(position).start_time_of_event;
			String endString = _items.get(position).end_time_of_event;

			String name_of_child_caps = name_of_child.toUpperCase();

			if (start_time.equals("") || start_time.equals(null)) {
				_holder.time.setText("");
			} else {
				_holder.time.setText(start_time + " -> " + endString);
			}
			_holder.guardian_name.setText(name_of_child_caps);
			_holder.date_of_event_list.setText(date_ofevent);

			url = _items.get(position).friendprofile_image;

			_holder.imageview.setTag(url);

			imageLoader.DisplayImage(url, _holder.imageview);

			_holder.imageview.requestLayout();

			int density = getResources().getDisplayMetrics().densityDpi;
			switch (density) {
			case DisplayMetrics.DENSITY_LOW:
				_holder.imageview.getLayoutParams().height = 40;
				_holder.imageview.getLayoutParams().width = 40;

				break;
			case DisplayMetrics.DENSITY_MEDIUM:
				_holder.imageview.getLayoutParams().height = 85;
				_holder.imageview.getLayoutParams().width = 85;

				break;
			case DisplayMetrics.DENSITY_HIGH:
				_holder.imageview.getLayoutParams().height = 85;
				_holder.imageview.getLayoutParams().width = 85;

				break;
			case DisplayMetrics.DENSITY_XHIGH:
				_holder.imageview.getLayoutParams().height = 120;
				_holder.imageview.getLayoutParams().width = 120;

				break;
			case DisplayMetrics.DENSITY_XXHIGH:
				_holder.imageview.getLayoutParams().height = 120;
				_holder.imageview.getLayoutParams().width = 120;

				break;
			}

			return convertView;
		}
	}

	private void readContent(String uriString) {

		Uri uri = Uri.parse(uriString);

		Cursor cursor = getActivity().getContentResolver().query(uri, null,
				null, null, null);
		if (cursor != null && cursor.getCount() > 0) {
			cursor.moveToFirst();
			do {
				String event_title = cursor.getString(cursor
						.getColumnIndex("title"));
				String dd_startevent = cursor.getString(cursor
						.getColumnIndex("dtstart"));
				String dd_end_event = cursor.getString(cursor
						.getColumnIndex("lastDate"));
				String date_start_time = null, date_end_time = null;
				try {
					date_start_time = convertDate(dd_startevent, "yyyy-MM-dd");
					System.out.println(date_start_time);
					System.out.println(event_title);
					System.out.println(date_end_time);
					date_end_time = convertDate(dd_end_event, "yyyy-MM-dd");

				} catch (Exception e) {
					// TODO: handle exception
				}
				String event_id = "-1";
				Getcatagory_forlist getcat = new Getcatagory_forlist();
				// System.out.println(date_start_time);

				getcat.start_time_of_event = "";
				getcat.end_time_of_event = "";
				getcat.date_ofevent = date_start_time;
				getcat.end_date_of_event = date_end_time;
				getcat.child_name = event_title;
				getcat.eventid = event_id;
				if (event_title.equalsIgnoreCase("PLAYDATE EVENT")) {

				} else {
					params_systems_event.add(getcat);
				}

			} while (cursor.moveToNext());

		}

	}

	public static String convertDate(String dateInMilliseconds,
			String dateFormat) {
		return DateFormat
				.format(dateFormat, Long.parseLong(dateInMilliseconds))
				.toString();
	}

	/*
	 * public void insert_event_intocalander(){ Calendar cal =
	 * Calendar.getInstance(); Intent intent = new Intent(Intent.ACTION_EDIT);
	 * intent.setType("vnd.android.cursor.item/event");
	 * intent.putExtra("beginTime", cal.getTimeInMillis());
	 * intent.putExtra("allDay", true); intent.putExtra("rrule", "FREQ=YEARLY");
	 * intent.putExtra("endTime", cal.getTimeInMillis()+60*60*1000);
	 * intent.putExtra("title", "A Test Event from android app");
	 * startActivity(intent);
	 * 
	 * // Another method
	 * 
	 * String eventUriString = "content://com.android.calendar/events";
	 * ContentValues eventValues = new ContentValues();
	 * 
	 * eventValues.put("calendar_id", 1); // id, We need to choose from // our
	 * mobile for primary // its 1 eventValues.put("title", "title");
	 * eventValues.put("description", ""); eventValues.put("eventLocation", "");
	 * 
	 * //long endDate = startDate + 1000 * 60 * 60; // For next 1hr
	 * 
	 * eventValues.put("dtstart", "startDate"); eventValues.put("dtend",
	 * "endDate");
	 * 
	 * eventValues.put("eventStatus", "status"); // This information is
	 * 
	 * eventValues.put("hasAlarm", 1); // 0 for false, 1 for true
	 * 
	 * Uri eventUri =
	 * getActivity().getContentResolver().insert(Uri.parse(eventUriString),
	 * eventValues); long eventID =
	 * Long.parseLong(eventUri.getLastPathSegment());
	 * 
	 * 
	 * // Another method
	 * 
	 * 
	 * if (Build.VERSION.SDK_INT >= 14) { Intent intent1 = new
	 * Intent(Intent.ACTION_INSERT) .setData(Events.CONTENT_URI)
	 * .putExtra(CalendarContract.EXTRA_EVENT_BEGIN_TIME, "")
	 * .putExtra(CalendarContract.EXTRA_EVENT_END_TIME, "")
	 * .putExtra(Events.TITLE, "Yoga") .putExtra(Events.DESCRIPTION,
	 * "Group class") .putExtra(Events.EVENT_LOCATION, "The gym")
	 * .putExtra(Events.AVAILABILITY, Events.AVAILABILITY_BUSY)
	 * .putExtra(Intent.EXTRA_EMAIL, "rowan@example.com,trevor@example.com");
	 * startActivity(intent1); }
	 * 
	 * else { Calendar cal1 = Calendar.getInstance(); Intent intent1 = new
	 * Intent(Intent.ACTION_EDIT);
	 * intent1.setType("vnd.android.cursor.item/event");
	 * intent1.putExtra("beginTime", cal1.getTimeInMillis());
	 * intent1.putExtra("allDay", true); intent1.putExtra("rrule",
	 * "FREQ=YEARLY"); intent1.putExtra("endTime",
	 * cal1.getTimeInMillis()+60*60*1000); intent1.putExtra("title",
	 * "A Test Event from android app"); startActivity(intent1); }
	 * 
	 * 
	 * // Another method
	 * 
	 * Calendar beginTime = Calendar.getInstance(); // beginTime.set("yearInt",
	 * "monthInt- 1", "dayInt", 7, 30);
	 * 
	 * 
	 * 
	 * ContentValues l_event = new ContentValues(); l_event.put("calendar_id",
	 * "CalIds[0]"); l_event.put("title", "event"); l_event.put("description",
	 * "This is test event"); l_event.put("eventLocation", "School");
	 * l_event.put("dtstart", beginTime.getTimeInMillis()); l_event.put("dtend",
	 * beginTime.getTimeInMillis()); l_event.put("allDay", 0);
	 * l_event.put("rrule", "FREQ=YEARLY"); // status: 0~ tentative; 1~
	 * confirmed; 2~ canceled // l_event.put("eventStatus", 1);
	 * 
	 * l_event.put("eventTimezone", "India"); Uri l_eventUri; if
	 * (Build.VERSION.SDK_INT >= 8) { l_eventUri =
	 * Uri.parse("content://com.android.calendar/events"); } else { l_eventUri =
	 * Uri.parse("content://calendar/events"); } Uri l_uri =
	 * getActivity().getContentResolver() .insert(l_eventUri, l_event);
	 * 
	 * }
	 */

}
