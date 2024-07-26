import numpy as np
from flask import Flask, jsonify, request
from flask_cors import CORS  # Add this import
from keras.models import load_model
from keras.preprocessing.sequence import pad_sequences

# Load your TensorFlow model and tokenizer
# Replace these paths with your actual paths
model_path = 'C:/Users/Chanakya/Downloads/sentiment1_model.h5'
tokenizer_path = 'C:/Users/Chanakya/Downloads/tokenizer1_word_index.npy'

# Load the model
model = load_model(model_path)

# Load the tokenizer
tokenizer = np.load(tokenizer_path, allow_pickle=True).item()

# Define labels
labels = ['angry', 'disgust', 'fear', 'joy', 'happy', 'sad', 'surprise', 'neutral']

# Preprocess input
def preprocess_input(input_text):
    max_len = 100
    sequences = []
    for word in input_text.split():
        word_index = tokenizer.get(word.lower(), 0)
        sequences.append(word_index)
    X = pad_sequences([sequences], maxlen=max_len)
    return X

# Create Flask app
app = Flask(__name__)
CORS(app)  # Add this line to enable CORS

# Define API endpoint
@app.route('/predictSentiment', methods=['POST'])
def predict_sentiment():
    try:
        # Get input text from request
        input_text = request.json.get('text', '')

        if not input_text:
            return jsonify({'error': 'No text provided'}), 400

        # Preprocess input
        preprocessed_input = preprocess_input(input_text)

        # Make prediction
        prediction = model.predict(preprocessed_input)

        # Calculate percentages
        total_probability = np.sum(prediction)
        if total_probability == 0:
            total_probability = 1  # Avoid division by zero
        percentage_values = (prediction / total_probability) * 100

        # Convert numpy array to Python list
        percentage_list = percentage_values[0].tolist()

        # Create response object
        response = {label: percentage for label, percentage in zip(labels, percentage_list)}

        # Send response
        return jsonify(response), 200

    except Exception as e:
        print('Error:', e)
        return jsonify({'error': 'Internal Server Error'}), 500

# Run the app
if __name__ == '__main__':
    app.run(debug=True, use_reloader=False)
