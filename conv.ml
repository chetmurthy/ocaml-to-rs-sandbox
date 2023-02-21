let rec typekind_to_rs ~name pps = function
    <:ctyp< int >> ->  Fmt.(pf pps "i32")
  | <:ctyp< string >> ->  Fmt.(pf pps "String")
  | <:ctyp< t >> ->  Fmt.(pf pps "%s" name)
  | <:ctyp< $lid:s$ >> ->  Fmt.(pf pps "%s" s)
  | <:ctyp< { $list:l$ } >> ->
     let members = l |> List.map (function (_,  mname, _,  ty, _) -> (mname, ty)) in
     Fmt.(pf pps "{ %a }"
            (list ~sep:(const string ", ") (pair ~sep:(const string ": ") string (typekind_to_rs ~name)))
            members)
  | <:ctyp< [ $list:l$ ] >> ->
     let members = l |> List.map (function
                         <:constructor< $uid:cname$ of $list:l$ >> -> (cname, l)) in
     let pp_branch pps (cname,l) =
       Fmt.(pf pps "%s(%a)" cname (list ~sep:(const string ", ") (typekind_to_rs ~name)) l) in
     Fmt.(pf pps "{ %a }" (list ~sep:(const string ", ") pp_branch) members)

let typedecl_to_rs ~name pps = function
    <:type_decl< t = $tk$ >> ->
     match tk with
       <:ctyp< { $list:_$ } >> ->
      Fmt.(pf pps "struct %s %a" name (typekind_to_rs ~name) tk)
     | <:ctyp< [ $list:_$ ] >> ->
      Fmt.(pf pps "enum %s %a" name (typekind_to_rs ~name) tk)

;;

let str_item_to_rs pps = function
    <:str_item:< module $uid:mname$ = struct
                type t = $tk$ ;
                end >> ->
      Fmt.(pf pps "%a" (typedecl_to_rs ~name:mname) <:type_decl< t = $tk$ >>)
;;

let loc = Ploc.dummy ;;
Fmt.(pf stdout "%a\n%!" (typekind_to_rs ~name:"Foo") <:ctyp< { a : int ; b : string ; c : t } >>);;
Fmt.(pf stdout "%a\n%!" (typedecl_to_rs ~name:"Foo") <:type_decl< t = { a : int ; b : string ; c : t } >>);;
Fmt.(pf stdout "%a\n%!" str_item_to_rs <:str_item< module MyRecord = struct
  type t = {
    a: int;
    b: string;
    c: int
  } ;
end >>) ;;
Fmt.(pf stdout "%a\n%!" str_item_to_rs <:str_item< module MyVariant = struct
  type t = [
     Ok of string and int
    | Err of int and int ] ;
end >>) ;;
