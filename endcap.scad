wallThickness = 4;
height = 7;
screwLength = 12-7;
screwHeadDiameter = 10;
screwThreadDiameter = 5.2;
leadScrewHoleInnerDiameter = 15;
leadScrewHoleOuterDiameter = 22.3;
leadScrewFlangeHeight = 4;


nema17ScrewLength = 10;
nema17ScrewThreadDiameter = 3.1;
nema17ScrewHeadDiameter = 6;
nema17ScrewHoleDepth = 4.0;
nema17ScrewOffset = 31;
nema17CenterHoleDiameter = 23;
nema17CenterHoleHeight = 2.1;
nema17ScrewHeadOffset = [0,0,nema17ScrewLength - nema17ScrewHoleDepth];
nema17BaseHeight = 70;

leadScrewPosition = [0,-2.4,0];

withStepperMount = true;

totalThickness = withStepperMount ? nema17BaseHeight : height;
maxScrewOpeningLength = min(totalThickness, 1000);
nema17ScrewHolePositions = [
    [-nema17ScrewOffset/2, -nema17ScrewOffset/2,-nema17BaseHeight+height],
    [nema17ScrewOffset/2, -nema17ScrewOffset/2,-nema17BaseHeight+height],
    [-nema17ScrewOffset/2, nema17ScrewOffset/2,-nema17BaseHeight+height],
    [nema17ScrewOffset/2, nema17ScrewOffset/2,-nema17BaseHeight+height]
];
nema17ScrewHolePositionsBottom = [
    [nema17ScrewOffset/2, -nema17ScrewOffset/2,-nema17BaseHeight+height],
    [-nema17ScrewOffset/2, nema17ScrewOffset/2,-nema17BaseHeight+height],
    [nema17ScrewOffset/2, nema17ScrewOffset/2,-nema17BaseHeight+height]
];

screwHolePositions = [
    [-10,20,height-totalThickness],
    [10,20,height-totalThickness],
    [-30,0,height-totalThickness],
    [30,0,height-totalThickness]
];

nema17CenterHolePosition = [0,0,-nema17BaseHeight+height];

rotate([180,0,0]) difference() {
    union() {
        hull() {
            for (s=screwHolePositions) {
                translate(s) translate([0,0,totalThickness-height]) cylinder(r=screwThreadDiameter/2+wallThickness,h=height,$fn=90);
            }
            if (withStepperMount) {
                translate(leadScrewPosition) rotate([0,0,45]) {
                    for (s=nema17ScrewHolePositionsBottom) {
                        translate(s) translate([0,0,-nema17BaseHeight+totalThickness]) 
                            cylinder(r=nema17ScrewThreadDiameter/2+wallThickness,h=nema17BaseHeight,$fn=90);
                    }
                }
                translate(leadScrewPosition) translate([0,0,-totalThickness+height]) 
                    cylinder(r=leadScrewHoleOuterDiameter/2+wallThickness,h=totalThickness,$fn=90);
            }
            else {
                translate(leadScrewPosition) 
                    cylinder(r=leadScrewHoleOuterDiameter/2+wallThickness,h=totalThickness,$fn=90);
            }
        }
    }
    
    
    if (withStepperMount) {
        for (s=screwHolePositions) {
            translate(s) translate([0,0,totalThickness-maxScrewOpeningLength]) cylinder(r=screwThreadDiameter/2,h=maxScrewOpeningLength,$fn=90);
        }
        for (s=screwHolePositions) {
            translate(s) translate([0,0,totalThickness-maxScrewOpeningLength-height])color("blue")cylinder(r=screwHeadDiameter/2,h=maxScrewOpeningLength,$fn=90);
        }
        translate(leadScrewPosition) {
            translate(nema17CenterHolePosition) {
                cylinder(r=nema17CenterHoleDiameter/2,h=nema17CenterHoleHeight,$fn=90);
                cylinder(r=leadScrewHoleOuterDiameter/2,h=totalThickness-leadScrewFlangeHeight,$fn=90);
                cylinder(r=leadScrewHoleInnerDiameter/2,h=totalThickness,$fn=90);
            }
            rotate([0,0,45]) {
                for (s=nema17ScrewHolePositions) {
                    translate(s) {
                        cylinder(r=nema17ScrewThreadDiameter/2,h=totalThickness,$fn=90);
                        translate(nema17ScrewHeadOffset) 
                            cylinder(r=nema17ScrewHeadDiameter/2,h=totalThickness,$fn=90);
                    }
                }
            }
        }
    }
    else {
        for (s=screwHolePositions) {
            translate(s) cylinder(r=screwThreadDiameter/2,h=maxScrewOpeningLength,$fn=90);
        }
        translate(leadScrewPosition) {
            cylinder(r=leadScrewHoleInnerDiameter/2,h=totalThickness,$fn=90);
            translate([0,0,totalThickness-leadScrewFlangeHeight])
                cylinder(r=leadScrewHoleOuterDiameter/2,h=leadScrewFlangeHeight,$fn=90);
        }
    }
}