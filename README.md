# YOLO in Japanese

not real-time

## Example 1

<img src="./img/horses_0.png" width="400">

<img src="./img/horses_1.png" width="400">

## Example 2 (Shibuya Crossing)

<img src="./img/shibuya.gif" width="400">

## Process

    in/*.png -----------+
      |                 |
      | darknet.py      |
      | (YOLOv3)        |
      v                 |
    in/result.txt ------+
                        |
                        | yj.rb
                        v
                      out/*.png

## Reference

YOLO: Real-Time Object Detection  
[https://pjreddie.com/darknet/yolo/](https://pjreddie.com/darknet/yolo/)
