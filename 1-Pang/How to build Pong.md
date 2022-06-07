# How to build Pong

## 0

### Try to Use Love2D
1. install [love2d](https://love2d.org/wiki/Main_Page)
2. creat a Folder named GAME which contains a `main.lua` file.
```lua
function love.draw()
    love.graphics.print("Hello World", 400, 300)
end
```
3. MacOS:`open -n -a love "~/path/to/GAME"`

### Set the Game Windows
#### Important Functions
1. `love.load()`
This function is used for initializing our game state at the very beginning of program execution. Whatever code we put here will be executed once at the very beginning of the program.
2. `love.window.setMode(width, height, params)`
Used to initialize the window’s dimensions and to set parameters like vsync (vertical sync), whether we’re fullscreen or not, and whether the window is resizeable after startup. We won’t be using this function past this example in favor of the push virtual resolution library, which has its own method like this, but it is useful to know if encountered in other code.

#### Code 
```lua
  WINDOW_WIDTH = 1280
  WINDOW_HEIGHT = 720

  function love.load()
      love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
          fullscreen = false,
          resizable = false,
          vsync = true
      })
  end
```

### Draw Hello in the centre.
#### Important Functions
1. `love.draw()`
This function is also called at each frame by LÖVE. 
It is called after the update step completes so that we can draw things to the screen once they’ve changed.
2. `love.graphics.printf(text, x, y, [width], [align])`
Versatile print function that can align text left, right, or center on the screen

#### Code
```lua
  function love.draw()
      love.graphics.printf(
          'Hello Pong!',          
          0,                      
          WINDOW_HEIGHT / 2 - 6,  
          WINDOW_WIDTH,           
          'center')             
  end
```

## Pixel Style (Low-Res)

[PUSH](https://github.com/Ulydev/push)
push is a simple resolution-handling library that allows you to focus on making your game with a fixed resolution.

### import the library & Window size
```lua
  push = require 'push'

  WINDOW_WIDTH = 1280
  WINDOW_HEIGHT = 720

  VIRTUAL_WIDTH = 432
  VIRTUAL_HEIGHT = 243
```

### Code to set Style
use `love.graphics.setDefaultFilter()` to set [mode](https://love2d.org/wiki/FilterMode) of scaling things.

Mode:
1. Linear(default): it makes images blurred.
2. Nearest: it's a pixel style.

```lua
  function love.load()
      love.graphics.setDefaultFilter('nearest', 'nearest')

      push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
          fullscreen = false,
          resizable = false,
          vsync = true
      })
  end
```

### Use push to draw Low-Res images
You’ll notice that our print statement remains unchanged, but we’ve wrapped it between push:apply('start') and push:apply('end') to ensure that its contents will be rendered at our desired virtual resolution.
```lua
  function love.draw()
      push:apply('start')
      love.graphics.printf('Hello Pong!', 0, VIRTUAL_HEIGHT / 2 - 6, VIRTUAL_WIDTH, 'center')
      push:apply('end')
  end

```

## Quit the Game
### Important Function
1. `love.keypressed(key)`
It’ll allow us to receive input from the keyboard for our game.
2. `love.event.quit()`
### 
This must be included in `main.lua`. Then the program is always monitoring whether the user has pressed the escape key on their keyboard.
```lua
  function love.keypressed(key)
      if key == 'escape' then
          love.event.quit()
      end
  end

```

## Draw your Rectangles & Set Font

### Important Function
1. `love.graphics.rectangle(mode, x, y, width, height)`
The mode parameter can be set to fill or line, which results in a filled or outlined rectangle, respectively.

2. `love.graphics.newFont(path, size)`

3. `love.graphics.setFont(font)`

4. `aphics.clear(r, g, b, a)`

### Code
#### To set Font
Add this to `love.load()`
```lua
  smallFont = love.graphics.newFont('font.ttf', 8)
  love.graphics.setFont(smallFont)
```
#### To set Backgroud and Draw Rectangles
Add this to `love.load()`
```lua
  raphics.clear(40/255, 45/255, 52/255, 255/255)

  love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')

  love.graphics.rectangle('fill', 10, 30, 5, 20)
  love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 50, 5, 20)
  love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)
```

## Move your Paddles
set the speed of paddles at the top of love.load(): `  PADDLE_SPEED = 200`
1. variables of paddles in `love.load()`
```lua
  scoreFont = love.graphics.newFont('font.ttf', 32)

  player1Score = 0
  player2Score = 0

  player1Y = 30
  player2Y = VIRTUAL_HEIGHT - 50
```
2. draw it in `love.draw()`
```lua
  love.graphics.setFont(scoreFont)
  love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
  love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
```
3. move it in `love.update()`
```lua
  function love.update(dt)
      if love.keyboard.isDown('w') then
          player1Y = player1Y + -PADDLE_SPEED * dt
      elseif love.keyboard.isDown('s') then
          player1Y = player1Y + PADDLE_SPEED * dt
      end

      if love.keyboard.isDown('up') then
          player2Y = player2Y + -PADDLE_SPEED * dt
      elseif love.keyboard.isDown('down') then
          player2Y = player2Y + PADDLE_SPEED * dt
      end
  end
```
## Move your ball
creat the ball in `love.load()` & `love.draw()` and make it move in `love.update()`

### some math problem
1. math.randomseed(num)
2. os.time()
3. math.random(min, max)
4. math.min(num1, num2)
5. math.max(num1, num2)
### steps
`math.randomseeds(os.time())` at top.
1. new variables of balls
```lua
  ballX = VIRTUAL_WIDTH / 2 - 2
  ballY = VIRTUAL_HEIGHT / 2 - 2

  ballDX = math.random(2) == 1 and 100 or -100
  ballDY = math.random(-50, 50)

  gameState = 'start'
```
2. draw it
```lua
  if gameState == 'start' then
      love.graphics.printf('Hello Start State!', 0, 20, VIRTUAL_WIDTH, 'center')
  else
      love.graphics.printf('Hello Play State!', 0, 20, VIRTUAL_WIDTH, 'center')
  end

  love.graphics.rectangle('fill', 10, player1Y, 5, 20)
  love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)
  love.graphics.rectangle('fill', ballX, ballY, 4, 4)
```
3. move it
```lua
  if gameState == 'play' then
      ballX = ballX + ballDX * dt
      ballY = ballY + ballDY * dt
  end
```
4. make it moving
```lua
  elseif key == 'enter' or key == 'return' then
      if gameState == 'start' then
          gameState = 'play'
      else
          gameState = 'start'

          ballX = VIRTUAL_WIDTH / 2 - 2
          ballY = VIRTUAL_HEIGHT / 2 - 2

          ballDX = math.random(2) == 1 and 100 or -100
          ballDY = math.random(-50, 50) * 1.5
      end
  end
```

## Clean Code
Hump has a utility called [class.lua](https://github.com/vrld/hump/blob/master/class.lua) to help you to do that.

## FPS
adds a title to our screen and displays the FPS of our application on the screen as well
1. Fuctions: `love.window.setTitle(title)`,`love.timer.getFPS()`
2. Our first addition to the code is in love.load():
 `love.window.setTitle('Pong')`
3. function to draw FPS.
```lua
  function displayFPS()
      love.graphics.setFont(smallFont)
      love.graphics.setColor(0, 255/255, 0, 255/255)
      love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
  end
```
4. call it in `love.draw()`

## Collision
1. Detect collection by posion.
```lua
  if rect1.x is not > rect2.x + rect2.width and
      rect1.x + rect1.width is not < rect2.x and
      rect1.y is not > rect2.y + rect2.height and
      rect1.y + rect1.height is not < rect2.y:
      collision is true
  else
      collision is false
```
2. add collision detection in `love.update()`
```lua
  if ball:collides(player1) then
      ball.dx = -ball.dx * 1.03
      ball.x = player1.x + 5

      if ball.dy < 0 then
          ball.dy = -math.random(10, 150)
      else
          ball.dy = math.random(10, 150)
      end
  end
  if ball:collides(player2) then
      ball.dx = -ball.dx * 1.03
      ball.x = player2.x - 4

      if ball.dy < 0 then
          ball.dy = -math.random(10, 150)
      else
          ball.dy = math.random(10, 150)
      end
  end
```
## Score

## New a Server State
1. We can essentially add our new “serve” state by making an additional condition within our `love.update() `function:
```lua
  if gameState == 'serve' then
      ball.dy = math.random(-50, 50)
      if servingPlayer == 1 then
          ball.dx = math.random(140, 200)
      else
          ball.dx = -math.random(140, 200)
      end
  elseif ...
```
The idea is that when a player gets scored on, they should get to serve the ball, so as to not be immediately on defense. We do this by adjusting the ball velocity in the “serve” state based off which player is serving.

## Victory
1. We introduce a new state: “done”, and then we set a maximum score (in our case, 10). Within love.update(), we modify our code that checks whether a point has been scored as follows:
```lua
  if ball.x < 0 then
      servingPlayer = 1
      player2Score = player2Score + 1

      if player2Score == 10 then
          winningPlayer = 2
          gameState = 'done'
      else
          gameState = 'serve'
          ball:reset()
      end
  end

  if ball.x > VIRTUAL_WIDTH then
      servingPlayer = 2
      player1Score = player1Score + 1

      if player1Score == 10 then
          winningPlayer = 1
          gameState = 'done'
      else
          gameState = 'serve'
          ball:reset()
      end
  end
```
2. When a player reaches the maximum score, the game state transitions to “done” and we produce a victory screen in love.draw():
```lua
  elseif gameState == 'done' then
      love.graphics.setFont(largeFont)
      love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!', 0, 10, VIRTUAL_WIDTH, 'center')
      love.graphics.setFont(smallFont)
      love.graphics.printf('Press Enter to restart!', 0, 30, VIRTUAL_WIDTH, 'center')
  end
```
3. Finally, we add some code to love.keypressed(key) to transition back to the “serve” state and reset the scores in case the player(s) would like to play again.
```lua
  elseif key == 'enter' or key == 'return' then
      ...
      elseif gameState == 'done' then
          gameState = 'serve'

          ball:reset()

          player1Score = 0
          player2Score = 0

          if winningPlayer == 1 then
              servingPlayer = 2
          else
              servingPlayer = 1
          end
      end
  end
```
## Add some Audios
1. Fuction: love.audio.newSource(path, [type])
2. make music with [bfxr.net](https://www.bfxr.net/)
3. They are small, so we are storing them as 'static' audio file. If they are large, we might consider storing them as 'steam' audio file as to save on memory.
```lua
  sounds = {
      ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
      ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
      ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
  }
```
4. Use them with `sounds['paddle_hit']:play()`

## Resize the windows
1. Fuction: love.resize(width, height)
2. set `resizable = true` in `love.load()`
3. overwrite `love.resize()`
```lua
  function love.resize(w, h)
      push:resize(w, h)
  end
```
