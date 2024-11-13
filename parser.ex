defmodule Tokenizer do
  defstruct [:lbrace, :rbrace, :colon, :quote, :value, :new_line]
end

defmodule Token do
  def start(content) do
    content 
      |> String.graphemes 
      |> Enum.map(fn(x) -> tokenize(x) end)
  end

  defp tokenize(char) do
    case char do
      "{" ->
        %Tokenizer{lbrace: char}
      "}" ->
        %Tokenizer{rbrace: char}
      ":" ->
        %Tokenizer{colon: char}
      "\"" ->
        %Tokenizer{quote: char}
      "\n" ->
        %Tokenizer{new_line: char}
      _ ->
        %Tokenizer{value: char}
    end
  end
end

defmodule Parser do
  def validate(path) do
    case File.read(path) do
      { :ok, content } ->
        [head | tail] = Token.start(content)
        
        if !parse(head, tail) do
          exit 1
        end
      { :error, _ } ->
        IO.puts "File not found"
        exit 1
    end
  end

  def parse(head, tail) when head.lbrace != nil do
    valid_tokens = ["\""]
    parse_object(tail, valid_tokens)
  end

  def parse(head, _tail) when head.lbrace == nil do
    false
  end

  def parse(_token, tokens) when length(tokens) == 0 do
    false
  end

  def parse_object(tokens, valid_tokens) when length(tokens) == 0 do
    IO.puts "exiting parse_object"
  end
    

  def parse_object(tokens, valid_tokens) do
    [head | tail] = tokens

    quote = Enum.any?(valid_tokens, fn(x) -> x == head.quote end)
    colon = Enum.any?(valid_tokens, fn(x) -> x == head.colon end)
    rbrace = Enum.any?(valid_tokens, fn(x) -> x == head.rbrace end)
    space = Enum.any?(valid_tokens, fn(x) -> x == head.value end)
    new_line = Enum.any?(valid_tokens, fn(x) -> x == head.new_line end)

    cond do
      quote ->
        parse_string(tail)
      colon ->
        parse_object(tail, ["\"", " "])
      rbrace ->
        parse_object(tail, ["\n"])
      space ->
        parse_object(tail, ["\""])
      new_line ->
        parse_object(tail, ["\n"])
      true ->
        if head.value == "," do
          IO.puts "invalid token"
          exit 1
        end

        parse_object(tail, ["\n"])
    end
  end

  def parse_string(tokens) do
    [head | tail] = tokens

    cond do
      head.value != nil ->
        parse_string(tail)
      head.quote != nil ->
        parse_object(tail, ["\n"])
      true ->
        IO.puts "expected quote got: #{head.value}"
        exit 1
    end
  end
end

# compile
# elixirc parser.ex
# $iex > Parser.validate("{\"name\":\"Rafael\",\"age\":3}")
