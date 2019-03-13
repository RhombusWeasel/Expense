local map = {}
      map.version = 0.2

function map.getNoiseValue(map, x, y, oct)
  local freq = map.freq / oct
  local amp = map.amp / oct
  return love.math.noise(x / freq, y / freq) * amp
end

function map.toXY(w, n)
  local x = n % w
  local y = n / w
  return x - 1, y - 1
end

function map.toIndex(w, x, y)
  return x + w * y
end

function map.generate(w, h)
  local rng = love.math.newRandomGenerator(math.random(1, 50000))
  local dump = rng:random(1, 2)
  local amp = 500--rng:random(100, 300)
  local freq = rng:random(.7, 1)
  local oct = rng:random(15, 20)
  local min = math.min
  local max = math.max
  local gnv = map.getNoiseValue
  local toIndex = map.toIndex
  local mapMin = love.math.noise(w / 2, h / 2)
  local mapMax = mapMin
  local m = {}
  m.w = w
  m.h = h
  m.amp = amp
  m.freq = freq
  m.oct = oct
  m.data = {}
  local c = 1
  for x = 1, w do
    for y = 1, h do
      local height = 0
      for i = 1, oct do
        height = height + gnv(m, x / w, y / h, i)
      end
      mapMin = min(mapMin, height)
      mapMax = max(mapMax, height)
      m.data[c] = {h = height, index = toIndex(w, x, y)}
      c = c + 1
    end
  end
  local mapMultiplier = 255 / (mapMax - mapMin)
  for i = 1, #m.data do
    m.data[i].h = m.data[i].h * mapMultiplier
  end
  return m
end

function map.draw_canvas(m, texture)
  local canvas = love.graphics.newCanvas(m.w, m.h)
  local getPoint = map.toXY
  love.graphics.setCanvas(canvas)
  for i = 1, #m.data do
    local x, y = getPoint(m.w, m.data[i].index)
    for j = 1, #texture do
      local c = m.data[i].h
      local m = c / 255
      if c < texture[j].cutoff then
        if texture[j].chance ~= nil then
          local r = love.math.random()
          if r < texture[j].chance then
            local r = m * texture[j].col[1]
            local g = m * texture[j].col[2]
            local b = m * texture[j].col[3]
            local a = texture[j].col[4]
            love.graphics.setColor(r, g, b, a)
            love.graphics.points(x, y)
          end
        else
          local r = m * texture[j].col[1]
          local g = m * texture[j].col[2]
          local b = m * texture[j].col[3]
          local a = texture[j].col[4]
          love.graphics.setColor(r, g, b, a)
          love.graphics.points(x, y)
        end
        break
      end
    end
  end
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setCanvas()
  return canvas
end

function map.make_shade_layer(w, h)
  local canvas = love.graphics.newCanvas(w, h)
  local alpha = 0
  local shade_angle = math.random(200, 210) / 100
  love.graphics.setCanvas(canvas)
  for x = w / shade_angle, w do
    love.graphics.setColor(0, 0, 0, alpha)
    for y = 1, h do
      love.graphics.points(x + .5, y + .5)
    end
    alpha = math.min(alpha + (50 / 255), 1)
  end
  love.graphics.setCanvas()
  return canvas
end

map.clouds = {}

map.clouds.none = {
  [1] = {cutoff = 260, col = {0, 0, 0, 0}},
}

map.clouds.white = {
  {cutoff = 180, col = {1, 1, 1, 0}},
  {cutoff = 190, col = {1, 1, 1, .2}},
  {cutoff = 200, col = {1, 1, 1, .4}},
  {cutoff = 210, col = {1, 1, 1, .6}},
  {cutoff = 230, col = {1, 1, 1, .8}},
  {cutoff = 260, col = {1, 1, 1, 1}},
}

map.clouds.red = {
  {cutoff = 145, col = {1, 0, 0, 0}},
  {cutoff = 150, col = {1, 0, 0, .45}},
  {cutoff = 155, col = {1, 0, 0, .5}},
  {cutoff = 160, col = {1, 0, 0, .55}},
  {cutoff = 165, col = {1, 0, 0, .6}},
  {cutoff = 170, col = {1, 0, 0, .65}},
  {cutoff = 175, col = {1, 0, 0, .7}},
  {cutoff = 180, col = {1, 0, 0, .75}},
  {cutoff = 190, col = {1, 0, 0, .8}},
  {cutoff = 200, col = {1, 0, 0, .85}},
  {cutoff = 210, col = {1, 0, 0, .9}},
  {cutoff = 230, col = {1, 0, 0, .95}},
  {cutoff = 260, col = {1, 0, 0, 1}},
}

return map