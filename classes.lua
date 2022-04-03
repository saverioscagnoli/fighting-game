screenWidth = 1024
screenHeight = 576
gravity = 2500
anim8 = require("libraries/anim8")
require("utils")

function createFighter(x, y, offsetX, offsetY, attackBoxOffsetX, attackBoxOffsetY, attackTime, recoveryTime, deathTime, deathFrames)
    love.graphics.setDefaultFilter("nearest", "nearest")
    local Fighter = {
        position = {
            x = x,
            y = y
        },
        width = 50,
        height = 150,
        velocity = {
            x = 0,
            y = 0
        },
        offset = {
            x = offsetX,
            y = offsetY
        },
        jumps = 0,
        isAttacking = false,
        isDead = false,
        attackTime,
        recoveryTime,
        deathTime = 0,
        attackBox = {
            position = {
                x = x,
                y = y
            },
            offset = {
                x = attackBoxOffsetX,
                y = attackBoxOffsetY
            },
            width = 160,
            height = 50
        },
        health = 400,
        sprites = {},
        grids = {},
        animations = {},
        currentSprite,
        currentAnimation,
    }

    function Fighter:update(dt)

        self.position.x = self.position.x + self.velocity.x * dt
        self.position.y = self.position.y + self.velocity.y * dt
        self.velocity.x = 0

        if self.position.y >= 330 then
            self.velocity.y = 0
            self.position.y = 330
            self.jumps = 0
        else self.velocity.y = self.velocity.y + gravity * dt end

        self.attackBox.position.x = self.position.x + self.attackBox.offset.x
        self.attackBox.position.y = self.position.y + self.attackBox.offset.y

    end

    function Fighter:playerMovement() 
        if love.keyboard.isDown("a") then
            self.velocity.x = self.velocity.x - 300
            self:switchSprite("run")

        elseif love.keyboard.isDown("d") then
            self.velocity.x = self.velocity.x + 300 
            self:switchSprite("run")
        else
            self:switchSprite("idle")
        end

        if self.velocity.y < 0 then
            self:switchSprite("jump")

        elseif self.velocity.y > 0 then
            self:switchSprite("fall") 
        end
    end

    function Fighter:enemyMovement()
        if love.keyboard.isDown("left") then
            self.velocity.x = self.velocity.x - 300 
            self:switchSprite("run")
        elseif love.keyboard.isDown("right") then
            self.velocity.x = self.velocity.x + 300 
            self:switchSprite("run")
        else
            self:switchSprite("idle")
        end

        if self.velocity.y < 0 then
            self:switchSprite("jump")

        elseif self.velocity.y > 0 then
            self:switchSprite("fall") 

        end
    end

    function Fighter:jumpAttack()

        function love.keypressed(key)
            if key == "w" then
                player.jumps = player.jumps + 1
                if player.jumps <= 2 then
                    player.velocity.y = -1000
                end
            end

            if key == "space" then
                if player.isAttacking == false then
                    player:attack()
                end
            end

            if key == "up" then
                enemy.jumps = enemy.jumps + 1
                if enemy.jumps <= 2 then
                    enemy.velocity.y = -1000
                end
            end

            if key == "down" then
                if enemy.isAttacking == false then
                    enemy:attack()
                end
            end
        end
    end

    function Fighter:attack()
        self:switchSprite("attack")
        self.attackTime = love.timer.getTime() + attackTime
        self.isAttacking = true
    end

    function Fighter:takeHit()
        self.recoveryTime = love.timer.getTime() + recoveryTime
        self.health = self.health - 50

        if self.health <= 0 then
            self.deathTime = love.timer.getTime() + deathTime
            self:switchSprite("death")
        else self:switchSprite("hit")
        end
    end
    
        
    function Fighter:switchSprite(sprite, death)

        if self.currentAnimation ~= nil and self.currentAnimation == self.animations.death then
            if self.currentAnimation.position == deathFrames then
                self.isDead = true
            end
        return end

        if self.currentAnimation ~= nil and self.currentAnimation == self.animations.hit and self.recoveryTime > love.timer.getTime() then return end
        if self.currentAnimation ~= nil and self.currentAnimation == self.animations.attack and self.attackTime > love.timer.getTime() then return end

        if sprite == "idle" then
            if self.currentSprite ~= self.sprites.idle then
                self.currentSprite = self.sprites.idle
                self.currentAnimation = self.animations.idle
            end

        elseif sprite == "run" then
            if self.currentSprite ~= self.sprites.run then
                self.currentSprite = self.sprites.run
                self.currentAnimation = self.animations.run
            end

        elseif sprite == "jump" then
            if self.currentSprite ~= self.sprites.jump then
                self.currentSprite = self.sprites.jump
                self.currentAnimation = self.animations.jump

            end

        elseif sprite == "attack" then
            if self.currentSprite ~= self.sprites.attack then
                self.currentSprite = self.sprites.attack
                self.currentAnimation = self.animations.attack
            end

        elseif sprite == "hit" then
            if self.currentSprite ~= self.sprites.hit then
                self.currentSprite = self.sprites.hit
                self.currentAnimation = self.animations.hit
            end

        elseif sprite == "death" then
            if self.currentSprite ~= self.sprites.death then
                self.currentSprite = self.sprites.death
                self.currentAnimation = self.animations.death
            end      
            
        elseif sprite == "fall" then
            if self.currentSprite ~= self.sprites.fall then
                self.currentSprite = self.sprites.fall
                self.currentAnimation = self.animations.fall
            end
        end
    end

    return Fighter
end

shop = createFighter(624, 160, 0, 0)
player = createFighter(100, 0, 240, 155, 40, 50, 0.6, 0.4, 0.6, 6)
enemy = createFighter(200, 0, 225, 165, -170, 50, 0.35, 0.3, 0.7, 7)

shop.sprites = {
    base = love.graphics.newImage("assets/shop.png")
}

shop.grids = {
    base = anim8.newGrid(shop.sprites.base:getWidth() / 6, shop.sprites.base:getHeight(), shop.sprites.base:getWidth(), shop.sprites.base:getHeight())
}

shop.animations = {
    base = anim8.newAnimation(shop.grids.base('1-6', 1), 0.2)
}

player.sprites = {
    idle = love.graphics.newImage("assets/samuraiMack/Idle.png"),
    run = love.graphics.newImage("assets/samuraiMack/Run.png"),
    jump = love.graphics.newImage("assets/samuraiMack/Jump.png"),
    fall = love.graphics.newImage("assets/samuraiMack/Fall.png"),
    attack = love.graphics.newImage("assets/samuraiMack/Attack1.png"),
    hit = love.graphics.newImage("assets/samuraiMack/Take Hit - white silhouette.png"),
    death = love.graphics.newImage("assets/samuraiMack/Death.png")
}

player.grids = {
    idle = anim8.newGrid(player.sprites.idle:getWidth() / 8, player.sprites.idle:getHeight(), player.sprites.idle:getWidth(), player.sprites.idle:getHeight()),
    run = anim8.newGrid(player.sprites.run:getWidth() / 8, player.sprites.run:getHeight(), player.sprites.run:getWidth(), player.sprites.run:getHeight()),
    jump = anim8.newGrid(player.sprites.jump:getWidth() / 2, player.sprites.jump:getHeight(), player.sprites.jump:getWidth(), player.sprites.jump:getHeight()),
    fall = anim8.newGrid(player.sprites.fall:getWidth() / 2, player.sprites.fall:getHeight(), player.sprites.fall:getWidth(), player.sprites.fall:getHeight()),
    attack = anim8.newGrid(player.sprites.attack:getWidth() / 6, player.sprites.attack:getHeight(), player.sprites.attack:getWidth(), player.sprites.attack:getHeight()),
    hit = anim8.newGrid(player.sprites.hit:getWidth() / 4, player.sprites.hit:getHeight(), player.sprites.hit:getWidth(), player.sprites.hit:getHeight()),
    death = anim8.newGrid(player.sprites.death:getWidth() / 6, player.sprites.death:getHeight(), player.sprites.death:getWidth(), player.sprites.death:getHeight())
}

player.animations = {
    idle = anim8.newAnimation(player.grids.idle('1-8', 1), 0.17),
    run = anim8.newAnimation(player.grids.run('1-8', 1), 0.1),
    jump = anim8.newAnimation(player.grids.jump('1-2', 1), 0.1),
    fall = anim8.newAnimation(player.grids.fall('1-2', 1), 0.1),
    attack = anim8.newAnimation(player.grids.attack('1-6', 1), 0.1),
    hit = anim8.newAnimation(player.grids.hit('1-4', 1), 0.1),
    death = anim8.newAnimation(player.grids.death('1-6', 1), 0.1)
}

enemy.sprites = {
    idle = love.graphics.newImage("assets/kenji/Idle.png"),
    run = love.graphics.newImage("assets/kenji/Run.png"),
    jump = love.graphics.newImage("assets/kenji/Jump.png"),
    fall = love.graphics.newImage("assets/kenji/Fall.png"),
    attack = love.graphics.newImage("assets/kenji/Attack1.png"),
    hit = love.graphics.newImage("assets/kenji/Take hit.png"),
    death = love.graphics.newImage("assets/kenji/Death.png")
}

enemy.girds = {
    idle = anim8.newGrid(enemy.sprites.idle:getWidth() / 4, enemy.sprites.idle:getHeight(), enemy.sprites.idle:getWidth(), enemy.sprites.idle:getHeight()),
    run = anim8.newGrid(enemy.sprites.run:getWidth() / 8, enemy.sprites.run:getHeight(), enemy.sprites.run:getWidth(), enemy.sprites.run:getHeight()),
    jump = anim8.newGrid(enemy.sprites.jump:getWidth() / 2, enemy.sprites.jump:getHeight(), enemy.sprites.jump:getWidth(), enemy.sprites.jump:getHeight()),
    fall = anim8.newGrid(enemy.sprites.fall:getWidth() / 2, enemy.sprites.fall:getHeight(), enemy.sprites.fall:getWidth(), enemy.sprites.fall:getHeight()),
    attack = anim8.newGrid(enemy.sprites.attack:getWidth() / 4, enemy.sprites.attack:getHeight(), enemy.sprites.attack:getWidth(), enemy.sprites.attack:getHeight()),
    hit = anim8.newGrid(enemy.sprites.hit:getWidth() / 3, enemy.sprites.hit:getHeight(), enemy.sprites.hit:getWidth(), enemy.sprites.hit:getHeight()),
    death = anim8.newGrid(enemy.sprites.death:getWidth() / 7, enemy.sprites.death:getHeight(), enemy.sprites.death:getWidth(), enemy.sprites.death:getHeight())
}

enemy.animations = {
    idle = anim8.newAnimation(enemy.girds.idle('1-4', 1), 0.17),
    run = anim8.newAnimation(enemy.girds.run('1-8', 1), 0.1),
    jump = anim8.newAnimation(enemy.girds.jump('1-2', 1), 0.1),
    fall = anim8.newAnimation(enemy.girds.fall('1-2', 1), 0.1),
    attack = anim8.newAnimation(enemy.girds.attack('1-4', 1), 0.1),
    hit = anim8.newAnimation(enemy.girds.hit('1-3', 1), 0.1),
    death = anim8.newAnimation(enemy.girds.death('1-7', 1), 0.1)
}

sakura = createFighter(0, 0, 0, 0)
sakura.sprites = {
    base = love.graphics.newImage("assets/sakura-rain.png"),
}

sakura.grids = {
    base = anim8.newGrid(math.floor(sakura.sprites.base:getWidth() / 28), sakura.sprites.base:getHeight(), sakura.sprites.base:getWidth(), sakura.sprites.base:getHeight())
}

sakura.animations = {
    base = anim8.newAnimation(sakura.grids.base('1-28', 1), 0.13)
}

