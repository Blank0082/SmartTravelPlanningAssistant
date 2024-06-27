import { Schema, model } from 'mongoose';

const DaySchema = new Schema({
  day: {
    type: Number,
    required: true,
  },
  activities: {
    type: [String],
    required: true,
  },
  destinations: {
    type: [String],
    required: true,
  },
});

const TravelPlanSchema = new Schema({
  username: {
    type: String,
    required: true,
  },
  travelSuggestions: {
    type: String,
    required: true,
  },
  travelPlan: {
    days: {
      type: [DaySchema],
      required: true,
    },
  },
});

export default model('TravelPlan', TravelPlanSchema);
