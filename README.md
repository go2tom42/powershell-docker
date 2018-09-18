If anyone can make this image smaller please do so



This is a powershell script that downloads videos from a list of IDs, It them monitors the ID for new videos and grabs them too


ripper.ini file looks like this



![INI](https://i.imgur.com/xOCH6kD.png)

- 720p=1 will download 720p MP4 files
- 720p=0 will download 1080p MP4 files

- Video files names will be the title with the video ID at the end for a [PLEX addon](https://github.com/ZeroQI/YouTube-Agent.bundle)

- Don't worry about lastid=, the script will file that in, but you need to include lastid= when adding sections to the INI file

- ID=, can be either the channel ID (starts with UC) or a playlist ID (Starts with PL).  If you you don't know how to get a channel ID [HERE](http://johnnythetank.github.io/youtube-channel-name-converter/). Playlist ID are in the URL, you want everything after list= youtube.com/watch?v=0RAlf58PcY0&list=**PLIPYu8RdPGbcMxsSxSq-i1Z859BfCDgjj**

- directory= must start with /media/ then the folder name you want 




Example docker-compose.yml





![YML](https://i.imgur.com/Jz2Lj7a.png)



Script works on windows, but you would need to
- Have [youtube-dl](https://github.com/rg3/youtube-dl) installed (in system path)
- Have [aria2](https://github.com/aria2/aria2) installed (in system path)
- Change directory settings in the ripper.ini for each section `c:\where\to\put\files`
