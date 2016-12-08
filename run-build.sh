#!/bin/bash

#
# Pull and run op-build.
# Some Notes:
#  - If using a preexisting source tree, make sure op-build-env exists
#       at the root. The cloning logic uses that to determing whether or not
#       to pull a fresh copy
#
#  - Determining if a defconfig has already been set is done by checking if
#       /op-build/output/.config exists. Usually this should not be a problem


OPB_REPO=${OPB_REPO:-"http://github.com/open-power/op-build"}
OPB_BRANCH=${OPB_BRANCH:-"master"}
OPB_MACHINE=${OPB_MACHINE:-"habanero"}

set -e

# Delete everything in /op-build
if [[ ${OPB_FORCE} == "true" ]]
then
	echo "Force clearing /op-build"
	ls -A op-build/ | xargs -I{} rm -rf "op-build/{}"
fi


# Pull fresh build if not already built or mounted
if [ ! -f "op-build/op-build-env" ]
then
	echo "Pulling a fresh op-build"
	# This *will* fail if the directory is not empty
	git clone --depth 1 --recursive -b ${OPB_BRANCH} ${OPB_REPO} op-build
else
	echo "op-build tree exists, not pulling"
fi

cd op-build
source op-build-env

# Prep defconfig if not already set
if [ ! -f output/.config ]
then
	op-build ${OPB_MACHINE}_defconfig
fi

# Run the build!
op-build

# Copy the images to the end destination
echo "Done! Copying to output directory"
for i in `ls output/images/`
do
	cp "output/images/$i" /images/
done
