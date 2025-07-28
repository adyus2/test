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

(* 主函数逻辑 *)
let run_program () =
  (* 1. 解析源码 *)
  let ast = parse_stdin () in
  
  (* 2. 执行语义分析（失败时终止） *)
  try analyze ast
  with SemanticError msg ->
    Printf.eprintf "Semantic error: %s\n" msg;
  (* 关键修复：语义错误时退出 *)

  (* 3. 生成汇编代码 *)
  let asm_code = compile ast in
  print_string asm_code

(* 程序入口 *)
let () = run_program ()
