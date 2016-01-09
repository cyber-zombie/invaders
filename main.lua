debug = true

love.graphics.setDefaultFilter('nearest','nearest')
enemy = {}
enemies_controller = {}
enemies_controller.enemies = {}
enemies_controller.image= love.graphics.newImage('enemy.png')
backgroundImage= love.graphics.newImage('background.jpg')

function checkCollisions(enemies, bullets)
  for i, e in ipairs(enemies) do
    for j, b in ipairs(bullets) do
      if b.y <= e.y + e.height and b.x > e.x and b.x < e.x + e.width then
        table.remove(bullets, j)
        table.remove(enemies, i)
      end
    end
  end
end

function love.load ()
  -- player
  print(love.graphics.getHeight())
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
  for i=0,5 do
    enemies_controller:spawnEnemy(i*90,0)
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
  -- print(dt)
  gameOver = false
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
  -- print(love.graphics.getHeight())
  for _,e in ipairs(enemies_controller.enemies) do
    if e.y >= love.graphics.getHeight() then
      gameOver = true
      -- print(gameOver)
    end
    e.y = e.y + e.speed
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
  if gameOver then
    love.graphics.print("game over")
    return
  end
 love.graphics.draw(backgroundImage)
 love.graphics.setColor(169, 199, 100)
 love.graphics.draw(player.image,player.x, player.y, 0, 5 , 5);
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
