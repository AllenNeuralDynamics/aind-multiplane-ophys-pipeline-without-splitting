#!/usr/bin/env nextflow
// hash:sha256:bfe74b9abb626619be713a50f0812650d7a8316997662278b2d8ec686dcef647

nextflow.enable.dsl = 1

params.ophys_mount_url = 's3://aind-private-data-prod-o5171v/multiplane-ophys_731327_2024-09-04_11-25-48'

ophys_mount_to_aind_ophys_motion_correction_1 = channel.fromPath(params.ophys_mount_url + "/*/*platform.json", type: 'any')
ophys_mount_to_aind_ophys_motion_correction_2 = channel.fromPath(params.ophys_mount_url + "/*.json", type: 'any')
ophys_mount_to_aind_ophys_motion_correction_3 = channel.fromPath(params.ophys_mount_url + "/*/*.h5", type: 'any')
ophys_mount_to_aind_ophys_motion_correction_4 = channel.fromPath(params.ophys_mount_url + "/*/MESOSCOPE_FILE*", type: 'any')
ophys_mount_to_aind_ophys_motion_correction_5 = channel.fromPath(params.ophys_mount_url + "/*/V*", type: 'any')
ophys_mount_to_aind_ophys_decrosstalk_split_session_json_6 = channel.fromPath(params.ophys_mount_url + "/session.json", type: 'any')
ophys_mount_to_aind_ophys_decrosstalk_split_session_json_7 = channel.fromPath(params.ophys_mount_url + "/*/MESO*", type: 'any')
capsule_aind_ophys_motion_correction_1_to_capsule_aind_ophys_decrosstalk_split_session_json_2_8 = channel.create()
ophys_mount_to_aind_ophys_decrosstalk_roi_images_9 = channel.fromPath(params.ophys_mount_url + "/*ophys/*MESO*.json", type: 'any')
ophys_mount_to_aind_ophys_decrosstalk_roi_images_10 = channel.fromPath(params.ophys_mount_url + "/pophys/*/V*_[0-9].h5", type: 'any')
ophys_mount_to_aind_ophys_decrosstalk_roi_images_11 = channel.fromPath(params.ophys_mount_url + "/session.json", type: 'any')
capsule_aind_ophys_decrosstalk_split_session_json_2_to_capsule_aind_ophys_decrosstalk_roi_images_3_12 = channel.create()
capsule_aind_ophys_motion_correction_1_to_capsule_aind_ophys_decrosstalk_roi_images_3_13 = channel.create()
capsule_aind_ophys_decrosstalk_roi_images_3_to_capsule_aind_ophys_extraction_suite_2_p_4_14 = channel.create()
ophys_mount_to_aind_ophys_extraction_suite2p_15 = channel.fromPath(params.ophys_mount_url + "/data_description.json", type: 'any')
ophys_mount_to_aind_ophys_extraction_suite2p_16 = channel.fromPath(params.ophys_mount_url + "/session.json", type: 'any')
capsule_aind_ophys_extraction_suite_2_p_4_to_capsule_aind_ophys_dff_5_17 = channel.create()
capsule_aind_ophys_dff_5_to_capsule_aind_ophys_oasis_event_detection_8_18 = channel.create()
ophys_mount_to_processing_json_aggregator_19 = channel.fromPath(params.ophys_mount_url + "/*.json", type: 'any')
capsule_aind_ophys_oasis_event_detection_8_to_capsule_processingjsonaggregator_9_20 = channel.create()
ophys_mount_to_nwb_packaging_subject_capsule_21 = channel.fromPath(params.ophys_mount_url + "/", type: 'any')
ophys_mount_to_aind_ophys_nwb_22 = channel.fromPath(params.ophys_mount_url + "/", type: 'any')
capsule_aind_ophys_oasis_event_detection_8_to_capsule_aind_ophys_nwb_11_23 = channel.create()
capsule_aind_ophys_dff_5_to_capsule_aind_ophys_nwb_11_24 = channel.create()
capsule_aind_ophys_extraction_suite_2_p_4_to_capsule_aind_ophys_nwb_11_25 = channel.create()
capsule_aind_ophys_extraction_suite_2_p_4_to_capsule_aind_ophys_nwb_11_26 = channel.create()
capsule_aind_ophys_decrosstalk_roi_images_3_to_capsule_aind_ophys_nwb_11_27 = channel.create()
capsule_aind_ophys_motion_correction_1_to_capsule_aind_ophys_nwb_11_28 = channel.create()
capsule_aind_ophys_motion_correction_1_to_capsule_aind_ophys_nwb_11_29 = channel.create()
capsule_aind_ophys_motion_correction_1_to_capsule_aind_ophys_nwb_11_30 = channel.create()
capsule_aind_ophys_motion_correction_1_to_capsule_aind_ophys_nwb_11_31 = channel.create()
capsule_nwb_packaging_subject_capsule_10_to_capsule_aind_ophys_nwb_11_32 = channel.create()

// capsule - aind-ophys-motion-correction
process capsule_aind_ophys_motion_correction_1 {
	tag 'capsule-7474660'
	container "$REGISTRY_HOST/published/91a8ed4d-3b9a-49c6-9283-3f16ea5482bf:v11"

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
	path 'capsule/results/*' into capsule_aind_ophys_motion_correction_1_to_capsule_aind_ophys_decrosstalk_split_session_json_2_8
	path 'capsule/results/*' into capsule_aind_ophys_motion_correction_1_to_capsule_aind_ophys_decrosstalk_roi_images_3_13
	path 'capsule/results/*/motion_correction/*.png' into capsule_aind_ophys_motion_correction_1_to_capsule_aind_ophys_nwb_11_28
	path 'capsule/results/*/motion_correction/*.csv' into capsule_aind_ophys_motion_correction_1_to_capsule_aind_ophys_nwb_11_29
	path 'capsule/results/*/motion_correction/*.webm' into capsule_aind_ophys_motion_correction_1_to_capsule_aind_ophys_nwb_11_30
	path 'capsule/results/*/motion_correction/*.h5' into capsule_aind_ophys_motion_correction_1_to_capsule_aind_ophys_nwb_11_31

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=91a8ed4d-3b9a-49c6-9283-3f16ea5482bf
	export CO_CPUS=16
	export CO_MEMORY=137438953472

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone --branch v11.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-7474660.git" capsule-repo
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_aind_ophys_motion_correction_1_args}

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
	path 'capsule/data/' from capsule_aind_ophys_motion_correction_1_to_capsule_aind_ophys_decrosstalk_split_session_json_2_8.collect()

	output:
	path 'capsule/results/*' into capsule_aind_ophys_decrosstalk_split_session_json_2_to_capsule_aind_ophys_decrosstalk_roi_images_3_12

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
process capsule_aind_ophys_decrosstalk_roi_images_3 {
	tag 'capsule-1533578'
	container "$REGISTRY_HOST/published/1383b25a-ecd2-4c56-8b7f-cde811c0b053:v6"

	cpus 16
	memory '128 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from ophys_mount_to_aind_ophys_decrosstalk_roi_images_9.collect()
	path 'capsule/data/' from ophys_mount_to_aind_ophys_decrosstalk_roi_images_10.collect()
	path 'capsule/data/' from ophys_mount_to_aind_ophys_decrosstalk_roi_images_11.collect()
	path 'capsule/data/' from capsule_aind_ophys_decrosstalk_split_session_json_2_to_capsule_aind_ophys_decrosstalk_roi_images_3_12.flatten()
	path 'capsule/data/' from capsule_aind_ophys_motion_correction_1_to_capsule_aind_ophys_decrosstalk_roi_images_3_13.collect()

	output:
	path 'capsule/results/*'
	path 'capsule/results/*' into capsule_aind_ophys_decrosstalk_roi_images_3_to_capsule_aind_ophys_extraction_suite_2_p_4_14
	path 'capsule/results/*/decrosstalk/*.h5' into capsule_aind_ophys_decrosstalk_roi_images_3_to_capsule_aind_ophys_nwb_11_27

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=1383b25a-ecd2-4c56-8b7f-cde811c0b053
	export CO_CPUS=16
	export CO_MEMORY=137438953472

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone --branch v6.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-1533578.git" capsule-repo
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-ophys-extraction-suite2p
process capsule_aind_ophys_extraction_suite_2_p_4 {
	tag 'capsule-9911715'
	container "$REGISTRY_HOST/published/5e1d659c-e149-4a57-be83-12f5a448a0c9:v5"

	cpus 4
	memory '240 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from capsule_aind_ophys_decrosstalk_roi_images_3_to_capsule_aind_ophys_extraction_suite_2_p_4_14.flatten()
	path 'capsule/data/' from ophys_mount_to_aind_ophys_extraction_suite2p_15.collect()
	path 'capsule/data/' from ophys_mount_to_aind_ophys_extraction_suite2p_16.collect()

	output:
	path 'capsule/results/*'
	path 'capsule/results/*' into capsule_aind_ophys_extraction_suite_2_p_4_to_capsule_aind_ophys_dff_5_17
	path 'capsule/results/*/extraction/*.h5' into capsule_aind_ophys_extraction_suite_2_p_4_to_capsule_aind_ophys_nwb_11_25
	path 'capsule/results/*/extraction/*.png' into capsule_aind_ophys_extraction_suite_2_p_4_to_capsule_aind_ophys_nwb_11_26

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=5e1d659c-e149-4a57-be83-12f5a448a0c9
	export CO_CPUS=4
	export CO_MEMORY=257698037760

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone --branch v5.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-9911715.git" capsule-repo
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_aind_ophys_extraction_suite_2_p_4_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-ophys-dff
process capsule_aind_ophys_dff_5 {
	tag 'capsule-6574773'
	container "$REGISTRY_HOST/published/85987e27-601c-4863-811b-71e5b4bdea37:v3"

	cpus 2
	memory '16 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from capsule_aind_ophys_extraction_suite_2_p_4_to_capsule_aind_ophys_dff_5_17

	output:
	path 'capsule/results/*'
	path 'capsule/results/*' into capsule_aind_ophys_dff_5_to_capsule_aind_ophys_oasis_event_detection_8_18
	path 'capsule/results/*/dff/*.h5' into capsule_aind_ophys_dff_5_to_capsule_aind_ophys_nwb_11_24

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
	git clone --branch v3.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-6574773.git" capsule-repo
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
	container "$REGISTRY_HOST/published/c6394aab-0db7-47b2-90ba-864866d6755e:v4"

	cpus 4
	memory '32 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from capsule_aind_ophys_dff_5_to_capsule_aind_ophys_oasis_event_detection_8_18

	output:
	path 'capsule/results/*'
	path 'capsule/results/*' into capsule_aind_ophys_oasis_event_detection_8_to_capsule_processingjsonaggregator_9_20
	path 'capsule/results/*/events/*.h5' into capsule_aind_ophys_oasis_event_detection_8_to_capsule_aind_ophys_nwb_11_23

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
	git clone --branch v4.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-8957649.git" capsule-repo
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - Processing json aggregator
process capsule_processingjsonaggregator_9 {
	tag 'capsule-1054292'
	container "$REGISTRY_HOST/published/2fafe85f-e0fa-41a7-b2a6-9ac24b88605d:v8"

	cpus 4
	memory '32 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from ophys_mount_to_processing_json_aggregator_19.collect()
	path 'capsule/data/' from capsule_aind_ophys_oasis_event_detection_8_to_capsule_processingjsonaggregator_9_20.collect()

	output:
	path 'capsule/results/*'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=2fafe85f-e0fa-41a7-b2a6-9ac24b88605d
	export CO_CPUS=4
	export CO_MEMORY=34359738368

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone --branch v8.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-1054292.git" capsule-repo
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
process capsule_nwb_packaging_subject_capsule_10 {
	tag 'capsule-8198603'
	container "$REGISTRY_HOST/published/bdc9f09f-0005-4d09-aaf9-7e82abd93f19:v2"

	cpus 1
	memory '8 GB'

	input:
	path 'capsule/data/ophys_session' from ophys_mount_to_nwb_packaging_subject_capsule_21.collect()

	output:
	path 'capsule/results/*' into capsule_nwb_packaging_subject_capsule_10_to_capsule_aind_ophys_nwb_11_32

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
	git clone --branch v2.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-8198603.git" capsule-repo
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_nwb_packaging_subject_capsule_10_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-ophys-nwb
process capsule_aind_ophys_nwb_11 {
	tag 'capsule-9383700'
	container "$REGISTRY_HOST/published/8c436e95-8607-4752-8e9f-2b62024f9326:v7"

	cpus 1
	memory '8 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/raw' from ophys_mount_to_aind_ophys_nwb_22.collect()
	path 'capsule/data/processed/' from capsule_aind_ophys_oasis_event_detection_8_to_capsule_aind_ophys_nwb_11_23.collect()
	path 'capsule/data/processed/' from capsule_aind_ophys_dff_5_to_capsule_aind_ophys_nwb_11_24.collect()
	path 'capsule/data/processed/' from capsule_aind_ophys_extraction_suite_2_p_4_to_capsule_aind_ophys_nwb_11_25.collect()
	path 'capsule/data/' from capsule_aind_ophys_extraction_suite_2_p_4_to_capsule_aind_ophys_nwb_11_26.collect()
	path 'capsule/data/processed/' from capsule_aind_ophys_decrosstalk_roi_images_3_to_capsule_aind_ophys_nwb_11_27.collect()
	path 'capsule/data/' from capsule_aind_ophys_motion_correction_1_to_capsule_aind_ophys_nwb_11_28.collect()
	path 'capsule/data/' from capsule_aind_ophys_motion_correction_1_to_capsule_aind_ophys_nwb_11_29.collect()
	path 'capsule/data/' from capsule_aind_ophys_motion_correction_1_to_capsule_aind_ophys_nwb_11_30.collect()
	path 'capsule/data/processed/' from capsule_aind_ophys_motion_correction_1_to_capsule_aind_ophys_nwb_11_31.collect()
	path 'capsule/data/nwb/' from capsule_nwb_packaging_subject_capsule_10_to_capsule_aind_ophys_nwb_11_32.collect()

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

	ln -s "/tmp/data/schemas" "capsule/data/schemas" # id: fb4b5cef-4505-4145-b8bd-e41d6863d7a9

	echo "[${task.tag}] cloning git repo..."
	git clone --branch v7.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-9383700.git" capsule-repo
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}
