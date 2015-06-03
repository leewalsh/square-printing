// Squares!

//-- Globally used sizes --\\

// all units are mm
s = 6.0;   // square s length
t = 2.0;   // square thickness
h = 1.0;   // generic protrusion height
w = 1.0;   // generic protrusion width
p = 0.5;   // minimum padding size
lap = 1e-4; // overlap size

//-- Some parts --\\

module base(){
    // The main square base
    cube([s, s, t], center=true);
}

module ball_socket(r){
    // just the hole, should be subtracted from solid
    // already centered in x and y
    // bottom at z = -hole_depth, goes up to hole_depth + lap
    // so just place it on top of a surface that's deep enough
    hole_gap = 0.15;
    hole_depth = r + hole_gap;
    hole_width = r + hole_gap;
    translate([0, 0, -hole_depth])
    cylinder(h=hole_depth + lap, r=hole_width, center=false);
}

module ball_post(r){
    // a port for a ball that sits atop a surface
    // (i.e. not just digging a hole in an existing surface)
    // r = ball radius
    hole_gap = 0.15;
    wall_thick = p;
    hole_depth = r + hole_gap;
    hole_width = r + hole_gap;
    cheight = hole_depth + lap;
    cwidth = hole_width + wall_thick;
    difference(){
        translate([0, 0, -lap])
        cylinder(h=cheight, r=cwidth, center=false);
        translate([0, 0, cheight])  // on top of post
        ball_socket(r);
    }
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
    }
}

module one_rail(alt=1){
    rail(-1, alt);
}

module postpair(alt=1){
    // two posts on one side
    union(){
        post([-1, -1], alt);
        post([1, -1], alt);
    }
}

module four_posts(alt=1){
    union(){
        post([-1, -1], alt);
        post([1, -1], alt);
        post([-1, 1], alt);
        post([1, 1], alt);
    }
}

//-- Complete Particles --\\

S = s + 0.5; // the spacing between particles
N = 1;

// Some particles:
//union(){ base(); one_rail();}
//union(){ base(); two_rails();}
//union(){ base(); four_posts();}
//union(){ base(); disc();}
//union(){ base(); disc(); disc(-1);}
//union(){ base(); post([-1, -1]);}

ball_r = 2.03/2;
ball_dist = s-4.5*ball_r;

for(i=[0:4], j=[0:4]){
    translate([i*S, j*S, 0])
    union(){
        base();
        translate([ball_dist, ball_dist, t/2-lap])
        ball_post(ball_r);
        translate([-ball_dist, ball_dist, t/2-lap])
        ball_post(ball_r);
    }
}
