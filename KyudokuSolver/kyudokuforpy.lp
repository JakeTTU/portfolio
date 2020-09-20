%Copyright © 2019 Jake Gonzalez. All rights reserved.
num(1..9).
size(1..6).

%select a position for each num(1-9) if the value in that position (N) = num. 
1{sel(X,Y): pos(N,X,Y)}1 :- num(N).

%if first element in column is not selected, sum equals zero at position. 
column(X,1,0) :- not sel(X,1), size(X).

%if first element in column is selected, sum equals number in position.
column(X,1,N) :- sel(X,1), pos(N,X,1), size(X), num(N).

%if element is not selected, column sum for that position is equal to the sum up to the 
%previous element. 
column(X,Y,S) :- column(X,Y-1,S), not sel(X,Y), size(X), size(Y).

%if element is selected, column sum for that position is equal to the sum up to the
%previous element plus the number in selected position.
column(X,Y,S+N) :- column(X,Y-1,S), sel(X,Y), pos(N,X,Y), size(X), size(Y), num(N).

%if the sum of a column at a position is greater than nine, it cannot be in answer set. 
:- column(X,Y,S), S>9, size(X).

row(Y,1,0) :- not sel(1,Y), size(Y).
row(Y,1,N) :- sel(1,Y), pos(N,1,Y), size(Y), num(N).
row(Y,X,S) :- row(Y,X-1,S), not sel(X,Y), size(X), size(Y).
row(Y,X,S+N) :- row(Y,X-1,S), sel(X,Y), pos(N,X,Y), size(X), size(Y), num(N).
:- row(Y,X,S), S>9, size(Y).

#show sel/2.