#!/usr/bin/env nextflow
// hash:sha256:a87515d3bf0de387dc4ffb038a952357fa1a26591f891fc3dec648b6a1ec573b

nextflow.enable.dsl = 1

params.multiplane_ophys_test_asset_results_url = 's3://aind-scratch-data/pipeline-test-assets/multiplane-ophys-test-asset_results'
params.multiplane_ophys_test_asset_url = 's3://aind-scratch-data/pipeline-test-assets/multiplane-ophys-test-asset'

multiplane_ophys_test_asset_results_to_aind_ophys_extraction_1 = channel.fromPath(params.multiplane_ophys_test_asset_results_url + "/V*/decrosstalk/*decrosstalk.h5", type: 'any')
multiplane_ophys_test_asset_to_aind_ophys_extraction_2 = channel.fromPath(params.multiplane_ophys_test_asset_url + "/*.json", type: 'any')
multiplane_ophys_test_asset_to_aind_ophys_dff_3 = channel.fromPath(params.multiplane_ophys_test_asset_url + "/*.json", type: 'any')
capsule_aind_ophys_extraction_4_to_capsule_aind_ophys_dff_5_4 = channel.create()
multiplane_ophys_test_asset_to_aind_ophys_oasis_event_detection_5 = channel.fromPath(params.multiplane_ophys_test_asset_url + "/*.json", type: 'any')
capsule_aind_ophys_dff_5_to_capsule_aind_ophys_oasis_event_detection_8_6 = channel.create()
capsule_aind_ophys_dff_5_to_capsule_aind_pipeline_processing_metadata_aggregator_9_7 = channel.create()
capsule_aind_ophys_oasis_event_detection_8_to_capsule_aind_pipeline_processing_metadata_aggregator_9_8 = channel.create()
capsule_aind_ophys_extraction_4_to_capsule_aind_pipeline_processing_metadata_aggregator_9_9 = channel.create()
multiplane_ophys_test_asset_to_aind_pipeline_processing_metadata_aggregator_10 = channel.fromPath(params.multiplane_ophys_test_asset_url + "/*.json", type: 'any')
multiplane_ophys_test_asset_results_to_aind_ophys_nwb_with_segmentation_masks_from_rois_11 = channel.fromPath(params.multiplane_ophys_test_asset_results_url + "/*/decrosstalk/*.h5", type: 'any')
multiplane_ophys_test_asset_results_to_aind_ophys_nwb_with_segmentation_masks_from_rois_12 = channel.fromPath(params.multiplane_ophys_test_asset_results_url + "/*/motion_correction/*.png", type: 'any')
capsule_aind_ophys_dff_5_to_capsule_aind_ophys_nwb_with_segmentation_masks_from_rois_10_13 = channel.create()
capsule_aind_ophys_extraction_4_to_capsule_aind_ophys_nwb_with_segmentation_masks_from_rois_10_14 = channel.create()
capsule_aind_ophys_oasis_event_detection_8_to_capsule_aind_ophys_nwb_with_segmentation_masks_from_rois_10_15 = channel.create()
multiplane_ophys_test_asset_to_aind_ophys_nwb_with_segmentation_masks_from_rois_16 = channel.fromPath(params.multiplane_ophys_test_asset_url + "/", type: 'any')
capsule_nwb_packaging_subject_11_to_capsule_aind_ophys_nwb_with_segmentation_masks_from_rois_10_17 = channel.create()
multiplane_ophys_test_asset_to_nwb_packaging_subject_18 = channel.fromPath(params.multiplane_ophys_test_asset_url + "/", type: 'any')

// capsule - aind-ophys-extraction
process capsule_aind_ophys_extraction_4 {
	tag 'capsule-5845047'
	container "$REGISTRY_HOST/capsule/13ac4e60-60c3-4fd5-87a5-84b212ef661b:66f0ee9a5f37824a456b40266a4f8e5d"

	cpus 4
	memory '240 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from multiplane_ophys_test_asset_results_to_aind_ophys_extraction_1
	path 'capsule/data/' from multiplane_ophys_test_asset_to_aind_ophys_extraction_2.collect()

	output:
	path 'capsule/results/*'
	path 'capsule/results/*' into capsule_aind_ophys_extraction_4_to_capsule_aind_ophys_dff_5_4
	path 'capsule/results/*/*/*data_process.json' into capsule_aind_ophys_extraction_4_to_capsule_aind_pipeline_processing_metadata_aggregator_9_9
	path 'capsule/results/*/extraction/*.h5' into capsule_aind_ophys_extraction_4_to_capsule_aind_ophys_nwb_with_segmentation_masks_from_rois_10_14

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=13ac4e60-60c3-4fd5-87a5-84b212ef661b
	export CO_CPUS=4
	export CO_MEMORY=257698037760

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-5845047.git" capsule-repo
	git -C capsule-repo checkout 5edcf59f85003c7b17b5f34e85461013837982dd --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run --init corr_pnr --diameter 16 --neuropil cnmf-e --min_corr .6 --min_pnr 4 --merge_thr 0.7 --cnn_thr 0

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-ophys-dff
process capsule_aind_ophys_dff_5 {
	tag 'capsule-6574773'
	container "$REGISTRY_HOST/published/85987e27-601c-4863-811b-71e5b4bdea37:v4"

	cpus 2
	memory '16 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from multiplane_ophys_test_asset_to_aind_ophys_dff_3.collect()
	path 'capsule/data/' from capsule_aind_ophys_extraction_4_to_capsule_aind_ophys_dff_5_4

	output:
	path 'capsule/results/*'
	path 'capsule/results/*' into capsule_aind_ophys_dff_5_to_capsule_aind_ophys_oasis_event_detection_8_6
	path 'capsule/results/*/*/*data_process.json' into capsule_aind_ophys_dff_5_to_capsule_aind_pipeline_processing_metadata_aggregator_9_7
	path 'capsule/results/*/dff/*.h5' into capsule_aind_ophys_dff_5_to_capsule_aind_ophys_nwb_with_segmentation_masks_from_rois_10_13

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=85987e27-601c-4863-811b-71e5b4bdea37
	export CO_CPUS=2
	export CO_MEMORY=17179869184

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone --branch v4.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-6574773.git" capsule-repo
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-ophys-oasis-event-detection
process capsule_aind_ophys_oasis_event_detection_8 {
	tag 'capsule-8957649'
	container "$REGISTRY_HOST/published/c6394aab-0db7-47b2-90ba-864866d6755e:v6"

	cpus 4
	memory '32 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from multiplane_ophys_test_asset_to_aind_ophys_oasis_event_detection_5.collect()
	path 'capsule/data/' from capsule_aind_ophys_dff_5_to_capsule_aind_ophys_oasis_event_detection_8_6

	output:
	path 'capsule/results/*'
	path 'capsule/results/*/*/*data_process.json' into capsule_aind_ophys_oasis_event_detection_8_to_capsule_aind_pipeline_processing_metadata_aggregator_9_8
	path 'capsule/results/*/events/*.h5' into capsule_aind_ophys_oasis_event_detection_8_to_capsule_aind_ophys_nwb_with_segmentation_masks_from_rois_10_15

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=c6394aab-0db7-47b2-90ba-864866d6755e
	export CO_CPUS=4
	export CO_MEMORY=34359738368

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone --branch v6.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-8957649.git" capsule-repo
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-pipeline-processing-metadata-aggregator
process capsule_aind_pipeline_processing_metadata_aggregator_9 {
	tag 'capsule-8250608'
	container "$REGISTRY_HOST/published/d51df783-d892-4304-a129-238a9baea72a:v3"

	cpus 1
	memory '8 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from capsule_aind_ophys_dff_5_to_capsule_aind_pipeline_processing_metadata_aggregator_9_7.collect()
	path 'capsule/data/' from capsule_aind_ophys_oasis_event_detection_8_to_capsule_aind_pipeline_processing_metadata_aggregator_9_8.collect()
	path 'capsule/data/' from capsule_aind_ophys_extraction_4_to_capsule_aind_pipeline_processing_metadata_aggregator_9_9.collect()
	path 'capsule/data/' from multiplane_ophys_test_asset_to_aind_pipeline_processing_metadata_aggregator_10.collect()

	output:
	path 'capsule/results/*'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=d51df783-d892-4304-a129-238a9baea72a
	export CO_CPUS=1
	export CO_MEMORY=8589934592

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone --branch v3.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-8250608.git" capsule-repo
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run --processor_full_name "Arielle Leon" --copy-ancillary-files True

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-ophys-nwb with segmentation_masks from ROIs
process capsule_aind_ophys_nwb_with_segmentation_masks_from_rois_10 {
	tag 'capsule-0451644'
	container "$REGISTRY_HOST/capsule/417df268-7471-4275-9739-3408ff07805b:337ca81d3eed378e1d2474a171996ee4"

	cpus 1
	memory '8 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/processed/' from multiplane_ophys_test_asset_results_to_aind_ophys_nwb_with_segmentation_masks_from_rois_11.collect()
	path 'capsule/data/processed/' from multiplane_ophys_test_asset_results_to_aind_ophys_nwb_with_segmentation_masks_from_rois_12.collect()
	path 'capsule/data/processed/' from capsule_aind_ophys_dff_5_to_capsule_aind_ophys_nwb_with_segmentation_masks_from_rois_10_13.collect()
	path 'capsule/data/processed/' from capsule_aind_ophys_extraction_4_to_capsule_aind_ophys_nwb_with_segmentation_masks_from_rois_10_14.collect()
	path 'capsule/data/processed/' from capsule_aind_ophys_oasis_event_detection_8_to_capsule_aind_ophys_nwb_with_segmentation_masks_from_rois_10_15.collect()
	path 'capsule/data/multiplane-ophys_raw' from multiplane_ophys_test_asset_to_aind_ophys_nwb_with_segmentation_masks_from_rois_16.collect()
	path 'capsule/data/nwb/' from capsule_nwb_packaging_subject_11_to_capsule_aind_ophys_nwb_with_segmentation_masks_from_rois_10_17.collect()

	output:
	path 'capsule/results/*'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=417df268-7471-4275-9739-3408ff07805b
	export CO_CPUS=1
	export CO_MEMORY=8589934592

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	ln -s "/tmp/data/schemas" "capsule/data/schemas" # id: fb4b5cef-4505-4145-b8bd-e41d6863d7a9

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-0451644.git" capsule-repo
	git -C capsule-repo checkout b894f2b91839690137ccdba48556601f05976ca4 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - NWB Packaging Subject
process capsule_nwb_packaging_subject_11 {
	tag 'capsule-8198603'
	container "$REGISTRY_HOST/published/bdc9f09f-0005-4d09-aaf9-7e82abd93f19:v3"

	cpus 1
	memory '8 GB'

	input:
	path 'capsule/data/ophys_session' from multiplane_ophys_test_asset_to_nwb_packaging_subject_18.collect()

	output:
	path 'capsule/results/*' into capsule_nwb_packaging_subject_11_to_capsule_aind_ophys_nwb_with_segmentation_masks_from_rois_10_17

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=bdc9f09f-0005-4d09-aaf9-7e82abd93f19
	export CO_CPUS=1
	export CO_MEMORY=8589934592

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone --branch v3.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-8198603.git" capsule-repo
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_nwb_packaging_subject_11_args}

	echo "[${task.tag}] completed!"
	"""
}
