innerDiameter = 5.7;
outerDiameter = 10;
lipDiameter = 8;
lipHeight = 1;

guardThickness = 2;
guardFlangeDiameter = 15;
nema23ScrewHoleSeparation = 47.14;

shortAxisInsideWidth = 41.7;
smallBearingWidth = 5;
shortAxisBearingSpacerHeight1 = 1.5;
shortAxisBearingSpacerHeight2 = shortAxisInsideWidth - 2 * smallBearingWidth - shortAxisBearingSpacerHeight1;

longAxisInsideWidth = 19.7;
longAxisBearingSpacerHeight = (longAxisInsideWidth - 2 * smallBearingWidth)/2;


module Spacer(height, lipHeight) {
    difference() {
        hull() {
            cylinder(h=height-lipHeight, r=outerDiameter/2, $fn=90);
            cylinder(h=height, r=lipDiameter/2, $fn=90);
        }
        cylinder(h=height, r=innerDiameter/2, $fn=90);
    }
}

module ShortAxisSpacers() {
    for(i=[outerDiameter/2+2, outerDiameter*3/2+4]) {
        translate([-outerDiameter/2-2,i,0]) Spacer(shortAxisBearingSpacerHeight1, lipHeight);
        translate([outerDiameter/2+2,i,0]) Spacer(shortAxisBearingSpacerHeight2-guardThickness, 0);
    }
    for(i=[-outerDiameter/2-2,outerDiameter/2+2],j=[-outerDiameter/2-2,-3*outerDiameter/2-4]) {
        translate([i,j,0]) Spacer(shortAxisInsideWidth,0);
    }
}

module GuardPlate() {
    holeOffset = [nema23ScrewHoleSeparation,0,0];
    Spacer(shortAxisBearingSpacerHeight1 + guardThickness, 1);
    translate(holeOffset)
        Spacer(shortAxisBearingSpacerHeight1 + guardThickness, 1);
    difference() {
        hull() {
            // add extra thickness to match the bottom of the lip of the spacer
            cylinder(h=guardThickness+(shortAxisBearingSpacerHeight1-lipHeight), r=guardFlangeDiameter/2, $fn=90);
            translate(holeOffset)
                cylinder(h=guardThickness+(shortAxisBearingSpacerHeight1-lipHeight), r=guardFlangeDiameter/2, $fn=90);
        }
        cylinder(h=shortAxisBearingSpacerHeight1+guardThickness, r=innerDiameter/2, $fn=90);
        translate(holeOffset)
            cylinder(h=shortAxisBearingSpacerHeight1+guardThickness, r=innerDiameter/2, $fn=90);
    }
}

/*
ShortAxisSpacers();

translate([2* outerDiameter + 2, -nema23ScrewHoleSeparation/2, 0])
    rotate([0,0,90]) GuardPlate();
*/
GuardPlate();