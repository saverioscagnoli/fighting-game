require("classes")
require("utils")
anim8 = require("libraries/anim8")

halfScreenWidth = 1024 / 2

background = love.graphics.newImage("assets/background.png")

function love.load()
    love.window.setMode(1024, 576)
    love.graphics.setFont(love.graphics.newFont("font.ttf", 20))
    player.currentSprite = player.sprites.idle
    player.currentAnimation = player.animations.idle
end

function love.update(dt)

    shop.animations.base:update(dt)

    if player.isDead == false then
        player:update(dt)
        player:playerMovement(dt)
        player:jumpAttack()
        player.currentAnimation:update(dt)
    
    elseif player.isDead == true and player.position.y < 330 then
        player:update(dt)
    end

    if enemy.isDead == false and player.position.y then
        enemy:update(dt)
        enemy:enemyMovement()
        enemy:jumpAttack()
        enemy.currentAnimation:update(dt)

    elseif enemy.isDead == true and enemy.position.y < 330 then
        enemy:update(dt)
    end

    if collisions(player, enemy) and player.isAttacking and player.currentAnimation.position == 4 then
        enemy:takeHit()
    end

    if player.isAttacking and player.currentAnimation.position == 4 then
        player.isAttacking = false
    end

    if collisions(player, enemy) and enemy.isAttacking and enemy.currentAnimation.position == 4 then
        player:takeHit()
    end

    if enemy.isAttacking and enemy.currentAnimation.position == 4 then
        enemy.isAttacking = false
    end

    sakura.animations.base:update(dt)

end

function love.draw()
    love.graphics.draw(background, 0, 0)
    sakura.animations.base:draw(sakura.sprites.base, sakura.position.x, sakura.position.y, nil, 1.1)
    sakura.animations.base:draw(sakura.sprites.base, 517, 0, nil, 1.1)
    shop.animations.base:draw(shop.sprites.base, shop.position.x, shop.position.y, nil, 2.5)

    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle("fill", halfScreenWidth - 25, 25, -player.health, 40)
    love.graphics.rectangle("fill", halfScreenWidth + 25, 25, enemy.health, 40)

    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle("fill", halfScreenWidth - 25, 20, 50, 50)

    love.graphics.setColor(255, 255, 255)
    love.graphics.print(timer(), halfScreenWidth - 18.5, 35)
    if ( player.isDead or enemy.isDead) then determineWinner() end

    player.currentAnimation:draw(player.currentSprite, player.position.x - player.offset.x, player.position.y - player.offset.y, nil, 2.5)
    enemy.currentAnimation:draw(enemy.currentSprite, enemy.position.x - enemy.offset.x, enemy.position.y - enemy.offset.y, nil, 2.5)

end


