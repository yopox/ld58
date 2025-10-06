extends Node

# — UI —
const SCREEN_H: int = 180
const SCREEN_W: int = 320

const TEXTBOX_W: float = 180
const TEXTBOX_H: float = 48
const TEXTBOX_APPEAR_DELAY: float = 0.2
const TEXTBOX_APPEAR_DY: float = 4.0
const TEXTBOX_OFFSET: Vector2 = Vector2(-TEXTBOX_W / 2.0, -TEXTBOX_H - 24)
const TEXTBOX_MIN_X: float = 24.0
const TEXTBOX_CHAR_FRAMES: int = 1

const LOCATION_TITLE_DISAPPEAR_DELAY: float = 2.0
const LOCATION_TITLE_DISAPPEAR_DURATION: float = 0.5

const TRANSITION_TIME: float = 0.5
const TRANSITION_DELAY: float = 0.75

# — INTRO —
const INTRO_HAND_APPEAR: float = 0.35
const HAND_SPEED: float = 50.0

# — PLACES —
const WALKABLE_Y: float = SCREEN_H * 0.4
const CHATELET_RIDDLE_SOLVED_DELAY: float = 0.5

# — PLAYER —
const PLAYER_SPEED: float = 80.0

# — ACHIEVEMENT —
const ACHIEVEMENT_TITLE: String = "Eiffel Tower Piece Collected!"
const ACHIEVEMENT_OBJECT_TIME: float = 0.75
const ACHIEVEMENT_CIRCLE_TIME: float = 0.75
const ACHIEVEMENT_TEXT_TIME: float = 0.25
const ACHIEVEMENT_TEXT_DELAY: float = 0.5
