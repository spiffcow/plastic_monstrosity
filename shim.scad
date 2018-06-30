width = 25.4 * 1.5;
sectionLength = 25.4 * 1;
step = 1;
maxSize = 3;

for(i=[1:maxSize/step])
{
    translate([sectionLength*i,0,0])
        cube([sectionLength,width,i*step]);
}