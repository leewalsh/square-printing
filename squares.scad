// Squares!
// sizes should be in mm

side = 6.0;   // square side length
thck = 2.0;   // square thickness
hght = 1.0;   // protrusion height
wdth = 1.0;   // protrusion width

module base(){
    cube([side, side, thck], center=true);
    }

module rail(rorl, alt=1){
    // rorl = right or left (+/- 1)
    translate([rorl*(side - wdth)/2, 0, alt*(thck + hght)/2])
    cube([wdth, side, hght], center=true);
    }

module post(crnr, alt=1){
    // crnr = which corner: [+/-1, +/-1]
    translate([crnr[0]*(side - wdth)/2, crnr[1]*(side - wdth)/2, alt*(thck+hght)/2])
    cylinder(h=hght, r=wdth/2, center=true);
    }

module sled(alt=1){
    translate([0, 0, alt*(thck+hght)/2])
    cylinder(h=hght, r=side/2, center=true);
    }

module two_rails(alt=1){
    union(){
    rail(-1, alt);
    rail(1, alt);
    }}

module one_rail(alt=1){
    union(){
    rail(-1, alt);
    }}

module one_postpair(alt=1){
    union(){
    post([-1, -1], alt);
    post([1, -1], alt);
    }}

module four_posts(alt=1){
    union(){
    post([-1, -1], alt);
    post([1, -1], alt);
    post([-1, 1], alt);
    post([1, 1], alt);
    }
}

spce = 1.25*side;

union(){ base(); one_postpair();}

translate([spce, 0, 0])
union(){ base(); one_rail();}

translate([0, spce, 0])
union(){ base(); two_rails();}

translate([spce, spce, 0])
union(){ base(); four_posts();}

translate([2*spce, 0, 0])
union(){ base(); sled();}

translate([2*spce, spce, hght])
union(){ base(); sled(); sled(-1);}

translate([2*spce, 2*spce, 0])
union(){ base(); post([-1, -1]);}
