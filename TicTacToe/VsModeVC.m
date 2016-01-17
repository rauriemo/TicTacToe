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
@property (weak, nonatomic) IBOutlet UIButton *vsAiToggle;


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
@property BOOL aiButtonToggled;
@property NSArray *pointCalc;
@property NSArray *buttonArray;
@property NSArray *buttonsInWinScenarios;

@end

@implementation VsModeVC

@synthesize b1, b2, b3, b4, b5, b6, b7, b8, b9, easyButton, toughButton, currentPlayerLabel, timeLeftLabel, currentPlayer, hasBeenClicked, tealImg, blueImg, orangeImg, currentTurn, timer, player1, player2, difficulty, pointCalc, buttonArray, buttonsInWinScenarios, aiButtonToggled, vsAiToggle;

- (void)viewDidLoad {
    [super viewDidLoad];
    //reprsent[c1, c2, c3, r1, r2, r3, d1-(top left to bot right), d2]
    //indexes [0 ,  1,  2,  3,  4,  5,  6,                          7]
    player1 = [Player new];
    player1.name = @"player1";
    player1.pointsArray = [[NSMutableArray alloc] initWithArray:@[@0,@0,@0,@0,@0,@0,@0,@0]];
    player2 = [Player new];
    player2.name = @"player2";
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
    aiButtonToggled = NO;
    easyButton.alpha = 0;
    toughButton.alpha = 0;
    
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeHandle:)];
    rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [rightRecognizer setNumberOfTouchesRequired:1];
    
    [self.view addGestureRecognizer:rightRecognizer];
    
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
                                           selector:@selector(switchPlayer:)
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

- (IBAction)buttonTapped:(UIButton *)sender {
    if ((currentPlayer == 1 && ![hasBeenClicked containsObject:sender]) || (!aiButtonToggled && ![hasBeenClicked containsObject:sender])) {
        [hasBeenClicked addObject:sender];
        int index = (int)[buttonArray indexOfObject:sender];
        [self updatePoints:pointCalc[index]];
        [self updateBoard:sender];
        [self resetTimer];
        if (currentTurn!=[@9 integerValue] && aiButtonToggled) {
            [self haveAiPlay];
        }
    }
}


-(void) haveAiPlay{
    if (difficulty == YES) {
        //action if AI is close to winning
        if ([player2.pointsArray containsObject:@2]) {
            BOOL picked = [self playForIndexOfPoint:player2:@2];
            if (picked) {
                return;
            }
        //action if player is close to winning
        }
        if ([player1.pointsArray containsObject:@2]) {
            BOOL picked = [self playForIndexOfPoint:player1:@2];
            if (picked) {
                return;
            }
        //action if AI already has 1 picked in a line
        }
        if ([player2.pointsArray containsObject:@1]) {
            BOOL picked = [self playForIndexOfPoint:player2:@1];
            if (!picked) {
                [self pickRandom];
            }
        }else{
            [self pickRandom];
        }
    }else{
        [self pickRandom];
    }
}

-(BOOL) playForIndexOfPoint:(Player *)player :(NSNumber *)pointToFind{
    NSIndexSet *indexSet=[player.pointsArray indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj isEqualToNumber:pointToFind];
    }];
    
    NSMutableArray *indexArray=[NSMutableArray new];
    
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [indexArray addObject:[NSNumber numberWithInteger:idx]];
    }];
    
    for (int i=0; i<indexArray.count; i++) {
        int currentIndex = (int)[indexArray[i] integerValue];
        NSArray *winScenario = buttonsInWinScenarios[currentIndex];
        NSUInteger buttonChosen;
        for (int i =0; i<winScenario.count; i++) {
            if (![hasBeenClicked containsObject:winScenario[i]]) {
                [hasBeenClicked addObject:winScenario[i]];
                buttonChosen = [buttonArray indexOfObject:winScenario[i]];
                [self updatePoints:pointCalc[buttonChosen]];
                [self updateBoard:winScenario[i]];
                return YES;
            }
        }
    }
    return NO;
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
    if ([winner isEqualToString:player1.name] || [winner isEqualToString:player2.name]) {
        [self resetBoard:winner];
    }else if (currentTurn == [@9 integerValue]){
        [self resetBoard:@"you tied"];
    }
    
    [self changeTurn];
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
    if (currentPlayer == 2 && aiButtonToggled) {
        [self haveAiPlay];
    }
}

-(NSString *)checkForWinner{
    NSString *winner = [NSString new];
    if ([player1.pointsArray containsObject:@3]) {
        winner = player1.name;
    }else if ([player2.pointsArray containsObject:@3]) {
        winner = player2.name;
    }
    
    return winner;
}

-(void) switchPlayer:(NSTimer *)timer{
    [self changeTurn];
    if (aiButtonToggled) {
        [self haveAiPlay];
    }
}

-(void) changeTurn {
    [self resetTimer];
    if (currentPlayer == 1) {
        currentPlayer = 2;
        currentPlayerLabel.text = player2.name;
    }else{
        currentPlayer = 1;
        currentPlayerLabel.text = player1.name;
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

- (void)rightSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)vsAiButtonToggled:(UIButton *)sender {
    if (aiButtonToggled) {
        vsAiToggle.selected = NO;
        easyButton.alpha = 0;
        toughButton.alpha = 0;
        aiButtonToggled = NO;
        player2.name = @"player2";
    }else {
        vsAiToggle.selected = YES;
        easyButton.alpha = 1;
        toughButton.alpha = 1;
        aiButtonToggled = YES;
        player2.name = @"AI";
        if (currentPlayer == 2) {
            [self haveAiPlay];
        }
    }
}

@end
