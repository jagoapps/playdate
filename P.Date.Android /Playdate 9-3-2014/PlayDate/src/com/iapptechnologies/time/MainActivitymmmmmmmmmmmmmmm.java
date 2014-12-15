//package com.example.snapy;
//
//import java.io.BufferedReader;
//import java.io.File;
//import java.io.FileNotFoundException;
//import java.io.FileOutputStream;
//import java.io.FileReader;
//import java.io.IOException;
//import java.sql.Date;
//import java.text.DateFormat;
//import java.text.SimpleDateFormat;
//import java.util.ArrayList;
//import java.util.Calendar;
//import java.util.GregorianCalendar;
//import java.util.Locale;
//
//import android.app.Activity;
//import android.app.AlertDialog;
//import android.app.ProgressDialog;
//import android.content.ContentValues;
//import android.content.Intent;
//import android.content.SharedPreferences;
//import android.database.Cursor;
//import android.database.sqlite.SQLiteDatabase;
//import android.graphics.Bitmap;
//import android.net.Uri;
//import android.os.AsyncTask;
//import android.os.Bundle;
//import android.os.Handler;
//import android.preference.PreferenceManager;
//import android.provider.MediaStore;
//import android.util.DisplayMetrics;
//import android.util.Log;
//import android.view.View;
//import android.view.View.OnClickListener;
//import android.view.Window;
//import android.widget.AdapterView;
//import android.widget.AdapterView.OnItemClickListener;
//import android.widget.Button;
//import android.widget.GridView;
//import android.widget.ImageView;
//import android.widget.RelativeLayout;
//import android.widget.TextView;
//import com.example.snapy.database.DataBaseSqlliteHelper;
//import com.example.snapy.model.CalenderModel;
//
//public class MainActivity extends Activity implements OnClickListener
//{
//	ArrayList<ArrayList<String>>imagePathStr=null;
//	public static final String PREFS_NAME = "MyPrefsFile";
//	ArrayList<String>calenderAdapterList=new ArrayList<String>();
//	SharedPreferences sharedPreferences;
//	SharedPreferences.Editor ed = null;
//	public static  int Counter, height,width;
//	DataBaseSqlliteHelper eventsData;
//	SQLiteDatabase eventDataRead,eventDataWrite;
//	private GridView gridview=null;
//	private TextView title=null;
//	private RelativeLayout next=null,previous=null;
//	public GregorianCalendar month, itemmonth;// calendar instances.
//	public CalendarAdapter adapter;// adapter instance
//	public Handler handler;// for grabbing some event values for showing the dot marker.
//	public ArrayList<String> items; // container to store calendar items which needs showing the event marker
//	private Button setting,camera;
//	ProgressDialog dialog=null;
//	ArrayList<ArrayList<String>>dateAndImagesList=null;
//	RelativeLayout mainBackGround=null,headerCalender=null,belowBar=null;
//	ImageView snappyTopBar=null,arrowLeft=null,arrowRight=null;
//	int CAMERA_REQUEST = 1888; 
//	ArrayList<CalenderModel> calenderModelList =null;
//    ArrayList<ArrayList<String>>eventDateArray=null;
//	public void onCreate(Bundle savedInstanceState)
//	{
//		super.onCreate(savedInstanceState);
//		requestWindowFeature(Window.FEATURE_NO_TITLE);
//		setContentView(R.layout.activity_main);
//		DisplayMetrics displaymetrics = new DisplayMetrics();
//		getWindowManager().getDefaultDisplay().getMetrics(displaymetrics);
//		height = displaymetrics.heightPixels;
//		width = displaymetrics.widthPixels;
//		dialog=new ProgressDialog(MainActivity.this,AlertDialog.THEME_TRADITIONAL);
//		intilizeView();
//	}
//	
//	class performanceBackground extends AsyncTask<String, String,String>
//	{
//		@Override
//		protected void onPreExecute()
//		{
//			dialog.setMessage("Loading Images");
//			dialog.setCancelable(true);
//			dialog.show();
//			super.onPreExecute();
//		}
//
//		@Override
//		protected String doInBackground(String... params)
//		{
//			MainActivity.this.runOnUiThread(new Runnable() 
//			{
//				@Override
//				public void run()
//				{
//					items.clear();
//					handler = new Handler();
//					handler.post(calendarUpdater);
//					// Print dates of the current week
//					DateFormat df = new SimpleDateFormat("dd-mm-yyy",Locale.US);
//					String itemvalue;
//					for (int i = 0; i < 7; i++) 
//					{
//						itemvalue = df.format(itemmonth.getTime());
//						itemmonth.add(GregorianCalendar.DATE, 1);
//						items.add("2012-09-12");
//						items.add("2012-10-07");
//						items.add("2012-10-15");
//						items.add("2012-10-20");
//						items.add("2012-11-30");
//						items.add("2012-11-28");
//					}	
//				}
//			});
//			Uri images = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
//			String[] projection = new String[] { MediaStore.Images.Media._ID,
//			MediaStore.Images.Media.BUCKET_DISPLAY_NAME,
//			MediaStore.Images.Media.DISPLAY_NAME,
//			MediaStore.Images.Media.MIME_TYPE,
//			MediaStore.Images.Media.DATA,
//			MediaStore.Images.Media.DATE_TAKEN, MediaStore.Images.Media.ORIENTATION};
//			Cursor cur = managedQuery(images, projection, null, null, null);
//			if (cur.moveToFirst())
//		    {
//		    String date="",path="";
//		    int dateColumn = cur.getColumnIndex(MediaStore.Images.Media.DATE_TAKEN);
//		    int imagePath = cur.getColumnIndex(MediaStore.Images.Media.DATA);
//		    do
//			{
//			date = cur.getString(dateColumn);
//			long dateInMillis = Long.parseLong(date);
//			SimpleDateFormat formatter = new SimpleDateFormat("yyy-MM-dd"); 
//			String dateString = formatter.format(new Date(dateInMillis));
//			path = cur.getString(imagePath);
//		
//			ArrayList<String> imagesanddate = new ArrayList<String>();
//		    imagesanddate.add(dateString);
//			imagesanddate.add(path);
//			dateAndImagesList.add(imagesanddate);
//			}
//		    while (cur.moveToNext());
//			}
//			calenderModelList.clear();
//			deleteTable();
//	
//			ContentValues cv = new ContentValues();
//			eventDataWrite=eventsData.getWritableDatabase();
//			for(int k=0;k<=dateAndImagesList.size();k++)
//			{
//			if(dateAndImagesList!=null && dateAndImagesList.size()>k)
//			{	
//			cv.put("date",dateAndImagesList.get(k).get(0).toString());
//			cv.put("imagepath",dateAndImagesList.get(k).get(1).toString());
//			eventDataWrite.insert("imageDate",null, cv);
//			}
//			}
//			return null;
//		}
//		@Override
//		protected void onPostExecute(String result)
//		{
//			mainBackGround.setBackgroundDrawable(getResources().getDrawable(R.drawable.background));
//			snappyTopBar.setVisibility(View.VISIBLE);
//			headerCalender.setVisibility(View.VISIBLE);
//			arrowLeft.setVisibility(View.VISIBLE);
//			arrowRight.setVisibility(View.VISIBLE);
//			belowBar.setVisibility(View.VISIBLE);
//			gridview.setVisibility(View.VISIBLE);
//			camera.setVisibility(View.VISIBLE);
//			setting.setVisibility(View.VISIBLE);
//			
//			if(dialog!=null && dialog.isShowing())
//			{
//			adapter = new CalendarAdapter(MainActivity.this, month,calenderModelList);
//			adapter.refreshDays();
//			gridview.setAdapter(adapter);
//			adapter.setItems(items);
//			adapter.notifyDataSetChanged();
//			}
//			dialog.dismiss();
//			dialog.cancel();
//			super.onPostExecute(result);
//		}
//	}
//
//	public void getEventData() 
//	{
//		eventDataRead = eventsData.getReadableDatabase();
//		String[] columns = new String[] {"date","imagepath"};
//		Cursor c = eventDataRead.query("imageDate", columns, null, null,null, null,null);
//		if(c != null && c.getCount() > 0)
//		{
//		GetAllValuesFromDB(c);
//		}
//		c.close();
//		eventDataRead.close();
//	}
//	public void GetAllValuesFromDB(Cursor c)
//	{
//		calenderModelList.clear();
//		dateAndImagesList.clear();
//		if (c != null)
//		{
//			c.moveToLast();
//			do
//			{
//				CalenderModel calenderModel =  new CalenderModel();
//				calenderModel.setDateCalenderModel(c.getString(c.getColumnIndex("date")));
//				calenderModel.setImagesCalenderModel(c.getString(c.getColumnIndex("imagepath")));
//				calenderModelList.add(calenderModel);
//			}
//			while (c.moveToPrevious());
//		}
//		c.close();
//	}
//	
//	
//	
//	public void fetchDateAndImages()
//	{
//		eventDateArray.clear();
//		if (calenderModelList != null && calenderModelList.size() > 0)
//		{
//			for (int i = 0; i < calenderModelList.size(); i++) 
//			{
//				
//				ArrayList<String>addDateAndImages=new ArrayList<String>();
//				addDateAndImages.add(calenderModelList.get(i).getDateCalenderModel());
//				addDateAndImages.add(calenderModelList.get(i).getImagesCalenderModel());
//				eventDateArray.add(addDateAndImages);
//			}
//		}
//	}
//	
//
//	protected void setNextMonth()
//	{
//		if (month.get(GregorianCalendar.MONTH) == month.getActualMaximum(GregorianCalendar.MONTH))
//		{
//		month.set((month.get(GregorianCalendar.YEAR) + 1),month.getActualMinimum(GregorianCalendar.MONTH), 1);
//		}
//		else 
//		{
// 		month.set(GregorianCalendar.MONTH,month.get(GregorianCalendar.MONTH) + 1);
//		}
//
//
//	}
//
//	protected void setPreviousMonth()
//	{
//		if (month.get(GregorianCalendar.MONTH) == month.getActualMinimum(GregorianCalendar.MONTH))
//		{
//		month.set((month.get(GregorianCalendar.YEAR) - 1),month.getActualMaximum(GregorianCalendar.MONTH), 1);
//		} 
//		else 
//		{
//		month.set(GregorianCalendar.MONTH,month.get(GregorianCalendar.MONTH) - 1);
//		}
//		adapter.notifyDataSetChanged();
//	}
//
////	protected void showToast(String string)
////	{
////	Toast.makeText(this, string, Toast.LENGTH_SHORT).show();
////
////	}
//
//	public void refreshCalendar()
//	{
//		adapter.refreshDays();
//		adapter.notifyDataSetChanged();
//		handler.post(calendarUpdater); // generate some calendar items
//		title.setText(android.text.format.DateFormat.format("MMMM yyyy", month));
//	}
//
//	public Runnable calendarUpdater = new Runnable() 
//	{
//		@Override
//		public void run()
//		{
//			items.clear();
//			// Print dates of the current week
//			DateFormat df = new SimpleDateFormat("dd-mm-yyy",Locale.US);
//			String itemvalue;
//			for (int i = 0; i < 7; i++) 
//			{
//				itemvalue = df.format(itemmonth.getTime());
//				itemmonth.add(GregorianCalendar.DATE, 1);
//				items.add("2012-09-12");
//				items.add("2012-10-07");
//				items.add("2012-10-15");
//				items.add("2012-10-20");
//				items.add("2012-11-30");
//				items.add("2012-11-28");
//			}
////			adapter.setItems(items);
////			adapter.notifyDataSetChanged();
//		}
//	};
//
//
//	private void deleteTable() 
//	{
//		eventDataRead = eventsData.getReadableDatabase();
//		try
//		{
//		eventDataRead.delete("imageDate", null, null);
//		
//		} catch (Exception e) 
//		{
//			Log.i("table", "table not found");
//		}
//		eventDataRead.close();
//	}
//	
//	public void intilizeView()
//	{
//		calenderModelList=new ArrayList<CalenderModel>();
//		eventDateArray=new ArrayList<ArrayList<String>>();
//		eventsData = new DataBaseSqlliteHelper(MainActivity.this);
//		mainBackGround=(RelativeLayout)findViewById(R.id.mainBackGround);
//		snappyTopBar=(ImageView)findViewById(R.id.relativeTopBar);
//		headerCalender=(RelativeLayout)findViewById(R.id.header);
//		arrowLeft=(ImageView)findViewById(R.id.arrowLeft);
//		arrowRight=(ImageView)findViewById(R.id.arrowRight);
//		dateAndImagesList=new ArrayList<ArrayList<String>>();
//		next = (RelativeLayout) findViewById(R.id.next);
//		previous = (RelativeLayout) findViewById(R.id.previous);
//	    title = (TextView) findViewById(R.id.title);
//		setting=(Button)findViewById(R.id.setting);
//		camera=(Button)findViewById(R.id.camera);
//		gridview = (GridView) findViewById(R.id.gridview);
//		belowBar=(RelativeLayout)findViewById(R.id.belowBar);
//		
//		Locale.setDefault( Locale.US );
//		month = (GregorianCalendar) GregorianCalendar.getInstance();
//		itemmonth = (GregorianCalendar) month.clone();
//		
//		setting.setOnClickListener(this);
//		camera.setOnClickListener(this);
//		next.setOnClickListener(this);
//		previous.setOnClickListener(this);
//		title.setText(android.text.format.DateFormat.format("MMMM yyyy", month));
//		items = new ArrayList<String>();
//		
//		sharedPreferences = PreferenceManager.getDefaultSharedPreferences(getBaseContext());
//		Counter = sharedPreferences.getInt("Counter",1);
//	
//				ed = sharedPreferences.edit();
//		ed.putInt("Counter", 2);
//		ed.commit();
//	
//		
//		gridview.setOnItemClickListener(new OnItemClickListener() 
//		{
//			public void onItemClick(AdapterView<?> parent, View v,int position, long id)
//			{
//				((CalendarAdapter) parent.getAdapter()).setSelected(v);
//				String selectedGridDate = CalendarAdapter.dayString.get(position);
//				String[] separatedTime = selectedGridDate.split("-");
//				String gridvalueString = separatedTime[2].replaceFirst("^0*","");// taking last part of date. ie; 2 from 2012-12-02.
//				int gridvalue = Integer.parseInt(gridvalueString);
//				if ((gridvalue > 10) && (position < 8))
//				{
//					setPreviousMonth();
//					refreshCalendar();
//				} else if ((gridvalue < 7) && (position > 28))
//				{
//					setNextMonth();
//					refreshCalendar();
//				}
//				((CalendarAdapter) parent.getAdapter()).setSelected(v);
//			
//				
//				String [] selectedDate=selectedGridDate.split("-");
//				String year=selectedDate[0].toString().trim();
//				String month=selectedDate[1].toString().trim();
//				String day=selectedDate[2].toString().trim();
//				
//				 SharedPreferences settingsDay = getSharedPreferences(PREFS_NAME, 0);
//			     SharedPreferences.Editor editorDay = settingsDay.edit();
//			     editorDay.putString("SelectedDay", day);
//			     editorDay.commit();
//			     
//				 SharedPreferences settingsMonth = getSharedPreferences(PREFS_NAME, 0);
//			     SharedPreferences.Editor editorMonth = settingsMonth.edit();
//			     editorMonth.putString("SelectedMonth",month);
//			     editorMonth.commit();
//			     
//				 SharedPreferences settingsYear = getSharedPreferences(PREFS_NAME, 0);
//			     SharedPreferences.Editor editorYear = settingsYear.edit();
//			     editorYear.putString("SelectedYear", year);
//			     editorYear.commit();
//				
//				
//				Intent in=new Intent(MainActivity.this,ShownAllImages.class);
//				startActivity(in);
//				//finish();
//			}
//		});
//	
//			if(Counter==1)
//			{	
//				mainBackGround.setBackgroundDrawable(getResources().getDrawable(R.drawable.blank_bg));
//				mainBackGround.setVisibility(View.VISIBLE);
//				snappyTopBar.setVisibility(View.INVISIBLE);
//				headerCalender.setVisibility(View.INVISIBLE);
//				arrowLeft.setVisibility(View.INVISIBLE);
//				arrowRight.setVisibility(View.INVISIBLE);
//				belowBar.setVisibility(View.INVISIBLE);
//				gridview.setVisibility(View.INVISIBLE);
//				camera.setVisibility(View.INVISIBLE);
//				setting.setVisibility(View.INVISIBLE);	
//			    new performanceBackground().execute();	
//			}
//					mainBackGround.setBackgroundDrawable(getResources().getDrawable(R.drawable.blank_bg));
//					mainBackGround.setVisibility(View.VISIBLE);
//					snappyTopBar.setVisibility(View.INVISIBLE);
//					headerCalender.setVisibility(View.INVISIBLE);
//					arrowLeft.setVisibility(View.INVISIBLE);
//					arrowRight.setVisibility(View.INVISIBLE);
//					belowBar.setVisibility(View.INVISIBLE);
//					gridview.setVisibility(View.INVISIBLE);
//					camera.setVisibility(View.INVISIBLE);
//					setting.setVisibility(View.INVISIBLE);
//					
//				    new performanceBackgroundSecondTime().execute();	
//			
//	}
//	class performanceBackgroundSecondTime extends AsyncTask<String, String, String>
//	{
//		
//		protected void onPreExecute()
//		{
//		dialog.setMessage("Loading Images");
//		dialog.setCancelable(true);
//		dialog.show();
//		super.onPreExecute();
//		}
//
//		@Override
//		protected String doInBackground(String... params)
//		{
//			MainActivity.this.runOnUiThread(new Runnable() 
//			{
//				@Override
//				public void run()
//				{
//					items.clear();
//					handler = new Handler();
//					handler.post(calendarUpdater);
//					// Print dates of the current week
//					DateFormat df = new SimpleDateFormat("dd-mm-yyy",Locale.US);
//					String itemvalue;
//					for (int i = 0; i < 7; i++) 
//					{
//						itemvalue = df.format(itemmonth.getTime());
//						itemmonth.add(GregorianCalendar.DATE, 1);
//						items.add("2012-09-12");
//						items.add("2012-10-07");
//						items.add("2012-10-15");
//						items.add("2012-10-20");
//						items.add("2012-11-30");
//						items.add("2012-11-28");
//					}	
//
//				}
//			});
//			return null;
//		}
//		@Override
//		protected void onPostExecute(String result)
//		{
//			mainBackGround.setBackgroundDrawable(getResources().getDrawable(R.drawable.background));
//			snappyTopBar.setVisibility(View.VISIBLE);
//			headerCalender.setVisibility(View.VISIBLE);
//			arrowLeft.setVisibility(View.VISIBLE);
//			arrowRight.setVisibility(View.VISIBLE);
//			belowBar.setVisibility(View.VISIBLE);
//			gridview.setVisibility(View.VISIBLE);
//			camera.setVisibility(View.VISIBLE);
//			setting.setVisibility(View.VISIBLE);
//			
//			title.setText(android.text.format.DateFormat.format("MMMM yyyy", month));
//			adapter = new CalendarAdapter(MainActivity.this, month,calenderModelList);
//			gridview.setAdapter(adapter);
//			adapter.refreshDays();
//			adapter.setItems(items);
//			adapter.notifyDataSetChanged();
//			adapter.notifyDataSetInvalidated();
//			dialog.dismiss();
//			super.onPostExecute(result);
//		}
//	}
//
//	
//	protected void onDestroy() 
//	   {
//    if (dialog!=null && dialog.isShowing())
//	{
//	dialog.dismiss();
//	}   
//	//finish();
//	super.onDestroy();
//	}
//	
//	@Override
//	public void onClick(View v)
//	{
//		switch(v.getId())
//		{
//		case R.id.setting:
//		Intent in=new Intent(MainActivity.this,Setting.class);
//		in.putExtra("CalenderSetting","1");
//		startActivity(in);
//		break;
//		
//		case R.id.camera:
//			Calendar c = Calendar.getInstance();
//			SimpleDateFormat df = new SimpleDateFormat("yyy-MM-dd");
//			String formattedDate = df.format(c.getTime());
//			Log.e("CurrentDate==",""+formattedDate);
//			
//			String [] nextDateOnClickOuy=formattedDate.split("-");
//			String YearCam=nextDateOnClickOuy[0];
//			String monthCam=nextDateOnClickOuy[1];
//			String dayCam=nextDateOnClickOuy[2];
//			
//			 SharedPreferences settingsDay = getSharedPreferences(PREFS_NAME, 0);
//		     SharedPreferences.Editor editorDay = settingsDay.edit();
//		     editorDay.putString("SelectedDay", dayCam);
//		     editorDay.commit();
//		     
//			 SharedPreferences settingsMonth = getSharedPreferences(PREFS_NAME, 0);
//		     SharedPreferences.Editor editorMonth = settingsMonth.edit();
//		     editorMonth.putString("SelectedMonth",monthCam);
//		     editorMonth.commit();
//		     
//			 SharedPreferences settingsYear = getSharedPreferences(PREFS_NAME, 0);
//		     SharedPreferences.Editor editorYear = settingsYear.edit();
//		     editorYear.putString("SelectedYear", YearCam);
//		     editorYear.commit();
//			
//			
//		SharedPreferences settings = getSharedPreferences(PREFS_NAME, 0);
//		SharedPreferences.Editor editor = settings.edit();
//		editor.putBoolean("BoolCameraCalender", true);
//		editor.commit();
//		SharedPreferences settingsCam = getSharedPreferences(PREFS_NAME, 0);
//		boolean boolCameraCalender = settingsCam.getBoolean("BoolCameraCalender", false);
//		if(boolCameraCalender)
//		{
//		Intent cameraIntent = new Intent(android.provider.MediaStore.ACTION_IMAGE_CAPTURE); 
//		startActivityForResult(cameraIntent, CAMERA_REQUEST); 
//		}
//		break;
//		
//		case R.id.next:
//		setNextMonth();
//		refreshCalendar();
//		break;
//		
//		case R.id.previous:
//		setPreviousMonth();
//		refreshCalendar();
//		break;
//		}
//	}
//	
//	protected void onActivityResult(int requestCode, int resultCode, Intent data) 
//	 {  
//	        if (requestCode == CAMERA_REQUEST && resultCode == RESULT_OK) 
//	        {
//	            Uri selectedImage = data.getData();
//	  	      	String[] filePathColumn = { MediaStore.Images.Media.DATA,MediaStore.Images.Media.ORIENTATION, MediaStore.Images.Media.DATE_TAKEN };
//	  	        Cursor cursor = getContentResolver().query(selectedImage,filePathColumn, null, null, null);
//				cursor.moveToFirst();
//
//				int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
//			    int dateColumn = cursor.getColumnIndex(filePathColumn[2]);
//				String path = cursor.getString(columnIndex);
//			    String	dateCam = cursor.getString(dateColumn);
//				long dateInMillis = Long.parseLong(dateCam);
//				SimpleDateFormat formatter = new SimpleDateFormat("yyy-MM-dd"); 
//				String dateString = formatter.format(new Date(dateInMillis));
//			    Log.e("DateString",""+dateString);
//	        	
//			    Intent intent=new Intent(MainActivity.this,ShownAllImages.class);
//			    if(dateString!=null && dateString.length()>0)
//			    {
//			    intent.putExtra("DateCalenderCamera", dateString);	
//			    }
//			    if(path!=null && path.length()>0)
//			    {
//			    intent.putExtra("PathCamlenderCamera", path);
//			    }
//			    startActivity(intent);
//	        }  
//	        else if(requestCode == CAMERA_REQUEST && resultCode == RESULT_CANCELED) 
//	        {
//	        }
//	    }
//	
//}
//
