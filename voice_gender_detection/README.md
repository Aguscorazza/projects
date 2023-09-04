# Voice Gender Recognition System
#### Speech Analytics
The primary objective of this project is to develop a system capable of accurately identifying the gender of a speaker from their voice with a high degree of accuracy. This will involve the creation of a machine learning model that can analyze audio features to make gender predictions. 

The system will be designed to perform real-time gender classification, allowing it to process audio input in real-time and provide gender predictions promptly. This capability is essential for applications like voice assistants, call centers, and online chatbots.

The system has been trained on the [Mozilla's Common Voice Dataset](https://www.kaggle.com/datasets/mozillaorg/common-voice). The dataset has been balanced to avoid biases in the training data so, at the end, we have around 67.000 samples to train our ML models.

## Methodology

### Feature Extraction
Audio feature extraction is be a crucial step, where relevant acoustic features, such as pitch, timbre, and spectral characteristics, will be extracted from the audio recordings. These features will serve as input to the gender classification model. **In this particular project, I've extracted the Mel Spectrogram and Mel Frequency Cepstral Coefficients (MFCC) features from the audio files to train our ML models.**

### Model Development
State-of-the-art deep learning techniques have been explored and implemented to create a gender classification model. The model will undergo extensive training and validation to optimize its performance. **As result, we reached around 96% accuracy on samples that were never seen before by the model.**

### Real-time Integration
The trained model will be integrated into a real-time system capable of processing audio input and providing gender predictions in real-time. This may involve the development of user-friendly APIs or integration with existing voice recognition systems. **At the moment, I have developed a simple python script that is able to record the voice input from your microphone, but later I might implement an API with an user-friendly GUI.**

## Applications

The Voice Gender Classification System can be applied in various domains, including:

- **Customer Service**: Enhance call center interactions and customer support by automatically routing calls to agents of the appropriate gender.
- **Voice Assistants**: Improve user experience in voice-controlled devices by tailoring responses based on the detected gender of the user.
- **Content Personalization**: Optimize content recommendations and advertisements based on user gender preferences.