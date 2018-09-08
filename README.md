
[![Build Status](https://travis-ci.org/bukin242/nmax.svg?branch=master)](https://travis-ci.org/bukin242/nmax)

# Nmax

Программа поиска максимальных чисел в файле

* Читает из входящего потока текстовые данные
* По завершении ввода выводит n самых больших целых чисел, встретившихся в полученных текстовых данных

## Особенности реализации
* Чтение из файла блоками (благодаря чему использование памяти рационально, линейно и не растет при использовании большого файла)
* Размер блоков устанавливается в lib/configuration.rb (по умолчанию 1КБ)
* Использование лимитированного буфера для сортировки чисел
* Можно использовать гем продключив к своему rails проекту и получить массив чисел из файла

## Установка

```
  $ git clone git@github.com:bukin242/nmax.git
  $ cd nmax
  $ bundle install
  $ rake install
```

## Использование

```
  cat ./sample.txt | nmax 10
```

## Использование в качестве библиотеки

Подключите в Gemfile своего проекта
```
  gem 'nmax', :git => 'git@github.com:bukin242/nmax.git'
```
Пример использования
```
  limit_numbers = 5
  file = File.open('./sample.txt')
  puts Nmax::Finder.numbers_list(limit_numbers, file)
```
