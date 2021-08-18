import numpy as np
import tensorflow as tf
import scipy.io

from sklearn.model_selection import train_test_split
from tensorflow.python.keras.models import Model
from tensorflow.python.keras.layers import Input, Conv2D
from tensorflow.python.keras.callbacks import ModelCheckpoint
from tensorflow.keras.callbacks import CSVLogger
from tensorflow.python.keras.optimizers import Adam

from segmentation_models.models.unet import Unet 


# Disable eager execution
tf.compat.v1.disable_eager_execution()
tf.executing_eagerly()

# Run over a specific GPU
# os.environ["CUDA_VISIBLE_DEVICES"] = "-1"


# GLOBAL VARIABLES
BACKBONES = ['vgg16', 'vgg19', 'resnet101', 'seresnet101', 'resnext101', 'seresnext101', 'inceptionresnetv2', 'inceptionv3', 'densenet201']
FREEZE_ENCODER = True
VERBOSE = 2
EPOCHS = 500
BATCH_SIZE = 16
SAVE_MODEL = True
SITE = 'finger' # finger or ear

# LOAD TRAINING DATA
data = scipy.io.loadmat('data.mat')

xtrain = np.zeros((data['CWT_camera_training'].shape[1], data['CWT_camera_training'][0,0]['cfs'][0,0].shape[0], data['CWT_camera_training'][0,0]['cfs'][0,0].shape[1],2))
ytrain = np.zeros((data['CWT_' + SITE + '_training'].shape[1], data['CWT_' + SITE + '_training'][0,0]['cfs'][0,0].shape[0], data['CWT_' + SITE + '_training'][0,0]['cfs'][0,0].shape[1],2))

for i in range(data['CWT_camera_training'].shape[1]):
    xtrain[i,:,:,0] = np.real(data['CWT_camera_training'][0,i]['cfs'][0,0])
    xtrain[i,:,:,1] = np.imag(data['CWT_camera_training'][0,i]['cfs'][0,0])
    ytrain[i,:,:,0] = np.real(data['CWT_' + SITE + '_training'][0,i]['cfs'][0,0])
    ytrain[i,:,:,1] = np.imag(data['CWT_' + SITE + '_training'][0,i]['cfs'][0,0])


# LOAD VALIDATION DATA
xvalid = np.zeros((data['CWT_camera_validation'].shape[1], data['CWT_camera_validation'][0,0]['cfs'][0,0].shape[0], data['CWT_camera_validation'][0,0]['cfs'][0,0].shape[1],2))
yvalid = np.zeros((data['CWT_' + SITE + '_validation'].shape[1], data['CWT_' + SITE + '_validation'][0,0]['cfs'][0,0].shape[0], data['CWT_' + SITE + '_validation'][0,0]['cfs'][0,0].shape[1],2))

for i in range(data['CWT_camera_validation'].shape[1]):
    xvalid[i,:,:,0] = np.real(data['CWT_camera_validation'][0,i]['cfs'][0,0])
    xvalid[i,:,:,1] = np.imag(data['CWT_camera_validation'][0,i]['cfs'][0,0])
    yvalid[i,:,:,0] = np.real(data['CWT_' + SITE + '_validation'][0,i]['cfs'][0,0])
    yvalid[i,:,:,1] = np.imag(data['CWT_' + SITE + '_validation'][0,i]['cfs'][0,0])



#  DEFINE AND TRAIN MODELS
for backbone in BACKBONES:

    model = Unet(backbone, classes=xtrain.shape[3], encoder_weights='imagenet', encoder_freeze=FREEZE_ENCODER, activation=None)

    # map N channels data to 3 channels
    inp = Input(shape=(None, None, xtrain.shape[-1]))
    l1 = Conv2D(3, (1, 1))(inp) 
    out = model(l1)
    model = Model(inp, out, name=model.name)


    if SAVE_MODEL:
        model_checkpoint = ModelCheckpoint('weights_ippg_to_cppg' + SITE + '_' + backbone + '.h5', monitor='val_loss', save_best_only=True, mode='auto')  
        history_checkpoint = CSVLogger('history_ippg_to_cppg' + SITE + '_' + backbone + '.csv', append=False)

        model.compile(optimizer=Adam(lr=1e-3), loss='mean_squared_error', metrics=['mean_absolute_error'])
        model.summary()
        history = model.fit(xtrain, ytrain, batch_size=BATCH_SIZE, epochs=EPOCHS, validation_data=(xvalid, yvalid), callbacks=[model_checkpoint, history_checkpoint], verbose=VERBOSE)


    # SAVE PREDICTIONS (VALIDATION SET)
    model.load_weights('weights_ippg_to_cppg' + SITE + '_' + backbone + '.h5')    # load best model

    results = np.zeros((yvalid.shape[0]), dtype=np.object)

    for i in range(yvalid.shape[0]):
        pred = model.predict(np.expand_dims(xvalid[i],0))
        results[i] = {}
        results[i]['prediction'] = pred[0]

    scipy.io.savemat('results_ippg_to_cppg' + SITE + '_'  + backbone + '.mat',{'results':results})

