defmodule Identicon do

    def main(input) do
        input
        |> hash_input
        |> pick_color
        |> build_grid
    end

    def build_grid(%Identicon.Image{hex: hex} = image) do
        hex
        |> Enum.chunk(3)
        # |> mirror_row
    end

    def mirror_row(row) do
        
    end

    def pick_color0(image) do
        %Identicon.Image{hex: hex_list} = image
        [r, g, b | _tail] = hex_list # | _tail = rest of the list
        # [r, g, b]
        # image
        %Identicon.Image{image | color: {r, g, b}}
    end

    def pick_color1(image) do
        %Identicon.Image{hex: [r, g, b | _tail]} = image
        %Identicon.Image{image | color: {r, g, b}}
    end

    def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
        %Identicon.Image{image | color: {r, g, b}}
    end

    @doc """
    Creating hash of the string and passing it to Identicon.Image struct.

    ## Examples

        iex> Identicon.hash_input("banana")
        %Identicon.Image{hex: [114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239, 124, 65]}

    """
    def hash_input(input) do
        hex = :crypto.hash(:md5, input)
        |> :binary.bin_to_list
        # hash = :crypto.hash(:md5, input) # Base.encode16(hash)
        # :binary._bin_to_list(hash)

        %Identicon.Image{hex: hex}
    end

end
