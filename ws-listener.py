import asyncio
import websockets
import pyaudio
import wave
import numpy as np
from scipy.io.wavfile import read

# constants
CHUNK = 1024
FORMAT = pyaudio.paInt16
CHANNELS = 1
RATE = 44100
RECORD_SECONDS = 1


async def themasterpiece(port):
    async with websockets.connect(  
        'ws://localhost:'+str(port)) as websocket:
        command = await websocket.recv()
        if (command == "sumo"):
            prev = 0
            for i in range (2):
                WAVE_OUTPUT_FILENAME = "output_"+str(i)+".wav"
                p = pyaudio.PyAudio()
                stream = p.open(format=FORMAT,
                            channels=CHANNELS,
                            rate=RATE,
                            input=True,
                            frames_per_buffer=CHUNK)
                frames = []
                for _ in range(0, int(RATE / CHUNK * RECORD_SECONDS)):
                    data = stream.read(CHUNK)
                    frames.append(data)
                stream.stop_stream()
                stream.close()
                p.terminate()
                wf = wave.open(WAVE_OUTPUT_FILENAME, 'wb')
                wf.setnchannels(CHANNELS)
                wf.setsampwidth(p.get_sample_size(FORMAT))
                wf.setframerate(RATE)
                wf.writeframes(b''.join(frames))
                wf.close() 
                str_rec = np.array(read(WAVE_OUTPUT_FILENAME)[1])
                str_fft = np.fft.rfft(str_rec)
                print(np.argmax(str_fft))
                if (i == 0):
                    prev = np.argmax(str_fft)
                    pass
                elif (np.argmax(str_fft) > prev+12):
                    print('up')
                    await websocket.send('up')
                elif (np.argmax(str_fft) < prev - 12):
                    print('down')
                    await websocket.send('down')		
                else:
                    print('no change')
                    await websocket.send('no change')
                prev = np.argmax(str_fft)
                p.terminate()
        else:
            hit_freq = await websocket.recv()
            for i in range (2):
                WAVE_OUTPUT_FILENAME = "output_"+str(i)+".wav"
                p = pyaudio.PyAudio()
                stream = p.open(format=FORMAT,
                            channels=CHANNELS,
                            rate=RATE,
                            input=True,
                            frames_per_buffer=CHUNK)
                frames = []
                for _ in range(0, int(RATE / CHUNK * RECORD_SECONDS)):
                    data = stream.read(CHUNK)
                    frames.append(data)
                stream.stop_stream()
                stream.close()
                p.terminate()
                wf = wave.open(WAVE_OUTPUT_FILENAME, 'wb')
                wf.setnchannels(CHANNELS)
                wf.setsampwidth(p.get_sample_size(FORMAT))
                wf.setframerate(RATE)
                wf.writeframes(b''.join(frames))
                wf.close() 
                str_rec = np.array(read(WAVE_OUTPUT_FILENAME)[1])
                str_fft = np.fft.rfft(str_rec)
                print(np.argmax(str_fft))
                elif (np.argmax(str_fft) >= hit_freq):
                    print('true')
                    await websocket.send('true')
                else:
                    print('false')
                    await websocket.send('true')		
                p.terminate()



asyncio.get_event_loop().run_until_complete(themasterpiece(7200))
asyncio.get_event_loop().run_forever()