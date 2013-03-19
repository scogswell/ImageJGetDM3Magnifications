// This macro scours a directory and all subdirectories from a chosen root, and 
// extracts the indicated microscope magnification for all DM3 (gatan format) files 
// contained within.  It then presents a summary table of magnifications which can be 
// saved as a CSV file or text.
//
// Steven Cogswell, P.Eng.
// April 2012. 
// 
setBatchMode(true); 
showMessage("Determine DM3 Magnifications", "This Macro makes a report of all the magnifications of DM3 files in a directory");

// Some of this is adapted from http://rsbweb.nih.gov/ij/macros/ListFilesRecursively.txt  
dir = getDirectory("Choose a Directory");
count = 1;
listFiles(dir); 
updateResults(); 
// End of macro. 

function listFiles(dir) {
     list = getFileList(dir);
     for (i=0; i<list.length; i++) {
        showProgress(i/list.length);  
        if (endsWith(list[i], "/"))
           listFiles(""+dir+list[i]);    // Recusive through all subdirectories
        else
           //print((count++) + ": " + dir + list[i]);
	if(endsWith(list[i],".dm3")) {    // Only open DM3 files 
		open(dir+list[i]); 
		printMag();   // Determine microscope indicated mag from DM3 file 
		close();
	}
     }
  }
		
// Function to determine the indicated magnification from a DM3 file, and put result into a table
//
function printMag() {

	thename = getInfo("image.filename");    // Name of image	
	theinfo = getImageInfo();   // Info containing all the Gatan DM3 tags
	index = indexOf(theinfo, "Indicated Magnification =");   // After this in the text is the mag value
	index2 = indexOf(theinfo, "\n", index);     // This is the end of that line 
	themag = substring(theinfo,index+25,index2);    // So this is the mag value between "=" and "\n"
	row=nResults;  // Current row in the results table 
	setResult("Microscope Magnfication",row,themag);    
	setResult("Label",row,thename); 
	//print(thename,"Magnification",themag); 
}
