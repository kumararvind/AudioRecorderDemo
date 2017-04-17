//
//  ViewController.m
//  DemoboxingRecorder
//
//  Created by Infoicon on 15/03/17.
//  Copyright © 2017 InfoiconTechnologies. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface ViewController ()
{
    NSMutableDictionary *recordSetting;
    NSString *recorderFilePath;
    AVAudioRecorder *recorder;
    NSMutableDictionary *editedObject;
    SystemSoundID soundID;
    
    NSArray *arrayAudioFiles;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   
    
    
    
    
}


- (IBAction)btnPlayAction:(id)sender {
    
    arrayAudioFiles=[self getLogRecordsFromDocumentDirectory];
    
    NSString *path=arrayAudioFiles[arrayAudioFiles.count-1];
    if(path)
    {
        AVPlayer *player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:recorderFilePath]];
        
        // create a player view controller
        AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
        [self presentViewController:controller animated:YES completion:nil];
        controller.player = player;
        [player play];
    }
   
}

- (IBAction)btnPauseAction:(id)sender {
    
    [recorder pause];
}
- (IBAction)btnStartAction:(id)sender {
    
    [self startRecording];
}
- (IBAction)btnStopAction:(id)sender {
    
    [self stopRecording];
}
- (IBAction)btnContinueAction:(id)sender {
    
    [recorder record];
}

- (void) startRecording{
    
    // Create a new dated file
    NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
    NSString *caldate = [now description];
    recorderFilePath = [NSString stringWithFormat:@"%@/%@.caf", DOCUMENTS_FOLDER, caldate] ;
    
    NSURL *url = [NSURL fileURLWithPath:recorderFilePath];
    NSError *err = nil;
    recorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
    if(!recorder){
        NSLog(@"recorder: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
                                   message: [err localizedDescription]
                                  delegate: nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        [alert show];
        
        return;
    }
  
    //prepare to record
    [recorder setDelegate:self];
    [recorder prepareToRecord];
    recorder.meteringEnabled = YES;
    [recorder record];
    

}

- (void) stopRecording{
    
    [recorder stop];
    
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag
{
    
    NSLog (@"audioRecorderDidFinishRecording:successfully:");
    UIAlertView *cantRecordAlert =
    [[UIAlertView alloc] initWithTitle: @"SUCCESS"
                               message: @"audioRecorderDidFinishRecording"
                              delegate: nil
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil];
    [cantRecordAlert show];
    
    [self getLogRecordsFromDocumentDirectory];
    
}

-(NSArray *)getLogRecordsFromDocumentDirectory    {
    
    //-----> LIST ALL FILES <-----//
    NSLog(@"LISTING ALL FILES FOUND");
    
    int count;
    
   // NSString *documentPath=[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"/Audio"];
   NSString *documentPath = DOCUMENTS_FOLDER;
   NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentPath error:NULL];
    for (count = 0; count < (int)[directoryContent count]; count++)
    {
        NSLog(@"File %d: %@", (count + 1), [directoryContent objectAtIndex:count]);
    }
    return directoryContent;
}

/**
 Returns the URL to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return documentsDirectory;
}

@end
