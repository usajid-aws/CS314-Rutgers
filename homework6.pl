% III
inside(joe, toy_dept).
report(X, Y, dept):- inside(X, dept), head(Y, dept).
head(sam, toy_dept).
less_salary(X, Y) :- report(X, Y, Z).
less_salary(joe, sam).

%IV
trib(0, 0).
trib(1,0).
trib(2, 1).
trib(N, T):- N>1, N1 is N-1, trib(N1, T1), N2 is N-2, trib(N2, T2), N3 is N-3, trib(N3, T3), T is T1+T2+T3.

%V
echo([],[]).
echo([X|T1],[X|T2]):- T2 = [X|T3], echo(T1,T3).

%VI
reverse([],A,A) :- !.  
reverse([A|Tail],B, C) :- reverse(Tail, [A|B], C).  
suppressEchos([],[]) :-!.  
suppressEchos(A,B) :- helper(A, [], B). 
helper([], A, B) :- reverse(A,B).  
helper([A | Tail],List, B) :-  
member(A,List),
helper(Tail, List, B),!.
helper([A | Tail],List, B) :-
helper(Tail,[A|List], B), !. 

