class Shmordle
    def self.play
        Runner.run(self.name)
    end

    def blurb
        "it's not wordle!\nexplain how the clues work\ngood luck!"
    end

    FIRST = "enter word length"
    MAX_GUESSES = 6

    attr_accessor :guesses, :word_length, :solution, :solved, :word_list, :guessed

    def initialize
        self.word_list = Spicy::Memory::Corpus.new.nouns +
            Spicy::Memory::Corpus.new.verbs +
            Spicy::Memory::Corpus.new.adverbs +
            Spicy::Memory::Corpus.new.adjectives
    end

    def first
        FIRST
    end
    
    def next(input, last)
        if last == FIRST
            self.word_length = input.to_i
            self.guesses = 1
            self.solution = Spicy::Proton.send(([:noun] * 40 + [:verb] * 32 + [:adverb] * 15 + [:adjective] * 13).sample, min: word_length, max: word_length).downcase
            self.solved = false
            self.guessed = Set.new
            return "ok, the word has #{word_length} letters!\nmake a guess\n  #{'?' * word_length}"
        end

        if input == '.used'
            return guessed.to_a.sort.join(' ')
        end

        if input == '.left'
            return (('a'..'z').to_a - guessed.to_a).sort.join(' ')
        end

        if input.length != word_length
            return "guess a word with #{word_length} letters!"
        end

        input.downcase!
        if input == solution
            self.solved = true
            return
        end

        unless word_list.include? input
            return "not in word list!"
        end

        if guesses == MAX_GUESSES
            return
        end

        self.guesses += 1

        self.guessed = guessed + input.chars
        solution_chars = solution.chars
        clues = input.chars.map.with_index do |c, i|
            if solution_chars[i] == c
                solution_chars[i] = nil
                c.upcase
            else 
                c
            end
        end
        clues = clues.map.with_index do |c, i|
            if /[A-Z]/.match c
                c
            else
                solution_index = solution_chars.index c
                if solution_index
                    solution_chars[solution_index] = nil
                    c
                else
                    '?'
                end
            end
        end

        "  #{clues.join}"
    end

    def done
        solved ? "  #{solution.upcase}\nyou got it in #{guesses} guesses!" : "the word was \"#{solution}\" - thanks for playing!"
    end
end
