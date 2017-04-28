// Written in the D programming language.
/**
 * Wordsalad generator
 *
 * License:   MIT
 */
module salad.generator;

import std.stdio;
import std.string;
import std.datetime;
import std.random;

class WordSaladGenerator
{
  private string[][string][] _dict;

  private string[] _allWords;

  private Random _rnd;

  private int _chain;

  private string _delimiter = null;
  private string _lineFeed = "\\n";

  @property
  public void delimiter(string newDelimiter)
  {
    _delimiter = newDelimiter;
  }

  @property
  public void lineFeed(string newLineFeed)
  {
    _lineFeed = newLineFeed;
  }

  public this()
  {
    uint seed = cast(uint)Clock.currTime.stdTime;
    int chain = 1;
    initialize(seed, chain);
  }

  public this(uint seed, int chain)
  {
    initialize(seed, chain);
  }

  private void initialize(uint seed, int chain)
  in
  {
    assert(chain >= 1);
  }
  body
  {
    _rnd = Random(seed);
    _chain = chain;
    _dict.length = chain;
  }

  /**
   * Add seed text to this instance.
   * Space separated text is only accepted.
   *
   * Params:
   *  text = space separated value
   */
  public void addText(string text)
  {
    string[] arr = text.split(" ");

    for (int i = 0; i < _chain; i++)
    {
      _dict[i] = createDict(arr, i+1);
    }
    _allWords = arr;
  }

  /**
   * Create wordsalad text.
   *
   * Returns:
   *  text = space separated value
   */
  public string create()
  {
    int wordNum = 50;

    string[] words;
    string firstWord = pickOutFirstWord();
    string currentWord = firstWord;
    words ~= currentWord;
    for (int i = 0; i < wordNum; i++)
    {
      string nextWord = pickWord(words);
      if (_delimiter)
      {
        words ~= _delimiter ~ nextWord;
      }
      else
      {
        words ~= nextWord;
      }
    }

    string str = words.join("");
    string lines = splitToLines(str, 60);
    return lines;
  }

  private string[][string] createDict(string[] arr, int num)
  {
    string[][string] dict;

    string[] list;
    list.length = num;
    for (int i = 0; i < arr.length; i++)
    {
      string currentStr = arr[i];

      if (i >= num)
      {
        string key = createKey(arr, i-num, i-1);
        if (key !in dict)
        {
          dict[key] = [currentStr];
        } else {
          dict[key] ~= currentStr;
        }
      }
    }

    return dict;
  }

  private static string createKey(string[] arr, int indexFrom, int indexTo)
  {
    if (indexFrom < 0 || indexTo >= arr.length)
    {
      return null;
    }
    string key = "";
    for (int i = indexFrom; i <= indexTo; i++)
    {
      key ~= "\t" ~ arr[i];
    }
    return key;
  }
  unittest
  {
    string[] arr = ["aaa", "bbb", "ccc", "ddd", "eee"];
    assert(WordSaladGenerator.createKey(arr, -1, 2) == null);
    assert(WordSaladGenerator.createKey(arr,  0, 5) == null);
    
    assert(WordSaladGenerator.createKey(arr,  0, 0) == "\taaa");
    assert(WordSaladGenerator.createKey(arr,  0, 1) == "\taaa\tbbb");
    assert(WordSaladGenerator.createKey(arr,  3, 4) == "\tddd\teee");
  }

  protected string pickWord(string[] words)
  {
    string nextWord = null;

    for (int c = _chain; c >= 1; c--)
    {
      auto dict = _dict[c-1];
      nextWord = getString(words, dict, c);
      if (nextWord !is null)
      {
        break;
      }
    }
    return nextWord;
  }

  protected string getString(string[] words, string[][string] dict, int num)
  {
    string result = null;
    string key = createKey(words, words.length-num, words.length-1);
    if (key in dict)
    {
      string[] candidates = dict[key];
      result = candidates[getRand(0, candidates.length-1)];
    }
    if (!result)
    {
      result = _allWords[ getRand(0, _allWords.length-1) ];
    }
    return result;
  }

  protected string pickOutFirstWord()
  {
    string firstWord;
    //firstWord = _allWords[ getRand(0, _allWords.length-1) ];
    firstWord = _allWords[0];
    return firstWord;
  }

  protected string splitToLines(string str, int charNum)
  {
    string lines = "";

    bool startLine = true;
    int c = 0;
    for (int i = 0; i < 3; i++)
    {
      if (c >= str.length) {
        break;
      }

      int t = c + charNum;
      if (t > str.length)
      {
        t = str.length;
      }
      string s = str[c..t];
      lines ~= s;
      startLine = false;
      if (_lineFeed.length > 0)
      {
        lines ~= _lineFeed;
        startLine = true;
      }

      c += charNum;
    }

    return lines;
  }

  protected int getRand(int min, int max)
  {
    _rnd.popFront();
    return min + (_rnd.front() % (max-min+1));
  }
}
unittest {
  string sourceText = "Alice was beginning to get very tired of sitting by her sister on the bank, and of having nothing to do: once or twice she had peeped into the book her sister was reading, but it had no pictures or conversations in it, 'and what is the use of a book,' thought Alice 'without pictures or conversations?' So she was considering in her own mind, as well as she could, for the hot day made her feel very sleepy and stupid, whether the pleasure of making a daisy-chain would be worth the trouble of getting up and picking the daisies, when suddenly a White Rabbit with pink eyes ran close by her. There was nothing so very remarkable in that; nor did Alice think it so very much out of the way to hear the Rabbit say to itself, Oh dear! Oh dear! I shall be late!' (when she thought it over afterwards, it occurred to her that she ought to have wondered at this, but at the time it all seemed quite natural); but when the Rabbit actually took a watch out of its waistcoat-pocket, and looked at it, and then hurried on, Alice started to her feet, for it flashed across her mind that she had never before seen a rabbit with either a waistcoat-pocket, or a watch to take out of it, and burning with curiosity, she ran across the field after it, and fortunately was just in time to see it pop down a large rabbit-hole under the hedge. In another moment down went Alice after it, never once considering how in the world she was to get out again.The rabbit-hole went straight on like a tunnel for some way, and then dipped suddenly down, so suddenly that Alice had not a moment to think about stopping herself before she found herself falling down a very deep well.";
  auto salad = new WordSaladGenerator();
  salad.addText(sourceText);
  salad.delimiter = " ";
  salad.lineFeed = "\n";
  string newText = salad.create();
  assert(newText.length >= 1);
  writeln(newText);

  string[] lines = salad.splitToLines("aa bb cc dd ee", 5).split("\n");
  assert(lines.length == 4);
  writeln(lines[0]);
  writeln(lines[1]);
  writeln(lines[2]);
  //assert(lines[0] == "aa bb");
  //assert(lines[1] == "cc dd");
  //assert(lines[2] == "ee");
}

