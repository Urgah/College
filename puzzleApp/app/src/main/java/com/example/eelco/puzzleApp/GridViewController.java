package com.example.eelco.puzzleApp;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
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

    public void moveTile(int position, GridView grid, Boolean canWin) {
        boolean canMove = checkPosition(position);
        if(!canMove) {
            return;
        }

        ImageView clickedImg = (ImageView) grid.getChildAt(position);
        ImageView imageToSet = (ImageView) grid.getChildAt(emptyImage);
        imageToSet.setImageBitmap(((BitmapDrawable)clickedImg.getDrawable()).getBitmap());

        emptyImage = position;
        clickedImg.setImageBitmap(null);

        moves++;
        imageActivity.updateMoves(moves);

        if(canWin) {
            checkWin(grid);
        }
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

    public List<Integer> getPossibleMoves(int position) {
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
        if(position % difficuly == difficuly && calc == 1) {
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

        imageActivity.gameWon();
    }

    public void shuffle(GridView grid) {
        int prev_pos = emptyImage;
        int prev_move = 0;

        for(int i = 0; i < (difficuly*20); i++) {
            int position = validMove(prev_pos, prev_move);

            prev_move = prev_pos;
            prev_pos = position;
            moveTile(position, grid, false);
        }

        imageActivity.updateMoves(0);
        moves = 0;
    }

    private int validMove(int prev_pos, int prev_move) {
        List<Integer> possibleMoves = getPossibleMoves(prev_pos);
        Random randomGenerator = new Random();
        int position = possibleMoves.get(randomGenerator.nextInt(possibleMoves.size()));
        if (position == prev_move) {
            position = validMove(prev_pos, prev_move);
        }

        return position;
    }
}
