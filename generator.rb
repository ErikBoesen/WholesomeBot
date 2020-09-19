require './chars'


def mid_favoring_random(upper_bound)
    running_total = 0
    rolls = 3
    rolls.times do
        running_total += rand(upper_bound)
    end
    mean = (running_total.to_f / rolls).round().to_i
    return mean
end

def lower(a, b)
    return (a < b) ? a : b
end

def low_favoring_random( upper_bound)
    a = rand(upper_bound)
    b = rand(upper_bound)
    return lower(a, b)
end

def generate()
    fishes = []
    fish_type_count = rand(Chars::FISH_TYPES.length()) + 1
    if fish_type_count == Chars::FISH_TYPES.length() then
        fishes += Chars::FISH_TYPES
    else
        while (fishes.length() < fish_type_count)
            String fish = Chars::FISH_TYPES.sample
            if !fishes.include? fish
                fishes << fish
            end
        end
    end

    # A rare swimmer should show up about once every 8 tweets.
    if rand(8) == 0 then
        fishes << Chars::RARE_SWIMMER_TYPES.sample
    end

    # There will be about 8 tweets a day. Something should be special about
    # many of them but not all of them. Only once a week should something
    # exceedingly rare show up. 8 tweets * 7 days = 56 tweets per week
    exceedingly_rare_bottom_time = (rand(56) == 0)

    # A rare bottom dweller should show up about once every 8 tweets.
    rare_bottom_dweller_time = (rand(8) == 0)

    max_line_length = 10
    bottom = []
    if rare_bottom_dweller_time then
        bottom << Chars::RARE_BOTTOM_DWELLERS.sample
    end
    if exceedingly_rare_bottom_time then
      bottom << Chars::EXCEEDINGLY_RARE_JUNK.sample
    end
    plant_count = mid_favoring_random(max_line_length - bottom.length() - 1)
    if plant_count < 1 then
        plant_count = 1
    end
    plant_count.times do
        bottom << Chars::PLANT_TYPES.sample
    end
    while bottom.length() < max_line_length do
        bottom << Chars::IDEOGRAPHIC_SPACE
    end
    bottom.shuffle!
    bottom_line = bottom.join('')

    # For each swimmer line, choose a random number of fish,
    # then random small whitespace in front of some.
    swim_line_count = 5
    # 2d array of strings
    swim_lines = []
    previous_swimmer_count = 0
    swim_line_count.times do
        swim_line = []

        # Lines should tend to have similar swimmer densities. How crowded in general is
        # this aquarium?
        max_per_line = rand((max_line_length * 0.6).round()) + 1
        swimmer_count = mid_favoring_random(max_per_line)

        # At least one swimmer on first line so first lines aren't trimmed.
        if previous_swimmer_count == 0 and swimmer_count == 0 then
            swimmer_count += 1
        end

        swimmer_count.times do
          swim_line << (get_small_personal_space() + fishes.sample)
        end
        while swim_line.length() < max_line_length do
            swim_line << Chars::IDEOGRAPHIC_SPACE
        end
        swim_line.shuffle!
        swim_lines << swim_line
        previous_swimmer_count = swimmer_count
    end

    string = swim_lines.collect { |swim_line| swim_line.join("") }.join("\n")
    string += "\n" + bottom_line
    return string
end

def get_small_personal_space()
    return [
        "",
        Chars::THIN_SPACE,
        Chars::THREE_PER_EM_SPACE,
        Chars::EN_SPACE
    ].sample
end

puts generate()
