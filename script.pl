cuvinte_valide(Lista,Cuvinte):-
    cuvant_valid(Lista,[],Cuvinte).

cuvant_valid([], Cuvinte,Cuvinte).
cuvant_valid([P | Permutari],CuvintePartiale,Cuvinte) :-
    verificare_despartire_corecta(P,Cuvant),
    append(CuvintePartiale,[Cuvant],New),
    cuvant_valid(Permutari,New,Cuvinte).
cuvant_valid([_ | Permutari],CuvintePartiale,Cuvinte) :-
    cuvant_valid(Permutari,CuvintePartiale,Cuvinte).

permutare_lista_silabe(Lista, Cuvinte) :-
    findall(Perm, permutation(Lista, Perm), Permutari),
    cuvinte_valide(Permutari,Cuvinte), !.

verificare_despartire_corecta(Lista, Cuvant) :-
    concateneaza_elemente(Lista, Cuvant),
    desparte_in_silabe(Cuvant, Silabe),
    Silabe==Lista.

concateneaza_elemente([], '').
concateneaza_elemente([Lista | Restul], Cuvant) :-
    concateneaza_elemente(Restul, RestulCuvant),
    atomic_list_concat(Lista, Atom),
    atomic_list_concat([Atom, RestulCuvant], Cuvant).
desparte_in_silabe(Cuvant, Silabe) :-
    atom_chars(Cuvant, Litere),
    desparte_silabe(Litere, [], Silabe), !.

desparte_silabe([], [], []) :- !.
desparte_silabe([], Acc, [Acc]) :- !.
%regula 1: o consoana intre 2 vocale
desparte_silabe([V1, C, V2 | Litere], Acc, Silabe) :-
    este_vocala(V1),
    este_consoana(C),
    este_vocala(V2),
    append(Acc, [V1], Acc1),
    desparte_silabe([C,V2 | Litere], [], RestSilabe),
    append([Acc1], RestSilabe, Silabe).
%grupul gh,ch urmat de "e" sau "i"
desparte_silabe([V1, C1, C2, V2 | Litere], Acc, Silabe) :-
    este_vocala(V1),
    este_grup(C1,C2),
    este_vocala_grup(V2),
    append(Acc, [V1], Acc1),
    desparte_silabe([C1,C2,V2 | Litere], [], RestSilabe),
    append([Acc1], RestSilabe, Silabe).
%regula 2: 2 consoane intre 2 vocale
%exceptie cand merg in a doua silaba
desparte_silabe([V1, C1, C2, V2 | Litere], Acc, Silabe) :-
    este_vocala(V1),
    este_grup_consoane(C1,C2),
    este_vocala(V2),
    append(Acc, [V1], Acc1),
    desparte_silabe([C1,C2,V2 | Litere], [], RestSilabe),
    append([Acc1], RestSilabe, Silabe).
%cazul cand merg in silabe separate
desparte_silabe([V1, C1, C2, V2 | Litere], Acc, Silabe) :-
    este_vocala(V1),
    este_consoana(C1),
    este_consoana(C2),
    este_vocala(V2),
    append(Acc, [V1,C1], Acc1),
    desparte_silabe([C2,V2 | Litere], [], RestSilabe),
    append([Acc1], RestSilabe, Silabe).
%grupul ch, gh
desparte_silabe([V1, C1, C2, C3, V2 | Litere], Acc, Silabe) :-
    este_vocala(V1),
    este_consoana(C1),
    este_grup(C2,C3),
    este_vocala_grup(V2),
    append(Acc, [V1,C1], Acc1),
    desparte_silabe([C2,C3,V2 | Litere], [], RestSilabe),
    append([Acc1], RestSilabe, Silabe).

% exceptie regula3
desparte_silabe([V1, C1,C2,C3, V2 | Litere], Acc, Silabe) :-
    este_vocala(V1),
    este_grup_consoane_regula3(C1,C2,C3),
    este_vocala(V2),
    append(Acc, [V1,C1,C2], Acc1),
    desparte_silabe([C3,V2 | Litere], [], RestSilabe),
    append([Acc1], RestSilabe, Silabe).

% trei consoane intre doua vocale -> vocala-con + con, con, vocala
desparte_silabe([V1, C1,C2,C3, V2 | Litere], Acc, Silabe) :-
    este_vocala(V1),
    este_consoana(C1),
    este_consoana(C2),
    este_consoana(C3),
    este_vocala(V2),
    append(Acc, [V1,C1], Acc1),
    desparte_silabe([C2,C3,V2 | Litere], [], RestSilabe),
    append([Acc1], RestSilabe, Silabe).


% patru consoane intre doua vocale -> vocala-con + con, con, vocala
desparte_silabe([V1,C1,C2,C3,C4, V2 | Litere], Acc, Silabe) :-
    este_vocala(V1),
    este_consoana(C1),
    este_consoana(C2),
    este_consoana(C3),
    este_consoana(C4),
    este_vocala(V2),
    append(Acc, [V1,C1], Acc1),
    desparte_silabe([C2,C3,C4,V2 | Litere], [], RestSilabe),
    append([Acc1], RestSilabe, Silabe).
%diftong triftong
desparte_silabe([V1, V2, V3, V4 | Litere], Acc, Silabe) :-
    este_vocala(V1),
    este_triftong(V2,V3,V4),
    append(Acc, [V1], Acc1),
    desparte_silabe([V2,V3,V4 | Litere], [], RestSilabe),
    append([Acc1], RestSilabe, Silabe).
desparte_silabe([V1, V2, V3 | Litere], Acc, Silabe) :-
    not(este_triftong(V1,V2,V3)),
    este_vocala(V1),
    este_diftong(V2,V3),
    append(Acc, [V1], Acc1),
    desparte_silabe([V2,V3 | Litere], [], RestSilabe),
    append([Acc1], RestSilabe, Silabe).


desparte_silabe([L | Litere], Acc, Silabe) :-
    append(Acc, [L], Acc1),
    desparte_silabe(Litere, Acc1, Silabe).

este_consoana(L) :-
    member(L, ['b', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm', 'n',
              'p', 'q', 'r', 's', 'ș', 't', 'ț', 'v', 'w', 'x', 'y', 'z']).
este_vocala(V) :-
    not(este_consoana(V)).

este_grup(C1,C2) :-
    member(C1, ['c','g']),
    member(C2, ['h']).
este_vocala_grup(V2) :-
    member(V2, ['e','i']).
%exceptie regula 2
este_grup_consoane(C1,C2) :-
    member(C1, ['b', 'c', 'd', 'f', 'g', 'h', 'p', 't', 'v']),
    member(C2, ['l', 'r']).
este_grup_consoane_regula3(C1,C2,C3) :-
    member([C1,C2,C3], [['l', 'p', 't'],['m','p','t'],['m','p','ț'], ['n','c','t'],['n','d','v'],['r','c','t'],['r','t','f'],['s','t','m'],['n', 'c', 'ț'],['n','c', 'ș']]).
este_diftong(V1, V2) :-
    member([V1, V2], [['a', 'i'], ['a', 'u'], ['e', 'a'], ['e', 'i'],
                         ['e', 'u'], ['i', 'a'], ['i', 'e'], ['i', 'u'],['i','o'],
                         ['o', 'i'], ['u', 'a'], ['u', 'e'], ['u', 'i']]).

este_triftong(V1, V2, V3) :-
    member([V1, V2, V3], [['a', 'i', 'e'], ['a', 'i', 'u'], ['e', 'a', 'i'],
                             ['e', 'a', 'u'], ['e', 'i', 'a'], ['e', 'i', 'u'],
                             ['i', 'a', 'i'], ['i', 'a', 'u'], ['i', 'e', 'a'],
                             ['i', 'e', 'u'], ['i', 'u', 'a'], ['i', 'u', 'e'],
                             ['o', 'a', 'i'], ['o', 'a', 'u'], ['u', 'a', 'i']]).
