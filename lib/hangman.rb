class Hangman
  def initialize
    @secret_word = pick_random_word
    @player_guess = Array.new(@secret_word.length, '_')
    @used_letters = []
    @countdown = 11

    self.start
  end

  private

  def start
    @secret_word_arr = @secret_word.split('')

    until end_of_game? do
      puts 'Enter a letter (A-Z, a-z):'
      letter = gets.chomp
      was_found = false

      @secret_word_arr.each_with_index do |ltr, i|
        if ltr == letter
          @player_guess[i] = letter
          was_found = true
        end
      end

      unless was_found
        @used_letters << letter
        @countdown -= 1
      end

      p @player_guess
      p @used_letters
      p @countdown
    end
  end

  def pick_random_word
    random_line = ''
    File.open('google-10000-english-no-swears.txt') do |file|
      file_lines = file.readlines()
      until random_line.length.between?(5,12)
        random_line = file_lines[Random.rand(0...file_lines.size())].strip
      end
    end 
  
    random_line
  end

  def end_of_game?
    if @player_guess == @secret_word_arr
      puts 'Congratulations! You won!'
      return true
    elsif @countdown == 0
      puts 'Read more! You lost!'
      return true
    else
      return false
    end
  end
  
end

Hangman.new