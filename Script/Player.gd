extends CharacterBody2D
class_name Player

@export_group("Physics")
@export var SPEED : float = 70.0
@export var JUMP_VELOCITY : float = -100.0
@export var GRAVITY : float = 390
@export var FAST_GRAVITY : float = 1200
@export var PEAK_GRAVITY : float = 100
@export var PEAK_GRAVITY_RANGE_MIN : float = -5
@export var PEAK_GRAVITY_RANGE_MAX : float = 5

@export_group("Animation")
@export var FRAMES_PER_SECOND : int = 12

@onready var Sprite : Sprite2D = $Sprite
@onready var SpriteEyes : Sprite2D = $Sprite/Eyes

var m_anim_timer : float = 0.0
var m_note_timer : float = 0.0

var m_current_note : int = 0

func _process(delta: float) -> void:
	m_handle_animation(delta)
	m_handle_singing(delta)
	

func _physics_process(delta: float) -> void:
	# get input
	var jump_input := Input.is_action_just_pressed("Jump")
	var jump_held := Input.is_action_pressed("Jump")
	var input_direction := Input.get_axis("Left", "Right")
	
	# add the gravity.
	var gravity : float = GRAVITY
	if not jump_held and velocity.y < PEAK_GRAVITY_RANGE_MIN: 
		gravity = FAST_GRAVITY 
	if velocity.y > PEAK_GRAVITY_RANGE_MIN and velocity.y < PEAK_GRAVITY_RANGE_MAX:
		gravity = PEAK_GRAVITY
	
	velocity.y += gravity * delta
	
	# handle jump.
	if jump_input and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# get the input direction and handle the movement/deceleration
	var target_speed = input_direction * SPEED
	velocity.x = move_toward(velocity.x, target_speed, SPEED)
	
	move_and_slide()

func m_handle_animation(delta: float) -> void:
	if velocity.x < 0.0:
		Sprite.scale.x = -1.0
	if velocity.x > 0.0:
		Sprite.scale.x = 1.0
	
	if absf(velocity.y) > 0.001:
		Sprite.frame = 1
		m_anim_timer = 0.0
	elif absf(velocity.x) < 0.001:
		Sprite.frame = 0
		m_anim_timer = 0.0
	else:
		m_anim_timer += delta
		var frame_length : float = 1.0 / float(FRAMES_PER_SECOND) 
		Sprite.frame = int(m_anim_timer / frame_length) % 4
	
	SpriteEyes.frame = Sprite.frame + (4 * m_current_note)
	
	if m_note_timer > 0.0:
		m_note_timer -= delta
		if m_note_timer <= 0.0:
			$Sprite/NoteSprite.visible = false
		else:
			$Sprite/NoteSprite.visible = true

func m_handle_singing(delta: float) -> void:
	
	var input_cycle_left := Input.is_action_just_pressed("Cycle Note Left")
	var input_cycle_right := Input.is_action_just_pressed("Cycle Note Right")
	var input_cycle_axis := int(input_cycle_right) - int(input_cycle_left)
	var input_sing := Input.is_action_just_pressed("Sing")
	
	m_current_note += input_cycle_axis
	m_current_note %= 4
	while m_current_note < 0: m_current_note += 4
	
	if input_sing:
		SoundSpace.play_note(m_current_note)
		$Sprite/NoteSprite.frame = m_current_note
		m_note_timer = 0.5
	
	pass
