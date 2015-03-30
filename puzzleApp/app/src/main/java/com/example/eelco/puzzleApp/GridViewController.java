package com.example.eelco.puzzleApp;

import android.app.Dialog;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.PorterDuff;
import android.graphics.drawable.BitmapDrawable;
import android.util.AttributeSet;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

/**
 * Created by Eelco on 26/03/15.
 */
public class GridViewController {
    public int emptyImage;
    public int difficuly;
    public int moves = 0;

    public ImageActivity imageActivity;

    public GridViewController(ImageActivity imageActivityInstance) {
        super();

        imageActivity = imageActivityInstance;
    }

    //REMOVE UNUSED PARAMS
    public void moveTile(int position, GridView grid) {
        boolean canMove = checkPosition(position);
        if(canMove == false) {
            return;
        }

        Log.d("MAD", "Move img: " + String.valueOf(position));
        Log.d("MAD", "Empty img: " + String.valueOf(emptyImage));

        ImageView clickedImg = (ImageView) grid.getChildAt(position);
        ImageView imageToSet = (ImageView) grid.getChildAt(emptyImage);
        imageToSet.setImageBitmap(((BitmapDrawable)clickedImg.getDrawable()).getBitmap());

        emptyImage = position;
        clickedImg.setImageBitmap(null);
        moves++;
        imageActivity.updateMoves(moves);
        checkWin(grid);
    }

    private boolean checkPosition(int position) {
        List<Integer> moves = getPossibleMoves(position);

        for(int i = 0; i < moves.size(); i++) {
            if(moves.get(i) == emptyImage) {
                return true;
            }
        }

        return false;
    }

    private List<Integer> getPossibleMoves(int position) {
        List<Integer> list = new ArrayList<Integer>();
        list = addMove(list, position, 1);
        list = addMove(list, position, -1);
        list = addMove(list, position, difficuly);
        list = addMove(list, position, difficuly*-1);

        return list;
    }

    private List<Integer> addMove(List<Integer> list, int position, int calc) {
        int end_position = (difficuly * difficuly) - 1;

        //Are we on the left side?
        if(position % difficuly == 0 && calc == -1) {
            return list;
        }

        //Are we on the right side?
        if(position % difficuly == 3 && calc == 1) {
            return list;
        }

        if(position + calc >= 0 && position + calc <= end_position) {
            list.add(position + calc);
            return list;
        }

        return list;
    }

    private void checkWin(GridView grid) {
        ArrayList<Tile> positionList = imageActivity.getImageList();
        //cant check the last img since we didnt place it in the grid
        for(int i = 0; i < positionList.size() - 1; i++) {
            ImageView clickedImg = (ImageView) grid.getChildAt(i);
            final BitmapDrawable gridImg = (BitmapDrawable)clickedImg.getDrawable();

            if (positionList.get(i).Image != gridImg.getBitmap()) {
                return;
            }
        }

        Dialog dialog = new Dialog(imageActivity);
        dialog.setContentView(R.layout.game_won);
        TextView txt = (TextView)dialog.findViewById(R.id.moves);
        txt.setText("Moves: " + moves);
        //TODO: add button to go to main screen

        //TODO: prevent user from going back to game
        dialog.show();
    }
}
