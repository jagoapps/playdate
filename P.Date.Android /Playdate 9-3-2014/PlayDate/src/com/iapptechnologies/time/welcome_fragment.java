/*package com.iapptechnologies.time;

import org.json.JSONArray;
import org.json.JSONException;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnTouchListener;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.iapp.playdate.R;

public class welcome_fragment extends android.support.v4.app.Fragment{
	JSONArray customMessageStr;
	String user_guardian_id;
	LinearLayout touch_screen;
public welcome_fragment(){
		
	}
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,Bundle savedInstanceState) {

		ViewGroup view = (ViewGroup) inflater.inflate(R.layout.welcome_msg, container,false);
		touch_screen=(LinearLayout)view.findViewById(R.id.touch_button);
		 user_guardian_id = getArguments().getString("user_guardian_id"); 
		 customMessageStr  = GlobalVariable.custom_Jsonarray;
		 if(customMessageStr!=null && customMessageStr.length()>0)
			{
		String first_msg = "",second_msg = "",third_msg = "",fourth_msg = "",fifth_msg = "";
		try {
			 first_msg=customMessageStr.getString(0);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		try {
			 second_msg=customMessageStr.getString(1);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		try {
			 third_msg=customMessageStr.getString(2);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		try {
			 fourth_msg=customMessageStr.getString(3);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		try {
			 fifth_msg=customMessageStr.getString(4);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		TextView first_testview = (TextView) view.findViewById(R.id.textView1_first);
		TextView second_textview = (TextView) view.findViewById(R.id.textView2_second);
		TextView third_TextView = (TextView) view.findViewById(R.id.textView3_third);
		TextView forth_textview = (TextView) view.findViewById(R.id.textView4_fourth);
		third_TextView.setText("On the HOME screen you'll find all your playdate arrangements");
		forth_textview.setText("On this NOTIFICATION screen you'll find messages and updates from the JAGO team");
		first_testview.setText(first_msg);
		second_textview.setText(second_msg+"\n\n"+third_msg+"\n"+fourth_msg+"\n"+fifth_msg);
		GlobalVariable.custom_Jsonarray=null;
		
		
		
		touch_screen.setOnTouchListener(new OnTouchListener() {
			
			@Override
			public boolean onTouch(View v, MotionEvent event) {
				// TODO Auto-generated method stub
				Bundle bundle = new Bundle();
				bundle.putString("user_guardian_id", user_guardian_id);
				//bundle.putString("CustomMessage", customMessageStr);
				android.support.v4.app.Fragment
				 android.support.v4.app.Fragment  fragment=new Home_fragment();
		         fragment.setArguments(bundle);
				android.support.v4.app.FragmentManager fragmentManager = getFragmentManager();
				fragmentManager.beginTransaction()
				        .replace(R.id.content_frame, fragment).commit();
				return true;
			}
		});
			}else{
				Bundle bundle = new Bundle();
				bundle.putString("user_guardian_id", user_guardian_id);
				//bundle.putString("CustomMessage", customMessageStr);
				android.support.v4.app.Fragment
				 android.support.v4.app.Fragment  fragment=new Home_fragment();
		         fragment.setArguments(bundle);
				android.support.v4.app.FragmentManager fragmentManager = getFragmentManager();
				fragmentManager.beginTransaction()
				        .replace(R.id.content_frame, fragment).commit();
			}
		return view;
	}

}













*/