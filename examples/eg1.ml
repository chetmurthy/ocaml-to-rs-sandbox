module MyRecord = struct
  type t = {
    a: int;
    b: string;
    c: int
  }
end

module MyVariant = struct
  type t =
    | Ok of string * int
    | Err of int * int
end
