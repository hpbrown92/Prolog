:- dynamic p/2.
:- dynamic p/3.
:- dynamic fact(1).
:- op(800,fx,if).
:- op(700,xfx,then).
:- op(300,xfy,or).
:- op(200,xfy,and).



% get probability of most likely disease;
% L is the list of symptoms;
% X is the probability
% -------
% EXAMPLE
% -------
% getmax([fev,swg,map,hda],X).
% X = 0.02367...
getmax(L, X) :- prob(chl,L,A), prob(gon,L,B), prob(hiv,L,C),
	       prob(gnh,L,D), prob(tri,L,E), max_member(X,[A,B,C,D,E]).



% assert the most likely disease;
% L is the list of symptoms;
% the second parameter should be a variable so that cases are tested
% until the correct disease (matching getmax()) is found
% -------
% EXAMPLE
% -------
% moli([fev,swg,map,hda],X).
% X = hiv
% ASSERTED: moliHIV.
moli(L, chlamydia) :- prob(chl,L,A), getmax(L,A), assert(fact(molichl)).
moli(L, gonorrhea) :- prob(gon,L,A), getmax(L,A), assert(fact(moligon)).
moli(L, hiv) :- prob(hiv,L,A), getmax(L,A), assert(fact(molihiv)).
moli(L, genital_herpes) :- prob(gnh,L,A), getmax(L,A), assert(fact(molignh)).
moli(L, trichomoniasis) :- prob(tri,L,A), getmax(L,A), assert(fact(molitri)).



% list probabilities of all diseases;
% L is the list of symptoms
listAll(L) :- prob(chl,L,A), prob(gon,L,B), prob(hiv,L,C),
	prob(gnh,L,D), prob(tri,L,E),
	write('chlamydia: \t\t'), write(A), nl,
	write('gonorrhea: \t\t'), write(B), nl,
	write('HIV: \t\t\t'), write(C), nl,
	write('genital herpes: \t'), write(D), nl,
	write('trichomoniasis: \t'), write(E), nl.



% creates list of symptoms;
% y/n is from user input;
% L1 is the prior list;
% L2 is the resulting list;
% start by calling addABP with the user response and [] for L1;
% first rule: adds symptom to list;
% second rule: adds nothing to list (fast for a handful of symptoms);
% third rule: adds not(symptom) to list (very slow)
addABP(y, L1, L2) :- append([abp],L1, L2), assert(fact(abp)).
addABP(n, L1, L2) :- L1 = L2, assert(fact(not(abp))).
addABP(n, L1, L2) :- append([not(abp)],L1,L2), assert(fact(not(abp))).

addFEV(y, L1, L2) :- append([fev],L1, L2), assert(fact(fev)).
addFEV(n, L1, L2) :- L1 = L2, assert(fact(not(fev))).
addFEV(n, L1, L2) :- append([not(fev)],L1,L2), assert(fact(not(fev))).

addPWU(y, L1, L2) :- append([pwu],L1, L2), assert(fact(pwu)).
addPWU(n, L1, L2) :- L1 = L2, assert(fact(not(pwu))).
addPWU(n, L1, L2) :- append([not(pwu)],L1,L2), assert(fact(not(pwu))).

addFRU(y, L1, L2) :- append([fru],L1, L2), assert(fact(fru)).
addFRU(n, L1, L2) :- L1 = L2, assert(fact(not(fru))).
addFRU(n, L1, L2) :- append([not(fru)],L1,L2), assert(fact(not(fru))).

addSWG(y, L1, L2) :- append([swg],L1, L2), assert(fact(swg)).
addSWG(n, L1, L2) :- L1 = L2, assert(fact(not(swg))).
addSWG(n, L1, L2) :- append([not(swg)],L1,L2), assert(fact(not(swg))).

addMAP(y, L1, L2) :- append([map],L1, L2), assert(fact(map)).
addMAP(n, L1, L2) :- L1 = L2, assert(fact(not(map))).
addMAP(n, L1, L2) :- append([not(map)],L1,L2), assert(fact(not(map))).

addHDA(y, L1, L2) :- append([hda],L1, L2), assert(fact(hda)).
addHDA(n, L1, L2) :- L1 = L2, assert(fact(not(hda))).
addHDA(n, L1, L2) :- append([not(hda)],L1,L2), assert(fact(not(hda))).

addACO(y, L1, L2) :- append([aco],L1, L2), assert(fact(aco)).
addACO(n, L1, L2) :- L1 = L2, assert(fact(not(aco))).
addACO(n, L1, L2) :- append([not(aco)],L1,L2), assert(fact(not(aco))).

addIGA(y, L1, L2) :- append([iga],L1, L2), assert(fact(iga)).
addIGA(n, L1, L2) :- L1 = L2, assert(fact(not(iga))).
addIGA(n, L1, L2) :- append([not(iga)],L1,L2), assert(fact(not(iga))).




% parents
parent(chl, abp).
parent(chl, fev).
parent(chl, pwu).
parent(gon, pwu).
parent(gon,fru).
parent(hiv, fev).
parent(hiv,swg).
parent(hiv, map).
parent(hiv, hda).
parent(gnh, fev).
parent(gnh, map).
parent(gnh, hda).
parent(tri, pwu).
parent(tri, aco).
parent(tri, iga).



% prior probabilities
p(chl,0.00136).
p(gon,0.00104).
p(hiv,0.00155).
p(tri,0.00108).
p(gnh,0.00163).



% conditional probability tables
p(abp,[chl],0.731).
p(abp,[not(chl)],0.616).
p(not(abp),[chl],0.269).
p(not(abp),[not(chl)],0.384).

p(fev,[chl,hiv,gnh],0.617).
p(fev,[chl,hiv,not(gnh)],0.604).
p(fev,[chl,not(hiv),gnh],0.553).
p(fev,[chl,not(hiv),not(gnh)],0.456).
p(fev,[not(chl),hiv,gnh],0.445).
p(fev,[not(chl),hiv,not(gnh)],0.376).
p(fev,[not(chl),not(hiv),gnh],0.154).
p(fev,[not(chl),not(hiv),not(gnh)],0.109).
p(not(fev),[chl,hiv,gnh],0.383).
p(not(fev),[chl,hiv,not(gnh)],0.396).
p(not(fev),[chl,not(hiv),gnh],0.447).
p(not(fev),[chl,not(hiv),not(gnh)],0.544).
p(not(fev),[not(chl),hiv,gnh],0.555).
p(not(fev),[not(chl),hiv,not(gnh)],0.624).
p(not(fev),[not(chl),not(hiv),gnh],0.846).
p(not(fev),[not(chl),not(hiv),not(gnh)],0.891).

p(pwu,[chl,gon,tri],0.723).
p(pwu,[chl,gon,not(tri)],0.584).
p(pwu,[chl,not(gon),tri],0.550).
p(pwu,[chl,not(gon),not(tri)],0.519).
p(pwu,[not(chl),gon,tri],0.442).
p(pwu,[not(chl),gon,not(tri)],0.287).
p(pwu,[not(chl),not(gon),tri],0.249).
p(pwu,[not(chl),not(gon),not(tri)],0.062).
p(not(pwu),[chl,gon,tri],0.277).
p(not(pwu),[chl,gon,not(tri)],0.416).
p(not(pwu),[chl,not(gon),tri],0.450).
p(not(pwu),[chl,not(gon),not(tri)],0.481).
p(not(pwu),[not(chl),gon,tri],0.558).
p(not(pwu),[not(chl),gon,not(tri)],0.713).
p(not(pwu),[not(chl),not(gon),tri],0.751).
p(not(pwu),[not(chl),not(gon),not(tri)],0.938).


p(fru,[gon],0.580).
p(fru,[not(gon)],0.401).
p(not(fru),[gon],0.420).
p(not(fru),[not(gon)],0.599).

p(swg,[hiv],0.483).
p(swg,[not(hiv)],0.191).
p(not(swg),[hiv],0.517).
p(not(swg),[not(hiv)],0.809).

p(map,[hiv,gnh],0.719).
p(map,[hiv,not(gnh)],0.531).
p(map,[not(hiv),gnh],0.311).
p(map,[not(hiv),not(gnh)],0.077).
p(not(map),[hiv,gnh],0.281).
p(not(map),[hiv,not(gnh)],0.469).
p(not(map),[not(hiv),gnh],0.689).
p(not(map),[not(hiv),not(gnh)],0.923).

p(hda,[hiv,gnh],0.702).
p(hda,[hiv,not(gnh)],0.465).
p(hda,[not(hiv),gnh],0.235).
p(hda,[not(hiv),not(gnh)],0.176).
p(not(hda),[hiv,gnh],0.298).
p(not(hda),[hiv,not(gnh)],0.535).
p(not(hda),[not(hiv),gnh],0.765).
p(not(hda),[not(hiv),not(gnh)],0.824).

p(aco,[tri],0.745).
p(aco,[not(tri)],0.572).
p(not(aco),[tri],0.255).
p(not(aco),[not(tri)],0.428).

p(iga,[tri],0.727).
p(iga,[not(tri)],0.155).
p(not(iga),[tri],0.273).
p(not(iga),[not(tri)],0.845).




%new code for HW5:
% doctor :- diagnosis, treatment.
doctor :- get_symptoms(Symptoms), treatment(Symptoms).

%call BN to get probability of each disease given Symptoms,
%tell user the probabilities, and assert the highest probability
%disease
%diagnosis :- get_symptoms(Symptoms), treatment(Symptoms).

% gets symptoms from user;
% L9 is list of symptoms to use in getmax() and moli();
% will output most likely disease to user and assert moliXXX
get_symptoms(L9) :- write('Welcome to Digital Doctor of Diagnoses and Data.'),nl,
	write('----------'),nl,
	write('Please indicate symptoms below (y or n).'),nl,
	write('abdominal pain: \t\t\t'),
	read(A), addABP(A, [], L1),
	write('fever: \t\t\t\t\t'),
	read(B), addFEV(B, L1, L2),
	write('pain when urinating: \t\t\t'),
	read(C), addPWU(C, L2, L3),
	write('frequent urination: \t\t\t'),
	read(D), addFRU(D, L3, L4),
	write('swollen glands: \t\t\t'),
	read(E), addSWG(E, L4, L5),
	write('muscle aches and pain: \t\t\t'),
	read(F), addMAP(F, L5, L6),
	write('headaches: \t\t\t\t'),
	read(G), addHDA(G, L6, L7),
	write('abnormal genitial color or odor: \t'),
	read(H), addACO(H, L7, L8),
	write('itching in genetial area: \t\t'),
	read(I), addIGA(I, L8, L9),
	moli(L9, X),
	write('----------'),nl,
	write('Your disease probabilities are: '),nl,
	listAll(L9),
	write('Your most likely disease is: '),
	write(X),nl,
	write('----------'),nl.

% placeholders for testing
% query_BN(L).


%ask user for other info relevant to treatment and assert it
%call FC rule interpreter
treatment(X) :- get_other_info, forward.
get_other_info :- write('Answer these questions to determine treatment:'),nl,
    write('Are you a man? (y or n): \t\t'),read1.
read1 :- read(X),query(X).
query('y') :- assert(fact(man)).
query('n') :- write('Are you pregnant? (y or n): '),assert(fact(wom)),read2.
read2 :- read(X),query2(X).
query2('y') :- assert(fact(prg)).
query2('n') :- assert(fact(n_prg)).

if (molichl and man) then 'Take the antibiotic Doxycycline'.
if (molichl and n_prg and wom) then 'Take the antibiotic Doxycycline'.
if (molichl and prg and wom) then 'Consult doctor on antibiotics'.
if (moligon and n_prg and wom) then 'Take Doxycycline'.
if (moligon and prg and wom) then 'Consult doctor on antibiotics'.
if (molihiv and wom) then 'Take Combivir'.
if (molihiv and man) then 'Take atripla'.
if (molitri and man) then 'Take Metronidazole'.
if (molitri and prg and wom) then 'Administer Metronidazole Gel'.
if (molitri and n_prg and wom) then 'Administer Metronidazole Gel'.
if (molignh and n_prg and wom) then 'Take Acyclovir'.
if (molignh and man) then 'Take Acyclovir'.
if (molignh and prg and wom) then 'Consult Doctor on Antiviral Therapy'.



% Figure 15.7  A forward chaining rule interpreter.
% Modifications: changed use of "not" to require parentheses
% (otherwise fails to compile). Tried to solve problem
% by defining not as follows but this did not help:
% :- op(900,fx,not)

% How to use
% Warning: before loading this, load a file with the operator
% definitions for if/then/and/or, e.g., as in exp-sys-1.pl
% To use the interpreter, first load a file of rules, e.g.,
%     if snowing then cold.
% Then assert some facts, e.g., fact(snowing).
% Then to forward chain on rules, type query 'forward'.

% Simple forward chaining in Prolog

forward  :-
   new_derived_fact( P),             % A new fact
   !,
   write( 'Derived: '), write( P), nl,
   assert( fact( P)),
   forward                           % Continue
   ;
   write( 'No more facts').          % All facts derived

new_derived_fact( Concl)  :-
   if Cond then Concl,               % A rule
   not( fact( Concl) ),              % Rule's conclusion not yet a fact
   composed_fact( Cond).             % Condition true?

composed_fact( Cond)  :-
   fact( Cond).                      % Simple fact

composed_fact( Cond1 and Cond2)  :-
   composed_fact( Cond1),
   composed_fact( Cond2).            % Both conjuncts true

composed_fact( Cond1 or Cond2)  :-
   composed_fact( Cond1)
   ;
   composed_fact( Cond2).






% Figure 15.11  An interpreter for belief networks.
% Modified by Dr. Green, Spring 2004, for CSC 529
% Changes: changed member-> mymember, delete->mydelete,
%   added parentheses to "not".



% Reasoning in belief networks

% Belief network is represented by relations:
%    parent( ParentNode, Node)
%    p( Node, ParentStates, Prob)
%      where Prob is conditional probability of Node given
%      values of parent variables ParentStates, for example:
%      p( alarm, [ burglary, not earthquake], 0.99)
%    p( Node, Prob)
%      probability of node without parents


% prob( Event, Condition, P):
%   probability of Event, given Cond, is P;
%   Event is a variable, its negation, or a list
%   of simple events representing their conjunction

prob( [X | Xs], Cond, P)  :-  !,   % Probability of conjunction
  prob( X, Cond, Px),
  prob( Xs, [X | Cond], PRest),
  P is Px * PRest.

prob( [], _, 1)  :-  !.            % Empty conjunction

prob( X, Cond, 1)  :-
  mymember( X, Cond), !.             % Cond implies X

prob( X, Cond, 0)  :-
  mymember( not(X), Cond), !.         % Cond implies X is false

prob( not(X), Cond, P)  :-  !,      % Probability of negation
  prob( X, Cond, P0),
  P is 1 - P0.

% Use Bayes rule if condition involves a descendant of X

prob( X, Cond0, P)  :-
  mydelete( Y, Cond0, Cond),
  predecessor( X, Y), !,           % Y is a descendant of X
  prob( X, Cond, Px),
  prob( Y, [X | Cond], PyGivenX),
  prob( Y, Cond, Py),
  P is Px * PyGivenX / Py.         % Assuming Py > 0

% Cases when condition does not involve a descendant

prob( X, Cond, P)  :-
  p( X, P), !.              % X a root cause - its probability given

prob( X, Cond, P)  :-  !,
  findall( (CONDi,Pi), p(X,CONDi,Pi), CPlist),  % Conditions on parents
  sum_probs( CPlist, Cond, P).

% sum_probs( CondsProbs, Cond, WeigthedSum)
%   CondsProbs is a list of conditions and corresponding probabilities,
%   WeightedSum is weighted sum of probabilities of Conds given Cond

sum_probs( [], _, 0).

sum_probs( [ (COND1,P1) | CondsProbs], COND, P)  :-
  prob( COND1, COND, PC1),
  sum_probs( CondsProbs, COND, PRest),
  P is P1 * PC1 + PRest.

predecessor( X, not(Y))  :- !,        % Negated variable Y
  predecessor( X, Y).

predecessor( X, Y)  :-
  parent( X, Y).

predecessor( X, Z)  :-
  parent( X, Y),
  predecessor( Y, Z).

mymember( X, [X | _]).

mymember( X, [_ | L])  :-
  mymember( X, L).

mydelete( X, [X | L], L).

mydelete( X, [Y | L], [Y | L2])  :-
  mydelete( X, L, L2).


