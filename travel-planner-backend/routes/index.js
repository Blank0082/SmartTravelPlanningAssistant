// routes/index.js
import { Router } from 'express';
const router = Router();

import { registerUser, loginUser } from '../controllers/userController.js';
import { getTravelPlans, deleteTravelPlan, generateTravelPlan } from '../controllers/travelController.js';

router.get('/', (req, res) => {
  res.send('Welcome to the Travel Planner API!');
});
router.post('/generateTravelPlan', generateTravelPlan);
router.get('/getTravelPlans', getTravelPlans);
router.post('/register', registerUser);
router.post('/login', loginUser);
router.post('/deleteTravelPlan', deleteTravelPlan);

export default router;
