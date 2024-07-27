import numpy as np
from flask import Flask, jsonify, request
from flask_cors import CORS
from keras.models import load_model
from keras.preprocessing.sequence import pad_sequences
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain_core.output_parsers import StrOutputParser
from langchain_community.chat_models import ChatOllama
from langchain_core.messages import HumanMessage
from langchain_community.chat_message_histories import ChatMessageHistory
from langchain_core.chat_history import BaseChatMessageHistory
from langchain_core.runnables.history import RunnableWithMessageHistory

# Load your TensorFlow model and tokenizer
model_path = 'sentiment1_model.h5'
tokenizer_path = 'tokenizer1_word_index.npy'

# Load the model
sentiment_model = load_model(model_path)

# Load the tokenizer
tokenizer = np.load(tokenizer_path, allow_pickle=True).item()

# Define labels
labels = ['angry', 'disgust', 'fear', 'joy', 'happy', 'sad', 'surprise', 'neutral']

# Preprocess input for sentiment analysis
def preprocess_input(input_text):
    max_len = 100
    sequences = []
    for word in input_text.split():
        word_index = tokenizer.get(word.lower(), 0)
        sequences.append(word_index)
    X = pad_sequences([sequences], maxlen=max_len)
    return X

# Initialize ChatOllama model
model = ChatOllama(model="mistral")

system_prompt = (
    "You are a warm, supportive friend offering emotional support. "
    "Speak conversationally and with compassion. Listen actively, validate feelings, and suggest positive steps. "
    "Share relatable experiences if appropriate. Recommend professional help for serious issues. Avoid medical advice. "
    "Encourage self-care and coping strategies."
)

prompt = ChatPromptTemplate.from_messages(
    [
        ("system", system_prompt),
        MessagesPlaceholder(variable_name="messages"),
    ]
)

store = {}

def get_session_history(session_id: str) -> BaseChatMessageHistory:
    if session_id not in store:
        store[session_id] = ChatMessageHistory()
    return store[session_id]

chain = prompt | model

with_message_history = RunnableWithMessageHistory(
    chain,
    get_session_history,
    input_messages_key="messages"
)
config = {"configurable": {"session_id": "chat1"}}

# Create Flask app
app = Flask(_name_)
CORS(app)

# Define sentiment analysis API endpoint
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
        prediction = sentiment_model.predict(preprocessed_input)

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

# Define chat API endpoint
@app.route('/chat', methods=['POST'])
def chat():
    data = request.json
    session_id = "chat1"
    user_input = data.get("message")
    
    def generate_response(question):
        response = with_message_history.invoke(
            {'messages': [HumanMessage(question)]},
            config=config
        )
        return response.content

    response = generate_response(user_input)
    return jsonify({"response": response})

# Run the app
if _name_ == '_main_':
    app.run(debug=True, use_reloader=False)
