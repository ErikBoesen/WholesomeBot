require './chars'


def mid_favoring_random(max)
    running_total = 0
    rolls = 3
    rolls.times do
        running_total += rand(max)
    end
    mean = (running_total.to_f / rolls).round().to_i
    return mean
end

def lower(a, b)
    return (a < b) ? a : b
end

def low_favoring_random(max)
    a = rand(max)
    b = rand(max)
    return lower(a, b)
end

def higher(a, b)
    return (a > b) ? a : b
end

def high_favoring_random(max)
    a = rand(max)
    b = rand(max)
    return higher(a, b)
end

def generate()
    faces = []
    face_type_count = rand(Chars::FACES.length()) + 1
    if face_type_count == Chars::FACES.length() then
        faces += Chars::FACES
    else
        while (faces.length() < face_type_count)
            String face = Chars::FACES.sample
            if !faces.include? face
                faces << face
            end
        end
    end

    # Choose several decorators to use
    (rand(3) + 1).times do
        faces << Chars::RARE_DECORATORS.sample
    end

    max_line_length = 10

    # For each swimmer line, choose a random number of face,
    # then random small whitespace in front of some.
    line_count = 5
    # 2d array of strings
    lines = []
    previous_emoji_count = 0
    line_count.times do
        line = []

        # Lines should tend to have similar emoji densities.
        # Tweak constant to control crowdedness.
        max_per_line = rand((max_line_length * 0.9).round()) + 1
        emoji_count = mid_favoring_random(max_per_line)

        # At least one swimmer on first line so first lines aren't trimmed.
        if previous_emoji_count == 0 and emoji_count == 0 then
            emoji_count += 1
        end

        emoji_count.times do
          line << (get_small_personal_space() + faces.sample)
        end
        while line.length() < max_line_length do
            line << Chars::IDEOGRAPHIC_SPACE
        end
        line.shuffle!
        lines << line
        previous_emoji_count = emoji_count
    end

    string = lines.collect { |line| line.join("") }.join("\n")
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
