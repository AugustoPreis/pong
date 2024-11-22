--Configurações do jogo
--TODO: Tornar as configurações configuráveis pelo usuário
WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600
PADDLE_WIDTH = 10
PADDLE_HEIGHT = 100
BALL_SIZE = 10
PADDLE_SPEED = 400
BALL_SPEED = 300

function love.load()
  love.window.setTitle("Pong")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    vsync = true,
    resizable = false
  })

  --Posição inicial das raquetes (meio da tela)
  player1Y = (WINDOW_HEIGHT / 2) - (PADDLE_HEIGHT / 2)
  player2Y = (WINDOW_HEIGHT / 2) - (PADDLE_HEIGHT / 2)

  --Posição inicial da bola (meio da tela)
  ballX = WINDOW_WIDTH / 2 - BALL_SIZE / 2
  ballY = WINDOW_HEIGHT / 2 - BALL_SIZE / 2

  --Velocidade inicial da bola
  ballDX = BALL_SPEED
  ballDY = BALL_SPEED

  -- Pontuação inicial
  player1Score = 0
  player2Score = 0

  scoreFont = love.graphics.newFont(32)
end

function love.update(dt)
  --Movimentação do jogador 1 (W e S)
  if love.keyboard.isDown("w") then
    player1Y = math.max(0, player1Y - PADDLE_SPEED * dt)
  elseif love.keyboard.isDown("s") then
    player1Y = math.min(WINDOW_HEIGHT - PADDLE_HEIGHT, player1Y + PADDLE_SPEED * dt)
  end

  --Movimentação do jogador 2 (UP e DOWN)
  if love.keyboard.isDown("up") then
    player2Y = math.max(0, player2Y - PADDLE_SPEED * dt)
  elseif love.keyboard.isDown("down") then
    player2Y = math.min(WINDOW_HEIGHT - PADDLE_HEIGHT, player2Y + PADDLE_SPEED * dt)
  end

  --Atualizar posição da bola
  ballX = ballX + ballDX * dt
  ballY = ballY + ballDY * dt

  --Rebater a bola nas bordas superior e inferior
  if ballY <= 0 or ballY >= WINDOW_HEIGHT - BALL_SIZE then
    ballDY = -ballDY
  end

  --Verificar colisão com a raquete do jogador 1
  if ballX <= PADDLE_WIDTH and ballY + BALL_SIZE >= player1Y and ballY <= player1Y + PADDLE_HEIGHT then
    ballDX = -ballDX

    --Evita atravessar a raquete
    ballX = PADDLE_WIDTH
  end

  -- Verificar colisão com a raquete do jogador 2
  if ballX + BALL_SIZE >= WINDOW_WIDTH - PADDLE_WIDTH and ballY + BALL_SIZE >= player2Y and ballY <= player2Y + PADDLE_HEIGHT then
    ballDX = -ballDX

    --Evita atravessar a raquete
    ballX = WINDOW_WIDTH - PADDLE_WIDTH - BALL_SIZE
  end

  -- Pontuação para o jogador 2
  if ballX < 0 then
    player2Score = player2Score + 1

    resetBall()
  end

  -- Pontuação para o jogador 1
  if ballX > WINDOW_WIDTH then
    player1Score = player1Score + 1

    resetBall()
  end
end

function love.draw()
  --Fundo
  love.graphics.clear(0, 0, 0)

  --Paddles
  love.graphics.rectangle("fill", 0, player1Y, PADDLE_WIDTH, PADDLE_HEIGHT)
  love.graphics.rectangle("fill", WINDOW_WIDTH - PADDLE_WIDTH, player2Y, PADDLE_WIDTH, PADDLE_HEIGHT)

  --Bola
  love.graphics.rectangle("fill", ballX, ballY, BALL_SIZE, BALL_SIZE)

  --Pontuação
  love.graphics.setFont(scoreFont)
  love.graphics.print(player1Score, WINDOW_WIDTH / 2 - 50, 20)
  love.graphics.print(player2Score, WINDOW_WIDTH / 2 + 30, 20)
end

function love.keypressed(key)
  -- Sair do jogo
  if key == "escape" then
    love.event.quit()
  end
end

function resetBall()
  ballX = WINDOW_WIDTH / 2 - BALL_SIZE / 2
  ballY = WINDOW_HEIGHT / 2 - BALL_SIZE / 2
  ballDX = -ballDX
  ballDY = BALL_SPEED
end
