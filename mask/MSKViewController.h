//
//  MSKViewController.h
//  mask
//
//  Created by HAN SANGWOO on 3/18/14.
//  Copyright (c) 2014 HAN SANGWOO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <SpeechKit/SpeechKit.h>


@interface MSKViewController : UIViewController<AVAudioRecorderDelegate, SKRecognizerDelegate, AVAudioPlayerDelegate> {
    AVAudioRecorder *recorder;
    NSTimer *levelTimer;
    double lowPassResults;
    NSURL *urlPlay;
    
    Boolean playing;
    int silenceTimer;
    int state;
    
    SKRecognizer *recognizer;
}


@property (weak, nonatomic) IBOutlet UITextView *textToSpeak;
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (retain, nonatomic) AVAudioPlayer *avPlay;
@property (nonatomic, retain) SKRecognizer *recognizer;
@end



