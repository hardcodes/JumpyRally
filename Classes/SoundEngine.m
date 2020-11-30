//
//  SoundEngine.m
//  Jumpy
//
//  Created by Sven Putze on 13.07.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "SoundEngine.h"
#import "MyOpenALSupport.h"
#import "Globals.h"

@implementation SoundEngine

@synthesize currentMusicVolume;
@synthesize globalSfxVolume;
@synthesize isExternalAudioPlaying;
@synthesize isMusicPlaying;
@synthesize usePlaylist;
@synthesize loopLastPlaylistTrack;
@synthesize masterMusicVolume;
@synthesize headphoneIsPluggedIn;


#pragma mark - init

- (id) init{
	
#if DEBUG
	NSLog(@"SoundEngine: init()");
#endif
    self = [super init];
	if(self) {
		
			// Initialize the array and dictionaries we are going to use
		soundSources = [[NSMutableArray alloc] init];
		soundDictionary = [[NSMutableDictionary alloc] init];
		musicDictionary = [[NSMutableDictionary alloc] init];
		playListDictionary = [[NSMutableDictionary alloc] init];
		
			// Grab a reference to the AVAudioSession singleton
		audioSession = [AVAudioSession sharedInstance];
		[audioSession setCategory: AVAudioSessionCategoryAmbient error: &audioSessionError];
		soundCategory = AVAudioSessionCategoryAmbient;
			// check if ipod music is already playing.
			// YES: leave the sound category as AmbientSound.
			// NO:  set the sound category to SoloAmbientSound so that decoding is done using the hardware.
		isExternalAudioPlaying = [self isExternalAudioPlaying];
		if (!isExternalAudioPlaying) {
			
#if TARGET_IPHONE_SIMULATOR
				// does not work on the simulator
#else
			audioSessionError = nil;
			[audioSession setCategory: AVAudioSessionCategorySoloAmbient error: &audioSessionError];
			
			if (audioSessionError)
				NSLog(@"SoundEngine: could not set sound category AVAudioSessionCategorySoloAmbient");
#endif
			soundCategory = AVAudioSessionCategorySoloAmbient;
		}
		
			// Set up OpenAL
			//		BOOL success = [self initOpenAL];
		if(![self initOpenAL]) {
            NSLog(@"SoundEngine: error initializing OpenAL");
            return nil;
        }
        
			// default volumes
		currentMusicVolume = HCDefaultMusicVolume;
		masterMusicVolume = HCDefaultMusicVolume;
		globalSfxVolume = HCDefaultSoundVolume;
		playlistIndex = 0;
		
		isFading = NO;
		isMusicPlaying = NO;
		stopMusicAfterFade = YES;
		usePlaylist = NO;
		loopLastPlaylistTrack = NO;
		[self updateHeadPhoneStatus];
		
#if TARGET_IPHONE_SIMULATOR
			// does not work on the simulator
#else
		AudioSessionAddPropertyListener(
										kAudioSessionProperty_AudioRouteChange,
										HCAudioSessionPropertyListener,
										self);
#endif		
	}
    return self;
}



- (void)dealloc {
	
	if (isMusicPlaying) [self stopMusic];
	
		// delete sound sources
	for(NSNumber *soundSource in soundSources) {
		NSUInteger sourceID = [soundSource unsignedIntValue];
		alDeleteSources(1, &sourceID);
	}
		// delete buffers
	for(id key in soundDictionary){
		NSUInteger bufferID = [[soundDictionary objectForKey:key] unsignedIntValue];
		alDeleteBuffers(1, &bufferID);
	};
		// Release the arrays and dictionaries we have been using
	[soundDictionary release];
	[soundSources release];
	[musicDictionary release];
	[playListDictionary release];
	if (currentPlayListTracksArray) [currentPlayListTracksArray release];
	if (avAudioPlayer) [avAudioPlayer release];
	
	alcMakeContextCurrent(NULL);
	alcDestroyContext(alcContext);
	alcCloseDevice(alcDevice);
	
	[super dealloc];
}



- (void) preloadSounds{

#if DEBUG
	NSLog(@"SoundEngine.preloadSounds()");
#endif
	[self loadSoundOfType: DOOROPENSOUND];
	[self loadSoundOfType: KEYCOLLECTEDSOUND];
	[self loadSoundOfType: COINCOLLECTEDSOUND];
	[self loadSoundOfType: BOMBTIMERSOUND];
	[self loadSoundOfType: EXPLOSIONSOUND];
	[self loadSoundOfType: HEALTHCOLLECTEDSOUND];
	[self loadSoundOfType: JUMPYDIESOUND];
	[self loadSoundOfType: BOMBCOLLECTEDSOUND];
	[self loadSoundOfType: JUMPYBOUNCESOUND];
	[self loadSoundOfType: JUMPYHURTSOUND];
	[self loadSoundOfType: BEEATTACKSOUND];
	[self loadSoundOfType: BURNINGSOUND];
	[self loadSoundOfType: ROCKRUMBLESOUND];
	[self loadSoundOfType: ENEMYDIESOUND];
	[self loadSoundOfType: HIGHSCORESOUND];
	[self loadSoundOfType: THREESOUND];
	[self loadSoundOfType: TWOSOUND];
	[self loadSoundOfType: ONESOUND];
	[self loadSoundOfType: GOSOUND];
	
}



- (void) preloadMusic{
	
	[self loadMusicOfType: MENUSONG];
	[self loadMusicOfType: GAMEOVERSONG];
	[self loadMusicOfType: GAMECOMPLETESONG];
	[self loadMusicOfType: LEVELCOMPLETESONG];
	
}



- (BOOL) initOpenAL{
    
#if DEBUG
	NSLog(@"SoundEngine: initOpenAL");
#endif
    
		// TODO: find memory leak - our fault or OS bug?
	
		// open the default sound device
	alcDevice = alcOpenDevice(NULL);
	
	if(alcDevice) {
			// create OpenAL context
		alcContext = alcCreateContext(alcDevice, NULL);
		alcMakeContextCurrent(alcContext);
        
			// Set the distance model to be used
        alDistanceModel(AL_LINEAR_DISTANCE_CLAMPED);
        
			// precreate all sound sources
		NSUInteger sourceID;
		for(int index = 0; index < HCmaxOpenALSources; index++) {
				// Generate an OpenAL source
			alGenSources(1, &sourceID);
            
				// Add the generated sourceID to our array of sound sources
			[soundSources addObject:[NSNumber numberWithUnsignedInt:sourceID]];
		}
        
			// listener position, orientation and velocity to default values.
		float listener_pos[] = {0, 0, 0};
		float listener_ori[] = {0.0, 1.0, 0.0, 0.0, 0.0, 1.0};
		float listener_vel[] = {0, 0, 0};
		alListenerfv(AL_POSITION, listener_pos);
		alListenerfv(AL_ORIENTATION, listener_ori);
		alListenerfv(AL_VELOCITY, listener_vel);
#if DEBUG
        NSLog(@"SoundEngine: initOpenAL() OK");
#endif
			// show success
		return YES;
	}
	
		// we didn't get a device, tell user and return NO
    NSLog(@"SoundEngine: alcOpenDevice(NULL) failed!");
	return NO;
}



#pragma mark - (un)load sounds


- (NSString*) getSoundNameForSoundType: (int) aSoundType{
	
	NSString *soundName;
	
	switch (aSoundType) {
		case JUMPYBOUNCESOUND:
			soundName =@"jumpybounce.caf";			
			break;
			
		case JUMPYHURTSOUND:
			soundName=@"jumpyhurt.caf";
			break;

		case DOOROPENSOUND:
			soundName=@"doorOpen.caf";
			break;
			
		case COINCOLLECTEDSOUND:
			soundName=@"coin.caf";
			break;
			
		case KEYCOLLECTEDSOUND:
			soundName=@"gotkey.caf";
			break;
			
		case BOMBTIMERSOUND:
			soundName=@"bombtimer.caf";
			break;
			
		case BOMBCOLLECTEDSOUND:
			soundName=@"activatebomb.caf";
			break;
			
		case JUMPYDIESOUND:
			soundName=@"jumpydie.caf";
			break;
			
		case EXPLOSIONSOUND:
			soundName=@"explosion.caf";
			break;
			
		case HEALTHCOLLECTEDSOUND:
			soundName=@"firstaid.caf";
			break;
			
		case BEEATTACKSOUND:
			soundName=@"beeattack.caf";
			break;
			
		case BURNINGSOUND:
			soundName=@"fire.caf";
			break;
			
		case ROCKRUMBLESOUND:
			soundName=@"rock.caf";
			break;
			
		case ENEMYDIESOUND:
			soundName=@"enemydied.caf";
			break;
			
		case HIGHSCORESOUND:
			soundName=@"highscore.caf";
			break;
			
		case THREESOUND:
			soundName=@"three.caf";
			break;
			
		case TWOSOUND:
			soundName=@"two.caf";
			break;
			
		case ONESOUND:
			soundName=@"one.caf";
			break;
			
		case GOSOUND:
			soundName=@"go.caf";
			break;
			
			
		default:
			NSLog(@"SoundEngine: Error - unknown soundType %i", aSoundType);
			soundName=@"";
			break;
	}
	
	return soundName;
}



- (void) loadSoundOfType: (int) aSoundType{
	
	NSString *soundName =  [self getSoundNameForSoundType: aSoundType];
	NSNumber *soundType = [NSNumber numberWithUnsignedInt: aSoundType];
	
		// Check to make sure that a sound with the same key does not already exist
    NSNumber *dictionaryEntry = [soundDictionary objectForKey: soundType];
    
		// have we loaded that sound already?
    if(dictionaryEntry != nil) {
#if DEBUG
			NSLog(@"SoundEngine: sound '%@' already exists.", soundName);
#endif
        return;
    }
    
		// Set up the bufferID that will hold the OpenAL buffer generated
    NSUInteger bufferID;
	
		// alError = AL_NO_ERROR;
	alGetError();
	
		// Generate a buffer within OpenAL for this sound
	alGenBuffers(1, &bufferID);
	
		// Check to make sure no errors occurred.
	if([self checkForOpenALErrors] != AL_NO_ERROR) {
#if DEBUG
		NSLog(@"SoundEngine: error creating OpenAL buffer with error for filename %@\n", soundName);
#endif
		
	}
    
		// Set up the variables which are going to be used to hold the format
		// size and frequency of the sound file we are loading along with the actual sound data
	ALenum  format;
	ALsizei size;
	ALsizei frequency;
	ALvoid *data;
    
	NSBundle *bundle = [NSBundle mainBundle];
	
		// Get the audio data from the file which has been passed in
	NSString *fileName = [[soundName lastPathComponent] stringByDeletingPathExtension];
	NSString *fileType = [soundName pathExtension];
	CFURLRef fileURL = (CFURLRef)[[NSURL fileURLWithPath:[bundle pathForResource:fileName ofType:fileType]] retain];
	
	if (fileURL) {	
		data = MyGetOpenALAudioData(fileURL, &size, &format, &frequency);
		CFRelease(fileURL);
		
			// Use the static buffer data API
		alBufferData(bufferID, format, data, size, frequency);
		
		if([self checkForOpenALErrors] != AL_NO_ERROR) {
			NSLog(@"SoundEngine: error attaching audio to buffer");
		}
		
			// Free the memory we used when getting the audio data
		free(data);
	} else {
		NSLog(@"SoundEngine: file not found: '%@.%@'", fileName, fileType);
		if (data)
			free(data);
		data = NULL;
	}
	
		// Place the buffer ID into the sound library against |aSoundKey|
	[soundDictionary setObject:[NSNumber numberWithUnsignedInt:bufferID] forKey: soundType];
#if DEBUG
		NSLog(@"SoundEngine: loaded sound with name '%@' into buffer '%d'", soundName, bufferID);
#endif
}



- (void) removeSoundWithKey: (int) aSoundType{
	
	
	NSString *soundName =  [self getSoundNameForSoundType: aSoundType];
	NSNumber *soundType = [NSNumber numberWithUnsignedInt: aSoundType];
	
		// Reset errors in OpenAL
	alGetError();
	
		// Find the buffer which has been linked to the sound key provided
    NSNumber *dictionaryEntry = [soundDictionary objectForKey: soundType];
    
		// If the key is not found log it and finish
    if(dictionaryEntry == nil) {
			NSLog(@"SoundEngine: No sound with name '%@' in dictionary", soundName);
        return;
    }
    
		// Get the buffer id
    NSUInteger bufferID = [dictionaryEntry unsignedIntValue];
	NSInteger bufferForSource;
	NSInteger sourceState;
	for(NSNumber *soundSource in soundSources) {
		
		NSUInteger currentSourceID = [soundSource unsignedIntValue];
		
			// Grab the current state of the source and also the buffer attached to it
		alGetSourcei(currentSourceID, AL_SOURCE_STATE, &sourceState);
		alGetSourcei(currentSourceID, AL_BUFFER, &bufferForSource);
		
			// If this source is not playing then unbind it.  If it is playing and the buffer it
			// is playing is the one we are removing, then also unbind that source from this buffer
		if(sourceState != AL_PLAYING || (sourceState == AL_PLAYING && bufferForSource == bufferID)) {
			alSourceStop(currentSourceID);
			alSourcei(currentSourceID, AL_BUFFER, 0);
		}
	} 
    
		// Delete the buffer
	alDeleteBuffers(1, &bufferID);
	
		// Check for any errors
	if([self checkForOpenALErrors] != AL_NO_ERROR) {
		NSLog(@"SoundEngine: Could not delete buffer %d", bufferID);
		return;
	}
	
		// Remove the soundkey from the soundLibrary
    [soundDictionary removeObjectForKey: soundType];
#if DEBUG
		NSLog(@"SoundManager: Removed sound with name '%@'", soundName);
#endif
}


#pragma mark - play/stop sounds


- (NSUInteger) playSoundOfType: (int) aSoundType
						  gain: (float) aGain
						 pitch: (float) aPitch
					  atPosition: (CGPoint) aPosition
					shouldLoop: (BOOL) playInLoop{
	
		// 0 volume = nothing can be heard, return 0 which is an nonexistant sound source
	if([self globalSfxVolume] == 0) return 0;
	
	NSNumber *soundType = [NSNumber numberWithUnsignedInt: aSoundType];
	
	alGetError(); // clear the error code
	
		// Find the buffer linked to the key which has been passed in
	NSNumber *dictionaryEntry = [soundDictionary objectForKey: soundType];
	if(dictionaryEntry == nil) return 0;
	NSUInteger bufferID = [dictionaryEntry unsignedIntValue];
	
		// Find the next available source
    NSUInteger soundSource;
    soundSource = [self nextAvailableSource];
	
		// If 0 is returned then no sound sources were available
	if (soundSource == 0) {
#if DEBUG
		NSString *soundName =  [self getSoundNameForSoundType: aSoundType];
		NSLog(@"SoundEngine: No sound sources available to play %@", soundName);
#endif
		return 0;
	}
	
		// Make sure that the source is clean by resetting the buffer assigned to the source
		// to 0
	alSourcei(soundSource, AL_BUFFER, 0);
    
		// Attach the buffer we have looked up to the source we have just found
	alSourcei(soundSource, AL_BUFFER, bufferID);
	
		// Set the pitch and gain of the source
	alSourcef(soundSource, AL_PITCH, aPitch);
	alSourcef(soundSource, AL_GAIN, aGain * globalSfxVolume);
	
		// Set the looping value
	if(playInLoop) {
		alSourcei(soundSource, AL_LOOPING, AL_TRUE);
	} else {
		alSourcei(soundSource, AL_LOOPING, AL_FALSE);
	}
	
		// Set the source location
	alSource3f(soundSource, AL_POSITION, aPosition.x, aPosition.y, 0.0f);
	
		// Now play the sound
	alSourcePlay(soundSource);
	
		// Check to see if there were any errors
	if([self checkForOpenALErrors] != AL_NO_ERROR) {
		NSLog(@"SoundEngine: error playing sound");
		return 0;
	}
    
		// Return the source ID so that loops can be stopped etc
	return soundSource;
}



- (void) playSoundOfType: (int) aSoundType
			  at2DPosition: (CGPoint) aPosition{
	
	if([self globalSfxVolume] == 0) return;
	
	CGPoint soundPosition;
	if(headphoneIsPluggedIn){
#if TARGET_IPHONE_SIMULATOR
		soundPosition = CGPointMake((float)(-(aPosition.x-HCmidScreenUIInterfaceOrientationLandscape)), HCDefaultZPosition);
#else
		soundPosition = CGPointMake((float)((aPosition.x-HCmidScreenUIInterfaceOrientationLandscape)), HCDefaultZPosition);
#endif
		
	}
	else{
		soundPosition = CGPointMake(HCDefaultXPosition, HCDefaultZPosition);;
	}
	
	[self playSoundOfType: aSoundType
					 gain: HCDefaultGain
					pitch: HCDefaultPitch
			   atPosition: soundPosition
			   shouldLoop: NO];
}



- (NSUInteger)nextAvailableSource {
	
		// Holder for the current state of the current source
	NSInteger sourceState;
	
		// Find a source which is not being used at the moment
	for(NSNumber *sourceNumber in soundSources) {
		alGetSourcei([sourceNumber unsignedIntValue], AL_SOURCE_STATE, &sourceState);
			// If this source is not playing then return it
		if(sourceState != AL_PLAYING) return [sourceNumber unsignedIntValue];
	}
	
	return 0;
}



- (void) stopSoundOfType: (int) aSoundType {
	
	NSString *soundName =  [self getSoundNameForSoundType: aSoundType];
	NSNumber *soundType = [NSNumber numberWithUnsignedInt: aSoundType];
	
		// Reset errors in OpenAL
	alGetError();
	
		// Find the buffer which has been linked to the sound key provided
    NSNumber *dictionaryEntry = [soundDictionary objectForKey: soundType];
    
		// If the key is not found log it and finish
    if(dictionaryEntry == nil) {
#if DEBUG
        NSLog(@"SoundEngine: sound with name '%@' is not in dictionary -> no stop", soundName);
#endif
        return;
    }
    
		// Get the buffer number from
    int bufferID = [dictionaryEntry unsignedIntValue];
	int bufferForSource;
	for(NSNumber *sourceID in soundSources) {
		
		int currentSourceID = [sourceID unsignedIntValue];
		
			// Grab the buffer currently bound to this source
		alGetSourcei(currentSourceID, AL_BUFFER, &bufferForSource);
		
			// If the buffer matches the buffer we want to stop then stop the source and unbind it from the buffer
		if(bufferForSource == bufferID) {
			alSourceStop(currentSourceID);
			alSourcei(currentSourceID, AL_BUFFER, 0);
		}
	} 
	
		// Check for any errors
	if([self checkForOpenALErrors] != AL_NO_ERROR)
		NSLog(@"SoundEngine: could not stop sound with name '%@'", soundName);
}



- (void) stopAllSounds{
	
	for(NSNumber *sourceID in soundSources) {
		
		int bufferForSource;
		int currentSourceID = [sourceID unsignedIntValue];
		
			// get the buffer currently bound to this source
		alGetSourcei(currentSourceID, AL_BUFFER, &bufferForSource);
			// stop source and unbind buffer
		alSourceStop(currentSourceID);
		alSourcei(currentSourceID, AL_BUFFER, 0);
	} 
}


#pragma mark - listener orientation

- (void) setListenerPosition: (ALfloat*) aPosition{
	listenerPosition = *aPosition;
	alListenerfv(AL_ORIENTATION, aPosition);
}



- (void) setListenerOrientation: (ALfloat*) aOrientation{
    listenerOrientation = *aOrientation;
    alListenerfv(AL_ORIENTATION, aOrientation);
}



- (void) setListenerVelocity: (ALfloat*) aVelocity{
	listenerVelocity = *aVelocity;
	alListenerfv(AL_VELOCITY, aVelocity);
}



#pragma mark - volume


- (void)fadeMusicVolumeFrom:(float)aFromVolume toVolume:(float)aToVolume duration:(float)aSeconds stopAfterFade:(BOOL)aStop {
	
		// If there is already a fade timer active, invalidate it so we can start another one
	if (timer) {
		[timer invalidate];
		timer = NULL;
	}
	
		// Work out how much to fade the music by based on the current volume, the requested volume
		// and the duration
	fadeAmount = (aToVolume - aFromVolume) / (aSeconds / HCFadeInterval); 
	currentMusicVolume = aFromVolume;
	
		// Reset the fades duration
	fadeDuration = 0;
	targetFadeDuration = aSeconds;
	isFading = YES;
	stopMusicAfterFade = aStop;
	
		// Set up a timer that fires kFadeInterval times per second calling the fadeVolume method
	timer = [NSTimer scheduledTimerWithTimeInterval:HCFadeInterval target:self selector:@selector(fadeVolume:) userInfo:nil repeats:TRUE];
}



- (void)fadeVolume:(NSTimer*) aTimer {
	
	fadeDuration += HCFadeInterval;
	if (fadeDuration >= targetFadeDuration) {
		if (timer) {
			[timer invalidate];
			timer = NULL;
		}
		
		isFading = NO;
		if (stopMusicAfterFade) {
			[avAudioPlayer stop];
			isMusicPlaying = NO;
		}
	} else {
		currentMusicVolume += fadeAmount;
	}
	
		// if music is currently playing then (re)set its volume
	if(isMusicPlaying) {
		[avAudioPlayer setVolume:currentMusicVolume];
	}
}



- (void) setMasterMusicVolume: (float) aVolume{
	
		// Set the volume iVar
	if (aVolume > 1)
		aVolume = 1.0f;
	
	currentMusicVolume = aVolume;
	masterMusicVolume = aVolume;
	
		// Check to make sure that the audio player exists and if so set its volume
	if(avAudioPlayer)
		[avAudioPlayer setVolume:currentMusicVolume];
}


#pragma mark - AVAudioPlayerDelegate


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	
	if (!flag) {
		NSLog(@"SoundEngine: error while playing music - stopped");
		return;
	}
	
	isMusicPlaying = NO;
		
		// TODO: check if we should play the song again
}


#pragma mark - interrupt sound ouput


- (void)beginInterruption {
	[self setOpenALStatus:NO];
}

- (void)endInterruption {
	[self setOpenALStatus:YES];
}


#pragma mark - statusflags


- (void) setOpenALStatus: (BOOL) aState{
    
    if(aState) {
#if DEBUG
        NSLog(@"INFO - SoundManager: OpenAL Active");
#endif
        
			// Set the AudioSession AudioCategory to what has been defined in soundCategory
		[audioSession setCategory:soundCategory error: &audioSessionError];
        if(audioSessionError) {
            NSLog(@"SoundEngine: Unable to set the audio session category");
            return;
        }
        
			// Set the audio session state to true and report any errors
		[audioSession setActive:YES error:&audioSessionError];
		if (audioSessionError) {
            NSLog(@"SoundEngine: Unable to set the audio session state to YES with error %@.", audioSessionError);
            return;
        }
		
		if (avAudioPlayer) {
			[avAudioPlayer play];
		}
        
			// As we are finishing the interruption we need to bind back to our context.
        alcMakeContextCurrent(alcContext);
    } else {
        NSLog(@"INFO - SoundManager: OpenAL Inactive");
        
			// As we are being interrupted we set the current context to NULL.  If this sound manager is to be
			// compaitble with firmware prior to 3.0 then the context would need to also be destroyed and
			// then re-created when the interruption ended.
        alcMakeContextCurrent(NULL);
    }
}



- (BOOL) isExternalAudioPlaying{
	UInt32 audioPlaying = 0;
	UInt32 audioPlayingSize = sizeof(audioPlaying);
	AudioSessionGetProperty(kAudioSessionProperty_OtherAudioIsPlaying, &audioPlayingSize, &audioPlaying);
	
	return (BOOL) audioPlaying;
}




- (ALenum)checkForOpenALErrors {
	
	ALenum alError = alGetError();
	if(alError != AL_NO_ERROR) {
			// errors should show up even in production code!
		NSLog(@"SoundEngine: OpenAL reported error '%d'", alError);
	}
	return alError;
}



- (BOOL)checkIfHeadsetIsPluggedIn {
	
	BOOL returnValue = NO;
	
#if TARGET_IPHONE_SIMULATOR
		// do nothing in the simulator - it will not work
		NSLog(@"can not check for headphones on a simulator");
#else


    UInt32 routeSize = sizeof (CFStringRef);
    CFStringRef route;
	
    AudioSessionGetProperty (kAudioSessionProperty_AudioRoute,
							 &routeSize,
							 &route);
	
    /* Known values of route:
     * "Headset"
     * "Headphone"
     * "Speaker"
     * "SpeakerAndMicrophone"
     * "HeadphonesAndMicrophone"
     * "HeadsetInOut"
     * "ReceiverAndMicrophone"
     * "Lineout"
     */
	
    NSString* routeStr = (NSString*)route;
	
    NSRange headphoneRange = [routeStr rangeOfString : @"Headphone"];
    NSRange receiverRange = [routeStr rangeOfString : @"Receiver"];
	
    if(headphoneRange.location != NSNotFound) {
			// Don't change the route if the headset is plugged in.
        returnValue = YES;
    } 
    else if (receiverRange.location != NSNotFound) {
		returnValue = NO;
        NSLog(@"play on the speaker");
		
    }
	
#endif
	
	return returnValue;
}



- (void)updateHeadPhoneStatus{
	
	[self setHeadphoneIsPluggedIn: [self checkIfHeadsetIsPluggedIn]];
}


#pragma mark - (un)load music


	// Selector translates the integer value from enum musicTypes{} into the
	// filename of the mp3
- (NSString*) getFileNameForMusicType: (int) aMusicType{
	
	NSString *musicName;
	
	switch (aMusicType) {
		case MENUSONG:
			musicName =@"mainmenusong.mp3";			
			break;
			
		case LEVELCOMPLETESONG:
			musicName=@"levelcompletesong.mp3";
			break;
			
		case GAMECOMPLETESONG:
			musicName=@"gamecompletesong.mp3";
			break;
			
		case GAMEOVERSONG:
			musicName=@"gameoversong.mp3";
			break;
			
		default:
			NSLog(@"SoundEngine: Error - unknown musicType %i", aMusicType);
			musicName=@"";
			break;
	}
	
	return musicName;

}



	// Loads a sound for the given key into a OpenAL buffer. Reference is stored in our resource dictionary.
- (void) loadMusicOfType: (int) aMusicType{
	
	NSString *fullFileName =  [self getFileNameForMusicType: aMusicType];
	NSString *fileName = [[fullFileName lastPathComponent] stringByDeletingPathExtension];;
	NSString *fileType = [fullFileName pathExtension];
	NSNumber *musicType = [NSNumber numberWithUnsignedInt: aMusicType];
		// Check to make sure that a musicfile with the same key does not already exist
    NSNumber *dictionaryEntry = [musicDictionary objectForKey: musicType];
    
		// have we loaded that sound already?
    if(dictionaryEntry != nil) {
		NSLog(@"SoundEngine: musicfile '%@' already exists.", fileName);
        return;
    }
    
	NSString *resourcePath = [[NSBundle mainBundle] pathForResource: fileName ofType: fileType];
	if (!resourcePath) {
		NSLog(@"WARNING - SoundManager: Cannot find file '%@.%@'", fileName, fileType);
		return;
	}
	
	[musicDictionary setObject: resourcePath forKey: musicType];
#if DEBUG
	NSLog(@"SoundManager: Loaded musicfile '%@'", fileName);
#endif

	
	
}



	// Removes the sound for the given key. The associated buffer is also cleared.
- (void) removeMusicOfType: (int) aMusicType{
	
	NSNumber *musicType = [NSNumber numberWithUnsignedInt: aMusicType];
		// Check to make sure that a musicfile with the same key does not already exist
    NSNumber *dictionaryEntry = [musicDictionary objectForKey: musicType];
    
		// have we loaded that sound already?
    if(!dictionaryEntry) {
		NSLog(@"SoundEngine: musicType '%@' does not exist -> can not remove.", musicType);
        return;
    }
	
	[musicDictionary removeObjectForKey: musicType];
#if DEBUG
	NSLog(@"SoundEngine: musicType '%@' removed.", musicType);
#endif

}



#pragma mark - play / stop music


	// Plays the music with the supplied key.  If no music is found then nothing happens.
	// |aRepeatCount| specifies the number of times the music should loop.
- (void) playMusicOfType: (int) aMusicType timesToRepeat: (int) aRepeatCount{
	
	NSString *musicName =  [self getFileNameForMusicType: aMusicType];
	NSNumber *musicType = [NSNumber numberWithUnsignedInt: aMusicType];
	NSString *pathOfMusicFile = [musicDictionary objectForKey: musicType];
	NSError *error;
	
	if(!pathOfMusicFile) {
		NSLog(@"SoundEngine: The music file '%@' could not be found", musicName);
		return;
	}
	
	if(avAudioPlayer)
		[avAudioPlayer release];
	
		// init audio player using the filename from our dictionary
	avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath: pathOfMusicFile] error: &error];
	
		// no audio player = error
	if(!avAudioPlayer) {
		NSLog(@"SoundEngine: Could not play music file '%@', error: %@", musicName, error);
		return;
	}
	
		// Set the delegate for this music player to be the sound manager
	avAudioPlayer.delegate = self;
	
		// Set the number of times this music should repeat.  -1 means never stop until its asked to stop
	[avAudioPlayer setNumberOfLoops: aRepeatCount];
	
		// Set the volume of the music
	[avAudioPlayer setVolume: currentMusicVolume];
	
		// Play the music
	[avAudioPlayer play];
	
		// Set the isMusicPlaying flag
	isMusicPlaying = YES;
}




- (void)stopMusic {
	[avAudioPlayer stop];
	isMusicPlaying = NO;
	usePlaylist = NO;
}



- (void)pauseMusic {
	[avAudioPlayer pause];
	isMusicPlaying = NO;
}



- (void)resumeMusic {
	[avAudioPlayer play];
	isMusicPlaying = YES;
}



#pragma mark - callback
void HCAudioSessionPropertyListener (
									 void                      *inClientData,
									 AudioSessionPropertyID    inAudioSessionPropertyID,
									 UInt32                    inDataSize,
									 const void                *inData
									 ){
		// just query data if an audio route change has occured
	if (inAudioSessionPropertyID != kAudioSessionProperty_AudioRouteChange) return;
		// get the address of the callback class (yes, it's us)
	SoundEngine *callBackSoundEngine = inClientData;
		// check for proper audio output route
	[callBackSoundEngine updateHeadPhoneStatus];
}


@end


