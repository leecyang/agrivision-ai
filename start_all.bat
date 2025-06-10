@echo off

REM 启动后端
echo Starting backend...
start cmd /k "cd pest-recognition-backend && mvn spring-boot:run"

REM 等待后端启动 (可以根据实际情况调整等待时间)
ping 127.0.0.1 -n 5 > nul

REM 启动前端
echo Starting frontend...
start cmd /k "cd pest-recognition-frontend && npm run serve"

echo Frontend and backend services are starting in separate windows.
echo Close the respective windows to stop the services.