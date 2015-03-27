package com.example.eelco.vid03;

import android.app.ActionBar;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import java.lang.reflect.Array;
import java.util.ArrayList;


public class ImageActivity extends ActionBarActivity {
    private static ArrayList<Tile> chunckedImgList = new ArrayList<Tile>();
    public static int difficulty;

    public GridViewController gridViewController;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_image);

        gridViewController  = new GridViewController(this);

        Intent intent = getIntent();
        difficulty = intent.getIntExtra("difficulty", 4);
        gridViewController.difficuly = difficulty;
        int resourceId = intent.getIntExtra("resourceid", 0);

        GridView grid = (GridView) findViewById(R.id.gridview);
        grid.setAdapter(new ImageAdapter(this));
        grid.setNumColumns(difficulty);

        final GridView final_grid = grid;
        grid.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View v,
                                    int position, long id) {
                gridViewController.moveTile(position, final_grid);
            }
        });

        ImageView image = new ImageView(this);
        //Need this later with 3 sec timeout
        image.setImageResource(resourceId);

        splitImage(image, difficulty, difficulty);
    }

    public void onCreate() {
        Log.d("MAD", "Created");
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_image, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    public void splitImage(ImageView image, int rows, int cols) {

        //For height and width of the small image chunks
        int chunkHeight,chunkWidth;

        //Getting the scaled bitmap of the source image
        BitmapDrawable drawable = (BitmapDrawable) image.getDrawable();
        Bitmap bitmap = drawable.getBitmap();
        Bitmap scaledBitmap = Bitmap.createScaledBitmap(bitmap, bitmap.getWidth(), bitmap.getHeight(), true);

        chunkHeight = bitmap.getHeight()/rows;
        chunkWidth = bitmap.getWidth()/cols;
        int imageNumber = rows * cols;

        //The amount of images
        int i = rows * cols;
        gridViewController.emptyImage = i - 1;

        //xCoord and yCoord are the pixel positions of the image chunks
        int yCoord = 0;
        for(int x=0; x<rows; x++){
            int xCoord = 0;
            for(int y=0; y<cols; y++){
                Bitmap map = Bitmap.createBitmap(scaledBitmap, xCoord, yCoord, chunkWidth, chunkHeight);
                i--;

                chunckedImgList.add(new Tile(i, map));
                xCoord += chunkWidth;
            }
            yCoord += chunkHeight;
        }
    }

    public ArrayList<Tile> getImageList() {
        return chunckedImgList;
    }

    public static void resetArrayList() {
        chunckedImgList = new ArrayList<Tile>();
    }
}
