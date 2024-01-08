import os
from pathlib import Path



user_data_paths = [
        r'C:\Program Files (x86)\Steam\userdata\443815666',
        r'C:\Users\Public\Documents\EMPRESS',
        r'C:\Users\Public\Documents\Steam\CODEX',
        os.getenv('APPDATA'),
        str(Path.home() / 'Documents/My Games'), 
        str(Path.home() / 'Saved Games'), 
        
        # Other paths here
    ]
