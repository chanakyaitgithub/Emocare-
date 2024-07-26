from flask import Flask, request, jsonify
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain_core.output_parsers import StrOutputParser
from langchain_community.chat_models import ChatOllama
# import streamlit as st  
import os
# from dotenv import load_dotenv
from langchain_core.messages import HumanMessage, SystemMessage, AIMessage
from langchain_community.chat_message_histories import ChatMessageHistory
from langchain_core.chat_history import BaseChatMessageHistory 
from langchain_core.runnables.history import RunnableWithMessageHistory 


# load_dotenv()
# os.environ["LANGCHAIN_API_KEY"] = os.getenv("LANGCHAIN_API_KEY")
# os.environ["LANGCHAIN_TRACING_V2"] = "true"
# os.environ["LANGCHAIN_PROJECT"] = os.getenv("LANGCHAIN_PROJECT")

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

chain=prompt|model

with_message_history=RunnableWithMessageHistory(
    chain,
    get_session_history,
    input_messages_key="messages"
)
config = {"configurable": {"session_id": "chat1"}}

app = Flask(_name_)

@app.route('/chat', methods=['POST'])
def chat():
    data = request.json
    session_id = "chat1"
    user_input = data.get("message")
    
    def generate_response(question):
        response=with_message_history.invoke(
            {'messages': [HumanMessage(question)]},
            config=config)
        return response.content

    response = generate_response(user_input)
    return jsonify({"response": response})

if _name_ == '_main_':
    app.run(debug=True)
