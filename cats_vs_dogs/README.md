# Cats vs Dogs Classifier using CNN
#### Computer Vision
The objective of this project is to build an image classifier capable of distinguish between Dogs and Cats using Convolutional Neural Networks (CNN). The data used in this notebook consists of around 25.000 labeled images. The main ideas of the projects were to develop a robust test harness for estimating the performance of the model, to explore improvements to the model, and to save the model and later load it to make predictions on new data. As the result, the final model was able to achieve an accuracy of 84% in correctly classifying cat and dog images.

Dataset: [Cats vs Dogs Dataset](https://www.microsoft.com/en-us/download/details.aspx?id=54765)

The algorithms were run in [Kaggle](www.kaggle.com) in order to get access to some GPUs that could run the code faster.

The project code is available in a Jupyter Notebook and it consists of the following steps:
1. Load the dataset.
2. Explore the dataset and remove corrupted/invalid images.
3. Split the data into a train/validation set.
4. Build a data iterator so we can load the images progressively. This will be slower than loading the images directly from memory but it will run on more machines (**loading the dataset directly would require a lot of RAM**).
5. **Build some baseline models**: We've implemented a **VGG (Very Deep Convolutional Neural Network)** as our baseline architecture. This architecture involves stacking convolutional layers with small 3×3 filters followed by a max pooling layer. Together, these layers form a block, and these blocks can be repeated where the number of filters in each block is increased with the depth of the network such as 32, 64, 128, 256 for the first four blocks of the model.
6. **Model Improvements**: We've implemented **Dropout** to reduce overfitting and **Data Augmentation** to further generalize and improve performance on unseen instances.