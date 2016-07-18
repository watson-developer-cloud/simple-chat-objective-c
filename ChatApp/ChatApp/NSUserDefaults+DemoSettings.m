/**
 * Copyright IBM Corporation 2016
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

#import "NSUserDefaults+DemoSettings.h"

static NSString * const kSettingExtraMessages = @"kSettingExtraMessages";
static NSString * const kSettingLongMessage = @"kSettingLongMessage";
static NSString * const kSettingEmptyMessages = @"kSettingEmptyMessages";
static NSString * const kSettingSpringiness = @"kSettingSpringiness";
static NSString * const kSettingIncomingAvatar = @"kSettingIncomingAvatar";
static NSString * const kSettingOutgoingAvatar = @"kSettingOutgoingAvatar";


@implementation NSUserDefaults (DemoSettings)

+ (void)saveExtraMessagesSetting:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:kSettingExtraMessages];
}

+ (BOOL)extraMessagesSetting
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kSettingExtraMessages];
}

+ (void)saveLongMessageSetting:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:kSettingLongMessage];
}

+ (BOOL)longMessageSetting
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kSettingLongMessage];
}

+ (void)saveEmptyMessagesSetting:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:kSettingEmptyMessages];
}

+ (BOOL)emptyMessagesSetting
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kSettingEmptyMessages];
}

+ (void)saveSpringinessSetting:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:kSettingSpringiness];
}

+ (BOOL)springinessSetting
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kSettingSpringiness];
}

+ (void)saveOutgoingAvatarSetting:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:kSettingOutgoingAvatar];
}

+ (BOOL)outgoingAvatarSetting
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kSettingOutgoingAvatar];
}

+ (void)saveIncomingAvatarSetting:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:kSettingIncomingAvatar];
}

+ (BOOL)incomingAvatarSetting
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kSettingIncomingAvatar];
}

@end
