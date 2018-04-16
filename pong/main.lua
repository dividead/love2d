Object = require 'lib/classic/classic'
Node = Object:extend()
Grid = Object:extend()
Highlight = Object:extend()

WIDTH = love.graphics.getWidth()
HEIGHT = love.graphics.getHeight()
RED = {1, 0, 0, 1}
BLUE = {0, 0, 1, 1}
BLACK = {0, 0, 0, 1}

function Grid:new(size, len, color)
  self.size = size
  self.len = len
  self.color = color
  local nodes = {}
  self.globalX = 400
  self.globalY = 150
  for x = 1, size do
    nodes[x] = {}
    for y = 1, size do
      local node = Node({x = x, y = y}, self.globalX + (y - x) * len, self.globalY + (x + y) * len/2 - size/2 * len/2, len, 1 , color)
      nodes[x][y] = node
    end
  end
  self.nodes = nodes
end

function Grid:draw()
  for _, row in pairs(self.nodes) do
    for _, node in pairs(row) do
      node:draw()
    end
  end
end

function drawXY()
  local x = love.mouse.getX()
  local y = love.mouse.getY()
  love.graphics.print('( ' .. x .. ' , ' .. y .. ' )' , x + 10, y)
end

function background()
  local step = 20
  love.graphics.setColor({0.1,0.1,0.1,0.5})
  for w=0, WIDTH, step do
    love.graphics.line(w, 0, w, HEIGHT)
    
  end
  for h=0, HEIGHT, step do
    love.graphics.line(0, h, WIDTH, h)
  end
  love.graphics.reset()
end

function Node:new(pos, x, y, len, lw, color)
  self.pos = pos
  self.x = x
  self.y = y
  self.len = len
  self.lw = lw
  self.color = color
end

function Node:draw()
  local ypl2 = self.y + self.len/2
  local ypl = self.y + self.len
  local yml = self.y - self.len
  local xml = self.x - self.len
  local xpl = self.x + self.len
  local yml2 = self.y - self.len/2
  local yp3l = self.y + self.len + self.len/2
  -- local y2 = (xpl)  *  math.tan(math.rad(27))
  
  love.graphics.setColor(BLACK)
  love.graphics.polygon('fill', self.x, self.y, xpl, ypl2, xpl, yp3l, self.x, ypl + self.len, xml, yp3l, xml, ypl2)
  
  love.graphics.setLineWidth(self.lw + 1)
  love.graphics.setColor(self.color)
  love.graphics.line(self.x, ypl, xpl, ypl2)
  love.graphics.line(self.x, ypl, xml, ypl2)
  love.graphics.line(self.x, ypl, self.x, ypl + self.len)
  love.graphics.polygon('line', self.x, self.y, xpl, ypl2, xpl, yp3l, self.x, ypl + self.len, xml, yp3l, xml, ypl2)
  love.graphics.reset()
  love.graphics.print(self.pos.x .. '-' .. self.pos.y, self.x - 10, self.y + 10)
  -- love.graphics.print(self.x .. '-' .. self.y, self.x - self.len/2, self.y + self.len/2 - 15)
end

function Node:setColor(color)
  self.color = color
end

function love.load()
  grid = Grid(8,50, RED)
  highlight = Highlight(grid)
end

function love.update(dt)

end

function love.draw()
  background()
  grid:draw()
  -- drawXY()
  highlight:run()
end

function Highlight:new(grid)
  self.grid = grid
  self.limit = #grid.nodes
  self.curr = nil
end

function Highlight:run()
  local grid = self.grid
  local limit = self.limit
  local w = grid.len * 2
  local h = grid.len
  local mx = love.mouse.getX() - grid.globalX
  local b = 7 -- ?
  local a = (h - h * b)/grid.size
  -- print(4*a + 100*b, 8*a + 50*b)
  local my = love.mouse.getY() - grid.globalY + 50

  local x = math.abs(math.floor(1/w * mx - 1/h * my))
  local y = math.floor(1/w * mx + 1/h * my) + 1

  love.graphics.print(x .. ' - ' .. y, 10, 10)  
  if x > 0 and x <= limit and y > 0 and y <= limit then
    if self.curr ~= nil then
      self.curr:setColor(RED)
    end
    local node = grid.nodes[x][y]
    node:setColor(BLUE)
    self.curr = node
  else
    if self.curr ~= nil then
      self.curr:setColor(RED)
    end
  end
end
