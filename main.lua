function love.load()
    x = 50
    y = 50
end

function love.update(dt)
    x = x + 100 * dt
    if x > love.graphics.getWidth() then
        x = 0
    end
end


function love.draw()
    love.graphics.rectangle("fill", x, y, 50, 50)
end