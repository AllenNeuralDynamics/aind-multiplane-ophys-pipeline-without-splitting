# Multiplane optical physiology processing pipeline


# aind-multiplane-ophys-pipeline

The multiplane-ophys pipeline is a processing pipeline which uses [Suite2p](https://github.com/MouseLand/suite2p) for both motion correction and segmentation. The final outputs of the pipeline are ROI events detected by [OASIS](https://github.com/j-friedrich/OASIS).

This is a [Nextflow](https://www.nextflow.io/) pipeline which runs the following steps:

* [aind-ophys-mesoscope-image-splitter](https://github.com/AllenNeuralDynamics/aind-ophys-mesoscope-image-splitter): Multiplanar imaging sessions requires that the TIFF series acquired on the ScanImage system be de-interleaved. All frames acquired simultaneously are stitched on a single page within the TIFF series and need to be pulled out into their respective planes.

* [aind-ophys-motion-correction](https://github.com/AllenNeuralDynamics/aind-ophys-motion-correction): Suite2p non-rigid motion correction is run on each plane in parallel.

* [aind-ophys-decrosstalk-roi-images](https://github.com/AllenNeuralDynamics/aind-ophys-decrosstalk-roi-images): Removes the ghosting of cells from concurrent plane scans.

* [aind-ophys-extraction-suite2p](https://github.com/AllenNeuralDynamics/aind-ophys-extraction-suite2p): Combination of cellpose and Suite2p cell detection and extraction.

* [aind-ophys-dff](https://github.com/AllenNeuralDynamics/aind-ophys-dff/blob/main/code/run_capsule.py#L116): Uses [aind-ophys-utils](https://github.com/AllenNeuralDynamics/aind-ophys-utils/tree/main) to compute the delta F over F from the fluorescence traces.

* [aind-ophys-oasis-event-detection](https://github.com/AllenNeuralDynamics/aind-ophys-oasis-event-detection): Generates events for each detected ROI using the OASIS library.


# Input

Currently, the pipeline supports the following input data types:

* `aind`: data intgestion used at AIND. The input folder must contain a subdirectory called `pophys` (for planar-ophys) which contains the raw TIFF timeseries. The root directory must contain JSON files following [aind-data-schema](https://github.com/AllenNeuralDynamics/aind-data-schema).

# Output

The output pipeline is saved to the `results` with JSON files following [aind-data-schema](https://github.com/AllenNeuralDynamics/aind-data-schema). Each parallel process will output a folder within the processes field of view (or plane). As the movies go through the processsing pipeline, a JSON file called processing.json gets created and processing data from processing parameters are appended to this file. The final JSON will sit at the root of the `results` folder at the end of processing. 

Tools used to read files in python are h5py, json and csv.

The following folders will be under the field of view directory within the `results` folder:

**`motion_correction`**

* Registered HDF5: motion corrected data are stored as a numpy array under the 'data' key
* Average projection PNG
* Max projection PNG
* Preview of movie WEBM
* Motion transforms CSV


**`decrosstalk`**

All data within the following HDF5 files are stored under the 'data' key as a numpy array.

* Decrosstalked movie (HDF5)
* Decrosstalked episodic mean field of view (HDF5)
* Decrosstalked eposodic mean field of view registered to pair (HDF5)
* Episodic mean field of view of the registered movie (HDF5)

**`extraction`**

* Extraction (HDF5): Datasets include:
 
    * 'traces/roi', the raw trace
    * 'traces/neuropil', neuropil trace
    * 'traces/corrected', corrected trace
    * 'traces/coords', coordinates of ROIs
    * 'traces/data', ROI pixel values

**`dff`**

Contains a dff HDF5 file where the dF/F signals for each ROI are packed into the 'data' key within the dataset. 

**`events`**

The events folder will contain a plots folder where the events trace for each ROI are plotted and saved as a PNG labeled by cell number. The oasis event file is saved as an HDF5 file. The HDF5 contains the following keys:

* 'cell_roi_ids', list of ROI ID values
* 'events', event traces for each ROI


