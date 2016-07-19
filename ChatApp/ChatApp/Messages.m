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

#import "Messages.h"

@implementation Messages

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.messages = [[NSMutableArray alloc] init];

        JSQMessagesAvatarImage *grfImage = [JSQMessagesAvatarImageFactory avatarImageWithUserInitials:@"GRF"
                                                                                      backgroundColor:[UIColor colorWithWhite:0.85f alpha:1.0f]
                                                                                            textColor:[UIColor colorWithWhite:0.60f alpha:1.0f]
                                                                                                 font:[UIFont systemFontOfSize:14.0f]
                                                                                             diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        
        JSQMessagesAvatarImage *watsonImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"watson_avatar"]
                                                                                       diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        
        self.avatars = @{ kChatAppAvatarIdFisher : grfImage,
                          kChatAppAvatarIdWatson : watsonImage };
        
        
        self.users = @{ kChatAppAvatarIdWatson : kChatAppAvatarDisplayNameWatson,
                        kChatAppAvatarIdFisher : kChatAppAvatarDisplayNameFisher };

        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        
        self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
        self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    }
    
    return self;
}

@end
