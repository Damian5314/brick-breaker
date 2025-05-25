function love.load()
    x = 50
    y = 50
    gameState = "start"
end

function love.update(dt)
    if gameState == "playing" then
        x = x + 100 * dt
        if x > love.graphics.getWidth() then
            x = 0
        end
    end
end


function love.draw()
    if gameState == "start" then
        love.graphics.print("Press SPACE to start", 10, 10)

    elseif gameState == "playing" then
        love.graphics.rectangle("fill", x, y, 50, 50)

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