r = 2.03/2;  // radius of sphere
pad = 1;     // padding size
lap = 1e-4;    // overlap (to ensure union, difference don't get confused)

// The steel balls with diameter .080" = 2.03 mm fit snugly into a hole with
// radius r + gap for gap = [ 0.10, 0.15, 0.20 ]; tested at [-0.2:0.05:0.5]
// They poke out with a stable fit for depths r + [0.135, 0.27]
// seems the best fit is
//  radius = r + .15
//  depth  = r + .15

//gaps = [-.2,-.1,0,.1,.2,.3,.4,.5];
gmin  = 0.1;
gmax  = 0.2;
gstep = 0.05;
gaps  = [gmin:gstep:gmax];
nsteps = (gmax - gmin)/gstep + 1;
echo("nsteps", nsteps);

//depths = [r, ... 2*(r+gmax)];
dmin = r;
dmax = 2*r + gmax;
ndepths = 10;
dstep = (dmax - dmin)/(ndepths - 1);
depths = [dmin:dstep:dmax];
echo("dstep", dstep);

l = 2*(pad + r + gmax);
echo("l", l);

bheight = dmax + pad;

module base(depth){
    translate([0, 0, bheight/2]) // center for x, y, but move up so bottom is at z=0
    cube([l, l, bheight], center=true);
}

cheight = dmax + pad;
echo(cheight);
module hole(w){
    translate([0, 0, cheight/2]) // center for x, y, but move up so bottom is at z=0
    cylinder(h=cheight, r=w, center=true);
}

for(gap=gaps, depth=depths){
    //echo("gap", gap);
    //echo("dep", depth-r);
    i = (gap-gmin)/gstep;
    j = (depth-dmin)/dstep;
    w = r + gap;
    translate([(l-lap)*i, (l-lap)*j, 0]){
        difference(){
            base();
            translate([0, 0, bheight-depth])
            hole(w);
        }
    }
}
