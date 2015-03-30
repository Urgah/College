package com.example.eelco.puzzleApp;

import android.content.Intent;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;


public class GameWonActivity extends ActionBarActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_gamewon);

        Intent intent = getIntent();
        int difficulty = intent.getIntExtra("difficulty", 4);
        int resourceId = intent.getIntExtra("resourceid", 0);
        int moves = intent.getIntExtra("moves", 0);

        String difficultyText;
        switch (difficulty) {
            case 3:
                difficultyText = "easy";
                break;
            case 4:
                difficultyText = "medium";
                break;
            case 5:
                difficultyText = "hard";
                break;
            default:
                difficultyText = "";
        }

        TextView gameWon = (TextView) findViewById(R.id.gameWon);
        gameWon.setText("Game won on " + difficultyText + " with " + String.valueOf(moves) + " moves!");

        ImageView image = (ImageView) findViewById(R.id.solvedImage);
        image.setImageResource(resourceId);
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_gamewon, menu);
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

    public void backToMainMenu(View view) {
        Intent intent = new Intent(GameWonActivity.this, MainActivity.class);
        startActivity(intent);
    }
}
