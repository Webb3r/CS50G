Paddle = Class{}

function Paddle:init(x, y, with, height)
	self.x = x
	self.y = y
	self.with = with
	self.height = height

	self.dy = 0
end

function Paddle:render()
	love.graphics.rectangle("fill", self.x, self.y, self.with, self.height)
end

function Paddle:update(dt)
	if self.dy > 0 then
		self.y = math.max(0, self.y + self.dy * dt)
	else
		self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
	end
end
