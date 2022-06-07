WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

push = require 'push'

function love.load()
    love.graphics.setDefaultFilter('nearest','nearest')

    smallFont = love.graphics.newFont('font.ttf', 8)
    love.graphics.setFont(smallFont)

    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    math.randomseed(os.time())
    ballX = VIRTUAL_WIDTH / 2 - 2
    ballY = VIRTUAL_HEIGHT / 2 - 2
    ballDX = math.random(-50, 50)
    ballDY = math.random(-25, 25)

end

function love.update(dt)
    ballX = ballX + ballDX*dt
    ballY = ballY + ballDY*dt
end

function love.draw()
    push:apply('start')
    
    love.graphics.clear(0/255, 45/255, 52/255, 255/255)

    love.graphics.printf(
        'Hello Pong!', 
        0,
        VIRTUAL_HEIGHT /2 -6,
        VIRTUAL_WIDTH, 
        'center')

    love.graphics.rectangle('fill', 10, 30, 5, 20)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 50, 5, 20)
    love.graphics.rectangle('fill', ballX, ballY, 4, 4)

    push:apply('end')
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end
