import express from "express";
import bodyParser from "body-parser";
import pg from "pg";
import cors from "cors";

const app = express();
const PORT = 3000;

// Database configuration
const db = new pg.Client({
    user: "postgres",
    host: "localhost",
    database: "postgres",
    password: "chanmass",
    port: 5432,
});

// Connect to the database
db.connect(err => {
    if (err) {
        console.error('Connection error', err.stack);
    } else {
        console.log('Connected to the database');
    }
});

// Middleware setup
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(express.static("public"));
app.use(cors({
    origin: '*',
}));

// Login endpoint
app.post("/login", async (req, res) => {
    const { email, password } = req.body;
    console.log(`Email: ${email}, Password: ${password}`);

    try {
        const result = await db.query('SELECT * FROM users WHERE email = $1', [email]);
        if (result.rows.length === 0) {
            console.log('User not found');
            return res.status(400).json({ error: 'User not found' });
        }
        const user = result.rows[0];
        const isMatch = password === user.password; // Direct comparison for testing
        if (!isMatch) {
            console.log('Invalid credentials');
            return res.status(400).json({ error: 'Invalid credentials' });
        }
        console.log('Login successful');
        res.status(200).json({ message: 'Login successful' });
    } catch (err) {
        console.error('Error during login:', err.message);
        res.status(500).json({ error: err.message });
    }
});

// Add message endpoint
app.post("/messages", async (req, res) => {
    const { sender, message } = req.body;
    console.log(`Sender: ${sender}, Message: ${message}`);

    try {
        await db.query('INSERT INTO messages (sender, message, created_at) VALUES ($1, $2, NOW())', [sender, message]);
        console.log('Message added successfully');
        res.status(201).json({ message: 'Message added successfully' });
    } catch (err) {
        console.error('Error adding message:', err.message);
        res.status(500).json({ error: err.message });
    }
});

// Get messages endpoint
app.get("/messages", async (req, res) => {
    try {
        const result = await db.query('SELECT * FROM messages ORDER BY created_at DESC');
        console.log('Fetched messages:', result.rows);
        res.status(200).json(result.rows);
    } catch (err) {
        console.error('Error fetching messages:', err.message);
        res.status(500).json({ error: err.message });
    }
});

// Start server
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
