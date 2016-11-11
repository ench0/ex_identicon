defmodule Identicon do

    def main(input) do
        input
        |> hash_input
        |> pick_color
    end

    def pick_color(image) do
        %Identicon.Image{hex: hex_list} = image
        [r, g, b | _tail] = hex_list # | _tail = rest of the list
        [r, g, b]
    end

    @doc """
    Creating hash of the string.

    ## Examples

        iex> Identicon.main("banana")
        [114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239, 124, 65]

    """
    def hash_input(input) do
        hex = :crypto.hash(:md5, input)
        |> :binary.bin_to_list
        # hash = :crypto.hash(:md5, input) # Base.encode16(hash)
        # :binary._bin_to_list(hash)

        %Identicon.Image{hex: hex}
    end

end
