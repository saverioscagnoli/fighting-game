function collisions(a, b)
    if a.attackBox.position.x + a.attackBox.width > b.position.x and
    a.attackBox.position.x <= b.position.x + b.width and
    a.attackBox.position.y + a.attackBox.height >= b.position.y and
    a.attackBox.position.y <= b.position.y + b.height then
        return true
    end

end

timerMax = love.timer.getTime() + 60

function timer() 

    if timerMax - love.timer.getTime() >= 0 then return math.floor(timerMax - love.timer.getTime())
    
    else return "0", determineWinner() end
end

function determineWinner()

    timerMax = 0

    if player.health < enemy.health then
        return love.graphics.print("Enemy Wins!", halfScreenWidth - 130, 576 / 2) 
    elseif enemy.health < player.health then 
        return  love.graphics.print("Player Wins!", halfScreenWidth - 130, 576 / 2)
    else return  love.graphics.print("Tie!", halfScreenWidth - 70, 576 / 2) end
end

