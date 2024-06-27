import { hash, compare } from 'bcrypt';
import User from '../models/User.js';


export async function registerUser(req, res) {
  console.log('Registering user:', req.body);
  const { username, password } = req.body;
  try {
    const existingUser = await User.findOne({ username });
    if (existingUser) {
      console.log('Username already exists');
      return res.status(400).json({ error: '用戶名已存在' });
    }
    const hashedPassword = await hash(password, 10);
    const newUser = new User({ username, password: hashedPassword });
    await newUser.save();
    console.log('User registered:', newUser);
    res.status(200).json({ username: newUser.username });
  } catch (error) {
    console.error('Error registering user:', error);
    res.status(500).json({ error: 'Error registering user' });
  }
}

export async function loginUser(req, res) {
  console.log('Logging in user:', req.body);
  const { username, password } = req.body;
  try {
    const user = await User.findOne({ username });
    if (user && await compare(password, user.password)) {
      console.log('User logged in:', user);
      res.status(200).json({ username: user.username });
    } else {
      console.log('Invalid credentials');
      res.status(401).json({ error: 'Invalid credentials' });
    }
  } catch (error) {
    console.error('Error logging in user:', error);
    res.status(500).json('Error logging in user:', error);
  }
}

