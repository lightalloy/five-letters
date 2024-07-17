require "sqlite3"
require "rainbow"
require "./lib/game"
require "./lib/turn"

DB_NAME = "db/words.db".freeze

db = SQLite3::Database.new DB_NAME

guess_word_rows = db.execute("select name from words where for_guess = 1 order by random() limit 1")
guess_word = guess_word_rows.first.first

instructions =  <<~INSTRUCT
  💻: Я загадал слово из пяти букв

  Если буква есть в загаданном слове и она на своём месте, она будет на жёлтом фоне, например, так: #{Rainbow(" а ").white.bg(:yellow)}
  Если буква есть в загаданном слове на другом месте, она будет на розовом фоне, например, так: #{Rainbow(" м ").black.bg(:pink)}
  Если буквы нет в загаданном слове, она не будет выделена

  Отгадайте слово или напишите "сдаюсь"
INSTRUCT

puts instructions

MAX_TRIES = 5

game_result = Game.new(guess_word: guess_word, db: db, max_tries: MAX_TRIES).play

case game_result.state
when "give-up"
  puts "Я загадал слово \"#{guess_word}\""
when "success"
  puts "Поздравляем! Вы отгадали слово 🎉"
when "not-guessed"
  puts "Вы не отгадали :("
  puts "Я загадывал слово \"#{guess_word}\""
else
  puts "Что-то непонятное"
end

exit
