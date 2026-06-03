#!/usr/bin/env nextflow
// hash:sha256:c0ffc0fe6ebb889013e5b5bbe8d154ed43cb83fcb0af35f6f6b4934640c1ecd3

nextflow.enable.dsl = 1

params.multiplane_ophys_test_asset_results_url = 's3://aind-scratch-data/pipeline-test-assets/multiplane-ophys-test-asset_results'
params.multiplane_ophys_test_asset_url = 's3://aind-scratch-data/pipeline-test-assets/multiplane-ophys-test-asset'

multiplane_ophys_test_asset_results_to_aind_ophys_extraction_1 = channel.fromPath(params.multiplane_ophys_test_asset_results_url + "/V*", type: 'any')
multiplane_ophys_test_asset_to_aind_ophys_extraction_2 = channel.fromPath(params.multiplane_ophys_test_asset_url + "/*.json", type: 'any')
multiplane_ophys_test_asset_to_aind_ophys_dff_3 = channel.fromPath(params.multiplane_ophys_test_asset_url + "/*.json", type: 'any')
capsule_aind_ophys_extraction_4_to_capsule_aind_ophys_dff_5_4 = channel.create()
multiplane_ophys_test_asset_to_aind_ophys_oasis_event_detection_5 = channel.fromPath(params.multiplane_ophys_test_asset_url + "/*.json", type: 'any')
capsule_aind_ophys_dff_5_to_capsule_aind_ophys_oasis_event_detection_8_6 = channel.create()
multiplane_ophys_test_asset_results_to_aind_pipeline_processing_metadata_aggregator_7 = channel.fromPath(params.multiplane_ophys_test_asset_results_url + "/*/decrosstalk/*data_process.json", type: 'any')
multiplane_ophys_test_asset_results_to_aind_pipeline_processing_metadata_aggregator_8 = channel.fromPath(params.multiplane_ophys_test_asset_results_url + "/*/motion_correction/*data_process.json", type: 'any')
capsule_aind_ophys_classifier_11_to_capsule_aind_pipeline_processing_metadata_aggregator_9_9 = channel.create()
capsule_aind_ophys_dff_5_to_capsule_aind_pipeline_processing_metadata_aggregator_9_10 = channel.create()
capsule_aind_ophys_oasis_event_detection_8_to_capsule_aind_pipeline_processing_metadata_aggregator_9_11 = channel.create()
capsule_aind_ophys_extraction_4_to_capsule_aind_pipeline_processing_metadata_aggregator_9_12 = channel.create()
multiplane_ophys_test_asset_to_aind_pipeline_processing_metadata_aggregator_13 = channel.fromPath(params.multiplane_ophys_test_asset_url + "/*.json", type: 'any')
capsule_aind_ophys_classifier_11_to_capsule_aind_ophys_nwb_10_14 = channel.create()
multiplane_ophys_test_asset_to_aind_ophys_nwb_15 = channel.fromPath(params.multiplane_ophys_test_asset_url + "/", type: 'any')
multiplane_ophys_test_asset_results_to_aind_ophys_nwb_16 = channel.fromPath(params.multiplane_ophys_test_asset_results_url + "/*/decrosstalk/*.h5", type: 'any')
multiplane_ophys_test_asset_results_to_aind_ophys_nwb_17 = channel.fromPath(params.multiplane_ophys_test_asset_results_url + "/*/motion_correction/*.png", type: 'any')
capsule_aind_ophys_dff_5_to_capsule_aind_ophys_nwb_10_18 = channel.create()
capsule_aind_ophys_extraction_4_to_capsule_aind_ophys_nwb_10_19 = channel.create()
capsule_aind_ophys_oasis_event_detection_8_to_capsule_aind_ophys_nwb_10_20 = channel.create()
multiplane_ophys_test_asset_to_aind_ophys_classifier_21 = channel.fromPath(params.multiplane_ophys_test_asset_url + "/session.json", type: 'any')
capsule_aind_ophys_extraction_4_to_capsule_aind_ophys_classifier_11_22 = channel.create()
multiplane_ophys_test_asset_results_to_aind_ophys_quality_control_aggregator_23 = channel.fromPath(params.multiplane_ophys_test_asset_results_url + "/*/motion_correction/*.json", type: 'any')
multiplane_ophys_test_asset_results_to_aind_ophys_quality_control_aggregator_24 = channel.fromPath(params.multiplane_ophys_test_asset_results_url + "/*/movie_qc/*.json", type: 'any')
multiplane_ophys_test_asset_results_to_aind_ophys_quality_control_aggregator_25 = channel.fromPath(params.multiplane_ophys_test_asset_results_url + "/*/classification/*.png", type: 'any')
multiplane_ophys_test_asset_to_aind_ophys_quality_control_aggregator_26 = channel.fromPath(params.multiplane_ophys_test_asset_url + "/*.json", type: 'any')
capsule_aind_ophys_oasis_event_detection_8_to_capsule_aind_ophys_quality_control_aggregator_12_27 = channel.create()
capsule_aind_ophys_extraction_4_to_capsule_aind_ophys_quality_control_aggregator_12_28 = channel.create()
capsule_aind_ophys_classifier_11_to_capsule_aind_ophys_quality_control_aggregator_12_29 = channel.create()
multiplane_ophys_test_asset_results_to_aind_ophys_collect_previous_results_30 = channel.fromPath(params.multiplane_ophys_test_asset_results_url + "/", type: 'any')

// capsule - aind-ophys-extraction
process capsule_aind_ophys_extraction_4 {
	tag 'capsule-9911715'
	container "$REGISTRY_HOST/published/5e1d659c-e149-4a57-be83-12f5a448a0c9:v13"

	cpus 1
	memory '7.5 GB'

	publishDir "$RESULTS_PATH", mode: 'copy', saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from multiplane_ophys_test_asset_results_to_aind_ophys_extraction_1
	path 'capsule/data/' from multiplane_ophys_test_asset_to_aind_ophys_extraction_2.collect()

	output:
	path 'capsule/results/*'
	path 'capsule/results/*' into capsule_aind_ophys_extraction_4_to_capsule_aind_ophys_dff_5_4
	path 'capsule/results/*/*/*data_process.json' into capsule_aind_ophys_extraction_4_to_capsule_aind_pipeline_processing_metadata_aggregator_9_12
	path 'capsule/results/*/extraction/*.h5' into capsule_aind_ophys_extraction_4_to_capsule_aind_ophys_nwb_10_19
	path 'capsule/results/*' into capsule_aind_ophys_extraction_4_to_capsule_aind_ophys_classifier_11_22
	path 'capsule/results/*/*/*.json' into capsule_aind_ophys_extraction_4_to_capsule_aind_ophys_quality_control_aggregator_12_28

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=5e1d659c-e149-4a57-be83-12f5a448a0c9
	export CO_CPUS=1
	export CO_MEMORY=8053063680

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git -c credential.helper= clone --filter=tree:0 --branch v13.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-9911715.git" capsule-repo
	else
		git -c credential.helper= clone --branch v13.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-9911715.git" capsule-repo
	fi
	mv capsule-repo/code capsule/code && ln -s \$PWD/capsule/code /code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_aind_ophys_extraction_4_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-ophys-dff
process capsule_aind_ophys_dff_5 {
	tag 'capsule-3040821'
	container "$REGISTRY_HOST/capsule/67c14c62-8eeb-49b0-bf09-d9c247754395:410bb4a4e1037a2e09c6b9510a0c067d"

	cpus 4
	memory '30 GB'

	publishDir "$RESULTS_PATH", mode: 'copy', saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from multiplane_ophys_test_asset_to_aind_ophys_dff_3.collect()
	path 'capsule/data/' from capsule_aind_ophys_extraction_4_to_capsule_aind_ophys_dff_5_4

	output:
	path 'capsule/results/*'
	path 'capsule/results/*' into capsule_aind_ophys_dff_5_to_capsule_aind_ophys_oasis_event_detection_8_6
	path 'capsule/results/*/*/*data_process.json' into capsule_aind_ophys_dff_5_to_capsule_aind_pipeline_processing_metadata_aggregator_9_10
	path 'capsule/results/*/dff/*.h5' into capsule_aind_ophys_dff_5_to_capsule_aind_ophys_nwb_10_18

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=67c14c62-8eeb-49b0-bf09-d9c247754395
	export CO_CPUS=4
	export CO_MEMORY=32212254720

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git -c credential.helper= clone --filter=tree:0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-3040821.git" capsule-repo
	else
		git -c credential.helper= clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-3040821.git" capsule-repo
	fi
	git -C capsule-repo checkout 43e8dd8371f48fd02ccd307093c0c2bd1e2d7619 --quiet
	mv capsule-repo/code capsule/code && ln -s \$PWD/capsule/code /code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run --method=triexp

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-ophys-oasis-event-detection
process capsule_aind_ophys_oasis_event_detection_8 {
	tag 'capsule-8957649'
	container "$REGISTRY_HOST/published/c6394aab-0db7-47b2-90ba-864866d6755e:v10"

	cpus 1
	memory '7.5 GB'

	publishDir "$RESULTS_PATH", mode: 'copy', saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from multiplane_ophys_test_asset_to_aind_ophys_oasis_event_detection_5.collect()
	path 'capsule/data/' from capsule_aind_ophys_dff_5_to_capsule_aind_ophys_oasis_event_detection_8_6

	output:
	path 'capsule/results/*'
	path 'capsule/results/*/*/*data_process.json' into capsule_aind_ophys_oasis_event_detection_8_to_capsule_aind_pipeline_processing_metadata_aggregator_9_11
	path 'capsule/results/*/events/*.h5' into capsule_aind_ophys_oasis_event_detection_8_to_capsule_aind_ophys_nwb_10_20
	path 'capsule/results/*/*/*.json' into capsule_aind_ophys_oasis_event_detection_8_to_capsule_aind_ophys_quality_control_aggregator_12_27

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=c6394aab-0db7-47b2-90ba-864866d6755e
	export CO_CPUS=1
	export CO_MEMORY=8053063680

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git -c credential.helper= clone --filter=tree:0 --branch v10.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-8957649.git" capsule-repo
	else
		git -c credential.helper= clone --branch v10.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-8957649.git" capsule-repo
	fi
	mv capsule-repo/code capsule/code && ln -s \$PWD/capsule/code /code
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
	container "$REGISTRY_HOST/published/d51df783-d892-4304-a129-238a9baea72a:v6"

	cpus 1
	memory '7.5 GB'

	publishDir "$RESULTS_PATH", mode: 'copy', saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from multiplane_ophys_test_asset_results_to_aind_pipeline_processing_metadata_aggregator_7.collect()
	path 'capsule/data/' from multiplane_ophys_test_asset_results_to_aind_pipeline_processing_metadata_aggregator_8.collect()
	path 'capsule/data/' from capsule_aind_ophys_classifier_11_to_capsule_aind_pipeline_processing_metadata_aggregator_9_9.collect()
	path 'capsule/data/' from capsule_aind_ophys_dff_5_to_capsule_aind_pipeline_processing_metadata_aggregator_9_10.collect()
	path 'capsule/data/' from capsule_aind_ophys_oasis_event_detection_8_to_capsule_aind_pipeline_processing_metadata_aggregator_9_11.collect()
	path 'capsule/data/' from capsule_aind_ophys_extraction_4_to_capsule_aind_pipeline_processing_metadata_aggregator_9_12.collect()
	path 'capsule/data/' from multiplane_ophys_test_asset_to_aind_pipeline_processing_metadata_aggregator_13.collect()

	output:
	path 'capsule/results/*'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=d51df783-d892-4304-a129-238a9baea72a
	export CO_CPUS=1
	export CO_MEMORY=8053063680

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git -c credential.helper= clone --filter=tree:0 --branch v6.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-8250608.git" capsule-repo
	else
		git -c credential.helper= clone --branch v6.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-8250608.git" capsule-repo
	fi
	mv capsule-repo/code capsule/code && ln -s \$PWD/capsule/code /code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run --processor_full_name "Sean McCulloch" --aggregate_quality_control 0 --modality "pophys" --pipeline_version 1

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-ophys-nwb
process capsule_aind_ophys_nwb_10 {
	tag 'capsule-9383700'
	container "$REGISTRY_HOST/published/8c436e95-8607-4752-8e9f-2b62024f9326:v15"

	cpus 1
	memory '7.5 GB'

	publishDir "$RESULTS_PATH", mode: 'copy', saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/processed/' from capsule_aind_ophys_classifier_11_to_capsule_aind_ophys_nwb_10_14.collect()
	path 'capsule/data/raw' from multiplane_ophys_test_asset_to_aind_ophys_nwb_15.collect()
	path 'capsule/data/processed/' from multiplane_ophys_test_asset_results_to_aind_ophys_nwb_16.collect()
	path 'capsule/data/processed/' from multiplane_ophys_test_asset_results_to_aind_ophys_nwb_17.collect()
	path 'capsule/data/processed/' from capsule_aind_ophys_dff_5_to_capsule_aind_ophys_nwb_10_18.collect()
	path 'capsule/data/processed/' from capsule_aind_ophys_extraction_4_to_capsule_aind_ophys_nwb_10_19.collect()
	path 'capsule/data/processed/' from capsule_aind_ophys_oasis_event_detection_8_to_capsule_aind_ophys_nwb_10_20.collect()

	output:
	path 'capsule/results/*'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=8c436e95-8607-4752-8e9f-2b62024f9326
	export CO_CPUS=1
	export CO_MEMORY=8053063680

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	ln -s "/tmp/data/schemas" "capsule/data/schemas" # id: fb4b5cef-4505-4145-b8bd-e41d6863d7a9

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git -c credential.helper= clone --filter=tree:0 --branch v15.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-9383700.git" capsule-repo
	else
		git -c credential.helper= clone --branch v15.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-9383700.git" capsule-repo
	fi
	mv capsule-repo/code capsule/code && ln -s \$PWD/capsule/code /code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-ophys-classifier
process capsule_aind_ophys_classifier_11 {
	tag 'capsule-0630574'
	container "$REGISTRY_HOST/published/3819d125-9f03-48f3-ba09-b44c84a7a2c7:v4"

	cpus 16
	memory '61 GB'
	accelerator 1
	label 'gpu'

	publishDir "$RESULTS_PATH", mode: 'copy', saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from multiplane_ophys_test_asset_to_aind_ophys_classifier_21.collect()
	path 'capsule/data/' from capsule_aind_ophys_extraction_4_to_capsule_aind_ophys_classifier_11_22

	output:
	path 'capsule/results/*/*/*data_process.json' into capsule_aind_ophys_classifier_11_to_capsule_aind_pipeline_processing_metadata_aggregator_9_9
	path 'capsule/results/*/classification/*classification.h5' into capsule_aind_ophys_classifier_11_to_capsule_aind_ophys_nwb_10_14
	path 'capsule/results/*'
	path 'capsule/results/*/*/*.json' into capsule_aind_ophys_classifier_11_to_capsule_aind_ophys_quality_control_aggregator_12_29

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=3819d125-9f03-48f3-ba09-b44c84a7a2c7
	export CO_CPUS=16
	export CO_MEMORY=65498251264

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	ln -s "/tmp/data/2p_roi_classifier" "capsule/data/2p_roi_classifier" # id: 57a10c5f-468f-4bb2-b3c6-7f4a80efa8ae

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git -c credential.helper= clone --filter=tree:0 --branch v4.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-0630574.git" capsule-repo
	else
		git -c credential.helper= clone --branch v4.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-0630574.git" capsule-repo
	fi
	mv capsule-repo/code capsule/code && ln -s \$PWD/capsule/code /code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-ophys-quality-control-aggregator
process capsule_aind_ophys_quality_control_aggregator_12 {
	tag 'capsule-4044810'
	container "$REGISTRY_HOST/published/4a698b5c-f5f6-4671-8234-dc728d049a68:v10"

	cpus 1
	memory '7.5 GB'

	publishDir "$RESULTS_PATH", mode: 'copy', saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from multiplane_ophys_test_asset_results_to_aind_ophys_quality_control_aggregator_23.collect()
	path 'capsule/data/' from multiplane_ophys_test_asset_results_to_aind_ophys_quality_control_aggregator_24.collect()
	path 'capsule/data/' from multiplane_ophys_test_asset_results_to_aind_ophys_quality_control_aggregator_25.collect()
	path 'capsule/data/' from multiplane_ophys_test_asset_to_aind_ophys_quality_control_aggregator_26.collect()
	path 'capsule/data/' from capsule_aind_ophys_oasis_event_detection_8_to_capsule_aind_ophys_quality_control_aggregator_12_27.collect()
	path 'capsule/data/' from capsule_aind_ophys_extraction_4_to_capsule_aind_ophys_quality_control_aggregator_12_28.collect()
	path 'capsule/data/' from capsule_aind_ophys_classifier_11_to_capsule_aind_ophys_quality_control_aggregator_12_29.collect()

	output:
	path 'capsule/results/*'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=4a698b5c-f5f6-4671-8234-dc728d049a68
	export CO_CPUS=1
	export CO_MEMORY=8053063680

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git -c credential.helper= clone --filter=tree:0 --branch v10.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-4044810.git" capsule-repo
	else
		git -c credential.helper= clone --branch v10.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-4044810.git" capsule-repo
	fi
	mv capsule-repo/code capsule/code && ln -s \$PWD/capsule/code /code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_aind_ophys_quality_control_aggregator_12_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-ophys-collect-previous-results
process capsule_aind_ophys_collect_previous_results_13 {
	tag 'capsule-3273600'
	container "$REGISTRY_HOST/capsule/09cccbe2-01bf-4ea6-8f3d-bc2b7d8125df:73e4b4a9f76196821214ded980f3c9de"

	cpus 1
	memory '7.5 GB'

	publishDir "$RESULTS_PATH", mode: 'copy', saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data' from multiplane_ophys_test_asset_results_to_aind_ophys_collect_previous_results_30.collect()

	output:
	path 'capsule/results/*'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=09cccbe2-01bf-4ea6-8f3d-bc2b7d8125df
	export CO_CPUS=1
	export CO_MEMORY=8053063680

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git -c credential.helper= clone --filter=tree:0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-3273600.git" capsule-repo
	else
		git -c credential.helper= clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-3273600.git" capsule-repo
	fi
	git -C capsule-repo checkout 297e61eba9301967df9d9f76462ab478c76069ee --quiet
	mv capsule-repo/code capsule/code && ln -s \$PWD/capsule/code /code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run --copy "true"

	echo "[${task.tag}] completed!"
	"""
}
