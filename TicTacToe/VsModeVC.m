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

@end

@implementation VsModeVC

@synthesize b1, b2, b3, b4, b5, b6, b7, b8, b9, currentPlayerLabel, timeLeftLabel, currentPlayer, hasBeenClicked, tealImg, blueImg, orangeImg, currentTurn, timer, player1, player2, difficulty;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    player1 = [Player new];
    player1.pointsArray = [[NSMutableArray alloc] initWithArray:@[@0,@0,@0,@0,@0,@0,@0,@0]];
    player2 = [Player new];
    player2.pointsArray = [[NSMutableArray alloc] initWithArray:@[@0,@0,@0,@0,@0,@0,@0,@0]];
    
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

-(void) changeTurn:(NSTimer *)timer {
    [self resetTimer];
    if (currentPlayer == 1) {
        currentPlayer = 2;
        currentPlayerLabel.text = @"AI";
    }else{
        currentPlayer = 1;
        currentPlayerLabel.text = @"YOU";
    }
}

-(void) resetTimeLabel {
    timeLeftLabel.text = @"15";
}

-(void) updateTimeLabel:(NSTimer *)timer{
    timeLeftLabel.text = [NSString stringWithFormat:@"%ld", [timeLeftLabel.text integerValue] - 1 ];
}

- (IBAction)b1Click:(id)sender {
}
- (IBAction)b2Click:(id)sender {
}
- (IBAction)b3Click:(id)sender {
}
- (IBAction)b4Click:(id)sender {
}
- (IBAction)b5Click:(id)sender {
}
- (IBAction)b6Click:(id)sender {
}
- (IBAction)b7Click:(id)sender {
}
- (IBAction)b8Click:(id)sender {
}
- (IBAction)b9Click:(id)sender {
}




- (IBAction)changeDifficulty:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString: @"tough"]) {
        difficulty = YES;
    }else{
        difficulty = NO;
    }
}



@end
