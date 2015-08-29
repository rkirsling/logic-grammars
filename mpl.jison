/**
 * Grammar for modal propositional logic.
 * Generates a parser which takes an ASCII wff and returns a JSON AST.
 *
 * @author Ross Kirsling
 */

%lex
%%
\s+       /* skip whitespace */
\w+       return 'PROPOSITION'
"("       return '('
")"       return ')'
"~"       return '¬'
"[]"      return '□'
"<>"      return '◊'
"&"       return '∧'
"|"       return '∨'
"->"      return '→'
"<->"     return '↔'
<<EOF>>   return 'EOF'
/lex

%right '↔'
%right '→'
%right '∨'
%right '∧'
%right '¬' '□' '◊'
%%

file
  : formula EOF
    { return $1; }
  ;

formula
  : formula '↔' formula
    { $$ = { equi: [$1, $3] }; }
  | formula '→' formula
    { $$ = { impl: [$1, $3] }; }
  | formula '∨' formula
    { $$ = { disj: [$1, $3] }; }
  | formula '∧' formula
    { $$ = { conj: [$1, $3] }; }
  | '¬' formula
    { $$ = { not: $2 }; }
  | '□' formula
    { $$ = { nec: $2 }; }
  | '◊' formula
    { $$ = { poss: $2 }; }
  | '(' formula ')'
    { $$ = $2; }
  | PROPOSITION
    { $$ = { prop: yytext }; }
  ;
