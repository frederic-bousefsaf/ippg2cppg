# iPPG2cPPG: reconstructing contact from imaging photoplethysmographic signals

This repository contains the source codes related to a deep learning model dedicated to the conversion of imaging PPG signals (computed from video) into PPG signals measured by contact sensor placed on the finger or on the ear.

## Reference
Frédéric Bousefsaf et al., **iPPG2cPPG: reconstructing contact from imaging photoplethysmographic signals using U-Net architectures**, *preprint*, 2021.

You can also visit my [website](https://sites.google.com/view/frederic-bousefsaf) for additional information.

## Scientific description
Available soon

## Requirements
Deep learning models have been developed and learned through Tensorflow+Keras frameworks (2.3.0) over Python 3.5/3.6 . Results were analyzed with MATLAB R2020b.

Different packages must be installed to properly run the codes : 
- `pip install tensorflow` (or `tensorflow-gpu`)
- `pip install opencv-python`
- `pip install matplotlib`
- `pip install scipy`
- `pip install scikit-learn`
- `pip install segmentation-models`


## Usage
**Training**

`train and predict/train.py` includes all the procedures. The input, `data.mat`, corresponds to a collection of continuous wavelet representation (size: 256×256) of iPPG and ground truth cPPG signals (not supplied here). `train and predict/signal_to_cwt.py` details the MATLAB procedure developped to compute the CWT from raw signals (series of 5 successive PPG waves sampled over 256 values).


**Prediction**

Trained architectures (U-Net supported by a ResNeXt101 backbone) [are freely available.](https://filesender.renater.fr/?s=download&token=787ebfe1-a4c7-4923-b9e7-c637108c0da7&lang=en)

The dataset employed to train the networks has not been publicly released yet but excerpts [are available.](https://filesender.renater.fr/?s=download&token=200192ef-c829-495c-ac33-89e4f59e98cd&lang=en)

`train and predict/predict.py` will output a `.mat` file that can be analyzed with the `results analysis/main.py` MATLAB code.

![Alt text](illustrations/pred.png?raw=true "Results computed from sample data")
