height = 10;
inner = 4;
outer = 5;
lip = 10;
lipHeight = 2;

difference() {
    union() {
        cylinder(h=lipHeight, r=lip/2, $fn=90);
        cylinder(h=height+lipHeight, r=outer/2, $fn=90);
    }
    cylinder(h=height+lipHeight, r=inner/2, $fn=90);
}