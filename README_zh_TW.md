# 智能旅遊規劃助手

## 概述

智能旅遊規劃助手是一個使用 Flutter 開發的跨平台移動應用程序。
它提供智能旅遊規劃功能，允許用戶輸入預算、旅行天數、人數、國家和特定感興趣的地點。
該應用會生成個性化的旅行計劃，並為用戶提供最佳的旅行路線和時間。
它還集成了 Google 地圖以顯示位置。

## 使用技術

- **前端**: Flutter 3.22.2
- **後端**: Node.js v20.9.0, Express.js
- **數據庫**: MongoDB

## 功能

1. 用戶認證: 允許用戶創建帳號和登錄。
2. 輸入旅行需求: 用戶可以輸入預算、旅行天數、人數、國家和感興趣的地點。
3. 旅行計劃生成: 根據輸入數據，後端使用 GPT-4o 模型生成個性化旅行計劃。
4. Google 地圖集成: 在地圖上顯示位置和旅行路線。
5. 計劃調整: 用戶可以自由添加或移除計劃中的地點。

### 先決條件

#### 克隆倉庫:

   ```
   git clone https://github.com/Blank0082/SmartTravelPlanningAssistant.git
   cd SmartTravelPlanningAssistant
   ```

### 前端設置

1. 進入前端目錄:

   ```
   cd my_travel_app
   ```

2. 在前端目錄中創建一個 .env 文件，內容如下:

   ```
   BACKEND_API_URL=your_backend_url
   ```

3. 安裝 Flutter 依賴:

   ```
   flutter pub get
   ```

4. 運行應用:

   ```
   flutter run
   ```

### 後端設置

1. 進入後端目錄:

   ```
   cd travel-planner-backend
   ```

2. 安裝 Node.js 依賴:

   ```
   npm install
   ```

3. 在後端目錄中創建一個 .env 文件，內容如下:

   ```
   MODEL=gpt-4o
   OPENAI_API_KEY=your_openai_api_key
   PORT=5000
   MONGO_URI=your_mongodb_uri
   ```

4. 啟動後端服務器:

   ```
   npm start
   ```

## 使用方法

1. 在您的移動設備或模擬器上打開應用。
2. 創建帳號或登錄。
3. 輸入您的旅行需求並提交。
4. 查看生成的旅行計劃。
5. 根據需要調整旅行計劃。