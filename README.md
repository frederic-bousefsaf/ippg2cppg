# iPPG 2 cPPG: reconstructing contact from imaging photoplethysmographic signals

This repository contains the source codes related to a deep learning model dedicated to the conversion of imaging PPG signals (computed from video) into PPG signals measured by contact sensor placed on the finger or on the ear.

## Reference
If you find this code useful or use it in an academic or research project, please cite it as:

Frédéric Bousefsaf et al., **iPPG 2 cPPG: reconstructing contact from imaging photoplethysmographic signals using U-Net architectures**, *Computers in Biology and Medicine*, 104860, https://doi.org/10.1016/j.compbiomed.2021.104860, 2021.

You can also visit my [website](https://sites.google.com/view/frederic-bousefsaf) for additional information.

## Scientific description
Please refer to the original publication to get all the details. We propose converting imaging photoplethysmographic (iPPG) to contact PPG (cPPG) signals using their continuous wavelet transforms (CWT). The real and imaginary parts of the CWT are passed to a deep pre-trained (ResNeXt101) U-shaped architecture. The main motivation behind this work corresponds to the possibility of proposing an estimation of arterial blood pressure from video by analyzing iPPG signals. The next step towards this direction is therefore the integration of the recovered cPPG signals into AI models dedicated to the estimation of blood pressure using contact signals collected from large public databases.


![Alt text](illustrations/overview2.png?raw=true "Overview")


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

`train and predict/train.py` includes all the procedures. The input, `data.mat`, corresponds to a collection of continuous wavelet representation (size: 256×256) of iPPG and ground truth cPPG signals (not supplied here). `train and predict/signal_to_cwt.m` is the MATLAB procedure dedicated to the conversion of a raw PPG signal (5 successive PPG waves) to its wavelet representation.


**Prediction**

Trained architectures (U-Net supported by a ResNeXt101 backbone) [are freely available.](https://zenodo.org/record/5482374)

The dataset employed to train the networks has not been publicly released yet but excerpts [are available.](https://zenodo.org/record/5477689)

`train and predict/predict.py` will output a `.mat` file that can be analyzed with the `results analysis/main.py` MATLAB code.

![Alt text](illustrations/pred.png?raw=true "Results computed from sample data")
