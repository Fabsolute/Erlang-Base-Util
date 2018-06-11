-module(base_util).
-author("ahmetturk").

-export([number_to_base_string/2, number_to_base_string/3, base_string_to_number/3, base_string_to_number/2]).

number_to_base_string(Number, Base) when is_integer(Number), is_integer(Base), Base =< 64 ->
  number_to_base_string(Number, Base, get_base_64_lookup()).

number_to_base_string(Number, Base, Lookup) when is_integer(Number), is_integer(Base), Base > 1 ->
  case Number < Base of
    true ->
      get_char_from_index(Number, Lookup);
    false ->
      number_to_base_string(Number div Base, Base, Lookup) ++ get_char_from_index(Number rem Base, Lookup)
  end.

base_string_to_number(String, Base) when is_binary(String), is_integer(Base) ->
  base_string_to_number(binary_to_list(String), Base);
base_string_to_number(String, Base) when is_list(String), is_integer(Base), Base =< 64, Base > 1 ->
  base_string_to_number(String, Base, get_base_64_lookup()).

base_string_to_number(String, Base, Lookup) when is_binary(String), is_integer(Base) ->
  base_string_to_number(binary_to_list(String), Base, Lookup);
base_string_to_number(String, Base, Lookup) when is_list(String), is_integer(Base), Base > 1 ->
  base_string_to_number(String, Base, Lookup, length(String) - 1, 0).

base_string_to_number([], _Base, _Lookup, _Counter, Acc) ->
  Acc;
base_string_to_number([H | T], Base, Lookup, Counter, Acc) ->
  base_string_to_number(T, Base, Lookup, Counter - 1, Acc + trunc(math:pow(Base, Counter) * get_index_from_char([H], Lookup))).

get_char_from_index(Index, Lookup) ->
  [lists:nth(Index + 1, Lookup)].

get_index_from_char(Char, Lookup) ->
  case index_of(Char, Lookup) of
    {ok, Index} ->
      Index - 1
  end.

get_base_64_lookup() ->
  [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z",
    "a",
    "b",
    "c",
    "d",
    "e",
    "f",
    "g",
    "h",
    "i",
    "j",
    "k",
    "l",
    "m",
    "n",
    "o",
    "p",
    "q",
    "r",
    "s",
    "t",
    "u",
    "v",
    "w",
    "x",
    "y",
    "z",
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "+",
    "/"
  ].

index_of(Item, List) ->
  index_of(Item, List, 1).

index_of(_, [], _) ->
  not_found;
index_of(Item, [Item | _], Index) ->
  {ok, Index};
index_of(Item, [_ | T], Index) ->
  index_of(Item, T, Index + 1).
