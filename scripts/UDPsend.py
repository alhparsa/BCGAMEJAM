from godot import exposed, export
from godot.bindings import *
from godot.globals import *
import websockets as ws
import asyinco

#import usocket as socket
import socket

@exposed
class UDP(Node):

    # member variables here, example:
    a = export(int)
    b = export(str, default='foo')

    def _ready(self):
        """
        Called every time the node is added to the scene.
        Initialization here.
        """
        self.sock = socket.socket(socket.AF_INET, # Internet
                             socket.SOCK_DGRAM) # UDP
        self.ip, self.port = ["127.0.0.1","6969"]
        
    def _send(self, mode):
        if mode == 'sumo':
            self.sock.sendto(mode, (self.ip, self.port))
        elif mode == 'meteor':
            self.sock.sendto(mode, (self.ip, self.port))

    def _recieve(self):
        data, addr = self.sock.recvfrom(1024)
        return data
        
    def _sumo(self):
        print "sumo"
        self._send{"sumo")
        data = self._recieve()
        return data

    def _meteor(self):
        print "meteor"
        self._send{"meteor")
        data = self._recieve()
        return data