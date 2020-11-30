//
//  SoundEngine.h
//  Jumpy
//
//  Created by Sven Putze on 13.07.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import <OpenAL/al.h>
#import <OpenAL/alc.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#define HCmaxOpenALSources 16				// number of OpenAL sources that will be generated
#define HCFadeInterval (1.0f/60.0)			// # of times/s volume is updated if music is faded
#define HCDefaultGain 1.0f					// default gain for siund output
#define HCDefaultPitch 1.0f					// default pitch for sound output
#define HCDefaultZPosition 0.0f				// default position (z-axis) for played sounds
#define HCDefaultXPosition 0.0f				// default position (x-axis) for played sounds if speaker is used
#define HCDefaultSoundVolume 1.0f			// default volume for all volume parameters
#define HCDefaultMusicVolume 0.5f			// default volume for played music
#define HCDefaultMusicRepeatCount 99		// number of song repetitions
#define HCGameOverMusicRepeatCount 1		// game over song is only played one time
#define HCDefaultFadeDuration 2.5f			// time of a fade

enum musicTypes{
	MENUSONG,
	LEVELCOMPLETESONG,
	GAMECOMPLETESONG,
	GAMEOVERSONG
};

enum soundTypes{
	JUMPYBOUNCESOUND,
	JUMPYHURTSOUND,
	COINCOLLECTEDSOUND,
	KEYCOLLECTEDSOUND,
	DOOROPENSOUND,
	HEALTHCOLLECTEDSOUND,
	JUMPYDIESOUND,
	BOMBTIMERSOUND,
	BOMBCOLLECTEDSOUND,
	EXPLOSIONSOUND,
	BEEATTACKSOUND,
	BURNINGSOUND,
	ROCKRUMBLESOUND,
	ENEMYDIESOUND,
	HIGHSCORESOUND,
	THREESOUND,
	TWOSOUND,
	ONESOUND,
	GOSOUND
};



@interface SoundEngine : NSObject <AVAudioPlayerDelegate, AVAudioSessionDelegate> {
	
	NSMutableDictionary *soundDictionary;		// Dictionary of all sounds loaded and their keys
	NSMutableDictionary *musicDictionary;		// Dictionary of all music/ambient sounds loaded and their keys
	NSMutableDictionary *playListDictionary;	// Dictionary of playlists
	NSMutableArray *currentPlayListTracksArray;	// Array of tracks for the current play list
	NSMutableArray *soundSources;				// Mutable array of all sound sources
	
	AVAudioPlayer *avAudioPlayer;				// AVAudioPlayer instance for the music
	AVAudioSession *audioSession;				// Reference to an audio session
	NSError *audioSessionError;					// Audiosession errors are placed in this ivar
	NSString *soundCategory;					// sound category being active at game start

	ALCcontext *alcContext;						// Context in which all sounds will be played
	ALCdevice *alcDevice;						// Reference to the device to use when playing sounds

	float currentMusicVolume;					// volume of music/ambient sounds played through AVAudioPlayer
	float globalSfxVolume;						// global volume of OpenAL sound effects
	float masterMusicVolume;					// The master music volume - not affected by fading music
	float fadeAmount;							// Amount the volume should be faded each timer call
	float fadeDuration;							// The amount of time the fade has been running
	float targetFadeDuration;					// The duration the current fade should run for
	
	NSTimer *timer;								// timer used fade the music volume up or down
	ALfloat listenerPosition;					// AL_POSITION of the OpenAL listener, e.g. {0.0,0.0,4.0}
	ALfloat listenerOrientation;				// AL_ORIENTATION of the OpenAL listener, e.g. {0.0,0.0,1.0, 0.0,1.0,0.0}
	ALfloat listenerVelocity;					// AL_VELOCITY of the OpenAL listener, e.g. {0.0,0.0,0.0}
	
	BOOL isExternalAudioPlaying;				// YES if music was playing before the sound engine was initialized i.e.
	BOOL isFading;								// YES if the sound manager is currently fading music
	BOOL isMusicPlaying;						// YES if music is currently playing
	BOOL stopMusicAfterFade;					// YES if music is to be stopped once fading has finished
	BOOL usePlaylist;							// YES if tracks in the playlist should be played one after the other
	BOOL loopPlaylist;							// YES if the playlist should loop when it reaches the end
	BOOL loopLastPlaylistTrack;					// YES if you want the last track of the playlist to be looped forever
	BOOL headphoneIsPluggedIn;					// YES if a headphone is detected, NO = speaker = mono
	
	int playlistIndex;							// Current index being played in the playlist
	NSString *currentPlaylistName;				// Holds the name of the currently playing play list
	
	
	
}

@property (nonatomic, assign) float currentMusicVolume;
@property (nonatomic, assign) float globalSfxVolume;
@property (nonatomic, assign) BOOL isExternalAudioPlaying;
@property (nonatomic, assign) BOOL isMusicPlaying;
@property (nonatomic, assign) BOOL usePlaylist;
@property (nonatomic, assign) BOOL loopLastPlaylistTrack;
@property (nonatomic, assign) BOOL headphoneIsPluggedIn;
@property (nonatomic, assign) float masterMusicVolume;


#pragma mark - init


	// Selector loads all sounds into the buffers and stores the reference in our resource array
- (void) preloadSounds;


	// Selector loads the paths to our musicfiles into the dictionary
- (void) preloadMusic;



	// Selector is used to initialize OpenAL.  It gets the default device, creates a new context 
	// to be used and then preloads the define # sources.  This preloading means we wil be able to play up to
	// (max 32) different sounds at the same time
- (BOOL) initOpenAL;


#pragma mark - (un)load sounds


	// Selector translates the integer value from enum soundTypes{} into the
	// filename of the soundsample
- (NSString*) getSoundNameForSoundType: (int) aSoundType;



	// Loads a sound for the given key into a OpenAL buffer. Reference is stored in our resource dictionary.
- (void) loadSoundOfType: (int) aSoundType;



	// Removes the sound for the given key. The associated buffer is also cleared.
- (void) removeSoundWithKey: (int) aSoundType;


#pragma mark - play/stop sounds


	// Selector plays the sound selected by aSoundType
- (NSUInteger) playSoundOfType: (int) aSoundType
						  gain: (float) aGain
						 pitch: (float) aPitch 
					  atPosition: (CGPoint) aPosition
					shouldLoop: (BOOL) playInLoop;


	// Selector plays the sound aSoundType at aPosition.
	// gain and pitch get default values.
	// sound will not loop and is played at the default z axis position
- (void) playSoundOfType: (int) aSoundType
			  at2DPosition: (CGPoint) aPosition;



	// Used to get the next available OpenAL source.  The returned source is then bound to a sound
	// buffer so that the sound can be played.  This method checks each of the available OpenAL 
	// soucres which have been generated and returns the first source which is not currently being
	// used.  If no sources are found to be free then the first looping source is returned.  If there
	// are no looping sources then the first source created is returned
- (NSUInteger)nextAvailableSource;



	// Stops all sounds playing with the supplied sound key
- (void) stopSoundOfType: (int) aSoundType;



	// Selector stops all sounds that are played at the moment
- (void) stopAllSounds;


#pragma mark - listener orientation


	// Selector sets the position of the listener, so OpenAL has a reference where the sounds are to be heard
- (void) setListenerPosition: (ALfloat*) aPosition;


	// Selector sets the orientation of the listener (which way he/she looks)
- (void) setListenerOrientation: (ALfloat*) aOrientation;


	// Selector sets the velocity of the listener (if he/she moves)
- (void) setListenerVelocity: (ALfloat*) aVelocity;


#pragma mark - volumes


	// Fades the music volume down to the specified value over the specified period of time.  This method
	// does not change the musicVolume for the sound manager which allows you to always get the music volume
	// allowing you to fade music down and then back up to the defined value set inside the settings screen for
	// example
- (void) fadeMusicVolumeFrom: (float) aFromVolume
					toVolume: (float) aToVolume
					duration: (float) aSeconds
			   stopAfterFade: (BOOL) aStop;


	// Set the volume for music which is played.
- (void) setMasterMusicVolume: (float) aVolume;



#pragma mark - statusflags


	// Selector sets the current state of OpenAL.
	// TODO: when the game is interrupted the OpenAL state is
	// stopped and then restarted when the game becomes active again.
- (void)setOpenALStatus: (BOOL) aState;


	// If audio is currently playing this method returns YES
- (BOOL)isExternalAudioPlaying;


	// Selector checks for any OpenAL error that may have been set
- (ALenum) checkForOpenALErrors;


	// check if a headphone is plugged in. If yes, sound is played in stereo.
	// else sound is played on a mono speaker thus panned to middle position.
- (BOOL)checkIfHeadsetIsPluggedIn;


	// wrapper for checkIfHeadsetIsPluggedIn -> used by HCAudioSessionPropertyListener
- (void)updateHeadPhoneStatus;


#pragma mark - (un)load music


	// Selector translates the integer value from enum soundTypes{} into the
	// filename of the soundsample
- (NSString*) getFileNameForMusicType: (int) aMusicType;



	// Loads a sound for the given key into a OpenAL buffer. Reference is stored in our resource dictionary.
- (void) loadMusicOfType: (int) aMusicType;



	// Removes the sound for the given key. The associated buffer is also cleared.
- (void) removeMusicOfType: (int) aMusicType;



#pragma mark - play / stop music


	// Plays the music with the supplied key.  If no music is found then nothing happens.
	// |aRepeatCount| specifies the number of times the music should loop.
- (void) playMusicOfType: (int) aMusicType timesToRepeat: (int) aRepeatCount;


	// Selector stops any currently playing music.
- (void) stopMusic;


	// Selector pauses any currently playing music.
- (void) pauseMusic;


	// selector resumes music that has been paused
- (void) resumeMusic;


#pragma mark - callback

	// method reacts upon changes in the audio route
void HCAudioSessionPropertyListener (
						 void                      *inClientData,
						 AudioSessionPropertyID    inAudioSessionPropertyID,
						 UInt32                    inDataSize,
						 const void                *inData
						 );



@end
