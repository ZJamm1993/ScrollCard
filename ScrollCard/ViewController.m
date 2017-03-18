//
//  ViewController.m
//  ScrollCard
//
//  Created by jam on 17/3/17.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "ViewController.h"

const NSInteger myTag=100;
const CGFloat minScale=0.7;

@interface ViewController ()<UIScrollViewDelegate>
{
    UIScrollView* _scrollView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, 320, 320)];
    _scrollView.delegate=self;
    _scrollView.pagingEnabled=YES;
    _scrollView.backgroundColor=[UIColor grayColor];
    
    int count=20;
    for (int i=0; i<count; i++) {
        UIImageView* vi=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width*0.6, _scrollView.frame.size.height*0.7)];
        vi.tag=myTag;
        vi.backgroundColor=[UIColor colorWithHue:(arc4random()%255)/255.0 saturation:1 brightness:1 alpha:1];
        [_scrollView addSubview:vi];
        vi.layer.borderColor=vi.backgroundColor.CGColor;
        vi.layer.borderWidth=1;
        vi.image=[UIImage imageNamed:@"stig.jpg"];
        
        UIView* cen=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
        cen.backgroundColor=[UIColor blackColor];
        cen.center=CGPointMake(vi.frame.size.width/2, vi.frame.size.height/2);
        [vi addSubview:cen];
        
//        UIView* imgV=[[UIView alloc]initWithFrame:CGRectMake(10, 10, 100, 100)];
//        imgV.backgroundColor=[UIColor blueColor];
//        [vi addSubview:imgV];
//        
        UILabel* lab=[[UILabel alloc]initWithFrame:CGRectMake(120, 10, 100, 20)];
        lab.backgroundColor=[vi backgroundColor];
        lab.text=[NSString stringWithFormat:@"%d",(int)i];
        [vi addSubview:lab];
    }
    
    [_scrollView setContentSize:CGSizeMake(count*_scrollView.frame.size.width, _scrollView.frame.size.height)];
    
    [self.view addSubview:_scrollView];
    [self scrollViewDidScroll:_scrollView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{    
    CGFloat offX=scrollView.contentOffset.x;
    CGFloat halfW=0.5*scrollView.frame.size.width;
    NSInteger numberOfPage=(offX+halfW)/scrollView.frame.size.width;
    CGFloat offCenterX=offX+halfW;
    
    CGFloat distance=0.55*scrollView.frame.size.width;
    
    NSArray* subViews=scrollView.subviews;
    NSMutableArray* views10=[NSMutableArray array];
    
    for (UIView* vi in subViews) {
        if (vi.tag==myTag) {
            [views10 addObject:vi];
        }
    }
    for (UIView* vi in views10) {
        vi.center=CGPointMake(-1000,-1000);
    }
    
    UIView* centerView=(numberOfPage<0||numberOfPage>views10.count-1)?nil:[views10 objectAtIndex:numberOfPage];
    UIView* leftView=(numberOfPage-1<0)?nil:[views10 objectAtIndex:numberOfPage-1];
    UIView* rightView=(numberOfPage+1>=views10.count)?nil:[views10 objectAtIndex:numberOfPage+1];
    
    CGFloat contentCenterX=numberOfPage*scrollView.frame.size.width+halfW;
    
    CGFloat newContentCenterX=offCenterX-((offCenterX-contentCenterX)*(distance/scrollView.frame.size.width));
    
    CGFloat centerY=scrollView.frame.size.height/2;
    
    centerView.center=CGPointMake(newContentCenterX, centerY);
    leftView.center=CGPointMake(newContentCenterX-distance, centerY);
    rightView.center=CGPointMake(newContentCenterX+distance, centerY);
    
    for (UIView* vi in views10) {
        if (vi==centerView||vi==leftView||vi==rightView) {
            CGFloat scale=minScale;
            CGFloat hw=distance;
            CGFloat dx=fabs(vi.center.x-offCenterX);
            CGFloat rate=dx/hw;
            scale=1.0-(1-scale)*rate;
            CGAffineTransform transform=CGAffineTransformMakeScale(scale, scale);
            vi.transform=transform;
        }
    }
}

@end
