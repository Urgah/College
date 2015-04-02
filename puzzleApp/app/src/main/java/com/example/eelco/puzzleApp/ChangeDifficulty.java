package com.example.eelco.puzzleApp;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.RadioButton;

/**
 * Created by Eelco on 30/03/15.
 */
public class ChangeDifficulty extends ActionBarActivity {
    public int difficulty;
    public int resourceId;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.change_difficulty);

        Intent intent = getIntent();
        difficulty = intent.getIntExtra("difficulty", 0);
        resourceId = intent.getIntExtra("resourceid", 0);

        SharedPreferences preferences = getSharedPreferences("settings", 0);
        int pref_difficulty = preferences.getInt("difficulty", 4);
        difficulty = pref_difficulty;

        RadioButton radioButton;
        switch (difficulty) {
            case 3:
                radioButton = (RadioButton) findViewById(R.id.easy);
                radioButton.setChecked(true);
                break;
            case 4:
                radioButton = (RadioButton) findViewById(R.id.medium);
                radioButton.setChecked(true);
                break;
            case 5:
                radioButton = (RadioButton) findViewById(R.id.hard);
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

    public void changeDifficulty(View view) {
        ImageActivity.resetArrayList();

        SharedPreferences preferences = getSharedPreferences("settings", 0);
        SharedPreferences.Editor editor = preferences.edit();
        editor.putInt("difficulty", difficulty);
        editor.commit();

        Intent intent = new Intent(ChangeDifficulty.this, ImageActivity.class);
        intent.putExtra("difficulty", difficulty);
        intent.putExtra("resourceid", resourceId);
        startActivity(intent);
    }

    public void onRadioButtonClicked(View view) {
        difficulty = Integer.parseInt(view.getTag().toString());
        Log.d("MAD", String.valueOf(difficulty));
    }
}
