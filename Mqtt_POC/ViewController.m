//
//  ViewController.m
//  Mqtt_POC
//
//  Created by MEETA on 23/10/16.
//  Copyright © 2016 MEETA_kanayalal. All rights reserved.
//

#import "ViewController.h"
#import "MQTTClient.h"
#include "MQTTSession.h"


@interface ViewController ()
@property (strong, nonatomic) NSMutableArray *chat;
@property (strong, nonatomic) MQTTSessionManager *manager;
@property (strong, nonatomic) NSString *base;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.chat = [[NSMutableArray alloc] init];

    if (!self.manager) {
        self.manager = [[MQTTSessionManager alloc] init];
        self.manager.delegate = self;
        self.manager.subscriptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:MQTTQosLevelAtLeastOnce]forKey:@"chat/room/nikesh/inbox"];
        

        [self.manager connectTo:@"msg.falcontrack.com"
                           port:8883
                            tls:YES
                       keepalive:60
                          clean:true
                           auth:YES
                           user:@"nikesh"
                           pass:@"nikesh"
                           will:YES
                      willTopic:@"chat/room/nikesh/inbox"
                        willMsg:[@"nikesh chat" dataUsingEncoding:NSUTF8StringEncoding]
                        willQos:MQTTQosLevelAtMostOnce
                 willRetainFlag:false
                   withClientId:@"nikesh_123456789"
                 securityPolicy:nil
                   certificates:nil];
    } else {
        [self.manager connectToLast];
    }
    
    /*
     * MQTTCLient: observe the MQTTSessionManager's state to display the connection status
     */
    
    [self.manager addObserver:self
                   forKeyPath:@"state"
                      options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                      context:nil];

}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    switch (self.manager.state) {
        case MQTTSessionManagerStateClosed:
            NSLog(@"closed");
            break;
        case MQTTSessionManagerStateClosing:
            NSLog(@"closing");
            
            break;
        case MQTTSessionManagerStateConnected:
            NSLog(@"connected");
    [self.manager sendData:[@"Nikesh chat" dataUsingEncoding:NSUTF8StringEncoding]topic:@"chat/room/nikesh/inbox"
                               qos:MQTTQosLevelAtMostOnce
                            retain:FALSE];
            break;
            
        case MQTTSessionManagerStateConnecting:
            NSLog(@"I am connecting");
            break;
        case MQTTSessionManagerStateError:
            NSLog(@"I Got an error");
            break;
        case MQTTSessionManagerStateStarting:
        default:
            NSLog(@"notconnected");
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleMessage:(NSData *)data onTopic:(NSString *)topic retained:(BOOL)retained {
    /*
     * MQTTClient: process received message
     */
    
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"I am Here ----%@",dataString);
    
    NSString *senderString = [topic substringFromIndex:self.base.length + 1];
    
    self.textmessage.text=dataString;
    
    [self.chat insertObject:[NSString stringWithFormat:@"%@:\n%@", senderString, dataString] atIndex:0];
   
}


- (IBAction)SendButton:(id)sender {
    
    if(self.sendmessage!=nil)
    {
       
        [self.manager sendData:[self.sendmessage.text dataUsingEncoding:NSUTF8StringEncoding]topic:@"chat/room/nikesh/inbox"
                           qos:MQTTQosLevelExactlyOnce
                        retain:FALSE];

    
    }
}
@end

