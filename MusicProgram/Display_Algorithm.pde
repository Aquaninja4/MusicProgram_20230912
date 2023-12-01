void displayAlgorithm () {
  smallerDimension = (appHeight >= appWidth) ? appHeight : appWidth;
  if (width<displayWidth && height < displayHeight) {
    println("CANVAS fits in DISPLAY GEOMETRY");
    println("Display Dimensions", "Width: "+width, "Height: "+height, "Display Width: "+displayWidth, "Display Height: "+displayHeight);
  } else {
    println("CANVAS is too BIG, make it smaller");
    exit();
  }
  if (width>=height) { 
    println ("DISPLAY is Landscape or Square");
  } else { //portrait
    println ("DISPLAY is Portrait");
    println("turn phone.");
    exit();
    //Optional: "Are You Sure" Exit Screen, YES or NO
  }
