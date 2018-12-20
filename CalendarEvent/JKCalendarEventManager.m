//
//  JKCalendarEventManager.m
//  Calendar
//
//  Created by Jack on 2018/11/21.
//  Copyright © 2018年 Jack Template. All rights reserved.
//

#import "JKCalendarEventManager.h"
#import <EventKit/EventKit.h>


@interface JKCalendarEventManager ()

/**
 * 因为 EventStore 是 Calendar database 的数据库引擎，
 * 所以应该尽量少的对他进行创建和销毁，所以推荐使用EventStore的时候使用单例模式
 */
@property (nonatomic,strong) EKEventStore *store;

@end

@implementation JKCalendarEventManager

+ (instancetype)sharedManager {
    static JKCalendarEventManager *manager;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        manager = [[JKCalendarEventManager alloc] init];
        manager.store = [[EKEventStore alloc] init];
    });
    return manager;
}

#pragma mark - 权限

- (BOOL)authorized {
    return [self authorization] == EKAuthorizationStatusAuthorized;
}

- (EKAuthorizationStatus)authorization {
    
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    return status;
}

- (void)requestAuthorization:(authorizeBlk)blk {
    
    [self.store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        
        if (blk) {
            
            if (granted) {
                blk(YES);
            } else {
                blk(NO);
            }
            
        }
    }];
}

#pragma mark - 检索事件

/**
 * 异步执行
 */
- (void)eventsWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate completion:(fetchEventCompletionBlk)blk {
    if (!self.authorized) {
        if (blk) {
            blk(nil);
        }
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        NSPredicate *predicate = [self.store predicateForEventsWithStartDate:startDate
                                                                     endDate:endDate
                                                                   calendars:nil];
        
        NSArray<EKEvent *> *events = [self.store eventsMatchingPredicate:predicate];
        
        if (blk) {
            blk(events);
        }
    });
}

- (EKEvent *)eventWithIdentifier:(NSString *)identifier {
    if (!self.authorized) {
        return nil;
    }
    if (identifier == nil) {
        return nil;
    }
    
    EKEvent *event = [self.store eventWithIdentifier:identifier];
    
    return event;
}

#pragma mark - 创建/编辑事件

- (EKEvent *)createNewCalendarEvent {
    if (!self.authorized) {
        return nil;
    }
    EKEvent *event = [EKEvent eventWithEventStore:self.store];
    [self setCalendar:self.store.defaultCalendarForNewEvents forEvent:event];
    
    return event;
}

- (void)setTitle:(NSString *)title forEvent:(EKEvent *)event {
    if (event && self.authorized) {
        event.title = title;
    }
}

- (void)setNotes:(NSString *)notes forEvent:(EKEvent *)event {
    if (event && self.authorized) {
        event.notes = notes;
    }
}

- (void)setTimeZone:(NSTimeZone *)timeZone forEvent:(EKEvent *)event {
    if (event && self.authorized) {
        event.timeZone = timeZone;
    }
}

- (void)setStartDate:(NSDate *)startDate forEvent:(EKEvent *)event {
    if (event && self.authorized) {
        event.startDate = startDate;
    }
}

- (void)setEndDate:(NSDate *)endDate forEvent:(EKEvent *)event {
    if (event && self.authorized) {
        event.endDate = endDate;
    }
}

- (void)setCalendar:(EKCalendar *)calendar forEvent:(EKEvent *)event {
    if (event && self.authorized) {
        event.calendar = calendar;
    }
}

- (void)addAlarm:(EKAlarm *)alarm forEvent:(EKEvent *)evnet {
    if (evnet && alarm && self.authorized) {
        [evnet addAlarm:alarm];
    }
}

#pragma mark - 保存/删除事件

- (void)saveEvent:(EKEvent *)event withCompletion:(commitResultBlk)blk {
    if (event && self.authorized) {
        
        NSError *error;
        [self.store saveEvent:event span:EKSpanThisEvent commit:YES error:&error];
        BOOL result = error ? NO : YES;
        if (blk) {
            blk(result, error);
        }
    }
}

- (void)removeEvent:(EKEvent *)event withCompletion:(commitResultBlk)blk {
    if (event && self.authorized) {
        
        NSError *error;
        [self.store removeEvent:event span:EKSpanThisEvent commit:YES error:&error];
        BOOL result = error ? NO : YES;
        if (blk) {
            blk(result, error);
        }
    }
}

@end
