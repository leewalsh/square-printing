// Squares!

//-- Globally used sizes --\\

// all units are mm
s = 6.0;   // square s length
t = 2.0;   // square thickness
h = 1.0;   // generic protrusion height
w = 1.0;   // generic protrusion width

//-- Some parts --\\

module base(){
    // The main square base
    cube([s, s, t], center=true);
    }

module rail(side, alt=1){
    // one long rail along one s on the top or bottom of the square
    //
    // side: right (1) or left (-1) s
    // alt (altitude): top (1) or bottom (-1)
    translate([side*(s - w)/2, 0, alt*(t + h)/2])
    cube([w, s, h], center=true);
    }

module post(corner, alt=1){
    // a post sticking up out of a corner
    // corner: gives the quadrant as list of two numbers: [+/-1, +/-1]
    //         e.g., [-1, 1] is the 2nd quadrant.
    translate([corner[0]*(s - w)/2, corner[1]*(s - w)/2, alt*(t+h)/2])
    cylinder(h=h, r=w/2, center=true);
    }

module disc(alt=1, size=1){
    // round disc with full rotational symmetry
    // size: diameter relative to the square
    // alt (altitude): top (1) or bottom (-1)
    translate([0, 0, alt*(t+h)/2])
    cylinder(h=h, r=size*s/2, center=true);
    }

//-- Some sub-assemblies for convenience --//

module two_rails(alt=1){
    // two parallel rails across from each other at given altitude
    union(){
    rail(-1, alt);
    rail(1, alt);
    }}

module one_rail(alt=1){
    union(){
    rail(-1, alt);
    }}

module postpair(alt=1){
    // two posts on one side
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

//-- Complete Particles --\\

spacing = 1.25*s; // the spacing between particles

union(){ base(); postpair();}

translate([spacing, 0, 0])
union(){ base(); one_rail();}

translate([0, spacing, 0])
union(){ base(); two_rails();}

translate([spacing, spacing, 0])
union(){ base(); four_posts();}

translate([2*spacing, 0, 0])
union(){ base(); disc();}

translate([2*spacing, spacing, h])
union(){ base(); disc(); disc(-1);}

translate([2*spacing, 2*spacing, 0])
union(){ base(); post([-1, -1]);}
