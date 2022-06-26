all_soldiers = {}

Bullet = {
    ["pos"] = {0, 0},
    ["vel"] = {0, 0},
    ["stopped"] = true,  -- Probably unnecessary variable
    ["radius"] = 20  -- Bullets are represented by circles
}

function Bullet:update(dt)
    -- Euler method
    if not self.stopped then
        self.pos[1] = self.pos[1] + self.vel[1]*dt
        self.pos[2] = self.pos[2] + self.vel[2]*dt
    end
end

function Bullet:start(vel)
    self.vel = vel
    self.stopped = false
end

function Bullet:stop()
    -- Run this method when the bullet hits a soldier
    self.vel[1] = 0
    self.vel[2] = 0
    self.stopped = true
end

function Bullet:new(pos)
    t = {["pos"] = pos}
    setmetatable(t, self)
    self.__index = self
    return t
end


Soldier = {
    ["pos"] = {0, 0},
    ["aim"] = {0, 0},
    ["alive"] = true,
    ["bullet"] = Bullet:new{["pos"] = {0, 0}, ["vel"] = {0, 0}},
    ["radius"] = 50,  -- Soldiers are represented by circles
    ["all_soldiers_ref"] = all_soldiers
}

function Soldier:update(dt)
    self.bullet:update(dt)

    -- Small helper function, computes distance between two points
    function dist(pos1, pos2)
        return math.sqrt((pos1[1] - pos2[1])^2 + (pos1[2] - pos2[2])^2)
    end

    -- Check if bullet has hit anyone, ignore self of course
    for _, soldier in ipairs(self.all_soldiers_ref) do
        if soldier ~= self and dist(self.bullet.pos, soldier.pos) - (self.bullet.radius + soldier.radius) < 0 then
            soldier:kill()
            self.bullet:stop()
        end
    end
end

function Soldier:kill()
    self.alive = false
end

function Soldier:shoot(speed)
    local bullet_vel = {self.aim[1]*speed/math.sqrt(2), self.aim[2]*speed/math.sqrt(2)}
    self.bullet:start(bullet_vel)
end

function Soldier:aim_at(soldier)
    local delta_p = delta_pos(soldier.pos, self.pos)
    local norm = math.sqrt(delta_p[1]^2 + delta_p[2]^2)
    self.aim = {delta_p[1]/norm, delta_p[2]/norm}
end

function Soldier:new(pos)
    t = {["pos"] = pos, ["bullet"] = Bullet:new({pos[1], pos[2]})}
    setmetatable(t, self)
    self.__index = self
    all_soldiers[#all_soldiers + 1] = t
    return t
end

-- Helper functions
function delta_pos(pos1, pos2)
    -- Returns the vector pos1 - pos2
    return {pos1[1] - pos2[1], pos1[2] - pos2[2]}
end

-- Return
return Soldier
