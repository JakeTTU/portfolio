xaxis(1..17).
yaxis(1..22).
action(move_n).
action(move_s).
action(move_w).
action(move_e).
action(move_nw).
action(move_ne).
action(move_sw).
action(move_se).
event(s_move_n).
event(s_move_s).
event(s_move_w).
event(s_move_e).
event(s_move_nw).
event(s_move_ne).
event(s_move_sw).
event(s_move_se).
event(moving).

%step(0..75).


% w/e paths
path(X1,Y,X2,Y) :- xaxis(X1), xaxis(X2), yaxis(Y), X1-X2 <= 1, X1-X2 >= -1, X1 != X2, not wall(X1,Y,X2,Y).
% n/s paths
path(X,Y1,X,Y2) :- xaxis(X), yaxis(Y1), yaxis(Y2), Y1-Y2 <= 1, Y2-Y1 >= -1, Y1 != Y2, not wall(X,Y1,X,Y2).
% nw paths
path(X1,Y1,X2,Y2) :- xaxis(X1), xaxis(X2), yaxis(Y1), yaxis(Y2), Y1-Y2 == -1, X1-X2 == 1, not wall(X1,Y1,X1-1,Y1), not wall(X1,Y1,X1,Y1+1), not wall(X2,Y2,X2+1,Y2), not wall(X2,Y2,X2,Y2-1), xaxis(X1-1), xaxis(X2+1), yaxis(Y1+1), yaxis(Y2-1). 
% ne paths
path(X1,Y1,X2,Y2) :- xaxis(X1), xaxis(X2), yaxis(Y1), yaxis(Y2), Y1-Y2 == -1, X1-X2 == -1, not wall(X1,Y1,X1+1,Y1), not wall(X1,Y1,X1,Y1+1), not wall(X2,Y2,X2-1,Y2), not wall(X2,Y2,X2,Y2-1), xaxis(X1+1), xaxis(X2-1), yaxis(Y1+1), yaxis(Y2-1).
% sw paths
path(X1,Y1,X2,Y2) :- xaxis(X1), xaxis(X2), yaxis(Y1), yaxis(Y2), Y1-Y2 == 1, X1-X2 == 1, not wall(X1,Y1,X1-1,Y1), not wall(X1,Y1,X1,Y1-1), not wall(X2,Y2,X2+1,Y2), not wall(X2,Y2,X2,Y2+1), xaxis(X1-1), xaxis(X2+1), yaxis(Y1-1), yaxis(Y2+1). 
% se paths
path(X1,Y1,X2,Y2) :- xaxis(X1), xaxis(X2), yaxis(Y1), yaxis(Y2), Y1-Y2 == 1, X1-X2 == -1, not wall(X1,Y1,X1+1,Y1), not wall(X1,Y1,X1,Y1-1), not wall(X2,Y2,X2-1,Y2), not wall(X2,Y2,X2,Y2+1), xaxis(X1+1), xaxis(X2-1), yaxis(Y1-1), yaxis(Y2+1).


wall(X1,Y,X2,Y) :- wall(X2,Y,X1,Y), xaxis(X1), xaxis(X2), yaxis(Y). 
wall(X,Y1,X,Y2) :- wall(X,Y2,X,Y1), xaxis(X), yaxis(Y1), yaxis(Y2).


%holds(at(X,Y+1), T+1) :- occurs(move_n,T), holds(at(X,Y), T), path(X,Y,X,Y+1), not fire(X,Y+1), step(T), step(T+1), xaxis(X), yaxis(Y), yaxis(Y+1). 
%holds(at(X,Y-1), T+1) :- occurs(move_s, T), holds(at(X,Y), T), path(X,Y,X,Y-1), not fire(X,Y-1), step(T), step(T+1), xaxis(X), yaxis(Y), yaxis(Y-1).
%holds(at(X+1,Y), T+1) :- occurs(move_e, T), holds(at(X,Y), T), path(X,Y,X+1,Y), not fire(X+1,Y), step(T), step(T+1), xaxis(X), xaxis(X+1), yaxis(Y).
%holds(at(X-1,Y), T+1) :- occurs(move_w, T), holds(at(X,Y), T), path(X,Y,X-1,Y), not fire(X-1,Y), step(T), step(T+1), xaxis(X), xaxis(X-1), yaxis(Y).
%holds(at(X-1,Y+1), T+1) :- occurs(move_nw, T), holds(at(X,Y), T), path(X,Y,X-1,Y+1), not fire(X-1,Y), not fire(X,Y+1), not fire(X-1,Y+1), step(T), step(T+1), xaxis(X), yaxis(Y), xaxis(X-1), yaxis(Y+1).
%holds(at(X+1,Y+1), T+1) :- occurs(move_ne, T), holds(at(X,Y), T), path(X,Y,X+1,Y+1), not fire(X+1,Y), not fire(X,Y+1), not fire(X+1,Y+1), step(T), step(T+1), xaxis(X), yaxis(Y), xaxis(X+1), yaxis(Y+1).
%holds(at(X-1,Y-1), T+1) :- occurs(move_sw, T), holds(at(X,Y), T), path(X,Y,X-1,Y-1), not fire(X-1,Y), not fire(X,Y-1), not fire(X-1,Y-1), step(T), step(T+1), xaxis(X), yaxis(Y), xaxis(X-1), yaxis(Y-1).
%holds(at(X+1,Y-1), T+1) :- occurs(move_se, T), holds(at(X,Y), T), path(X,Y,X+1,Y-1), not fire(X+1,Y), not fire(X,Y-1), not fire(X+1,Y-1), step(T), step(T+1), xaxis(X), yaxis(Y), xaxis(X+1), yaxis(Y-1).

%holds(at(X,Y), T+1) :- holds(at(X,Y), T), not -holds(at(X,Y), T+1), step(T), step(T+1).
%-holds(at(X,Y), T+1) :- -holds(at(X,Y), T), not holds(at(X,Y), T+1), step(T), step(T+1).


occurs(moving, T+1) :- occurs(move_nw, T), step(T), step(T+1).
occurs(moving, T+1) :- occurs(move_ne, T), step(T), step(T+1).
occurs(moving, T+1) :- occurs(move_sw, T), step(T), step(T+1).
occurs(moving, T+1) :- occurs(move_se, T), step(T), step(T+1).

occurs(s_move_nw, T+2) :- occurs(move_nw,T), step(T), step(T+2).
occurs(s_move_ne, T+2) :- occurs(move_ne,T), step(T), step(T+2).
occurs(s_move_sw, T+2) :- occurs(move_sw,T), step(T), step(T+2).
occurs(s_move_se, T+2) :- occurs(move_se,T), step(T), step(T+2).

occurs(s_move_n, T+1) :- occurs(move_n, T), step(T), step(T+1).
occurs(s_move_s, T+1) :- occurs(move_s, T), step(T), step(T+1).
occurs(s_move_w, T+1) :- occurs(move_w, T), step(T), step(T+1).
occurs(s_move_e, T+1) :- occurs(move_e, T), step(T), step(T+1).

holds(at(X,Y+1), T+2) :- occurs(move_n, T), holds(at(X,Y), T), path(X,Y,X,Y+1), not fire(X,Y+1), step(T), step(T+1), step(T+2), xaxis(X), yaxis(Y), yaxis(Y+1).
holds(at(X,Y-1), T+2) :- occurs(move_s, T), holds(at(X,Y), T), path(X,Y,X,Y-1), not fire(X,Y-1), step(T), step(T+1), step(T+2), xaxis(X), yaxis(Y), yaxis(Y-1).
holds(at(X-1,Y), T+2) :- occurs(move_w, T), holds(at(X,Y), T), path(X,Y,X-1,Y), not fire(X-1,Y), step(T), step(T+1), step(T+2), xaxis(X), xaxis(X+1), yaxis(Y).
holds(at(X+1,Y), T+2) :- occurs(move_e, T), holds(at(X,Y), T), path(X,Y,X+1,Y), not fire(X+1,Y), step(T), step(T+1), step(T+2), xaxis(X), xaxis(X-1), yaxis(Y).

holds(at(X-1,Y+1), T+3) :- occurs(move_nw,T), holds(at(X,Y), T), path(X,Y,X-1,Y+1), not fire(X-1,Y), not fire(X,Y+1), not fire(X-1,Y+1), step(T), step(T+1), step(T+2), step(T+3), xaxis(X), yaxis(Y), xaxis(X-1), yaxis(Y+1).
holds(at(X+1,Y+1), T+3) :- occurs(move_ne,T), holds(at(X,Y), T), path(X,Y,X+1,Y+1), not fire(X+1,Y), not fire(X,Y+1), not fire(X+1,Y+1), step(T), step(T+1), step(T+2), step(T+3), xaxis(X), yaxis(Y), xaxis(X+1), yaxis(Y+1).
holds(at(X-1,Y-1), T+3) :- occurs(move_sw,T), holds(at(X,Y), T), path(X,Y,X-1,Y-1), not fire(X-1,Y), not fire(X,Y-1), not fire(X-1,Y-1), step(T), step(T+1), step(T+2), step(T+3), xaxis(X), yaxis(Y), xaxis(X-1), yaxis(Y-1).
holds(at(X+1,Y-1), T+3) :- occurs(move_se,T), holds(at(X,Y), T), path(X,Y,X+1,Y-1), not fire(X+1,Y), not fire(X,Y-1), not fire(X+1,Y-1), step(T), step(T+1), step(T+2), step(T+3), xaxis(X), yaxis(Y), xaxis(X+1), yaxis(Y-1).

%holds(at(X,Y),T) :- not holds(at(X1,Y),T), X != X1, xaxis(X), xaxis(X1), yaxis(Y), step(T).
%holds(at(X,Y),T) :- not holds(at(X,Y1),T), Y != Y1, xaxis(X), yaxis(Y), yaxis(Y1), step(T).


goal(T) :- holds(at(8,1), T), step(T).
goal(T) :- holds(at(17,15), T), step(T).
goal(T) :- holds(at(12,18), T), step(T).
goal(T) :- holds(at(11,21), T), step(T).
success :- goal(T), step(T).
:- not success.
%1{occurs(A,T): action(A)}1 :- step(T), not goal(T).
1{occurs(A,T): action(A)}1 :- step(T), not goal(T), not occurs(E,T), event(E).


stand((X,0,Y,0),T) :- holds(at(X,Y),T), X<10, Y<10, xaxis(X), yaxis(Y), step(T).
stand((X,0,Y-10,1),T) :- holds(at(X,Y),T), X<10, Y>9, Y<20, xaxis(X), yaxis(Y), step(T).
stand((X,0,Y-20,2),T) :- holds(at(X,Y),T), X<10, Y>19, Y<23, xaxis(X), yaxis(Y), step(T).

stand((X-10,1,Y,0),T) :- holds(at(X,Y),T), X>9, X<18, Y<10, xaxis(X), yaxis(Y), step(T).
stand((X-10,1,Y-10,1),T) :- holds(at(X,Y),T), X>9, X<18, Y>9, Y<20, xaxis(X), yaxis(Y), step(T).
stand((X-10,1,Y-20,2),T) :- holds(at(X,Y),T), X>9, X<18, Y>19, Y<23, xaxis(X), yaxis(Y), step(T).



wall(1,4..21,2,4..21).
wall(2,2..3,3,2..3).
wall(2,18..19,3,18..19).
wall(2,21,3,21).
wall(3,7..8,4,7..8).
wall(3,10..12,4,10..12).
wall(5,3,6,3).
wall(5,9,6,9).
wall(6,3,7,3).
wall(8,18,9,18).
wall(8,20,9,20).
wall(9,2..3,10,2..3).
wall(9,14,10,14).
wall(10,18..20,11,18..20).
wall(11,2..3,12,2..3).
wall(12,7..8,13,7..8).
wall(12,10..12,13,10..12).
wall(13,2..3,14,2..3).
wall(14,4..14,15,4..14).
wall(14,16..17,15,16..17).
wall(16,13..14,17,13..14).
wall(16,16..17,17,16..17).
wall(3..7,1,3..7,2).
wall(9..13,1,9..13,2).
wall(3..5,2,3..5,3).
wall(2..7,3,2..7,4).
wall(9,3,9,4).
wall(11..12,3,11..12,4).
wall(14,3,14,4).
wall(4..12,5,4..12,6).
wall(4..12,8,4..12,9).
wall(4..12,9,4..12,10).
wall(15..16,12,15..16,13).
wall(4..12,13,4..12,14).
wall(16,14,16,15).
wall(16,15,16,16).
wall(3..11,17,3..11,18).
wall(13..16,17,13..16,18).
wall(9..10,19,9..10,20).
wall(2..10,21,2..10,22).

%holds(at(14,8),0).
fire(1,1).


%#show path/4.
%#show at/2.
#show stand/2.
%#show holds/2.
%#show occurs/2.