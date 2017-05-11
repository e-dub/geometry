Function CreateUpperSwashPlate
aoffset = 0;
uswash_outer_radius = base_radius - link_length;

//-------------------------------------------------------------------//
// Add a block to the swash plate
//-------------------------------------------------------------------//

dxtmp = uswash_outer_radius;
dytmp = 1.5*link_length;
dztmp = upper_swash_height;

xtmp = x_upper_swash;
ytmp = y_upper_swash - dytmp/2.0;
ztmp = z_upper_swash;

vblock = newv;
Block(vblock) = {xtmp, ytmp, ztmp, dxtmp, dytmp, dztmp};

//-------------------------------------------------------------------//
// Cut a smaller block out of this
//-------------------------------------------------------------------//

dxtmp = -link_length;
dytmp = -link_length;
dztmp = upper_swash_height;

xtmp = uswash_outer_radius*Cos(aoffset);
ytmp = uswash_outer_radius*Sin(aoffset) + link_length/2.0;
ztmp = z_upper_swash;

vsmallblock = newv;
Block(vsmallblock) = {xtmp, ytmp, ztmp, dxtmp, dytmp, dztmp};

vtot = newv;
BooleanDifference(vtot) = { Volume{vblock}; Delete; }{ Volume{vsmallblock}; Delete; };


//------------------------------------------------------------------//
// Cylindrical link
//------------------------------------------------------------------//

xlink = uswash_outer_radius*Cos(aoffset) - link_length/2.0;
ylink = uswash_outer_radius*Sin(aoffset) - link_length/2.0;
zlink = z_upper_swash + upper_swash_height/2.0;

hcy = link_length;
rcy = link_radius;

// Add a link along y dir
vlinktmp = newv;
Cylinder(vlinktmp) = {xlink, ylink, zlink, 0, hcy, 0, rcy, 2*Pi};

// create a new sphere to add to the link
vspheretmp = newv;
Sphere(vspheretmp) = {xlink, ylink + link_length/2.0 , zlink, pushrod_sphere_radius, -Pi/2, Pi/2, 2*Pi};
vlink  = newv;
BooleanUnion(vlink) = { Volume{vlinktmp}; Delete;}{ Volume{vspheretmp}; Delete;};

// Add the spherical headed connector to the total volume of the plate
v = newv;
BooleanUnion(v) = { Volume{vtot}; Delete;}{ Volume{vlink}; Delete;};

//v = Fillet{v}{11, 18, 25, 23, 7, 5, 6, 21, 19, 20, 12, 17, 22, 9, 16, 14, 8, 10}{0.0025};
//Printf("newvol %g", v);

//-------------------------------------------------------------------//
//                   MAIN CYLINDRICAL PLATE
//-------------------------------------------------------------------//

vcyl = newv;
Cylinder(vcyl) = {x_upper_swash, y_upper_swash, z_upper_swash, 0, 0, upper_swash_height, upper_swash_radius, 2*Pi};

// Remove the piece separately
vpiece = newv;
BooleanDifference(vpiece) = { Volume{v}; Delete;}{ Volume{vcyl};};

// Now add the piece to the cylinder
vnew = newv;
BooleanUnion(vnew) = { Volume{vcyl}; Delete;}{ Volume{vpiece}; Delete;};

out[] = Rotate {{0, 0, 1}, {0, 0, 0}, Pi} {
Duplicata { Volume{vnew}; }
};
vconn2 = out[0];

//out[] = Rotate {{0, 0, 1}, {0, 0, 0}, 2.0*Pi/3.0} {
//Duplicata { Volume{vconn2}; }
//};
//vconn3 = out[0];

// Unite all volumes into one
vplate = newv;
BooleanUnion(vplate) = { Volume{vnew}; Delete;}{ Volume{vconn2}; Delete;};
Coherence;

// create a new sphere to cut
X_sphere =  x_sphere;
Y_sphere =  y_sphere;
Z_sphere =  z_sphere;
vsp = newv;
Sphere(vsp) = {X_sphere, Y_sphere, Z_sphere, sphere_radius, -Pi/4, Pi/4, 2*Pi};

vupperswash = newv;
BooleanDifference(vupperswash) = { Volume{vplate}; Delete; }{ Volume{vsp}; Delete; };
Printf("Created upper swash volume (%g)", vupperswash);
Return
//
Function CreateLowerSwashPlate
aoffset = 0;

//-------------------------------------------------------------------//
// Add a block to the swash plate
//-------------------------------------------------------------------//

dxtmp = base_radius;
dytmp = 1.5*link_length;
dztmp = lower_swash_height;

xtmp = x_lower_swash;
ytmp = y_lower_swash - dytmp/2.0;
ztmp = z_lower_swash;

vblock = newv;
Block(vblock) = {xtmp, ytmp, ztmp, dxtmp, dytmp, dztmp};

//-------------------------------------------------------------------//
// Cut a smaller block out of this
//-------------------------------------------------------------------//

dxtmp = -link_length;
dytmp = -link_length;
dztmp = lower_swash_height;

xtmp = base_radius*Cos(aoffset);
ytmp = base_radius*Sin(aoffset) + link_length/2.0;
ztmp = z_lower_swash;

vsmallblock = newv;
Block(vsmallblock) = {xtmp, ytmp, ztmp, dxtmp, dytmp, dztmp};

vtot = newv;
BooleanDifference(vtot) = { Volume{vblock}; Delete; }{ Volume{vsmallblock}; Delete; };


//------------------------------------------------------------------//
// Cylindrical link
//------------------------------------------------------------------//

xlink = base_radius*Cos(aoffset) - link_length/2.0;
ylink = base_radius*Sin(aoffset) - link_length/2.0;
zlink = z_lower_swash + lower_swash_height/2.0;

hcy = link_length;
rcy = link_radius;

// Add a link along y dir
vlinktmp = newv;
Cylinder(vlinktmp) = {xlink, ylink, zlink, 0, hcy, 0, rcy, 2*Pi};

// create a new sphere to add to the link
vspheretmp = newv;
Sphere(vspheretmp) = {xlink, ylink + link_length/2.0 , zlink, pushrod_sphere_radius, -Pi/2, Pi/2, 2*Pi};
vlink  = newv;
BooleanUnion(vlink) = { Volume{vlinktmp}; Delete;}{ Volume{vspheretmp}; Delete;};

// Add the spherical headed connector to the total volume of the plate
v = newv;
BooleanUnion(v) = { Volume{vtot}; Delete;}{ Volume{vlink}; Delete;};

//-------------------------------------------------------------------//
//                   MAIN CYLINDRICAL PLATE
//-------------------------------------------------------------------//

vcyl = newv;
Cylinder(vcyl) = {x_lower_swash, y_lower_swash, z_lower_swash, 0, 0, lower_swash_height, lower_swash_radius, 2*Pi};

// Remove the piece separately
vpiece = newv;
BooleanDifference(vpiece) = { Volume{v}; Delete;}{ Volume{vcyl};};

// Now add the piece to the cylinder
vnew = newv;
BooleanUnion(vnew) = { Volume{vcyl}; Delete;}{ Volume{vpiece}; Delete;};

// vnew = Fillet{vnew}{23, 24, 28, 14}{fillet_radius};

out[] = Rotate {{0, 0, 1}, {0, 0, 0}, Pi/2} {
Duplicata { Volume{vnew}; }
};
vconn2 = out[0];

out[] = Rotate {{0, 0, 1}, {0, 0, 0}, Pi/2} {
Duplicata { Volume{vconn2}; }
};
vconn3 = out[0];

out[] = Rotate {{0, 0, 1}, {0, 0, 0}, Pi/2} {
Duplicata { Volume{vconn3}; }
};
vconn4 = out[0];

// Unite all volumes into one
v1 = newv;
BooleanUnion(v1) = { Volume{vconn3}; Delete;}{ Volume{vconn4}; Delete;};
Coherence;

v2 = newv;
BooleanUnion(v2) = { Volume{vnew}; Delete;}{ Volume{vconn2}; Delete;};
Coherence;

vplate = newv;
BooleanUnion(vplate) = { Volume{v1}; Delete;}{ Volume{v2}; Delete;};

// create a new sphere to cut
X_sphere =  x_sphere;
Y_sphere =  y_sphere;
Z_sphere =  z_sphere;
vsp = newv;
Sphere(vsp) = {X_sphere, Y_sphere, Z_sphere, sphere_radius, -Pi/4, Pi/4, 2*Pi};

vlowerswash = newv;
BooleanDifference(vlowerswash) = { Volume{vplate}; Delete; }{ Volume{vsp}; Delete; };
Printf("Created lower swash volume (%g)", vlowerswash);
Return
//
Function CreateBasePlate

// Create the hollow cylinder for main base plate
xcy = x_base;
ycy = y_base;
zcy = z_base;
hcy = base_height;
rcy = inner_base_radius;
Rcy = base_radius;
angle = 2*Pi;
Call HollowCylinderZ;
Printf("Baseplate volume is (%g)", NewVolume);

// Add push rod hole at 90 degrees
aoffset = Pi/2.0;
roffset = pushrod_roffset;
baseplate_vnum = NewVolume;
Call AddPushRodHole;
Printf("Baseplate volume is (%g)", NewVolume);

// Add push rod hole at 180 degrees
aoffset = Pi;
roffset = pushrod_roffset;
baseplate_vnum = NewVolume;
Call AddPushRodHole;
Printf("Baseplate volume is (%g)", NewVolume);

// Add push rod hole at 270 degrees
aoffset = 3.0*Pi/2.0;
roffset = pushrod_roffset;
baseplate_vnum = NewVolume;
Call AddPushRodHole;
Printf("Baseplate volume is (%g)", NewVolume);

// Create a block volume to be cut from the base plate
aoffset = 0.0;
baseplate_vnum = NewVolume;
Call CutBlockFromBasePlate;
Printf("Cutblock Baseplate volume is (%g)", NewVolume);
Return
//
Function CreatePushRod90
//-------------------------------------------------------------------//
// Create a body cylinder
//-------------------------------------------------------------------//

// Pushrod at 90 degrees

aoffset   = Pi/2.0;
roffset   = pushrod_roffset;

xbcy      = x_base + roffset*Cos(aoffset);
ybcy      = y_base + roffset*Sin(aoffset);
zbcy      = z_base;

hrod      = pushrod_height;
rrod      = pushrod_base_radius;

vbody = newv;
Cylinder(vbody) = {xbcy, ybcy, zbcy, 0, 0, hrod, rrod, 2*Pi};
Printf("Created body pushrod cylinder = %g", vbody);

//-------------------------------------------------------------------//
// Create a head cylinder
//-------------------------------------------------------------------//

hcy   = 2*pushrod_inner_radius;
rcy   = pushrod_outer_radius;

xcy   = x_base + roffset*Cos(aoffset) - hcy/2.0;
ycy   = y_base + roffset*Sin(aoffset); 
zcy   = z_lower_swash + lower_swash_height/2.0 ;

vhead = newv;
Cylinder(vhead) = {xcy, ycy, zcy, hcy, 0, 0, rcy, 2*Pi};
Printf("Created head pushrod cylinder = %g", vhead);

// Unite the body and head to make the pushrod
vtot = newv;
BooleanUnion(vtot) = { Volume{vhead}; Delete; }{ Volume{vbody}; Delete; };
NewVolume = vtot;

// Punch a spherical hole on the head
xcy   = x_base + roffset*Cos(aoffset);
ycy   = y_base + roffset*Sin(aoffset); 
zcy   = z_lower_swash + lower_swash_height/2.0 ;

vspheretmp = newv;
Sphere(vspheretmp) = {xcy, ycy, zcy, pushrod_sphere_radius, -Pi/2, Pi/2, 2*Pi};
Printf("Punched spherical hole in pushrod = %g", vspheretmp);
v = newv;
BooleanDifference(v) = { Volume{vtot}; Delete; }{ Volume{vspheretmp}; Delete; };

// Punch a cylindrical hole on the head
//hcy   = 2*pushrod_inner_radius;
//rcy   = pushrod_inner_radius;
//vcyltmp = newv;
//Cylinder(vcyltmp) = {xcy, ycy, zcy, hcy, 0, 0, rcy, 2*Pi};
//Printf("Punched cylindrical hole in pushrod = %g", vcyltmp);
//v = newv;
//BooleanDifference(v) = { Volume{vtot}; Delete; }{ Volume{vcyltmp}; Delete; };
Return
//
Function CreatePushRod180
// Pushrod at 180 degrees
//-------------------------------------------------------------------//
// Create a body cylinder
//-------------------------------------------------------------------//
aoffset   = Pi;
roffset   = pushrod_roffset;

xbcy      = x_base + roffset*Cos(aoffset);
ybcy      = y_base + roffset*Sin(aoffset);
zbcy      = z_base;

hrod      = pushrod_height;
rrod      = pushrod_base_radius;

vbody = newv;
Cylinder(vbody) = {xbcy, ybcy, zbcy, 0, 0, hrod, rrod, 2*Pi};
Printf("Created body pushrod cylinder = %g", vbody);

//-------------------------------------------------------------------//
// Create a head cylinder
//-------------------------------------------------------------------//

hcy   = 2*pushrod_inner_radius;
rcy   = pushrod_outer_radius;

xcy   = x_base + roffset*Cos(aoffset);
ycy   = y_base + roffset*Sin(aoffset)- hcy/2.0; 
zcy   = z_lower_swash + lower_swash_height/2.0 ;

vhead = newv;
Cylinder(vhead) = {xcy, ycy, zcy, 0, hcy, 0, rcy, 2*Pi};
Printf("Created head pushrod cylinder = %g", vhead);

// Unite the body and head to make the pushrod
vtot = newv;
BooleanUnion(vtot) = { Volume{vhead}; Delete; }{ Volume{vbody}; Delete; };
NewVolume = vtot;

// Punch a spherical hole on the head
xcy   = x_base + roffset*Cos(aoffset);
ycy   = y_base + roffset*Sin(aoffset); 
zcy   = z_lower_swash + lower_swash_height/2.0 ;

vspheretmp = newv;
Sphere(vspheretmp) = {xcy, ycy, zcy, pushrod_sphere_radius, -Pi/2, Pi/2, 2*Pi};
Printf("Punched spherical hole in pushrod = %g", vspheretmp);
v = newv;
BooleanDifference(v) = { Volume{vtot}; Delete; }{ Volume{vspheretmp}; Delete; };

// Punch a cylindrical hole on the head
//hcy   = 2*pushrod_inner_radius;
//rcy   = pushrod_inner_radius;
//vcyltmp = newv;
//Cylinder(vcyltmp) = {xcy, ycy, zcy, hcy, 0, 0, rcy, 2*Pi};
//Printf("Punched cylindrical hole in pushrod = %g", vcyltmp);
//v = newv;
//BooleanDifference(v) = { Volume{vtot}; Delete; }{ Volume{vcyltmp}; Delete; };
Return
//
Function CreatePushRod270
// Pushrod at 270 degrees
//-------------------------------------------------------------------//
// Create a body cylinder
//-------------------------------------------------------------------//
aoffset = 3.0*Pi/2.0;
roffset   = pushrod_roffset;

xbcy      = x_base + roffset*Cos(aoffset);
ybcy      = y_base + roffset*Sin(aoffset);
zbcy      = z_base;

hrod      = pushrod_height;
rrod      = pushrod_base_radius;

vbody = newv;
Cylinder(vbody) = {xbcy, ybcy, zbcy, 0, 0, hrod, rrod, 2*Pi};
Printf("Created body pushrod cylinder = %g", vbody);

//-------------------------------------------------------------------//
// Create a head cylinder
//-------------------------------------------------------------------//

hcy   = 2*pushrod_inner_radius;
rcy   = pushrod_outer_radius;

xcy   = x_base + roffset*Cos(aoffset) - hcy/2.0;
ycy   = y_base + roffset*Sin(aoffset); 
zcy   = z_lower_swash + lower_swash_height/2.0 ;

vhead = newv;
Cylinder(vhead) = {xcy, ycy, zcy, hcy, 0, 0, rcy, 2*Pi};
Printf("Created head pushrod cylinder = %g", vhead);

// Unite the body and head to make the pushrod
vtot = newv;
BooleanUnion(vtot) = { Volume{vhead}; Delete; }{ Volume{vbody}; Delete; };
NewVolume = vtot;

// Punch a spherical hole on the head
xcy   = x_base + roffset*Cos(aoffset);
ycy   = y_base + roffset*Sin(aoffset); 
zcy   = z_lower_swash + lower_swash_height/2.0 ;

vspheretmp = newv;
Sphere(vspheretmp) = {xcy, ycy, zcy, pushrod_sphere_radius, -Pi/2, Pi/2, 2*Pi};
Printf("Punched spherical hole in pushrod = %g", vspheretmp);
v = newv;
BooleanDifference(v) = { Volume{vtot}; Delete; }{ Volume{vspheretmp}; Delete; };

// Punch a cylindrical hole on the head
//hcy   = 2*pushrod_inner_radius;
//rcy   = pushrod_inner_radius;
//vcyltmp = newv;
//Cylinder(vcyltmp) = {xcy, ycy, zcy, hcy, 0, 0, rcy, 2*Pi};
//Printf("Punched cylindrical hole in pushrod = %g", vcyltmp);
//v = newv;
//BooleanDifference(v) = { Volume{vtot}; Delete; }{ Volume{vcyltmp}; Delete; };
Return
//
Function CreateBlade
// Airfoil
cl       = 0.01; // characteristic length of the mesh //0.01
chord    = 0.121; // chord of the airfoil
r_cutout = 0.44;  // cutout radius of the root
R        = 2.0;   // Tip radius
r_tw     = 1.5;                     // radius of zero twist (m)
b_len    = R - r_cutout;            // blade length (m)
theta_tw = -8.0;                    // linear twist (deg)
dtheta   = theta_tw/(R-r_cutout)*Pi/180; //linear twist rate (rad/m)

// The following variables must be set on entry:
// NACA4_th       : thickness in percent of chord
// NACA4_ch       : aerofoil chord
// NACA4_le_x,y,z : leading edge coordinates
// NACA4_len_te   : length scale (trailing edge)
// NACA4_len_mc   : length scale (mid chord)
// NACA4_len_le   : length scale (leading edge)
// NACA4_nspl     : number of splines on section
// NACA4_pps      : number of points per spline

// NACA4_npts = NACA4_nspl*NACA4_pps ;

NACA4_nspl   = 4 ;
NACA4_pps    = 5 ;

NACA4_len_le = cl ; // unused
NACA4_len_mp = cl ; // unused
NACA4_len_te = cl ; // unused

NACA4_th     = 12 ;
NACA4_ch     = 0.121 ;
NACA4_le_x   = -0.121/2.0; // Span/2*Sin(Sweep) ;
NACA4_le_y   = 0.0 ; // actually z
NACA4_le_z   = r_cutout ; // actually y

// Create the airfoil 
Call NACA4 ;

ll = newll ;
Line Loop(ll) = NACA4_Splines[] ;

s = news ;
Plane Surface(s) = {ll};

out[] = Rotate {{0, 0, 1}, {0, 0, 0}, -Pi/2.0} {
Duplicata { Surface{s}; }
};
srotated = out[0];

Delete{s};

Extrude {R, 0, 0} {
  Surface{srotated};
  Layers{(R-r_cutout)/cl};
}
Coherence;
// Delete the duplicate surface and points
Return
//