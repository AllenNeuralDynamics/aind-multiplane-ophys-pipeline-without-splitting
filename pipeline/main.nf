#!/usr/bin/env nextflow
// hash:sha256:e9f8a63829e471748af4757e4a720b6114429b224d76af657c2d9d22e6eb3565

nextflow.enable.dsl = 1

params.multiplane_ophys_test_asset_results_url = 's3://aind-scratch-data/pipeline-test-assets/multiplane-ophys-test-asset_results'
params.multiplane_ophys_test_asset_url = 's3://aind-scratch-data/pipeline-test-assets/multiplane-ophys-test-asset'

multiplane_ophys_test_asset_results_to_aind_ophys_extraction_1 = channel.fromPath(params.multiplane_ophys_test_asset_results_url + "/V*", type: 'any')
multiplane_ophys_test_asset_to_aind_ophys_extraction_2 = channel.fromPath(params.multiplane_ophys_test_asset_url + "/*.json", type: 'any')
multiplane_ophys_test_asset_to_aind_ophys_dff_3 = channel.fromPath(params.multiplane_ophys_test_asset_url + "/*.json", type: 'any')
capsule_aind_ophys_extraction_4_to_capsule_aind_ophys_dff_5_4 = channel.create()
multiplane_ophys_test_asset_to_aind_ophys_oasis_event_detection_5 = channel.fromPath(params.multiplane_ophys_test_asset_url + "/*.json", type: 'any')
capsule_aind_ophys_dff_5_to_capsule_aind_ophys_oasis_event_detection_8_6 = channel.create()
capsule_aind_ophys_classifier_11_to_capsule_aind_pipeline_processing_metadata_aggregator_9_7 = channel.create()
capsule_aind_ophys_dff_5_to_capsule_aind_pipeline_processing_metadata_aggregator_9_8 = channel.create()
capsule_aind_ophys_oasis_event_detection_8_to_capsule_aind_pipeline_processing_metadata_aggregator_9_9 = channel.create()
capsule_aind_ophys_extraction_4_to_capsule_aind_pipeline_processing_metadata_aggregator_9_10 = channel.create()
multiplane_ophys_test_asset_to_aind_pipeline_processing_metadata_aggregator_11 = channel.fromPath(params.multiplane_ophys_test_asset_url + "/*.json", type: 'any')
capsule_aind_ophys_classifier_11_to_capsule_aind_ophys_nwb_10_12 = channel.create()
multiplane_ophys_test_asset_to_aind_ophys_nwb_13 = channel.fromPath(params.multiplane_ophys_test_asset_url + "/", type: 'any')
multiplane_ophys_test_asset_results_to_aind_ophys_nwb_14 = channel.fromPath(params.multiplane_ophys_test_asset_results_url + "/*/decrosstalk/*.h5", type: 'any')
multiplane_ophys_test_asset_results_to_aind_ophys_nwb_15 = channel.fromPath(params.multiplane_ophys_test_asset_results_url + "/*/motion_correction/*.png", type: 'any')
capsule_aind_ophys_dff_5_to_capsule_aind_ophys_nwb_10_16 = channel.create()
capsule_aind_ophys_extraction_4_to_capsule_aind_ophys_nwb_10_17 = channel.create()
capsule_aind_ophys_oasis_event_detection_8_to_capsule_aind_ophys_nwb_10_18 = channel.create()
multiplane_ophys_test_asset_to_aind_ophys_classifier_19 = channel.fromPath(params.multiplane_ophys_test_asset_url + "/session.json", type: 'any')
capsule_aind_ophys_extraction_4_to_capsule_aind_ophys_classifier_11_20 = channel.create()

// capsule - aind-ophys-extraction
process capsule_aind_ophys_extraction_4 {
	tag 'capsule-9911715'
	container "$REGISTRY_HOST/published/5e1d659c-e149-4a57-be83-12f5a448a0c9:v13"

	cpus 1
	memory '7.5 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from multiplane_ophys_test_asset_results_to_aind_ophys_extraction_1
	path 'capsule/data/' from multiplane_ophys_test_asset_to_aind_ophys_extraction_2.collect()

	output:
	path 'capsule/results/*'
	path 'capsule/results/*' into capsule_aind_ophys_extraction_4_to_capsule_aind_ophys_dff_5_4
	path 'capsule/results/*/*/*data_process.json' into capsule_aind_ophys_extraction_4_to_capsule_aind_pipeline_processing_metadata_aggregator_9_10
	path 'capsule/results/*/extraction/*.h5' into capsule_aind_ophys_extraction_4_to_capsule_aind_ophys_nwb_10_17
	path 'capsule/results/*' into capsule_aind_ophys_extraction_4_to_capsule_aind_ophys_classifier_11_20

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
	tag 'capsule-6574773'
	container "$REGISTRY_HOST/published/85987e27-601c-4863-811b-71e5b4bdea37:v5"

	cpus 4
	memory '30 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from multiplane_ophys_test_asset_to_aind_ophys_dff_3.collect()
	path 'capsule/data/' from capsule_aind_ophys_extraction_4_to_capsule_aind_ophys_dff_5_4

	output:
	path 'capsule/results/*'
	path 'capsule/results/*' into capsule_aind_ophys_dff_5_to_capsule_aind_ophys_oasis_event_detection_8_6
	path 'capsule/results/*/*/*data_process.json' into capsule_aind_ophys_dff_5_to_capsule_aind_pipeline_processing_metadata_aggregator_9_8
	path 'capsule/results/*/dff/*.h5' into capsule_aind_ophys_dff_5_to_capsule_aind_ophys_nwb_10_16

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=85987e27-601c-4863-811b-71e5b4bdea37
	export CO_CPUS=4
	export CO_MEMORY=32212254720

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git -c credential.helper= clone --filter=tree:0 --branch v5.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-6574773.git" capsule-repo
	else
		git -c credential.helper= clone --branch v5.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-6574773.git" capsule-repo
	fi
	mv capsule-repo/code capsule/code && ln -s \$PWD/capsule/code /code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_aind_ophys_dff_5_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-ophys-oasis-event-detection
process capsule_aind_ophys_oasis_event_detection_8 {
	tag 'capsule-8957649'
	container "$REGISTRY_HOST/published/c6394aab-0db7-47b2-90ba-864866d6755e:v10"

	cpus 1
	memory '7.5 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from multiplane_ophys_test_asset_to_aind_ophys_oasis_event_detection_5.collect()
	path 'capsule/data/' from capsule_aind_ophys_dff_5_to_capsule_aind_ophys_oasis_event_detection_8_6

	output:
	path 'capsule/results/*'
	path 'capsule/results/*/*/*data_process.json' into capsule_aind_ophys_oasis_event_detection_8_to_capsule_aind_pipeline_processing_metadata_aggregator_9_9
	path 'capsule/results/*/events/*.h5' into capsule_aind_ophys_oasis_event_detection_8_to_capsule_aind_ophys_nwb_10_18

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

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from capsule_aind_ophys_classifier_11_to_capsule_aind_pipeline_processing_metadata_aggregator_9_7.collect()
	path 'capsule/data/' from capsule_aind_ophys_dff_5_to_capsule_aind_pipeline_processing_metadata_aggregator_9_8.collect()
	path 'capsule/data/' from capsule_aind_ophys_oasis_event_detection_8_to_capsule_aind_pipeline_processing_metadata_aggregator_9_9.collect()
	path 'capsule/data/' from capsule_aind_ophys_extraction_4_to_capsule_aind_pipeline_processing_metadata_aggregator_9_10.collect()
	path 'capsule/data/' from multiplane_ophys_test_asset_to_aind_pipeline_processing_metadata_aggregator_11.collect()

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
	./run --processor_full_name "Arielle Leon" --aggregate_quality_control 0

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-ophys-nwb
process capsule_aind_ophys_nwb_10 {
	tag 'capsule-9383700'
	container "$REGISTRY_HOST/published/8c436e95-8607-4752-8e9f-2b62024f9326:v15"

	cpus 1
	memory '7.5 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/processed/' from capsule_aind_ophys_classifier_11_to_capsule_aind_ophys_nwb_10_12.collect()
	path 'capsule/data/raw' from multiplane_ophys_test_asset_to_aind_ophys_nwb_13.collect()
	path 'capsule/data/processed/' from multiplane_ophys_test_asset_results_to_aind_ophys_nwb_14.collect()
	path 'capsule/data/processed/' from multiplane_ophys_test_asset_results_to_aind_ophys_nwb_15.collect()
	path 'capsule/data/processed/' from capsule_aind_ophys_dff_5_to_capsule_aind_ophys_nwb_10_16.collect()
	path 'capsule/data/processed/' from capsule_aind_ophys_extraction_4_to_capsule_aind_ophys_nwb_10_17.collect()
	path 'capsule/data/processed/' from capsule_aind_ophys_oasis_event_detection_8_to_capsule_aind_ophys_nwb_10_18.collect()

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

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from multiplane_ophys_test_asset_to_aind_ophys_classifier_19.collect()
	path 'capsule/data/' from capsule_aind_ophys_extraction_4_to_capsule_aind_ophys_classifier_11_20

	output:
	path 'capsule/results/*/*/*data_process.json' into capsule_aind_ophys_classifier_11_to_capsule_aind_pipeline_processing_metadata_aggregator_9_7
	path 'capsule/results/*/classification/*classification.h5' into capsule_aind_ophys_classifier_11_to_capsule_aind_ophys_nwb_10_12
	path 'capsule/results/*'

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

	ln -s "/tmp/data/2p_roi_classifier" "capsule/data/2p_roi_classifier" # id: 35d1284e-4dfa-4ac3-9ba8-5ea1ae2fdaeb

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
