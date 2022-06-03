is_category(C):-
	word(_,C).

categories(L):-
    setof(List,is_category(List),L).

available_length(L):-
    word(Tmp,_),
    string_chars(Tmp,Tmp2),
    length(Tmp2,M),
    M = L,!.

pick_word(W,L,C):-
    word(Tmp,C),
    string_chars(Tmp,Tmp2),
    length(Tmp2,L),
    W = Tmp.

correct_letters(L1,L2,R) :- correct_letters_helper(L2,L1,[],R).
correct_letters_helper([],_,R,R).
correct_letters_helper([H|T],L,Acc,R):- member(H,L), append(Acc,[H],NewAcc), correct_letters_helper(T,L,NewAcc,R).
correct_letters_helper([H|T],L,Acc,R):- \+member(H,L), correct_letters_helper(T,L,Acc,R).

correct_positions([],[],[]).    
correct_positions([H|T],[H|T2],R):-  R = [H|T3], correct_positions(T,T2,T3).
correct_positions([H|T],[H2|T2],R):-  H\=H2,correct_positions(T,T2,R).

build_kb():-
write('Please enter a word and its category on separate lines:'),nl,
read(X), ( X=done; read(Y), assert(word(X,Y)), build_kb()).
main:-
write('Welcome to Pro-Wordle!'),nl,write('--------------------------------'),nl,
build_kb(),
write('Done building the words database...'),nl,
play.

play():-
    categories(L),
    write("The available categories are: "),
    write(L),nl,
    write("Choose a category:" ),nl,
    choose_a_category(C),
    write("Choose a length: "),nl,
    choose_a_length(Le,C),
    Le2 is Le+1,
    write("Game started. You have "),write(Le2),write(" guesses."),nl,
    pick_word(W,Le,C),helper(W,Le2,Le).
helper(W,Guesses,Len):-
	((write('Enter a word composed of '),write(Len),write(' letters : '),nl,
	read(In),string_chars(W,WL),string_chars(In,InL),
	length(InL,X),((X\=Len,
	write('Word is not composed of '),write(Len),write(' letters. Try again.'),nl,write('Remaining Guesses are '),write(Guesses),helper(W,Guesses,Len));(X=Len,
	correct_letters(InL,WL,Res),
	correct_positions(InL,WL,Res2),
	((length(Res2,X),X=Len,write('You Won!'),nl,!);
((Guesses==1,write('You Lost'),nl);(write('Correct letters are: '),write(Res),nl,write('Correct letters in correct positions are: '),

write(Res2),nl,Nguess is Guesses-1 ,write('Remaining Guesses are '),write(Nguess),nl,helper(W,Nguess,Len))


)))))).

choose_a_category(X):-
    read(Y),
    ((is_category(Y),X=Y);(\+is_category(Y)),write("This category does not exist."),nl,write("Choose a category:"),nl,choose_a_category(X)).
    
choose_a_length(Le,C):-
    read(Y),
    ((available_length(Y),choose_a_length_helper(Y,C),Le=Y);(\+choose_a_length_helper(Y,C),write("There are no words of this length."),nl,write("Choose a length:"),nl,choose_a_length(Le,C))).
choose_a_length_helper(Y,C):-
    word(Tmp,C),
    string_to_list(Tmp,Tmp2),
    length(Tmp2,Y).
    

