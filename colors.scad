/*
Rainbow Color Library
=====================
Aaron Ciuffo (Txoof)
Reach me at google mail: aaron dot ciuffo
https://www.thingiverse.com/txoof/about
released under GPL V3.0

Library to produce 2D array of RGB values scaled across an abitrary size
*/

/* [Demo] */
//Which Demo?
demo = "wheel"; //[wheel:Color Wheel, grid:Color Palet, objDemo:Object Demo]
//Use color scaling?
ColorScaling = true; //[true:Use Color Scaling, false:Do Not Use Color Scaling]
//Segments to divide color wheel into
WheelSegments = 144; //[2:255]
// Iterations 
WheelIterations = 144; // [1:255]
//Grid Columns
GridColumns = 144; //[1:255]
//Grid Rows
GridRows = 144; //[1:255]

thingiverse();

module thingiverse() {
  if (demo == "wheel") {
    wheel(WheelSegments, WheelIterations, ColorScaling);
  } 

  if (demo == "grid") {
    grid(GridColumns, GridRows, ColorScaling);
  }

  if (demo == "objDemo") {
    objDemo();
  }
}

/*
function wCos (wheel cosine)
  calculates the phase shifted cos function with a period of 8Pi/3 (cos(t*3/4))/0.7
  
  accepts:
    * angle (real): angle for which to calculate a the cos function (in degrees)
    * shift (real): angle by which to advance/retard the phase (in degrees)

  returns:
    * positive real number between 1.5, 0
*/
function wCos(angle = 0, shift = 0) = abs(cos((angle*3/4)-shift))/0.7;


/*
function chord(r = 1, angle = 30)
  calculates chord length given a radius and angle

  accepts:
    * r (real): radius of circle
    * angle (real): angle of segement
  returns:
    * length of chord (real)

  example:
    * echo(chord(r = 10, angle = 60));
    * ECHO: 5.17638

*/
function chord(r = 1, angle = 30) = 2*(r*sin(angle/2));


/*
function red
  provides red values for a color wheel with a radius of 1 radian where:
    red increases from 0 to 1 over interval 4Pi/3 to 5Pi/3
    red is 1 over interval  5Pi/3 to Pi/3
    red decreases from 1 to 0 over interval Pi/3 to 2Pi/3
    phase shift = 0 and 270

  accepts:
    * angle (real)
  returns:
    * positive real between 0 and 1
*/
function red(angle = 0) = 
  angle <= 120  ? 
    ((wCos(angle, 0) >= 1) ? 1 : wCos(angle, 0)) 
  : ((angle >=240) ? (wCos(angle, 270) >= 1 ? 1 : wCos(angle, 270)) 
  : 0);

/*
function redScale
  Scales red values between 5Pi/3 to Pi/3 for a color wheel as a percentage 
  of 1 radian

  accepts:
    * angle (real)
    * r (real): radians
  returns:
    * positive real between 0 and 1
*/
function redScale(angle = 0, r = 1) =
  ((angle >= 0 && angle <= 60) || (angle >= 300 && angle <= 360)) ?
    red(angle) : red(angle) + ((1 - red(angle)) * (1 - r)); 

/*
function green
  provides green values for a color wheel with a radius of 1 radian where:
    green increases from 0 to 1 over interval 0 to Pi/3
    green is 1 over interval Pi/3 to Pi
    green decreases from 1 to 0 over interval Pi to 4Pi/3
    phase shift = 90

  accepts:
    * angle (real)
  returns:
    * positive real between 0 and 1
*/
function green(angle = 0) = 
  angle <= 240 ?
    ((wCos(angle, 90) >= 1) ? 1 : wCos(angle, 90)) : 0;

/*
function greenScale
  Scales green values between Pi/3 to 3Pi/3 for a color wheel as a percentage 
  of 1 radian
  
  accepts:
    * angle (real)
    * r (real): radians
  returns:
    * positive real between 0 and 1
*/
function greenScale(angle = 0, r = 1) =
  (angle >= 60 && angle <= 180) ?
    green(angle) : green(angle) + ((1 - green(angle)) * (1 - r)); 



/*
function blue
  provides green values for a color wheel with a radius of  radian where:
    blue increases from 0 to 1 over interval 2Pi/3 to Pi
    blue is 1 over interval Pi to 5Pi/3
    blue decreases from 1 to 0 over interval 5Pi/3 to 0
  accepts:
    * angle (real)
  returns:
    * positve real between 0 and 1
*/
function blue(angle = 0) = 
  angle >= 120 ?
    ((wCos(angle, 180) >= 1) ? 1 : wCos(angle, 180)) : 0; 

/*
function blueScale
  Scales blue values between 3Pi/3 to 5Pi/3 for a color wheel as a percentage 
  of 1 radian
  
  accepts:
    * angle (real)
    * r (real): radians
  returns:
    * positive real between 0 and 1
*/
function blueScale(angle = 0, r = 1) =
  (angle >= 180 && angle <= 300) ?
    blue(angle) : blue(angle) + ((1 - blue(angle)) * (1 - r)); 

/*
function RGB(angle = 30)
  returns RGB value as 1D array of reals value between 0 an 1.

  accepts:
    * angle (real)
  returns:
    * RGB (array of real)

  example:
    * echo(RGB(30))
    * ECHO: [1, 0.546691, 0]

*/
function RGB(angle = 0) = [red(angle), green(angle), blue(angle)];

/*
funciton RGBScale
  returns RGB value as 1D array of reals scaled by distance from origin (0-1)

  accepts:
    * angle (real)
    * r (real): radius between 0-1
  returns:
    * RGB (array of real)

  example: 
    * echo(RGBScale(55, 1));
    * ECHO: [1, 0.941923, 0]
    * echo(RGBScale(55, 0.5));
    * ECHO: [1, 0.970961, 0.5]
    * echo(RGBScale(55, 0));
    * ECHO: [1, 1, 1]
*/
function RGBScale(angle = 0, r = 1) = 
  [redScale(angle, r), greenScale(angle, r), blueScale(angle, r)];



/*
function colorArray(columns = 10, rows = 10, scaled = false)
  create an X by Y array of RGB values

  accepts:
    * columns (integer): divisions of color wheel
    * rows (integer): number of itterations from origin 
    * scaled (boolean): when true, return a value scaled by 
      distance from origin
  returns:
    * X by Y array of RGB values

  example:
    * myArray = colorArray(3, 3, scaled = false);
      for (row=[0:len(myArray)-1]) { //five itterations
        echo(colorArray[row]);
      }

    * ECHO: [[1, 0, 0], [1, 0, 0], [1, 0, 0]]
    * ECHO: [[0, 1, 0], [0, 1, 0], [0, 1, 0]]
    * ECHO: [[0, 0, 1], [0, 0, 1], [0, 0, 1]]

*/
function colorArray(columns = 10, rows = 10, scaled = false) = 
  scaled ? 
    [
      for(i = [0:360/columns:359.999])
        [for (j = [1:rows]) RGBScale(i, (j-1)/rows)]
    ] : 
    [
      for(i = [0:360/columns:359.999])
        [for(j = [1:rows])  RGB(i)]
    ];


/*
module grid(x = 10, y = 10, scaled = true, pixel = [10, 10, 10]
  draws a color grid
  
  accepts:
    * x (integer): number of rows
    * y (integer): number of columns
    * scaled (boolean): true - use scaling
    * pixel ([l, w, h]): 1D array of length, width, height
*/
module grid(x = 10, y = 10, scaled = true, pixel = [10, 10, 10]) {
  myColor = colorArray(x, y, scaled);
  translate([(-(pixel[0])*x)/2, (-(pixel[1])*y)/2, 0]) {
    for (i = [0:x-1]) {
      for (j = [0:y-1]) {
        translate([pixel[0]*1*i, pixel[1]*1*j, 0])
        color(myColor[i][j])
        cube(pixel, center = true);
      }
    }
  }
}

/*
module wheel(segments = 72, rings = 72, pixel = [10, 10, 10]
  draws a color wheel
  
  accepts:
    * segments (integer): number of segments to divide the wheel into
    * rings (integer): number of itterations 
    * scaled (boolean): true - use color scaling
    * pixel (1D array): [x dimension, y dimension, z dimension] of elements
*/
module wheel(segments = 72, rings = 72, scaled = true, pixel = [10, 10, 10]) {
  angle = 360/segments;
  for (i = [0 : 360/segments : 359.99999]) {
    segnum = i/360*segments;
    //echo(str("segnum: ", segnum, " angle: ", i, " RGB: ", [red(i ), green(i), blue(i)]));
    for (j = [1 : rings-0 ]) {
      if (scaled) {
        rotate([0, 0, i])
          translate([j*pixel[2], 0, 0])
          color(RGBScale(i, (j-1)/rings))
          //color(RGB(i))
          cube([pixel[0], chord(r = pixel[1]*(j+1), angle = angle), 
                pixel[2]], center = true);
      } else {
         rotate([0, 0, i])
          translate([j*pixel[2], 0, 0])
          //color(RGBScale(i, (j-1)/rings))
          color(RGB(i))
          cube([pixel[0], chord(r = pixel[1]*(j+1), angle = angle), 
                pixel[2]], center = true);
     
      }
    }

  }
}

module objDemo(rows = 2, columns = 3, size = 20, minQual = 36, step = 1) {
  sep = 1; //seperation of elements
  //create an array of RGB values that matches the rows and columns
  myColors = colorArray(rows, columns, scaled = true);
  for (i = [1:rows]) {
    for (j = [1:columns]) {
      // make some interesting shapes by adjusting the quality
      $fn = (minQual+i*step) >= 36 ? 36 : (minQual+i*step);
      //pull the next color from the color array 
      color(myColors[i-1][j-1])
      translate([size+(size*2+size*sep)*(i-1), 
                size+(size*2+size*sep)*(j-1), 0])
      sphere(size, $fn);
    }
  }

}

//wheel(144, 90, true);
//grid(255, 255, true);

//echo(chord(10, 30));
//echo(RGB(30));
//echo(colorArray(11, 15));

/*
echo(RGBScale(55, 1));
echo(RGBScale(55, 0.5));
echo(RGBScale(55, 0));
*/

/*
myArray = colorArray(3, 3, scaled = false);
for (row=[0:len(myArray)-1]) { //three iterations
  echo(myArray[row]);
}
*/
