//
//  ViewController.h
//  Mqtt_POC
//
//  Created by MEETA on 23/10/16.
//  Copyright © 2016 MEETA_kanayalal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MQTTClient/MQTTClient.h>
#import <MQTTClient/MQTTSessionManager.h>


@interface ViewController : UIViewController<MQTTSessionManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textmessage;

@property (weak, nonatomic) IBOutlet UITextField *sendmessage;

- (IBAction)SendButton:(id)sender;

@end

