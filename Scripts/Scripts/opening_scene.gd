extends Control
@onready var story_text: Label = $text/story_text
@onready var timer: Timer = $timer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $sprites/AnimatedSprite2D


var story_count: = 0
var text_array:= ["Jason ate tons of mangos, played golf and attempted 
to catch fish as his son played super mega baseball 
 on the television.",
	 "          Life was simple, and he was happy.", 
	"But one day... a factory was built over Leath’s land.", 
	"The evil “mango corp”, run by the evil Mr White, 
	was destroying the land and worst of all...", 
	"                    Stealing leaths mangos.",
	"Jason got angry. so he built a catapult and 
	got ready for war with Mr. White."]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start(5)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("input_interact"):
		new_story_text()

func change_text(str):
	story_text.text = str(str)

func _on_timer_timeout() -> void:
	new_story_text()

func new_story_text():
	animated_sprite_2d.frame = (story_count + 1)
	if story_count == 5:
		audio_stream_player.play()
	if story_count == 6:
		get_tree().change_scene_to_file("res://Scenes/menu_scene.tscn")
	else:
		change_text(text_array[story_count])
		story_count += 1
		timer.start(5)
