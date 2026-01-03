#!/usr/bin/env opend run
module common.alpha_tiles;

/**
 * Core tile definitions for the baahouse project
 * Following the required format:
 * - alias output=bool; (for current alpha tiles)
 * - enum maxtiles=256; (defines functions in the set)
 * - Tiles defined in overload set with int value template specialization
 * - Coordinate system: (0,0) is top-left, (1,1) is bottom-right
 */

import std.math;

alias output=bool;
enum maxtiles=256;

// Basic tiles - starting with simple geometric patterns

output tile(int i:0)(float x,float y)=>true;//blank
output tile(int i:1)(float x,float y)=>false;//empty
output tile(int i:2)(float x,float y)=>x>0.5;//right half
output tile(int i:3)(float x,float y)=>x<0.5;//left half
output tile(int i:4)(float x,float y)=>y>0.5;//bottom half
output tile(int i:5)(float x,float y)=>y<0.5;//top half
output tile(int i:6)(float x,float y)=>x>y;//diagonal top-left to bottom-right
output tile(int i:7)(float x,float y)=>x+y>1.0;//diagonal bottom-left to top-right
output tile(int i:8)(float x,float y)=>x>0.5 && y>0.5;//bottom-right quadrant
output tile(int i:9)(float x,float y)=>x<0.5 && y<0.5;//top-left quadrant
output tile(int i:10)(float x,float y)=>x>0.5 && y<0.5;//top-right quadrant
output tile(int i:11)(float x,float y)=>x<0.5 && y>0.5;//bottom-left quadrant
output tile(int i:12)(float x,float y)=>abs(x-0.5)>0.25;//vertical strip (not center)
output tile(int i:13)(float x,float y)=>abs(y-0.5)>0.25;//horizontal strip (not center)
output tile(int i:14)(float x,float y)=>abs(x-0.5)<0.25;//vertical center strip
output tile(int i:15)(float x,float y)=>abs(y-0.5)<0.25;//horizontal center strip
output tile(int i:16)(float x,float y)=>(x-0.5)*(x-0.5)+(y-0.5)*(y-0.5)>0.25;//outside circle
output tile(int i:17)(float x,float y)=>(x-0.5)*(x-0.5)+(y-0.5)*(y-0.5)<0.25;//inside circle
output tile(int i:18)(float x,float y)=>abs(x-y)<0.1 || abs(x+y-1.0)<0.1;//diagonal cross
output tile(int i:19)(float x,float y)=>abs(x-0.5)<0.1 || abs(y-0.5)<0.1;//horizontal and vertical cross
output tile(int i:20)(float x,float y)=>(cast(int)(x*10)+cast(int)(y*10))%2==0;//checkerboard small

// Additional tiles for suggested 50 total

output tile(int i:21)(float x,float y)=>x>0.3 && x<0.7;//vertical center band
output tile(int i:22)(float x,float y)=>y>0.3 && y<0.7;//horizontal center band
output tile(int i:23)(float x,float y)=>abs(x-0.5)<0.1 && abs(y-0.5)<0.1;//center square
output tile(int i:24)(float x,float y)=>(x<0.1 || x>0.9) && (y<0.1 || y>0.9);//corner square
output tile(int i:25)(float x,float y)=>abs(x-y)<0.05;//thin diagonal
output tile(int i:26)(float x,float y)=>abs(x-(1-y))<0.05;//thin anti-diagonal
output tile(int i:27)(float x,float y)=>x>0.2 && x<0.8 && y>0.2 && y<0.8;//center rectangle
output tile(int i:28)(float x,float y)=>x<0.1 || x>0.9 || y<0.1 || y>0.9;//border
output tile(int i:29)(float x,float y)=>abs(x-0.5)*abs(y-0.5)<0.05;//center cross
output tile(int i:30)(float x,float y)=>abs((x-0.5)*2+(y-0.5)*2)<0.5;//diagonal band
output tile(int i:31)(float x,float y)=>abs((x-0.5)*2-(y-0.5)*2)<0.5;//anti-diagonal band
output tile(int i:32)(float x,float y)=>sin(PI*6*x)<0.0;//horizontal waves
output tile(int i:33)(float x,float y)=>sin(PI*6*y)<0.0;//vertical waves
output tile(int i:34)(float x,float y)=>sin(PI*6*x)*sin(PI*6*y)<0.0;//grid waves
output tile(int i:35)(float x,float y)=>abs(sin(PI*4*x))<0.5;//horizontal stripes
output tile(int i:36)(float x,float y)=>abs(sin(PI*4*y))<0.5;//vertical stripes
output tile(int i:37)(float x,float y)=>abs(sin(PI*4*x)*sin(PI*4*y))<0.25;//grid stripes
output tile(int i:38)(float x,float y)=>(x+y)<0.5;//upper left triangle
output tile(int i:39)(float x,float y)=>(x+y)>1.5;//lower right triangle
output tile(int i:40)(float x,float y)=>abs(x-0.5)+abs(y-0.5)<0.3;//diamond shape
output tile(int i:41)(float x,float y)=>abs(x-0.5)+abs(y-0.5)>0.7;//outside diamond
output tile(int i:42)(float x,float y)=>(x-0.5)*(y-0.5)<0.1;//saddle shape
output tile(int i:43)(float x,float y)=>(x-0.5)*(y-0.5)<0.0;//negative saddle
output tile(int i:44)(float x,float y)=>abs(x-0.5)<0.3 && abs(y-0.5)<0.1;//horizontal rectangle
output tile(int i:45)(float x,float y)=>abs(x-0.5)<0.1 && abs(y-0.5)<0.3;//vertical rectangle
output tile(int i:46)(float x,float y)=>abs(x-0.5)<0.3 || abs(y-0.5)<0.3;//cross shape
output tile(int i:47)(float x,float y)=>(cast(int)(x*5)+cast(int)(y*5))%2==0;//medium checkerboard
output tile(int i:48)(float x,float y)=>(cast(int)(x*20)+cast(int)(y*20))%2==0;//fine checkerboard
output tile(int i:49)(float x,float y)=>(cast(int)(x*3)+cast(int)(y*3))%2==0;//coarse checkerboard