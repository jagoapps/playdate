package com.iapptechnologies.time;

import com.iapp.playdate.R;

import android.annotation.SuppressLint;
import android.app.Fragment;
import android.content.Intent;
import android.os.Bundle;
import android.telephony.SmsManager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;


public class Send_SMS extends android.support.v4.app.Fragment {
	
		
		
		Button buttonSend;
		//EditText textTo;
		EditText phone_number;
		EditText textMessage;
		@Override
		public View onCreateView(final LayoutInflater inflater,
				final ViewGroup container, Bundle savedInstanceState) {
			// TODO Auto-generated method stub
			//FragmentManager fragmentManager;
			ViewGroup view = (ViewGroup) inflater.inflate(R.layout.send_sms,
					container, false);
			

			buttonSend = (Button) view.findViewById(R.id.buttonSend_SMS);
			//textTo = (EditText)view. findViewById(R.id.editTextTo);
			phone_number = (EditText) view.findViewById(R.id.editTextSubject_phone_number);
			textMessage = (EditText) view.findViewById(R.id.editTextMessage_typed);
			textMessage.setText("I’ve started using Playdate by JAGO, an awesome app to arrange & manage my kids lives.  Check it out here www.jago.nu");


			
			
			buttonSend.setOnClickListener(new OnClickListener() {
				 
				@Override
				public void onClick(View v) {
	 
				 // String to = textTo.getText().toString();
				  String phonenumber = phone_number.getText().toString();
				  String message = textMessage.getText().toString();
	             
	              SmsManager smsManager = SmsManager.getDefault();
	      		smsManager.sendTextMessage(phonenumber, null, message, null, null);
	      		
	      		phone_number.setText("");
	      		textMessage.setText("");	 
				}
			});
	 
			
			
			
			return view;
		}
	

}
