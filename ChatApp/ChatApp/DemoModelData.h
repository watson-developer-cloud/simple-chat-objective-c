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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "JSQMessages.h"

/**
 *  This is for demo/testing purposes only. 
 *  This object sets up some fake model data.
 *  Do not actually do anything like this.
 */

static NSString * const kJSQDemoAvatarDisplayNameSquires = @"Jesse Squires";
static NSString * const kJSQDemoAvatarDisplayNameCook = @"Watson";
static NSString * const kJSQDemoAvatarDisplayNameJobs = @"Jobs";
static NSString * const kJSQDemoAvatarDisplayNameWoz = @"Steve Wozniak";

static NSString * const kJSQDemoAvatarIdSquires = @"053496-4509-289";
static NSString * const kJSQDemoAvatarIdCook = @"468-768355-23123";
static NSString * const kJSQDemoAvatarIdJobs = @"707-8956784-57";
static NSString * const kJSQDemoAvatarIdWoz = @"309-41802-93823";



@interface DemoModelData : NSObject

@property (strong, nonatomic) NSMutableArray *messages;

@property (strong, nonatomic) NSDictionary *avatars;

@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;

@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

@property (strong, nonatomic) NSDictionary *users;

- (void)addPhotoMediaMessage;

- (void)addLocationMediaMessageCompletion:(JSQLocationMediaItemCompletionBlock)completion;

- (void)addVideoMediaMessage;

- (void)addAudioMediaMessage;

@end
