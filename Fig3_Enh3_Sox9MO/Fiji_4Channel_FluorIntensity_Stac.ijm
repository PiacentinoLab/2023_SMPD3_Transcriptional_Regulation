//Define channels to measure and their names
measure_channel_1 = 2
measure_channel_1_name = "SOX10"
measure_channel_2 = 3
measure_channel_2_name = "H2BRFP"
measure_channel_3 = 4
measure_channel_3_name = "Enh3GFP"
measure_channel_4 = 5
measure_channel_4_name = "Pax7"

//learn file name, prepare file and Fiji for analysis
name=File.nameWithoutExtension;
//run("Rotate... ", "angle=180 grid=1 interpolation=Bilinear stack");
run("Z Project...", "projection=[Max Intensity]");
rename("A");
setTool("freehand");

//Close unnecessary windows from last analysis
if (isOpen("Results")) { 
         selectWindow("Results"); 
         run("Close"); 
    } 
if (isOpen("Summary")) { 
         selectWindow("Summary"); 
         run("Close"); 
    } 
if (isOpen("ROI Manager")) { 
         selectWindow("ROI Manager"); 
         run("Close"); 
    } 

////Optional: Input ROI File:
//	roi=File.openDialog("Select ROI file");
//	roiManager("Open",roi);

//Add scale bar to define AP length for measurement
run("Scale Bar...", "width=400 height=8 font=28 color=White background=None location=[Lower Right] bold overlay");

//Define ROIs
setTool("freehand");
waitForUser("Draw ROI 0 (Background in the forebrain NT tissue), then press ok");
roiManager("Add");
roiManager("Select",0);
roiManager("Rename","Background");
roiManager("Show All");
waitForUser("Draw ROI 1 (Control Area), then press ok");
roiManager("Add");
roiManager("Select",1);
roiManager("Rename","CntlArea");
waitForUser("Draw ROI 2 (Experimental Area), then press ok");
roiManager("Add");
roiManager("Select",2);
roiManager("Rename","ExptArea");

run("Split Channels");

//Measure background then ROI IntDen
//Channel 2
selectWindow("C" + toString(measure_channel_1) + "-A");
rename(measure_channel_1_name);
resetMinAndMax();
run("Subtract Background...", "rolling=200");
roiManager("Show All");
roiManager("Deselect");
roiManager("Measure");
selectWindow(measure_channel_1_name);
close();

//Channel 3
selectWindow("C" + toString(measure_channel_2) + "-A");
rename(measure_channel_2_name);
resetMinAndMax();
run("Subtract Background...", "rolling=200");
roiManager("Show All");
roiManager("Deselect");
roiManager("Measure");
selectWindow(measure_channel_2_name);
close();

//Channel 4
selectWindow("C" + toString(measure_channel_3) + "-A");
rename(measure_channel_3_name);
resetMinAndMax();
run("Subtract Background...", "rolling=200");
roiManager("Show All");
roiManager("Deselect");
roiManager("Measure");
selectWindow(measure_channel_3_name);
close();

//Channel 5
selectWindow("C" + toString(measure_channel_4) + "-A");
rename(measure_channel_4_name);
resetMinAndMax();
run("Subtract Background...", "rolling=200");
roiManager("Show All");
roiManager("Deselect");
roiManager("Measure");
selectWindow(measure_channel_4_name);
close();

//Save out ROIs
waitForUser("Choose a directory to save ROIs, then press ok");
dir = getDirectory("Choose a directory to save ROI sets.");
roiManager("Save", dir+name+".zip");

//Save out Measurements as csv
waitForUser("Choose a directory to save measurements, then press ok");
dir = getDirectory("Choose a directory to save measurement results.");
saveAs("Results", dir+name+".csv");

//Close image windows
run("Close All");