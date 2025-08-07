%{

#include"symbol_info.h"

#define YYSTYPE symbol_info*

int yyparse(void);
int yylex(void);

extern FILE *yyin;


ofstream outlog;

int lines = 1;

// declare any other variables or functions needed here
void yyerror(char *s) {
    fprintf(stderr, "Error at line %d: %s\n", lines, s);
    outlog << "Error at line " << lines << ": " << s << endl; // Log the error
    exit(1);
}

%}

%token IF ELSE FOR WHILE DO BREAK INT CHAR FLOAT DOUBLE VOID RETURN SWITCH CASE DEFAULT CONTINUE GOTO PRINTLN SEMICOLON COMMA ID LTHIRD RTHIRD CONST_INT CONST_FLOAT LCURL RCURL ASSIGNOP LOGICOP RELOP ADDOP MULOP NOT LPAREN RPAREN INCOP DECOP
%%

start : program
      {
          outlog<<"At line no: "<<lines<<" start : program "<<endl<<endl;
          outlog<<"\nTotal lines: "<<lines<<endl;
          //$$ = new symbol_info($1->getname(), "start");
      }
      ;

program : program unit
        {
            outlog<<"At line no: "<<lines<<" program : program unit "<<endl<<endl;
            outlog<<$1->getname()+"\n"+$2->getname()<<endl<<endl;
            $$ = new symbol_info($1->getname()+"\n"+$2->getname(),"program");
        }
        | unit
        {
            outlog<<"At line no: "<<lines<<" program : unit "<<endl<<endl;
            outlog<<$1->getname()<<endl<<endl;
            $$ = new symbol_info($1->getname(),"program");
        }
    ;

unit : var_declaration
     {
       outlog<<"At line no: "<<lines<<" unit : var_declaration "<<endl<<endl;
       outlog<<$1->getname()<<endl<<endl;
       $$ = new symbol_info($1->getname(),"unit_def");
     }
     | func_definition
     {
       outlog<<"At line no: "<<lines<<" unit : func_definition "<<endl<<endl;
       outlog<<$1->getname()<<endl<<endl;
       $$ = new symbol_info($1->getname(),"unit_def");
     }
     ;

var_declaration : type_specifier declaration_list SEMICOLON
                {
                    outlog<<"At line no: "<<lines<<" var_declaration : type_specifier declaration_list SEMICOLON "<<endl<<endl;
                    outlog<<$1->getname()<<" "<<$2->getname()<<";"<<endl<<endl;
                    $$ = new symbol_info($1->getname() + " " + $2->getname() + ";", "var_dec");
                }
                ;

type_specifier : INT
               {
                 outlog<<"At line no: "<<lines<<" type_specifier : INT "<<endl<<endl;
                 outlog<<"int"<<endl<<endl;
                 $$ = new symbol_info("int","type_spec");
               }
               | FLOAT
               {
                 outlog<<"At line no: "<<lines<<" type_specifier : FLOAT "<<endl<<endl;
                 outlog<<"float"<<endl<<endl;
                 $$ = new symbol_info("float","type_spec");
               }
               | VOID
               {
                 outlog<<"At line no: "<<lines<<" type_specifier : VOID "<<endl<<endl;
                 outlog<<"void"<<endl<<endl;
                 $$ = new symbol_info("void","type_spec");
               }
               ;

declaration_list : declaration_list COMMA ID
                 {
                     outlog<<"At line no: "<<lines<<" declaration_list : declaration_list COMMA ID "<<endl<<endl;
                     outlog<<$1->getname()<<","<<$3->getname()<<endl<<endl;
                     $$ = new symbol_info($1->getname() + "," + $3->getname(), "decl_list");
                 }
                 | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD
                 {
                     outlog<<"At line no: "<<lines<<" declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD "<<endl<<endl;
                     outlog<<$1->getname()<<","<<$3->getname()<<"["<<$5->getname()<<"]"<<endl<<endl;
                     $$ = new symbol_info($1->getname() + "," + $3->getname() + "[" + $5->getname() + "]", "decl_list");
                 }
                 | ID
                 {
                     outlog<<"At line no: "<<lines<<" declaration_list : ID "<<endl<<endl;
                     outlog<<$1->getname()<<endl<<endl;
                     $$ = new symbol_info($1->getname(), "decl_list");
                 }
                 | ID LTHIRD CONST_INT RTHIRD
                 {
                     outlog<<"At line no: "<<lines<<" declaration_list : ID LTHIRD CONST_INT RTHIRD "<<endl<<endl;
                     outlog<<$1->getname()<<"["<<$3->getname()<<"]"<<endl<<endl;
                     $$ = new symbol_info($1->getname() + "[" + $3->getname() + "]", "decl_list");
                 }
                 ;

parameter_list : parameter_list COMMA type_specifier ID
                {
                    outlog<<"At line no: "<<lines<<" parameter_list : parameter_list COMMA type_specifier ID "<<endl<<endl;
                    outlog<<$1->getname()<<","<<$3->getname()<<" "<<$4->getname()<<endl<<endl;
                    $$ = new symbol_info($1->getname() + "," + $3->getname() + " " + $4->getname(), "param_list");
                }
                | parameter_list COMMA type_specifier
                {
                    outlog<<"At line no: "<<lines<<" parameter_list : parameter_list COMMA type_specifier "<<endl<<endl;
                    outlog<<$1->getname()<<","<<$3->getname()<<endl<<endl;
                    $$ = new symbol_info($1->getname()+","+$3->getname(),"param_list");
                }
                | type_specifier ID
                {
                    outlog<<"At line no: "<<lines<<" parameter_list : type_specifier ID "<<endl<<endl;
                    outlog<<$1->getname()<<" "<<$2->getname()<<endl<<endl;
                    $$ = new symbol_info($1->getname()+" "+$2->getname(),"param_list");
                }
                | type_specifier
                {
                    outlog<<"At line no: "<<lines<<" parameter_list : type_specifier "<<endl<<endl;
                    outlog<<$1->getname()<<endl<<endl;
                    $$ = new symbol_info($1->getname(),"param_list");
                }
                ;

compound_statement : LCURL statements RCURL
                    {
                      outlog<<"At line no: "<<lines<<" compound_statement : LCURL statements RCURL "<<endl<<endl;
                      outlog<<"{\n"<<$2->getname()<<"\n}"<<endl<<endl;
                      $$ = new symbol_info("{\n"+$2->getname()+"\n}","comp_stmnt");
                    }
                    | LCURL RCURL
                    {
                        outlog<<"At line no: "<<lines<<" compound_statement : LCURL RCURL "<<endl<<endl;
                        outlog<<"{\n}"<<endl<<endl;
                        $$ = new symbol_info("{\n}", "comp_stmnt");
                    }
                    ;

statements : statements statement
            {
                outlog<<"At line no: "<<lines<<" statements : statements statement "<<endl<<endl;
                outlog<<$1->getname()<<"\n"<<$2->getname()<<endl<<endl;
                $$ = new symbol_info($1->getname() + "\n" + $2->getname(), "stmnts");
            }
            | statement
            {
              outlog<<"At line no: "<<lines<<" statements : statement "<<endl<<endl;
              outlog<<$1->getname()<<endl<<endl;
              $$ = new symbol_info($1->getname(),"stmnt");
            }
            ;

expression : logic_expression
            {
              outlog<<"At line no: "<<lines<<" expression : logic_expression "<<endl<<endl;
              outlog<<$1->getname()<<endl<<endl;
              $$ = new symbol_info($1->getname(),"exp");
            }
            | variable ASSIGNOP logic_expression
            {
              outlog<<"At line no: "<<lines<<" expression : variable ASSIGNOP logic_expression "<<endl<<endl;
              outlog<<$1->getname()<<"="<<$3->getname()<<endl<<endl;
              $$ = new symbol_info($1->getname()+"="+$3->getname(),"exp");
            }
            ;

variable : ID LTHIRD expression RTHIRD
          {
              outlog<<"At line no: "<<lines<<" variable : ID LTHIRD expression RTHIRD "<<endl<<endl;
              outlog<<$1->getname()<<"["<<$3->getname()<<"]"<<endl<<endl;
              $$ = new symbol_info($1->getname() + "[" + $3->getname() + "]", "variable");
          }
          | ID
          {
            outlog<<"At line no: "<<lines<<" variable : ID "<<endl<<endl;
            outlog<<$1->getname()<<endl<<endl;
            $$ = new symbol_info($1->getname(),"variable");
          }
          ;

logic_expression : rel_expression
                  {
                    outlog<<"At line no: "<<lines<<" logic_expression : rel_expression "<<endl<<endl;
                    outlog<<$1->getname()<<endl<<endl;
                    $$ = new symbol_info($1->getname(),"log_exp");
                  }
                  | rel_expression LOGICOP rel_expression
                  {
                      outlog<<"At line no: "<<lines<<" logic_expression : rel_expression LOGICOP rel_expression "<<endl<<endl;
                      outlog<<$1->getname()<<""<<$2->getname()<<""<<$3->getname()<<endl<<endl;
                      $$ = new symbol_info($1->getname() + "" + $2->getname() + "" + $3->getname(), "log_exp");
                  }
                  ;

rel_expression : simple_expression
                {
                  outlog<<"At line no: "<<lines<<" rel_expression : simple_expression "<<endl<<endl;
                  outlog<<$1->getname()<<endl<<endl;
                  $$ = new symbol_info($1->getname(),"rel_exp");
                }
                | simple_expression RELOP simple_expression
                {
                    outlog<<"At line no: "<<lines<<" rel_expression : simple_expression RELOP simple_expression "<<endl<<endl;
                    outlog<<$1->getname()<<""<<$2->getname()<<""<<$3->getname()<<endl<<endl;
                    $$ = new symbol_info($1->getname() + "" + $2->getname() + "" + $3->getname(), "rel_exp");
                }
                ;

simple_expression : term
                  {
                    outlog<<"At line no: "<<lines<<" simple_expression : term "<<endl<<endl;
                    outlog<<$1->getname()<<endl<<endl;
                    $$ = new symbol_info($1->getname(),"sim_exp");
                  }
                  | simple_expression ADDOP term
                  {
                      outlog<<"At line no: "<<lines<<" simple_expression : simple_expression ADDOP term "<<endl<<endl;
                      outlog<<$1->getname()<<""<<$2->getname()<<""<<$3->getname()<<endl<<endl;
                      $$ = new symbol_info($1->getname() + "" + $2->getname() + "" + $3->getname(), "sim_exp");
                  }
                  ;

term : unary_expression
      {
        outlog<<"At line no: "<<lines<<" term : unary_expression "<<endl<<endl;
        outlog<<$1->getname()<<endl<<endl;
        $$ = new symbol_info($1->getname(),"term");
      }
      | term MULOP unary_expression
      {
          outlog<<"At line no: "<<lines<<" term : term MULOP unary_expression "<<endl<<endl;
          outlog<<$1->getname()<<""<<$2->getname()<<""<<$3->getname()<<endl<<endl;
          $$ = new symbol_info($1->getname() + "" + $2->getname() + "" + $3->getname(), "term");
      }
      ;

unary_expression : ADDOP unary_expression
                  {
                      outlog<<"At line no: "<<lines<<" unary_expression : ADDOP unary_expression "<<endl<<endl;
                      outlog<<$1->getname()<<$2->getname()<<endl<<endl;
                      $$ = new symbol_info($1->getname() + $2->getname(), "unary_expression");
                  }
                  | NOT unary_expression
                  {
                      outlog<<"At line no: "<<lines<<" unary_expression : NOT unary_expression "<<endl<<endl;
                      outlog<<"!"<<$2->getname()<<endl<<endl;
                      $$ = new symbol_info("!" + $2->getname(), "unary_expression");
                  }
                  | factor
                  {
                    outlog<<"At line no: "<<lines<<" unary_expression : factor "<<endl<<endl;
                    outlog<<$1->getname()<<endl<<endl;
                    $$ = new symbol_info($1->getname(),"unary_expression");
                  }
                  ;

factor : variable
        {
            outlog<<"At line no: "<<lines<<" factor : variable "<<endl<<endl;
            outlog<<$1->getname()<<endl<<endl;
            $$ = new symbol_info($1->getname(),"factor");
        }
        | ID LPAREN argument_list RPAREN
        {
            outlog<<"At line no: "<<lines<<" factor : ID LPAREN argument_list RPAREN "<<endl<<endl;
            outlog<<$1->getname()<<"("<<$3->getname()<<")"<<endl<<endl;
            $$ = new symbol_info($1->getname() + "(" + $3->getname() + ")", "factor");
        }
        | LPAREN expression RPAREN
        {
            outlog<<"At line no: "<<lines<<" factor : LPAREN expression RPAREN "<<endl<<endl;
            outlog<<"("<<$2->getname()<<")"<<endl<<endl;
            $$ = new symbol_info("(" + $2->getname() + ")", "factor");
        }
        | CONST_INT
        {
          outlog<<"At line no: "<<lines<<" factor : CONST_INT "<<endl<<endl;
          outlog<<$1->getname()<<endl<<endl;
          $$ = new symbol_info($1->getname(),"factor");
        }
        | CONST_FLOAT
        {
            outlog<<"At line no: "<<lines<<" factor : CONST_FLOAT "<<endl<<endl;
            outlog<<$1->getname()<<endl<<endl;
            $$ = new symbol_info($1->getname(), "factor");
        }
        | variable INCOP
        {
            outlog<<"At line no: "<<lines<<" factor : variable INCOP "<<endl<<endl;
            outlog<<$1->getname()<<"++"<<endl<<endl;
            $$ = new symbol_info($1->getname() + "++", "factor");
        }
        | variable DECOP
        {
            outlog<<"At line no: "<<lines<<" factor : variable DECOP "<<endl<<endl;
            outlog<<$1->getname()<<"--"<<endl<<endl;
            $$ = new symbol_info($1->getname() + "--", "factor");
        }
        ;

expression_statement : SEMICOLON
                     {
                         outlog<<"At line no: "<<lines<<" expression_statement : SEMICOLON "<<endl<<endl;
                         outlog<<";"<<endl<<endl;
                         $$ = new symbol_info(";", "exp_stmnt");
                     }
                     | expression SEMICOLON
                     {
                         outlog<<"At line no: "<<lines<<" expression_statement : expression SEMICOLON "<<endl<<endl;
                         outlog<<$1->getname()<<";"<<endl<<endl;
                         $$ = new symbol_info($1->getname() + ";", "exp_stmnt");
                     }
                     ;

argument_list : arguments
              {
                  outlog<<"At line no: "<<lines<<" argument_list : arguments "<<endl<<endl;
                  outlog<<$1->getname()<<endl<<endl;
                  $$ = new symbol_info($1->getname(), "arg_list");
              }
              | /* empty */
              {
                  outlog<<"At line no: "<<lines<<" argument_list : /* empty */ "<<endl<<endl;
                  outlog<<""<<endl<<endl;
                  $$ = new symbol_info("", "arg_list");
              }
              ;

arguments : arguments COMMA logic_expression
          {
              outlog<<"At line no: "<<lines<<" arguments : arguments COMMA logic_expression "<<endl<<endl;
              outlog<<$1->getname()<<","<<$3->getname()<<endl<<endl;
              $$ = new symbol_info($1->getname() + "," + $3->getname(), "args");
          }
          | logic_expression
          {
              outlog<<"At line no: "<<lines<<" arguments : logic_expression "<<endl<<endl;
              outlog<<$1->getname()<<endl<<endl;
              $$ = new symbol_info($1->getname(), "args");
          }
          ;

func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement
                {
                    outlog<<"At line no: "<<lines<<" func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement "<<endl<<endl;
                    outlog<<$1->getname()<<" "<<$2->getname()<<"("<<$4->getname()<<")\n"<<$6->getname()<<endl<<endl;
                    $$ = new symbol_info($1->getname()+" "+$2->getname()+"("+$4->getname()+")\n"+$6->getname(),"func_def");
                }
                | type_specifier ID LPAREN RPAREN compound_statement
                {
                    outlog<<"At line no: "<<lines<<" func_definition : type_specifier ID LPAREN RPAREN compound_statement "<<endl<<endl;
                    outlog<<$1->getname()<<" "<<$2->getname()<<"()\n"<<$5->getname()<<endl<<endl;
                    $$ = new symbol_info($1->getname()+" "+$2->getname()+"()\n"+$5->getname(),"func_def");
                }
                ;

statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement
          {
            outlog<<"At line no: "<<lines<<" statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement "<<endl<<endl;
            outlog<<"for("<<$3->getname()<<$4->getname()<<$5->getname()<<")\n"<<$7->getname()<<endl<<endl;
            $$ = new symbol_info("for("+$3->getname()+$4->getname()+$5->getname()+")\n"+$7->getname(), "stmnt");
          }
          | var_declaration
          {
              outlog<<"At line no: "<<lines<<" statement : var_declaration "<<endl<<endl;
              outlog<<$1->getname()<<endl<<endl;
              $$ = new symbol_info($1->getname(), "stmnt");
          }
          | compound_statement
          {
              outlog<<"At line no: "<<lines<<" statement : compound_statement "<<endl<<endl;
              outlog<<$1->getname()<<endl<<endl;
              $$ = new symbol_info($1->getname(), "stmnt");
          }
          | expression_statement
          {
              outlog<<"At line no: "<<lines<<" statement : expression_statement "<<endl<<endl;
              outlog<<$1->getname()<<endl<<endl;
              $$ = new symbol_info($1->getname(), "stmnt");
          }
          | IF LPAREN expression RPAREN statement
          {
              outlog<<"At line no: "<<lines<<" statement : IF LPAREN expression RPAREN statement "<<endl<<endl;
              outlog<<"if("<<$3->getname()<<")\n"<<$5->getname()<<endl<<endl;
              $$ = new symbol_info("if(" + $3->getname() + ")\n" + $5->getname(), "stmnt");
          }
          | IF LPAREN expression RPAREN statement ELSE statement
          {
              outlog<<"At line no: "<<lines<<" statement : IF LPAREN expression RPAREN statement ELSE statement "<<endl<<endl;
              outlog<<"if("<<$3->getname()<<")\n"<<$5->getname()<<"\nelse\n"<<$7->getname()<<endl<<endl;
              $$ = new symbol_info("if(" + $3->getname() + ")\n" + $5->getname() + "\nelse\n" + $7->getname(), "stmnt");
          }
          | WHILE LPAREN expression RPAREN statement
          {
              outlog<<"At line no: "<<lines<<" statement : WHILE LPAREN expression RPAREN statement "<<endl<<endl;
              outlog<<"while("<<$3->getname()<<")\n"<<$5->getname()<<endl<<endl;
              $$ = new symbol_info("while(" + $3->getname() + ")\n" + $5->getname(), "stmnt");
          }
          | PRINTLN LPAREN ID RPAREN SEMICOLON
          {
              outlog<<"At line no: "<<lines<<" statement : PRINTLN LPAREN ID RPAREN SEMICOLON "<<endl<<endl;
              outlog<<"printf("<<$3->getname()<<");"<<endl<<endl;
              $$ = new symbol_info("printf(" + $3->getname() + ");", "stmnt");
          }
          | RETURN expression SEMICOLON
          {
            outlog<<"At line no: "<<lines<<" statement : RETURN expression SEMICOLON "<<endl<<endl;
            outlog<<"return "<<$2->getname()<<";"<<endl<<endl;
            $$ = new symbol_info("return " + $2->getname() + ";","stmnt");
          }
          ;

%%

int main(int argc, char *argv[])
{
    if(argc != 2) 
    {
        // check if filename given
    }
    yyin = fopen(argv[1], "r");
    outlog.open("my_log.txt", ios::trunc);

if(yyin == NULL)
    {
        cout<<"Couldn't open file"<<endl;
        return 0;
    }

yyparse();

//print number of lines

outlog.close();

fclose(yyin);

return 0;
}
