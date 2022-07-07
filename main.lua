Soldier = require "lib"

function love.load()
    K = 1  -- How many soldiers to jump
    BULLET_SPEED = 1000
    WIDTH = 800
    HEIGHT = 800
    N_SOLDIERS = 80
    --
    -- A transform for normal cartesian coordinates and origin in the center
    transform = love.math.newTransform( WIDTH/2, HEIGHT/2, 0, 1, -1, 0, 0, 0, 0 )

    -- Create 10 Soldiers, positioned in a ring
    -- First divide the angle 2*pi into 10 parts
    Soldiers = {}
    local radius = 300
    for theta = 0, 2*math.pi-2*math.pi/N_SOLDIERS, 2*math.pi/N_SOLDIERS do
        local x = radius*math.cos(theta)
        local y = radius*math.sin(theta)
        Soldiers[#Soldiers+1] = Soldier:new({x, y})
    end

    Curr_soldier_index = 1
    To_shoot_soldier_index = 2
    Soldiers[Curr_soldier_index]:aim_at(Soldiers[To_shoot_soldier_index])
    Soldiers[Curr_soldier_index]:shoot(BULLET_SPEED)

    -- Initialize window
    love.window.setMode(WIDTH,HEIGHT)
    love.window.setTitle("Josephus")
end

function love.update(dt)
    Soldiers[Curr_soldier_index]:update(dt)

    if not Soldiers[Curr_soldier_index].bullet then
        Curr_soldier_index = next_alive_soldier(Curr_soldier_index,1)
        To_shoot_soldier_index = next_alive_soldier(Curr_soldier_index,K)
        Soldiers[Curr_soldier_index]:aim_at(Soldiers[To_shoot_soldier_index])
        Soldiers[Curr_soldier_index]:shoot(BULLET_SPEED)
    end


end

function love.draw()
    -- Draw background
    love.graphics.setColor(.14, .36, .46)
    love.graphics.rectangle('fill', 0, 0, 800, 800)

    -- Apply transform
    love.graphics.applyTransform(transform)

    -- Draw Soldiers
    for _, soldier in ipairs(Soldiers) do
        if soldier.alive then
            love.graphics.setColor(1,1,1)
        else
            love.graphics.setColor(0,0,0)
        end
        love.graphics.circle("fill", soldier.pos[1], soldier.pos[2], soldier.radius)
    end

    -- Draw bullet (if there is one) for current soldier
    if Soldiers[Curr_soldier_index].bullet then
        love.graphics.setColor(0,1,0)
        love.graphics.circle("fill", Soldiers[Curr_soldier_index].bullet.pos[1], Soldiers[Curr_soldier_index].bullet.pos[2], Soldiers[Curr_soldier_index].bullet.radius)
    end
end

function next_alive_soldier(soldier_index,step)
    -- TODO: implement step
    local next_soldier_index = (soldier_index % #Soldiers) + 1
    while not Soldiers[next_soldier_index].alive do
      next_soldier_index = (next_soldier_index % #Soldiers) + 1
    end
    return next_soldier_index
end
