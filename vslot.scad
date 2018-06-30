include<constants.scad>;

testPiece=true;
if (testPiece) {
    zExtrusionLength = 15;
    zExtrusionWidthSections = 2;
    zExtrusionDepthSections = 1;
    difference() {
        linear_extrude(height=zExtrusionLength)
            square([
                sectionWidth*zExtrusionWidthSections+wallWidth*2,
                sectionWidth*zExtrusionDepthSections+wallWidth*2
            ]);
        translate([wallWidth, wallWidth, 0]) {
            linear_extrude(height=zExtrusionLength)
            VSlot2dProfile(
                sectionCountWidth=zExtrusionWidthSections, 
                sectionCountDepth=zExtrusionDepthSections,
                indentHeight=vslotIndentHeight,
                oversize=oversize
            );
        }; 
        /*
        negativeSpaceHoles(
            extrusionLength=zExtrusionLength,
            fullIndentHeight=wallWidth+vslotIndentHeight,
            firstIndentOffset=wallWidth,
            widthSections=zExtrusionWidthSections,
            lengthHoleSpacing=lengthHoleSpacing
        );*/        
    };
}

module extrusionIndent(_indentWidthInside, _indentWidthOutside, _indentHeight) {
    polygon(points=[
            [0,0], 
            [(_indentWidthOutside-_indentWidthInside)/2, _indentHeight], 
            [_indentWidthInside + (_indentWidthOutside-_indentWidthInside)/2, _indentHeight],
            [_indentWidthOutside, 0]
        ]);
};

module VSlot2dProfile(
    extrusionLength,
    sectionWidth = 20,
    indentHeight = vslotIndentHeight,
    sectionCountWidth,
    sectionCountDepth,
    topIndent = true,
    bottomIndent = true,
    leftIndent = true,
    rightIndent = true,
    oversize = 0
)
{
    translate([-oversize/2,-oversize/2,-oversize/2])
    resize([
        sectionWidth*sectionCountWidth+oversize,
        sectionWidth*sectionCountDepth+oversize,
        extrusionLength+oversize
    ]) difference() {
        
            square(
                size=[
                    sectionWidth*sectionCountWidth, 
                    sectionWidth*sectionCountDepth
                ]
            );
        for(i = [0:sectionCountWidth]) {
            // bottom indents
            if (bottomIndent) 
                translate([i * sectionWidth + (sectionWidth-indentWidthOutside)/2, 0, 0])
                extrusionIndent(indentWidthInside,indentWidthOutside,indentHeight);
            
            // top indents
            if (topIndent)
                translate([
                    i * sectionWidth + (sectionWidth-indentWidthOutside)/2, 
                    sectionWidth*sectionCountDepth, 
                    0
                ])
                rotate([180,0,0])
                extrusionIndent(indentWidthInside,indentWidthOutside,indentHeight);
        }
        for(i = [0:sectionCountDepth]) {
            // left side indent
            if (leftIndent)
                translate([0, (i+1) * sectionWidth - (sectionWidth-indentWidthOutside)/2, 0])
                rotate([0,0,-90]) 
                extrusionIndent(indentWidthInside,indentWidthOutside,indentHeight);
            
            // right side inden
            if (rightIndent)
                translate([
                    sectionWidth*sectionCountWidth, 
                    i * sectionWidth + (sectionWidth-indentWidthOutside)/2, 
                    0
                ])
                rotate([0,0,90]) 
                extrusionIndent(indentWidthInside,indentWidthOutside,indentHeight);
        }
    }
};


module negativeSpaceHole(
    largeHoleIndent = largeHoleIndent,
    fullIndentHeight = wallSpacing+vslotIndentHeight,
    largeHoleRadius = 5,
    smallHoleRadius = 2.5,
    )
{ 
    cylinder(h=largeHoleHeight,r=largeHoleRadius,center=false, $fn=90);
    cylinder(h=fullIndentHeight,r=smallHoleRadius,center=false, $fn=90);
}

module negativeSpaceHolePoints(
    largeHoleIndent = 1,
    largeHoleRadius = 5,
    smallHoleRadius = 2.5,
    fullIndentHeight,
    points = []
    )
{
    for (i=[0:len(points)-1]){
        translate([points[i][1],0,points[i][0]]) {
            rotate([-90,0,0]) {
                echo(points[i][0], points[i][1]);
                negativeSpaceHole(
                    largeHoleHeight=largeHoleIndent,
                    fullIndentHeight=fullIndentHeight,
                    largeHoleRadius=largeHoleRadius,
                    smallHoleRadius=smallHoleRadius);
            };
        }
    }
}

module negativeSpaceHoles(
    largeHoleIndent = 1,
    largeHoleRadius = 5,
    smallHoleRadius = 2.5,
    widthHoleSpacing = 20,
    fullIndentHeight,
    lengthHoleSpacing,
    extrusionLength,
    firstIndentOffset,
    widthSections
    ) 
{
    
    negativeSpaceHolePoints(
        largeHoleIndent = largeHoleIndent,
        largeHoleRadius = largeHoleRadius,
        smallHoleRadius = smallHoleRadius,
        fullIndentHeight = fullIndentHeight,
        lengthHoleSpacing = lengthHoleSpacing,
        widthSections = widthSections,
        points=[ 
            for (p = [lengthHoleSpacing/2+firstIndentOffset:lengthHoleSpacing:extrusionLength-firstIndentOffset-lengthHoleSpacing/2]) 
            for (s = [firstIndentOffset+widthHoleSpacing/2:widthHoleSpacing:widthHoleSpacing*widthSections]) 
            [p,s]
         ]
            
    );
}


module drawVslotExtrusion(
    height, 
    sectionCountWidth, 
    sectionCountDepth, 
    topIndent=true, 
    rightIndent=true, 
    leftIndent=true, 
    bottomIndent=true, 
    oversize=0,
    screwHeight=screwHeight,
    screwOffset=0,
    leftScrewPoints = [],
    rightScrewPoints = [], 
    topScrewPoints = [],
    bottomScrewPoints = [],
    backScrewPoints = []
    ) 
{
    linear_extrude(height=height) 
        VSlot2dProfile(
            sectionCountWidth=sectionCountWidth,
            sectionCountDepth=sectionCountDepth,
            topIndent=topIndent,
            bottomIndent= bottomIndent,
            leftIndent=leftIndent,
            rightIndent=rightIndent,
            oversize=oversize);
    
    if (len(topScrewPoints) > 0) {
        points = [ 
            for(i = [0:len(topScrewPoints)-1])
            for(j=[profileSize/2:profileSize:sectionCountWidth*profileSize])
            [topScrewPoints[i],j]
        ];
            translate([0,-screwHeight+vslotIndentHeight,0])
        negativeSpaceHolePoints(
            largeHoleIndent = screwHeight-screwOffset,
            fullIndentHeight=screwHeight,
            points = points
        );
    };
    if (len(bottomScrewPoints) > 0) {
        points = [ 
            for(i = [0:len(bottomScrewPoints)-1])
            for(j=[profileSize/2:profileSize:sectionCountWidth*profileSize])
            [height-bottomScrewPoints[i],j]
        ];
            translate([0,screwHeight+sectionCountDepth*profileSize-vslotIndentHeight,height])
            rotate([180,0,0])
        negativeSpaceHolePoints(
            largeHoleIndent = screwHeight-screwOffset,
            fullIndentHeight=screwHeight+oversize,
            points = points
        );
    };
    if (len(leftScrewPoints) > 0) {
        points = [ 
            for(i = [0:len(leftScrewPoints)-1])
            for(j=[profileSize/2:profileSize:sectionCountDepth*profileSize])
            [leftScrewPoints[i],j]
        ];
            translate([-screwHeight+vslotIndentHeight,sectionCountDepth*profileSize,0])
            rotate([0,0,-90])
        negativeSpaceHolePoints(
            largeHoleIndent = screwHeight-screwOffset,
            fullIndentHeight=screwHeight+oversize,
            points = points
        );
    };
    if (len(rightScrewPoints) > 0) {
        points = [ 
            for(i = [0:len(rightScrewPoints)-1])
            for(j=[profileSize/2:profileSize:sectionCountDepth*profileSize])
            [rightScrewPoints[i],j]
        ];
            translate([sectionCountWidth*profileSize+screwHeight-vslotIndentHeight,0,0])
            rotate([0,0,90])
        negativeSpaceHolePoints(
            largeHoleIndent = screwHeight-screwOffset,
            fullIndentHeight=screwHeight+oversize,
            points = points
        );
    };
    if (len(backScrewPoints) > 0) {
        points = [ 
            for(i = [0:len(backScrewPoints)-1])
            for(j=[profileSize/2:profileSize:sectionCountWidth*profileSize])
            [backScrewPoints[i],j]
        ];
            translate([0,sectionCountDepth*profileSize,-screwHeight+vslotIndentHeight])
            rotate([90,0,0])
        negativeSpaceHolePoints(
            largeHoleIndent = screwHeight-screwOffset,
            fullIndentHeight=screwHeight,
            points = points
        );
    };
    /*
        translate([profileSize/2,0,0])
        for(i = [0:len(leftScrewPoints)])
        for(j=[0:profileSize:sectionCountDepth*profileSize]) {
            translate([0,leftScrewPoints[i]],j) 
                negativeSpaceHole(largeHoleHeight = screwHeight-screwOffset, fullIndentHeight = screwHeight);
            }
    */
}


        