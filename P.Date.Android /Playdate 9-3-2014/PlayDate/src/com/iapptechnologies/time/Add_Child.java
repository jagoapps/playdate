package com.iapptechnologies.time;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.sql.Time;
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

import android.app.AlertDialog;
import android.app.DatePickerDialog;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.app.TimePickerDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Point;
import android.graphics.drawable.BitmapDrawable;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TimePicker;
import android.widget.Toast;

import com.iapp.playdate.R;


public class Add_Child extends android.support.v4.app.Fragment {

	Float x1, y1, x2, y2;

	EditText childname, dateofbirth, freetime, allergies, hobbies,
			school, youthclub;
	Button btn_submit, addmore_freetime;
	EditText edit, edit1;
	ImageView img_child;
	Point p;
	Boolean isInternetPresent = false;
	ConnectionDetector cd;
	int RESULT_LOAD_IMAGE = 1, CAPTURE_IMAGE_ACTIVITY_REQUEST_CODE = 999;
	int chk1 = 0;
	private int myYear, myMonth, myDay;
	static final int ID_DATEPICKER = 0;
	int hours, minutes, dayselect = 0;
	static final int DATE_DIALOG_ID = 999;

	protected static final int REQUEST_TAKE_PHOTO = 999;
	String name, dob, free_time, scHool, conDition, aLLergies, hoBBies,youthClub, url, data;
	Bitmap imageData = null;
	String days = "", daysadd = "", time, user_guardian_id;
	boolean timechk1 = false, timechk2 = false, timechk3 = false,timechk4 = false, timechk5 = false, timechk6 = false,timechk7 = false, clicked = false;
	String daymon, daytue, daywed, daythu, dayfri, daysat, daysun,date_od_birth_parent;
	// ListView allergies_1;
	File photoFile = null;
	String date_comparision,name_get, dob_get, location, freetime_get, strURL, guardiantype,firstname, fb_id, userguardiantype, userfreetime, facebook_friends,phone_number;

	
	// for checking checkboxes clicking allergies
	int i = 1, i2 = 1, i3 = 1, i4 = 1, i5 = 1, i6 = 1, i7 = 1, i8 = 1, i9 = 1,i10 = 1, i11 = 1, i12 = 1, i13 = 1, i14 = 1, i15 = 1;
	String nutMilk = "", egg = "", wheat = "", soyfish = "", corn = "",gelate = "", seed = "", spices = "", grass = "", banana = "",dairy = "", hay = "", insect = "", stings = "", celiacGluten = "",
			other = "";
	
	String cooking = "", dance = "", drama = "", drawing = "", lego = "",buildingMagicModel = "", painting = "", puzzles = "",scrapbooking = "", sewing = "", singing = "", videogaming = "",
			woodworking = "", writing = "", skating = "", otherhobbies = "",skiingSurfing = "", snowboarding = "", swimmingWater = "",football = "", baseball = "", basketball = "", climbing = "",
			cricket = "", cycling = "", judo = "", running = "", table = "",lawnTennis = "", reading = "";
	// for checkbox clicking hobbies
	int ii = 1, ii2 = 1, ii3 = 1, ii4 = 1, ii5 = 1, ii6 = 1, ii7 = 1, ii8 = 1,ii9 = 1, ii10 = 1, ii11 = 1, ii12 = 1, ii13 = 1, ii14 = 1,ii15 = 1, ii16 = 1, ii17 = 1, ii18 = 1, ii19 = 1, ii20 = 1,
         ii21 = 1, ii22 = 1, ii23 = 1, ii24 = 1, ii25 = 1, ii26 = 1,ii27 = 1, ii28 = 1, ii29 = 1;

	
	int count_alert=0;
	public Add_Child() {

	}

	
	@Override
	public View onCreateView(final LayoutInflater inflater,
			final ViewGroup container, Bundle savedInstanceState) {
		ViewGroup view = (ViewGroup) inflater.inflate(R.layout.add_child,container, false);
		getActivity().getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_PAN);
		final Home home = new Home();
		Calendar c = Calendar.getInstance();
		System.out.println("Current time => " + c.getTime());

		SimpleDateFormat df = new SimpleDateFormat("dd-MM-yyyy");
		 date_comparision = df.format(c.getTime());
		addmore_freetime = (Button) view.findViewById(R.id.button1_add_moredays);
		img_child = (ImageView) view.findViewById(R.id.imageView1_child);
		childname = (EditText) view.findViewById(R.id.edit_childname);
		dateofbirth = (EditText) view.findViewById(R.id.edit_Dob);
		freetime = (EditText) view.findViewById(R.id.edit_childfreetime);
		allergies = (EditText) view.findViewById(R.id.edit_childallergies);
		hobbies = (EditText) view.findViewById(R.id.edit_childhobbies);
		school = (EditText) view.findViewById(R.id.edit_childschool);
		youthclub = (EditText) view.findViewById(R.id.edit_childyouthclub);
		btn_submit = (Button) view.findViewById(R.id.button1_childsubmit);
		allergies.setFocusable(false);
		allergies.setClickable(true);
		hobbies.setFocusable(false);
		hobbies.setClickable(true);
		dateofbirth.setFocusable(false);
		dateofbirth.setClickable(true);
		freetime.setFocusable(false);
		freetime.setClickable(true);

		if (GlobalVariable.parent_picute_update == 3) {
			GlobalVariable.parent_picute_update = 0;
			Bitmap bitmap = getArguments().getParcelable("bitmap");
			img_child.setImageBitmap(bitmap);
			setsizeofimage();
		}
		name_get = getArguments().getString("name");
		firstname = getArguments().getString("firstname");
		fb_id = getArguments().getString("facebook_id");
		dob_get = getArguments().getString("dob");
		location = getArguments().getString("location");
		freetime_get = getArguments().getString("freetime");
		facebook_friends = getArguments().getString("facebook_friends");
		strURL = getArguments().getString("url");
		guardiantype = getArguments().getString("guardiantype");
		phone_number = getArguments().getString("phone");
		user_guardian_id = getArguments().getString("user_guardian_id");
		addmore_freetime.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				hours = new Time(System.currentTimeMillis()).getHours();
				minutes = new Time(System.currentTimeMillis()).getMinutes();
				LinearLayout viewGroup = (LinearLayout) getActivity().findViewById(R.id.weekdays_selection);
				View layout = inflater.inflate(R.layout.weekdays, viewGroup);
				final PopupWindow popup = new PopupWindow(getActivity());
				popup.setContentView(layout);
				popup.setWidth(WindowManager.LayoutParams.MATCH_PARENT);
				popup.setHeight(WindowManager.LayoutParams.MATCH_PARENT);
				popup.setFocusable(true);
				int OFFSET_X = 0;
				int OFFSET_Y = 0;
				popup.setBackgroundDrawable(new BitmapDrawable());
				popup.showAtLocation(getView(), Gravity.NO_GRAVITY, OFFSET_X,OFFSET_Y);
				RelativeLayout monday = (RelativeLayout) layout.findViewById(R.id.Monday);
				monday.setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View v) {
						clicked = true;
						TimePickerDialog tiiPickerDialog = new TimePickerDialog(getActivity(), mTimesetlistenermonto, hours,minutes, true);
						tiiPickerDialog.setTitle("TO");
						tiiPickerDialog.show();
						TimePickerDialog tiPickerDialog = new TimePickerDialog(getActivity(), mTimesetlistenermon, hours,minutes, true);
						tiPickerDialog.setTitle("FROM");
						tiPickerDialog.show();
						popup.dismiss();
					}
				});
				RelativeLayout tuesday = (RelativeLayout) layout.findViewById(R.id.Tuesday);
				tuesday.setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View v) {
						clicked = true;
						TimePickerDialog tiiPickerDialog = new TimePickerDialog(getActivity(), mTimesetlistenertueto, hours,minutes, true);
						tiiPickerDialog.setTitle("TO");
						tiiPickerDialog.show();
						TimePickerDialog tiPickerDialog = new TimePickerDialog(getActivity(), mTimesetlistenertue, hours,minutes, true);
						tiPickerDialog.setTitle("FROM");
						tiPickerDialog.show();
						popup.dismiss();
					}
				});
				RelativeLayout Wednesday = (RelativeLayout) layout.findViewById(R.id.Wednesday);
				Wednesday.setOnClickListener(new OnClickListener() {
					@Override
					public void onClick(View v) {
						clicked = true;
						TimePickerDialog tiiPickerDialog = new TimePickerDialog(getActivity(), mTimesetlistenerwedto, hours,minutes, true);
						tiiPickerDialog.setTitle("TO");
						tiiPickerDialog.show();
						TimePickerDialog tiPickerDialog = new TimePickerDialog(getActivity(), mTimesetlistenerwed, hours,minutes, true);
						tiPickerDialog.setTitle("FROM");
						tiPickerDialog.show();
						popup.dismiss();
					}
				});
				RelativeLayout Thursday = (RelativeLayout) layout.findViewById(R.id.Thursday);
				Thursday.setOnClickListener(new OnClickListener() {
					@Override
					public void onClick(View v) {
						clicked = true;
						TimePickerDialog tiiPickerDialog = new TimePickerDialog(getActivity(), mTimesetlistenerthuto, hours,minutes, true);
						tiiPickerDialog.setTitle("TO");
						tiiPickerDialog.show();
						TimePickerDialog tiPickerDialog = new TimePickerDialog(getActivity(), mTimesetlistenerthu, hours,minutes, true);
						tiPickerDialog.setTitle("FROM");
						tiPickerDialog.show();
						popup.dismiss();
					}
				});
				RelativeLayout Friday = (RelativeLayout) layout.findViewById(R.id.Friday);
				Friday.setOnClickListener(new OnClickListener() {
					@Override
					public void onClick(View v) {
						clicked = true;
						TimePickerDialog tiiPickerDialog = new TimePickerDialog(getActivity(), mTimesetlistenerfrito, hours,minutes, true);
						tiiPickerDialog.setTitle("TO");
						tiiPickerDialog.show();
						TimePickerDialog tiPickerDialog = new TimePickerDialog(getActivity(), mTimesetlistenerfri, hours,minutes, true);
						tiPickerDialog.setTitle("FROM");
						tiPickerDialog.show();
						popup.dismiss();
					}
				});
				RelativeLayout Saturday = (RelativeLayout) layout.findViewById(R.id.Saturday);
				Saturday.setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View v) {
						clicked = true;
						TimePickerDialog tiiPickerDialog = new TimePickerDialog(getActivity(), mTimesetlistenersatto, hours,minutes, true);
						tiiPickerDialog.setTitle("TO");
						tiiPickerDialog.show();
						TimePickerDialog tiPickerDialog = new TimePickerDialog(getActivity(), mTimesetlistenersat, hours,minutes, true);
						tiPickerDialog.setTitle("FROM");
						tiPickerDialog.show();
						popup.dismiss();
					}
				});
				RelativeLayout Sunday = (RelativeLayout) layout.findViewById(R.id.Sunday);
				Sunday.setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View v) {
						clicked = true;
						TimePickerDialog tiiPickerDialog = new TimePickerDialog(getActivity(), mTimesetlistenersunto, hours,minutes, true);
						tiiPickerDialog.setTitle("TO");
						tiiPickerDialog.show();
						TimePickerDialog tiPickerDialog = new TimePickerDialog(getActivity(), mTimesetlistenersun, hours,minutes, true);
						tiPickerDialog.setTitle("FROM");
						tiPickerDialog.show();
						popup.dismiss();
					}
				});

			}
		});

		freetime.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {

				hours = new Time(System.currentTimeMillis()).getHours();
				minutes = new Time(System.currentTimeMillis()).getMinutes();
				LinearLayout viewGroup = (LinearLayout) getActivity().findViewById(R.id.weekdays_selection);
				View layout = inflater.inflate(R.layout.weekdays, viewGroup);
				final PopupWindow popup = new PopupWindow(getActivity());
				popup.setContentView(layout);
				popup.setWidth(WindowManager.LayoutParams.MATCH_PARENT);
				popup.setHeight(WindowManager.LayoutParams.MATCH_PARENT);
				popup.setFocusable(true);
				int OFFSET_X = 0;
				int OFFSET_Y = 0;
				popup.setBackgroundDrawable(new BitmapDrawable());
				popup.showAtLocation(getView(), Gravity.NO_GRAVITY, OFFSET_X,OFFSET_Y);

				RelativeLayout monday = (RelativeLayout) layout.findViewById(R.id.Monday);
				monday.setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View v) {
						// TODO Auto-generated method stub
						dayselect = 1;
						clicked = true;
						TimePickerDialog tiiPickerDialog = new TimePickerDialog(getActivity(), mTimesetlistenermonto, hours,minutes, true);
						tiiPickerDialog.setTitle("TO");
						tiiPickerDialog.show();
						TimePickerDialog tiPickerDialog = new TimePickerDialog(getActivity(), mTimesetlistenermon, hours,minutes, true);
						tiPickerDialog.setTitle("FROM");
						tiPickerDialog.show();
						popup.dismiss();
					}
				});
				RelativeLayout tuesday = (RelativeLayout) layout.findViewById(R.id.Tuesday);
				tuesday.setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View v) {
						// TODO Auto-generated method stub
						dayselect = 2;
						clicked = true;
						TimePickerDialog tiiPickerDialog = new TimePickerDialog(getActivity(), mTimesetlistenertueto, hours,minutes, true);
						tiiPickerDialog.setTitle("TO");
						tiiPickerDialog.show();
						TimePickerDialog tiPickerDialog = new TimePickerDialog(getActivity(), mTimesetlistenertue, hours,minutes, true);
						tiPickerDialog.setTitle("FROM");
						tiPickerDialog.show();
						popup.dismiss();
					}
				});
				RelativeLayout Wednesday = (RelativeLayout) layout.findViewById(R.id.Wednesday);
				Wednesday.setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View v) {
						// TODO Auto-generated method stub
						dayselect = 3;
						clicked = true;
						TimePickerDialog tiiPickerDialog = new TimePickerDialog(getActivity(), mTimesetlistenerwedto, hours,minutes, true);
						tiiPickerDialog.setTitle("TO");
						tiiPickerDialog.show();
						TimePickerDialog tiPickerDialog = new TimePickerDialog(getActivity(), mTimesetlistenerwed, hours,minutes, true);
						tiPickerDialog.setTitle("FROM");
						tiPickerDialog.show();
						popup.dismiss();
					}
				});
				RelativeLayout Thursday = (RelativeLayout) layout.findViewById(R.id.Thursday);
				Thursday.setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View v) {
						// TODO Auto-generated method stub
						dayselect = 4;
						clicked = true;
						TimePickerDialog tiiPickerDialog = new TimePickerDialog(getActivity(), mTimesetlistenerthuto, hours,minutes, true);
						tiiPickerDialog.setTitle("TO");
						tiiPickerDialog.show();
						TimePickerDialog tiPickerDialog = new TimePickerDialog(getActivity(), mTimesetlistenerthu, hours,minutes, true);
						tiPickerDialog.setTitle("FROM");
						tiPickerDialog.show();
						popup.dismiss();
					}
				});
				RelativeLayout Friday = (RelativeLayout) layout.findViewById(R.id.Friday);
				Friday.setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View v) {
						// TODO Auto-generated method stub
						dayselect = 5;
						clicked = true;
						TimePickerDialog tiiPickerDialog = new TimePickerDialog(getActivity(), mTimesetlistenerfrito, hours,minutes, true);
						tiiPickerDialog.setTitle("TO");
						tiiPickerDialog.show();
						TimePickerDialog tiPickerDialog = new TimePickerDialog(getActivity(), mTimesetlistenerfri, hours,minutes, true);
						tiPickerDialog.setTitle("FROM");
						tiPickerDialog.show();
						popup.dismiss();
					}
				});
				RelativeLayout Saturday = (RelativeLayout) layout.findViewById(R.id.Saturday);
				Saturday.setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View v) {
						// TODO Auto-generated method stub
						dayselect = 6;
						clicked = true;
						TimePickerDialog tiiPickerDialog = new TimePickerDialog(getActivity(), mTimesetlistenersatto, hours,minutes, true);
						tiiPickerDialog.setTitle("TO");
						tiiPickerDialog.show();
						TimePickerDialog tiPickerDialog = new TimePickerDialog(getActivity(), mTimesetlistenersat, hours,minutes, true);
						tiPickerDialog.setTitle("FROM");
						tiPickerDialog.show();
						popup.dismiss();
					}
				});
				RelativeLayout Sunday = (RelativeLayout) layout.findViewById(R.id.Sunday);
				Sunday.setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View v) {
						// TODO Auto-generated method stub
						dayselect = 7;
						clicked = true;
						TimePickerDialog tiiPickerDialog = new TimePickerDialog(getActivity(), mTimesetlistenersunto, hours,minutes, true);
						tiiPickerDialog.setTitle("TO");
						tiiPickerDialog.show();
						TimePickerDialog tiPickerDialog = new TimePickerDialog(getActivity(), mTimesetlistenersun, hours,minutes, true);
						tiPickerDialog.setTitle("FROM");
						tiPickerDialog.show();
						popup.dismiss();
					}
				});

				

			}
		});

		btn_submit.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				name = childname.getText().toString();
				dob = dateofbirth.getText().toString();
				free_time = freetime.getText().toString();
				aLLergies = allergies.getText().toString();
				hoBBies = hobbies.getText().toString();
				scHool = school.getText().toString();
				youthClub = youthclub.getText().toString();
				if (name.length() > 0 && dob.length() > 0) {

					if (free_time.equals(null) || free_time.equals("")) {
						free_time = "";
					}
					if (aLLergies.equals(null) || aLLergies.equals("")) {
						aLLergies = "";
					}
					if (hoBBies.equals(null) || hoBBies.equals("")) {
						hoBBies = "";
					}
					if (scHool.equals(null) || scHool.equals("")) {
						scHool = "";
					}
					if (youthClub.equals(null) || youthClub.equals("")) {
						youthClub = "";
					}
					if (dob.equals(null) || dob.equals("")) {
						dob = "";
					}

					SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
					Date date_of_birth = null;
					try {
						date_of_birth = sdf.parse(dob);
					} catch (ParseException e) {
						e.printStackTrace();
					}
					SimpleDateFormat destDf = new SimpleDateFormat("yyyy-MM-dd");
					date_od_birth_parent = destDf.format(date_of_birth);
					cd = new ConnectionDetector(getActivity());
					isInternetPresent = cd.isConnectingToInternet();
					if (isInternetPresent) {
						new chilprofilecreate_webservice().execute();
					} else {
						Toast.makeText(getActivity(),
								"Please check internet connection", 2000)
								.show();

					}

				} else {
					Toast.makeText(getActivity(),
							"Name or Date of birth can not be blank", 2000)
							.show();
				}

			}
		});

		dateofbirth.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				count_alert=0;
				Calendar c = Calendar.getInstance();
				myYear = c.get(Calendar.YEAR);
				myMonth = c.get(Calendar.MONTH);
				myDay = c.get(Calendar.DAY_OF_MONTH);
				try {
					String date_from_edit_text = dateofbirth.getText()
							.toString();
					if (date_from_edit_text.equals("")
							|| date_from_edit_text.equals(null)) {

					} else {
						String[] dateArr = date_from_edit_text.split("-");

						myDay = Integer.parseInt(dateArr[0]);
						myMonth = Integer.parseInt(dateArr[1]) - 1;
						myYear = Integer.parseInt(dateArr[2]);
					}

				} catch (Exception e) {
					// TODO: handle exception
				}
				DatePickerDialog d = new DatePickerDialog(getActivity(),
						mDateSetListener, myYear, myMonth, myDay);

				d.show();

			}
		});
		img_child.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				
				new AlertDialog.Builder(getActivity())
						.setTitle("Select Picture")
						.setMessage("Complete action using")
						.setPositiveButton("Gallery",
								new DialogInterface.OnClickListener() {
									public void onClick(DialogInterface dialog,
											int which) {
										
										Intent intent = new Intent(
				                                Intent.ACTION_GET_CONTENT);
				                        intent.setType("image/*");

				                        Intent chooser = Intent
				                                .createChooser(
				                                        intent,
				                                        "Choose a Picture");
				                       getActivity().startActivityForResult(
				                                chooser,
				                                RESULT_LOAD_IMAGE);
									}
								})
						.setNegativeButton("Camera",
								new DialogInterface.OnClickListener() {
									public void onClick(DialogInterface dialog,
											int which) {
										
										GlobalVariable.parent_picute_update = 3;
										Intent it = new Intent(getActivity(),
												Home.class);
										it.putExtra("url", strURL);
										it.putExtra("name", name_get);
										it.putExtra("firstname", firstname);
										it.putExtra("iD", fb_id);
										it.putExtra("location", location);
										it.putExtra("dob", dob_get);
										it.putExtra("guardiantype",
												guardiantype);
										it.putExtra("freetime", freetime_get);
										it.putExtra("phone", phone_number);
										it.putExtra("user_guardian_id",
												user_guardian_id);
										it.putExtra("facebook_friends",
												facebook_friends);
										

										getActivity().startActivity(it);
									}
								}).setIcon(android.R.drawable.ic_dialog_alert)
						.show();

				

			}

			
		});

		allergies.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				

				allergies.setText("");
				
				LinearLayout viewGroup = (LinearLayout) getActivity()
						.findViewById(R.id.popup_allergies);
				View layout = inflater.inflate(R.layout.allergies, viewGroup);
				final PopupWindow popup = new PopupWindow(getActivity());
				popup.setContentView(layout);
				popup.setWidth(WindowManager.LayoutParams.MATCH_PARENT);
				popup.setHeight(WindowManager.LayoutParams.MATCH_PARENT);
				popup.setFocusable(true);
				int OFFSET_X = 0;
				int OFFSET_Y = 0;
				popup.setBackgroundDrawable(new BitmapDrawable());
				popup.showAtLocation(getView(), Gravity.NO_GRAVITY, OFFSET_X,
						OFFSET_Y);
				RelativeLayout nutmilk = (RelativeLayout) layout
						.findViewById(R.id.Nutmilk);
				CheckBox chk = (CheckBox) nutmilk
						.findViewById(R.id.checkBox1_1);
				chk.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (i % 2 == 0) {
							nutMilk = "";
							System.out.println("even" + nutMilk);
							i++;
						} else {
							nutMilk = "Nutmilk";
							System.out.println("odd" + nutMilk);
							i++;
						}
					}
				});

				
				RelativeLayout egg1 = (RelativeLayout) layout
						.findViewById(R.id.egg);
				CheckBox chk2 = (CheckBox) egg1.findViewById(R.id.checkBox1_2);
				chk2.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (i2 % 2 == 0) {
							egg = "";
							System.out.println("even" + egg);
							i2++;
						} else {
							egg = "Egg";
							System.out.println("odd" + egg);
							i2++;
						}
					}
				});

				// Add bp Records pop layout
				RelativeLayout wheat1 = (RelativeLayout) layout
						.findViewById(R.id.wheat);
				CheckBox chk3 = (CheckBox) wheat1
						.findViewById(R.id.checkBox1_3);
				chk3.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (i3 % 2 == 0) {
							wheat = "";
							System.out.println("even" + wheat);
							i3++;
						} else {
							wheat = "Wheat";
							System.out.println("odd" + wheat);
							i3++;
						}
					}
				});
				// // bp Records reading pop layout
				RelativeLayout soyfish1 = (RelativeLayout) layout
						.findViewById(R.id.SoyFish);
				CheckBox chk4 = (CheckBox) soyfish1
						.findViewById(R.id.checkBox1_4);
				chk4.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (i4 % 2 == 0) {
							soyfish = "";
							System.out.println("even" + soyfish);
							i4++;
						} else {
							soyfish = "Soyfish";
							System.out.println("odd" + soyfish);
							i4++;
						}
					}
				});
				RelativeLayout Corn = (RelativeLayout) layout
						.findViewById(R.id.Corn);
				CheckBox chk5 = (CheckBox) Corn.findViewById(R.id.checkBox1_5);
				chk5.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (i5 % 2 == 0) {
							corn = "";
							System.out.println("even" + corn);
							i5++;
						} else {
							corn = "Corn";
							System.out.println("odd" + corn);
							i5++;
						}
					}
				});
				// // body weight reading pop layout
				RelativeLayout GelatinMeat = (RelativeLayout) layout
						.findViewById(R.id.GelatinMeat);
				CheckBox chk6 = (CheckBox) GelatinMeat
						.findViewById(R.id.checkBox1_6);
				chk6.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (i6 % 2 == 0) {
							gelate = "";
							System.out.println("even" + gelate);
							i6++;
						} else {
							gelate = "GelatinMeat";
							System.out.println("odd" + gelate);
							i6++;
						}
					}
				});
				// Add bp Records pop layout
				RelativeLayout Seeds = (RelativeLayout) layout
						.findViewById(R.id.Seeds);
				CheckBox chk7 = (CheckBox) Seeds.findViewById(R.id.checkBox1_7);
				chk7.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (i7 % 2 == 0) {
							seed = "";
							System.out.println("even" + seed);
							i7++;
						} else {
							seed = "Seeds";
							System.out.println("odd" + seed);
							i7++;
						}
					}
				});

				// // bp Records reading pop layout
				RelativeLayout Spices = (RelativeLayout) layout
						.findViewById(R.id.Spices);
				CheckBox chk8 = (CheckBox) Spices
						.findViewById(R.id.checkBox1_8);
				chk8.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (i8 % 2 == 0) {
							spices = "";
							System.out.println("even" + spices);
							i8++;
						} else {
							spices = "Spices";
							System.out.println("odd" + spices);
							i8++;
						}
					}
				});
				RelativeLayout Grass = (RelativeLayout) layout
						.findViewById(R.id.Grass);
				CheckBox chk9 = (CheckBox) Grass.findViewById(R.id.checkBox1_9);
				chk9.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (i9 % 2 == 0) {
							grass = "";
							System.out.println("even" + grass);
							i9++;
						} else {
							grass = "Grass";
							System.out.println("odd" + grass);
							i9++;
						}
					}
				});
				// // body weight reading pop layout
				RelativeLayout Banana = (RelativeLayout) layout
						.findViewById(R.id.Banana);
				CheckBox chk10 = (CheckBox) Banana
						.findViewById(R.id.checkBox1_10);
				chk10.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (i10 % 2 == 0) {
							banana = "";
							System.out.println("even" + banana);
							i10++;
						} else {
							banana = "Banana";
							System.out.println("odd" + banana);
							i10++;
						}
					}
				});

				// Add bp Records pop layout
				RelativeLayout DairyAnaphylaxis = (RelativeLayout) layout
						.findViewById(R.id.DairyAnaphylaxis);
				CheckBox chk11 = (CheckBox) DairyAnaphylaxis
						.findViewById(R.id.checkBox1_11);
				chk11.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (i11 % 2 == 0) {
							dairy = "";
							System.out.println("even" + dairy);
							i11++;
						} else {
							dairy = "Dairy Anaphy laxis";
							System.out.println("odd" + dairy);
							i11++;
						}
					}
				});

				// // bp Records reading pop layout
				RelativeLayout HayfeaverInsect = (RelativeLayout) layout
						.findViewById(R.id.HayfeaverInsect);
				CheckBox chk12 = (CheckBox) HayfeaverInsect
						.findViewById(R.id.checkBox1_12);
				chk12.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (i12 % 2 == 0) {
							hay = "";
							System.out.println("even" + hay);
							i12++;
						} else {
							hay = "Hay feaver Insect";
							System.out.println("odd" + hay);
							i12++;
						}
					}
				});
				RelativeLayout Insect = (RelativeLayout) layout
						.findViewById(R.id.Insect);
				CheckBox chk13 = (CheckBox) Insect
						.findViewById(R.id.checkBox1_13);
				chk13.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (i13 % 2 == 0) {
							insect = "";
							System.out.println("even" + insect);
							i13++;
						} else {
							insect = "Insect";
							System.out.println("odd" + insect);
							i13++;
						}
					}
				});

				// // body weight reading pop layout
				RelativeLayout StingsLactose = (RelativeLayout) layout
						.findViewById(R.id.StingsLactose);
				CheckBox chk14 = (CheckBox) StingsLactose
						.findViewById(R.id.checkBox1_14);
				chk14.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (i14 % 2 == 0) {
							stings = "";
							System.out.println("even" + stings);
							i14++;
						} else {
							stings = "Stings Lactose";
							System.out.println("odd" + stings);
							i14++;
						}
					}
				});
				// Add bp Records pop layout
				RelativeLayout CeliacGluten = (RelativeLayout) layout
						.findViewById(R.id.CeliacGluten);
				CheckBox chk15 = (CheckBox) CeliacGluten
						.findViewById(R.id.checkBox1_15);
				chk15.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						String nutmilk = "";

						if (i15 % 2 == 0) {
							celiacGluten = "";
							System.out.println("even" + celiacGluten);
							i15++;
						} else {
							celiacGluten = "CeliacGluten";
							System.out.println("odd" + celiacGluten);
							i15++;
						}
					}
				});
				RelativeLayout edittext = (RelativeLayout) layout
						.findViewById(R.id.edit_allergies);
				edit = (EditText) edittext
						.findViewById(R.id.editText_allergies_xml);

				// // bp Records reading pop layout
				RelativeLayout submit = (RelativeLayout) layout
						.findViewById(R.id.button_submit_allergies);
				Button submit1 = (Button) submit
						.findViewById(R.id.button1_allergies);
				submit1.setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View v) {
						// TODO Auto-generated method stub
						String allergies_selected = "";
						other = edit.getText().toString();
						if (other.equals("") || other.equals(null)) {

						} else {

							if (allergies_selected.equals("")
									|| allergies_selected.equals(null)) {
								allergies_selected = other;
							} else {
								allergies_selected = allergies_selected + ","
										+ other;
							}
						}
						// nutMilk="",egg="",wheat="",soyfish="",corn="",gelate="",seed="",spices="",grass="",banana="",dairy="",hay="",insect="",stings="",celiacGluten=""
						if (!nutMilk.equals("")) {
							if (allergies_selected.equals("")
									|| allergies_selected.equals(null)) {
								allergies_selected = nutMilk;
							} else {
								allergies_selected = allergies_selected + ","
										+ nutMilk;
							}
						}
						if (!egg.equals("")) {
							if (allergies_selected.equals("")
									|| allergies_selected.equals(null)) {
								allergies_selected = egg;
							} else {
								allergies_selected = allergies_selected + ","
										+ egg;
							}
						}
						if (!wheat.equals("")) {
							if (allergies_selected.equals("")
									|| allergies_selected.equals(null)) {
								allergies_selected = wheat;
							} else {
								allergies_selected = allergies_selected + ","
										+ wheat;
							}
						}
						if (!soyfish.equals("")) {
							if (allergies_selected.equals("")
									|| allergies_selected.equals(null)) {
								allergies_selected = soyfish;
							} else {
								allergies_selected = allergies_selected + ","
										+ soyfish;
							}
						}
						if (!corn.equals("")) {
							if (allergies_selected.equals("")
									|| allergies_selected.equals(null)) {
								allergies_selected = corn;
							} else {
								allergies_selected = allergies_selected + ","
										+ corn;
							}
						}
						if (!gelate.equals("")) {
							if (allergies_selected.equals("")
									|| allergies_selected.equals(null)) {
								allergies_selected = gelate;
							} else {
								allergies_selected = allergies_selected + ","
										+ gelate;
							}
						}
						if (!seed.equals("")) {
							if (allergies_selected.equals("")
									|| allergies_selected.equals(null)) {
								allergies_selected = seed;
							} else {
								allergies_selected = allergies_selected + ","
										+ seed;
							}
						}
						if (!spices.equals("")) {
							if (allergies_selected.equals("")
									|| allergies_selected.equals(null)) {
								allergies_selected = spices;
							} else {
								allergies_selected = allergies_selected + ","
										+ spices;
							}
						}
						if (!grass.equals("")) {
							if (allergies_selected.equals("")
									|| allergies_selected.equals(null)) {
								allergies_selected = grass;
							} else {
								allergies_selected = allergies_selected + ","
										+ grass;
							}
						}
						if (!banana.equals("")) {
							if (allergies_selected.equals("")
									|| allergies_selected.equals(null)) {
								allergies_selected = banana;
							} else {
								allergies_selected = allergies_selected + ","
										+ banana;
							}
						}
						if (!dairy.equals("")) {
							if (allergies_selected.equals("")
									|| allergies_selected.equals(null)) {
								allergies_selected = dairy;
							} else {
								allergies_selected = allergies_selected + ","
										+ dairy;
							}
						}
						if (!hay.equals("")) {
							if (allergies_selected.equals("")
									|| allergies_selected.equals(null)) {
								allergies_selected = hay;
							} else {
								allergies_selected = allergies_selected + ","
										+ hay;
							}
						}
						if (!insect.equals("")) {
							if (allergies_selected.equals("")
									|| allergies_selected.equals(null)) {
								allergies_selected = insect;
							} else {
								allergies_selected = allergies_selected + ","
										+ insect;
							}
						}
						if (!stings.equals("")) {
							if (allergies_selected.equals("")
									|| allergies_selected.equals(null)) {
								allergies_selected = stings;
							} else {
								allergies_selected = allergies_selected + ","
										+ stings;
							}
						}
						if (!celiacGluten.equals("")) {
							if (allergies_selected.equals("")
									|| allergies_selected.equals(null)) {
								allergies_selected = celiacGluten;
							} else {
								allergies_selected = allergies_selected + ","
										+ celiacGluten;
							}
						}
						System.out.println(allergies_selected);
						allergies.setText(allergies_selected.toUpperCase());
						nutMilk = "";egg = "";wheat = "";soyfish = "";corn = "";gelate = "";seed = "";spices = "";grass = "";banana = "";dairy = "";hay = "";
						insect = "";stings = "";celiacGluten = "";other = "";
						popup.dismiss();
					}

				});
				
			}

		});

		hobbies.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub

				hobbies.setText("");
				
				LinearLayout viewGroup = (LinearLayout) getActivity()
						.findViewById(R.id.popup_hobbies);
				
				View layout = inflater.inflate(R.layout.hobbies, viewGroup);
				final PopupWindow popup = new PopupWindow(getActivity());
				popup.setContentView(layout);
				popup.setWidth(WindowManager.LayoutParams.MATCH_PARENT);
				popup.setHeight(WindowManager.LayoutParams.MATCH_PARENT);
				popup.setFocusable(true);
				int OFFSET_X = 0;
				int OFFSET_Y = 0;
				popup.setBackgroundDrawable(new BitmapDrawable());
				popup.showAtLocation(getView(), Gravity.NO_GRAVITY, OFFSET_X,OFFSET_Y);

				RelativeLayout cooKing = (RelativeLayout) layout
						.findViewById(R.id.Cooking);
				CheckBox chk = (CheckBox) cooKing
						.findViewById(R.id.checkBox11_1);
				chk.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (ii % 2 == 0) {
							cooking = "";
							System.out.println("even" + cooking);
							ii++;
						} else {
							cooking = "Cooking";
							System.out.println("odd" + cooking);
							ii++;
						}
					}
				});

				
				RelativeLayout Dance = (RelativeLayout) layout
						.findViewById(R.id.Dance);
				CheckBox chk2 = (CheckBox) Dance
						.findViewById(R.id.checkBox11_2);
				chk2.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (ii2 % 2 == 0) {
							dance = "";
							System.out.println("even" + dance);
							ii2++;
						} else {
							dance = "Dance";
							System.out.println("odd" + dance);
							ii2++;
						}
					}
				});

				// Add bp Records pop layout
				RelativeLayout Drama = (RelativeLayout) layout
						.findViewById(R.id.Drama);
				CheckBox chk3 = (CheckBox) Drama
						.findViewById(R.id.checkBox11_3);
				chk3.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (ii3 % 2 == 0) {
							drama = "";
							System.out.println("even" + drama);
							ii3++;
						} else {
							drama = "Drama";
							System.out.println("odd" + drama);
							ii3++;
						}
					}
				});
				// // bp Records reading pop layout
				RelativeLayout Drawing = (RelativeLayout) layout
						.findViewById(R.id.Drawing);
				CheckBox chk4 = (CheckBox) Drawing
						.findViewById(R.id.checkBox11_4);
				chk4.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (ii4 % 2 == 0) {
							drawing = "";
							System.out.println("even" + drawing);
							ii4++;
						} else {
							drawing = "Drawing";
							System.out.println("odd" + drawing);
							ii4++;
						}
					}
				});
				RelativeLayout Lego = (RelativeLayout) layout
						.findViewById(R.id.Lego);
				CheckBox chk5 = (CheckBox) Lego.findViewById(R.id.checkBox11_5);
				chk5.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (ii5 % 2 == 0) {
							lego = "";
							System.out.println("even" + lego);
							ii5++;
						} else {
							lego = "Lego";
							System.out.println("odd" + lego);
							ii5++;
						}
					}
				});
				// // body weight reading pop layout
				RelativeLayout BuildingMagicModel = (RelativeLayout) layout
						.findViewById(R.id.BuildingMagicModel);
				CheckBox chk6 = (CheckBox) BuildingMagicModel
						.findViewById(R.id.checkBox11_6);
				chk6.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (ii6 % 2 == 0) {
							buildingMagicModel = "";
							System.out.println("even" + buildingMagicModel);
							ii6++;
						} else {
							buildingMagicModel = "Building Magic Model";
							System.out.println("odd" + buildingMagicModel);
							ii6++;
						}
					}
				});
				// Add bp Records pop layout
				RelativeLayout Painting = (RelativeLayout) layout
						.findViewById(R.id.Painting);
				CheckBox chk7 = (CheckBox) Painting
						.findViewById(R.id.checkBox11_7);
				chk7.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (ii7 % 2 == 0) {
							painting = "";
							System.out.println("even" + painting);
							ii7++;
						} else {
							painting = "Painting";
							System.out.println("odd" + painting);
							ii7++;
						}
					}
				});

				// // bp Records reading pop layout
				RelativeLayout Puzzles = (RelativeLayout) layout
						.findViewById(R.id.Puzzles);
				CheckBox chk8 = (CheckBox) Puzzles
						.findViewById(R.id.checkBox11_8);
				chk8.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (ii8 % 2 == 0) {
							puzzles = "";
							System.out.println("even" + puzzles);
							ii8++;
						} else {
							puzzles = "Puzzles";
							System.out.println("odd" + puzzles);
							ii8++;
						}
					}
				});
				RelativeLayout Scrapbooking = (RelativeLayout) layout
						.findViewById(R.id.Scrapbooking);
				CheckBox chk9 = (CheckBox) Scrapbooking
						.findViewById(R.id.checkBox11_9);
				chk9.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (ii9 % 2 == 0) {
							scrapbooking = "";
							System.out.println("even" + scrapbooking);
							ii9++;
						} else {
							scrapbooking = "Scrapbooking";
							System.out.println("odd" + scrapbooking);
							ii9++;
						}
					}
				});
				// // body weight reading pop layout
				RelativeLayout Sewing = (RelativeLayout) layout
						.findViewById(R.id.Sewing);
				CheckBox chk10 = (CheckBox) Sewing
						.findViewById(R.id.checkBox11_10);
				chk10.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (ii10 % 2 == 0) {
							sewing = "";
							System.out.println("even" + sewing);
							ii10++;
						} else {
							sewing = "Sewing";
							System.out.println("odd" + sewing);
							ii10++;
						}
					}
				});

				// Add bp Records pop layout
				RelativeLayout Singing = (RelativeLayout) layout
						.findViewById(R.id.Singing);
				CheckBox chk11 = (CheckBox) Singing
						.findViewById(R.id.checkBox11_11);
				chk11.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (ii11 % 2 == 0) {
							singing = "";
							System.out.println("even" + singing);
							ii11++;
						} else {
							singing = "Singing";
							System.out.println("odd" + singing);
							ii11++;
						}
					}
				});

				// // bp Records reading pop layout
				RelativeLayout Videogaming = (RelativeLayout) layout
						.findViewById(R.id.Videogaming);
				CheckBox chk12 = (CheckBox) Videogaming
						.findViewById(R.id.checkBox11_12);
				chk12.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (ii12 % 2 == 0) {
							videogaming = "";
							System.out.println("even" + videogaming);
							ii12++;
						} else {
							videogaming = "Videogaming";
							System.out.println("odd" + videogaming);
							ii12++;
						}
					}
				});
				RelativeLayout Woodworking = (RelativeLayout) layout
						.findViewById(R.id.Woodworking);
				CheckBox chk13 = (CheckBox) Woodworking
						.findViewById(R.id.checkBox11_13);
				chk13.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (ii13 % 2 == 0) {
							woodworking = "";
							System.out.println("even" + woodworking);
							ii13++;
						} else {
							woodworking = "Woodworking";
							System.out.println("odd" + woodworking);
							ii13++;
						}
					}
				});

				// // body weight reading pop layout
				RelativeLayout Writing = (RelativeLayout) layout
						.findViewById(R.id.Writing);
				CheckBox chk14 = (CheckBox) Writing
						.findViewById(R.id.checkBox11_14);
				chk14.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (ii14 % 2 == 0) {
							writing = "";
							System.out.println("even" + writing);
							ii14++;
						} else {
							writing = "Writing";
							System.out.println("odd" + writing);
							ii14++;
						}
					}
				});

				// Add bp Records pop layout
				RelativeLayout Skating = (RelativeLayout) layout
						.findViewById(R.id.Skating);
				CheckBox chk15 = (CheckBox) Skating
						.findViewById(R.id.checkBox11_15);
				chk15.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						String nutmilk = "";

						if (ii15 % 2 == 0) {
							skating = "";
							System.out.println("even" + skating);
							ii15++;
						} else {
							skating = "Skating";
							System.out.println("odd" + skating);
							ii15++;
						}
					}
				});
				RelativeLayout SkiingSurfing = (RelativeLayout) layout
						.findViewById(R.id.SkiingSurfing);
				CheckBox chk16 = (CheckBox) SkiingSurfing
						.findViewById(R.id.checkBox11_16);
				chk16.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (ii16 % 2 == 0) {
							skiingSurfing = "";
							System.out.println("even" + skiingSurfing);
							ii16++;
						} else {
							skiingSurfing = "Skiing Surfing";
							System.out.println("odd" + skiingSurfing);
							ii16++;
						}
					}
				});
				// // bp Records reading pop layout
				RelativeLayout Snowboarding = (RelativeLayout) layout
						.findViewById(R.id.Snowboarding);
				CheckBox chk17 = (CheckBox) Snowboarding
						.findViewById(R.id.checkBox11_17);
				chk17.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (ii17 % 2 == 0) {
							snowboarding = "";
							System.out.println("even" + snowboarding);
							ii17++;
						} else {
							snowboarding = "Snow boarding";
							System.out.println("odd" + snowboarding);
							ii17++;
						}
					}
				});
				RelativeLayout SwimmingWater = (RelativeLayout) layout
						.findViewById(R.id.SwimmingWater);
				CheckBox chk18 = (CheckBox) SwimmingWater
						.findViewById(R.id.checkBox11_18);
				chk18.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (ii18 % 2 == 0) {
							swimmingWater = "";
							System.out.println("even" + swimmingWater);
							ii18++;
						} else {
							swimmingWater = "Swimming Water";
							System.out.println("odd" + swimmingWater);
							ii18++;
						}
					}
				});
				// // body weight reading pop layout
				RelativeLayout Football = (RelativeLayout) layout
						.findViewById(R.id.Football);
				CheckBox chk19 = (CheckBox) Football
						.findViewById(R.id.checkBox11_19);
				chk19.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (ii19 % 2 == 0) {
							football = "";
							System.out.println("even" + football);
							ii19++;
						} else {
							football = "Football";
							System.out.println("odd" + buildingMagicModel);
							ii19++;
						}
					}
				});
				// Add bp Records pop layout
				RelativeLayout Baseball = (RelativeLayout) layout
						.findViewById(R.id.Baseball);
				CheckBox chk20 = (CheckBox) Baseball
						.findViewById(R.id.checkBox11_20);
				chk20.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (ii20 % 2 == 0) {
							baseball = "";
							System.out.println("even" + baseball);
							ii20++;
						} else {
							baseball = "Baseball";
							System.out.println("odd" + baseball);
							ii20++;
						}
					}
				});

				// // bp Records reading pop layout
				RelativeLayout Basketball = (RelativeLayout) layout
						.findViewById(R.id.Basketball);
				CheckBox chk21 = (CheckBox) Basketball
						.findViewById(R.id.checkBox11_21);
				chk21.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (ii21 % 2 == 0) {
							basketball = "";
							System.out.println("even" + basketball);
							ii21++;
						} else {
							basketball = "Basketball";
							System.out.println("odd" + basketball);
							ii21++;
						}
					}
				});
				RelativeLayout Climbing = (RelativeLayout) layout
						.findViewById(R.id.Climbing);
				CheckBox chk22 = (CheckBox) Climbing
						.findViewById(R.id.checkBox11_22);
				chk22.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (ii22 % 2 == 0) {
							climbing = "";
							System.out.println("even" + climbing);
							ii22++;
						} else {
							climbing = "Climbing";
							System.out.println("odd" + climbing);
							ii22++;
						}
					}
				});
				// // body weight reading pop layout
				RelativeLayout Cricket = (RelativeLayout) layout
						.findViewById(R.id.Cricket);
				CheckBox chk23 = (CheckBox) Cricket
						.findViewById(R.id.checkBox11_23);
				chk23.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (ii23 % 2 == 0) {
							cricket = "";
							System.out.println("even" + cricket);
							ii23++;
						} else {
							cricket = "Cricket";
							System.out.println("odd" + cricket);
							ii23++;
						}
					}
				});

				// Add bp Records pop layout
				RelativeLayout Cycling = (RelativeLayout) layout
						.findViewById(R.id.Cycling);
				CheckBox chk24 = (CheckBox) Cycling
						.findViewById(R.id.checkBox11_24);
				chk24.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (ii24 % 2 == 0) {
							cycling = "";
							System.out.println("even" + cycling);
							ii24++;
						} else {
							cycling = "Cycling";
							System.out.println("odd" + cycling);
							ii24++;
						}
					}
				});

				// // bp Records reading pop layout
				RelativeLayout Judo = (RelativeLayout) layout
						.findViewById(R.id.Judo);
				CheckBox chk25 = (CheckBox) Judo
						.findViewById(R.id.checkBox11_25);
				chk25.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (ii25 % 2 == 0) {
							judo = "";
							System.out.println("even" + judo);
							ii25++;
						} else {
							judo = "judo";
							System.out.println("odd" + judo);
							ii25++;
						}
					}
				});
				RelativeLayout Running = (RelativeLayout) layout
						.findViewById(R.id.Running);
				CheckBox chk26 = (CheckBox) Running
						.findViewById(R.id.checkBox11_26);
				chk26.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (ii26 % 2 == 0) {
							running = "";
							System.out.println("even" + running);
							ii26++;
						} else {
							running = "Running";
							System.out.println("odd" + running);
							ii26++;
						}
					}
				});

				// // body weight reading pop layout
				RelativeLayout Table = (RelativeLayout) layout
						.findViewById(R.id.Table);
				CheckBox chk27 = (CheckBox) Table
						.findViewById(R.id.checkBox11_27);
				chk27.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (ii27 % 2 == 0) {
							table = "";
							System.out.println("even" + table);
							ii27++;
						} else {
							table = "Table Tennis";
							System.out.println("odd" + writing);
							ii27++;
						}
					}
				});
				RelativeLayout LawnTennis = (RelativeLayout) layout
						.findViewById(R.id.LawnTennis);
				CheckBox chk28 = (CheckBox) LawnTennis
						.findViewById(R.id.checkBox11_28);
				chk28.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (ii28 % 2 == 0) {
							lawnTennis = "";
							System.out.println("even" + lawnTennis);
							ii28++;
						} else {
							lawnTennis = "Lawn Tennis";
							System.out.println("odd" + lawnTennis);
							ii28++;
						}
					}
				});
				RelativeLayout Reading = (RelativeLayout) layout
						.findViewById(R.id.Reading);
				CheckBox chk29 = (CheckBox) Reading
						.findViewById(R.id.checkBox11_29);
				chk29.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						// TODO Auto-generated method stub

						if (ii29 % 2 == 0) {
							reading = "";
							System.out.println("even" + reading);
							ii29++;
						} else {
							reading = "Reading";
							System.out.println("odd" + reading);
							ii29++;
						}
					}
				});

				RelativeLayout edittext = (RelativeLayout) layout
						.findViewById(R.id.edit_hobbies);
				edit1 = (EditText) edittext
						.findViewById(R.id.editText_hobbies_xml);

				// // bp Records reading pop layout
				RelativeLayout submit2 = (RelativeLayout) layout
						.findViewById(R.id.button_layout_hobbies);
				Button submit1 = (Button) submit2
						.findViewById(R.id.button1_hobbies);
				submit1.setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View v) {
						// TODO Auto-generated method stub
						String hobbies_selected = "";
						otherhobbies = edit1.getText().toString();
						if (otherhobbies.equals("")
								|| otherhobbies.equals(null)) {

						} else {

							if (hobbies_selected.equals("")
									|| hobbies_selected.equals(null)) {
								hobbies_selected = otherhobbies;
							} else {
								hobbies_selected = hobbies_selected + ","
										+ otherhobbies;
							}
						}

						// nutMilk="",egg="",wheat="",soyfish="",corn="",gelate="",seed="",spices="",grass="",banana="",dairy="",hay="",insect="",stings="",celiacGluten=""
						if (!cooking.equals("")) {
							if (hobbies_selected.equals("")
									|| hobbies_selected.equals(null)) {
								hobbies_selected = cooking;
							} else {
								hobbies_selected = hobbies_selected + ","
										+ cooking;
							}
						}
						if (!dance.equals("")) {
							if (hobbies_selected.equals("")
									|| hobbies_selected.equals(null)) {
								hobbies_selected = dance;
							} else {
								hobbies_selected = hobbies_selected + ","
										+ dance;
							}
						}
						if (!drama.equals("")) {
							if (hobbies_selected.equals("")
									|| hobbies_selected.equals(null)) {
								hobbies_selected = drama;
							} else {
								hobbies_selected = hobbies_selected + ","
										+ drama;
							}
						}
						if (!drawing.equals("")) {
							if (hobbies_selected.equals("")
									|| hobbies_selected.equals(null)) {
								hobbies_selected = drawing;
							} else {
								hobbies_selected = hobbies_selected + ","
										+ drawing;
							}
						}
						/*
						 * if (!corn.equals("")) { if
						 * (hobbies_selected.equals("") ||
						 * hobbies_selected.equals(null)) { hobbies_selected =
						 * corn; } else { hobbies_selected = hobbies_selected +
						 * "," + corn; } }
						 */
						if (!lego.equals("")) {
							if (hobbies_selected.equals("")
									|| hobbies_selected.equals(null)) {
								hobbies_selected = lego;
							} else {
								hobbies_selected = hobbies_selected + ","
										+ lego;
							}
						}
						if (!buildingMagicModel.equals("")) {
							if (hobbies_selected.equals("")
									|| hobbies_selected.equals(null)) {
								hobbies_selected = buildingMagicModel;
							} else {
								hobbies_selected = hobbies_selected + ","
										+ buildingMagicModel;
							}
						}
						if (!painting.equals("")) {
							if (hobbies_selected.equals("")
									|| hobbies_selected.equals(null)) {
								hobbies_selected = painting;
							} else {
								hobbies_selected = hobbies_selected + ","
										+ painting;
							}
						}
						if (!puzzles.equals("")) {
							if (hobbies_selected.equals("")
									|| hobbies_selected.equals(null)) {
								hobbies_selected = puzzles;
							} else {
								hobbies_selected = hobbies_selected + ","
										+ puzzles;
							}
						}
						if (!scrapbooking.equals("")) {
							if (hobbies_selected.equals("")
									|| hobbies_selected.equals(null)) {
								hobbies_selected = scrapbooking;
							} else {
								hobbies_selected = hobbies_selected + ","
										+ scrapbooking;
							}
						}
						if (!sewing.equals("")) {
							if (hobbies_selected.equals("")
									|| hobbies_selected.equals(null)) {
								hobbies_selected = sewing;
							} else {
								hobbies_selected = hobbies_selected + ","
										+ sewing;
							}
						}
						if (!singing.equals("")) {
							if (hobbies_selected.equals("")
									|| hobbies_selected.equals(null)) {
								hobbies_selected = singing;
							} else {
								hobbies_selected = hobbies_selected + ","
										+ singing;
							}
						}
						if (!videogaming.equals("")) {
							if (hobbies_selected.equals("")
									|| hobbies_selected.equals(null)) {
								hobbies_selected = videogaming;
							} else {
								hobbies_selected = hobbies_selected + ","
										+ videogaming;
							}
						}
						if (!woodworking.equals("")) {
							if (hobbies_selected.equals("")
									|| hobbies_selected.equals(null)) {
								hobbies_selected = woodworking;
							} else {
								hobbies_selected = hobbies_selected + ","
										+ woodworking;
							}
						}
						if (!writing.equals("")) {
							if (hobbies_selected.equals("")
									|| hobbies_selected.equals(null)) {
								hobbies_selected = writing;
							} else {
								hobbies_selected = hobbies_selected + ","
										+ writing;
							}
						}

					
						if (!skating.equals("")) {
							if (hobbies_selected.equals("")
									|| hobbies_selected.equals(null)) {
								hobbies_selected = skating;
							} else {
								hobbies_selected = hobbies_selected + ","
										+ skating;
							}
						}
						if (!skiingSurfing.equals("")) {
							if (hobbies_selected.equals("")
									|| hobbies_selected.equals(null)) {
								hobbies_selected = skiingSurfing;
							} else {
								hobbies_selected = hobbies_selected + ","
										+ skiingSurfing;
							}
						}
						if (!snowboarding.equals("")) {
							if (hobbies_selected.equals("")
									|| hobbies_selected.equals(null)) {
								hobbies_selected = snowboarding;
							} else {
								hobbies_selected = hobbies_selected + ","
										+ snowboarding;
							}
						}
						if (!swimmingWater.equals("")) {
							if (hobbies_selected.equals("")
									|| hobbies_selected.equals(null)) {
								hobbies_selected = swimmingWater;
							} else {
								hobbies_selected = hobbies_selected + ","
										+ swimmingWater;
							}
						}
						if (!football.equals("")) {
							if (hobbies_selected.equals("")
									|| hobbies_selected.equals(null)) {
								hobbies_selected = football;
							} else {
								hobbies_selected = hobbies_selected + ","
										+ football;
							}
						}
						if (!baseball.equals("")) {
							if (hobbies_selected.equals("")
									|| hobbies_selected.equals(null)) {
								hobbies_selected = baseball;
							} else {
								hobbies_selected = hobbies_selected + ","
										+ baseball;
							}
						}
						if (!basketball.equals("")) {
							if (hobbies_selected.equals("")
									|| hobbies_selected.equals(null)) {
								hobbies_selected = basketball;
							} else {
								hobbies_selected = hobbies_selected + ","
										+ basketball;
							}
						}
						if (!climbing.equals("")) {
							if (hobbies_selected.equals("")
									|| hobbies_selected.equals(null)) {
								hobbies_selected = climbing;
							} else {
								hobbies_selected = hobbies_selected + ","
										+ climbing;
							}
						}
						if (!cricket.equals("")) {
							if (hobbies_selected.equals("")
									|| hobbies_selected.equals(null)) {
								hobbies_selected = cricket;
							} else {
								hobbies_selected = hobbies_selected + ","
										+ cricket;
							}
						}
						if (!cycling.equals("")) {
							if (hobbies_selected.equals("")
									|| hobbies_selected.equals(null)) {
								hobbies_selected = cycling;
							} else {
								hobbies_selected = hobbies_selected + ","
										+ cycling;
							}
						}
						if (!judo.equals("")) {
							if (hobbies_selected.equals("")
									|| hobbies_selected.equals(null)) {
								hobbies_selected = judo;
							} else {
								hobbies_selected = hobbies_selected + ","
										+ judo;
							}
						}
						if (!singing.equals("")) {
							if (hobbies_selected.equals("")
									|| hobbies_selected.equals(null)) {
								hobbies_selected = singing;
							} else {
								hobbies_selected = hobbies_selected + ","
										+ singing;
							}
						}
						if (!running.equals("")) {
							if (hobbies_selected.equals("")
									|| hobbies_selected.equals(null)) {
								hobbies_selected = running;
							} else {
								hobbies_selected = hobbies_selected + ","
										+ running;
							}
						}
						if (!table.equals("")) {
							if (hobbies_selected.equals("")
									|| hobbies_selected.equals(null)) {
								hobbies_selected = table;
							} else {
								hobbies_selected = hobbies_selected + ","
										+ table;
							}
						}
						if (!writing.equals("")) {
							if (hobbies_selected.equals("")
									|| hobbies_selected.equals(null)) {
								hobbies_selected = writing;
							} else {
								hobbies_selected = hobbies_selected + ","
										+ writing;
							}
						}
						if (!reading.equals("")) {
							if (hobbies_selected.equals("")
									|| hobbies_selected.equals(null)) {
								hobbies_selected = reading;
							} else {
								hobbies_selected = hobbies_selected + ","
										+ reading;
							}
						}
						System.out.println(hobbies_selected);
						hobbies.setText(hobbies_selected.toUpperCase());
						cooking = "";
						dance = "";
						drama = "";
						drawing = "";
						lego = "";
						buildingMagicModel = "";
						painting = "";
						puzzles = "";
						scrapbooking = "";
						sewing = "";
						singing = "";
						videogaming = "";
						woodworking = "";
						writing = "";
						skating = "";
						otherhobbies = "";
						skiingSurfing = "";
						snowboarding = "";
						swimmingWater = "";
						football = "";
						baseball = "";
						basketball = "";
						climbing = "";
						cricket = "";
						cycling = "";
						judo = "";
						running = "";
						table = "";
						lawnTennis = "";
						reading = "";

						hobbies_selected = null;
						popup.dismiss();
					}

				});

			}
		});
		LinearLayout layout = (LinearLayout) view
				.findViewById(R.id.child_layout);// get your root layout

		layout.setOnTouchListener(new OnTouchListener() {

			@Override
			public boolean onTouch(View v, MotionEvent touchevent) {
				Log.v(null, "TOUCH EVENT"); // handle your fragment number here
				switch (touchevent.getAction()) {
				// when user first touches the screen we get x and y coordinate
				case MotionEvent.ACTION_DOWN: {
					System.out.println("fffffffffffffffffffffffff");
					x1 = touchevent.getX();
					y1 = touchevent.getY();
					break;
				}
				case MotionEvent.ACTION_UP: {
					System.out.println("fffffffffffffffffffffffff");
					x2 = touchevent.getX();
					y2 = touchevent.getY();

					if (x1 > x2) {
						System.out.println("right to left swipe");
						home.clickeventimplementfragment();
					}

					break;
				}
				}
				return true;
			}
		});

		return view;
	}

	

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		
		super.onActivityResult(resultCode, resultCode, data);
		System.out.println("request code"+requestCode);
		System.out.println("result code"+resultCode);
		System.out.println("data"+data);
		if (requestCode == RESULT_LOAD_IMAGE && resultCode == -1
				&& !(data == null)) {

			InputStream is = null;
			try {
				is = getActivity().getContentResolver().openInputStream(
						data.getData());
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			/*
			 * BitmapFactory.Options bounds = new BitmapFactory.Options();
			 * bounds.inSampleSize = 4;
			 */
			imageData = BitmapFactory.decodeStream(is, null, null);
			imageData = Bitmap.createScaledBitmap(imageData, 100, 100, true);
			try {
				is.close();

				img_child.setImageBitmap(imageData);
				setsizeofimage();

			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} 
	}

	public void setsizeofimage() {
		img_child.requestLayout();
		int density = getResources().getDisplayMetrics().densityDpi;
		switch (density) {
		case DisplayMetrics.DENSITY_LOW:
			img_child.getLayoutParams().height = 100;
			img_child.getLayoutParams().width = 100;
			break;
		case DisplayMetrics.DENSITY_MEDIUM:
			img_child.getLayoutParams().height = 180;
			img_child.getLayoutParams().width = 180;
			break;
		case DisplayMetrics.DENSITY_HIGH:
			img_child.getLayoutParams().height = 180;
			img_child.getLayoutParams().width = 180;
			break;
		case DisplayMetrics.DENSITY_XHIGH:
			img_child.getLayoutParams().height = 250;
			img_child.getLayoutParams().width = 250;
			break;
		case DisplayMetrics.DENSITY_XXHIGH:
			img_child.getLayoutParams().height = 250;
			img_child.getLayoutParams().width = 250;
			break;
		}
	}

	public Dialog onCreateDialog(int id) {

		// set date picker as current date
		return new DatePickerDialog(getActivity(), mDateSetListener, myYear,
				myMonth, myDay) {

			public void onDateChanged(DatePicker view, int year,
					int monthOfYear, int dayOfMonth) {
				System.out.println("on date change listener");
			}

		};

	}

	TimePickerDialog.OnTimeSetListener mTimesetlistenermon = new TimePickerDialog.OnTimeSetListener() {

		@Override
		public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
			// TODO Auto-generated method stub

			timechk1 = true;
			timechk2 = false;
			timechk3 = false;
			timechk4 = false;
			timechk5 = false;
			timechk6 = false;
			timechk7 = false;
			String hour_s = String.valueOf(hourOfDay);
			int length = hour_s.length();
			if (length == 1) {
				hour_s = "0" + String.valueOf(hourOfDay);
			}
			String minut_s = String.valueOf(minute);
			int length1 = minut_s.length();
			if (length1 == 1) {
				minut_s = "0" + String.valueOf(minute);
			}

			time = hour_s + ":" + minut_s;
			if (dayselect == 1) {
				days = "Monday" + " " + time + "-";
				daysadd = "";
			} else {
				daymon = "Monday" + " " + time + "-";
				// daysadd=days+daysadd+"Monday"+time+ "-";
				days = "";
			}

		}
	};

	TimePickerDialog.OnTimeSetListener mTimesetlistenertue = new TimePickerDialog.OnTimeSetListener() {

		@Override
		public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
			// TODO Auto-generated method stub

			timechk2 = true;
			timechk1 = false;
			timechk3 = false;
			timechk4 = false;
			timechk5 = false;
			timechk6 = false;
			timechk7 = false;
			String hour_s = String.valueOf(hourOfDay);
			int length = hour_s.length();
			if (length == 1) {
				hour_s = "0" + String.valueOf(hourOfDay);
			}
			String minut_s = String.valueOf(minute);
			int length1 = minut_s.length();
			if (length1 == 1) {
				minut_s = "0" + String.valueOf(minute);
			}

			time = hour_s + ":" + minut_s;

			if (dayselect == 2) {
				days = "Tuesday" + " " + time + "-";
				daysadd = "";
			} else {
				daytue = "Tuesday" + " " + time + "-";
				// daysadd=days+daysadd+"Tuesday"+time+ "-";
				days = "";
			}

		}
	};
	TimePickerDialog.OnTimeSetListener mTimesetlistenerwed = new TimePickerDialog.OnTimeSetListener() {

		@Override
		public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
			// TODO Auto-generated method stub
			timechk3 = true;
			timechk2 = false;
			timechk1 = false;
			timechk4 = false;
			timechk5 = false;
			timechk6 = false;
			timechk7 = false;
			String hour_s = String.valueOf(hourOfDay);
			int length = hour_s.length();
			if (length == 1) {
				hour_s = "0" + String.valueOf(hourOfDay);
			}
			String minut_s = String.valueOf(minute);
			int length1 = minut_s.length();
			if (length1 == 1) {
				minut_s = "0" + String.valueOf(minute);
			}

			time = hour_s + ":" + minut_s;

			if (dayselect == 3) {
				days = "Wednesday" + " " + time + "-";
				daysadd = "";
			} else {
				daywed = "Wednesday" + " " + time + "-";
				// daysadd=days+daysadd+"Wednesday"+time+ "-";
				days = "";
			}

		}
	};
	TimePickerDialog.OnTimeSetListener mTimesetlistenerthu = new TimePickerDialog.OnTimeSetListener() {

		@Override
		public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
			// TODO Auto-generated method stub
			timechk4 = true;
			timechk2 = false;
			timechk3 = false;
			timechk1 = false;
			timechk5 = false;
			timechk6 = false;
			timechk7 = false;
			String hour_s = String.valueOf(hourOfDay);
			int length = hour_s.length();
			if (length == 1) {
				hour_s = "0" + String.valueOf(hourOfDay);
			}
			String minut_s = String.valueOf(minute);
			int length1 = minut_s.length();
			if (length1 == 1) {
				minut_s = "0" + String.valueOf(minute);
			}

			time = hour_s + ":" + minut_s;

			if (dayselect == 4) {
				days = "Thursday" + " " + time + "-";
				daysadd = "";
			} else {
				daythu = "Thursday" + " " + time + "-";
				// daysadd=days+daysadd+"Thursday"+time+ "-";
				days = "";
			}

		}
	};
	TimePickerDialog.OnTimeSetListener mTimesetlistenerfri = new TimePickerDialog.OnTimeSetListener() {

		@Override
		public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
			// TODO Auto-generated method stub

			timechk5 = true;
			timechk2 = false;
			timechk3 = false;
			timechk4 = false;
			timechk1 = false;
			timechk6 = false;
			timechk7 = false;
			String hour_s = String.valueOf(hourOfDay);
			int length = hour_s.length();
			if (length == 1) {
				hour_s = "0" + String.valueOf(hourOfDay);
			}
			String minut_s = String.valueOf(minute);
			int length1 = minut_s.length();
			if (length1 == 1) {
				minut_s = "0" + String.valueOf(minute);
			}

			time = hour_s + ":" + minut_s;

			if (dayselect == 5) {
				days = "Friday" + " " + time + "-";
				daysadd = "";
			} else {
				dayfri = "Friday" + " " + time + "-";
				// daysadd=days+daysadd+"Friday"+time+ "-";
				days = "";
			}

		}
	};
	TimePickerDialog.OnTimeSetListener mTimesetlistenersat = new TimePickerDialog.OnTimeSetListener() {

		@Override
		public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
			// TODO Auto-generated method stub

			int hours = hourOfDay;
			int minutes = minute;

			timechk6 = true;
			timechk2 = false;
			timechk3 = false;
			timechk4 = false;
			timechk5 = false;
			timechk1 = false;
			timechk7 = false;
			String hour_s = String.valueOf(hourOfDay);
			int length = hour_s.length();
			if (length == 1) {
				hour_s = "0" + String.valueOf(hourOfDay);
			}
			String minut_s = String.valueOf(minute);
			int length1 = minut_s.length();
			if (length1 == 1) {
				minut_s = "0" + String.valueOf(minute);
			}

			time = hour_s + ":" + minut_s;
			if (dayselect == 6) {
				days = "Saturday" + " " + time + "-";
				daysadd = "";
			} else {
				daysat = "Saturday" + " " + time + "-";
				// daysadd=days+daysadd+"Saturday"+time+ "-";
				days = "";
			}

		}
	};
	TimePickerDialog.OnTimeSetListener mTimesetlistenersun = new TimePickerDialog.OnTimeSetListener() {

		@Override
		public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
			// TODO Auto-generated method stub

			System.out.println("to .....sunnnnnnn");
			timechk7 = true;
			timechk2 = false;
			timechk3 = false;
			timechk4 = false;
			timechk5 = false;
			timechk6 = false;
			timechk1 = false;
			String hour_s = String.valueOf(hourOfDay);
			int length = hour_s.length();
			if (length == 1) {
				hour_s = "0" + String.valueOf(hourOfDay);
			}
			String minut_s = String.valueOf(minute);
			int length1 = minut_s.length();
			if (length1 == 1) {
				minut_s = "0" + String.valueOf(minute);
			}

			time = hour_s + ":" + minut_s;

			if (dayselect == 7) {
				days = "Sunday" + " " + time + "-";
				daysadd = "";
			}

			else {
				daysun = "Sunday" + " " + time + "-";
				// daysadd=days+daysadd+"Saturday"+time+ "-";
				days = "";
			}

		}
	};
	TimePickerDialog.OnTimeSetListener mTimesetlistenermonto = new TimePickerDialog.OnTimeSetListener() {

		@Override
		public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
			// TODO Auto-generated method stub
			if (clicked == true) {
				clicked = false;
				String hour_s = String.valueOf(hourOfDay);
				int length = hour_s.length();
				if (length == 1) {
					hour_s = "0" + String.valueOf(hourOfDay);
				}
				String minut_s = String.valueOf(minute);
				int length1 = minut_s.length();
				if (length1 == 1) {
					minut_s = "0" + String.valueOf(minute);
				}

				time = hour_s + ":" + minut_s;

				if (dayselect == 1) {

					if (timechk1 == true) {
						days = days + time + " ";

						freetime.setText(days.toUpperCase());
					} else {
						alert();
					}

				} else {
					if (timechk1 == true) {
						daysadd = daysadd + daymon + time + "  ";
						time = "";
						freetime.setText(daysadd.toUpperCase());
						daymon = "";
					} else {
						alert();
					}
					dayselect = 0;
				}
			}
		}
	};

	TimePickerDialog.OnTimeSetListener mTimesetlistenertueto = new TimePickerDialog.OnTimeSetListener() {

		@Override
		public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
			// TODO Auto-generated method stub
			if (clicked == true) {
				clicked = false;
				String hour_s = String.valueOf(hourOfDay);
				int length = hour_s.length();
				if (length == 1) {
					hour_s = "0" + String.valueOf(hourOfDay);
				}
				String minut_s = String.valueOf(minute);
				int length1 = minut_s.length();
				if (length1 == 1) {
					minut_s = "0" + String.valueOf(minute);
				}

				time = hour_s + ":" + minut_s;
				if (dayselect == 2) {
					if (timechk2 == true) {
						days = days + time + " ";
						freetime.setText(days.toUpperCase());
					} else {
						alert();
					}
				} else {
					if (timechk2 == true) {
						daysadd = daysadd + daytue + time + "  ";
						time = "";
						freetime.setText(daysadd.toUpperCase());
						daytue = "";
					} else {
						alert();
					}
					dayselect = 0;
				}
			}
		}
	};
	TimePickerDialog.OnTimeSetListener mTimesetlistenerwedto = new TimePickerDialog.OnTimeSetListener() {

		@Override
		public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
			// TODO Auto-generated method stub
			if (clicked == true) {
				clicked = false;
				String hour_s = String.valueOf(hourOfDay);
				int length = hour_s.length();
				if (length == 1) {
					hour_s = "0" + String.valueOf(hourOfDay);
				}
				String minut_s = String.valueOf(minute);
				int length1 = minut_s.length();
				if (length1 == 1) {
					minut_s = "0" + String.valueOf(minute);
				}

				time = hour_s + ":" + minut_s;
				if (dayselect == 3) {
					if (timechk3 == true) {
						days = days + time + " ";
						freetime.setText(days.toUpperCase());
					} else {
						alert();
					}
				} else {
					if (timechk3 == true) {
						daysadd = daysadd + daywed + time + "  ";
						freetime.setText(daysadd.toUpperCase());
						daywed = "";
					} else {
						alert();
					}
					dayselect = 0;
				}
			}
		}
	};
	TimePickerDialog.OnTimeSetListener mTimesetlistenerthuto = new TimePickerDialog.OnTimeSetListener() {

		@Override
		public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
			// TODO Auto-generated method stub
			if (clicked == true) {
				clicked = false;
				String hour_s = String.valueOf(hourOfDay);
				int length = hour_s.length();
				if (length == 1) {
					hour_s = "0" + String.valueOf(hourOfDay);
				}
				String minut_s = String.valueOf(minute);
				int length1 = minut_s.length();
				if (length1 == 1) {
					minut_s = "0" + String.valueOf(minute);
				}

				time = hour_s + ":" + minut_s;
				if (dayselect == 4) {
					if (timechk4 == true) {
						days = days + time + " ";
						freetime.setText(days.toUpperCase());
					} else {
						alert();
					}
				} else {
					if (timechk4 == true) {
						daysadd = daysadd + daythu + time + "  ";
						freetime.setText(daysadd.toUpperCase());
						daythu = "";
					} else {
						alert();
					}
					dayselect = 0;
				}
			}

		}
	};
	TimePickerDialog.OnTimeSetListener mTimesetlistenerfrito = new TimePickerDialog.OnTimeSetListener() {

		@Override
		public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
			// TODO Auto-generated method stub
			if (clicked == true) {
				clicked = false;
				String hour_s = String.valueOf(hourOfDay);
				int length = hour_s.length();
				if (length == 1) {
					hour_s = "0" + String.valueOf(hourOfDay);
				}
				String minut_s = String.valueOf(minute);
				int length1 = minut_s.length();
				if (length1 == 1) {
					minut_s = "0" + String.valueOf(minute);
				}

				time = hour_s + ":" + minut_s;
				if (dayselect == 5) {
					if (timechk5 == true) {
						days = days + time + " ";
						freetime.setText(days.toUpperCase());
					} else {
						alert();
					}
				} else {
					if (timechk5 == true) {
						daysadd = daysadd + dayfri + time + "  ";
						freetime.setText(daysadd.toUpperCase());
						dayfri = "";
					} else {
						alert();
					}
					dayselect = 0;
				}
			}
		}
	};
	TimePickerDialog.OnTimeSetListener mTimesetlistenersatto = new TimePickerDialog.OnTimeSetListener() {

		@Override
		public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
			// TODO Auto-generated method stub
			if (clicked == true) {
				clicked = false;
				String hour_s = String.valueOf(hourOfDay);
				int length = hour_s.length();
				if (length == 1) {
					hour_s = "0" + String.valueOf(hourOfDay);
				}
				String minut_s = String.valueOf(minute);
				int length1 = minut_s.length();
				if (length1 == 1) {
					minut_s = "0" + String.valueOf(minute);
				}

				time = hour_s + ":" + minut_s;
				if (dayselect == 6) {
					if (timechk6 == true) {
						days = days + time + " ";
						freetime.setText(days.toUpperCase());
					} else {
						alert();
					}
				} else {
					if (timechk6 == true) {
						daysadd = daysadd + daysat + time + "  ";
						time = "";
						freetime.setText(daysadd.toUpperCase());
						daysat = "";
					} else {
						alert();
					}
					dayselect = 0;
				}

			}

		}
	};
	TimePickerDialog.OnTimeSetListener mTimesetlistenersunto = new TimePickerDialog.OnTimeSetListener() {

		@Override
		public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
			// TODO Auto-generated method stub
			if (clicked == true) {
				clicked = false;
				String hour_s = String.valueOf(hourOfDay);
				int length = hour_s.length();
				if (length == 1) {
					hour_s = "0" + String.valueOf(hourOfDay);
				}
				String minut_s = String.valueOf(minute);
				int length1 = minut_s.length();
				if (length1 == 1) {
					minut_s = "0" + String.valueOf(minute);
				}

				time = hour_s + ":" + minut_s;
				if (dayselect == 7) {
					if (timechk7 == true) {
						days = days + time;
						freetime.setText(days.toUpperCase());
					} else {
						alert();
					}
				} else {
					if (timechk7 == true) {
						daysadd = daysadd + daysun + time + " ";
						freetime.setText(daysadd.toUpperCase());
						daysun = "";
					} else {
						alert();
					}
					dayselect = 0;
				}
			}

		}
	};

	public void alert() {
		AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());

		builder.setTitle("Invalid entry");
		builder.setMessage("Please select from time ").setCancelable(false)
				.setPositiveButton("OK", new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int id) {
						// edit_email.setText("");

						dialog.cancel();

					}

				});

		AlertDialog alert = builder.create();
		alert.show();
	}

	DatePickerDialog.OnDateSetListener mDateSetListener = new DatePickerDialog.OnDateSetListener() {

		public void onDateSet(DatePicker view, int year, int monthOfYear,
				int dayOfMonth) {
			myYear = year;
			myMonth = monthOfYear;
			myDay = dayOfMonth;
			monthOfYear = monthOfYear + 1;
			String day = String.valueOf(dayOfMonth);
			String month = String.valueOf(monthOfYear);
			String year1 = String.valueOf(year);
			int i = day.length();
			if (i == 1) {
				day = "0" + day;

			}
			int i1 = month.length();
			if (i1 == 1) {
				month = "0" + month;

			}
			int i2 = year1.length();
			if (i2 == 1) {
				year1 = "0" + year1;

			}

			String date = day + "-" + month + "-" + year1;
			try{

			      SimpleDateFormat formatter = new SimpleDateFormat("dd-MM-yyyy");
			       Date date1 = formatter.parse(date_comparision);
			       Date date2 = formatter.parse(date);
			    if (date1.compareTo(date2)<0)
			    {
			    	if(count_alert==0){
			    		count_alert=count_alert+1;
			    	new AlertDialog.Builder(getActivity())
					
				    .setTitle("Invalid Entry")
				    .setMessage("can't select future date")
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
			    	dateofbirth.setText(date);
			    }
			 } catch (ParseException e1) 
		      {
		    // TODO Auto-generated catch block
		    e1.printStackTrace();
		                        }
			
			
		}
	};

	public class chilprofilecreate_webservice extends
			AsyncTask<String, Integer, String> {
		ProgressDialog dialog = new ProgressDialog(getActivity());

		@Override
		protected void onPreExecute() {
			// Toast.makeText(Login.this,"asynch task",Toast.LENGTH_LONG).show();
			dialog.setMessage("Loading.......please wait");
			dialog.setCancelable(false);
			dialog.show();
			url = "http://54.191.67.152/playdate/child.php";// ?profile_pic=pic&name=deepak&dob=1989/1/12&set_fixed_freetime=1989/2/4&school=DPS&conditions=TRUE&allergies=test&hobbies=demo&siblings=mother&youth_club=abc&g_id=10"
		}// [10:30:39 AM] Rattandeep Kaur: [Friday, May 23, 2014 5:47 PM]
			// Rattandeep Kaur:

		// <<<
		// http://112.196.34.179/playdate/child.php?profile_image=pic&name=rattan&dob=1989/1/12&set_fixed_freetime=1989/2/4&school=DPS&conditions=TRUE&allergies=test&hobbies=demo&siblings=mother&youth_club=abc&g_id=10

		@Override
		protected String doInBackground(String... arg0) {
			// TODO Auto-generated method stub
			HttpClient httpClient = new DefaultHttpClient();
			HttpContext localContext = new BasicHttpContext();
			HttpPost httpPost = new HttpPost(url);

			String image_str = null;

			try {
				ByteArrayOutputStream stream = new ByteArrayOutputStream();
				imageData.compress(Bitmap.CompressFormat.JPEG, 90, stream); // compress
																			// to
																			// which
																			// format
																			// you
																			// want.
				byte[] byte_arr = stream.toByteArray();
				image_str = com.iapptechnologies.time.Base64
						.encodeBytes(byte_arr);
				System.out.println("image compressed");
			} catch (Exception e) {
				// TODO: handle exception
			}
			// Bitmap bitmap =
			// BitmapFactory.decodeResource(getResources(),R.drawable.ic_launcher);

			// profile_image=pic&name=deepak&dob=1989/1/12&set_fixed_freetime=1989/2/4&school=DPS&conditions=TRUE&allergies=test&hobbies=demo&youth_club=abc&g_id=10

			ArrayList<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();
			nameValuePairs.add(new BasicNameValuePair("profile_image",
					image_str));
			nameValuePairs.add(new BasicNameValuePair("name", name));
			nameValuePairs.add(new BasicNameValuePair("dob",
					date_od_birth_parent));
			nameValuePairs.add(new BasicNameValuePair("set_fixed_freetime",
					free_time));
			nameValuePairs.add(new BasicNameValuePair("school", scHool));
			nameValuePairs.add(new BasicNameValuePair("conditions", ""));
			nameValuePairs.add(new BasicNameValuePair("allergies", aLLergies));
			nameValuePairs.add(new BasicNameValuePair("hobbies", hoBBies));

			nameValuePairs.add(new BasicNameValuePair("youth_club", youthClub));
			nameValuePairs
					.add(new BasicNameValuePair("g_id", user_guardian_id));
			Log.d("nameValuePairs", "nameValuePairs" + nameValuePairs);
			Log.d("nameValuePairs", "nameValuePairs" + nameValuePairs);
			Log.d("nameValuePairs", "nameValuePairs" + nameValuePairs);

			StringBuilder sbb = new StringBuilder();

			sbb.append("http://54.191.67.152/playdate/child.php?");
			sbb.append(nameValuePairs.get(0) + "&");
			sbb.append(nameValuePairs.get(1) + "&");
			sbb.append(nameValuePairs.get(2) + "&");
			sbb.append(nameValuePairs.get(3) + "&");
			sbb.append(nameValuePairs.get(4) + "&");
			sbb.append(nameValuePairs.get(5) + "&");
			sbb.append(nameValuePairs.get(6) + "&");
			sbb.append(nameValuePairs.get(7) + "&");
			sbb.append(nameValuePairs.get(8) + "&");

			sbb.append(nameValuePairs.get(9));

			System.out.println("string builder...\n");

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

			try {
				String sResponse = reader.readLine();

				System.out.println("response" + sResponse);
				JSONObject json;
				try {
					json = new JSONObject(sResponse);
					data = json.getString("success");
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			return null;
		}

		protected void onPostExecute(String resultt) {

			dialog.dismiss();

			if (data.equals("1")) {
				Toast.makeText(getActivity(), "Updation Successful", 2000)
						.show();

				childname.setText("");
				dateofbirth.setText("");
				freetime.setText("");
				//conditions.setText("");
				allergies.setText("");
				hobbies.setText("");
				school.setText("");
				youthclub.setText("");

				img_child.setImageResource(R.drawable.placeholder_large);

			}

		}
	}

}