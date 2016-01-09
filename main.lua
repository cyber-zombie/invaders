debug = true

love.graphics.setDefaultFilter('nearest','nearest')
enemy = {}
enemies_controller = {}
enemies_controller.enemies = {}
enemies_controller.image= love.graphics.newImage('enemy.png')
backgroundImage= love.graphics.newImage('background.jpg')
particle_systems = {}
particle_systems.list = {}
particle_systems.img = love.graphics.newImage('particle.png')

function particle_systems:spawn(x, y)
  local ps = {}
  ps.x = x
  ps.y = y
  ps.ps = love.graphics.newParticleSystem(particle_systems.img, 32)
  ps.ps:setParticleLifetime(2, 4)
  ps.ps:setEmissionRate(5)
  ps.ps:setSizeVariation(1)
  ps.ps:setLinearAcceleration(-20, -20, 20, 20)
  ps.ps:setColors(100, 255, 100, 255, 0, 255, 0, 255)
  table.insert(particle_systems.list, ps)
end
function particle_systems:draw()
  for _, v in pairs(particle_systems.list) do
    love.graphics.draw(v.ps, v.x, v.y, 5, 5)
  end
end

function particle_systems:update(dt)
  for _, v in pairs(particle_systems.list) do
    v.ps:update(dt)
  end
end

function particle_systems:cleanup()
  -- delete particle systems after a length of time...
  -- exercise left for the viewer ;)
end

function checkCollisions(enemies, bullets)
  for i, e in ipairs(enemies) do
    for j, b in ipairs(bullets) do
      if b.y <= e.y + e.height and b.x > e.x and b.x < e.x + e.width then
        particle_systems:spawn(e.x, e.y)
        table.remove(bullets, j)
        table.remove(enemies, i)
      end
    end
  end
end

function love.load ()
  -- player
  local music = love.audio.newSource('main.mp3')
  music:setLooping(true)
  love.audio.play(music)
  game_over = false
  game_win = false
  player = {}
  player.x = 0
  player.y = 500
  player.bullets = {}
  player.speed = 10
  player.cooldown = 0
  player.height = 50
  player.image= love.graphics.newImage('player.png')
  player.fire_sound = love.audio.newSource('SHOOT019.mp3')
  player.fire = function ()
    if  player.cooldown <= 0 then
      love.audio.play(player.fire_sound)
      player.cooldown = 30
      bullet = {}
      bullet.x = player.x + 25
      bullet.y = player.y;
      table.insert(player.bullets,bullet)
    end
  end
  -- spawn enemies
  for i=0,5 do
    for j = 0,3 do
      enemies_controller:spawnEnemy(i*90,j*60)
    end
  end

end

function enemies_controller:spawnEnemy (x, y)
  enemy = {}
  enemy.x = x
  enemy.y = y
  enemy.width = 50
  enemy.height = 50
  enemy.bullets = {}
  enemy.speed = 1
  enemy.cooldown = 20
  table.insert(self.enemies,enemy)
end

function enemy:fire ()
  if self.cooldown <=0 then
    self.cooldown = 20
    bullet = {}
    bullet.x = self.x + 35
    bullet.y = self.y;
    table.insert(self.bullets,bullet)
  end
end

function love.update (dt)
  -- particle_systems:update(dt)
  checkCollisions(enemies_controller.enemies, player.bullets)

  player.cooldown = player.cooldown - 1

  if love.keyboard.isDown("d") then
    player.x = player.x + player.speed
  elseif love.keyboard.isDown("a") then
    player.x = player.x - player.speed
  end
  if love.keyboard.isDown(" ") then
      player.fire()
  end
  -- check for wining
  if #enemies_controller.enemies == 0 then
    game_win = true
  end
  -- enemies falling
  for _,e in ipairs(enemies_controller.enemies) do
    if e.y >= love.graphics.getHeight() then
      game_over = true
      -- print(game_win)
    end
    e.y = e.y + e.speed
  end
  -- bullets controller
  for i,b in ipairs(player.bullets) do
    if b.y < -10  then
      table.remove(player.bullets, i)
    end
    b.y = b.y - 5
  end
end
function love.draw ()
  -- love.graphics.scale(5)
  love.graphics.draw(backgroundImage)

  if game_over then
    love.graphics.print("game over")
    return
  elseif game_win then
    love.graphics.print("You Won! Now get drunk, white boy!")
  end

  -- particle_systems:draw()

  love.graphics.setColor(169, 199, 100)
  love.graphics.draw(player.image,player.x, player.y, 0, 5 , 5);
  -- enemy
  love.graphics.setColor(255, 255, 255)

  for _,e in ipairs(enemies_controller.enemies) do
    love.graphics.draw(enemies_controller.image, e.x,e.y, 0 , 5 ,5)
  end
  -- bullet draw
  love.graphics.setColor(255, 255, 255)
  for _,b in ipairs(player.bullets) do
    love.graphics.rectangle("fill", b.x, b.y, 5, 5)
    end
end
