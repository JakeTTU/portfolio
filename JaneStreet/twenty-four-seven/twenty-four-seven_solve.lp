%Copyright © 2023 Jake Gonzalez. All rights reserved.
%https://www.janestreet.com/puzzles/twenty-four-seven-index/

pos(1,2,2).
pos(1,3,4).
pos(2,3,7).
pos(2,7,4).
pos(3,6,6).
pos(4,2,7).
pos(4,4,4).
pos(4,6,3).
pos(5,2,4).
pos(6,1,1).
pos(6,5,5).
pos(7,5,5).
pos(7,6,6).
    
num(0..7).
ok_num(1..7).
size(1..7).
grid(1..7, 1..7).

%choose value for each grid cell
1{pos(X,Y,N): num(N)}1 :- grid(X,Y).

%init columns sum to zero    
col_sum(X,0,0) :- size(X).

%column sum at row 1 equals value at row 1 for the column     
col_sum(X,1,N) :- pos(X,1,N), size(X).

%column sum at row Y equals value at row Y plus value at row Y-1 for the column         
col_sum(X,Y,S+N) :- col_sum(X,Y-1,S), pos(X,Y,N).

%column sum must equal 20        
:- col_sum(X,Y,S), S>20, size(X), size(Y).
:- col_sum(X,7,S), S<20, size(X), size(Y).
    
%same summation rule for rows  
row_sum(0,Y,0) :- size(Y).
row_sum(1,Y,N) :- pos(1,Y,N), size(Y).
row_sum(X,Y,S+N) :- row_sum(X-1,Y,S), pos(X,Y,N).
:- row_sum(X,Y,S), S>20, size(Y), size(X).
:- row_sum(7,Y,S), S<20, size(Y).
    
%can only use 4 numbers from 1..7 for each col
col_num_used(X,0,0) :- size(X).
col_num_used(X,Y,S) :- col_num_used(X,Y-1,S), pos(X,Y,0).
col_num_used(X,Y,S+1) :- col_num_used(X,Y-1,S), pos(X,Y,N), ok_num(N).
:- col_num_used(X,7,S), S<4, size(X).
:- col_num_used(X,Y,S), S>4, size(X), size(Y).

%can only use 4 numbers from 1..7 for each row
row_num_used(0,Y,0) :- size(Y).
row_num_used(X,Y,S) :- row_num_used(X-1,Y,S), pos(X,Y,0).
row_num_used(X,Y,S+1) :- row_num_used(X-1,Y,S), pos(X,Y,N), ok_num(N).
:- row_num_used(7,Y,S), S<4, size(Y).
:- row_num_used(X,Y,S), S>4, size(X), size(Y).
    
num_totals(0, Y, N, 0) :- num(N), size(Y).
num_totals(X, Y, N, S+1) :- num_totals(X-1, Y, N, S), pos(X,Y,N), num(N), size(Y), size(X).
num_totals(X, Y, N, S) :- num_totals(X-1, Y, N, S), not pos(X,Y,N), num(N), size(Y), size(X).

t(8, Y, N, S) :- num_totals(7, Y, N, S), size(Y), ok_num(N).
t2(8, 0, N, 0) :- ok_num(N).
t2(8, Y, N, S+S2) :- t2(8, Y-1, N, S), t(8, Y, N, S2), ok_num(N), size(Y).  
:- t2(8,Y,N, S), S>N, size(Y).
:- t2(8,7,N, S), S<N.
    
c(X, Y, 1) :- pos(X-1,Y,N), ok_num(N), size(X), size(Y).
c(X, Y, 1) :- pos(X+1,Y,N), ok_num(N), size(X), size(Y).
c(X, Y, 1) :- pos(X,Y-1,N), ok_num(N), size(X), size(Y).
c(X, Y, 1) :- pos(X,Y+1,N), ok_num(N), size(X), size(Y).
     
n(X,Y) :- pos(X,Y,N), ok_num(N), grid(X,Y).

e(X1, Y1, X2, Y2) :- n(X1,Y1), n(X2, Y2), grid(X1,Y1), grid(X2,Y2), Y1 == Y2, X1 - X2 == 1.
e(X1, Y1, X2, Y2) :- n(X1,Y1), n(X2, Y2), grid(X1,Y1), grid(X2,Y2), Y1 == Y2, X1 - X2 == -1.
e(X1, Y1, X2, Y2) :- n(X1,Y1), n(X2, Y2), grid(X1,Y1), grid(X2,Y2), Y1 - Y2 == 1, X1 == X2.
e(X1, Y1, X2, Y2) :- n(X1,Y1), n(X2, Y2), grid(X1,Y1), grid(X2,Y2), Y1 - Y2 == 1, X1 == X2.
    
sub_grid(1..6, 1..6).

sub_grid_zero(X, Y, 1) :- pos(X,Y,0), sub_grid(X,Y).
sub_grid_zero(X, Y, 1) :- pos(X,Y+1,0), sub_grid(X,Y).
sub_grid_zero(X, Y, 1) :- pos(X+1,Y,0), sub_grid(X,Y).
sub_grid_zero(X, Y, 1) :- pos(X+1,Y+1,0), sub_grid(X,Y).
        
:- not sub_grid_zero(X, Y, 1), sub_grid(X,Y).

#show pos/3.
