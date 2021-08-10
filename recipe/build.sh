#!/bin/bash
# *****************************************************************
# (C) Copyright IBM Corp. 2018, 2021. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# *****************************************************************

#Build horovod
git submodule update --init --recursive

ARCH=`uname -p`

if [[ "${ARCH}" == 'x86_64' ]]; then
    export HOROVOD_BUILD_ARCH_FLAGS='-march=nocona -mtune=haswell'
fi
if [[ "${ARCH}" == 'ppc64le' ]]; then
    export HOROVOD_BUILD_ARCH_FLAGS='-mcpu=power8 -mtune=power8'
fi

if [[ $build_type == "cuda" ]]
then
    export HOROVOD_CUDA_HOME=$CUDA_HOME
    # Create symlinks of cublas headers into CONDA_PREFIX
    mkdir -p $CONDA_PREFIX/include
    find /usr/include -name cublas*.h -exec ln -s "{}" "$CONDA_PREFIX/include/" ';'
    export CXXFLAGS="${CXXFLAGS} -I${PREFIX}/include -I${CUDA_HOME}/include -I${CONDA_PREFIX}/include"
fi

MAKEFLAGS="-j1" HOROVOD_WITHOUT_MXNET=1 HOROVOD_WITHOUT_GLOO=1 HOROVOD_WITH_MPI=1 HOROVOD_WITH_PYTORCH=1 HOROVOD_WITH_TENSORFLOW=1 HOROVOD_CUDA_HOME=$CUDA_HOME HOROVOD_NCCL_HOME=$CONDA_PREFIX HOROVOD_GPU_ALLREDUCE=NCCL HOROVOD_GPU_BROADCAST=NCCL python setup.py install --prefix=$PREFIX

#Copy example scripts
HVD_EXAMPLES_DIR=$PREFIX/horovod/examples/
mkdir -p $HVD_EXAMPLES_DIR
cp examples/pytorch/pytorch_imagenet_resnet50.py        $HVD_EXAMPLES_DIR
cp examples/pytorch/pytorch_mnist.py                    $HVD_EXAMPLES_DIR
cp examples/pytorch/pytorch_synthetic_benchmark.py      $HVD_EXAMPLES_DIR

cp examples/tensorflow2/tensorflow2_keras_mnist.py          $HVD_EXAMPLES_DIR
cp examples/tensorflow2/tensorflow2_mnist.py                $HVD_EXAMPLES_DIR
cp examples/tensorflow2/tensorflow2_synthetic_benchmark.py  $HVD_EXAMPLES_DIR
cp examples/tensorflow2/tensorflow2_keras_synthetic_benchmark.py  $HVD_EXAMPLES_DIR

#Copy examples install script
cp $RECIPE_DIR/../scripts/horovod-install-samples $PREFIX/bin
