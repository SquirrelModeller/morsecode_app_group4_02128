enum MorseState {
  Dot,
  Dash,
}

const morseCode = {
  'A': [MorseState.Dot, MorseState.Dash],
  'B': [MorseState.Dash, MorseState.Dot, MorseState.Dot, MorseState.Dot],
  'C': [MorseState.Dash, MorseState.Dot, MorseState.Dash, MorseState.Dot],
  'D': [MorseState.Dash, MorseState.Dot, MorseState.Dot],
  'E': [MorseState.Dot],
  'F': [MorseState.Dot, MorseState.Dot, MorseState.Dash, MorseState.Dot],
  'G': [MorseState.Dash, MorseState.Dash, MorseState.Dot],
  'H': [MorseState.Dot, MorseState.Dot, MorseState.Dot, MorseState.Dot],
  'I': [MorseState.Dot, MorseState.Dot],
  'J': [MorseState.Dot, MorseState.Dash, MorseState.Dash, MorseState.Dash],
  'K': [MorseState.Dash, MorseState.Dot, MorseState.Dash],
  'L': [MorseState.Dot, MorseState.Dash, MorseState.Dot, MorseState.Dot],
  'M': [MorseState.Dash, MorseState.Dash],
  'N': [MorseState.Dash, MorseState.Dot],
  'O': [MorseState.Dash, MorseState.Dash, MorseState.Dash],
  'P': [MorseState.Dot, MorseState.Dash, MorseState.Dash, MorseState.Dot],
  'Q': [MorseState.Dash, MorseState.Dash, MorseState.Dot, MorseState.Dash],
  'R': [MorseState.Dot, MorseState.Dash, MorseState.Dot],
  'S': [MorseState.Dot, MorseState.Dot, MorseState.Dot],
  'T': [MorseState.Dash],
  'U': [MorseState.Dot, MorseState.Dot, MorseState.Dash],
  'V': [MorseState.Dot, MorseState.Dot, MorseState.Dot, MorseState.Dash],
  'W': [MorseState.Dot, MorseState.Dash, MorseState.Dash],
  'X': [MorseState.Dash, MorseState.Dot, MorseState.Dot, MorseState.Dash],
  'Y': [MorseState.Dash, MorseState.Dot, MorseState.Dash, MorseState.Dash],
  'Z': [MorseState.Dash, MorseState.Dash, MorseState.Dot, MorseState.Dot],
  '0': [
    MorseState.Dash,
    MorseState.Dash,
    MorseState.Dash,
    MorseState.Dash,
    MorseState.Dash
  ],
  '1': [
    MorseState.Dot,
    MorseState.Dash,
    MorseState.Dash,
    MorseState.Dash,
    MorseState.Dash
  ],
  '2': [
    MorseState.Dot,
    MorseState.Dot,
    MorseState.Dash,
    MorseState.Dash,
    MorseState.Dash
  ],
  '3': [
    MorseState.Dot,
    MorseState.Dot,
    MorseState.Dot,
    MorseState.Dash,
    MorseState.Dash
  ],
  '4': [
    MorseState.Dot,
    MorseState.Dot,
    MorseState.Dot,
    MorseState.Dot,
    MorseState.Dash
  ],
  '5': [
    MorseState.Dot,
    MorseState.Dot,
    MorseState.Dot,
    MorseState.Dot,
    MorseState.Dot
  ],
  '6': [
    MorseState.Dash,
    MorseState.Dot,
    MorseState.Dot,
    MorseState.Dot,
    MorseState.Dot
  ],
  '7': [
    MorseState.Dash,
    MorseState.Dash,
    MorseState.Dot,
    MorseState.Dot,
    MorseState.Dot
  ],
  '8': [
    MorseState.Dash,
    MorseState.Dash,
    MorseState.Dash,
    MorseState.Dot,
    MorseState.Dot
  ],
  '9': [
    MorseState.Dash,
    MorseState.Dash,
    MorseState.Dash,
    MorseState.Dash,
    MorseState.Dot
  ]
};
