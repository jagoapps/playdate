package com.iapptechnologies.time;

import java.util.ArrayList;

import org.json.JSONArray;

import android.app.Application;

public class GlobalVariable extends Application {

	public static String allergiesSelected = "";
	public static String facebook_ID = "";
	public static String global_name = "";
	public static String url = "";
	public static String url_child = "";
	public static String guardian_Id = "";
	public static int pref = 0;
	public static ArrayList<Getcategory> global_list_child = null;
	public static int parent_picute_update = 0;
	public static String CustomMessageStr = "";
	public static JSONArray custom_Jsonarray;
	public static boolean show_unlink_button=false;
	public static boolean appers_unlink_button=false;
}
