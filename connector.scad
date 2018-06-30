
// diameter of the tube (mm)
tubeDiameter = 2.197*25.4*0.95; 

undersideLength = 40;

undersideWidth = 40;

flangeExtension = 70;

slotTriangleWidth = 40;

screwThreadDiameter = 5;

screwHeadDiameter = 13;

screwOffset = 5;

screwHeadInset = 5;

height = 10;

flangeHeight = 5;

singleLayer = 0.2;

difference() {
    union() {
        translate([-undersideWidth/2, -tubeDiameter/2 - height,0])
            cube([undersideWidth,tubeDiameter/2 + height, undersideLength]);
        hull() {
            rotate([-90,0,0]) 
            for (i = [-1,1],j=[-1,1]) 
                translate([i*(flangeExtension/2 - screwHeadDiameter/2), j*(flangeExtension/2-screwHeadDiameter/2)-undersideLength/2,-tubeDiameter/2-height])
                    cylinder(r=screwHeadDiameter/2,h=flangeHeight,$fn=90);
        }
    }
    rotate([-90,0,0]) 
    for (i = [-1,1],j=[-1,1]) 
        translate([i*(flangeExtension/2 - screwHeadDiameter/2), j*(flangeExtension/2-screwHeadDiameter/2)-undersideLength/2,-tubeDiameter/2-height])
            cylinder(r=screwThreadDiameter/2,h=flangeHeight+.1,$fn=90);
    color("green", alpha=0.25) cylinder(r=tubeDiameter/2, h=undersideLength, $fn=90);
    intersection() {
        translate([-slotTriangleWidth/2,-tubeDiameter/2-height,undersideLength/2])
            color("red")
            linear_extrude(height = screwHeadDiameter, center=true) 
            polygon( points=[[0,0],[slotTriangleWidth,0],[slotTriangleWidth/2,tubeDiameter/2+height]] );
        translate([0,0,undersideLength/2]) {
            difference() {
                cylinder(r=tubeDiameter/2+screwOffset, h=screwThreadDiameter, $fn=90, center=true);
                cylinder(r=tubeDiameter/2, h=screwThreadDiameter, $fn=90, center=true);
            }
            difference() {
                cylinder(r=1000, h=screwHeadDiameter, $fn=90, center=true);
                // tiny layer to allow easier printing
                cylinder(r=tubeDiameter/2+screwOffset+singleLayer, h=screwHeadDiameter, $fn=90, center=true);
            }
        }
    }
}