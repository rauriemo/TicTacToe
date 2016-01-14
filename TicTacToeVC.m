//
//  TicTacToeVC.m
//  TicTacToe
//
//  Created by Rafael Auriemo on 1/13/16.
//  Copyright © 2016 Rafael Auriemo. All rights reserved.
//

#import "TicTacToeVC.h"


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


@property int currentPlayer;
@property (weak, nonatomic) IBOutlet UILabel *currentPlayerLabel;
@property NSMutableArray *p1Points;
@property NSMutableArray *p2Points;
@property UIImage * tealImg;
@property UIImage * blueImg;
@property UIImage * orangeImg;

@end

@implementation TicTacToeVC

@synthesize b1, b2, b3, b4, b5, b6, b7, b8, b9, currentPlayer, p2Points, p1Points, tealImg, blueImg, orangeImg;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    p1Points = [[NSMutableArray alloc] initWithArray:@[@0,@0,@0,@0,@0,@0,@0,@0]];
    p2Points = [[NSMutableArray alloc] initWithArray:@[@0,@0,@0,@0,@0,@0,@0,@0]];
    tealImg = [UIImage imageNamed:@"teal_button.png"];
    blueImg = [UIImage imageNamed:@"blue_button.png"];
    orangeImg = [UIImage imageNamed:@"orange_button.png"];
    currentPlayer = 1;
   
}

//array of sum of points in rows/columns/diag in format:
//[c1, c2, c3, r1, r2, r3, d1-(top left to bot right), d2]
//[0 ,  1,  2,  3,  4,  5,  6,                          7]

- (IBAction)b1Click:(UIButton *)sender {
    [self updatePoints:@[@0,@3,@6]];
    [self updateBoard:sender];
}
- (IBAction)b2Click:(UIButton *)sender {
    [self updatePoints:@[@1,@3]];
    [self updateBoard:sender];
}
- (IBAction)b3Click:(UIButton *)sender {
    [self updatePoints:@[@2,@3,@7]];
    [self updateBoard:sender];
}
- (IBAction)b4Click:(UIButton *)sender {
    [self updatePoints:@[@0,@4]];
    [self updateBoard:sender];
}
- (IBAction)b5Click:(UIButton *)sender {
    [self updatePoints:@[@1,@4,@6,@7]];
    [self updateBoard:sender];
}
- (IBAction)b6Click:(UIButton *)sender {
    [self updatePoints:@[@2,@4]];
    [self updateBoard:sender];
}
- (IBAction)b7Click:(UIButton *)sender {
    [self updatePoints:@[@0,@5,@7]];
    [self updateBoard:sender];
}
- (IBAction)b8Click:(UIButton *)sender {
    [self updatePoints:@[@1,@5]];
    [self updateBoard:sender];
}
- (IBAction)b9Click:(UIButton *)sender {
    [self updatePoints:@[@2,@5,@6]];
    [self updateBoard:sender];
}

-(void) updatePoints:(NSArray *) indexArray {
    NSNumber *index;
    if (currentPlayer == 1) {
        for (int i = 0; i<indexArray.count; i++) {
            index = [indexArray objectAtIndex:i];
            p1Points[[index integerValue]] = @([p1Points[[index integerValue]] integerValue] + 1);
        }
    }else {
        for (int i = 0; i<indexArray.count; i++) {
            index = [indexArray objectAtIndex:i];
            p2Points[[index integerValue]] = @([p2Points[[index integerValue]] integerValue] + 1);
        }
    }
}


-(void) updateBoard:(UIButton *)sender {
    
    if (currentPlayer == 1) {
        [sender setImage:tealImg forState:UIControlStateNormal];
        self.currentPlayerLabel.text = @"player 2";
        currentPlayer = 2;
    }else {
        [sender setImage:blueImg forState:UIControlStateNormal];
        self.currentPlayerLabel.text = @"player 1";
        currentPlayer = 1;
    }
    NSString *winner = [self checkForWinner];
    if ([winner isEqualToString:@"player 1"] || [winner isEqualToString:@"player 2"]) {
        [self resetBoard:winner];
    }
}

-(void) resetBoard:(NSString *) winner{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"You Won!" message:[NSString stringWithFormat:@"Congratulations %@!", winner] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *restartGame = [UIAlertAction actionWithTitle:@"restart" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [b1 setImage:orangeImg forState:UIControlStateNormal];
        [b2 setImage:orangeImg forState:UIControlStateNormal];
        [b3 setImage:orangeImg forState:UIControlStateNormal];
        [b4 setImage:orangeImg forState:UIControlStateNormal];
        [b5 setImage:orangeImg forState:UIControlStateNormal];
        [b6 setImage:orangeImg forState:UIControlStateNormal];
        [b7 setImage:orangeImg forState:UIControlStateNormal];
        [b8 setImage:orangeImg forState:UIControlStateNormal];
        [b9 setImage:orangeImg forState:UIControlStateNormal];
        for (int i=0; i<p1Points.count; i++) {
            [p1Points replaceObjectAtIndex:i withObject:@0];
            [p2Points replaceObjectAtIndex:i withObject:@0];
        }
    }];
    
    [alertController addAction:restartGame];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(NSString *)checkForWinner{
    NSString *winner = [NSString new];
    if ([p1Points containsObject:@3]) {
        winner = @"player 1";
    }else if ([p2Points containsObject:@3]) {
        winner = @"player 2";
    }
    
    return winner;
}

@end
