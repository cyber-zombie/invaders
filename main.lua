love.graphics.setDefaultFilter('nearest','nearest')
enemy = {}
enemies_controller = {}
enemies_controller.enemies = {}
enemies_controller.image= love.graphics.newImage('enemy.png')

function love.load ()
  -- player
  player = {}
  player.x = 0
  player.y = 500
  player.bullets = {}
  player.speed = 10
  player.cooldown = 0
  player.image= love.graphics.newImage('player.png')
  player.fire_sound = love.audio.newSource('SHOOT019.mp3')
  player.fire = function ()
    if  player.cooldown <= 0 then
      love.audio.play(player.fire_sound)
      player.cooldown = 60
      bullet = {}
      bullet.x = player.x + 25
      bullet.y = player.y;
      table.insert(player.bullets,bullet)

    end
  end
  enemies_controller:spawnEnemy(0,0)
  enemies_controller:spawnEnemy(90,0)
  enemies_controller:spawnEnemy(180,0)

end

function enemies_controller:spawnEnemy (x, y)
  enemy = {}
  enemy.x = x
  enemy.y = y
  enemy.bullets = {}
  enemy.speed = 10
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
  player.cooldown = player.cooldown - 1
  if love.keyboard.isDown("d") then
    player.x =player.x + player.speed
  elseif love.keyboard.isDown("a") then
    player.x = player.x - player.speed
  end
  if love.keyboard.isDown(" ") then
      player.fire()
  end
  for _,e in ipairs(enemies_controller.enemies) do
    e.y = e.y + 3
  end

  for i,b in ipairs(player.bullets) do
    if b.y < -10  then
      table.remove(player.bullets, i)
    end
    b.y = b.y - 5
  end
end
function love.draw ()
  -- love.graphics.scale(5)
  -- rect
 love.graphics.setColor(169, 199, 100)
 love.graphics.draw(player.image,player.x, player.y, 0 , 5, 5);
 -- enemy
 love.graphics.setColor(255, 255, 255)

 for _,e in ipairs(enemies_controller.enemies) do
   love.graphics.draw(enemies_controller.image, e.x,e.y, 0 , 5 ,5)
 end

 -- bull
 love.graphics.setColor(255, 255, 255)
 for _,b in ipairs(player.bullets) do
   love.graphics.rectangle("fill", b.x, b.y, 5, 5)
 end
end
