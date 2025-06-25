# Sudoku Game for IAPX 88 Processor

This is a simple Sudoku game implemented for the **IAPX 88 processor**, featuring keyboard input, a timer, and auditory feedback. The game is designed to run on a processor with a basic graphical display and keyboard interface. The game validates row completions and generates a sound effect upon the successful completion of any row. The system also tracks and displays the time taken to complete the puzzle.

## Features

- **Keyboard Input Handling**: The game uses keyboard interrupts to handle user input. Each key press corresponds to a number from 1 to 9, which is used to fill cells in the Sudoku puzzle.
- **Timer**: The game has a built-in timer that tracks how long the player takes to complete the puzzle. The timer is updated periodically through interrupts.
- **Sound on Row Completion**: When a player successfully completes a row, a sound is generated as auditory feedback to indicate progress.
- **Efficient Interrupt Handling**: The IAPX 88 processor’s interrupt system is leveraged to manage user input, timer updates, and sound generation, ensuring smooth real-time gameplay.

## Requirements

- **IAPX 88 Processor** or compatible environment.
- **Keyboard** for input.
- **Display** (basic graphical or character-based).
- **Sound Output** (via an external sound generator or speaker).
  
## Game Instructions

1. Upon running the game, the Sudoku grid will be displayed on the screen.
2. Use the keyboard to fill in numbers from 1 to 9 into the grid.
3. The game validates rows as they are completed. When a row is correct, a sound will be played.
4. Keep an eye on the timer, which tracks your time as you play.
5. Complete the grid to win the game. A final sound will play to indicate success.

## Architecture and Design

### IAPX 88 Processor

- **Keyboard Interrupts**: Used for capturing user input in real time. Each key press updates the corresponding cell in the Sudoku grid.
- **Timer Interrupts**: The game uses periodic interrupts to update and display the timer on the screen.
- **Sound Generation**: The processor triggers sound upon the completion of any row in the grid using an output port for sound generation.

### Game Logic

1. **Input Handling**: The game listens for key presses and updates the grid based on the numbers entered. It ensures that the player's inputs match the Sudoku rules.
2. **Row Validation**: The game checks for completed rows. When a row is correctly filled, a sound is triggered to notify the player.
3. **Timer Function**: The timer counts down (or up), showing the time taken by the player to complete the puzzle.

## Usage

1. Compile and load the Sudoku game program onto the IAPX 88 processor.
2. Connect the keyboard and display to the system.
3. Run the game, which will show a Sudoku grid and begin accepting input.
4. Fill in the grid by typing numbers corresponding to empty cells. The timer will start as soon as you begin inputting data.
5. When a row is completed correctly, a sound will play. Continue until the entire grid is completed.
6. The game ends when the entire grid is filled correctly.

## Contributing

Feel free to contribute to this project by submitting issues or pull requests. If you have any ideas for improving the game or additional features you would like to see, please let us know!

## License

This project is open-source and available under the [MIT License](LICENSE).
