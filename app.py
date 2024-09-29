import os
import tensorflow as tf
import librosa
import numpy as np
from flask import Flask, request, jsonify

app = Flask(__name__)
model = tf.keras.models.load_model('rck.keras')

# List of classes
classes = ["COPD", "Bronchiolitis", "Pneumonia", "URTI", "Healthy"]

@app.route('/predict', methods=['POST'])
@app.route('/predict', methods=['POST'])
def predict():
    if 'file' not in request.files:
        return jsonify({'error': 'No file uploaded'}), 400

    file = request.files['file']
    file_path = os.path.join('/tmp', file.filename)
    file.save(file_path)

    # Load the audio file and extract features
    data_x, sampling_rate = librosa.load(file_path, res_type='kaiser_fast')
    mfccs = np.mean(librosa.feature.mfcc(y=data_x, sr=sampling_rate, n_mfcc=52).T, axis=0)

    # Expand dimensions to match expected input shape
    val = np.expand_dims(mfccs, axis=0)  # Shape: (1, 52)
    val = np.expand_dims(val, axis=1)    # Shape: (1, 1, 52)

    # Make prediction
    prediction = model.predict(val)
    predicted_class = classes[np.argmax(prediction)]

    return jsonify({'predicted_class': predicted_class})


if __name__ == '__main__':
    app.run(debug=True)
