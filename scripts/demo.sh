ffmpeg -r 30 -s 1600x900 -f x11grab -i :0.0 -vcodec libx264 -preset ultrafast -crf 0 -y screencast.mp4
