import { connect } from 'mongoose';
import { config } from 'dotenv';

config();

const connectDB = async () => {
  try {
    await connect(process.env.MONGO_URI);
    console.log('MongoDB was connected.');
  } catch (err) {
    console.error(err.message);
    process.exit(1);
  }
};

export default connectDB;
