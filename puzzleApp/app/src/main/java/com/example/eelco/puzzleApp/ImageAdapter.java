package com.example.eelco.puzzleApp;

import android.content.Context;
import android.graphics.Point;
import android.util.Log;
import android.view.Display;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.AbsListView;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.ImageView;

import java.util.ArrayList;

/**
 * Created by Eelco on 24/03/15.
 */
public class ImageAdapter extends BaseAdapter {
    private Context mContext;

    public ImageAdapter(Context c) {
        mContext = c;
    }
    private ImageActivity imageActivity = new ImageActivity();

    public int getCount() {
        ArrayList<Tile> list = imageActivity.getImageList();
        return list.size();
    }

    public Object getItem(int position) {
        return null;
    }

    public long getItemId(int position) {
        return 0;
    }

    // create a new ImageView for each item referenced by the Adapter
    public View getView(int position, View convertView, ViewGroup parent) {
        ImageView imageView;

        WindowManager wm = (WindowManager) mContext.getSystemService(Context.WINDOW_SERVICE);
        Display display = wm.getDefaultDisplay();
        Point size = new Point();
        display.getSize(size);

        int difficulty = imageActivity.difficulty;
        int width = (size.x - ((difficulty-1) * 8)) / difficulty;

        if (convertView == null) {
            // if it's not recycled, initialize some attributes
            imageView = new ImageView(mContext);
            imageView.setLayoutParams(new GridView.LayoutParams(width, width));
            imageView.setScaleType(ImageView.ScaleType.CENTER_CROP);
            imageView.setPadding(8, 4, 8, 4);
        } else {
            imageView = (ImageView) convertView;
        }

        //Dont draw the last in the gridview
        if(position != (difficulty*difficulty-1)) {
            ArrayList<Tile> list = imageActivity.getImageList();
            imageView.setImageBitmap(list.get(position).Image);
        } else {
            imageView.setImageBitmap(null);
        }
        return imageView;
    }

}
