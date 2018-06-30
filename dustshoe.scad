use <zaxis2.scad>;

/*
difference() {
    hull() { ZAxis(spindleDiameter=65); };
    hull() { ZAxis(spindleDiameter=78); }
}
*/

cbeamWidth = 80;
cbeamDepth = 40;
overlap = 50;
height = 51;
wallThickness = 5;
diameter = 25.4 * 4;
tubeLen = 25.4*1;
angle = 60;
angleLarge = 30;
scaling = height/2*sin(angle);
scalingLarge = diameter/2*sin(angleLarge);
sideAirChannel = 25;
airChannelDepth = 100;
airChannelHeight = 25;
profileSize = 20;
screwThreadDiameter = 5.6;
screwHeadDiameter = 10;
screwHeadOffset = 15;
screwWallThickness = 5;

rearOffset = 50;

insideHoles = false;

union() {
    difference() {
        union() {
            difference() {
                union() {
                    translate([0,-diameter/2*cos(angleLarge)-rearOffset,scalingLarge]) rotate([angleLarge,0,0]) difference() {
                        cylinder(r=diameter/2,h=tubeLen,$fn=90);
                    }
                    hull() {
                        translate([-cbeamWidth/2-2*wallThickness+height/2,-scaling-rearOffset,scaling]) rotate([angle,0,0]) {
                            cylinder(r=height/2,h=0.01,$fn=90);
                        }
                        translate([cbeamWidth/2+2*wallThickness-height/2,-scaling-rearOffset,scaling]) rotate([angle,0,0]) {
                            cylinder(r=height/2,h=0.01,$fn=90);
                        }
                        translate([0,-diameter/2*cos(angleLarge)-rearOffset,scalingLarge]) rotate([angleLarge,0,0]) {
                            cylinder(r=diameter/2,h=0.01,$fn=90);
                        }
                        translate([0,-diameter/2*cos(angleLarge)-rearOffset+wallThickness,0]) {
                            cylinder(r=diameter/2,h=0.01,$fn=90);
                        }
                        translate([-cbeamWidth/2-sideAirChannel-wallThickness,-scaling,0]) {
                            cube([cbeamWidth+2*sideAirChannel+2*wallThickness,scaling+airChannelDepth+wallThickness,airChannelHeight+wallThickness]);
                        }
                        translate([-cbeamWidth/2-wallThickness,0,0]) hull() {
                            cube([cbeamWidth+2*wallThickness,cbeamDepth,height]);
                        }
                    }
                }
                union() {
                    translate([0,-diameter/2*cos(angleLarge)-rearOffset,scalingLarge]) rotate([angleLarge,0,0]) difference() {
                        cylinder(r=diameter/2-wallThickness,h=tubeLen,$fn=90);
                    }
                    hull() {
                        
                        translate([-cbeamWidth/2-2*wallThickness+height/2,-scaling,scaling]) rotate([angle,0,0]) {
                            cylinder(r=height/2-wallThickness,h=0.01,$fn=90);
                        }
                        translate([cbeamWidth/2+2*wallThickness-height/2,-scaling,scaling]) rotate([angle,0,0]) {
                            cylinder(r=height/2-wallThickness,h=0.01,$fn=90);
                        }
                        translate([0,-diameter/2*cos(angleLarge)-rearOffset,scalingLarge]) rotate([angleLarge,0,0]) {
                            cylinder(r=diameter/2-wallThickness,h=0.01,$fn=90);
                        }
                        translate([-cbeamWidth/2-sideAirChannel,-scaling,wallThickness]) {
                            cube([cbeamWidth+2*sideAirChannel,scaling+airChannelDepth,airChannelHeight-wallThickness]);
                        }
                    }
                }
            }
            translate([-cbeamWidth/2-wallThickness,0,0]) difference() {
                hull() {
                    cube([cbeamWidth+2*wallThickness,cbeamDepth,height]);
                    cube([cbeamWidth+2*wallThickness,airChannelDepth+wallThickness,airChannelHeight+wallThickness]);
                }
                for (i = [wallThickness:3*wallThickness:airChannelDepth]) {
                    translate([0,i,wallThickness]) {
                        cube([cbeamWidth+2*wallThickness,2*wallThickness, height]);
                    }
                }
            }
        }
        translate([-cbeamWidth/2,wallThickness,0]) {
            cube([cbeamWidth,airChannelDepth,height]);
        }
        for (i=[profileSize/2,3/2*profileSize], j=[0]) {
            translate([-cbeamWidth/2-screwWallThickness,screwWallThickness + i, height-screwWallThickness-screwThreadDiameter/2+j]) {
                rotate([0,90,0]) cylinder(r=screwThreadDiameter/2,h=screwWallThickness, $fn=90);
                rotate([0,-90,0]) cylinder(r=screwHeadDiameter/2,h=screwWallThickness+sideAirChannel, $fn=90);
            }
            translate([cbeamWidth/2+screwWallThickness,screwWallThickness + i, height-screwWallThickness-screwThreadDiameter/2+j]) {
                rotate([0,-90,0]) cylinder(r=screwThreadDiameter/2,h=screwWallThickness, $fn=90);
                rotate([0,90,0]) cylinder(r=screwHeadDiameter/2,h=screwWallThickness+sideAirChannel, $fn=90);
            }
        }
        if (insideHoles) {
            for (i=[-3/2*profileSize,-profileSize/2,3/2*profileSize,profileSize/2,], j=[0,-screwHeadOffset]) {
                translate([-i, 0,height-scaling-screwHeadDiameter/2+j]) {
                    rotate([-90,0,0]) cylinder(r=screwThreadDiameter/2,h=wallThickness, $fn=90);
                }
            }
        }
        for (x = [-cbeamWidth/2-sideAirChannel, cbeamWidth/2 + wallThickness]) translate([x,0,0]) difference() {
            for (i = [wallThickness:3*wallThickness:airChannelDepth]) {
                translate([0,i,0]) {
                    cube([sideAirChannel-wallThickness,2*wallThickness, wallThickness]);
                }
            }
        }
    }
    
    hull() {
        translate([-wallThickness/2,-diameter*cos(angleLarge)-rearOffset,0]) 
            cube([wallThickness,diameter*cos(angleLarge)+rearOffset,wallThickness]);
        translate([-wallThickness/2,-rearOffset,diameter*sin(angleLarge)-wallThickness]) 
            cube([wallThickness,rearOffset,wallThickness]);
        translate([-cbeamWidth/2-wallThickness,-wallThickness,0]) 
            cube([cbeamWidth+2*wallThickness,wallThickness,wallThickness]);
    }
}