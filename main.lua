paddleWidth = 100
paddleHeight = 20

function resetBall()
    ballX = x + paddleWidth / 2
    ballY = y - radius
    ballSpeedY = -math.abs(ballSpeedY)
end

function love.load()
    gameState = "start"
    level = 1
    blockWidth = 60
    blockHeight = 20
    loadLevel(level)
    lives = 3
    score = 0
    x = 50
    y = love.graphics.getHeight() - paddleHeight - 10

    ballX = 52
    ballSpeedX = 100
    ballY = 10
    ballSpeedY = 100
    radius = 10
    
end


function loadLevel(level)
    blocks = {}
    local rows = 2 + level
    for row = 1, rows do
        for col = 1, 10 do
            local block = {
                x = (col - 1) * (blockWidth + 5) + 30,
                y = row * (blockHeight + 5),
                hit = false
            }
            table.insert(blocks, block)
        end
    end
end

function love.update(dt)
    if gameState ~= "playing" then
        return
    end
    if ballY + radius >= y and ballY + radius <= y + paddleHeight and
       ballX + radius >= x and ballX - radius <= x + paddleWidth then
        ballSpeedY = -ballSpeedY
        ballY = y - radius
    end

    for _, block in ipairs(blocks) do
        if not block.hit and
            ballX + radius > block.x and
            ballX - radius < block.x + blockWidth and
            ballY + radius > block.y and
            ballY - radius < block.y + blockHeight then

            block.hit = true
            ballSpeedY = -ballSpeedY
            score = score + 10
        end
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
        lives = lives - 1
        if lives <= 0 then
            gameState = "lose"
        else
            resetBall()
        end
    end

    if love.keyboard.isDown("left") then
        x = x - 200 * dt
        if x < 0 then x = 0 end
    elseif love.keyboard.isDown("right") then
        x = x + 200 * dt
        if x > love.graphics.getWidth() - paddleWidth then
            x = love.graphics.getWidth() - paddleWidth
        end
    end

    local allHit = true
    for _, block in ipairs(blocks) do
        if not block.hit then
            allHit = false
            break
        end
    end

    if allHit then
        level = level + 1
        loadLevel(level)
        resetBall()
        gameState = "start"
    end
end


function love.draw()
    if gameState == "start" then
        love.graphics.print("Press SPACE to start", 10, 10)

    elseif gameState == "playing" then
        love.graphics.print("Lives: " .. lives, 10, 30)
        love.graphics.print("Score: " .. score, 10, 50)
        love.graphics.rectangle("fill", x, y, paddleWidth, paddleHeight)
        love.graphics.circle("fill", ballX, ballY, radius)
        for _, block in ipairs(blocks) do
            if not block.hit then
                love.graphics.rectangle("fill", block.x, block.y, blockWidth, blockHeight)
            end
        end

    elseif gameState == "win" then
        love.graphics.print("YOU WIN! Press R to restart", 10, 10)

    elseif gameState == "lose" then
        love.graphics.print("GAME OVER! Press R to restart", 10, 10)
    end

    if gameState == "paused" then
        love.graphics.printf("PAUSED\nDruk ESC om verder te gaan", 0, love.graphics.getHeight()/2 - 30, love.graphics.getWidth(), "center")
    end
end

function love.keypressed(key)
    if gameState == "start" and key == "space" then
        gameState = "playing"
    elseif (gameState == "win" or gameState == "lose") and key == "r" then
        love.load()
    elseif gameState == "playing" and key == "escape" then
        gameState = "paused"
    elseif gameState == "paused" and key == "escape" then
        gameState = "playing"
    end
end