# SmartTravelPlanningAssistant

## Overview

SmartTravelPlanningAssistant is a cross-platform mobile application developed using Flutter.
It offers intelligent travel planning features, allowing users to input their budget, travel days, number of people, country, and specific places of interest.
The app generates personalized travel plans and provides users with optimal travel routes and times.
It also integrates Google Maps for location display.

## Technologies Used

- **Frontend**: Flutter 3.22.2
- **Backend**: Node.js v20.9.0, Express.js
- **Database**: MongoDB

## Features

1. User Authentication: Allows users to create accounts and login.
2. Input Travel Requirements: Users can enter their budget, travel days, number of people, country, and places of interest.
3. Travel Plan Generation: Based on the input data, the backend generates personalized travel plans using GPT-4o models.
4. Google Maps Integration: Displays locations and travel routes on a map.
5. Plan Adjustment: Users can freely add or remove places from the plan.

## Installation

### Prerequisites

##### clone repository

   ```
   git clone https://github.com/Blank0082/SmartTravelPlanningAssistant.git
   cd SmartTravelPlanningAssistant
   ```

### Frontend Setup

1.  Navigate to the frontend directory:

   ```
   cd my_travel_app
   ```

2. Create a .env file in the backend directory with the following content:

   ```
   BACKEND_API_URL=your_backend_url
   ```

3. Install Flutter dependencies:

   ```
   flutter pub get
   ```

4. Run the app:

   ```
   flutter run
   ```

### Backend Setup

1. Navigate to the backend directory:

   ```
   cd travel-planner-backend
   ```

2. Install Node.js dependencies:

   ```
   npm install
   ```

3. Create a .env file in the backend directory with the following content:

   ```
   MODEL=gpt-4o
   OPENAI_API_KEY=your_openai_api_key
   PORT=5000
   MONGO_URI=your_mongodb_uri
   ```

4. Start the backend server:

   ```
   npm start
   ```

## Usage

1. Open the app on your mobile device or emulator.
2. Create an account or login.
3. Enter your travel requirements and submit.
4. View the generated travel plan.
5. Adjust the travel plan as needed.
