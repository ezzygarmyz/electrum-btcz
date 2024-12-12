#!/usr/bin/env python
#
# Electrum - lightweight Bitcoin client
# Copyright (C) 2015 Thomas Voegtlin
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation files
# (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import sys
import time
from pyzbar.pyzbar import decode
from PIL import Image

try:
    from cv2 import VideoCapture
    opencv = True
except ImportError:
    opencv = None
    raise RuntimeError("OpenCV is required for capturing video.")

def scan_barcode(device='', timeout=-1, display=True, threaded=False, try_cnt=10):
    if not device:
        device = 0  # Default to first camera
    
    # Open the video capture device
    cap = VideoCapture(device)
    if not cap.isOpened():
        raise RuntimeError(f"Cannot open device {device}")
    
    cap.set(3, 640)  # Set frame width
    cap.set(4, 480)  # Set frame height
    
    start_time = time.time()
    
    while True:
        ret, frame = cap.read()
        if not ret:
            continue
        
        # Decode the barcode from the frame using pyzbar
        decoded_objects = decode(frame)
        if decoded_objects:
            # Return the data of the first decoded object
            return decoded_objects[0].data.decode('utf-8')
        
        # Check timeout
        if timeout > 0 and time.time() - start_time > timeout:
            break

        # Display the frame if required
        if display:
            from cv2 import imshow
            from cv2 import waitKey
            imshow('Scanning...', frame)
            if waitKey(1) & 0xFF == ord('q'):
                break
    
    cap.release()
    return None


def _find_system_cameras():
    # Function to list available cameras (not necessary for pyzbar)
    device_root = "/sys/class/video4linux"
    devices = {} # Name -> device
    if os.path.exists(device_root):
        for device in os.listdir(device_root):
            try:
                with open(os.path.join(device_root, device, 'name')) as f:
                    name = f.read()
            except IOError:
                continue
            name = name.strip('\n')
            devices[name] = os.path.join("/dev", device)
    return devices


if __name__ == "__main__":
    print(scan_barcode())
