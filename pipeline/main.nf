#!/usr/bin/env nextflow
// hash:sha256:0bc05dbbd9d1b2f8aa57d2a71022c4f9a586d672249f9af19c600ebb8bc0624f

nextflow.enable.dsl = 1

params.ophys_mount_url = 's3://aind-private-data-prod-o5171v/multiplane-ophys_731327_2024-09-04_11-25-48'

ophys_mount_to_aind_ophys_motion_correction_1 = channel.fromPath(params.ophys_mount_url + "/*/*platform.json", type: 'any')
ophys_mount_to_aind_ophys_motion_correction_2 = channel.fromPath(params.ophys_mount_url + "/*.json", type: 'any')
ophys_mount_to_aind_ophys_motion_correction_3 = channel.fromPath(params.ophys_mount_url + "/*/*.h5", type: 'any')
ophys_mount_to_aind_ophys_motion_correction_4 = channel.fromPath(params.ophys_mount_url + "/*/MESOSCOPE_FILE*", type: 'any')
ophys_mount_to_aind_ophys_motion_correction_5 = channel.fromPath(params.ophys_mount_url + "/*/V*", type: 'any')
ophys_mount_to_aind_ophys_decrosstalk_split_session_json_6 = channel.fromPath(params.ophys_mount_url + "/session.json", type: 'any')
ophys_mount_to_aind_ophys_decrosstalk_split_session_json_7 = channel.fromPath(params.ophys_mount_url + "/*/MESO*", type: 'any')
capsule_logging_aind_ophys_motion_correction_1_to_capsule_aind_ophys_decrosstalk_split_session_json_2_8 = channel.create()
ophys_mount_to_aind_ophys_decrosstalk_roi_images_9 = channel.fromPath(params.ophys_mount_url + "/*.json", type: 'any')
ophys_mount_to_aind_ophys_decrosstalk_roi_images_10 = channel.fromPath(params.ophys_mount_url + "/pophys/*/V*_[0-9].h5", type: 'any')
capsule_aind_ophys_decrosstalk_split_session_json_2_to_capsule_logging_aind_ophys_decrosstalk_roi_images_3_11 = channel.create()
capsule_logging_aind_ophys_motion_correction_1_to_capsule_logging_aind_ophys_decrosstalk_roi_images_3_12 = channel.create()
ophys_mount_to_aind_ophys_extraction_suite2p_13 = channel.fromPath(params.ophys_mount_url + "/*.json", type: 'any')
capsule_logging_aind_ophys_decrosstalk_roi_images_3_to_capsule_logging_aind_ophys_extraction_suite_2_p_4_14 = channel.create()
ophys_mount_to_logging_aind_ophys_dff_15 = channel.fromPath(params.ophys_mount_url + "/*.json", type: 'any')
capsule_logging_aind_ophys_extraction_suite_2_p_4_to_capsule_logging_aind_ophys_dff_5_16 = channel.create()
ophys_mount_to_aind_ophys_oasis_event_detection_17 = channel.fromPath(params.ophys_mount_url + "/*.json", type: 'any')
capsule_logging_aind_ophys_dff_5_to_capsule_logging_aind_ophys_oasis_event_detection_8_18 = channel.create()
capsule_logging_aind_ophys_dff_5_to_capsule_aind_pipeline_processing_metadata_aggregator_9_19 = channel.create()
capsule_logging_aind_ophys_oasis_event_detection_8_to_capsule_aind_pipeline_processing_metadata_aggregator_9_20 = channel.create()
capsule_logging_aind_ophys_extraction_suite_2_p_4_to_capsule_aind_pipeline_processing_metadata_aggregator_9_21 = channel.create()
capsule_logging_aind_ophys_decrosstalk_roi_images_3_to_capsule_aind_pipeline_processing_metadata_aggregator_9_22 = channel.create()
capsule_logging_aind_ophys_motion_correction_1_to_capsule_aind_pipeline_processing_metadata_aggregator_9_23 = channel.create()
ophys_mount_to_aind_pipeline_processing_metadata_aggregator_24 = channel.fromPath(params.ophys_mount_url + "/*.json", type: 'any')
capsule_logging_aind_ophys_oasis_event_detection_8_to_capsule_aind_ophys_nwb_10_25 = channel.create()
capsule_logging_aind_ophys_dff_5_to_capsule_aind_ophys_nwb_10_26 = channel.create()
capsule_logging_aind_ophys_extraction_suite_2_p_4_to_capsule_aind_ophys_nwb_10_27 = channel.create()
capsule_logging_aind_ophys_decrosstalk_roi_images_3_to_capsule_aind_ophys_nwb_10_28 = channel.create()
capsule_logging_aind_ophys_motion_correction_1_to_capsule_aind_ophys_nwb_10_29 = channel.create()
ophys_mount_to_aind_ophys_nwb_30 = channel.fromPath(params.ophys_mount_url + "/", type: 'any')
capsule_nwb_packaging_subject_11_to_capsule_aind_ophys_nwb_10_31 = channel.create()
capsule_logging_aind_ophys_motion_correction_1_to_capsule_aind_ophys_quality_control_aggregator_12_32 = channel.create()

// capsule - aind-ophys-motion-correction
process capsule_logging_aind_ophys_motion_correction_1 {
	tag 'capsule-8075853'
	container "$REGISTRY_HOST/capsule/9078ac4b-9073-4d3d-bd01-7feef6aa355b"

	cpus 16
	memory '128 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from ophys_mount_to_aind_ophys_motion_correction_1.collect()
	path 'capsule/data/' from ophys_mount_to_aind_ophys_motion_correction_2.collect()
	path 'capsule/data/' from ophys_mount_to_aind_ophys_motion_correction_3.collect()
	path 'capsule/data/' from ophys_mount_to_aind_ophys_motion_correction_4.collect()
	path 'capsule/data/' from ophys_mount_to_aind_ophys_motion_correction_5

	output:
	path 'capsule/results/*'
	path 'capsule/results/*' into capsule_logging_aind_ophys_motion_correction_1_to_capsule_aind_ophys_decrosstalk_split_session_json_2_8
	path 'capsule/results/*' into capsule_logging_aind_ophys_motion_correction_1_to_capsule_logging_aind_ophys_decrosstalk_roi_images_3_12
	path 'capsule/results/*/*/*data_process.json' into capsule_logging_aind_ophys_motion_correction_1_to_capsule_aind_pipeline_processing_metadata_aggregator_9_23
	path 'capsule/results/*/motion_correction/*.h5' into capsule_logging_aind_ophys_motion_correction_1_to_capsule_aind_ophys_nwb_10_29
	path 'capsule/results/*/motion_correction/*' into capsule_logging_aind_ophys_motion_correction_1_to_capsule_aind_ophys_quality_control_aggregator_12_32

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=9078ac4b-9073-4d3d-bd01-7feef6aa355b
	export CO_CPUS=16
	export CO_MEMORY=137438953472

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-8075853.git" capsule-repo
	git -C capsule-repo checkout 732d5932b44526270fb2886b90db46fa0d3d265d --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run --debug

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-ophys-decrosstalk-split-session-json
process capsule_aind_ophys_decrosstalk_split_session_json_2 {
	tag 'capsule-4425001'
	container "$REGISTRY_HOST/published/fc1b1e9a-fb4b-47e8-a223-b06d8eeb1462:v1"

	cpus 1
	memory '8 GB'

	input:
	path 'capsule/data/' from ophys_mount_to_aind_ophys_decrosstalk_split_session_json_6.collect()
	path 'capsule/data/' from ophys_mount_to_aind_ophys_decrosstalk_split_session_json_7.collect()
	path 'capsule/data/' from capsule_logging_aind_ophys_motion_correction_1_to_capsule_aind_ophys_decrosstalk_split_session_json_2_8.collect()

	output:
	path 'capsule/results/*' into capsule_aind_ophys_decrosstalk_split_session_json_2_to_capsule_logging_aind_ophys_decrosstalk_roi_images_3_11

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=fc1b1e9a-fb4b-47e8-a223-b06d8eeb1462
	export CO_CPUS=1
	export CO_MEMORY=8589934592

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone --branch v1.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-4425001.git" capsule-repo
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-ophys-decrosstalk-roi-images
process capsule_logging_aind_ophys_decrosstalk_roi_images_3 {
	tag 'capsule-6343030'
	container "$REGISTRY_HOST/capsule/1c537182-e732-42d3-b5c3-5c320e7df4b1"

	cpus 16
	memory '128 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from ophys_mount_to_aind_ophys_decrosstalk_roi_images_9.collect()
	path 'capsule/data/' from ophys_mount_to_aind_ophys_decrosstalk_roi_images_10.collect()
	path 'capsule/data/' from capsule_aind_ophys_decrosstalk_split_session_json_2_to_capsule_logging_aind_ophys_decrosstalk_roi_images_3_11.flatten()
	path 'capsule/data/' from capsule_logging_aind_ophys_motion_correction_1_to_capsule_logging_aind_ophys_decrosstalk_roi_images_3_12.collect()

	output:
	path 'capsule/results/*'
	path 'capsule/results/*' into capsule_logging_aind_ophys_decrosstalk_roi_images_3_to_capsule_logging_aind_ophys_extraction_suite_2_p_4_14
	path 'capsule/results/*/*/*data_process.json' into capsule_logging_aind_ophys_decrosstalk_roi_images_3_to_capsule_aind_pipeline_processing_metadata_aggregator_9_22
	path 'capsule/results/*/decrosstalk/*.h5' into capsule_logging_aind_ophys_decrosstalk_roi_images_3_to_capsule_aind_ophys_nwb_10_28

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=1c537182-e732-42d3-b5c3-5c320e7df4b1
	export CO_CPUS=16
	export CO_MEMORY=137438953472

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-6343030.git" capsule-repo
	git -C capsule-repo checkout 7236228afe44e55bc0075b42392173e22e33362a --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run --debug

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-ophys-extraction-suite2p
process capsule_logging_aind_ophys_extraction_suite_2_p_4 {
	tag 'capsule-5021297'
	container "$REGISTRY_HOST/capsule/d4a61cb3-c0ff-4df5-afb5-fdd27705ae17"

	cpus 4
	memory '240 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from ophys_mount_to_aind_ophys_extraction_suite2p_13.collect()
	path 'capsule/data/' from capsule_logging_aind_ophys_decrosstalk_roi_images_3_to_capsule_logging_aind_ophys_extraction_suite_2_p_4_14.flatten()

	output:
	path 'capsule/results/*'
	path 'capsule/results/*' into capsule_logging_aind_ophys_extraction_suite_2_p_4_to_capsule_logging_aind_ophys_dff_5_16
	path 'capsule/results/*/*/*data_process.json' into capsule_logging_aind_ophys_extraction_suite_2_p_4_to_capsule_aind_pipeline_processing_metadata_aggregator_9_21
	path 'capsule/results/*/extraction/*.h5' into capsule_logging_aind_ophys_extraction_suite_2_p_4_to_capsule_aind_ophys_nwb_10_27

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=d4a61cb3-c0ff-4df5-afb5-fdd27705ae17
	export CO_CPUS=4
	export CO_MEMORY=257698037760

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-5021297.git" capsule-repo
	git -C capsule-repo checkout 03385735db54cad4cd95e55b3accfeb5088e6c02 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - LOGGING aind-ophys-dff
process capsule_logging_aind_ophys_dff_5 {
	tag 'capsule-4898929'
	container "$REGISTRY_HOST/capsule/f6cea6eb-ab57-45a3-81c6-c12acea8cd52"

	cpus 2
	memory '16 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from ophys_mount_to_logging_aind_ophys_dff_15.collect()
	path 'capsule/data/' from capsule_logging_aind_ophys_extraction_suite_2_p_4_to_capsule_logging_aind_ophys_dff_5_16

	output:
	path 'capsule/results/*'
	path 'capsule/results/*' into capsule_logging_aind_ophys_dff_5_to_capsule_logging_aind_ophys_oasis_event_detection_8_18
	path 'capsule/results/*/*/*data_process.json' into capsule_logging_aind_ophys_dff_5_to_capsule_aind_pipeline_processing_metadata_aggregator_9_19
	path 'capsule/results/*/dff/*.h5' into capsule_logging_aind_ophys_dff_5_to_capsule_aind_ophys_nwb_10_26

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=f6cea6eb-ab57-45a3-81c6-c12acea8cd52
	export CO_CPUS=2
	export CO_MEMORY=17179869184

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-4898929.git" capsule-repo
	git -C capsule-repo checkout f2c649c8d49c4205bb088f82f3906105dbe87fb7 --quiet
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
process capsule_logging_aind_ophys_oasis_event_detection_8 {
	tag 'capsule-9367816'
	container "$REGISTRY_HOST/capsule/d85189da-954d-45f4-b76c-98a70fa4955d"

	cpus 4
	memory '32 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from ophys_mount_to_aind_ophys_oasis_event_detection_17.collect()
	path 'capsule/data/' from capsule_logging_aind_ophys_dff_5_to_capsule_logging_aind_ophys_oasis_event_detection_8_18

	output:
	path 'capsule/results/*'
	path 'capsule/results/*/*/*data_process.json' into capsule_logging_aind_ophys_oasis_event_detection_8_to_capsule_aind_pipeline_processing_metadata_aggregator_9_20
	path 'capsule/results/*/events/*.h5' into capsule_logging_aind_ophys_oasis_event_detection_8_to_capsule_aind_ophys_nwb_10_25

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=d85189da-954d-45f4-b76c-98a70fa4955d
	export CO_CPUS=4
	export CO_MEMORY=34359738368

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-9367816.git" capsule-repo
	git -C capsule-repo checkout c5c670bcf2e7864b06227964b58ac8e663188acb --quiet
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
	container "$REGISTRY_HOST/published/d51df783-d892-4304-a129-238a9baea72a:v2"

	cpus 4
	memory '32 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from capsule_logging_aind_ophys_dff_5_to_capsule_aind_pipeline_processing_metadata_aggregator_9_19.collect()
	path 'capsule/data/' from capsule_logging_aind_ophys_oasis_event_detection_8_to_capsule_aind_pipeline_processing_metadata_aggregator_9_20.collect()
	path 'capsule/data/' from capsule_logging_aind_ophys_extraction_suite_2_p_4_to_capsule_aind_pipeline_processing_metadata_aggregator_9_21.collect()
	path 'capsule/data/' from capsule_logging_aind_ophys_decrosstalk_roi_images_3_to_capsule_aind_pipeline_processing_metadata_aggregator_9_22.collect()
	path 'capsule/data/' from capsule_logging_aind_ophys_motion_correction_1_to_capsule_aind_pipeline_processing_metadata_aggregator_9_23.collect()
	path 'capsule/data/' from ophys_mount_to_aind_pipeline_processing_metadata_aggregator_24.collect()

	output:
	path 'capsule/results/*'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=d51df783-d892-4304-a129-238a9baea72a
	export CO_CPUS=4
	export CO_MEMORY=34359738368

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone --branch v2.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-8250608.git" capsule-repo
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_aind_pipeline_processing_metadata_aggregator_9_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-ophys-nwb
process capsule_aind_ophys_nwb_10 {
	tag 'capsule-9383700'
	container "$REGISTRY_HOST/published/8c436e95-8607-4752-8e9f-2b62024f9326:v8"

	cpus 1
	memory '8 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/processed/' from capsule_logging_aind_ophys_oasis_event_detection_8_to_capsule_aind_ophys_nwb_10_25.collect()
	path 'capsule/data/processed/' from capsule_logging_aind_ophys_dff_5_to_capsule_aind_ophys_nwb_10_26.collect()
	path 'capsule/data/processed/' from capsule_logging_aind_ophys_extraction_suite_2_p_4_to_capsule_aind_ophys_nwb_10_27.collect()
	path 'capsule/data/processed/' from capsule_logging_aind_ophys_decrosstalk_roi_images_3_to_capsule_aind_ophys_nwb_10_28.collect()
	path 'capsule/data/processed/' from capsule_logging_aind_ophys_motion_correction_1_to_capsule_aind_ophys_nwb_10_29.collect()
	path 'capsule/data/multiplane-ophys_raw' from ophys_mount_to_aind_ophys_nwb_30.collect()
	path 'capsule/data/nwb/' from capsule_nwb_packaging_subject_11_to_capsule_aind_ophys_nwb_10_31.collect()

	output:
	path 'capsule/results/*'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=8c436e95-8607-4752-8e9f-2b62024f9326
	export CO_CPUS=1
	export CO_MEMORY=8589934592

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone --branch v8.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-9383700.git" capsule-repo
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - NWB-Packaging-Subject-Capsule
process capsule_nwb_packaging_subject_11 {
	tag 'capsule-8198603'
	container "$REGISTRY_HOST/published/bdc9f09f-0005-4d09-aaf9-7e82abd93f19:v2"

	cpus 1
	memory '8 GB'

	output:
	path 'capsule/results/*' into capsule_nwb_packaging_subject_11_to_capsule_aind_ophys_nwb_10_31

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

	ln -s "/tmp/data/schemas" "capsule/data/schemas" # id: fb4b5cef-4505-4145-b8bd-e41d6863d7a9

	echo "[${task.tag}] cloning git repo..."
	git clone --branch v2.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-8198603.git" capsule-repo
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_nwb_packaging_subject_11_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-ophys-quality-control-aggregator
process capsule_aind_ophys_quality_control_aggregator_12 {
	tag 'capsule-4691390'
	container "$REGISTRY_HOST/capsule/05b8a796-f8c7-4177-b486-82abfc146e49"

	cpus 1
	memory '8 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from capsule_logging_aind_ophys_motion_correction_1_to_capsule_aind_ophys_quality_control_aggregator_12_32.collect()

	output:
	path 'capsule/results/*'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=05b8a796-f8c7-4177-b486-82abfc146e49
	export CO_CPUS=1
	export CO_MEMORY=8589934592

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-4691390.git" capsule-repo
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}
