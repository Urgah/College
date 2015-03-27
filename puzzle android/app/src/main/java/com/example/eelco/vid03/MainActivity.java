package com.example.eelco.vid03;

import android.content.DialogInterface;
import android.content.Intent;
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

                    ImageView image = new ImageView(this);
                    image.setImageResource(resourceId);
                    image.setId(resourceId);

                    Button button = new Button(this);
                    button.setText(name);
                    button.setOnClickListener(new View.OnClickListener() {
                        public void onClick(View arg0) {
                            ImageActivity.resetArrayList();
                            Intent intent = new Intent(MainActivity.this, ImageActivity.class);
                            intent.putExtra("difficulty", difficulty);
                            intent.putExtra("resourceid", resourceId);
                            startActivity(intent);
                        }
                    });

                    LinearLayout newLayout = new LinearLayout(this);
                    newLayout.addView(image, 200, 200);
                    newLayout.addView(button, 200, 100);

                    LinearLayout layout = (LinearLayout) findViewById(R.id.imagesClick);
                    layout.addView(newLayout, 400, 250);
                }
            } catch (Exception e) {
                Log.e("MAD","### OOPS", e);
            }
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

    private int difficulty = 4;
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

        Log.d("MAD", "difficulty set: " + difficulty);
    }
}
