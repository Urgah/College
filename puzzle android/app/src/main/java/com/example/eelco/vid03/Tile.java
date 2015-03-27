package com.example.eelco.vid03;

import android.graphics.Bitmap;

/**
 * Created by Eelco on 23/03/15.
 */
public class Tile {
    int Position;
    Bitmap Image;
    public Tile(int position, Bitmap chunkedImage) {
        this.Position = position;
        this.Image = chunkedImage;
    }
}
