function love.load ()
  player = {}
  player.x = 0
  player.y = 550
  player.bullets = {}
  player.speed = 10
  player.countdown = 20
  player.fire = function ()
    if  player.countdown <= 0 then
      player.countdown = 20
      bullet = {}
      bullet.x = player.x + 35
      bullet.y = player.y;
      table.insert(player.bullets,bullet)
    end
  end
end
function love.update (dt)
  player.countdown = player.countdown - 1
  if love.keyboard.isDown("d") then
    player.x =player.x + player.speed
  elseif love.keyboard.isDown("a") then
    player.x = player.x - player.speed
  end
  if love.keyboard.isDown(" ") then
      player.fire()
  end
  for i,b in pairs(player.bullets) do
    if b.y < -10  then
      table.remove(player.bullets, i)
    end
    b.y = b.y - 5
  end
end
function love.draw ()
  -- rect
 love.graphics.setColor(169, 199, 100)
 love.graphics.rectangle('fill',player.x, player.y, 80 , 40);
 -- bull
 love.graphics.setColor(255, 255, 255)
 for _,b in pairs(player.bullets) do
   love.graphics.rectangle("fill", b.x, b.y, 10, 10)
 end
end
