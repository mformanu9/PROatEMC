run("Close All");
run("Colors...", "foreground=yellow background=yellow selection=red");
run("Line Width...", "line=3");

Dialog.create("Image Information");
Dialog.addNumber("Pixel Size:", 0.1016);
Dialog.addNumber("Radius of largest object to be quantified( in Pixel ):", 3);
Dialog.addNumber("Number of fake compartments:", 1000);
Dialog.show();
n = Dialog.getNumber();
m = Dialog.getNumber();
o = Dialog.getNumber();


dir1 = getDirectory("Choose Source Directory");
dir2 = getDirectory("Choose Destination Directory"); 
list = getFileList(dir1);


for (i = 0; i < list.length; i++){ 
      showProgress(i+1, list.length); 
      open(dir1+list[i]); 

  //path = dir1+list[i];     
 //print(path);
run("Set Scale...", "distance=1 known="+n+" pixel=1 unit=µm global");
run("Enhance Contrast", "saturated=0.35");
makeRectangle(0, 0, 300, 300);
setTool("rectangle");
waitForUser( "Adjust ROI" );
run("Crop");
saveAs("Tiff", dir2+list[i] + " ROI.tif");
run("Close All");
open(dir2+list[i] + " ROI.tif");
rename("ROI");
run("Duplicate...", "title=Endo");
selectWindow("ROI");
run("Next Slice [>]");
run("Duplicate...", "title=Protein");
selectWindow("ROI");
close();
selectWindow("Protein");
saveAs("Tiff", dir2+list[i] + " Protein.tif");
rename("Entire ROI");
selectWindow("Endo");
saveAs("Tiff", dir2+list[i] + " Endo.tif");
rename("Endo");
run("Set Measurements...", "area mean standard display redirect=None decimal=2");
selectWindow("Entire ROI");
run("Measure");
rename("Compartment");
selectWindow("Endo");
//run("Measure");
run("Smooth");
run("Smooth");
run("Duplicate...", " ");
run("Gaussian Blur...", "sigma="+m+"");
imageCalculator("Subtract create", "Endo","Endo-1");
setAutoThreshold("MaxEntropy dark");
run("Convert to Mask");
run("Fill Holes");
run("Close-");
run("Open");
saveAs("Tiff", dir2+list[i] + " Mask.tif");
rename("Mask");
run("Set Measurements...", "area mean standard display redirect=Compartment decimal=2");
run("Analyze Particles...", "display");
saveAs("Results", dir2+list[i] + " Result_EMC.xls");
run("Clear Results");

selectWindow("Compartment");
rename("RandomCompartment");
selectWindow("Mask");

run("Set Measurements...", "area mean standard display redirect=None decimal=2");
p = m*2;
dotSize = p;
  width = getWidth();
  height = getHeight();
  for (j=0; j<o; j++) {
      x = random()*width-dotSize/5;
      y = random()*height-dotSize/5;
      makeOval(x, y, dotSize, dotSize);     
run("Set Measurements...", "area mean standard display redirect=RandomCompartment decimal=2");
      run("Measure"); 
}
run("Close All");
saveAs("Results", dir2+list[i] + " Result_FakeDots.xls");
run("Clear Results");
}
