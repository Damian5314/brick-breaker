# Brick Breaker

A classic brick breaker game built with LÖVE (Love2D) in Lua. Destroy all the blocks, collect upgrades, and progress through increasingly challenging levels!

## How to Play
- Move the paddle left and right with the arrow keys.
- Press `SPACE` to start the game or advance to the next level.
- Bounce the ball to break all the blocks.
- If you lose all balls, you lose a life. Lose all lives and it's game over.
- Collect falling upgrades for special effects!
- Press `ESC` to pause/unpause. Press `R` to restart after game over.

## Upgrades & Their Colors
When you break a block, there's a chance an upgrade will drop. Catch it with your paddle to activate its effect:

| Upgrade       | Color         | Effect                                      |
|-------------- |--------------|----------------------------------------------|
| Bigger Paddle | Cyan         | Paddle becomes wider for easier ball control |
| Faster Ball   | Orange       | All balls move faster                        |
| Row Destroy   | Pink/Red     | Destroys an entire row of blocks             |
| Extra Life    | Green        | Gain an extra life                           |
| Multiball     | Yellow       | Splits ball(s) into two for more action      |

## Block Types & Colors
- **Normal Block (Blue):** Standard block, breaks in one hit.
- **Hard Block (Orange):** Takes two hits to break. Shows remaining health as a number.
- **Unbreakable Block (Gray):** Cannot be destroyed, acts as an obstacle.

## Features
- Multiple levels (each level adds more rows of blocks)
- Three block types: normal, hard (2 hits), and unbreakable
- Score and lives tracking
- Five unique upgrades, each with a distinct color and effect
- Pause and restart functionality
- Multiball chaos and row-clearing powerups
- Hard blocks display their remaining health

## Requirements
- [LÖVE 2D](https://love2d.org/) (Love2D) engine

## Running the Game
1. Install Love2D.
2. Download or clone this repository.
3. Run the game:
   - On Windows: Drag the project folder onto `love.exe` or run `love .` in the project directory.

Enjoy breaking bricks and chasing high scores!
