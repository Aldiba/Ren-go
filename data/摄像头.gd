extends Camera2D

@export var zoomSpeed : float = 10;
#@export var boundary : float = 0.04;
@export var PanSpeed : float = 8;
var MousePos:Vector2
var zoomTarget :Vector2

var dragStartMousePos = Vector2.ZERO
var dragStartCameraPos = Vector2.ZERO
var isDragging : bool = false

var is_active:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	zoomTarget = zoom
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if enabled:
		Zoom(delta)
		SimplePan(delta)
		ClickAndDrag()



func camera_return():
	if position.x < 0:
		position.x = 0
	if position.y < 0:
		position.y = 0
	

func Zoom(delta):
	if Input.is_action_just_pressed("mouse_scroll_up"):
		if zoomTarget.x <=10:
			zoomTarget *= 1.1
		
		
	if Input.is_action_just_pressed("mouse_scroll_down"):
		if zoomTarget.x >= 0.01:
			zoomTarget *= 0.9
		
	zoom = zoom.slerp(zoomTarget, zoomSpeed *delta)
	
	
func SimplePan(delta):
	var moveAmount = Vector2.ZERO
	if Input.is_action_pressed("d") or Input.is_action_pressed("down"):
		moveAmount.x += PanSpeed
		
	if Input.is_action_pressed("a") or Input.is_action_pressed("left"):
		moveAmount.x -= PanSpeed
		
	if Input.is_action_pressed("w") or Input.is_action_pressed("up"):
		moveAmount.y -= PanSpeed
		
	if Input.is_action_pressed("s") or Input.is_action_pressed("right"):
		moveAmount.y += PanSpeed
		
	moveAmount = moveAmount.normalized()
	position += moveAmount * delta * 1000 * (1/zoom.x)
	
func ClickAndDrag():
	if !isDragging and Input.is_action_just_pressed("mouse_scroll_press"):
		dragStartMousePos = get_viewport().get_mouse_position()
		dragStartCameraPos = position
		isDragging = true
		
	if isDragging and (Input.is_action_just_released("mouse_scroll_press") or Input.is_action_just_released("mouse_right_press")):
		isDragging = false
		
	if isDragging:
		var moveVector = get_viewport().get_mouse_position() - dragStartMousePos
		position = dragStartCameraPos - moveVector * 1/zoom.x	
		
func _input(event):
	if enabled:
		if event is InputEventMouseMotion:
			MousePos = event.position
	
