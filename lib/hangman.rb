class Hangman
  require 'json'

  def initialize
    @saved_game = false
  end

  def start
    continue_saved_game?

    until end_of_game?
      puts 'Enter a letter (A-Z, a-z). You can save your progress by typing "save".'
      letter = gets.chomp

      if letter.downcase == 'save'
        save_game
        return
      end

      process_result(check_letter(letter), letter)
    end
  end

  private

  def pick_random_word
    random_line = ''
    File.open('google-10000-english-no-swears.txt') do |file|
      file_lines = file.readlines() 
      random_line = file_lines[Random.rand(0...file_lines.size())].strip until random_line.length.between?(5,12)
      file.close
    end

    random_line
  end

  def check_letter(letter)
    was_found = false

    @secret_word_arr.each_with_index do |ltr, i|
      if ltr == letter
        @player_guess[i] = letter
        was_found = true
      end
    end

    was_found
  end

  def process_result(was_found, letter)
    unless was_found
      @used_letters << letter if @used_letters.find_index(letter).nil?
      @countdown -= 1

      print_sketch
    end

    print_params
  end

  def print_sketch
    hangman_sketch = File.open('hangman.txt', 'r')
    hangman_sketch.readlines.drop((11 - @countdown) * 10).take(9).each { |line| puts line }
    hangman_sketch.close
  end

  def print_params
    p @player_guess
    p @used_letters
    p @countdown
  end

  def continue_saved_game?
    if @saved_game
      puts 'Would you like to continue the last saved game? [y/n]'
      answer = gets.chomp.downcase
      load_game if answer == 'y'
      initialize_params if answer != 'y'
    else
      initialize_params
    end
    @secret_word_arr = @secret_word.split('')
  end

  def initialize_params
    @used_letters = []
    @countdown = 12
    @secret_word = pick_random_word
    @player_guess = Array.new(@secret_word.length, '_')
  end

  def end_of_game?
    if @player_guess == @secret_word_arr
      puts 'Congratulations! You won!'
      return true
    elsif @countdown.zero?
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

    File.open('temp.txt', 'w') { |f| f.write(json_string) }
    @saved_game = true
  end

  def load_game
    temp_file = File.read('temp.txt')
    temp_hash = JSON.parse(temp_file)

    @secret_word = temp_hash['secret_word']
    @used_letters = temp_hash['used_letters']
    @player_guess = temp_hash['player_guess']
    @countdown = temp_hash['countdown']

    print_sketch
    print_params
  end
end

game = Hangman.new
game.start
