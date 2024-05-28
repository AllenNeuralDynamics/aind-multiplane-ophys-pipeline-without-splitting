#!/usr/bin/env nextflow
// hash:sha256:83cdbae44e352c81913fa0da6b064462d6d0d0c650e9ed52723904f6b940ecb5

nextflow.enable.dsl = 1

params.multiplane_ophys_726433_2024_05_14_08_13_02_url = 's3://aind-private-data-prod-o5171v/multiplane-ophys_726433_2024-05-14_08-13-02'

multiplane_ophys_726433_2024_05_14_08_13_02_to_aind_ophys_motion_correction_1 = channel.fromPath(params.multiplane_ophys_726433_2024_05_14_08_13_02_url + "/*json", type: 'any')
multiplane_ophys_726433_2024_05_14_08_13_02_to_aind_ophys_motion_correction_2 = channel.fromPath(params.multiplane_ophys_726433_2024_05_14_08_13_02_url + "/ophys/*platform*", type: 'any')
multiplane_ophys_726433_2024_05_14_08_13_02_to_aind_ophys_motion_correction_3 = channel.fromPath(params.multiplane_ophys_726433_2024_05_14_08_13_02_url + "/*/*.h5", type: 'any')
capsule_aind_ophys_mesoscope_image_splitter_10_to_capsule_aind_ophys_motion_correction_1_4 = channel.create()
multiplane_ophys_726433_2024_05_14_08_13_02_to_aind_ophys_decrosstalk_split_session_json_5 = channel.fromPath(params.multiplane_ophys_726433_2024_05_14_08_13_02_url + "/session.json", type: 'any')
capsule_aind_ophys_motion_correction_1_to_capsule_aind_ophys_decrosstalk_split_session_json_2_6 = channel.create()
capsule_aind_ophys_motion_correction_1_to_capsule_aind_ophys_decrosstalk_roi_images_3_7 = channel.create()
capsule_aind_ophys_decrosstalk_split_session_json_2_to_capsule_aind_ophys_decrosstalk_roi_images_3_8 = channel.create()
capsule_aind_ophys_decrosstalk_roi_images_3_to_capsule_aind_ophys_segmentation_cellpose_4_9 = channel.create()
capsule_aind_ophys_segmentation_cellpose_4_to_capsule_aind_ophys_trace_extraction_5_10 = channel.create()
capsule_aind_ophys_decrosstalk_roi_images_3_to_capsule_aind_ophys_trace_extraction_5_11 = channel.create()
capsule_aind_ophys_motion_correction_1_to_capsule_aind_ophys_trace_extraction_5_12 = channel.create()
capsule_aind_ophys_decrosstalk_roi_images_3_to_capsule_aind_ophys_neuropil_correction_7_13 = channel.create()
capsule_aind_ophys_trace_extraction_5_to_capsule_aind_ophys_neuropil_correction_7_14 = channel.create()
capsule_aind_ophys_neuropil_correction_7_to_capsule_aind_ophys_dff_8_15 = channel.create()
capsule_aind_ophys_dff_8_to_capsule_aind_ophys_oasis_event_detection_9_16 = channel.create()
multiplane_ophys_726433_2024_05_14_08_13_02_to_aind_ophys_mesoscope_image_splitter_17 = channel.fromPath(params.multiplane_ophys_726433_2024_05_14_08_13_02_url + "/", type: 'any')
multiplane_ophys_726433_2024_05_14_08_13_02_to_processing_json_aggregator_18 = channel.fromPath(params.multiplane_ophys_726433_2024_05_14_08_13_02_url + "/*", type: 'any')
capsule_aind_ophys_oasis_event_detection_9_to_capsule_processingjsonaggregator_11_19 = channel.create()

// capsule - aind-ophys-motion-correction
process capsule_aind_ophys_motion_correction_1 {
	tag 'capsule-5379831'
	container "$REGISTRY_HOST/capsule/63a8ce2e-f232-4590-9098-36b820202911"

	cpus 16
	memory '128 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from multiplane_ophys_726433_2024_05_14_08_13_02_to_aind_ophys_motion_correction_1.collect()
	path 'capsule/data/' from multiplane_ophys_726433_2024_05_14_08_13_02_to_aind_ophys_motion_correction_2.collect()
	path 'capsule/data/' from multiplane_ophys_726433_2024_05_14_08_13_02_to_aind_ophys_motion_correction_3.collect()
	path 'capsule/data/' from capsule_aind_ophys_mesoscope_image_splitter_10_to_capsule_aind_ophys_motion_correction_1_4.flatten()

	output:
	path 'capsule/results/*'
	path 'capsule/results/*' into capsule_aind_ophys_motion_correction_1_to_capsule_aind_ophys_decrosstalk_split_session_json_2_6
	path 'capsule/results/*' into capsule_aind_ophys_motion_correction_1_to_capsule_aind_ophys_decrosstalk_roi_images_3_7
	path 'capsule/results/*/motion_correction/*transform.csv' into capsule_aind_ophys_motion_correction_1_to_capsule_aind_ophys_trace_extraction_5_12

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=63a8ce2e-f232-4590-9098-36b820202911
	export CO_CPUS=16
	export CO_MEMORY=137438953472

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-5379831.git" capsule-repo
	git -C capsule-repo checkout 2669e941555aed21967a1f7322cf1350c2dc8499 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-ophys-decrosstalk-split-session-json
process capsule_aind_ophys_decrosstalk_split_session_json_2 {
	tag 'capsule-7511402'
	container "$REGISTRY_HOST/capsule/76b52bbc-5e23-4e4b-9bc7-f48d24031e09"

	cpus 1
	memory '8 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from multiplane_ophys_726433_2024_05_14_08_13_02_to_aind_ophys_decrosstalk_split_session_json_5.collect()
	path 'capsule/data/' from capsule_aind_ophys_motion_correction_1_to_capsule_aind_ophys_decrosstalk_split_session_json_2_6.collect()

	output:
	path 'capsule/results/*'
	path 'capsule/results/*' into capsule_aind_ophys_decrosstalk_split_session_json_2_to_capsule_aind_ophys_decrosstalk_roi_images_3_8

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=76b52bbc-5e23-4e4b-9bc7-f48d24031e09
	export CO_CPUS=1
	export CO_MEMORY=8589934592

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-7511402.git" capsule-repo
	git -C capsule-repo checkout cf1de4446f30bf896a2b37c13a4e4f4d9a62c1ae --quiet
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
	tag 'capsule-4612268'
	container "$REGISTRY_HOST/capsule/e31d29f8-7eee-446b-8f0a-2f027fe6f39b"

	cpus 16
	memory '128 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from capsule_aind_ophys_motion_correction_1_to_capsule_aind_ophys_decrosstalk_roi_images_3_7.collect()
	path 'capsule/data/' from capsule_aind_ophys_decrosstalk_split_session_json_2_to_capsule_aind_ophys_decrosstalk_roi_images_3_8.flatten()

	output:
	path 'capsule/results/*'
	path 'capsule/results/*' into capsule_aind_ophys_decrosstalk_roi_images_3_to_capsule_aind_ophys_segmentation_cellpose_4_9
	path 'capsule/results/*/decrosstalk/*decrosstalk.h5' into capsule_aind_ophys_decrosstalk_roi_images_3_to_capsule_aind_ophys_trace_extraction_5_11
	path 'capsule/results/*/decrosstalk/*decrosstalk.h5' into capsule_aind_ophys_decrosstalk_roi_images_3_to_capsule_aind_ophys_neuropil_correction_7_13

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=e31d29f8-7eee-446b-8f0a-2f027fe6f39b
	export CO_CPUS=16
	export CO_MEMORY=137438953472

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-4612268.git" capsule-repo
	git -C capsule-repo checkout ed7e22685c139a76219f20520d5fe07f7056112a --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-ophys-segmentation-cellpose
process capsule_aind_ophys_segmentation_cellpose_4 {
	tag 'capsule-0136322'
	container "$REGISTRY_HOST/capsule/84e6b3e3-e24b-450e-b275-589fc229087e"

	cpus 2
	memory '16 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from capsule_aind_ophys_decrosstalk_roi_images_3_to_capsule_aind_ophys_segmentation_cellpose_4_9.flatten()

	output:
	path 'capsule/results/*'
	path 'capsule/results/*' into capsule_aind_ophys_segmentation_cellpose_4_to_capsule_aind_ophys_trace_extraction_5_10

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=84e6b3e3-e24b-450e-b275-589fc229087e
	export CO_CPUS=2
	export CO_MEMORY=17179869184

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-0136322.git" capsule-repo
	git -C capsule-repo checkout 895065a10b3111bb2a15a0d6848a4ef6f5d97994 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-ophys-trace-extraction
process capsule_aind_ophys_trace_extraction_5 {
	tag 'capsule-7385227'
	container "$REGISTRY_HOST/capsule/3821c170-5883-48ed-a2d5-4a627a432f18"

	cpus 1
	memory '8 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from capsule_aind_ophys_segmentation_cellpose_4_to_capsule_aind_ophys_trace_extraction_5_10
	path 'capsule/data/' from capsule_aind_ophys_decrosstalk_roi_images_3_to_capsule_aind_ophys_trace_extraction_5_11.collect()
	path 'capsule/data/' from capsule_aind_ophys_motion_correction_1_to_capsule_aind_ophys_trace_extraction_5_12.collect()

	output:
	path 'capsule/results/*'
	path 'capsule/results/*' into capsule_aind_ophys_trace_extraction_5_to_capsule_aind_ophys_neuropil_correction_7_14

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=3821c170-5883-48ed-a2d5-4a627a432f18
	export CO_CPUS=1
	export CO_MEMORY=8589934592

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-7385227.git" capsule-repo
	git -C capsule-repo checkout 5a070cd608fd25f8920825c31fb42e698cd3c679 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-ophys-neuropil-correction
process capsule_aind_ophys_neuropil_correction_7 {
	tag 'capsule-7531658'
	container "$REGISTRY_HOST/capsule/7b9dcdd9-4f54-405b-974c-c4c9e405ce26"

	cpus 1
	memory '8 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from capsule_aind_ophys_decrosstalk_roi_images_3_to_capsule_aind_ophys_neuropil_correction_7_13.collect()
	path 'capsule/data/' from capsule_aind_ophys_trace_extraction_5_to_capsule_aind_ophys_neuropil_correction_7_14

	output:
	path 'capsule/results/*'
	path 'capsule/results/*' into capsule_aind_ophys_neuropil_correction_7_to_capsule_aind_ophys_dff_8_15

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=7b9dcdd9-4f54-405b-974c-c4c9e405ce26
	export CO_CPUS=1
	export CO_MEMORY=8589934592

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-7531658.git" capsule-repo
	git -C capsule-repo checkout 960095acef00c65537c1290ba046413155928b7e --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-ophys-dff
process capsule_aind_ophys_dff_8 {
	tag 'capsule-5186816'
	container "$REGISTRY_HOST/capsule/4d1bad07-ff45-4e69-a50f-874e840cd7e6"

	cpus 1
	memory '8 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from capsule_aind_ophys_neuropil_correction_7_to_capsule_aind_ophys_dff_8_15

	output:
	path 'capsule/results/*'
	path 'capsule/results/*' into capsule_aind_ophys_dff_8_to_capsule_aind_ophys_oasis_event_detection_9_16

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=4d1bad07-ff45-4e69-a50f-874e840cd7e6
	export CO_CPUS=1
	export CO_MEMORY=8589934592

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-5186816.git" capsule-repo
	git -C capsule-repo checkout 5c58f5f11d6e0d0527b275c5c75b0d8bb3a347aa --quiet
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
process capsule_aind_ophys_oasis_event_detection_9 {
	tag 'capsule-0298748'
	container "$REGISTRY_HOST/capsule/382062c4-fd31-4812-806b-cc81bad29bf4"

	cpus 1
	memory '8 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from capsule_aind_ophys_dff_8_to_capsule_aind_ophys_oasis_event_detection_9_16

	output:
	path 'capsule/results/*'
	path 'capsule/results/*' into capsule_aind_ophys_oasis_event_detection_9_to_capsule_processingjsonaggregator_11_19

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=382062c4-fd31-4812-806b-cc81bad29bf4
	export CO_CPUS=1
	export CO_MEMORY=8589934592

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-0298748.git" capsule-repo
	git -C capsule-repo checkout 42f266411c0420bca3b27a29767ef8594069e8fa --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-ophys-mesoscope-image-splitter
process capsule_aind_ophys_mesoscope_image_splitter_10 {
	tag 'capsule-0115380'
	container "$REGISTRY_HOST/capsule/c567666c-dd08-45dd-a824-6a570bd4675d"

	cpus 4
	memory '32 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> filename.matches("capsule/results/.*\\.h5") ? new File(filename).getName() : null }

	input:
	path 'capsule/data' from multiplane_ophys_726433_2024_05_14_08_13_02_to_aind_ophys_mesoscope_image_splitter_17.collect()

	output:
	path 'capsule/results/*_[0-9]' into capsule_aind_ophys_mesoscope_image_splitter_10_to_capsule_aind_ophys_motion_correction_1_4
	path 'capsule/results/*.h5'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=c567666c-dd08-45dd-a824-6a570bd4675d
	export CO_CPUS=4
	export CO_MEMORY=34359738368

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-0115380.git" capsule-repo
	git -C capsule-repo checkout 96bf77c1fe8a210de1ace68a4d426c8f8a7a8b7c --quiet
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
process capsule_processingjsonaggregator_11 {
	tag 'capsule-1130313'
	container "$REGISTRY_HOST/capsule/266b93f8-1b9b-4e1e-9415-4eb9ae8eccb0"

	cpus 1
	memory '8 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from multiplane_ophys_726433_2024_05_14_08_13_02_to_processing_json_aggregator_18
	path 'capsule/data/' from capsule_aind_ophys_oasis_event_detection_9_to_capsule_processingjsonaggregator_11_19.collect()

	output:
	path 'capsule/results/*'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=266b93f8-1b9b-4e1e-9415-4eb9ae8eccb0
	export CO_CPUS=1
	export CO_MEMORY=8589934592

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-1130313.git" capsule-repo
	git -C capsule-repo checkout 2c65a9b38e6f16fe3ab72c83311fb840578d7a8b --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}
