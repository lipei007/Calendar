//
//  JKCalendarEventManager.h
//  Calendar
//
//  Created by Jack on 2018/11/21.
//  Copyright © 2018年 Jack Template. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EKEvent,EKCalendar,EKAlarm;

typedef void(^fetchEventCompletionBlk)(NSArray<EKEvent *> *events);
typedef void(^commitResultBlk)(BOOL result, NSError *error);
typedef void(^authorizeBlk)(BOOL granted);

/**
 * Privacy - Calendars Usage Description
 */
@interface JKCalendarEventManager : NSObject

@property (nonatomic,assign,readonly) BOOL authorized;

+ (instancetype)sharedManager;

- (void)requestAuthorization:(authorizeBlk)blk;

#pragma mark - 检索

/**
 * 异步执行
 */
- (void)eventsWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate completion:(fetchEventCompletionBlk)blk;

- (EKEvent *)eventWithIdentifier:(NSString *)identifier;

#pragma mark - 创建/编辑事件

- (EKEvent *)createNewCalendarEvent;

- (void)setTitle:(NSString *)title forEvent:(EKEvent *)event;

- (void)setNotes:(NSString *)notes forEvent:(EKEvent *)event;

- (void)setTimeZone:(NSTimeZone *)timeZone forEvent:(EKEvent *)event;

- (void)setStartDate:(NSDate *)startDate forEvent:(EKEvent *)event;

- (void)setEndDate:(NSDate *)endDate forEvent:(EKEvent *)event;

- (void)setCalendar:(EKCalendar *)calendar forEvent:(EKEvent *)event;

- (void)addAlarm:(EKAlarm *)alarm forEvent:(EKEvent *)evnet;

#pragma mark - 保存/删除事件

- (void)saveEvent:(EKEvent *)event withCompletion:(commitResultBlk)blk;

- (void)removeEvent:(EKEvent *)event withCompletion:(commitResultBlk)blk;

@end


