/**
 * Grammar for combinatory logic.
 * Generates a parser which takes an ASCII expression and returns a JSON AST.
 *
 * @author Ross Kirsling
 */

%lex
%%
\s+        /* skip whitespace */
"("        return '('
")"        return ')'
[A-Za-z]   return 'COMBINATOR'
<<EOF>>    return 'EOF'
/lex

%%

file
 : expr EOF
   { return $expr; }
 ;

expr
  : term
    { $$ = $term; }
  | expr term
    { $$ = [$expr, $term]; }
  ;

term
  : '(' expr ')'
    { $$ = $expr; }
  | COMBINATOR
    { $$ = yytext; }
  ;
