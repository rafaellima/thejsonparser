defmodule TokenizerTest do
  use ExUnit.Case

  test "tokenizes an empty json" do
    assert Tokenizer.process("{}") == [%Tokenizer{lbrace: true}, %Tokenizer{rbrace: true}]
  end

  test "tokenizes a json with a single key" do
    assert Tokenizer.process("{\"key\":\"value\"}") == [
      %Tokenizer{lbrace: true},
      %Tokenizer{quote: true},
      %Tokenizer{value: "key"}, 
      %Tokenizer{quote: true},
      %Tokenizer{colon: true},
      %Tokenizer{quote: true},
      %Tokenizer{value: "value"},
      %Tokenizer{quote: true},
      %Tokenizer{rbrace: true}
    ]
  end
end
