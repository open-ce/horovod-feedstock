# *****************************************************************
#
# Licensed Materials - Property of IBM
#
# (C) Copyright IBM Corp. 2018, 2019. All Rights Reserved.
#
# US Government Users Restricted Rights - Use, duplication or
# disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
#
# *****************************************************************


#Build horovod
git submodule update --init --recursive
HOROVOD_WITHOUT_MXNET=1 HOROVOD_WITHOUT_GLOO=1 HOROVOD_WITH_PYTORCH=1 HOROVOD_WITH_TENSORFLOW=1 HOROVOD_CUDA_HOME=$CONDA_PREFIX HOROVOD_GPU_ALLREDUCE=NCCL HOROVOD_GPU_BROADCAST=NCCL python setup.py install --prefix=$PREFIX

#Copy example scripts
HVD_EXAMPLES_DIR=$PREFIX/horovod/examples/
mkdir -p $HVD_EXAMPLES_DIR
cp examples/pytorch_imagenet_resnet50.py        $HVD_EXAMPLES_DIR
cp examples/pytorch_mnist.py                    $HVD_EXAMPLES_DIR
cp examples/pytorch_synthetic_benchmark.py      $HVD_EXAMPLES_DIR

cp examples/tensorflow2_keras_mnist.py          $HVD_EXAMPLES_DIR
cp examples/tensorflow2_mnist.py                $HVD_EXAMPLES_DIR
cp examples/tensorflow2_synthetic_benchmark.py  $HVD_EXAMPLES_DIR

#Copy examples install script
cp $RECIPE_DIR/../scripts/horovod-install-samples $PREFIX/bin
