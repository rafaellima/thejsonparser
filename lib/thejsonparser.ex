defmodule Thejsonparser do
  # @moduledoc """
  # Documentation for `Thejsonparser`.
  # """
  #
  # @doc """
  # Hello world.
  #
  # ## Examples
  #
  #     iex> Thejsonparser.parse("tests/step1/valid.json")
  #     :true
  #
  # """
  def parse(tokens) do
    [head | tail] = tokens

    cond do
      head.lbrace != nil ->
        parse_object(tail, [:rbrace, :quote])
      head.rbrace != nil ->
          false
      true ->
        false
    end
  end

  defp parse_object(tokens, valid) do
    [head | tail] = tokens

    cond do
      head.rbrace && Enum.any?(valid, fn(x) -> x == :rbrace end) ->
        true
      head.quote && Enum.any?(valid, fn(x) -> x == :quote end) ->
        parse_object(tail, [:value, :colon, :rbrace])
      head.value && Enum.any?(valid, fn(x) -> x == :value end) ->
        parse_object(tail, [:quote])
      head.colon && Enum.any?(valid, fn(x) -> x == :colon end) ->
        parse_object(tail, [:quote])
      true ->
        false
    end
  end
end

