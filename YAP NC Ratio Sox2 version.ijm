//INITIAL HOUSEKEEPING
	//set measurements to average intensity
		run("Set Measurements...", "mean redirect=None decimal=3");
	//clear results
		run("Clear Results");
	
//IMAGE ANALYSIS
	//open image with Actin, Sox2, YAP, Hoechst in channels 1-4

	//rename image to "raw" and split channels
		rename("raw");
		run("Split Channels");

	//generate cytoplasm mask by Otsu threshold of Actin
		selectWindow("C1-raw");
		run("OtsuThresholding 16Bit");
		run("Create Mask");
		rename("C1-Actin Mask");

	//generate nuclear mask by Otsu threshold of Sox2
		selectWindow("C2-raw");
		run("OtsuThresholding 16Bit");
		run("Create Mask");
		rename("C2-Sox2 Mask");

	//remove Sox2-high pixels from Cytoplasm Mask
		imageCalculator("Subtract create", "C1-Actin Mask","C2-Sox2 Mask");
		selectWindow("Result of C1-Actin Mask");
		rename("C1-Actin Mask Adjusted");

	//remove Actin-high pixels from Nuclear Mask
		imageCalculator("Subtract create", "C2-Sox2 Mask","C1-Actin Mask");
		selectWindow("Result of C2-Sox2 Mask");
		rename("C2-Sox2 Mask Adjusted");

	//create ROI selection of nuclear mask and apply to YAP channel
		run("Invert");
		run("Create Selection");
		selectWindow("C3-raw");
		run("Restore Selection");
		roiManager("Add");
		roiManager("Select", 0);
		roiManager("Rename", "Nuclei");

	//create ROI selection of cytoplasm mask and apply to YAP channel
		selectWindow("C1-Actin Mask Adjusted");
		run("Invert");
		run("Create Selection");
		selectWindow("C3-raw");
		run("Restore Selection");
		roiManager("Add");
		roiManager("Select", 1);
		roiManager("Rename", "Cytoplasm");

	//measure ROI of nuclear and cytoplasmic YAP intensity, respectively
		roiManager("Select", newArray(0,1));
		roiManager("Measure");
		String.copyResults();

	//close windows
	close();
close();
close();
close();
close();
close();
close();
selectWindow("C4-raw");
close();
	//run("Close");

		//clear ROIs?
		roiManager("Deselect");
		roiManager("Delete");