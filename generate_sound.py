import wave
import struct
import math
import random
import os

os.makedirs('assets/sounds', exist_ok=True)
duration = 1.5
sample_rate = 44100
num_samples = int(duration * sample_rate)

with wave.open('assets/sounds/vandalism.wav', 'w') as wav_file:
    wav_file.setnchannels(1)
    wav_file.setsampwidth(2)
    wav_file.setframerate(sample_rate)

    for i in range(num_samples):
        t = float(i) / sample_rate
        sub = math.sin(2.0 * math.pi * 40.0 * t)
        
        glitch = random.uniform(-1, 1) if random.random() < 0.3 else 0
        
        val = sub + glitch * 0.8
        val = max(min(val * 20.0, 1.0), -1.0)
        
        # Sudden loud start, then decay
        envelope = 1.0 if t < 0.2 else math.exp(-(t-0.2) * 5.0)
        val *= envelope
        
        sample = int(val * 32767.0)
        wav_file.writeframes(struct.pack('<h', sample))

print("Created assets/sounds/vandalism.wav")
