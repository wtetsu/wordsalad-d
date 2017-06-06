[![Build Status](https://travis-ci.org/wtetsu/wordsalad-d.svg?branch=master)](https://travis-ci.org/wtetsu/wordsalad-d)

# wordsalad-d
Word salad generator written in D

## Example

```D
import std.stdio;
import std.array;
import salad.generator;

int main() {
  string[] lines = [
    "Alice was beginning to get very tired of sitting by her sister on the",
    "bank, and of having nothing to do: once or twice she had peeped into the",
    "book her sister was reading, but it had no pictures or conversations in",
    "it, 'and what is the use of a book,' thought Alice 'without pictures or",
    "conversations?'",
    "So she was considering in her own mind (as well as she could, for the",
    "hot day made her feel very sleepy and stupid), whether the pleasure",
    "of making a daisy-chain would be worth the trouble of getting up and",
    "picking the daisies, when suddenly a White Rabbit with pink eyes ran",
    "close by her.",
    "There was nothing so VERY remarkable in that; nor did Alice think it so",
    "VERY much out of the way to hear the Rabbit say to itself, 'Oh dear!",
    "Oh dear! I shall be late!' (when she thought it over afterwards, it",
    "occurred to her that she ought to have wondered at this, but at the time",
    "it all seemed quite natural); but when the Rabbit actually TOOK A WATCH",
    "OUT OF ITS WAISTCOAT-POCKET, and looked at it, and then hurried on,",
    "Alice started to her feet, for it flashed across her mind that she had",
    "never before seen a rabbit with either a waistcoat-pocket, or a watch",
    "to take out of it, and burning with curiosity, she ran across the field",
    "after it, and fortunately was just in time to see it pop down a large",
    "rabbit-hole under the hedge.",
  ];
  string sourceText = lines.join(" ");

  auto salad = new WordSaladGenerator();
  salad.addText(sourceText);
  salad.delimiter = " ";
  salad.lineFeed = "\n";
  string newText = salad.create();
  writeln(newText);

  return 0;
}
```

* Example1
```
Alice think sleepy never was having to quite it, out conside
ring pictures TOOK well see Alice a sister a was own of on d
id see afterwards, making beginning pictures that bank, her
```

* Example2
```
Alice was it and it much rabbit-hole of her of it in convers
ations?' picking be of it, ran making Alice day close gettin
g started very do: pop out as her in way over book whether t
```

* Example3
```
Alice started the a under mind a Alice over shall looked she
 across be by with seen sister of stupid), that; of at but m
ade had actually TOOK curiosity, she picking over OF she cur
```
