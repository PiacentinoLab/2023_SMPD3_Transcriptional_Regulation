//Define directories (Hard-Coded):
indir_czi = getDirectory("home")+"Desktop//czi_mips//";
outdir_intensity = getDirectory("home")+"Desktop//csvs_3FOVs_perExplant//";
outdir_rois = getDirectory("home")+"Desktop//rois_3FOVs//";
indir_czi_list = getFileList(indir_czi);

setBatchMode(false);

for(img=0;img<indir_czi_list.length;img++){

	//Close any leftover windows
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

	run("Bio-Formats Windowless Importer", "open=" + indir_czi + indir_czi_list[img]);
	name=File.nameWithoutExtension;
	rename("A");
	print("Processing: " + name);
	Stack.getDimensions(width, height, channels, slices, frames);

	//Define channels to measure and their names
	measure_channel_1 = 1;
	measure_channel_1_name = "H2BRFP";
	measure_channel_2 = channels;
	measure_channel_2_name = "smpd3";
	
	//Define ROIs
	run("Enhance Contrast", "saturated=0.35");
	makeRectangle(0, 0, 550, 550);
	waitForUser("Drag ROI to position 1, then press ok");
	roiManager("Add");
	roiManager("Select",0);
	roiManager("Rename","FOV1");
	roiManager("Show All");
	makeRectangle(0, 0, 550, 550);
	waitForUser("Drag ROI to position 2, then press ok");
	roiManager("Add");
	roiManager("Select",1);
	roiManager("Rename","FOV2");
	makeRectangle(0, 0, 550, 550);
	waitForUser("Drag ROI to position 3, then press ok");
	roiManager("Add");
	roiManager("Select",2);
	roiManager("Rename","FOV3");

	run("Split Channels");
	
	//Measure background then ROI IntDen
	//Channel 1
	selectWindow("C" + toString(measure_channel_1) + "-A");
	rename(measure_channel_1_name);
	resetMinAndMax();
//	run("Median...", "radius=2");
//	run("Subtract Background...", "rolling=200");
	resetMinAndMax();
	roiManager("Show All");
	roiManager("Deselect");
	roiManager("Measure");
//	roiManager("Select", 0);
//	run("Measure");
//	roiManager("Select", 1);
//	run("Measure");
//	roiManager("Select", 2);
//	run("Measure");
		
	//Channel 2
	selectWindow("C" + toString(measure_channel_2) + "-A");
	rename(measure_channel_2_name);
	resetMinAndMax();
//	run("Median...", "radius=2");
//	run("Subtract Background...", "rolling=200");
	resetMinAndMax();
	roiManager("Show All");
	roiManager("Deselect");
	roiManager("Measure");
//	roiManager("Select", 0);
//	run("Measure");
//	roiManager("Select", 1);
//	run("Measure");
//	roiManager("Select", 2);
//	run("Measure");
	
	//Save out Measurements as csv
	saveAs("Results", outdir_intensity+name+".csv");
	roiManager("Save", outdir_rois+name+".zip");
	
	//Close image windows
	run("Close All");

}