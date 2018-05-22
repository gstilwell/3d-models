/*
http://codeviewer.org/view/code:1b36 
Copyright (C) 2011 Sergio Vilches
This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
Contact: s.vilches.e@gmail.com


    ----------------------------------------------------------- 
                 Round Corners Cube (Extruded)                
      roundCornersCube(x,y,z,r) Where:                        
         - x = Xdir width                                     
         - y = Ydir width                                     
         - z = Height of the cube                             
         - r = Rounding radious                               
                                                              
      Example: roundCornerCube(10,10,2,1);                    
     *Some times it's needed to use F6 to see good results!   
 	 ----------------------------------------------------------- 
*/

// creates the shape that is subtracted from a cube to make its corners rounded.
module roundedCorner(radius)
// cube - 1/4 cylinder
difference(){
   // add small fractions to avoid "ghost boundaries" when subtracting
    cube([radius + 0.1, radius + 0.1, radius + 0.1], center=true);    
     
    translate([radius/2, radius/2, radius/2]){
        sphere(r = radius, $fn = 25, center = true);
    }
}


module roundedEdge(length, radius)
// cube - 1/4 cylinder
difference(){
    cube([radius + 0.1, radius + 0.1, length + 0.1], center=true);    
     
    translate([radius/2, radius/2, 0]){
        cylinder(h = length + 0.3, r = radius, $fn = 25, center = true);
    }
}

module roundedEdgesCube(x,y,z,r) {
    difference() {
        cube( [x, y, z], center = true );
    
        // x edges
        translate([0, (y/2 - r/2), (z/2 - r/2)]) {
            rotate([90,90,-90]) { roundedEdge(x, r); }
        }
        translate([0, (y/2 - r/2), -(z/2 - r/2)]) {
            rotate([-90,-90,-90]) { roundedEdge(x, r); }
        }
        translate([0, -(y/2 - r/2), (z/2 - r/2)]) {
            rotate([0,90,0]) { roundedEdge(x, r); }
        }
        translate([0, -(y/2 - r/2), -(z/2 - r/2)]) {
            rotate([90,-90,-90]) { roundedEdge(x, r); }
        }

        // y edges
        translate([(x/2 - r/2), 0, (z/2 - r/2)]) {
            rotate([90,180,0]) { roundedEdge(y, r); }
        }
        translate([(x/2 - r/2), 0, -(z/2 - r/2)]) {
            rotate([90,-90,0]) { roundedEdge(y, r); }
        }
        translate([-(x/2 - r/2), 0, (z/2 - r/2)]) {
            rotate([90,90,0]) { roundedEdge(y, r); }
        }
        translate([-(x/2 - r/2), 0, -(z/2 - r/2)]) {
            rotate([90,0,0]) { roundedEdge(y, r); }
        }

        // z edges
        translate([(x/2 - r/2), (y/2 - r/2), 0]) {
            rotate([0,0,180]) { roundedEdge(z, r); }
        }
        translate([(x/2 - r/2), -(y/2 - r/2), 0]) {
            rotate([0,0,90]) { roundedEdge(z, r); }
        }
        translate([-(x/2 - r/2), (y/2 - r/2), 0]) {
            rotate([0,0,-90]) { roundedEdge(z, r); }
        }
        translate([-(x/2 - r/2), -(y/2 - r/2), 0]) {
            rotate([0,0,0]) { roundedEdge(z, r); }
        }

        // top corners
        translate([(x/2 - r/2), (y/2 - r/2), (z/2 - r/2)]) {
            rotate([90,90,-90]) { roundedCorner(r); }
        }
        translate([(x/2 - r/2), -(y/2 - r/2), (z/2 - r/2)]) {
            rotate([-90,0,90]) { roundedCorner(r); }
        }
        translate([-(x/2 - r/2), (y/2 - r/2), (z/2 - r/2)]) {
            rotate([0,180,180]) { roundedCorner(r); }
        }
        translate([-(x/2 - r/2), -(y/2 - r/2), (z/2 - r/2)]) {
            rotate([0,90,0]) { roundedCorner(r); }
        }

        // bottom corners
        translate([(x/2 - r/2), (y/2 - r/2), -(z/2 - r/2)]) {
            rotate([90,-90,0]) { roundedCorner(r); }
        }
        translate([(x/2 - r/2), -(y/2 - r/2), -(z/2 - r/2)]) {
            rotate([-90,-90,90]) { roundedCorner(r); }
        }
        translate([-(x/2 - r/2), (y/2 - r/2), -(z/2 - r/2)]) {
            rotate([90,0,0]) { roundedCorner(r); }
        }
        translate([-(x/2 - r/2), -(y/2 - r/2), -(z/2 - r/2)]) {
            rotate([0,0,0]) { roundedCorner(r); }
        }
    }
}


module roundCornersCube(x,y,z,r)
difference(){
    cube([x,y,z], center=true);

    //roundedEdge(x,y,z,r);

    translate([x/2 - r, y/2 - r]){  // We move to the first corner (x,y)
      rotate(0){  
         roundedCorner(z,r); // And substract the meniscus
      }
    }
    translate([-x/2 + r, y/2 - r]){ // To the second corner (-x,y)
      rotate(90){
         roundedCorner(z,r); // But this time we have to rotate the meniscus 90 deg
      }
    }
    translate([-x/2 + r, -y/2 + r]){ // ... 
        rotate(180){
            roundedCorner(z,r);
        }
    }
    translate([x/2 - r, -y/2 + r]){
        rotate(270){
            roundedCorner(z,r);
        }
    }
}

module triangleCutout(x,y,z) {
    polyhedron(
        points = [ [0,0,0], [x,0,0], [x,y,0], [0,y,0], [0,y/2,z], [x,y/2,z] ],
        faces = [ [0,1,2,3], [5,4,3,2], [0,4,5,1], [0,3,4], [5,2,1] ]
    );
}

module xCutout(l,w,h) {
    translate([-w/6.5, 0, h]) {
        rotate([0,90,0]) {
            translate([0,-l/4,-w/2]) {
                triangleCutout(h * 2, l / 2, w / 2.2, 0,0,0,0,0);
            }
        }
        rotate([90,90,0]) {
            translate([0,-l/4,-w/2.5]) {
                triangleCutout(h * 2, l / 2, w / 3, 0,0,0,0,0);
            }
        }
        rotate([0,90,90]) {
            translate([0,-l/4,-w/2.5]) {
                triangleCutout(h * 2, l / 2, w / 3, 0,0,0,0,0);
            }
        }
        rotate([-90,90,90]) {
            translate([0,-l/4,-w/2]) {
                triangleCutout(h * 2, l / 2, w / 2.2, 0,0,0,0,0);
            }
        }
    }
}

module fingerNotch(length, height, radius)
translate( [length/2, 0, 0] ) {
    cylinder(height + 0.2, r = radius, $fn = 25, center = true);
}





module capWithNothingCutOut(l, w, h, edgeRad, notchRad) {
    difference() {
        roundedEdgesCube( l, w, h, edgeRad );
        fingerNotch(l, h, notchRad);
    }
}


module capWithXCutOut(l, w, h, edgeRad, notchRad) {
    difference() {
        roundedEdgesCube( l, w, h, edgeRad );
        fingerNotch(l, h, notchRad);
        xCutout(l, w, h);
    }
}

module capWithCapCutOut(l, w, h, edgeRad, notchRad) {
    difference() {
        roundedEdgesCube( l, w, h, edgeRad );
        fingerNotch(l, h, notchRad);
        difference() {
            roundedEdgesCube( l * 0.75, w * 0.75, h * 1.1, edgeRad );
            scale([1.3, 1.3]) {
                fingerNotch(l * 0.75, h * 1.1, notchRad * 1);
            }
        }
    }
}

module capWithFancyXCutOut(l, w, h, edgeRad, notchRad) {
    difference() {
        roundedEdgesCube( l, w, h, edgeRad );
        fingerNotch(l, h, notchRad);
        xCutout(l, w, h);
        difference() {
            roundedEdgesCube( l * 0.85, w * 0.77, h * 1.1, edgeRad );
            scale([1.3, 1.3]) {
                fingerNotch(l * 0.75, h * 1.1, notchRad * 1);
            }
            translate([-l/3.66, 0, 0]) {
                cube([l, w, h*2], center=true);
            }
        }
    }
}




// stockpile big cards
// values in mm
    largeLength = 87;
    largeWidth = 57;
    largeHeight = 12;
    largeEdgeRadius = 1;
    largeNotchRadius = 15;

// stockpile small cards
// values in mm
    length = 66;
    width = 44;
    height = 12;
    edgeRadius = 1;
    notchRadius = 13;

large = true;
small = !large;


if( large ) {
translate([0, -largeWidth * 1.1, 0])    capWithNothingCutOut    ( largeLength, largeWidth, largeHeight, largeEdgeRadius, largeNotchRadius );
translate([0,  largeWidth * 1.1, 0])    capWithXCutOut          ( largeLength, largeWidth, largeHeight, largeEdgeRadius, largeNotchRadius );
                                        capWithCapCutOut        ( largeLength, largeWidth, largeHeight, largeEdgeRadius, largeNotchRadius );
translate([largeLength * 1.1, 0, 0])    capWithFancyXCutOut     ( largeLength, largeWidth, largeHeight, largeEdgeRadius, largeNotchRadius );
}



if( small ) {
translate([0, -width * 1.1, 0])     capWithNothingCutOut    ( length, width, height, edgeRadius, notchRadius );
translate([0,  width * 1.1, 0])     capWithXCutOut          ( length, width, height, edgeRadius, notchRadius );
                                    capWithCapCutOut        ( length, width, height, edgeRadius, notchRadius );
translate([length * 1.1, 0, 0])     capWithFancyXCutOut     ( length, width, height, edgeRadius, notchRadius );
}