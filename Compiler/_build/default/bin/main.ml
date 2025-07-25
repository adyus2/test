open ToyClib
open Ast
open Semantic
open Codegen

(* 解析标准输入流为AST *)
let parse_stdin () : comp_unit =
  let lexbuf = Lexing.from_channel stdin in
  try 
    Parser.comp_unit Lexer.token lexbuf
  with
  | Lexer.LexError msg -> 
      Printf.eprintf "Lexer error: %s\n" msg;
      exit 1
  | Parsing.Parse_error ->
      Printf.eprintf "Parser error\n";
      exit 1

let () =
  (* 1. 从stdin解析源码 *)
  let ast = parse_stdin () in
  
  (* 2. 执行语义分析 *)
  try
    analyze ast
  with SemanticError msg ->
    Printf.eprintf "Semantic error: %s\n" msg;
  
  
  (* 3. 生成汇编代码并输出到stdout *)
  let asm_code = compile ast in
  print_string asm_code