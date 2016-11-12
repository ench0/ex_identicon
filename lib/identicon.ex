defmodule Identicon do

    def main(input) do
        input
        |> hash_input
        |> pick_color
        |> build_grid
        |> filter_odd_squares
        |> build_pixel_map
        |> draw_image
        |> save_image(input) #input is actually second argument, first one comes from the pipe (image)
    end

    def save_image(image, input) do
        File.write("#{input}.png", image)
    end

    def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do #no '= image' because it is end of the pipeline and we do not care about other arguments
        image = :egd.create(250,250)
        fill = :egd.color(color)

        Enum.each pixel_map, fn ({start, stop}) -> #difference between Enum.each and Enum.map is that Enum.each itterates over every element but does not return new collection or transforming, but only does the processing step
            :egd.filledRectangle(image, start, stop, fill)
        end

        :egd.render(image)
    end

    def build_pixel_map(%Identicon.Image{grid: grid} = image) do
        pixel_map = Enum.map grid, fn({_code, index}) ->
            horizontal = rem(index, 5) * 50
            vertical = div(index, 5) * 50
            top_left = {horizontal, vertical}
            bottom_right = {horizontal + 50, vertical + 50}

            {top_left, bottom_right}
        end

        %Identicon.Image{image | pixel_map: pixel_map}
    end

    def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
        grid = Enum.filter grid, fn({code, _index}) ->
            rem(code, 2) == 0
        end

        %Identicon.Image{image | grid: grid}
    end

    def build_grid(%Identicon.Image{hex: hex} = image) do
        grid = 
            hex #community convention
            |> Enum.chunk(3) #producing list of lists
            |> Enum.map(&mirror_row/1) #Enum.map() mapping every element; &mirror_row/1 - passing reference to function
            |> List.flatten
            |> Enum.with_index

        %Identicon.Image{image | grid: grid}
    end

    def mirror_row(row) do
        [first, second | _tail] = row
        row ++ [second, first] #take row and append 2 elements
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
