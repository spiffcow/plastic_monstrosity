wallWidth=4;
chainWidth = 80;
sideHeight = 20;
holeDiameter = 5;
length = 30;
bevel = 2;
count = 4;
spacing = 10;
lip = 5;

rotate([90,0,0]) 
for (itemNum = [0:count-1]) translate([itemNum*spacing, 0, itemNum*spacing]) {
    difference() {
        cube([chainWidth + wallWidth, length, sideHeight+wallWidth]);
        translate([wallWidth,0,wallWidth])
            cube([chainWidth, length, sideHeight ]);
        
        for (i=[wallWidth+holeDiameter/2,length-wallWidth-holeDiameter/2])
            translate([0,i,sideHeight/2+wallWidth])
            rotate([0,90,0]) 
            cylinder(r=holeDiameter/2,h=wallWidth,$fn=90);
    }

    hull() {
        translate([0,0,bevel]) cube([wallWidth, length, wallWidth ]);
        translate([bevel,0,0]) cube([wallWidth, length, wallWidth ]);
    }
    
    translate([chainWidth,0,-lip])
        cube([wallWidth, length, lip+wallWidth ]);
}