//
//  VsModeVC.m
//  TicTacToe
//
//  Created by Rafael Auriemo on 1/14/16.
//  Copyright © 2016 Rafael Auriemo. All rights reserved.
//

#import "VsModeVC.h"
#import "Player.h"

@interface VsModeVC ()

@property (weak, nonatomic) IBOutlet UIButton *b1;
@property (weak, nonatomic) IBOutlet UIButton *b2;
@property (weak, nonatomic) IBOutlet UIButton *b3;
@property (weak, nonatomic) IBOutlet UIButton *b4;
@property (weak, nonatomic) IBOutlet UIButton *b5;
@property (weak, nonatomic) IBOutlet UIButton *b6;
@property (weak, nonatomic) IBOutlet UIButton *b7;
@property (weak, nonatomic) IBOutlet UIButton *b8;
@property (weak, nonatomic) IBOutlet UIButton *b9;

@property (weak, nonatomic) IBOutlet UIButton *easyButton;
@property (weak, nonatomic) IBOutlet UIButton *toughButton;

@property (weak, nonatomic) IBOutlet UILabel *currentPlayerLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLeftLabel;

@property int currentPlayer;
@property NSMutableArray *hasBeenClicked;
@property UIImage *tealImg;
@property UIImage *blueImg;
@property UIImage *orangeImg;
@property int currentTurn;
@property NSTimer *timer;

@property Player *player1;
@property Player *player2;

//yes if difficult
@property BOOL difficulty;
@property NSArray *pointCalc;
@property NSArray *buttonArray;
@property NSArray *buttonsInWinScenarios;

@end

@implementation VsModeVC

@synthesize b1, b2, b3, b4, b5, b6, b7, b8, b9, easyButton, toughButton, currentPlayerLabel, timeLeftLabel, currentPlayer, hasBeenClicked, tealImg, blueImg, orangeImg, currentTurn, timer, player1, player2, difficulty, pointCalc, buttonArray, buttonsInWinScenarios;

- (void)viewDidLoad {
    [super viewDidLoad];
    //reprsent[c1, c2, c3, r1, r2, r3, d1-(top left to bot right), d2]
    //indexes [0 ,  1,  2,  3,  4,  5,  6,                          7]
    player1 = [Player new];
    player1.pointsArray = [[NSMutableArray alloc] initWithArray:@[@0,@0,@0,@0,@0,@0,@0,@0]];
    player2 = [Player new];
    player2.pointsArray = [[NSMutableArray alloc] initWithArray:@[@0,@0,@0,@0,@0,@0,@0,@0]];
    
    pointCalc = @[@[@0,@3,@6],@[@1,@3],@[@2,@3,@7],@[@0,@4],@[@1,@4,@6,@7],@[@2,@4],@[@0,@5,@7],@[@1,@5],@[@2,@5,@6]];
    buttonArray = @[b1, b2, b3, b4, b5, b6, b7, b8, b9];
    buttonsInWinScenarios = @[@[b1,b4,b7],@[b2,b5,b8],@[b3,b6,b9],@[b1,b2,b3],@[b4,b5,b6],@[b7,b8,b9],@[b1,b5,b9],@[b3,b5,b7]];
    
    hasBeenClicked = [NSMutableArray new];
    tealImg = [UIImage imageNamed:@"teal_button.png"];
    blueImg = [UIImage imageNamed:@"blue_button.png"];
    orangeImg = [UIImage imageNamed:@"orange_button.png"];
    currentPlayer = 1;
    currentTurn = 0;
    difficulty = NO;

}

-(void) viewDidAppear:(BOOL)animated{
    [self startTimer];
    [NSTimer scheduledTimerWithTimeInterval:1.0f
                                     target:self
                                   selector:@selector(updateTimeLabel:)
                                   userInfo:nil
                                    repeats:YES];
}

-(void) startTimer{
    timer = [NSTimer scheduledTimerWithTimeInterval:15.0
                                             target:self
                                           selector:@selector(changeTurn:)
                                           userInfo:nil
                                            repeats:NO];
}

-(void) resetTimer{
    [self resetTimeLabel];
    [timer invalidate];
    [self startTimer];
}

-(void) resetTimeLabel {
    timeLeftLabel.text = @"15";
}

-(void) updateTimeLabel:(NSTimer *)timer{
    timeLeftLabel.text = [NSString stringWithFormat:@"%ld", [timeLeftLabel.text integerValue] - 1 ];
}

- (IBAction)b1Click:(id)sender {
    if (currentPlayer == 1 && ![hasBeenClicked containsObject:b1]) {
        [hasBeenClicked addObject:b1];
        [self updatePoints:@[@0,@3,@6]];
        [self updateBoard:sender];
        [self resetTimer];
        if (currentTurn!=[@9 integerValue]) {
            [self haveAiPlay];
        }
    }
}
- (IBAction)b2Click:(id)sender {
    if (currentPlayer == 1 && ![hasBeenClicked containsObject:b2]) {
        [hasBeenClicked addObject:b2];
        [self updatePoints:@[@1,@3]];
        [self updateBoard:sender];
        [self resetTimer];
        if (currentTurn!=[@9 integerValue]) {
            [self haveAiPlay];
        }
    }
}
- (IBAction)b3Click:(id)sender {
    if (currentPlayer == 1 && ![hasBeenClicked containsObject:b3]) {
        [hasBeenClicked addObject:b3];
        [self updatePoints:@[@2,@3,@7]];
        [self updateBoard:sender];
        [self resetTimer];
        if (currentTurn!=[@9 integerValue]) {
            [self haveAiPlay];
        }
    }
}
- (IBAction)b4Click:(id)sender {
    if (currentPlayer == 1 && ![hasBeenClicked containsObject:b4]) {
        [hasBeenClicked addObject:b4];
        [self updatePoints:@[@0,@4]];
        [self updateBoard:sender];
        [self resetTimer];
        if (currentTurn!=[@9 integerValue]) {
            [self haveAiPlay];
        }
    }
}
- (IBAction)b5Click:(id)sender {
    if (currentPlayer == 1 && ![hasBeenClicked containsObject:b5]) {
        [hasBeenClicked addObject:b5];
        [self updatePoints:@[@1,@4,@6,@7]];
        [self updateBoard:sender];
        [self resetTimer];
        if (currentTurn!=[@9 integerValue]) {
            [self haveAiPlay];
        }
    }
}
- (IBAction)b6Click:(id)sender {
    if (currentPlayer == 1 && ![hasBeenClicked containsObject:b6]) {
        [hasBeenClicked addObject:b6];
        [self updatePoints:@[@2,@4]];
        [self updateBoard:sender];
        [self resetTimer];
        if (currentTurn!=[@9 integerValue]) {
            [self haveAiPlay];
        }
    }
}
- (IBAction)b7Click:(id)sender {
    if (currentPlayer == 1 && ![hasBeenClicked containsObject:b7]) {
        [hasBeenClicked addObject:b7];
        [self updatePoints:@[@0,@5,@7]];
        [self updateBoard:sender];
        [self resetTimer];
        if (currentTurn!=[@9 integerValue]) {
            [self haveAiPlay];
        }
    }
}
- (IBAction)b8Click:(id)sender {
    if (currentPlayer == 1 && ![hasBeenClicked containsObject:b8]) {
        [hasBeenClicked addObject:b8];
        [self updatePoints:@[@1,@5]];
        [self updateBoard:sender];
        [self resetTimer];
        if (currentTurn!=[@9 integerValue]) {
            [self haveAiPlay];
        }
    }
}
- (IBAction)b9Click:(id)sender {
    if (currentPlayer == 1 && ![hasBeenClicked containsObject:b9]) {
        [hasBeenClicked addObject:b9];
        [self updatePoints:@[@2,@5,@6]];
        [self updateBoard:sender];
        [self resetTimer];
        if (currentTurn!=[@9 integerValue]) {
            [self haveAiPlay];
        }
    }
}

-(void) haveAiPlay{
    if (difficulty == YES) {
        //action if player is close to winning
        if ([player1.pointsArray containsObject:@2]) {
            NSUInteger index=[player1.pointsArray indexOfObject:@2];
            NSArray *winScenario = buttonsInWinScenarios[index];
            for (int i =0; i<winScenario.count; i++) {
                if (![hasBeenClicked containsObject:winScenario[i]]) {
                    [hasBeenClicked addObject:winScenario[i]];
                    NSUInteger index = [buttonArray indexOfObject:winScenario[i]];
                    [self updatePoints:pointCalc[index]];
                    [self updateBoard:winScenario[i]];
                    return;
                }
            }
            [self pickRandom];
        }else{
           [self pickRandom];
        }
    }else{
        [self pickRandom];
    }
    
}

-(void) pickRandom{
    BOOL picked = NO;
    while (!picked) {
        NSInteger randomIndexInSet = arc4random() % [buttonArray count];
        if (![hasBeenClicked containsObject:buttonArray[randomIndexInSet]]) {
            [hasBeenClicked addObject:buttonArray[randomIndexInSet]];
            [self updatePoints:(pointCalc[randomIndexInSet])];
            [self updateBoard:buttonArray[randomIndexInSet]];
            picked = YES;
        }
    }
}

-(void) updatePoints:(NSArray *) indexArray {
    currentTurn += 1;
    NSNumber *index;
    if (currentPlayer == 1) {
        for (int i = 0; i<indexArray.count; i++) {
            index = [indexArray objectAtIndex:i];
            player1.pointsArray[[index integerValue]] = @([player1.pointsArray[[index integerValue]] integerValue] + 1);
        }
    }else {
        for (int i = 0; i<indexArray.count; i++) {
            index = [indexArray objectAtIndex:i];
            player2.pointsArray[[index integerValue]] = @([player2.pointsArray[[index integerValue]] integerValue] + 1);
        }
    }
}

-(void) updateBoard:(UIButton *)sender {
    
    if (currentPlayer == 1) {
        [sender setImage:tealImg forState:UIControlStateNormal];
    }else {
        [sender setImage:blueImg forState:UIControlStateNormal];
    }
    
    NSString *winner = [self checkForWinner];
    if ([winner isEqualToString:@"PLAYER"] || [winner isEqualToString:@"AI"]) {
        [self resetBoard:winner];
    }else if (currentTurn == [@9 integerValue]){
        [self resetBoard:@"you tied"];
    }
    
    [self changeTurn:timer];
}

-(void) resetBoard:(NSString *) winner{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Game Over!" message:[NSString stringWithFormat:@"Congratulations %@!", winner] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *restartGame = [UIAlertAction actionWithTitle:@"restart" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self resetGame];
    }];
    
    [alertController addAction:restartGame];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void) resetGame{
    [b1 setImage:orangeImg forState:UIControlStateNormal];
    [b2 setImage:orangeImg forState:UIControlStateNormal];
    [b3 setImage:orangeImg forState:UIControlStateNormal];
    [b4 setImage:orangeImg forState:UIControlStateNormal];
    [b5 setImage:orangeImg forState:UIControlStateNormal];
    [b6 setImage:orangeImg forState:UIControlStateNormal];
    [b7 setImage:orangeImg forState:UIControlStateNormal];
    [b8 setImage:orangeImg forState:UIControlStateNormal];
    [b9 setImage:orangeImg forState:UIControlStateNormal];
    for (int i=0; i<player1.pointsArray.count; i++) {
        [player1.pointsArray replaceObjectAtIndex:i withObject:@0];
        [player2.pointsArray replaceObjectAtIndex:i withObject:@0];
    }
    [hasBeenClicked removeAllObjects];
    currentTurn = 0;
    [self resetTimeLabel];
    [self resetTimer];
    if (currentPlayer == 2) {
        [self haveAiPlay];
    }
}

-(NSString *)checkForWinner{
    NSString *winner = [NSString new];
    if ([player1.pointsArray containsObject:@3]) {
        winner = @"PLAYER";
    }else if ([player2.pointsArray containsObject:@3]) {
        winner = @"AI";
    }
    
    return winner;
}

-(void) changeTurn:(NSTimer *)timer {
    [self resetTimer];
    if (currentPlayer == 1) {
        currentPlayer = 2;
        currentPlayerLabel.text = @"AI";
        
    }else{
        currentPlayer = 1;
        currentPlayerLabel.text = @"PLAYER";
    }
}


- (IBAction)changeDifficulty:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString: @"tough"]) {
        difficulty = YES;
        toughButton.selected = YES;
        easyButton.selected = NO;
        if (currentPlayer == 2) {
            [self haveAiPlay];
        }
    }else{
        difficulty = NO;
        easyButton.selected = YES;
        toughButton.selected = NO;
        if (currentPlayer == 2) {
            [self haveAiPlay];
        }
    }
}



@end
