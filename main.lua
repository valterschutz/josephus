Soldier = require "lib"

function love.load()
    WIDTH = 800
    HEIGHT = 800
    --
    -- A transform for normal cartesian coordinates and origin in the center
    transform = love.math.newTransform( WIDTH/2, HEIGHT/2, 0, 1, -1, 0, 0, 0, 0 )

    -- Create 10 soldiers, positioned in a ring
    -- First divide the angle 2*pi into 10 parts
    soldiers = {}
    local radius = 300
    for theta = 0, 2*math.pi-2*math.pi/10, 2*math.pi/10 do
        local x = radius*math.cos(theta)
        local y = radius*math.sin(theta)
        soldiers[#soldiers+1] = Soldier:new({x, y})
    end

    soldiers[8]:aim_at(soldiers[2])
    soldiers[8]:shoot(100)
    curr_soldier = soldiers[8]

    -- Initialize window
    love.window.setMode(WIDTH,HEIGHT)
    love.window.setTitle("Josephus")
end

function love.update(dt)
    curr_soldier:update(dt)
end

function love.draw()
    -- Draw background
    love.graphics.setColor(.14, .36, .46)
    love.graphics.rectangle('fill', 0, 0, 800, 800)

    -- Apply transform
    love.graphics.applyTransform(transform)

    -- Draw soldiers
    for _, soldier in ipairs(soldiers) do
        if soldier.alive then
            love.graphics.setColor(1,1,1)
        else
            love.graphics.setColor(0,0,0)
        end
        love.graphics.circle("fill", soldier.pos[1], soldier.pos[2], soldier.radius)
    end

    -- Draw bullet (if there is one) for current soldier
    if not curr_soldier.bullet.stopped then
        love.graphics.setColor(0,1,0)
        love.graphics.circle("fill", curr_soldier.bullet.pos[1], curr_soldier.bullet.pos[2], curr_soldier.bullet.radius)
    end
end

