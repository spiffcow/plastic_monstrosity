innerDiameter = 5.6;
outerDiameter = 10;
lipDiameter = 8;

shortAxisInsideWidth = 41.7;
smallBearingWidth = 5;
shortAxisBeltExtraOffset = 20- 5;
shortAxisBearingSpacerHeight1 = (shortAxisInsideWidth - 2 * smallBearingWidth)/2+shortAxisBeltExtraOffset;
shortAxisBearingSpacerHeight2 = (shortAxisInsideWidth - 2 * smallBearingWidth)/2-shortAxisBeltExtraOffset;

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
        translate([-outerDiameter/2-2,i,0]) Spacer(shortAxisBearingSpacerHeight1, 1);
        translate([outerDiameter/2+2,i,0]) Spacer(shortAxisBearingSpacerHeight2, 1);
    }
    for(i=[-outerDiameter/2-2,outerDiameter/2+2],j=[-outerDiameter/2-2,-3*outerDiameter/2-4]) {
        translate([i,j,0]) Spacer(shortAxisInsideWidth,0);
    }
}

ShortAxisSpacers();