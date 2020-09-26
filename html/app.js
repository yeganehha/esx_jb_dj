var audioPlayer = {};
window.addEventListener('message', function(e) {
	//// console.log(JSON.stringify(e))
    if (e.data.musiccommand === 'playsong') {
  		
	  if (audioPlayer[e.data.dancefloor] != null) {
		audioPlayer[e.data.dancefloor].pause();
		audioPlayer[e.data.dancefloor].currentTime = 0;
	  }
	  
	  console.log(e.data.songname);
	  audioPlayer[e.data.dancefloor] = new Audio(e.data.songname);
	  audioPlayer[e.data.dancefloor].volume = 0.0;

	  audioPlayer[e.data.dancefloor].play();
	  // console.log(JSON.stringify(audioPlayer));
	} else if (e.data.musiccommand === 'pause') {
	  if (audioPlayer[e.data.dancefloor] != null) {
		audioPlayer[e.data.dancefloor].pause();
	  }
	} else if (e.data.musiccommand === 'stop') {
	  if (audioPlayer[e.data.dancefloor] != null) {
		audioPlayer[e.data.dancefloor].pause();
		audioPlayer[e.data.dancefloor].currentTime = 0;
	  }
	} else if (e.data.musiccommand === 'play') {
	  if (audioPlayer[e.data.dancefloor] != null) {
		audioPlayer[e.data.dancefloor].play();
	  }
	} else if (e.data.setvolume !== undefined && audioPlayer[e.data.dancefloor] != null) {
		if (e.data.setvolume >= 0.0 && e.data.setvolume <= 1.0) {
			// console.log(e.data.setvolume);
			audioPlayer[e.data.dancefloor].volume = e.data.setvolume;
		}
	}
});