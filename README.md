# Linear Instructions Language (liin)
![Логотип](liin_logo.png)

[![Pub Package](https://img.shields.io/pub/v/liin_lang.svg)](https://pub.dev/packages/liin_lang)
[![Dart Version](https://img.shields.io/badge/Dart-2.8.1-blue.svg)](https://dart.dev)
[![GitHub License](https://img.shields.io/badge/License-MIT-blue.svg)](https://raw.githubusercontent.com/uslashvlad/liin_lang/master/LICENSE)

# Что это?
Итак, ну думаю стоит начать с того, что мне сложновато это назвать языком программирования, поэтому я называю это обычно языком инструкций. И вот этот язык можно назвать функциональным, интерпретируемый, с динамической, но строгой типизацией

У языка философия следующая: всё состоит из инструкций и пустых строк. Инструкции это то, что выполняется, а всё остальное - пустые строки (несмотря на то, что сейчас есть уже и комментарии). На данный момент инструкции разделяются на объявления, команды и настройки. Объявление - операции с переменными (или объявление блока), команды - выполнение каких-либо действий в основном потоке выполнения, настройки - выполнение некоторых специфических действий до основного потока, например импорт кода

Пример кода:
```liin
. Комментарий
! inp << input
! a = inp * 2
> if a > 10
    . Тоже комментарий
    > print a
> if a <= 10
    > print -a
```
Эта программа получает на вход число, умножает его на 2, если оно больше 10, выводится без изменений, иначе меняется знак числа

И сделано всё это чудо полностью на замечательном языке Dart :)

# Как на этом писать?
А теперь поговорим о синтаксисе. Здесь он довольно простой. Каждое действие с новой строчки, и тут главные начала строчек:
- `!` - начало для любых объявлений и разделяется на:
    - просто `!` - объявление переменной. Далее должно идти имя переменной, операнд (присвоение `=`/плюс `+=`/минус `-=`/умножение `*=`/деление `/=`/остаток от деления `%=` либо операция получение значения команды `<<`). В случае с обычными операциями, то после операнда указывается выражение, в случае с командной операцией `<<` после операнда указывается команда (все параметры также можно указывать, как и при обычном вызове функции)
    - `!x` или `!X` - удаление переменной. Далее идёт имя переменной
    - `!>` - объявление блока. Далее указывается имя блока. После строчки с объявлением блока, код пишется с отступом, для обозначения границ блока. Вызывается блок командой `run <имя блока в кавычках>`
- `>` - начало для любой команды. После этого символа пишется имя команды и аргументы (через запятые)
- `#` - начало для любых настроек, то есть команд препроцессора. Настройки обрабатываются до выполнения кода, так что тут не существует переменных и команд основного кода
- `.` - обозначение комментария. Строчка, которая начинается с такого символа (отступы можно игнорировать), не будет выполняться

Теперь, полагаю, стоит поговорить и о самих выражениях и тиках данных. Здесь тип данных определяется сам по себе в зависимости от того, что писать в выражении. Выражение это в принципе всё, что указывается в значении переменной, в аргументе и в вводе. `1 + 1`, `true || false`, `"lmao"`, `5.25` - это всё выражения. bool, int и string между собой не скрестить в рамках одного выражения и в рамках одной переменной, разные типы чисел могут использоваться в одном контексте, тип преобразуется в наиболее подходящий. Всё это - магия модуля `expressions`, магия, работающая отлично.

Также есть возможность импортировать другой liin код при помощи настройки `include`. Импортировать можно как локальные файлы, так и код из интернета (через http запросы). Делается это так:
```liin
. Импорт локального файла
# include a.liin
. Импорт файла из интернета
# include https://raw.githubusercontent.com/uSlashVlad/liin_lang/master/lang_examples/hello_world.liin
```

**[Про все команды можно узнать здесь](COMMANDS.md)**

**[Также примеры кода есть здесь](examples/)**

# Как с этим работать?
Ну вот синтаксис, наверное, стал понятен, а что с этим делать-то?

Данный модуль [есть в pub](https://pub.dev/packages/liin_lang) 

Можно работать с этим всем, как с модулем, то есть импортировать, запускать код и получать из него какие-то результаты:
```dart
import 'package:liin_lang/liin_lang.dart';

void main() async {
    final r = await runLiin(
        fileName: 'instructions/lines.liin',
        runInput: ['96', '"Hello World!"'],
    );
    print('Executed in ${r.executionTime.inMilliseconds}ms');
}
```

Также можно работать с простым интерпретатором языка прямо из терминала при помощи установленного Dart. Тут есть несколько вариантов

1) После импорта модуля в проект, вызвать интерпретатор можно через
```bash
pub run liin_lang
```

2) Использовать `pub global` для "установки" и "удаления"
```bash
# Установка
pub global activate liin_lang
# Удаление
pub global deactivate liin_lang
# Запуск
liin_lang
```

3) Компиляция и использование скомпилированных бинарных файлов. Скомпилированные исходники работают значительно быстрей, так что это если не хочется использовать `pub global` по каким-то причинам, можно скачать исходник и в корневой папке проекта использовать
```bash
# Для компиляции под текущую ОС
dart compile exe bin/liin_lang.dart
# Для компиляции в AOT
dart compile aot-snapshot bin/liin_lang.dart

# Для запуска exe
bin/liin_lang.exe
# Для запуска AOT снапшота
dartaotruntime bin/liin_lang.aot
```
Я постараюсь прикрепить AOT снапшот к репозиторию на GitHub

Можно указать файл и тогда просто выполнится файл. Если не указать, то можно построчно выполнять команды. Для ввода блоков надо разделять на строки, это делается через `\\\` (надо учесть, что этот символ делит строки, даже если этот символ внутри выражения). Например можно вот так:
```bash
❯ liin_lang
.! version = "0.1.0 alpha"
.! author = "u/vlad"
>> > print "Hello World!"
Hello World!
```

Для получения информации о использовании интерпретатора можно использовать просто аргумент `help`

# Что будет дальше?
Ну самое главное - дальше будет добавлена работа с файлами **[Готово!]**. Изначально разрабатывалось всё под работу с изображениями, так что добавлю и это. Также надо придумать, как правильней будет реализовать инструкции для интерпретатора (что-то вроде изначальных "настроек"), константные переменные тут тоже стоит сделать, надо оптимизировать парсер, ускорить анализ. Возможно будет всё настолько плохо, что придётся во всю эту структуру вклинивать асинхрон

Также надо перевести эту тонну текста на английский, а то **pub.dev** ругается, да и сам понимаю, что надо...

А теперь списком:
- [X] Работа с файлами
- [X] Работа со строками
- [ ] Работа с изображениями
- [X] Много примеров :)
- [ ] Хороший парсер, анализатор и препроцессор
- [ ] **Модули и модульность языка**
- [ ] Перевод документации на английский
- [X] Дополнительны комментарии
- [X] Улучшение интерпретатора
- [X] Перенос на dart null safety
- [X] Тестирование

# Как это появилось?
Началось всё это с идеи автоматизировать скриншоты ежедневные одного сайта, поэтому я на NodeJS сделал простенький скрипт, который делал скрин сайта, писал на нём кое-какие данные и отправлял этот скрин в ВК. Однако тут мне пришла идея создать что-то вроде отдельно интерпретатора для команд по рисованию на картинке, чтобы, например, делать скрин, потом запускать отдельный скрипт, который бы написал и нарисовал на скрине всё, что мне надо. Выглядело это как-то так:
```liin
Этот код рисовал чёрную линию из верхнего левого угла в центр картинки
> line 0; 0; x / 2; y / 2; 0xff000000
```
Далее я игрался с рисованием линий и подумал, что было бы неплохо сделать ещё переменные и циклы, чтобы рисовать по несколько линий по определённом алгоритму. Тут я переписал код ещё пару раз, сделал блоки кода, сделал переменные, всё работало по философии какого-то супер функционального языка (даже более функционального, чем он есть сейчас), вставляя, например, переменную i в while, ты вставлял только значение i в конкретный вызова while. Аргументы разделялись через ";", отступы обозначались через "-". Всё это я сделал где-то за 2 вечера и половину выходного. На этом моменте развития это выглядело как-то так:
```liin
! a = 1
! b = 2 + 3
> count 5
-> print 1
```
Тут тоже было много перемен. В какой-то промежуток времени были константы, обозначающиеся через "!!", до констант были "настройки", по факту константные переменные, которые получают сразу все значения на уровне первичного анализа, где бы в коде они не находились. Сначала был только цикл count, который просто выполнял свой блок кода указанные N раз, позже реализовал while как строковое выражение, которое потом уже парсилось. На этом этапе парсинг и построчное выполнение были одним целым, программа сразу читала код, определяла, что есть что, выполняла. При этом комментариев как таковых не было: всё, что не было инструкциями, было "пустыми строками", а значит удалялись перед выполнением

После некоторых размышлений, некоторых идеи и 2 университетских лекций по программированию, через ~полторы недели я вернулся к проекты, я переписал весь интерпретатор с нуля. Теперь сначала проходит парсинг с анализом, а только потом уже выполнение по проанализированным строкам. Были в большей мере задействованы регулярные выражения, были добавлены блоки (слабый аналог функций), переменные в команды терерь переходят в виде выражений, и только потом парсятся, команды теперь могут возвращать значения. Также появились комментарии, так как с усложнением кода, стало иногда трудно находить ошибки, так как ошибочные строки пропускались на уровне первичного анализа

И вот сейчас я на этом этапе развития проекта, этапе версии **0.1.0**. Думаю, что если буду развивать идею, то ещё много чего поменяю, но по-крайней мере какой-то живучий скелет кода создан, осталось только создать функционал и доделать до полноценного вида

# Помочь идее?
Нет помощи лучше, чем помощь кодом. Поэтому буду рад вкладам в виде кода больше всего. Особенно в области парсера, так как там я довольно слаб. По каким-либо вопросам, просьбам, пожеланиям и прочем можно писать в [issues](https://github.com/uSlashVlad/liin_lang/issues) на GitHub, но если хочется поговорить со мной более лично, то можно писать на мою странички во [**ВКонтакте**](https://vk.com/uslashvlad), мне в лс в [**Телеграме**](https://t.me/uslashvlad), ну и как вариант можно писать на мою [почту-помойку](mailto:idroidservv@gmail.com) или на [почту DT](mailto:debils.technologies@gmail.com)