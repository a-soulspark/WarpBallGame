extends RigidBody2D

var thrown = false
var player_position
var direction = Vector2()

func _ready(): set_as_toplevel(true) # isso faz com q a bola nao siga a posição/rotação do jogador, apesar de ser child dele

# uso esse método pq no RigidBody2D, vc n pode mudar a posição diretamente, ao inves tem q usar esse metodo pra mudar a origem do transform 'w.w	
func _integrate_forces(state):
	if player_position: # se a posiçao do player n eh nula, move pra ela
		state.transform.origin = player_position # move a bolinha pra posição do player
		player_position = null # ja moveu a bolinha, ent n precisa mais lembrar da posiçao do player
		linear_velocity = direction.normalized() * 240 # aplica a força pra bolinha ir na direção do mouse
		# TODO: melhorar a trajetória da bola
		
		# espera 2 frames antes de deixar a bolinha visivel (nsei pq tem q ser 2, mas se for so 1 da pra ver a bola antes dela mudar de posição ¯\_(ツ)_/¯
		yield(get_tree(), "physics_frame")
		yield(get_tree(), "physics_frame")
		show()

func throw(origin):
	# thrown e usado pra determinar se deve teleportar ou tacar a bola
	thrown = true
	# salva a posição pra onde deve ir (vide _integrate_forces())
	player_position = origin

# esconde a bola e avisa q n ta mais tacando ela
func warp():
	thrown = false
	hide()
