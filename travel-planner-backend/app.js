import express, { json } from 'express';
import connectDB from './config/db.js';
import routes from './routes/index.js';
import { config } from 'dotenv';

config();

const app = express();

connectDB();

const PORT = process.env.PORT || 5000;

app.use(json());
app.use('/api', routes);

app.get('/', (req, res) => {
    res.send('Welcome to the API!');
  });

app.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}`);
});
