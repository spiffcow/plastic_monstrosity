include<constants.scad>;
use<vslot.scad>;

innerDiameter = 5.7;
outerDiameter = 10;
lipDiameter = 8;
plateHoleSideOffset = 11;
spacerLen = 11.2;
lipOffset = 1;

cBeamWidth = 80;
cBeamDepth = 40;
vWheelHoleSeparation = 5.95;

plateWidth = cBeamWidth+40;



difference() {
    union() {
        hull() {
            translate([plateHoleSideOffset-plateWidth/2-outerDiameter/2, -outerDiameter/2, lipOffset]) cube([-plateHoleSideOffset*2+plateWidth+outerDiameter, outerDiameter, spacerLen-2*lipOffset]);
        }
        hull() {
            translate([plateHoleSideOffset-plateWidth/2, 0, 0]) cylinder(h=spacerLen,r=lipDiameter/2, $fn=90);
            translate([plateHoleSideOffset-plateWidth/2, 0, lipOffset]) cylinder(h=spacerLen-2*lipOffset,r=outerDiameter/2, $fn=90);
        }
        hull() {
            translate([plateWidth/2-plateHoleSideOffset, 0, 0]) cylinder(h=spacerLen,r=lipDiameter/2, $fn=90);
            translate([plateWidth/2-plateHoleSideOffset, 0, lipOffset]) cylinder(h=spacerLen-2*lipOffset,r=outerDiameter/2, $fn=90);
        }
    }
    translate([plateHoleSideOffset-plateWidth/2, 0, 0]) cylinder(h=spacerLen,r=innerDiameter/2, $fn=90);
    translate([plateWidth/2-plateHoleSideOffset, 0, 0]) cylinder(h=spacerLen,r=innerDiameter/2, $fn=90);
}