# PhoneDictionary
  
## Introduction
This project will convert the given 10 digit phone number into the list of words.

### Description
Given a 10 digit phone number, you must return all possible words or combination of words from the provided dictionary, that can be mapped back as a whole to the number.

- With this we can generate numbers like 1-800-motortruck which is easier to remember than 1-800-6686787825.
- The phone numbers will never contain a 0 or 1.
- Words have to be at least 3 characters.
- The conversion of a 10 digit phone number should be performed within 1000ms.
- The phone number mapping to letters is as follows:

2 = a b c

3 = d e f

4 = g h i

5 = j k l

6 = m n o

7 = p q r s

8 = t u v

9 = w x y z

The basic Dictionary is stored in ./assets/docs/dictionary

## Approach
The basic assumptions for phone directory project are

 1. The phone number is strictly 10 digits long.
 2. The phone numbers will never contain a 0 or 1.
 3. Words have to be at least 3 characters.

The Assumptions 1 and 2 relate to validity of the input telephone number. Hence before passing the input parameters, the phone number needs to be checked for validity. 

The Assumptions 1 and 3 rule the length of the words that can be found in the dictionary. 

As per the current conditions, words that are 1 or 2 characters long are eliminated. Also words longer than 10 characters are eliminated automatically. 

Also, words that are 8 and 9 characters long are eliminated immediately as the rest of the string would be 1 or 2 digits long. So my approach here is to create buckets of dictionary words based on their length and consider the words that are between 3 and 7 letters long and all words that are 10 letters long.

The supplied dictionary is 1.2 MB in size. If the following words are eliminated from the dictionary, it would reduce the memory utilization. However, the side-effect of this approach would be initial setup time would be required. But for a large number if inputs, this would be compensated as the calculation time would be reduced. 


**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `phone_dictionary` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:phone_dictionary, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/phone_dictionary>.

