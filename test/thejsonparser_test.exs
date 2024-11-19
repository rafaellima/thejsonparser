defmodule ThejsonparserTest do
  use ExUnit.Case
  doctest Thejsonparser

  test "it parses an empty json" do 
    assert Thejsonparser.parse([%Tokenizer{lbrace: true}, %Tokenizer{rbrace: true}])
  end

  test "it indicates an error when parsing an invalid json" do 
    assert Thejsonparser.parse([%Tokenizer{rbrace: true}]) == false
  end

  test "it parses json with a single key" do
    assert Thejsonparser.parse([%Tokenizer{lbrace: true}, %Tokenizer{quote: true}, %Tokenizer{value: "key"}, %Tokenizer{quote: true}, %Tokenizer{colon: true}, %Tokenizer{quote: true}, %Tokenizer{value: "value"}, %Tokenizer{quote: true}, %Tokenizer{rbrace: true}])
  end

  test "it indicates an error when parsing a comma after the last key" do
    assert Thejsonparser.parse([%Tokenizer{lbrace: true}, %Tokenizer{quote: true}, %Tokenizer{value: "key"}, %Tokenizer{quote: true}, %Tokenizer{colon: true}, %Tokenizer{quote: true}, %Tokenizer{value: "value"}, %Tokenizer{quote: true}, %Tokenizer{comma: true}, %Tokenizer{rbrace: true}]) == false
  end
end
