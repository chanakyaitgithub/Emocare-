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
  - [Target Audience](#target-audience)
  - [Revenue Strategy](#revenue-strategy)
  - [Contributions](#contributions)
  - [FOSS Community Contributions](#foss-community-contributions)
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
    git clone https://github.com/chanakyaitgithub/emocare-.git
    ```
    
2. Navigate to the project directory:
    ```sh
    cd emocare-
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
5. For NLP model which is done using tensorflow , download the dataset from https://github.com/Jcharis/end2end-nlp-project/tree/main/data there will be the original dataset note that if it not works try using this link https://www.kaggle.com/datasets/chanakyar/emotion-dataset-link and run the ipynb code with your prefered file location for loading the dataset.

### 5. Set up PostgreSQL:

1. **Follow PostgreSQL setup instructions:**
   - Refer to the [PostgreSQL installation tutorial](https://www.postgresql.org/docs/current/tutorial-install.html) to install PostgreSQL on your system.

2. **Configure the connection in the application settings:**
   - Configure the database connection in your application settings file (e.g., `settings.py` for a Django application, `config.js` for a Node.js application, etc.).

3. **Create a table named `user` with `email` and `password` as text parameters:**
   - Use the following SQL code to create the `user` table:
     ```sql
     CREATE TABLE user (
         id SERIAL PRIMARY KEY,
         email TEXT UNIQUE NOT NULL,
         password TEXT NOT NULL
     );
     ```
  - insert users using
    ```sql
    INSERT INTO user (email, password)
    VALUES ('user email', 'user password');
    ```
4. **Create a table named `messages` with `sender` and `message` as text inputs and `created_at` as a timestamp:**
   - Use the following SQL code to create the `messages` table:
     ```sql
     CREATE TABLE messages (
         id SERIAL PRIMARY KEY,
         sender TEXT NOT NULL,
         message TEXT NOT NULL,
         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
     );
     ```

### Description of the tables:

- **user table:**
  - `id SERIAL PRIMARY KEY`: An auto-incrementing unique identifier for each user.
  - `email TEXT UNIQUE NOT NULL`: The email address of the user, which must be unique and cannot be null.
  - `password TEXT NOT NULL`: The password of the user, which cannot be null.

- **messages table:**
  - `id SERIAL PRIMARY KEY`: An auto-incrementing unique identifier for each message.
  - `sender TEXT NOT NULL`: The sender of the message, which cannot be null.
  - `message TEXT NOT NULL`: The content of the message, which cannot be null.
  - `created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP`: The timestamp when the message was created, with the default value set to the current time.



7. Install Ollama by following the instructions on the [Ollama website](https://ollama.com).

8. Download and run the Mistral model:
    ```sh
    ollama run mistral
    ```

9. Run the Node.js server:
    ```sh
    node server.js
    ```

10. Run the Flask server:
    ```sh
    python nlpflask.py
    ```

11 Download and install flutter with the following instructions:
    ->download flutter sdk
    ->set path in environment variables(settings)
    ->Install Android Studio from website
    ->Download command line tools from android studio.
    -> Accept Licences.
    -> Install flutter and dart pluggins

    
12. Installing Flutter with VS Code:
    1. Download Flutter SDK from the official website.
    2. Extract the downloaded file and add the flutter/bin directory to your system's PATH.
    3. Install Visual Studio Code from the official website.
    4. Install the Flutter extension in VS Code:
        - Open VS Code.
        - Go to Extensions (Ctrl+Shift+X).
        - Search for 'Flutter' and click 'Install'.
    5. Install the Dart extension in VS Code:
        - Go to Extensions (Ctrl+Shift+X).
        - Search for 'Dart' and click 'Install'.
    6. Open a terminal in VS Code and run:
        ```sh
        flutter doctor
        ```
        - Follow any additional setup instructions provided by `flutter doctor`.
    
13. Navigate to the Flutter project directory and run the app:
    ```sh
    cd flutter_app
    flutter pub get
    flutter run
    ```
14. Add the pictures in the 'fan' folder to the file 'pubspec.yaml' under assets section.


## Usage

1. Open the app and sign in using your credentials.
2. Utilize the chat feature for seamless communication with colleagues.
3. Leverage the AI chatbot for emotional support, professional paraphrasing suggestions and displaying memes.
4. Monitor mood analysis and emotion tracking through the intuitive dashboard.


### Screenshots

Below are some examples of Emocare in action:

![Screenshot 2024-07-28 075522](https://github.com/user-attachments/assets/af2fe1e2-519e-4151-a34b-a374ec8fc2bc)


The User Login Page provides a streamlined access point to the application.

![Screenshot 2024-07-28 075557](https://github.com/user-attachments/assets/7b2e5c93-e85e-47c5-a388-bccc0d25aee1)

The Features screen highlights the core functionalities of Emocare.

![Screenshot 2024-07-28 075904](https://github.com/user-attachments/assets/b73d4fa1-ed1b-4a77-afe3-e65db59efbde)

The Group Chat Interface facilitates team collaboration.

![Screenshot 2024-07-28 075924](https://github.com/user-attachments/assets/b8ea266f-17de-440e-aa42-5f462271ec60)

Detailed emotion metrics and analytics offer insights into emotional trends and patterns.

![Screenshot 2024-07-28 080022](https://github.com/user-attachments/assets/9f14f32b-14c8-4b72-8894-4791bc2a14d2)

The Chat Interface demonstrates the integration of the AI chatbot, enhancing user interaction.

![Screenshot 2024-07-28 080339](https://github.com/user-attachments/assets/f37c0a9d-ea26-4d4c-909d-3f99f2402b83)

A page dedicated to uplifting content, such as memes, designed to enhance user mood.

![Screenshot 2024-07-28 080506](https://github.com/user-attachments/assets/183321b7-0de0-4de4-a4ee-2b5cbe883049)

Evaluating text to paraphrase allows for refining communication in real-time.

![Screenshot 2024-07-28 080549](https://github.com/user-attachments/assets/53d461c1-ad98-4d0e-a095-e85864ef7c21)

The Paraphrasing Tool assists in modulating the tone of chat messages to foster positive dialogue.


## Technologies Used

- Machine Learning: TensorFlow, Scikit-Learn, Mistral 7B
- Backend: Flask (for hosting sentiment analysis, paraphrasing, and LLM models), Node.js (for hosting PostgreSQL database)
- Frontend: Flutter
- Database and Authentication: PostgreSQL


## Target Audience

- HR Departments: Enhance employee well-being and communication.
- Team Leaders and Organizations: Improve team dynamics and support by managing conflict and stress in the workplace.
- Tech-savvy Professionals: Utilize AI-driven solutions for workplace enhancement.


## Contributions

Contributions are welcome! To contribute code::

1. Fork the repository.
2. Create a new branch (git checkout -b feature-branch).
3. Make your modifications.
4. Commit your changes (git commit -m 'Add some feature').
5. Push to your branch (git push origin feature-branch).
6. Open and submit a pull request.


## FOSS Community Contributions

1. Code contributions (as mentioned above) to help improve core functionalities and features
2. Test existing features and provide insights for model training to improve user experience
3. Help in design of UI/UX with the help of user research and to help with front end optimisation.
4. Create an Issue Tracker forum with the expansion of the product's features and user base
5. Organize workshops or engage in raising awareness about the product
6. Write tutorials and example usage for the project
 

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE.txt) file for details.


## Contact

For inquiries or suggestions, please reach out:

- *Name:* Chanakya R
- *Email:* chanakya7707@gmail.com
- *GitHub:* [chanakyaitgithub](https://github.com/chanakyaitgithub)
