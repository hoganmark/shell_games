class Runner
    def self.run(game_name)
        game = game_name.camelize.constantize.new
        puts game.blurb

        prompt = game.first
        while prompt
            puts prompt
            print '> '
            prompt = game.next gets.strip, prompt
        end

        puts game.done
    end
end