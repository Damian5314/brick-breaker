paddleWidth = 100
paddleHeight = 20
radius = 10

function resetBall()
    balls = {
        {
            x = x + paddleWidth / 2,
            y = y - radius,
            speedX = 100,
            speedY = -100
        }
    }
end

function love.load()
    defaultFont = love.graphics.newFont(14)
    titleFont = love.graphics.newFont(32)
    gameState = "start"
    level = 1
    blockWidth = 60
    blockHeight = 20
    lives = 3
    score = 0
    x = 50
    y = love.graphics.getHeight() - paddleHeight - 10
    upgrades = {}
    upgradeTypes = { "biggerPaddle", "fasterBall", "rowDestroy", "extraLife", "multiball" }

    loadLevel(level)
    resetBall()
end

function loadLevel(level)
    blocks = {}
    local rows = 2 + level
    local blockTypes = { "normal", "hard", "unbreakable" }
    for row = 1, rows do
        for col = 1, 10 do
            local blockType = blockTypes[math.random(#blockTypes)]
            local block = {
                x = (col - 1) * (blockWidth + 5) + 30,
                y = 120 + row * (blockHeight + 5),
                type = blockType,
                hit = false,
                health = blockType == "hard" and 2 or 1
            }
            table.insert(blocks, block)
        end
    end
end

function love.update(dt)
    if gameState ~= "playing" then return end

    for i, ball in ipairs(balls) do
        ball.x = ball.x + ball.speedX * dt
        ball.y = ball.y + ball.speedY * dt

        if ball.x < 0 or ball.x > love.graphics.getWidth() - radius then
            ball.speedX = -ball.speedX
        end
        if ball.y < 0 then
            ball.speedY = -ball.speedY
        end

        if ball.y + radius >= y and ball.y + radius <= y + paddleHeight and
           ball.x + radius >= x and ball.x - radius <= x + paddleWidth then
            ball.speedY = -math.abs(ball.speedY)
            ball.y = y - radius
        end

        for _, block in ipairs(blocks) do
            if not block.hit and
                ball.x + radius > block.x and
                ball.x - radius < block.x + blockWidth and
                ball.y + radius > block.y and
                ball.y - radius < block.y + blockHeight then

                if block.type ~= "unbreakable" then
                    block.health = block.health - 1
                    if block.health <= 0 then
                        block.hit = true
                        score = score + 10

                        if math.random() < 0.2 then
                            table.insert(upgrades, {
                                x = block.x + blockWidth / 2,
                                y = block.y,
                                type = upgradeTypes[math.random(#upgradeTypes)],
                                active = true
                            })
                        end
                    end
                end

                ball.speedY = -ball.speedY
            end
        end

        if ball.y > love.graphics.getHeight() then
            table.remove(balls, i)
            if #balls == 0 then
                lives = lives - 1
                if lives <= 0 then
                    gameState = "lose"
                else
                    resetBall()
                end
            end
        end
    end

    for _, upgrade in ipairs(upgrades) do
        if upgrade.active then
            upgrade.y = upgrade.y + 100 * dt
            if upgrade.y > y and upgrade.y < y + paddleHeight and
                upgrade.x > x and upgrade.x < x + paddleWidth then
                applyUpgrade(upgrade.type)
                upgrade.active = false
            end
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
        if block.type ~= "unbreakable" and not block.hit then
            allHit = false
            break
        end
    end

    if allHit then
        gameState = "win"
    end
end

function love.draw()
    love.graphics.clear(0.05, 0.05, 0.05)
    love.graphics.setColor(0.15, 0.15, 0.15)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), 100)

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(defaultFont)
    love.graphics.print("Lives: " .. lives, 10, 30)
    love.graphics.print("Score: " .. score, 10, 50)
    love.graphics.print("Level: " .. level, 10, 70)

    if gameState == "start" then
        love.graphics.setFont(titleFont)
        love.graphics.printf("Press SPACE to start", 0, love.graphics.getHeight() / 2 - 40, love.graphics.getWidth(), "center")

    elseif gameState == "playing" then
        love.graphics.setColor(0.2, 0.6, 1)
        love.graphics.rectangle("fill", x, y, paddleWidth, paddleHeight, 10, 10)

        for _, ball in ipairs(balls) do
            love.graphics.setColor(1, 0.8, 0.2)
            love.graphics.circle("fill", ball.x, ball.y, radius)
        end

        for _, block in ipairs(blocks) do
            if not block.hit then
                if block.type == "normal" then
                    love.graphics.setColor(0.2, 0.6, 1)
                elseif block.type == "hard" then
                    love.graphics.setColor(1, 0.4, 0.2)
                elseif block.type == "unbreakable" then
                    love.graphics.setColor(0.5, 0.5, 0.5)
                end
                love.graphics.rectangle("fill", block.x, block.y, blockWidth, blockHeight, 5, 5)

                if block.type == "hard" then
                    love.graphics.setColor(1, 1, 1)
                    love.graphics.setFont(defaultFont)
                    love.graphics.printf(tostring(block.health), block.x, block.y + 2, blockWidth, "center")
                end
            end
        end

        for _, upgrade in ipairs(upgrades) do
            if upgrade.active then
                if upgrade.type == "biggerPaddle" then
                    love.graphics.setColor(0, 0.8, 1)
                elseif upgrade.type == "fasterBall" then
                    love.graphics.setColor(1, 0.5, 0)
                elseif upgrade.type == "rowDestroy" then
                    love.graphics.setColor(0.9, 0, 0.4)
                elseif upgrade.type == "extraLife" then
                    love.graphics.setColor(0.2, 1, 0.2)
                elseif upgrade.type == "multiball" then
                    love.graphics.setColor(1, 1, 0.2)
                end
                love.graphics.circle("fill", upgrade.x, upgrade.y, 8)
            end
        end

    elseif gameState == "win" then
        love.graphics.setFont(titleFont)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Level " .. level .. " voltooid!", 0, 100, love.graphics.getWidth(), "center")
        love.graphics.setFont(defaultFont)
        love.graphics.printf("Druk op SPACE om door te gaan naar level " .. (level + 1), 0, 140, love.graphics.getWidth(), "center")

    elseif gameState == "lose" then
        love.graphics.setFont(titleFont)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("GAME OVER", 0, 100, love.graphics.getWidth(), "center")
        love.graphics.setFont(defaultFont)
        love.graphics.printf("Druk op R om opnieuw te starten", 0, 140, love.graphics.getWidth(), "center")
    end

    if gameState == "paused" then
        love.graphics.setColor(0, 0, 0, 0.6)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(titleFont)
        love.graphics.printf("PAUZE", 0, love.graphics.getHeight() / 2 - 40, love.graphics.getWidth(), "center")
        love.graphics.setFont(defaultFont)
        love.graphics.printf("Druk op ESC om verder te gaan", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
    end
end
function applyUpgrade(type)
    if type == "biggerPaddle" then
        paddleWidth = paddleWidth + 30
    elseif type == "fasterBall" then
        for _, ball in ipairs(balls) do
            ball.speedX = ball.speedX * 1.2
            ball.speedY = ball.speedY * 1.2
        end
    elseif type == "rowDestroy" then
        local rowY = nil
        for _, block in ipairs(blocks) do
            if not block.hit then
                rowY = block.y
                break
            end
        end
        if rowY then
            for _, block in ipairs(blocks) do
                if block.y == rowY then
                    block.hit = true
                    score = score + 10
                end
            end
        end
    elseif type == "extraLife" then
        lives = lives + 1
    elseif type == "multiball" then
        local newBalls = {}
        for _, ball in ipairs(balls) do
            table.insert(newBalls, {
                x = ball.x,
                y = ball.y,
                speedX = -ball.speedX,
                speedY = -math.abs(ball.speedY)
            })
            table.insert(newBalls, {
                x = ball.x,
                y = ball.y,
                speedX = ball.speedX,
                speedY = -math.abs(ball.speedY)
            })
        end
        for _, b in ipairs(newBalls) do
            table.insert(balls, b)
        end
    end
end

function love.keypressed(key)
    if gameState == "win" and key == "space" then
        level = level + 1
        loadLevel(level)
        resetBall()
        gameState = "start"
    elseif gameState == "start" and key == "space" then
        gameState = "playing"
    elseif gameState == "lose" and key == "r" then
        love.load()
    elseif gameState == "playing" and key == "escape" then
        gameState = "paused"
    elseif gameState == "paused" and key == "escape" then
        gameState = "playing"
    end
end