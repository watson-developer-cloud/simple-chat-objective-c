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

#import "ViewController.h"
#import "ChatApp-swift.h"

@interface ViewController ()

@property (strong, nonatomic) Messages *messages;
@property (strong, nonatomic) ConversationBridge *conversation;
@property (strong, nonatomic) TextToSpeechBridge *textToSpeech;
@property (strong, nonatomic) SpeechToTextBridge *speechToText;

@end

@implementation ViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Chat App Example";
    self.messages = [[Messages alloc] init];
    self.senderId = kChatAppAvatarIdFisher;
    self.senderDisplayName = kChatAppAvatarDisplayNameFisher;
    
    [JSQMessagesCollectionViewCell registerMenuAction:@selector(synthesize:)];
    
    UIImage *microphoneImage = [UIImage imageNamed:@"microphone"];
    UIButton *microphoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [microphoneButton setImage:microphoneImage forState:UIControlStateNormal];
    microphoneButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.inputToolbar.contentView.leftBarButtonItem = microphoneButton;
    
    [microphoneButton addTarget:self action:@selector(didPressMicrophoneButton:) forControlEvents:UIControlEventTouchDown];
    [microphoneButton addTarget:self action:@selector(didReleaseMicrophoneButton:) forControlEvents:UIControlEventTouchUpInside];

    self.conversation = [[ConversationBridge alloc] init];
    self.textToSpeech = [[TextToSpeechBridge alloc] init];
    self.speechToText = [[SpeechToTextBridge alloc] init];
    
    [self.conversation startConversation:nil success:^(NSString *response){
        [self didReceiveConversationResponse:response];
    }];
    
    [self.speechToText prepare:^(NSString *transcript) {
        self.inputToolbar.contentView.textView.text = transcript;
        [self.inputToolbar toggleSendButtonEnabled];
    }];
    
    [self.speechToText connect];
}

#pragma mark - Watson service callbacks

- (void)didReceiveConversationResponse:(NSString *)response
{
    [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
    
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:kChatAppAvatarIdWatson
                                             senderDisplayName:kChatAppAvatarDisplayNameWatson
                                                          date:[NSDate date]
                                                          text:response];
    
    [self.messages.messages addObject:message];
    [self finishReceivingMessageAnimated:YES];
    [self.textToSpeech synthesize:response];
}

- (void)didPressMicrophoneButton:(UIButton *)sender
{
    [self.speechToText connect]; // connect, if not already connected
    [self.speechToText startRequest]; // start a new recognition request
    [self.speechToText startMicrophone]; // start streaming microphone audio
}

- (void)didReleaseMicrophoneButton:(UIButton *)sender
{
    [self.speechToText stopMicrophone]; // stop streaming microphone audio
    [self.speechToText stopRequest]; // stop the recognition request
    
    // No need to disconnect -- the connection will timeout if the microphone
    // is not used again within 30 seconds. This avoids the overhead of
    // connecting and disconnecting the session with every press of the
    // microphone button.
}

#pragma mark - Custom menu actions for cells

- (void)didReceiveMenuWillShowNotification:(NSNotification *)notification
{
    UIMenuController *menu = [notification object];
    menu.menuItems = @[ [[UIMenuItem alloc] initWithTitle:@"Synthesize" action:@selector(synthesize:)] ];
}

#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
                                             senderDisplayName:senderDisplayName
                                                          date:date
                                                          text:text];
    
    [self.messages.messages addObject:message];
    [self finishSendingMessageAnimated:YES];
    [self.conversation continueConversation:text success:^(NSString *response){
        [self didReceiveConversationResponse:response];
    }];
}

- (void)didPressAccessoryButton:(UIButton *)sender
{
    NSLog(@"Tapped microphone!");
}

#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messages.messages objectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messages.messages objectAtIndex:indexPath.item];
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.messages.outgoingBubbleImageData;
    }
    return self.messages.incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messages.messages objectAtIndex:indexPath.item];
    return [self.messages.avatars objectForKey:message.senderId];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messages.messages objectAtIndex:indexPath.item];
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.messages.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.messages.messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    JSQMessage *msg = [self.messages.messages objectAtIndex:indexPath.item];
    if (!msg.isMediaMessage) {
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor blackColor];
        }
        else {
            cell.textView.textColor = [UIColor whiteColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    return cell;
}

#pragma mark - Custom menu items

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(synthesize:)) {
        return YES;
    }
    return [super collectionView:collectionView canPerformAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(synthesize:)) {
        [self synthesize:sender];
        return;
    }
    [super collectionView:collectionView performAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)synthesize:(id)sender
{
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)sender;
    JSQMessagesCellTextView *textView = cell.textView;
    if (textView) {
        [self.textToSpeech synthesize:textView.text];
    }
}

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *currentMessage = [self.messages.messages objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.messages.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

@end
