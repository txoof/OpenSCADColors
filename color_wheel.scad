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
function chord (circle chord length)
  calculates chord length given a radius and angle

  accepts:
    * r (real): radius of circle
    * angle (real): angle of segement
  returns:
    * length of chord (real)
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

function RGB(angle = 0) = [red(angle), green(angle), blue(angle)];

function RGBScale(angle = 0, r = 1) = 
  [redScale(angle, r), greenScale(angle, r), blueScale(angle, r)];

/*
module wheel
  draws a color wheel
  
  accepts:
    * segments (integer): number of segments to divide the wheel into
    * rings (integer): number of itterations 
    * pixel (array): [x dimension, y dimension, z dimension] of elements
*/
module wheel(segments = 72, rings = 10, pixel = [1, 1, 1]) {
  angle = 360/segments;
  for (i = [0 : 360/segments : 359.99999]) {
    segnum = i/360*segments;
    //echo(str("segnum: ", segnum, " angle: ", i, " RGB: ", [red(i ), green(i), blue(i)]));
    for (j = [1 : rings-0 ]) {
      //echo("j:", j);
      //add radius calculation here
      rotate([0, 0, i])
        translate([j*pixel[2], 0, 0])
        //color([red(i, 0), green(i, 0), blue(i, 0)])
        color(RGBScale(i, (j-1)/rings))
        //color(RGB(i))
        cube([pixel[0], chord(r = pixel[1]*j+1, angle = angle), pixel[2]], center = true);
    }

  }
}


function colorArray(segments = 3, rings = 5) = 
[
  for(i = [0:360/segments:359.999])
    [for(j = [1:rings])  RGB(i)]
    //[for (j = [1:rings]) RGBScale(i, (j-1)/rings)]
];



module grid(x = 10, y = 10, pixel = [10, 10, 10]) {
  myColor = colorArray(x, y);
  translate([(-(pixel[0]-1)*2*x)/2, (-(pixel[1]-1)*2*x)/2, 0]) {
    for (i = [0:x-1]) {
      for (j = [0:y-1]) {
        translate([pixel[0]*2*i, pixel[1]*2*j, 0])
        color(myColor[i][j])
        cube(pixel, center = true);
      }
    }
  }
}
wheel(90, 90);
//grid();
