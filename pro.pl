:-dynamic (cell/3).
:-dynamic (fxd_cell/3).
:-dynamic (vv/2).

fxd_cell(1,2,3).
fxd_cell(1,6,1).
fxd_cell(3,1,2).
fxd_cell(3,4,1).
fxd_cell(5,2,1).
fxd_cell(5,5,2).
fxd_cell(6,3,2).
fxd_cell(7,1,1).
fxd_cell(7,5,1).
fxd_cell(7,7,6).
/*ro delete all the dynamics for vv*/
clearvv():-retractall(vv(_,_)).
  /*initialize the gamex*/
startgame():-abolish(cell/3),clearvv(),nl,write('Game Started '),nl,assert(cell(1,2,g)),
assert(cell(1,6,g)),
assert(cell(3,1,g)),
assert(cell(3,4,g)),
assert(cell(5,2,g)),
assert(cell(5,5,g)),
assert(cell(6,3,g)),
assert(cell(7,1,g)),
assert(cell(7,5,g)),
assert(cell(7,7,g)),
not(printboard()),nl,nl,
userchoice().

/*loop 1->7*/
get_num(Num):-L=[1,2,3,4,5,6,7],member(Num,L).
/*loop 1->6*/
get_num2(Num):-L=[1,2,3,4,5,6],member(Num,L).


/*Print the Current Solution*/
printboard():-get_num(Row),nl,get_num(Col),
(cell(Row,Col,Color),not(fxd_cell(Row,Col,Num)),(Color='g',write('G ');Color='b',write('B ')),fail
;fxd_cell(Row,Col,Num),write(Num),write(' '),fail
;not(cell(Row,Col,Color)),not(fxd_cell(Row,Col,Num)),write('W '),fail).

/*Ask user to Enter cell or check  solution */
userchoice():-write('to enter new cell print y or else to check sol : '),read(X),X='y',!,entercell();X='n',not(colortheuncolored()),
checkdone().



entercell():-write('enter row , col and color of the cell :'),read(Row),read(Col),read(Color),not(fxd_cell(Row,Col,T)),!,retractall(cell(Row,Col,_)),assert(cell(Row,Col,Color)),write(' board '),nl,
not(printboard()),nl,
(not(check_all_colored()),write('all cells colored checking solution'),nl,checkdone(),!;write('the game is still alife : '),nl,userchoice())
;fxd_cell(Row,Col,T),write('you cant modify a fixed cell'),nl,userchoice().


/*checking every thing is done*/
checkdone():-retractall(vv(_,_)),write('verifying the solution : '),nl,
not(check_it()),retractall(vv(_,_)),
not(check_all_colored()),
checkwater(),
not(check_water_2()),
write('problame solved . '),nl,retractall(vv(_,_)),!,userchoice();write('wrong solution.'),nl,retractall(vv(_,_)),userchoice().

/* check each island cells = fixed cell value*/
check_it():-get_num(Row),get_num(Col),fxd_cell(Row,Col,Z),numberofgreencellswithoutfxdcells(Row,Col,Z1,Row,Col),clearvv(),numberofgreencellswithfxdcells(Row,Col,S),clearvv(),(Z=Z1,S=Z,fail;Z\=Z1,!).


/*counting green neighbors of a fixed cell*/
numberofgreencellswithoutfxdcells(Row,Col,S,X,Y):-cell(Row,Col,'g'),not(vv(Row,Col)),(fxd_cell(Row,Col,_),Row=X,Col=Y,!;fxd_cell(Row,Col,_),Row\=X,Col\=Y,fail,!;not(fxd_cell(Row,Col,_))),
assert(vv(Row,Col)),!,
Row1 is Row+1,numberofgreencellswithoutfxdcells(Row1,Col,S1,X,Y),
Row2 is Row-1,numberofgreencellswithoutfxdcells(Row2,Col,S2,X,Y),
Col1 is Col+1,numberofgreencellswithoutfxdcells(Row,Col1,S3,X,Y),
Col2 is Col-1,numberofgreencellswithoutfxdcells(Row,Col2,S4,X,Y),S is S1+S2+S3+S4+1;S is 0,!.

numberofgreencellswithfxdcells(Row,Col,S):-cell(Row,Col,'g'),
not(vv(Row,Col)),assert(vv(Row,Col)),!,
Row1 is Row+1,numberofgreencellswithfxdcells(Row1,Col,S1),
Row2 is Row-1,numberofgreencellswithfxdcells(Row2,Col,S2),
Col1 is Col+1,numberofgreencellswithfxdcells(Row,Col1,S3),
Col2 is Col-1,numberofgreencellswithfxdcells(Row,Col2,S4),S is S1+S2+S3+S4+1;S is 0,!.

/* Check if there is a lonely Water*/
checkwater():-get_num(Row),get_num(Col),cell(Row,Col,'b'),numberofwatercells(Row,Col,Numofdfs),retractall(vv(_,_)),findall(c(X,Y),cell(X,Y,'b'),L),length(L,Numofblue),Numofdfs=Numofblue,!;fail.

/*find number of neighbors water cell*/
numberofwatercells(Row,Col,N):-cell(Row,Col,'b'),not(vv(Row,Col)),!,assert(vv(Row,Col)),
Row1 is Row+1,numberofwatercells(Row1,Col,N1),
Row2 is Row-1,numberofwatercells(Row2,Col,N2),
Col1 is Col+1,numberofwatercells(Row,Col1,N3),
Col2 is Col-1,numberofwatercells(Row,Col2,N4),N is N1+N2+N3+N4+1;N is 0,!.


check_water_cell(X,Y):-cell(X,Y,g),!;X>7,!;X<1,!;Y>7,!;Y<1,!.
/*2x2*/
check_water_2():-  get_num2(Row),get_num2(Col),(cell(Row,Col,b);not(cell(Row,Col,T))),
    Row1 is Row+1,not( check_water_cell( Row1,Col)),
 Col1 is Col+1,  not(check_water_cell(Row,Col1)),
  not(check_water_cell(Row1,Col1)),!;fail.



/*check all cells Coloured*/
check_all_colored():- get_num(Row),get_num(Col),not(cell(Row,Col,T)),!;fail.



/*Make the uncoloured blue*/
colortheuncolored():-get_num(Row),get_num(Col),not(cell(Row,Col,T)),assert(cell(Row,Col,b)),fail;fail.

fixthistemp():-assert(cell(1,3,g)),assert(cell(1,4,g)),
assert(cell(3,2,g)),
assert(cell(5,4,g)),
assert(cell(7,3,g)),
assert(cell(3,7,g)),assert(cell(4,7,g)),assert(cell(5,7,g)),assert(cell(6,7,g)),
assert(cell(3,6,g)),colortheuncolored().

/*---------------------Computer startegies------------------*/

/*check done 2 return only true or false*/
checkdone2():-retractall(vv(_,_)),
not(check_it()),retractall(vv(_,_)),
not(check_all_colored()),
checkwater(),
not(check_water_2()),retractall(vv(_,_)).

/*first call all the computer startegyies then the backtrack*/
computerstrategy():-not(solvecellswithfixed1()),not(solveneighbourcells())
,not(solve2x2water()),not(surroundedbywater()),not(fxdcellsurroundedbywater()),
not(solve2x2water()),not(surroundedbywater()),
not(fxdcellsurroundedbywater()),not(findallthewhitecells()),
findall(c(R,C),cell(R,C,'w'),L),retractall(cell(_,_,'w')),backtrack(L).

/*get all the cells that ill backtrack for*/
findallthewhitecells():-get_num(Row),get_num(Col),not(cell(Row,Col,_)),assert(cell(Row,Col,'w')),fail;fail.

/*backtracking each cell insert green and then insert blue and */
backtrack([]):-checkdone2(),printboard().
backtrack([c(Row,Col)|Y]):-retractall(cell(Row,Col,_)),assert(cell(Row,Col,'g')),backtrack(Y),!;
retractall(cell(Row,Col,_)),assert(cell(Row,Col,'b')),backtrack(Y).

/* 1 cell*/
solvecellswithfixed1():-get_num(Row),get_num(Col),fxd_cell(Row,Col,1),
Row1 is Row+1,assert(cell(Row1,Col,b)),
Row2 is Row-1,assert(cell(Row2,Col,b)),
Col1 is Col+1,assert(cell(Row,Col1,b)),
Col2 is Col-1,assert(cell(Row,Col2,b)),fail;fail.


solveneighbourcells():-get_num(Row),get_num(Col),not(cell(Row,Col,_)),(
Row1 is Row+1,fxd_cell(Row1,Col,_),Row2 is Row-1,fxd_cell(Row2,Col,_);
Col1 is Col+1,fxd_cell(Row,Col1,_),Col2 is Col-1,fxd_cell(Row,Col2,_)),assert(cell(Row,Col,b)),fail;fail.


solve2x2water():-get_num(Row),get_num(Col),not(cell(Row,Col,_)),
 (Row1 is  Row-1,cell(Row1,Col,b),
 Col1 is Col+1,cell(Row1,Col1,b),
 cell(Row,Col1,b);
 Row1 is  Row-1,cell(Row1,Col,b),
 Col1 is Col-1,cell(Row1,Col1,b),
 cell(Row,Col1,b);
 Row1 is  Row+1,cell(Row1,Col,b),
 Col1 is Col+1,cell(Row1,Col1,b),
 cell(Row,Col1,b);
 Row1 is  Row+1,cell(Row1,Col,b),
 Col1 is Col-1,cell(Row1,Col1,b),
 cell(Row,Col1,b)),assert(cell(Row,Col,g)),fail;fail.

surroundedbywater():-get_num(Row),get_num(Col),not(cell(Row,Col,_)),(
Row1 is Row+1,cell(Row1,Col,b),
Row2 is Row-1,cell(Row2,Col,b),
Col1 is Col+1,cell(Row,Col1,b),
Col2 is Col-1,cell(Row,Col2,b)),assert(cell(Row,Col,b)),fail;fail.


fxdcellsurroundedbywater():-get_num(Row),get_num(Col),fxd_cell(Row,Col,T),T\=1,
(Row1 is  Row-1,cell(Row1,Col,b),
 Row2 is Row+1,cell(Row2,Col,b),
 Col1 is Col+1,cell(Row,Col1,b),Col2 is Col-1,assert(cell(Row,Col2,g));
 Row1 is  Row-1,cell(Row1,Col,b),
 Row2 is Row+1,cell(Row2,Col,b),
 Col1 is Col-1,cell(Row,Col1,b),Col2 is Col+1,assert(cell(Row,Col2,g));
 Col1 is  Col-1,cell(Row,Col1,b),
 Col2 is Col+1,cell(Row,Col2,b),
 Row1 is Row+1,cell(Row1,Col,b),Row2 is Row-1,assert(cell(Row2,Col,g));
 Col1 is  Col-1,cell(Row,Col1,b),
 Col2 is Col+1,cell(Row,Col2,b),
 Row1 is Row-1,cell(Row1,Col,b),Row2 is Row+1,assert(cell(Row2,Col,g))
),fail;fail.








