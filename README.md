If anyone can make this image smaller please do so



This is a powershell script that downloads videos from a list of IDs, It them monitors the ID for new videos and grabs them too



ripper.ini files looks like this

`[Byte My Bits Plex]`
`lastid=`
`720p=0`
`ID=PLQXNc7LCyfPJ3OCZ6P7JC7_NzgOh6bc9P`
`directory=/media/Byte My Bits/Plex`

`[CineFix]`
`lastid=`
`720p=0`
`ID=UCVtL1edhT8qqY-j2JIndMzg`
`directory=/media/CineFix`

`[CinemaSins]`
`lastid=`
`720p=0`
`ID=UCYUQQgogVeQY8cMQamhHJcg`
`directory=/media/CinemaSins` 



- 720p=1 will download 720p MP4 files
- 720p=0 will download 1080p MP4 files

- Video files names will be the title with the video ID at the end for a [PLEX addon](https://github.com/ZeroQI/YouTube-Agent.bundle)

- Don't worry about lastid=, the script will file that in, but you need to include lastid= when adding sections to the INI file

- ID=, can be either the channel ID (starts with UC) or a playlist ID (Starts with PL).  If you you don't know how to get a channel ID [HERE](http://johnnythetank.github.io/youtube-channel-name-converter/). Playlist ID are in the URL, you want everything after list= (youtube.com/watch?v=0RAlf58PcY0&list=**PLIPYu8RdPGbcMxsSxSq-i1Z859BfCDgjj**)

- directory= must start with /media/ then the folder name you want 




Example docker-compose.yml

`version: '2.1'`
`services:`
​    `psripper:`
​        `image: tom42/ps_youtube_dl`
​        `container_name: psripper`
​        `volumes:`
​            `- /WHERE THE INI FILE GOES:/PSripper/config`
​            `- /WHERE YOU WANT THE VIDEOS:/media`
​        `restart: always`

`networks:`
  `default:`
​    `external:`
​      `name: nginx-proxy`
