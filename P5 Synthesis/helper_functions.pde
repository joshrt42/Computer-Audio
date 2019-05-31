//Helper Functions
AudioContext ac;

void playSine() {
  for (int wave = 1; wave<10; wave++) {
    gainGlideArray[wave].setValue(0);
  }
}

void playSquare() {
  for (int wave = 1; wave<10; wave++) {
    freqGlideArray[wave].setValue(freqGlideArray[0].getValue()*((2*(wave+1))-1));
    gainGlideArray[wave].setValue(1.0/(wave+1));
  }
}

void playTriangle() {
  for (int wave = 1; wave<10; wave++) {
    freqGlideArray[wave].setValue(freqGlideArray[0].getValue()*((2*(wave+1))-1));
    gainGlideArray[wave].setValue(1.0/((wave+1)*(wave+1)));
  }
}

void playSawtooth() {
  for (int wave = 1; wave<10; wave++) {
    freqGlideArray[wave].setValue(freqGlideArray[0].getValue()*(wave+1));
    gainGlideArray[wave].setValue(1.0/(wave+1));
  }
}

void updateFundamentals(int mode) {
   if (mode == 0)
     playSine();
   else if (mode == 1)
     playSquare();
   else if (mode == 2)
     playTriangle();
   else if (mode == 3)
     playSawtooth();
}
