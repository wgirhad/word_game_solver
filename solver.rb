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

  if result == 'p'
    words.each { |a| puts a}
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
      words.select! { |word| word[i] != letter }
    end

    if score == 2
      words.select! { |word| word[i] == letter }
    end

    tcount = hints.count { |h| h[:letter] == letter }
    count = hints.count { |h| h[:letter] == letter && h[:score] > 0 }
    if tcount > count
      words.select! { |word| word.count(letter) == count }
    else
      words.select! { |word| word.count(letter) >= count }
    end
  end
end
