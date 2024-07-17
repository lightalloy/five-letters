# Заполнение базы данных словами из csv-файла

require "sqlite3"
require "csv"

# наши слова для игры - файл формируется скриптом make_word_list.rb
WORDS_FILE = File.join(File.dirname(__FILE__), "words.csv")

# Open a database
db = SQLite3::Database.new(File.join(File.dirname(__FILE__), "words.db"))

# Create a table
words_table = db.execute <<-SQL
  create table if not exists words (
    name varchar(30),
    for_guess integer,
    id integer primary key autoincrement
  );
SQL

db.execute("create unique index if not exists unique_word_name on words (name)")

# очистим базу
db.execute("delete from words")

# записываем слова в базу данных
CSV.foreach(WORDS_FILE) do |row|
  db.execute "INSERT OR IGNORE INTO words (name, for_guess) VALUES ( ?, ? )", row
end

db.execute( "select count(*) from words" ) do |row|
  puts "Всего слов: #{row.first}"
end

# sample data
puts "Sample:"
db.execute( "select * from words order by random() limit 10" ) do |row|
  p row
end

