//
//  ViewController.m
//  Calendar
//
//  Created by Jack on 2018/11/21.
//  Copyright © 2018年 Jack Template. All rights reserved.
//

#import "ViewController.h"
#import "JKCalendarEventManager.h"
#import <EventKit/EventKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 增
    [[JKCalendarEventManager sharedManager] requestAuthorization:^(BOOL granted) {

        if (granted) {

            EKEvent *event = [[JKCalendarEventManager sharedManager] createNewCalendarEvent];
            [[JKCalendarEventManager sharedManager] setTitle:@"习某到成都" forEvent:event];

            NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:400];
            [[JKCalendarEventManager sharedManager] setStartDate:startDate forEvent:event];

            NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:500];
            [[JKCalendarEventManager sharedManager] setEndDate:endDate forEvent:event];

            EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:300];
            [[JKCalendarEventManager sharedManager] addAlarm:alarm forEvent:event];

            [[JKCalendarEventManager sharedManager] saveEvent:event withCompletion:^(BOOL result, NSError *error) {

                if (error) {
                    NSLog(@"save %@ error: %@", event.eventIdentifier,error);
                }
                if (!result) {
                    NSLog(@"save %@ false", event.eventIdentifier);
                } else {
                    NSLog(@"save %@ success", event.eventIdentifier);
                }
            }];
        }
    }];
    
    // 查
//    [[JKCalendarEventManager sharedManager] eventsWithStartDate:[NSDate dateWithTimeIntervalSinceNow:-1000] endDate:[NSDate dateWithTimeIntervalSinceNow:1000] completion:^(NSArray<EKEvent *> *events) {
//
//        for (EKEvent *event in events) {
//            NSLog(@"fetch event: %@",event.eventIdentifier);
//        }
//
//
//    }];
    
//    NSString *ID = @"F9A7EE56-AE45-4B67-8F4B-5032F6625941:330F3582-2898-4E4B-8CE1-4CD51962750B";
//    EKEvent *event = [[JKCalendarEventManager sharedManager] eventWithIdentifier:ID];

//    // 改
//    [[JKCalendarEventManager sharedManager] setTitle:@"李某人到双流机场" forEvent:event];
//    [[JKCalendarEventManager sharedManager] setEndDate:[NSDate dateWithTimeIntervalSinceNow:500] forEvent:event];
//    [[JKCalendarEventManager sharedManager] setStartDate:[NSDate dateWithTimeIntervalSinceNow:400] forEvent:event];
//    [[JKCalendarEventManager sharedManager] saveEvent:event withCompletion:^(BOOL result, NSError *error) {
//
//        if (error) {
//            NSLog(@"save %@ error: %@", event.eventIdentifier,error);
//        }
//        if (!result) {
//            NSLog(@"save %@ false", event.eventIdentifier);
//        } else {
//            NSLog(@"save %@ success", event.eventIdentifier);
//        }
//    }];

    // 删
//    [[JKCalendarEventManager sharedManager] removeEvent:event withCompletion:^(BOOL result, NSError *error) {
//
//        if (result) {
//            NSLog(@"remove event %@ success",ID);
//        } else{
//            NSLog(@"remove event %@ failed %@",ID, error);
//        }
//
//    }];
}


@end
