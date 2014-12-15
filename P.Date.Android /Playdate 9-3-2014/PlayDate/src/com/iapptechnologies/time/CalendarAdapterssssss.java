//package com.example.snapy;
//import java.text.DateFormat;
//import java.text.SimpleDateFormat;
//import java.util.ArrayList;
//import java.util.GregorianCalendar;
//import java.util.List;
//import java.util.Locale;
//
//import android.app.ProgressDialog;
//import android.content.Context;
//import android.database.Cursor;
//import android.database.sqlite.SQLiteDatabase;
//import android.graphics.Bitmap;
//import android.graphics.BitmapFactory;
//import android.graphics.Color;
//import android.util.Log;
//import android.view.LayoutInflater;
//import android.view.View;
//import android.view.ViewGroup;
//import android.widget.BaseAdapter;
//import android.widget.ImageView;
//import android.widget.TextView;
//
//import com.example.snapy.database.DataBaseSqlliteHelper;
//import com.example.snapy.imageloader.ImageLoaderCalender;
//import com.example.snapy.model.CalenderModel;
//import com.nostra13.universalimageloader.core.DisplayImageOptions;
//import com.nostra13.universalimageloader.core.ImageLoader;
//
//public class CalendarAdapter extends BaseAdapter 
//{
//	public static ImageView iw=null;
//	public ImageLoaderCalender imageLoaderCalender=null; 
//	Cursor cur;
//	private Context mContext;
//	SQLiteDatabase eventDataRead,eventDataWrite;
//	private java.util.Calendar month;
//	private GregorianCalendar pmonth,pmonthmaxset; // calendar instance for previous month
//	private GregorianCalendar selectedDate;
//	int firstDay,maxWeeknumber,maxP,calMaxP,lastWeekDay,leftDays,mnthlength;
//	String itemvalue, curentDateString;
//	DateFormat df;
//	private ArrayList<String> items;
//	public static List<String> dayString=null;
//	private View previousView;
//    private ArrayList<CalenderModel> data=null;
//	private ArrayList<CalenderModel> results=null;
//	ArrayList<ArrayList<String>>eventDateArrayFromDataBase=null;
//	ProgressDialog dialog=null;
//	private DisplayImageOptions options;
//	
//	public CalendarAdapter(Context c, GregorianCalendar monthCalendar,ArrayList<CalenderModel> results)
//	{
////	    data=results;
////	    if(data!=null && data.size()>0)
////	    {
////	    	 for(int i=0;i<data.size();i++)
////	 	    {
////	 	    	ArrayList<String>addDateAndImages=new ArrayList<String>();
////				addDateAndImages.add(data.get(i).getImagesCalenderModel().toString().trim());
////				addDateAndImages.add(data.get(i).getImagesCalenderModel());
////				eventDateArray.add(addDateAndImages);
////	 	    }	
////	    }
////		if(CalendarAdapter.dayString!=null && CalendarAdapter.dayString.size()>0)
////		{
////			dayString.clear();
////			eventDateArrayFromDataBase.clear();
////		}
//		
//		
//		//dialog=new ProgressDialog(mContext,AlertDialog.THEME_TRADITIONAL);
//		eventDateArrayFromDataBase=new ArrayList<ArrayList<String>>();
//		imageLoaderCalender=new ImageLoaderCalender(mContext);
//		CalendarAdapter.dayString = new ArrayList<String>();
//		Locale.setDefault( Locale.US );
//		month = monthCalendar;
//		selectedDate = (GregorianCalendar) monthCalendar.clone();
//		mContext = c;
//		month.set(GregorianCalendar.DAY_OF_MONTH, 1);
//		this.items = new ArrayList<String>();
//		df = new SimpleDateFormat("yyyy-MM-dd", Locale.US);
//		curentDateString = df.format(selectedDate.getTime());
//		refreshDays();
//		options = new DisplayImageOptions.Builder()
//		.showStubImage(R.drawable.ic_launcher)
//		.showImageForEmptyUri(R.drawable.ic_launcher)
//		.cacheInMemory()
//		.cacheOnDisc()
////		.displayer(new FakeBitmapDisplayer())
////    	.displayer(new RoundedBitmapDisplayer(20))
//		.build();
//		//getDateFromDataBase(mContext);
//	}
//
//	public void setItems(ArrayList<String> items)
//	{
//		for (int i = 0; i != items.size(); i++)
//		{
//			if (items.get(i).length() == 1) {
//				items.set(i, "0" + items.get(i));
//			}
//		}
//		this.items = items;
//	}
//
//	public int getCount() 
//	{
//		return dayString.size();
//	}
//
//	public Object getItem(int position)
//	{
//		return dayString.get(position);
//	}
//
//	public long getItemId(int position)
//	{
//		return position;
//	}
//
//	// create a new view for each item referenced by the Adapter
//	public View getView(int position, View convertView, ViewGroup parent)
//	{
//		View v = convertView;
//		TextView dayView;
//		
//		if (convertView == null)
//		{ 
//		LayoutInflater vi = (LayoutInflater) mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
//		v = vi.inflate(R.layout.calenderadapter, null);
//		}
//		dayView = (TextView) v.findViewById(R.id.date);
//		 iw = (ImageView) v.findViewById(R.id.date_icon);
//		 View checkedItem = (View) v.findViewById(R.id.main);
//		//View checkedItem = (View) v.findViewById(R.id.check);
//		// separates daystring into parts.
//		String[] separatedTime = dayString.get(position).split("-");
//		// taking last part of date. ie; 2 from 2012-12-02
//		String gridvalue = separatedTime[2].replaceFirst("^0*", "");
//		// checking whether the day is in current month or not.
//		if ((Integer.parseInt(gridvalue) > 1) && (position < firstDay))
//		{
//			// setting offdays to white color.
//			dayView.setTextColor(Color.BLACK);
//			dayView.setClickable(false);
//			dayView.setFocusable(false);
//		} 
//		else if ((Integer.parseInt(gridvalue) < 7) && (position > 28))
//		{
//			dayView.setTextColor(Color.BLACK);
//			dayView.setClickable(false);
//			dayView.setFocusable(false);
//		}
//		else
//		{
//			// setting curent month's days in blue color.
//			dayView.setTextColor(Color.BLACK);
//		}
//
//		if (dayString.get(position).equals(curentDateString))
//		{
//	     setSelected(v);
//		 previousView = v;
//		} else 
//		{
//		v.setBackgroundResource(R.drawable.list_item_background);
//		}
//		dayView.setText(gridvalue);
//
//		
//		    eventDateArrayFromDataBase.clear();
//		    String date = dayString.get(position);
//		  //  Log.e("DateString==",""+date);
//		    DataBaseSqlliteHelper  eventsData = new DataBaseSqlliteHelper(mContext);
//		    eventDataRead = eventsData.getReadableDatabase();
//			String[] columns = new String[] {"date","imagepath"};
//			String [] previousDateOnClick=date.split("-");
//			String YearFromDataBase=previousDateOnClick[0];
//			String monthFromDataBase=previousDateOnClick[1];
//			String dayFromDataBase=previousDateOnClick[2];
//			    
//			String dateDataBase=YearFromDataBase+"-"+monthFromDataBase+"-"+dayFromDataBase;
//		    cur = eventDataRead.query("imageDate",columns,"date=?" ,new String[]{dateDataBase}, null, null,null);
//			if(cur != null && cur.getCount() > 0)
//			{
//			GetAllValuesFromDB(cur);
//		//	Log.e("CursorCount=======",""+cur.getCount());
//			}
//		   cur.close();
//		   eventDataRead.close();
//		
//
//		   iw.setVisibility(View.GONE);
//				for(int y=0;y<eventDateArrayFromDataBase.size();y++)
//				{
//					String dateDataBase11 = dayString.get(position);
//					String [] previousDateOnClick11=dateDataBase11.split("-");
//					String YearFromDataBase11=previousDateOnClick11[0];
//					String monthFromDataBase11=previousDateOnClick11[1];
//					String dayFromDataBase11=previousDateOnClick11[2];
//					
//					if (eventDateArrayFromDataBase.get(y).get(0).trim().contains((YearFromDataBase11 + "-" + (monthFromDataBase11)+ "-" + dayFromDataBase11).toString())) 
//					{
//				    String imagePath="";
//					imagePath=eventDateArrayFromDataBase.get(y).get(1).toString().trim();
//					if(imagePath!=null && imagePath.length()>0)
//					{
//						imageLoaderCalender.DisplayImage(imagePath, iw);
//				//	ImageLoader.getInstance().displayImage("file://"+imagePath, iw, options);
//					iw.setVisibility(View.VISIBLE);
//					dayView.setTextColor(Color.WHITE);
//					}
//					}
//					
//				}	
//			
//	
//		   
//		if (date.length() == 1)
//		{
//		date = "0" + date;
//		}
//		String monthStr = "" + (month.get(GregorianCalendar.MONTH) + 1);
//		if (monthStr.length() == 1) {
//			monthStr = "0" + monthStr;
//		}
//	
////	
//		// show icon if date is not empty and it exists in the items array
////		ImageView iw = (ImageView) v.findViewById(R.id.date_icon);
////		if (date.length() > 0 && items != null && items.contains(date))
////		{
////			iw.setVisibility(View.VISIBLE);
////		} else 
////		{
////			//iw.setVisibility(View.INVISIBLE);
////		}
//		return v;
//	}
//	
//	
//
//	private void GetAllValuesFromDB(Cursor c)
//	{
//		eventDateArrayFromDataBase.clear();
//		if (c != null)
//		{
//			c.moveToLast();
//			do
//			{
//			    ArrayList<String>addDateAndImages=new ArrayList<String>();
//			    addDateAndImages.clear();
//				addDateAndImages.add(c.getString(c.getColumnIndex("date")));
//				addDateAndImages.add(c.getString(c.getColumnIndex("imagepath")));
//				eventDateArrayFromDataBase.add(addDateAndImages);
//			//	Log.e("EventArafrom",""+eventDateArrayFromDataBase);
//			}
//			while (c.moveToPrevious());
//		}
//		c.close();
//	}
//
//	public View setSelected(View view) 
//	{
//		if (previousView != null)
//		{
//			previousView.setBackgroundResource(R.drawable.list_item_background);
//		}
//		previousView = view;
//		view.setBackgroundResource(R.drawable.calendar_cel_selectl);
//		return view;
//	}
//
//	public void refreshDays()
//	{
//		// clear items
//		
//		items.clear();
//		dayString.clear();
//		Locale.setDefault( Locale.US );
//		pmonth = (GregorianCalendar) month.clone();
//		// month start day. ie; sun, mon, etc
//		firstDay = month.get(GregorianCalendar.DAY_OF_WEEK);
//		// finding number of weeks in current month.
//		maxWeeknumber = month.getActualMaximum(GregorianCalendar.WEEK_OF_MONTH);
//		// allocating maximum row number for the gridview.
//		mnthlength = maxWeeknumber * 7;
//		maxP = getMaxP(); // previous month maximum day 31,30....
//		calMaxP = maxP - (firstDay - 1);// calendar offday starting 24,25 ...
//		/**
//		 * Calendar instance for getting a complete gridview including the three
//		 * month's (previous,current,next) dates.
//		 */
//		pmonthmaxset = (GregorianCalendar) pmonth.clone();
//		/**
//		 * setting the start date as previous month's required date.
//		 */
//		pmonthmaxset.set(GregorianCalendar.DAY_OF_MONTH, calMaxP + 1);
//
//		/**
//		 * filling calendar gridview.
//		 */
//		for (int n = 0; n < mnthlength; n++) 
//		{
//			itemvalue = df.format(pmonthmaxset.getTime());
//			pmonthmaxset.add(GregorianCalendar.DATE, 1);
//			dayString.add(itemvalue);
//			eventDateArrayFromDataBase.clear();
//		}
//	}
//
//	private int getMaxP()
//	{
//		int maxP;
//		if (month.get(GregorianCalendar.MONTH) == month.getActualMinimum(GregorianCalendar.MONTH))
//		{
//			pmonth.set((month.get(GregorianCalendar.YEAR) - 1),month.getActualMaximum(GregorianCalendar.MONTH), 1);
//		} else 
//		{
//			pmonth.set(GregorianCalendar.MONTH,month.get(GregorianCalendar.MONTH) - 1);
//		}
//		maxP = pmonth.getActualMaximum(GregorianCalendar.DAY_OF_MONTH);
//		return maxP;
//	}
//
//	public   Bitmap decodeSampledBitmapFromResource(String pathName)
//	{
////		DisplayMetrics displaymetrics = new DisplayMetrics();
////		getWindowManager().getDefaultDisplay().getMetrics(displaymetrics);
////		int height = displaymetrics.heightPixels;
////		int width = displaymetrics.widthPixels;
//	
//		
//			int reqWidth,reqHeight;
//			//reqWidth =Utils.getScreenWidth();
//			reqWidth = (480/20)*2;
//			reqHeight = reqWidth;
//			final BitmapFactory.Options options = new BitmapFactory.Options();
//			options.inJustDecodeBounds = true;
//			//  BitmapFactory.decodeStream(is, null, options);
//			BitmapFactory.decodeFile(pathName, options);
//			// Calculate inSampleSize
//			options.inSampleSize = calculateInSampleSize(options, reqWidth, reqHeight);
//			// Decode bitmap with inSampleSize set
//			options.inJustDecodeBounds = false;
//			return BitmapFactory.decodeFile(pathName, options);
//			}
//
//			   public   int calculateInSampleSize(BitmapFactory.Options options,
//			  int reqWidth, int reqHeight) {
//			// Raw height and width of image
//			final int height = options.outHeight;
//			final int width = options.outWidth;
//			int inSampleSize = 1;
//
//			if (height > reqHeight || width > reqWidth) {
//			  if (width > height) {
//			    inSampleSize = Math.round((float) height / (float) reqHeight);
//			  } else {
//			    inSampleSize = Math.round((float) width / (float) reqWidth);
//			  }
//			}
//			return inSampleSize;
//			 }
//
//}