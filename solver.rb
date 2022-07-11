class WordleSolver
  def ask_for_result()
    print 'Type in the result (h for help, x to skip this word, q to quit): '

    result = $stdin.gets.strip
    if result == 'h'
      puts 'You should type the result after trying the word suggested as a string of 5 numbers, like this:'
      puts '🟩⬛🟨⬛⬛ -> 20100'
      puts '⬛⬛⬛⬛⬛ -> 00000'
      puts '⬛🟨⬛🟨🟨 -> 01011'
      puts 'Got it?'
      return ask_for_result
    end

    if result == 'x'
      return nil
    end

    if result == 'q'
      exit
    end

    if result == 'p'
      @words.each { |a| puts a}
      return ask_for_result
    end

    result
  end

  def main
    puts 'Wordle Solver'
    file = ARGV.shift
    @words = File.read(file.nil? ? 'words.txt' : file).split("\n")

    x = 0
    while true
      guess = @words.at(rand(@words.count))

      if not ARGV.at(x).nil?
        guess = ARGV.at(x)
      end

      x += 1
      puts "Try \"#{guess}\""

      result = ask_for_result

      if result.nil?
        next
      end

      hint = result.split('')

      hints = []
      hint.each_index do |i|
        score = hint.at(i).to_i
        hints.push({
          index: i,
          score: score,
          letter: guess[i],
        })
      end

      hints.each do |hint|
        letter = hint[:letter]
        score = hint[:score]
        i = hint[:index]

        if score < 2
          @words.select! { |word| word[i] != letter }
        end

        if score == 2
          @words.select! { |word| word[i] == letter }
        end

        # what is tcount or ncount? Bob would be mad...
        tcount = hints.count { |h| h[:letter] == letter }
        ncount = hints.count { |h| h[:letter] == letter && h[:score] > 0 }
        if tcount > ncount
          @words.select! { |word| word.count(letter) == ncount }
        else
          @words.select! { |word| word.count(letter) >= ncount }
        end
      end
    end
  end
end

WordleSolver.new.main
