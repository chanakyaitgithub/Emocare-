# Emocare+

To create a productive and supportive workplace, we are implementing AI-driven tools for emotion and stress management. Leveraging artificial general intelligence (AGI), our approach includes Emocare, a personalized AI chatbot designed to manage emotions and stress, and a workplace chat app that screens emotions, analyzes moods, and detects emotionally charged conversations. Additionally, we offer a chat paraphrasing tool to help modulate tone and intent in professional communication. Emocare ensures user privacy and data protection with proper certifications. It calculates mean emotion values over time for proactive support, provides calming content like memes and videos, and promotes positive dialogue to reduce conflicts.

## Table of Contents

- [Emocare](#emocare)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Features](#features)
    - [1. Emotion Calculation](#1-emotion-calculation)
    - [2. Personalized Chatbot and Chat App](#2-personalized-chatbot-and-chat-app)
    - [3. Emotional Check and Paraphrasing](#3-emotional-check-and-paraphrasing)
    - [4. Group Chat Management](#4-group-chat-management)
  - [Installation](#installation)
    - [Prerequisites](#prerequisites)
    - [Steps](#steps)
  - [Usage](#usage)
  - [Technologies Used](#technologies-used)
  - [Target Market](#target-market)
  - [Revenue Strategy](#revenue-strategy)
  - [Contributing](#contributing)
  - [License](#license)
  - [Contact](#contact)

## Introduction

Emocare+ is a workplace chatting app equipped with advanced AI capabilities for emotion screening, mood analysis, and chat paraphrasing. It aims to improve employee well-being and communication by providing real-time emotional support and feedback.

## Features

### 1. Emotion Detection
- Calculate mean emotion values for individuals over time.
- Showcase proactive support and personalized interventions.

### 2. Personalized Chatbot and Chat App
- AI-driven chatbot automatically responds to emotions.
- Enhances user experience and emotional well-being.

### 3. Emotion Regulation and Paraphrasing
- Detects and addresses emotionally charged conversations.
- Promotes positive dialogue and reduces conflict through paraphrasing.
- Paraphrasing tool detects the emotion in a sentence and rephrases it.

### 4. Group Chat Management
- Supports group chats for team collaboration.
- Paraphrasing tool helps in modulating tone in group chats to limit conflict in the workspace.
- Provides real-time feedback to reduce conflicts and improve communication.

## Installation

### Prerequisites

- Python 3.7+
- Flutter SDK
- PostgreSQL account
- Node.js
- Virtual environment (optional but recommended)

### Steps

1. Clone the repository:
    ```sh
    git clone https://github.com/yourusername/emocare-plus.git
    ```
    
2. Navigate to the project directory:
    ```sh
    cd emocare-plus
    ```
    
3. Create and activate a virtual environment:
    ```sh
    python -m venv venv
    source venv/bin/activate  # On Windows use `venv\Scripts\activate`
    ```
    
4. Install the required packages:
    ```sh
    pip install -r requirements.txt
    ```

5. Set up PostgreSQL:
    - Follow [PostgreSQL setup instructions](https://www.postgresql.org/docs/current/tutorial-install.html).
    - Configure the connection in the application settings.

6. Install Ollama by following the instructions on the [Ollama website](https://ollama.com).

7. Download and run the Mistral model:
    ```sh
    ollama run mistral
    ```

8. Run the Node.js server:
    ```sh
    node server.js
    ```

9. Run the Flask server:
    ```sh
    python nlpflask.py
    ```

10. Navigate to the Flutter project directory and run the app:
    ```sh
    cd flutter_app
    flutter pub get
    flutter run
    ```

## Usage

1. Open the app and sign in using your credentials.
2. Utilize the chat feature for seamless communication with colleagues.
3. Leverage the AI chatbot for emotional support, professional paraphrasing suggestions and displaying memes.
4. Monitor mood analysis and emotion tracking through the intuitive dashboard.

### Screenshots

Below are some examples of Emocare in action:

![ec1](https://github.com/user-attachments/assets/5e0aa4a5-b7f0-4f5d-bb1f-25149b7fa741)

The User Login Page provides a streamlined access point to the application.

![ec2](https://github.com/user-attachments/assets/530b2491-39a5-4259-b033-1dbe08647f86)

The Features screen highlights the core functionalities of Emocare.

![ec3](https://github.com/user-attachments/assets/89c30969-b50e-4ffb-a751-47e26a28e83b)

The Group Chat Interface facilitates team collaboration.

![ec4](https://github.com/user-attachments/assets/6d478040-5094-41ec-adb7-177a8820b0ed)

Detailed emotion metrics and analytics offer insights into emotional trends and patterns.

![ec5](https://github.com/user-attachments/assets/ce36907b-b278-4f9d-a017-2235aec0ad48)

The Chat Interface demonstrates the integration of the AI chatbot, enhancing user interaction.

![ec6](https://github.com/user-attachments/assets/d67430cd-3be8-409f-abec-ad89c2e4e3cb)

A page dedicated to uplifting content, such as memes, designed to enhance user mood.

![ec11](https://github.com/user-attachments/assets/48a5de6c-6a88-42a1-ae2c-9f4388885ab2)

Evaluating text to paraphrase allows for refining communication in real-time.

![ec9](https://github.com/user-attachments/assets/65238944-bd06-4b4a-a4bb-463cafc71ea2)

The Paraphrasing Tool assists in modulating the tone of chat messages to foster positive dialogue.

## Technologies Used

- *Machine Learning:* TensorFlow, Scikit-Learn, Mistral 7B
- *Backend:* Flask (for hosting sentiment analysis, paraphrasing, and LLM models), Node.js (for hosting PostgreSQL database)
- *Frontend:* Flutter
- *Database and Authentication:* PostgreSQL

## Target Market

- *HR Departments:* Enhance employee well-being and communication.
- *Team Leaders and Organizations:* Improve team dynamics and support.
- *Tech-savvy Professionals:* Utilize AI-driven solutions for workplace enhancement.

## Revenue Strategy

- *Subscription-based Model:* Organizations are billed based on user and conversation volume.
- *Partnerships:* Explore collaborations with HR consulting firms and wellness programs for enterprise adoption.

## Contributing

Contributions are welcomed! To contribute:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Make your modifications.
4. Commit your changes (`git commit -m 'Add some feature'`).
5. Push to your branch (`git push origin feature-branch`).
6. Open a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE.txt) file for details.

## Contact

For inquiries or suggestions, please reach out:

- *Name:* Chanakya R
- *Email:* chanakya7707@gmail.com
- *GitHub:* [chanakyaitgithub](https://github.com/chanakyaitgithub)
