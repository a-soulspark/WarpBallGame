extends KinematicBody2D

# Parâmetros de Movimento
const JUMP_BUFFER = 0.1
const JUMP_FORCE = -300
const FALL_FORCE = -500
const MOVEMENT_SPEED = 200
const GRAVITY = 900

# Estado do Input
var vel = Vector2()
var input_x = 0
var jump_buffer = 0
var jump_held = false
var fire_triggered

# pega o input no process (mais recomendado)
func _process(delta): get_input(delta)

# processa o movimento no physics_process
func _physics_process(delta):
	move_vertical(delta)
	apply_movement(delta)
	fire(delta)

func get_input(delta):
	# geta o input horizontal (nao precisava de uma variavel extra pra isso, mas eh melhor pegar no _process() e eu acho mais bonito desse jeito kk
	if Input.is_action_pressed("ui_right"): input_x = 1
	elif Input.is_action_pressed("ui_left"): input_x = -1
	else: input_x = 0
	
	# verdadeiro se o botao de pulo tá segurado (até soltar)
	jump_held = Input.is_action_pressed("jump")
	jump_buffer -= delta
	if Input.is_action_just_pressed("jump"): jump_buffer = JUMP_BUFFER
	# jump buffer serve pra qnd o player aperta pulo antes de tocar no chao, ele ainda deixar pular qnd tocar no chao
	# deixa o movimento mais fluido
	
	fire_triggered = Input.is_action_just_pressed("fire")

func move_vertical(delta):
	vel.y += GRAVITY * delta # aplica gravidade
	
	# se pulo não tá apertado ou vc ta caindo, cai mais rápido
	if !jump_held or vel.y > 0: vel.y -= FALL_FORCE * delta
	if is_on_floor() and jump_buffer > 0: jump() # se vc apertou pulo recentemente e ta no chao, pula

func apply_movement(delta):
	# seta a velocidade pra ser o input obtido no _process()
	vel.x = input_x * MOVEMENT_SPEED
	
	# se estiver se movendo, define a direção do sprite do jogador
	if vel.x < 0: $Sprite.flip_h = true
	elif vel.x > 0: $Sprite.flip_h = false
	
	vel = move_and_slide(vel, Vector2.UP) # aplica o movimento

func fire(delta):
	if fire_triggered: # se apertou pra atirar...
		fire_triggered = false
		# vide throw_ball()
		if $WarpBall.thrown: warp_to_ball()
		else: throw_ball()

func jump():
	vel.y = JUMP_FORCE # aplica a força
	jump_buffer = 0 # reseta o buffer

# se n tava tacando, taca
func throw_ball():
	$WarpBall.direction = get_local_mouse_position() # seta a direção pra a posição do mouse relativa ao jogador (eg. se o mouse tivesse em cima do jogador, seria (0, 0))
	$WarpBall.throw(position) # avisa a bolinha q ela foi tacada

# se tava tacando, teleporta
func warp_to_ball():
	position = $WarpBall.position
	$WarpBall.warp() # avisa a bolinha q o player deu tp pra ela
