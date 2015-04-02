package com.example.eelco.puzzleApp;

import android.app.ActionBar;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.RadioButton;
import android.widget.LinearLayout;
import android.widget.TextView;

import java.lang.reflect.Field;

public class MainActivity extends ActionBarActivity {
    private int difficulty;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Field[] imageResources = R.drawable.class.getFields();
        for (Field f : imageResources) {
            try {
                String name = f.getName();
                if(!name.contains("abc")) {
                    final int resourceId = f.getInt(null);
                    Log.d("MAD", "### afbeelding resource naam: " + name + ", id:" + resourceId);

                    final ImageView image = new ImageView(this);
                    image.setImageResource(resourceId);
                    image.setId(resourceId);
                    View.OnClickListener clickListener = new View.OnClickListener() {
                        public void onClick(View v) {
                            if (v.equals(image)) {
                                ImageActivity.resetArrayList();
                                Intent intent = new Intent(MainActivity.this, ImageActivity.class);
                                intent.putExtra("difficulty", difficulty);
                                intent.putExtra("resourceid", resourceId);
                                startActivity(intent);
                            }
                        }
                    };
                    image.setOnClickListener(clickListener);

                    LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
                    lp.setMargins(0, 0, 0, 20);
                    image.setLayoutParams(lp);

                    LinearLayout layout = (LinearLayout) findViewById(R.id.imagesClick);
                    layout.addView(image);
                }
            } catch (Exception e) {
                Log.e("MAD","### OOPS", e);
            }
        }

        SharedPreferences preferences = getSharedPreferences("settings", 0);
        int pref_difficulty = preferences.getInt("difficulty", 4);
        difficulty = pref_difficulty;

        RadioButton radioButton;
        switch (difficulty) {
            case 3:
                radioButton = (RadioButton) findViewById(R.id.easyMode);
                radioButton.setChecked(true);
                break;
            case 4:
                radioButton = (RadioButton) findViewById(R.id.mediumMode);
                radioButton.setChecked(true);
                break;
            case 5:
                radioButton = (RadioButton) findViewById(R.id.hardMode);
                radioButton.setChecked(true);
                break;
            default: break;
        }
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
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

    public void onRadioButtonClicked(View view) {
        // Is the button now checked?
        boolean checked = ((RadioButton) view).isChecked();
        // Check which radio button was clicked
        switch(view.getId()) {
            case R.id.easyMode:
                if (checked)
                    difficulty = 3;
                    break;
            case R.id.mediumMode:
                if (checked)
                    difficulty = 4;
                    break;
            case R.id.hardMode:
                if (checked)
                    difficulty = 5;
                    break;
        }

        storeDifficulty(difficulty);
        Log.d("MAD", "difficulty set: " + difficulty);
    }

    //Static because I want to use it form all classes
    public void storeDifficulty(int difficulty) {
        SharedPreferences preferences = getSharedPreferences("settings", 0);
        SharedPreferences.Editor editor = preferences.edit();
        editor.putInt("difficulty", difficulty);
        editor.commit();
    }
}
