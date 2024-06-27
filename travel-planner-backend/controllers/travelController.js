import { OpenAI } from 'openai';
import { config } from 'dotenv';
import TravelPlan from '../models/TravelPlan.js';


config();

const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });
const model = process.env.MODEL;


export async function getTravelPlans(req, res) {
    const { username } = req.query;

    if (!username) {
        return res.status(400).send('Username is required');
    }

    try {
        const travelPlans = await TravelPlan.find({ username: username });
        res.json(travelPlans);
    } catch (error) {
        console.error(error);
        res.status(500).send('Error fetching travel plans');
    }
}

export async function deleteTravelPlan(req, res) {
    const { _id } = req.body;
    try {
        await TravelPlan.findByIdAndDelete(_id);
        console.log('delete success.');
        res.status(200).send('Travel plan deleted successfully');
    } catch (error) {
        console.error(error);
        res.status(500).send('Error deleting travel plan');
    }
}
export async function generateTravelPlan(req, res) {
    console.log('start generate.');
    const { username, budget, travelDays, numberOfPeople, selectedCountry, customLocation } = req.body;

    const locationText = customLocation.length > 0 ? `感興趣的地點包括${customLocation.join('、')}。` : '沒有特定的感興趣地點。';

    const text = `預算為${budget}(TWD)，旅遊天數為${travelDays}天，同行人數為${numberOfPeople}人，選擇的國家是${selectedCountry}，${locationText}`;

    const prompt = [
        {
            "role": "system",
            "content": "你是一個智能旅遊規劃助手，根據以下輸入的預算、天數、人數、國家和感興趣的地點(可選)，生成旅行計劃，預算只有參考，需要詳細指定旅遊的目的地點，不需要任何禮貌性的詞語、不需要預設出發的地點、不需要計算或是換算當地的幣值。"
        },
        {
            "role": "user",
            "content": text
        }
    ];

    try {
        const response = await openai.chat.completions.create({
            model: model,
            messages: prompt,
            temperature: 0.9,
            max_tokens: 1024,
            top_p: 0.75,
            frequency_penalty: 0,
            presence_penalty: 0,
            stop: null,
        });

        const responseMessage = response.choices[0].message.content;
        console.log('responseMessage:', responseMessage);
        const functionResponse = await handleFunctionCall(responseMessage);
        console.log('functionResponse:', functionResponse);

        const newTravelPlan = new TravelPlan({
            username,
            travelSuggestions: responseMessage,
            travelPlan: functionResponse,
        });
        await newTravelPlan.save();

        res.json({ travelSuggestions: responseMessage, travelPlan: functionResponse });

    } catch (error) {
        console.error(error);
        res.status(500).send('Error generating travel plan');
    }
}

async function handleFunctionCall(planText) {
    const prompt = [
        {
            "role": "system",
            "content": "你是一個智能旅遊規劃助手，根據以下旅行計劃文本，解析並生成行程安排，包括每天的行程、詳細的行程目的地點。"
        },
        {
            "role": "user",
            "content": planText
        }
    ];

    const functions = [
        {
            "name": "parse_travel_plan",
            "description": "解析旅行計劃文本，生成詳細的行程安排，包括每天的行程、詳細的行程目的地點。",
            "parameters": {
                "type": "object",
                "properties": {
                    "days": {
                        "type": "array",
                        "items": {
                            "type": "object",
                            "properties": {
                                "day": {
                                    "type": "integer",
                                    "description": "行程的天數"
                                },
                                "activities": {
                                    "type": "array",
                                    "items": {
                                        "type": "string",
                                        "description": "當天的行程活動"
                                    },
                                    "description": "當天的行程活動列表"
                                },
                                "destinations": {
                                    "type": "array",
                                    "items": {
                                        "type": "string",
                                        "description": "當天的行程詳細目的地點"
                                    },
                                    "description": "當天的行程詳細目的地點列表"
                                }
                            }
                        }
                    }
                },
                "required": ["day", "activities"]
            }
        }
    ];

    const response = await openai.chat.completions.create({
        model: model,
        messages: prompt,
        temperature: 0.95,
        max_tokens: 1024,
        top_p: 0.75,
        frequency_penalty: 0,
        presence_penalty: 0,
        stop: null,
        functions: functions,
        function_call: { "name": "parse_travel_plan" }
    });

    const responseMessage = response.choices[0].message;

    if (responseMessage.function_call) {
        return JSON.parse(responseMessage.function_call.arguments);
    } else {
        throw new Error('Error: No function call found in response.');
    }
}