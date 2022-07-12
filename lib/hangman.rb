class Hangman
  require 'json'

  def initialize
    @used_letters = []
    @countdown = 11
  end

  def start
    if @saved_game
      puts 'Would you like to continue the last saved game? [y/n]'
      answer = gets.chomp.downcase
    else
      answer = 'n'
    end

    if answer == 'y'
      load_game
    else 
      @secret_word = pick_random_word
      @player_guess = Array.new(@secret_word.length, '_')
    end

    @secret_word_arr = @secret_word.split('')

    puts 'You can save your progress by typing "save".'

    until end_of_game? do
      puts 'Enter a letter (A-Z, a-z):'
      letter = gets.chomp

      if letter == 'save'
        save_game
        @saved_game = true
        return
      end

      was_found = false

      @secret_word_arr.each_with_index do |ltr, i|
        if ltr == letter
          @player_guess[i] = letter
          was_found = true
        end
      end

      unless was_found
        @used_letters << letter if @used_letters.find_index(letter).nil?
        @countdown -= 1
      end

      p @player_guess
      p @used_letters
      p @countdown
    end
  end

  private

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

  def save_game
    temp_hash = {'secret_word' => @secret_word,
                 'used_letters' => @used_letters,
                 'player_guess' => @player_guess,
                 'countdown' => @countdown}
    json_string = JSON.dump temp_hash

    File.open('temp.txt', 'w') { |f| f.write(json_string)}
  end

  def load_game
      temp_file = File.read('temp.txt')
      temp_hash = JSON.parse(temp_file)

      @secret_word = temp_hash['secret_word']
      @used_letters = temp_hash['used_letters']
      @player_guess = temp_hash['player_guess']
      @countdown = temp_hash['countdown']
  end
  
end

game = Hangman.new
game.start