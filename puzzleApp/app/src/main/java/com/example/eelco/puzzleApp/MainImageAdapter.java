package com.example.eelco.puzzleApp;

import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.ImageView;

/**
 * Created by Eelco on 01/04/15.
 */
public class MainImageAdapter extends BaseAdapter {
    private Context mContext;
    public MainImageAdapter(Context c) {
        mContext = c;
    }

    public Object getItem(int position) {
        return null;
    }

    public long getItemId(int position) {
        return 0;
    }

    public int getCount() {
        return 0;
    }

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        ImageView imageView;
        Log.d("we ogt here?", "xx");
        if (convertView == null) {
            // if it's not recycled, initialize some attributes
            imageView = new ImageView(mContext);
            imageView.setLayoutParams(new GridView.LayoutParams(200, 200));
            imageView.setScaleType(ImageView.ScaleType.CENTER_CROP);
            imageView.setPadding(8, 8, 8, 8);

            imageView.setOnClickListener(new View.OnClickListener() {

                @Override
                public void onClick(View view) {
                    Log.d("onClick", "position [" + String.valueOf(position) + "]");

//                ImageActivity.resetArrayList();
//                Intent intent = new Intent(, ImageActivity.class);
//                intent.putExtra("difficulty", difficulty);
//                intent.putExtra("resourceid", resourceId);
//                startActivity(intent);
                }

            });

        }
        else {
            imageView = (ImageView) convertView;
        }
        imageView.setImageResource(MainActivity.resourceIdList.get(position));
        return imageView;
    }
}
