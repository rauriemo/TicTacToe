//
//  TicTacToeVC.m
//  TicTacToe
//
//  Created by Rafael Auriemo on 1/13/16.
//  Copyright © 2016 Rafael Auriemo. All rights reserved.
//

#import "TicTacToeVC.h"
#import "Player.h"
#import "VsModeVC.h"


@interface TicTacToeVC ()

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

@end

@implementation TicTacToeVC

@synthesize b1, b2, b3, b4, b5, b6, b7, b8, b9, currentPlayer, tealImg, blueImg, orangeImg, hasBeenClicked, currentTurn, timer, timeLeftLabel, currentPlayerLabel, player1, player2;

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
    
    
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeHandle:)];
    leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [leftRecognizer setNumberOfTouchesRequired:1];
    
    [self.view addGestureRecognizer:leftRecognizer];
    
}

-(void) viewDidAppear:(BOOL)animated{
    [self startTimer];
    [NSTimer scheduledTimerWithTimeInterval:1.0f
                                     target:self
                                   selector:@selector(updateTimeLabel:)
                                   userInfo:nil
                                    repeats:YES];
}

//array of sum of points in rows/columns/diag in format:
//reprsent[c1, c2, c3, r1, r2, r3, d1-(top left to bot right), d2]
//indexes [0 ,  1,  2,  3,  4,  5,  6,                          7]

- (IBAction)b1Click:(UIButton *)sender {
    if (![hasBeenClicked containsObject:@1]) {
        [hasBeenClicked addObject:@1];
        [self updatePoints:@[@0,@3,@6]];
        [self updateBoard:sender];
        [self resetTimer];
    }
}
- (IBAction)b2Click:(UIButton *)sender {
    if (![hasBeenClicked containsObject:@2]) {
        [hasBeenClicked addObject:@2];
        [self updatePoints:@[@1,@3]];
        [self updateBoard:sender];
        [self resetTimer];
    }
}
- (IBAction)b3Click:(UIButton *)sender {
    if (![hasBeenClicked containsObject:@3]) {
        [hasBeenClicked addObject:@3];
        [self updatePoints:@[@2,@3,@7]];
        [self updateBoard:sender];
        [self resetTimer];
    }
}
- (IBAction)b4Click:(UIButton *)sender {
    if (![hasBeenClicked containsObject:@4]) {
        [hasBeenClicked addObject:@4];
        [self updatePoints:@[@0,@4]];
        [self updateBoard:sender];
        [self resetTimer];
    }
}
- (IBAction)b5Click:(UIButton *)sender {
    if (![hasBeenClicked containsObject:@5]) {
        [hasBeenClicked addObject:@5];
        [self updatePoints:@[@1,@4,@6,@7]];
        [self updateBoard:sender];
        [self resetTimer];
    }
}
- (IBAction)b6Click:(UIButton *)sender {
    if (![hasBeenClicked containsObject:@6]) {
        [hasBeenClicked addObject:@6];
        [self updatePoints:@[@2,@4]];
        [self updateBoard:sender];
        [self resetTimer];
    }
}
- (IBAction)b7Click:(UIButton *)sender {
    if (![hasBeenClicked containsObject:@7]) {
        [hasBeenClicked addObject:@7];
        [self updatePoints:@[@0,@5,@7]];
        [self updateBoard:sender];
        [self resetTimer];
    }
}
- (IBAction)b8Click:(UIButton *)sender {
    if (![hasBeenClicked containsObject:@8]) {
        [hasBeenClicked addObject:@8];
        [self updatePoints:@[@1,@5]];
        [self updateBoard:sender];
        [self resetTimer];
    }
}
- (IBAction)b9Click:(UIButton *)sender {
    if (![hasBeenClicked containsObject:@9]) {
        [hasBeenClicked addObject:@9];
        [self updatePoints:@[@2,@5,@6]];
        [self updateBoard:sender];
        [self resetTimer];
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
    [self changeTurn:timer];
    
    NSString *winner = [self checkForWinner];
    if ([winner isEqualToString:@"player 1"] || [winner isEqualToString:@"player 2"]) {
        [self resetBoard:winner];
    }else if (currentTurn == [@9 integerValue]){
        [self resetBoard:@"you tied"];
    }
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
}

-(NSString *)checkForWinner{
    NSString *winner = [NSString new];
    if ([player1.pointsArray containsObject:@3]) {
        winner = @"player 1";
    }else if ([player2.pointsArray containsObject:@3]) {
        winner = @"player 2";
    }
    
    return winner;
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
        currentPlayerLabel.text = @"player 2";
    }else{
        currentPlayer = 1;
        currentPlayerLabel.text = @"player 1";
    }
}

-(void) resetTimeLabel {
    timeLeftLabel.text = @"15";
}

-(void) updateTimeLabel:(NSTimer *)timer{
    timeLeftLabel.text = [NSString stringWithFormat:@"%ld", [timeLeftLabel.text integerValue] - 1 ];
}

//on swipe left move to VsModeVC
- (void)leftSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer {
    UIStoryboard *storyboard = self.storyboard;
    VsModeVC *viewController = (VsModeVC *)[storyboard instantiateViewControllerWithIdentifier:@"vsAiVC"];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(IBAction)unwindToRoot:(UIStoryboardSegue *)unwindSegue{
    [self resetGame];
}

@end
