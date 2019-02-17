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
prev = 0


async def themasterpiece(websocket, path):
    command = await websocket.recv() # wait for the request
    print("command recieved from "+ websocket, path)
    for i in range (4):
	    WAVE_OUTPUT_FILENAME = "output_"+str(i)+".wav"
	    p = pyaudio.PyAudio()
	    stream = p.open(format=FORMAT,
	                channels=CHANNELS,
	                rate=RATE,
	                input=True,
	                frames_per_buffer=CHUNK)
	    frames = []
	    for _in range(0, int(RATE / CHUNK * RECORD_SECONDS)):
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
	        websocket.send('up')
	    elif (np.argmax(str_fft) < prev - 12):
	        print('down')
	        websocket.send('down')		
	    else:
	        print('no change')
	        websocket.send('no change')
	    prev = np.argmax(str_fft)
	p.terminate()
    await websocket.send(greeting)

backend_server = websockets.serve(themasterpiece, 'localhost', 6969)

asyncio.get_event_loop().run_until_complete(backend_server)
asyncio.get_event_loop().run_forever()
