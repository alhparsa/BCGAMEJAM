from godot import exposed, export
from godot.bindings import *
from godot.globals import *
import sys
sys.path.append('C:/Users/Ari\ Blondal/AppData/Local/Programs/Python/Python37-32/Lib/site-packages');
import numpy as np


@exposed
class Main(Node):

    # member variables here, example:
    a = export(int)
    b = export(str, default='foo')
    def _ready(self):
        """
        Called every time the node is added to the scene.
        Initialization here.
        """
        array_np = np.arange(15).reshape(3, 5)
