#!/usr/bin/env nextflow
// hash:sha256:a0abb105dc71d05685b0971c4b76648bed1a3c0e85e7e730a5d1141892a47831

nextflow.enable.dsl = 1

params.multiplane_ophys_485152_2019_12_09_13_04_09_url = 's3://aind-ophys-data/multiplane-ophys_485152_2019-12-09_13-04-09'

multiplane_ophys_485152_2019_12_09_13_04_09_to_aind_ophys_motion_correction_1 = channel.fromPath(params.multiplane_ophys_485152_2019_12_09_13_04_09_url + "/*/ophys_experiment*", type: 'any')
multiplane_ophys_485152_2019_12_09_13_04_09_to_aind_ophys_motion_correction_2 = channel.fromPath(params.multiplane_ophys_485152_2019_12_09_13_04_09_url + "/*.json", type: 'any')
multiplane_ophys_485152_2019_12_09_13_04_09_to_aind_ophys_motion_correction_3 = channel.fromPath(params.multiplane_ophys_485152_2019_12_09_13_04_09_url + "/*/MESOSCOPE_FILE*", type: 'any')
multiplane_ophys_485152_2019_12_09_13_04_09_to_aind_ophys_motion_correction_4 = channel.fromPath(params.multiplane_ophys_485152_2019_12_09_13_04_09_url + "/*/*.h5", type: 'any')
multiplane_ophys_485152_2019_12_09_13_04_09_to_aind_ophys_motion_correction_5 = channel.fromPath(params.multiplane_ophys_485152_2019_12_09_13_04_09_url + "/*/*platform.json", type: 'any')

// capsule - aind-ophys-motion-correction
process capsule_aind_ophys_motion_correction_1 {
	tag 'capsule-5379831'
	container "$REGISTRY_HOST/capsule/63a8ce2e-f232-4590-9098-36b820202911"

	cpus 16
	memory '128 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from multiplane_ophys_485152_2019_12_09_13_04_09_to_aind_ophys_motion_correction_1
	path 'capsule/data/' from multiplane_ophys_485152_2019_12_09_13_04_09_to_aind_ophys_motion_correction_2.collect()
	path 'capsule/data/' from multiplane_ophys_485152_2019_12_09_13_04_09_to_aind_ophys_motion_correction_3.collect()
	path 'capsule/data/' from multiplane_ophys_485152_2019_12_09_13_04_09_to_aind_ophys_motion_correction_4.collect()
	path 'capsule/data/' from multiplane_ophys_485152_2019_12_09_13_04_09_to_aind_ophys_motion_correction_5.collect()

	output:
	path 'capsule/results/*'

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
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run --debug

	echo "[${task.tag}] completed!"
	"""
}
