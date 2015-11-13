use <Spiff.scad>; //Made by stuartpb under the Creative Commons - Public Domain Dedication license. Source: http://www.thingiverse.com/thing:106256

//IMPORTANT: This file has to be unzipped and saved into the same folder as Spiff.scad and Spiffsans.scad to work correctly!


//Define lengths. All lengths is in mm.
sideLength = 80;
baseHeight = 18;
bezelHeight = 18;
rimLength = 18;
sideTextHeight = 4;

usbLength = 12;
usbWidth = 4;
usbDepth = 15;


module base(side, height, usbSize) {
    
    //create base with hole for USB
    
    difference() {
        cube([side, side, height]); //base
        translate([side/2, side/2, height]) {
            cube(usbSize, center = true); //usb socket
        }
    }
    
}


module bezel(baseHeight, p0, p1, p2, p3, p4, p5) {
    
    //function to create bezels surrounding the USB hole
    
    translate([0, 0, baseHeight]){
        polyhedron(
            points=[p0, p1, p2, p3, p4, p5],
            faces=[[0,2,1], [1,2,3], [0,4,2], [1,3,5], [2,5,3], [2,4,5]]
        );
    }
    
}



module bezels(side, height, baseHeight, usbLength, usbWidth) {
    
    //calls bezel() four times to create the four bezels (one for each side) surrounding the USB hole
    
    bezel(baseHeight, [0,0,0], [side,0,0], [0,0,height], [side,0,height], [side/2-usbLength/2, side/2-usbWidth/2, 0], [side/2+usbLength/2, side/2-usbWidth/2, 0]);
    
    bezel(baseHeight, [side,0,0], [side,side,0], [side,0,height], [side,side,height], [side/2+usbLength/2, side/2-usbWidth/2, 0], [side/2+usbLength/2, side/2+usbWidth/2, 0]);
    
    bezel(baseHeight, [side,side,0], [0,side,0], [side,side,height], [0,side,height], [side/2+usbLength/2, side/2+usbWidth/2, 0], [side/2-usbLength/2, side/2+usbWidth/2, 0]);
    
    bezel(baseHeight, [0,side,0], [0,0,0], [0,side,height], [0,0,height], [side/2-usbLength/2, side/2+usbWidth/2, 0], [side/2-usbLength/2, side/2-usbWidth/2, 0]);
    
}


module text(height, position, rotation, size, string) {
    
    //insert text. write functionality imported from spiff.scad
    
    translate(position)
    rotate(rotation){
        scale(size)
        linear_extrude(height)
        write(string);      
    }
    
}


module topText(textHeight, side, height, string, size, xOffset, yOffset) {
    
    //create the "UCL" text on the top of the stand
    
    text(textHeight, [side/2-xOffset, sideLength/4-yOffset, height], [0,0,0], size, "UCL");
    
    text(textHeight, [side/2+xOffset, sideLength*3/4+yOffset, height], [0,0,180], size, "UCL");
    
}


module slope(p0, p1, p2, p3, p4, p5) {
    
    //function to create a slope on the side of the stand 
    
    polyhedron(
        points=[p0, p1, p2, p3, p4, p5],
        faces=[[0,1,2], [1,3,2], [0,4,1], [1,4,5]]
    );
    
}


module corner(p0, p1, p2, p3) {
    
    //function to create the corners between slopes
    
    polyhedron(
        points=[p0, p1, p2, p3],
        faces=[[0,1,2], [0,3,1]]
    );
    
}


module rim(side, length) {
    
    //calls slope() and corners() four times to create the rim of the stand
    
    slope([0,-length,0], [side,-length,0], [0,0,0], [side,0,0], [0,0,length], [side,0,length]);
    
    slope([side+length,0,0], [side+length,side,0], [side,0,0], [side,side,0], [side,0,length], [side,side,length]);
    
    slope([side,side+length,0], [0,side+length,0], [side,side,0], [0,side,0], [side,side,length], [0,side,length]);
    
    slope([-length,side,0], [-length,0,0], [0,side,0], [0,0,0], [0,side,length], [0,0,length]);
    
    corner([-length,0,0], [0,-length,0], [0,0,0], [0,0,length]);
    
    corner([side,-length,0], [side+length,0,0], [side,0,0], [side,0,length]);
    
    corner([side+length,side,0], [side,side+length,0], [side,side,0], [side,side,length]);
    
    corner([0,side+length,0], [-length,side,0], [0,side,0], [0,side,length]);
    
}


module rimText(height, side, rimLength, string, size, sideOffset, heightOffset){
    
    //create the "Engduino" text in the rim
    
    text(height, [side/2-sideOffset, -rimLength/2-heightOffset, rimLength/2-heightOffset], [45,0,0], size, string);
    
    text(height, [side+rimLength/2+heightOffset, side/2-sideOffset, rimLength/2-heightOffset], [45,0,90], size, string);
    
    text(height, [side/2+sideOffset, side+rimLength/2+heightOffset, rimLength/2-heightOffset], [45,0,180], size, string);
    
    text(height, [-rimLength/2-heightOffset, side/2+sideOffset, rimLength/2-heightOffset], [45,0,270], size, string);
    
}


module stand(){
    
    //create the stand itself by calling previously defined modules and adding parameters
    
    base(sideLength, baseHeight, [usbLength,usbWidth,usbDepth*2]);

    bezels(sideLength, bezelHeight, baseHeight, usbLength, usbWidth);

    topText(bezelHeight, sideLength, baseHeight, "UCL", [2,2,1], 18, 10);

    rim(sideLength, rimLength);

    rimText(sideTextHeight, sideLength, rimLength, "Engduino", [1.2,1.2,1] , 32, 4.5);
    
}


stand();