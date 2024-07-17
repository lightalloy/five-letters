# Игра "5 букв" / Wordle

```
bundle install
bundle exec ruby play.rb
```

База данных со словами (sqlite) включена в репозиторий (`db/words.db`)

Формирование базы слов с помощью скриптов:
- `db/make_word_list.rb` (запись в csv-файл)
- `db/seed.rb` (запись в базу)

Ссылки на исходные словари и пояснения - в `db/make_word_list.rb`
