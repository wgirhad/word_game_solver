puts 'Wordle Solver'

file = ARGV.shift
words = File.read(file.nil? ? 'words.txt' : file).split("\n")

x = 0
while true
    guess = words.at(rand(words.count))

    if not ARGV.at(x).nil?
        guess = ARGV.at(x)
    end

    x += 1
    puts "Try \"#{guess}\""
    print 'Type in the result (h for help, x to skip, q to quit): '

    result = $stdin.gets.strip
    if result == 'h'
        puts 'Super helpful help message...'
        next
    end

    if result == 'x'
        next
    end

    if result == 'q'
        break
    end

    hint = result.split('')

    hint.each_index do |i|
        score = hint.at(i)
        letter = guess[i]

        if score == '0'
            words.select! { |word| word[i] != letter }
            if guess.count(letter) == 1
                words.select! { |word| word.count(letter).zero? }
            end
        end

        if score == '1'
            words.select! { |word| !word.index(letter).nil? }
            words.select! { |word| word[i] != letter }
        end

        if score == '2'
            words.select! { |word| word[i] == letter }
        end
    end
end
