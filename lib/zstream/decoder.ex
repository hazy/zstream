defmodule Zstream.Decoder do
  @moduledoc false

  @callback init() :: term

  @callback decode(chunk :: iodata, state :: term) :: {[{:data, iodata}], term}

  @callback close(state :: term) :: iodata

  def init(8), do: {Zstream.Decoder.Deflate, Zstream.Decoder.Deflate.init()}
  def init(0), do: {Zstream.Decoder.Stored, Zstream.Decoder.Stored.init()}
  def init(x), do: raise(Zstream.Unzip.Error, "Unsupported compression method #{x}")

  def decode(8, data) do
    :zlib.unzip(data)
  end

  def decode(0, data) do
    data
  end

  def decode(x, _data) do
    raise(Zstream.Unzip.Error, "Unsupported compression method #{x}")
  end
end
