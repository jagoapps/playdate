package com.iapptechnologies.time;

import java.io.File;

import android.content.Context;
import android.os.Environment;

public class FileCache {
    
    private File cacheDir;
     
    public FileCache(Context context){
        //Find the dir to save cached images
       /* if (android.os.Environment.getExternalStorageState().equals(android.os.Environment.MEDIA_MOUNTED))
            cacheDir=new File(android.os.Environment.getExternalStorageDirectory(),"PlayDate Cache");
        else
            cacheDir=context.getCacheDir();
        if(!cacheDir.exists())
            cacheDir.mkdirs();*/
        
       
        	 cacheDir = null;
                if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED)) {
                	cacheDir = new File(Environment.getExternalStorageDirectory(), "PlayDate_Cache");
                    if(!cacheDir.exists()) {
                    	cacheDir.mkdirs();
                    }
                }
                
              /*  if(!cacheDir.exists()) {
                	cacheDir = context.getFilesDir();
                }*/
                
        
     

        
        
    }
     
    public File getFile(String url){
        //I identify images by hashcode. Not a perfect solution, good for the demo.
        String filename=String.valueOf(url.hashCode());
        //Another possible solution (thanks to grantland)
        //String filename = URLEncoder.encode(url);
        File f = new File(cacheDir, filename);
        return f;
         
    }
     
    public void clear(){
        File[] files=cacheDir.listFiles();
        if(files==null)
            return;
        for(File f:files)
            f.delete();
    }
 
}