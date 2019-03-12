local function new_bat(x, h, k1, k2)
  return {
    x = x,
    y = (engine.screen_height - h) / 2,
    w = 10,
    h = h,
    spd = 200,
    up = k1,
    dn = k2,
    score = 0,
  }
end

local function update_bat(dt, bat)
  local dist = bat.spd * dt
  if engine.keys[bat.up] then
    local new_y = bat.y - dist
    bat.y = new_y > 0 and new_y or 0
  end
  if engine.keys[bat.dn] then
    local new_y = bat.y + dist
    bat.y = new_y < engine.screen_height - bat.h and new_y or engine.screen_height - bat.h
  end
end

local function draw_bat(bat)
  love.graphics.setColor(1,1,1,1)
  love.graphics.line(bat.x, bat.y, bat.x, bat.y + bat.h)
end

local function new_ball(vx)
  return {
    x = engine.screen_width / 2,
    y = engine.screen_height / 2,
    r = 10,
    vx = vx,
    vy = -1,
    sx = 0,
    sy = 0,
    spd = 100,
  }
end

local function check_walls(ball)
  if ball.y < ball.r or ball.y > engine.screen_height - ball.r then
    ball.vy = ball.vy * -1
  end
end

local function check_score(ball, bats)
  if ball.x <= bats.left.x then
    bats.right.score = bats.right.score + 1
    return new_ball(-1)
  elseif ball.x > bats.right.x then
    bats.left.score = bats.left.score + 1
    return new_ball(1)
  end
  return ball
end

local function check_x(ball, bat)
  if bat.x < engine.screen_width / 2 and ball.x - ball.r < bat.x then
    ball.vx = ball.vx * -1
    ball.x = (bat.x + ball.r) + ball.vx
    ball.spd = ball.spd + 1
    if engine.keys[bat.up] then
      ball.sx = ball.sx + .2
    elseif engine.keys[bat.dn] then
      ball.sx = ball.sx - .2
    end
    return true
  elseif bat.x > engine.screen_width / 2 and ball.x + ball.r > bat.x then
    ball.vx = ball.vx * -1
    ball.x = (bat.x - ball.r) + ball.vx
    ball.spd = ball.spd + 1
    if engine.keys[bat.up] then
      ball.sx = ball.sx - .2
    elseif engine.keys[bat.dn] then
      ball.sx = ball.sx + .2
    end
    return true
  end
  return false
end

local function check_bat(ball, bat)
  if ball.y > bat.y and ball.y < bat.y + bat.h then
    check_x(ball, bat)
  end
end

local function update_ball(dt, ball, bats)
  ball.x = ball.x + ((ball.vx * ball.spd) * dt)
  ball.y = ball.y + ((ball.vy * ball.spd) * dt)
  local slow = .01
  if ball.sx > 0 then
    ball.sx = ball.sx - (slow * dt)
  elseif ball.sx < 0 then
    ball.sx = ball.sx + (slow * dt)
  end
  check_walls(ball)
  check_bat(ball, bats.left)
  check_bat(ball, bats.right, -bats.right.w)
end

local function draw_ball(ball)
  love.graphics.setColor(1,1,1,1)
  love.graphics.circle("line", ball.x, ball.y, ball.r)
end

local function draw_screen(p)
  love.graphics.setColor(0,1,0,1)
  local hw = engine.screen_width / 2
  love.graphics.line(hw, 0, hw, engine.screen_height)
  love.graphics.print(tostring(p.bats.left.score), 10, 10)
  local sw = engine.font[engine.current_font]:getWidth(tostring(p.bats.right.score))
  love.graphics.print(tostring(p.bats.right.score), (engine.screen_width - 10) - sw, 10)
  local s = math.round(p.ball.sx, 2).." "..math.round(p.ball.vx, 2)
  sw = engine.font[engine.current_font]:getWidth(s)
  love.graphics.print(s, (engine.screen_width - sw) / 2, 10)
end

local p = {}

function p.startup()
  
end

function p.enter()
  local bat_width = 50
  local bat_height = 200
  p.score_1 = 0
  p.score_2 = 0
  p.bats = {
    left = new_bat(bat_width, bat_height, "w", "s"),
    right = new_bat(engine.screen_width - (bat_width), bat_height, "p", "l"),
  }
  p.ball = new_ball(-1)
end

function p.exit()
  
end

function p.update(dt)
  p.ball = check_score(p.ball, p.bats)
  update_bat(dt, p.bats.left)
  update_bat(dt, p.bats.right)
  update_ball(dt, p.ball, p.bats)
end

function p.draw()
  draw_screen(p)
  for k, v in pairs(p.bats) do
    draw_bat(v)
  end
  draw_ball(p.ball)
end

return p