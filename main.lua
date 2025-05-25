paddleWidth = 100
paddleHeight = 20

function love.load()
    gameState = "start"
    x = 50
    y = love.graphics.getHeight() - paddleHeight - 10

    ballX = 52
    ballSpeedX = 100
    ballY = 10
    ballSpeedY = 100
    radius = 10
end

function love.update(dt)
    if gameState == "playing" then
        -- Paddle collision
        if ballY + radius >= y and ballY + radius <= y + paddleHeight and
           ballX + radius >= x and ballX - radius <= x + paddleWidth then
            ballSpeedY = -ballSpeedY
            ballY = y - radius  -- Position the ball above the paddle
        end
        ballX = ballX + ballSpeedX * dt
        ballY = ballY + ballSpeedY * dt
        if ballX < 0 or ballX > love.graphics.getWidth() - radius then
            ballSpeedX = -ballSpeedX
        end
        if ballY < 0 then
            ballSpeedY = -ballSpeedY
        end
        if ballY > love.graphics.getHeight() then
            gameState = "lose"
        end
        if love.keyboard.isDown("left") then
            x = x - 200 * dt
            if x < 0 then
                x = 0
            end
        elseif love.keyboard.isDown("right") then
            x = x + 200 * dt
            if x > love.graphics.getWidth() - paddleWidth then
                x = love.graphics.getWidth() - paddleWidth
            end
        end
    end
end


function love.draw()
    if gameState == "start" then
        love.graphics.print("Press SPACE to start", 10, 10)

    elseif gameState == "playing" then
        love.graphics.rectangle("fill", x, y, paddleWidth, paddleHeight)
        love.graphics.circle("fill", ballX, ballY, radius)

    elseif gameState == "win" then
        love.graphics.print("YOU WIN! Press R to restart", 10, 10)

    elseif gameState == "lose" then
        love.graphics.print("GAME OVER! Press R to restart", 10, 10)
    end
end

function love.keypressed(key)
    if gameState == "start" and key == "space" then
        gameState = "playing"
    elseif (gameState == "win" or gameState == "lose") and key == "r" then
        love.load()
    end
end