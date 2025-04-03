extends XROrigin3D

@export var speed := 1.0
@export var sensitivity := 1.0

@onready var camera := $XRCamera3D

var yaw := 0.0
var pitch := 0.0
var cam_yaw := 0.0
var cam_pitch := -20.0

func _ready():
	camera.position = camera.position + Vector3(0, 0.4, 0.6)
	camera.rotation.x = deg_to_rad(cam_pitch)

func _physics_process(delta):
	# Look
	if Input.is_action_pressed("look_left"):
		cam_yaw += sensitivity
	if Input.is_action_pressed("look_right"):
		cam_yaw -= sensitivity
	if Input.is_action_pressed("look_up"):
		cam_pitch = clamp(cam_pitch - sensitivity, -90, 90)
	if Input.is_action_pressed("look_down"):
		cam_pitch = clamp(cam_pitch + sensitivity, -90, 90)

	camera.rotation.y = deg_to_rad(cam_yaw)
	camera.rotation.x = deg_to_rad(cam_pitch)

	if not Input.is_key_pressed(KEY_SHIFT):
		# Rotate horizontally
		if Input.is_action_pressed("rotate_left"):
			yaw += sensitivity
		if Input.is_action_pressed("rotate_right"):
			yaw -= sensitivity
		if Input.is_action_pressed("rotate_up"):
			pitch = clamp(pitch - sensitivity, -90, 90)
		if Input.is_action_pressed("rotate_down"):
			pitch = clamp(pitch + sensitivity, -90, 90)

		rotation.y = deg_to_rad(yaw)
		rotation.x = deg_to_rad(pitch)

		# Movement
		var dir := Vector3.ZERO
		var cam_basis: Basis = camera.global_transform.basis  # From XRCamera3D

		# Movement relative to look direction
		if Input.is_action_pressed("move_forward"):
			dir -= cam_basis.z
		if Input.is_action_pressed("move_backward"):
			dir += cam_basis.z
		if Input.is_action_pressed("move_left"):
			dir -= cam_basis.x
		if Input.is_action_pressed("move_right"):
			dir += cam_basis.x

		# Lock to horizontal plane
		dir.y = 0

		# Manual vertical overrides
		if Input.is_action_pressed("move_up"):
			dir += Vector3.UP
		if Input.is_action_pressed("move_down"):
			dir -= Vector3.UP

		if dir.length() > 0.001:
			global_position += dir.normalized() * speed * delta
