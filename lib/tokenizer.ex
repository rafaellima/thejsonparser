defmodule Tokenizer do
  # defstruct [:lbrace, :rbrace, :colon, :quote, :value, :new_line, :comma]
  #
  # def process(text) do
  #   text 
  #     |> String.graphemes 
  #     |> Enum.map(&tokenize/1)
  # end
  #
  # defp tokenize(x) do
  #   case x do
  #     "{" -> %Tokenizer{lbrace: true}
  #     "}" -> %Tokenizer{rbrace: true}
  #     ":" -> %Tokenizer{colon: true}
  #     "\"" -> %Tokenizer{quote: true}
  #     "," -> %Tokenizer{comma: true}
  #     "\n" -> %Tokenizer{new_line: true}
  #     _ -> %Tokenizer{value: x}
  #   end
  # end
  defstruct [:lbrace, :rbrace, :colon, :quote, :value, :new_line, :comma]

  def process(text) do
    text
    |> String.graphemes()
    |> tokenize()
  end

  defp tokenize(graphemes) do
    Enum.reduce(graphemes, {[], nil}, fn x, {tokens, current_string} ->
      case x do
        "{" -> 
          {tokens ++ [%Tokenizer{lbrace: true}], current_string}
        "}" -> 
          {tokens ++ [%Tokenizer{rbrace: true}], current_string}
        ":" -> 
          {tokens ++ [%Tokenizer{colon: true}], current_string}
        "\"" -> 
          handle_quote(tokens, current_string)
        "," -> 
          {tokens ++ [%Tokenizer{comma: true}], current_string}
        "\n" -> 
          {tokens ++ [%Tokenizer{new_line: true}], current_string}
        _ -> 
          {tokens, append_to_string(current_string, x)}
      end
    end)
    |> finalize_tokens()
  end

  defp handle_quote(tokens, nil) do
    {tokens, ""}
  end
  defp handle_quote(tokens, current_string) do
    new_token = %Tokenizer{value: current_string}
    {tokens ++ [%Tokenizer{quote: true}, new_token, %Tokenizer{quote: true}], nil}
  end

  defp append_to_string(nil, char), do: char
  defp append_to_string(string, char), do: string <> char

  defp finalize_tokens({tokens, nil}), do: tokens
  defp finalize_tokens({tokens, current_string}) do
    tokens ++ [%Tokenizer{value: current_string}]
  end
end
