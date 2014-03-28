//
//  MSKViewController.m
//  mask
//
//  Created by HAN SANGWOO on 3/18/14.
//  Copyright (c) 2014 HAN SANGWOO. All rights reserved.
//

#import "MSKViewController.h"


const unsigned char SpeechKitApplicationKey[] = {0xc0, 0x69, 0x8d, 0xf3, 0xee, 0x44, 0x8f, 0xf0, 0x8d, 0x4b, 0x3f, 0x72, 0x9c, 0xbd, 0xe0, 0xfe, 0xbc, 0x45, 0x2a, 0xba, 0x76, 0xf2, 0x31, 0x99, 0x69, 0xce, 0x87, 0x4e, 0xcd, 0x65, 0x56, 0x8d, 0xce, 0xe3, 0x81, 0xbc, 0x28, 0x10, 0xad, 0xb5, 0x5b, 0xec, 0x27, 0xf8, 0xaa, 0x08, 0xf6, 0x66, 0x4d, 0x21, 0x20, 0xc3, 0x13, 0x51, 0x5c, 0x7c, 0x1f, 0xe3, 0xca, 0xec, 0x49, 0x20, 0x7a, 0x17};

@interface MSKViewController ()

@end



@implementation MSKViewController
@synthesize avPlay = _avPlay;
@synthesize recognizer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"initializing");
    [SpeechKit setupWithID:@"NMDPPRODUCTION_Sangwoo_Han_mask_20140321195844"
                      host:@"bkj.nmdp.nuancemobility.net"
                      port:443
                    useSSL:NO
                  delegate:nil];

    
    if (!recognizer){
       NSLog(@"recognizer off");
        self.recognizer = [[SKRecognizer alloc] initWithType:SKDictationRecognizerType detection:SKLongEndOfSpeechDetection language:@"en_US" delegate:self];
        }
    
 
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)playPauseButtonPressed:(UIButton *)sender {
    [self.textToSpeak resignFirstResponder];
    
    //AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:self.textToSpeak.text];
    //utterance.rate = 0.1;
    //utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"fr-FR"];
    //[self.synthesizer speakUtterance:utterance];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"file.mp3"];
    
    NSString *text = self.textToSpeak.text; //@"You are one chromosome away from being a potato.";
    NSString *urlString = [NSString stringWithFormat:@"http://www.translate.google.com/translate_tts?tl=fr&q=%@",text];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url] ;
    [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:2.0.1) Gecko/20100101 Firefox/4.0.1" forHTTPHeaderField:@"User-Agent"];
    NSURLResponse* response = nil;
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    [data writeToFile:path atomically:YES];
    
    SystemSoundID soundID;
    NSURL *url2 = [NSURL fileURLWithPath:path];
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url2, &soundID);
    AudioServicesPlaySystemSound (soundID);
}

- (void)performRecognition:(id)sender
{
    if (!recognizer){
        self.recognizer = [[SKRecognizer alloc] initWithType:SKDictationRecognizerType detection:SKLongEndOfSpeechDetection language:@"en_US" delegate:self];
    }
}

- (void)recognizerDidBeginRecording:(SKRecognizer *)recognizer{
    NSLog(@"starting");
}

- (void)recognizerDidFinishRecording:(SKRecognizer *)recognizer{
    NSLog(@"ending");
}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithResults:(SKRecognition *)results{
    NSString *search = [results firstResult];
    self.textToSpeak.text = search;
    NSLog(@"%@",search);
    NSLog(@"hahahaha");
    
    //Download text-to-speech
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"file.mp3"];
    
    NSString *text = search; //@"You are one chromosome away from being a potato.";
    NSString *urlString = [NSString stringWithFormat:@"http://www.translate.google.com/translate_tts?tl=fr&q=%@",text];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url] ;
    [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:2.0.1) Gecko/20100101 Firefox/4.0.1" forHTTPHeaderField:@"User-Agent"];
    NSURLResponse* response = nil;
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    [data writeToFile:path atomically:YES];
    
    //SystemSoundID soundID;
    NSURL *url2 = [NSURL fileURLWithPath:path];
    self.avPlay = [[AVAudioPlayer alloc] initWithContentsOfURL:url2 error:nil];
    self.avPlay.delegate = self;
    
    [self.avPlay play];
//    SystemSoundID id = [self playASound:url2];
//    AudioServicesAddSystemSoundCompletion (
//                                           id,
//                                           NULL,
//                                           NULL,
//                                           endSound,
//                                           (__bridge void *)(self)
//                                           );
//    AudioServicesPlaySystemSound(id);
    //AudioServicesCreateSystemSoundID((__bridge CFURLRef)url2, &soundID);
    //AudioServicesPlaySystemSound (soundID);
    NSLog(@"restarting");
    self.recognizer = nil;
    
    //[self performRecognition];
    //[self performSelector:@selector(performRecognition:) withObject:nil afterDelay:1];
    
}



- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //start playing next sound
    if (!recognizer){
        NSLog(@"recognizer off");
        self.recognizer = [[SKRecognizer alloc] initWithType:SKDictationRecognizerType detection:SKLongEndOfSpeechDetection language:@"en_US" delegate:self];
    }
}


-(SystemSoundID) playASound: (NSURL *) url2 {
    
    SystemSoundID soundID;
    //Get a URL for the sound file
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url2, &soundID);
    //play the file
    //AudioServicesPlaySystemSound(soundID);
    return soundID;
}

void endSound ( SystemSoundID  ssID, void *clientData )
{
    printf("end\n");

    MSKViewController *mySelf = (__bridge MSKViewController *)clientData;
    [mySelf performRecognition:nil];
    AudioServicesRemoveSystemSoundCompletion(ssID);
    AudioServicesDisposeSystemSoundID(ssID);
    //[self performSelector:@selector(performRecognition:) withObject:nil afterDelay:1];
//
//    SKRecognizer *recognizer = [[SKRecognizer alloc] initWithType:SKDictationRecognizerType detection:SKLongEndOfSpeechDetection language:@"en_US" delegate:nil];
}

@end
