//  name: "Python 101",
//  author: "Tapaneeya Odmung",
//  major: 0,
//  minor: 1,

#import "../shared/title_template.typ": title
#import "../shared/chapter_template.typ": chapter, sidenote, warning, technical

#show: title.with(
  title: "Python 101",
  subtitle: "Faculty of Engineering, Department of Computer Engineering, Chulalongkorn University",
  role: "Translator",
  version: "1.0.2 - translated",
  author: "Tapaneeya Odmung",
  paper: "a4",
  cover_image: image("../assets/python-logo.png"),
)

#outline()

#show: chapter.with(
  name: "Python 101",
  title: "String",
  subtitle: "Chapter 4",
  author: "Tapaneeya Odmung",
  paper: "a4",
)
= String
String is a data type that's contain character from size of 0 upwards. String is ordered from left to right and each has it's own index for positioning. The left most index of string is 0 and each character of a string can be a text, number, or even special characters.
There are multiple way to write a string
- Write by using single quote #h(51pt) 'I am "Python".' #h(24pt) 'I\\'m Python.'
- Write by using double quote #h(46pt) "I'm Python." #h(35pt) "I am \\"Python\\"."
- Write by using triple single quotes #h(120pt) '''I'm "Python".'''
- Write by using triple double quotes #h(115pt) """I'm "Python"."""

#sidenote(
  "12 is an int not a string but '12' is a string if you want to change value in variable x into string. Use str(x).",
)

*Example of accesing character and substring* (Assuming s = "ABCDEFG")
- len(t) will count amount of character in string t but len('') is 0
- s[0] is the same as s[-len(s)] which got "A" but s[-1] got the same result as s[len(s)-1] which got "G"
- Don't forget that index of string must be in range *0 to len(s) - 1* from left to rigth and *-1 to -len(s)* from right to left.
  Therefore we can write s[k] if $-\l\e\n(s) <= k <= (\l\e\n(s)-1)$. Hence "01234"[-6] and "01234"[5] are both wrong.
- s, s[:], s[0:], s[:len(s)], s[::], and s[::1] are the same
- s[::2] is picking every character that has an even index which result as "ACEG", s[1::2] is picking an odd index which result in "BDF".
- s[::-1], s[-1::-1], and s[-1:-(len(s)+1):-1] are equals which result as "GFEDCBA".
- If you wrote s[a:b] for choosing substring. a and b can be any integer value there are no wrong choices.
  - "01234"[2:50000] results as "234", #h(32pt) "01234"[4999:50000] results as ""
  - "01234"[-500:-2] results as "012", #h(32pt) "01234"[-3:-500:-1] results as "210",
  - "01234"[-500::-300] results as "",
- Use `for c in s` in order to breakdown each character in string s from left to write and assign it to variable c in order to use it within a loop.

*Example of string handling* (Assuming s = "#"  Python 3.6  "")
- t = s.upper() #h(32pt) will result in t got "#"  PYTHON 3.6  "" #h(32pt) s stays the same.
- t = s.lower() #h(34pt) will result in t got "#"  python 3.6  "" #h(43pt) s stays the same.
- t = s.strip() #h(39pt) will result in t got "Python 3.6" #h(55pt) s stays the same.
- s = s.strip().upper() will result in s = "PYTHON 3.6"
- k = s.find(c) return smallest index which found c in s that search from index 0 if it's not found it will return -1.\
  k = "engineering".find("ng") will get k = 1 because "ng" is found at index 1 in "engineering"\
  The command if c in s is equal to if s.find(c) >= 0
- k = s.find(c,j) which return the least index that found c in s but start searching at index j forward.
- If we sum two string together, it's meaning that we joining together the strings such as '12'+'23' results as '1223'
- If we multiply the string, that's mean we repeating a string with the amount of times of that integer such as '12'\*3 is '121212'

== Example of managing string
#table(
  columns: (1.5fr, 2.5fr),
  box()[
    We can't change character like s[2] = 'a'.\
    But, we can create new one.
  ],
  box()[
    ```py
    s = s[:2] + 'a' + s[3:]
    ```
  ],

  box()[
    Check if string c contain only 1 characters and it is a vowel character.
  ],
  box()[
    ```py
    if len(c) == 1 and c.lower() in 'aeiou':
        # c is a vowel
        ...
    ```
  ],

  box()[
    Check if string c contain only 1 characters and it is lower english alphabet or not.
  ],
  box()[
    ```py
    if len(c) == 1 and 'a' <= c.lower() <= 'z':
        # c contains an English alphabet
        ...
    ```
  ],
)

== Common List Processing Pattern
#table(
  columns: (1.5fr, 2.5fr),
  box()[
    Processing each character in a string.
  ],
  box()[
    ```py
    """
    Counting how many number is in a string.
    """
    c = 0
    for e in s:
        if '0' <= e <= '9':
            c += 1
    ```
  ],

  box()[
    Processing each character along with it's index.
  ],
  box()[
    ```py
    for i in range(len(s)):
        c = s[i]
        print(i,c)

    # or
    for i,c in enumerate(s):
        print(i,c)
    ```
  ],

  box()[
    Proccesing each character in a string from right to left.
  ],
  box()[
    ```py
    for e in s[::-1]:
        ...

    # or
    for k in range(-1, -(len(s)+1), -1):
        e = s[k]
        ...
    ```
  ],

  box()[
    Process a pair character (the next one that close to the current one) in a string from left to right.
    such as
    ```py
    s = '1234'
    """
    In pair we meant
    '12', '23', '34'
    """
    ```
  ],
  box()[
    ```py
    """
    Wanting to count how many character that is a number and it's character next to it also a number (number in pair).
    """
    c = 0
    for k in range(len(s)-1):
    """
    Since we are picking pair that's meant we can only pick only to the one whose index is before the end.
    in this example we stop at '3' because if we access '4' the s[k+1] will be out of bound.
    """
      if '0' <= s[k] <= '9' and '0' <= s[k+1] <= '9':
      # if current is s[k]
      # then next one is s[k+1]
          c += 1
    ```
  ],
  box()[
    Counting how many occurence of character t within s
    ```py
    c = 0
    while t in s:
        c += 1
    """
    This is wrong because if there is character t inside s the condition t in s will always be True hence it will become infinite loop.
    """
    ```
  ],
  box()[
    ```py
    c = 0
    k = s.find(t)
    while k >= 0:
        c += 1
        k = s.find(t, k+1)
        # 'aaaaaa' has 4 'aaa'
    
    # or
    c = 0
    for i in range(len(s)- len(t)+1):
        if s[i:i+len(t)] == t:
            c+=1
    ```
  ],
  box()[
    Using string as a temporary bucket for printing later.
  ],
  box()[
    ```py
    """
    Finding prime number that is less than 30.
    """
    result = ""
    for n in range(2,30):
        for k in range(2, n):
            if n % k == 0: break
            else:
                result += str(n) + ", "
    print(result[:-2])
    """
    This will result as
    2, 3, 5, 7, 11, 13, 17, 19, 23, 29
    """
    ```
  ],
  box()[
    Picking a substring that is in between a formatted string.
  ],
  box()[
    ```python
    """
    Finding a sbustring that's in between "<title>" and </title>"
    (Assuming that every string that has <title> will always have </title>)
    """
    t = input().strip()
    a = t.find("<title>")
    if a >= 0:
    """
      a      j      b
    ..<title>.......</title>
    """
        j = a+len("<title>")
        b = t.find("</title>", j)
        print( t[j:b] )
    else:
        print( 'No title' )
    ```
  ],
  box()[
    Using string as a information bucket in order to change integer into string.
  ],
  box()[
    ```py
    """
    Change a number of month m into a short month name.
    """
    months = "JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC"
    m = int(input())
    if 1 <= m <= 12:
        print( months[(m-1)*3:m*3])
    else:
        print( 'invalid month number' )
    ```
  ],
  box()[
    Using 2 strings to keep information in order to update one string into the other.
  ],
  box()[
    ```py
    """
    Finding currency short name (3 characters) from country short name (2 characters)
    """
    c = input().strip().lower() # country code
    # USA, Thailand, Japan, China, Singapore
    countries = "usthjpcnsg"
    currency_codes = "USDTHBJPYCNYSGD"
    k = countries.find(c)
    if k >= 0:
        k //= 2
        print( currency_codes[3*k:3*(k+1)] )
    else:
        print( 'Not found' )
    ```
  ]
)

== Common Mistake
#table(
  columns: (1.5fr, 2.5fr),
  box()[
    String symbol doesn't match or writing it inside without putting \\ in front.
  ],
  box()[
    ```py
    s = "String
    s = String'
    s = "string'
    s = "You shouted "Hey!" very loudly yesterday"
    ```
  ],
  box()[
    Receiving input from keyboard. Should always use `strip` because user might insert more space on the left or the right.
    such as #"\"  Hello\"" or #"\"hEllo   \""
  ],
  box()[
    ```py
    """
    This code below if user type ok with a space and then enter. The comparison will not equal to 'ok'
    """
    s = input()
    if s == 'ok':
        print('OK')
    """
    Therefore, we should write s = input().stript()
    (Unless, we want to keep every user input for processing)
    """
    ```
  ],
  box()[
    Using index that is not in range of allowed value of string.\
    Don't forget that index of string s can only in range from 0 to len(s) - 1 from left to right and -1 to -len(s) from right to left.
  ],
  box()[
    ```py
    s = input().strip()
    t = ""
    for i in range(10):
        t = s[i] + t
        # if len(s) < 10 will cause an error
    ```
  ],
  box()[
    Using index of string that is not integer.
  ],
  box()[
    ```py
    print( s[n/2] )
    # wrong, because n/2 is a real number
    ```
  ],
  box()[
    Try to change value inside of string.
  ],
  box()[
    ```py
    t = input().strip()
    t[0],t[-1] = t[-1],t[0]
    """
    Try to switch first and last like this is wrong.
    If we want to switch the first and the last. We must create new string
    """
    t = t[-1] + t[1:-1] + t[0]
    ```
  ],
  box()[
    Write a string that is a location of a file with \\ symbol but doesn't use \\\\.
    #sidenote("In python and most of programming language, symbol \ is a special character that is being used to do a lot of operation. In order to use it, we must use 2 of them in order to tell the program that we intend to write a \ symbol.")
  ],
  box()[
    ```py
    s = "c\temp\data\input.txt" # This is wrong.
    # Must be
    s = "c:\\temp\\data\\input.txt"
    ```
  ],
  box()[
    Try to sum string with other data types.
  ],
  box()[
    ```py
    # (Go back to your JavaScript world)
    print("average = " + avg) # This wrong
    # Must be
    print("average= " + str(avg))
    # or
    print("average =", avg)
    ```
  ]
)

#show: chapter.with(
  name: "Python 101",
  title: "File",
  subtitle: "Chapter 5",
  author: "Tapaneeya Odmung",
  paper: "a4",
)

= File
There are many different way to read information to process from file but in this class we will use the most simple method which is reading text file line by line as a string
which has a pattern like this
#table(
  columns: (1fr, 1fr),
  box()[
    Read file line by line using `readline`
    ```python
    infile = open(filename, 'r')
    first_line = infile.readline()
    second_line = infile.readline()
    """
    Using for in is mean reading infile each line only once
    and put that line into a string until reaching the end of the file.
    """
    for line in infile:
        ...
    infline.close()
    # when you are done don't forget to close the file
    ```
    When the line that got read is an empty line that kept in t you will get `t = '\n'` or `len(t)` is 1
    but when there is nothing in file to read it will result in `t = ''` or `len(t)` is 0.
    ```python
    for line in infile:
        ...
    ```
    which is the same as
    ```python
    line = infile.readline()
    while len(line) > 0:
        ...
    ```
  ],
  box()[
    ```python
    """
    We want to read information in a file to find the average value.
    Given that each line keep student id and score.
    """
    infile = open('c:/temp/data.txt', 'r')
    n = 0
    s = 0
    for line in infile:
        sid, sc = line.strip().split()
        s += float(sc)
        n += 1
    infile.close()
    print('average =', (sc/n))

    """
    Another way is to read the file to find the average value but the first line tell us how many lines to read.
    """
    infile = open('c:/temp/data.txt', 'r')
    n = int(infile.readline())
    # read the first line
    s = 0
    for k in range(n):
        sid, sc = infile.readline().strip().split()
        s += float(sc)
    infline.close()
    print('average =', (sc/n))
    ```
  ],

  box()[
    When reading a line from a file there might be a newline symbol (`\n`) at the end of the line (When reading the last line of file there will not have this symbol)
    If we don't want to have the newline symbol don't forget to read the line then using `strip()` the code `\n` will be gone and we don't have to do anything else.
  ],
  box()[
    ```python
    f = open('data.txt', 'r')
    t = f.readline()
    if len(t)>0 and t[-1] =='\n':
        t = t[:-1]

    for line in f:
        if line[-1] == '\n':
            line = line[:-1]
        ...

    # or
    t = f.readline().strip()

    for line in f:
        line = line.strip()
    ```
  ],

  box()[
    Storing information into a file
    ```python
    outfile = open('c:/temp/out.txt', 'w')
    outfile.write(any_string)
    outfile.write(any_string + '\n')
    ...
    outfile.close()
    ```
    #sidenote(
      box()[Remember that `write` doesn't add `\n` for us. Hence when we want to create newline, we have to put that ourselves],
    )
  ],
  box()[
    ```python
    """
    We want to find prime numbers that less than m to a file with 5 numbers per line
    """
    m = int(input())
    outfile = open('D:/primes.txt', 'w')
    c = 0
    result = ""

    for n in range(2,m):
        for k in range(2,n):
            if n % k == 0: break
        else:
            result += str(n) + ", "
            c += 1
            if c % 5 == 0:
                outfile.write(result[:-2]\
                              + '\n')
                result = ""

    if len(result) > 0:
        outfile.write(result[:-2] + '\n')
    outfile.close()
    ```
  ],
)

== Common Mistake
#table(
  columns: (1.5fr, 2.5fr),
  box()[
    When reading information each line from a file.\
    Forgot to remove `\n` resulting in process became an error.
  ],
  box()[
    ```python
    t = input().strip()
    f = open('names.txt', 'r')
    for line in f:
        if line == t:
        # Wrong because a line might have \n
            print(t, ': found in names.txt')
            break
    else:
        print(t, ': not found')
    ```
  ],

  box()[
    File's name has only one of `\` symbol.
  ],
  box()[
    ```python
    of = open('c:\temp\data.txt', 'w')
    # Wrong because \t is a tab write it like this
    of = open('c:\\temp\\data.txt', 'w')
    # or using / because python allow for a file
    # with /
    # (this doesn't imply that \ is the same as /)
    of = open('c:/temp/data.txt', 'w')
    ```
  ],

  box()[
    Open file that doesn't exist on machine.
  ],
  box()[
    ```python
    infile = open('h:\\file.data')
    # If there is no h:/file.data on machine
    # this will cause an error
    fn = input()
    infile = open(fn)
    # This can also cause an error if there
    # is a blank on either front or back.
    # It is safer to strip the value first.
    infile = open( input().strip() )
    ```
  ],

  box()[
    Type `readlines` instead of `readline`
    #sidenote(
      box()[
        `readlines` is using for *reading entire file*.\
        (This will result in a *list of strings* which is not yet introduce so we are not going into details otherwise check the python documentation.)
      ],
    )
  ],
  box()[
    ```python
    infile = open('c:/temp/data.txt')
    first_line = infile.readlines() # Becareful
    second_line = infile.readline() # We should use it
                                    # like this.
    ```
  ],
)

#show: chapter.with(
  name: "Python 101",
  title: "List",
  subtitle: "Chapter 6.1",
  author: "Tapaneeya Odmung",
  paper: "a4",
)

= List
List is a datatype that keep group of information with ordering. Each information has an index with left most information has 0 as it's index.
- List Creation
  - x = [] or x = list() #h(35pt) Create empty list with len(x) is 0
  - x = [0]\*10  #h(64pt) Create x = [0,0,0,0,0,0,0,0,0,0]
  - x = list(a) #h(67.5pt) Create x with information from each value in a (create with `for e in a`)\
    x = list('abcde') #h(40pt) Create x = ['a','b','c','d','e']
    #v(-2pt)
    x = list(range(1,10,2)) #h(15.5pt) Create x = [1,3,5,7,9]
    #v(4pt)
  - a = [1,2,3]; b = [1,2,3]; c = b; d = list(b)
    #v(-2pt)
    Get the result as image below. Interestingly c = b result in c and b to be the same list
    #align(center)[#image("../assets/listptr.png", width: 100pt)]
- Using `+` in order to append list and using `*` in order to `+` multiple of times\
  x = 2\*([1,2,3] + [3,4,5]) Create x = [1,2,3,3,4,5,1,2,3,3,4,5]
- x.append(i) add e at the end (right hand side) of list x
- x.insert(i, e) insert e at index i of list x
- x.pop(i) removing information at index i of list x and *return removed information* as a result
- x.sort() make information in list x sort as an incresing order and this command *return nothing*
- sorted(x) *return new list* that has the same information as x but the resulted list is sorted in increasing order (*x is not changing*)
- sum(x) return summation result of information in list x
- max(x) return maximum value of list x, min(x) return minimum value of list x
- x.count(e) return amount of e occurance appears in list x
- if e in x checking whether e in x or not
- x.index(e) *return least index* that found e in list x if it's found nothing it will cause an error so you have to check first
#v(-8pt)
```python
if e in x:
  k = x.index(e)
  ...
else:
  ...
```
#sidenote("List does not have find like string")
- *`split` and `join` function is not a function of list* but it is a string function that closely relate to list
  - t.split() #h(10pt)return list of substring that split from t using empty space as a splitting point (including "\\r\\n")
  - t.split(s) #h(5pt)return list of substring that split from t using s as a splitting point
  - s.join(x) #h(5.5pt)return strng that got from combining string in list x with s insert in middle

// #pagebreak()

*Examples of accessing information and splitted list within list* (Assuming x= [11,12,13,14,15])
- List has the accessing and choosing splitted list using index with the same method as string
- Use `for e in x:` in order to process each element in list x from left to right by assigning each to `e` in order to use in `for` body.
#warning(
  "Do not change list while list is being process because it will result in unexpected behavior.\nie. for e in x: x = [1,2,3]",
)
- x[0] is the same as x[-len(x)] which get 11
- x[-1] is the same as x[len(x)-1] which get 15
- Don't forget that index of list x must be in between
  - 0 to len(x) - 1 which is from left to right
  - -1 to -len(x) which is from right to left
  Therefore, we can write x[k] if -len(x) <= k <= (len(x) - 1) hence x[-6] and x[5] is wrong
- x[a:b] (slice of list) will always return list
- Write x[a:b] value of a and b can be anything (there is no wrong value)
  - x[2:50000] results in [13,14,15], x[4999:50000] results in []
  - x[-500:-2] results in [11,12,13], x[-3:-500:-1] results in [13,12,11], x[-500:-300] results in []
- x, x[:], x[0:], x[:len(s)], x[::], and x[::1] are equal
- x[::2] will result in splitted list that contain only value of even index x[1::2] will result in sub list with value of odd index
- x[::-1], x[-1::-1], x[-1:-(len(x)+1):-1] are equals which result in [15,14,13,12,11]
*Examples of updating information in list* (Even though we cannot change value in string but we can change value in list)
- x[k] = e is the same as x[k:k+1] = e
- x[a:b:c] = y is overwriting x[a:b:c] with value in list y
  if |c| > 1, len(y) must equal to len(x[a:b:c]) such as
  x = [1,2,3,4,5]; x[::2] = [0,0,0] will result in x = [0,2,0,4,0]
- x[len(x):] = [e] is same as x.append(e)
- x[i:i] = [e] is same as x.insert(i,e)
- x[i:i+1] = [] is same as x.pop(i)
- x += [1,2] and x = x + [1,2] result in x having 2 more members which are both 1 and 2 but these two commands behave differently
  - x += [1,2] meaning putting 1 and 2 at the end of list x
    Like using x.append(1) then x.append(2)
  - x = x + [1,2] meaning *let x be new list* that created from old x which is appended by list [1,2]
  - Hence x = [3]; y = x this result x and y being the same list
    But if putting x = x + [9], this will result in x and y being different list
  - While x = [3]; y = x then x.append(9), this will result in x and y being same list
- A conclusion on different of x = y, x = y[:], x[:] = y, and x[:] = y[:] where x and y are list
  - x = y #h(24pt) point x to *the same list* as y (meaning x and y are pointing at the same list)
  - x = y[:] #h(14pt) point x to *the new list* that has same members as y which is the same as `x = list(y)`
  #v(-6pt)
  - x[:] = y #h(14pt) x still *pointing to the same list* but information of list x is change to be
  #v(-4pt)
  #h(59pt)the same as information of y (when x and y are different list)
  - x[:] = y[:] #h(3pt) same as x[:] = y
// #pagebreak()

== Common List Processing Pattern
#table(
  columns: (1fr, 1fr),
  "Putting information in list for later process",
  box()[
    ```python
    # Read information n times
    n = int(input())
    data = []
    for k in range(n):
        data.append(float(input())
    ```],

  box()[Process *each* information in list from *left to right*\ \ Use `for e in x`],
  box()[
    ```python
    # Wanting to count occurence of e
    # in list x
    c = 0
    for d in x:
        if d == e: c+=1

    # Or using short hand
    c = x.count(e)
    ```],

  box()[
    Process information only in range of interest in list \ \
    Use `for e in x[a:b:c]`
  ],
  box()[
    ```python
    # Want to find sum of score in list x
    # But doesn't want maximum and minimum
    # value
    s = 0
    for d in sorted(x)[1:-1]:
        s+=d

    # Or using short hand
    s = sum(sorted(x)[1:-1])
    ```
  ],

  box()[
    Update information in list \ \
    Use
    #v(-12pt)
    ```python
    for i in range(len(x)):\
        x[i] = ...
    ```
  ],
  box()[
    ```python
    # x is list that kept score information
    # wanting to update the score that less
    # than 3 0by increasing that value
    # by 10%
    for i in range(len(x)):
      if x[i] < 30:
        x[i] += 0.1 * x[i]

    # Do not write like the code below
    # because e is not the same as
    # information as in the list
    # (different information same value)
    for e in x:
        if e < 30:
            e += 0.1*e
    ```
  ],

  box()[
    Getting each value with index
  ],
  box()[
    ```python
    for i in range(len(t)):
        c = t[i]
        print(i,c)

    # or
    for i,c in enumerate(t):
        print(i,c)
    ```
  ],

  box()[
    Getting each information in list *from right to left*
  ],
  box()[
    ```python
    for e in x[::-1]:
        ...

    # or
    for k in range(-1,-(len(x) + 1), - 1):
        # hard to read which prone to error
        e = x[k]
        ...
    ```
  ],

  box()[
    Picking each infomation in list until condition is met
  ],
  box()[
    ```python
    for e in x:
        if <condition>:
            ...
            break
        ...
    else:
        ...
    ```
  ],

  box()[
    Picking each information from a sorted by ascending order list
  ],
  box()[
    ```python
    for e in sorted(x):
        ...
    ```
  ],

  box()[
    Picking each information from a sorted by decending order list
  ],
  box()[
    ```python
    for e in sorted(x)[::-1]:
        ...
    ```
  ],

  box()[
    Process a pair of information that near each other by list order
  ],
  box()[
    ```python
    # We want to check
    # if information in list s
    # is sorted by ascending order or not
    for k in range(len(s)-1):
        if s[k] > s[k+1]:
            print("False")
            break
    else:
        print("True")
    ```
  ],

  box()[
    Picking every element in list in pair (doesn't need to be close to each other) to process
  ],
  box()[
    ```python
    # Want to count how many elements
    # that has left value greater than
    # right value
    # (doesn't need to be close to each other)
    c = 0
    for i in range(len(x)):
        for j in range(i+1< len(x)):
            if x[i] > x[j]: c += 1
    print(c)
    ```
  ],

  box()[
    Sort information in list (using bubble sort)
  ],
  box()[
    ```python
    # Want to sort information
    # in list d in ascending order
    for k in range(len(d)-1):
        for i in range(len(d)-1):
            if d[i] > d[i+1]:
                d[i],d[i+1] = d[i+1],d[i]
    ```
  ],
)

// #pagebreak()

== Common Mistake
#table(
  columns: (1fr, 1fr),
  box()[
    Using index that is out of range of list.\
    Don't forget that range of index on list are\
    *0 to len(x)-1 from left to right* and\
    *-1 to -len(x) from right to left*.
  ],
  box()[
    ```python
    x = [2,3,5,7,11,13,17,19,23]
    s = 0
    for i in range(len(x),0,-1):
        s += i*x[i]
        # This is wrong because i is len(x)
        # which is out of range
    ```
  ],

  box()[
    Index when accessing list is not an integer.
  ],
  box()[
    ```python
    print( x[n/2] )
    # This is wrong because
    # n/2 is not an integer
    ```
  ],

  box()[
    When x is list, do not confuse between `x.append(y)` and `x+=y` because their results are not the same.
  ],
  box()[
    ```python
    x = [1,2,3,4]; x.append( [5] )
    # result in [1,2,3,4,[5]]

    x = [1,2,3,4]; x += [5]
    # result in [1,2,3,4,5]

    x = [1,2,3,4]; x.append( 5 )
    # result in [1,2,3,4,5]

    x = [1,2,3,4]; x += 5
    # this will cause an error
    ```
  ],

  box()[
    Wanting list y to have same value as list x you must choose between `y=x` or `y=list(x)` but normally we don't use `y=x`
  ],
  box()[
    ```python
    x = [1,2,3]
    y = x        # y is the same list as x
    x[2] = 0     # y[2] is also change to 0
    ```
  ],

  box()[
    Write `x = list(str)` will create list that contain each character in `str`
  ],
  box()[
    ```python
    x = list('abc')
    # result in x = ['a','b','c'] not x = ['abc']
    ```
  ],

  box()[
    Getting each information in list to join each other to string but forget that information must be a string in order to be joinable.
  ],
  box()[
    ```python
    x = [1,2,3]
    s = ','.join(x)
    # Error because 1,2,3 are not string

    # Do this instead
    x = [1,2,3]
    t = []
    for e in x:
        t.append(str(e))
    s = ','.join(t)
    # This is correct because t is
    # a list of string
    ```
  ],

  box()[
    Confusing between `x.sort()` and `sorted(x)` commands.\
    `x.sort()` sorts information in list x and does not return any value.\
    While `sorted(x)` is getting information from x to sort and return new list that has the same information as in x but sorted while x stays the same.
  ],
  box()[
    ```python
    x = [9,2,0,4]
    x = x.sort()
    # This is wrong. It will result
    # in x = None because
    # x.sort() return nothing.

    for e in x.sort():
        ...
    # This is also wrong because
    # x.sort() does not return.
    # Therefore, there is nothing
    # to give to e

    # if you want to sort information
    # in x uses x.sort() or x = sorted(x)
    for e in sorted(x):
        ...
    # This ok because sorted(x) return
    # new list that's sort

    x = sorted(x)
    # This also fine because sorted return.
    x.sort()
    # This is ok but remember that it
    # sort on original list.
    ```
  ],

  box()[
    Removing or inserting information to list while breaking down list for processing
  ],
  box()[
    ```python
    x = [1,2,3,3,2,1]
    for e in x:
        if e%2 == 1:
            x.pop(x.index(e))

    # or
    for i in range(len(x)):
        if x[i]%2 == 1:
            x.pop(i)

    """
    this will not result as expected and will cause an error between running (try running the example)
    create temporory list before putting it back to original list
    """
    t = []
    for e in x:
        if e%2 != 1:
            t.append(e)
    x[:] = t
    """
    Interestingly that the last line we use x[:] = t instead of x = t because of wanting to change information in list x to be the same as t but not wanting x to point to the same list as t
    """
    ```
  ],
)

#show: chapter.with(
  name: "Python 101",
  title: "Nested List",
  subtitle: "Chapter 6.2",
  author: "Tapaneeya Odmung",
  paper: "a4",
)

= Nested List
List can contain anything, integer, real number, string, or else, even a list itself. If we give x as a list and x[k] is also a list, then x[k][j] is an information at index j of list x[k].
#h(8pt) x = []\
#h(8pt) x.append( 1 ) #h(64pt) \# [1]\
#h(8pt) x.append( [2,3] ) #h(46.5pt) \# [1,[2,3]]\
#h(8pt) x.append( [4,5,6] ) #h(38pt) \# [1,[2,3],[4,5,6]]\
#h(8pt) x.append( [[7,8]] ) #h(40.5pt) \# [1,[2,3],[4,5,6],[[7,8]]]\
#h(8pt) x.append( [] ) #h(60pt) \# [1,[2,3],[4,5,6],[[7,8]],[]]\
#h(8pt) len(x) is 5, x[1][1] is 3, x[2][1] is 5, x[3][0][1] is 8, len(x[3][0]) is 2, len(x[4]) is 0

== Common Nested List Processing Pattern
#table(
  columns: (1.5fr, 2.5fr),
  box()[Using nested list instead of using normal list for information when each sub list is keeping smaller information with equally size],
  box()[
    ```python
    """
    Using nested list to keep mulitple information of a circle.
    Inside sub list are 3 numbers represent position x and y then radius of a circle such as
    [[0.0, 0.0, 10.0], [1.0 ,5.0 ,3.0]]
    The code below is reading information of each circle from files to a list
    """
    circles = []
    file1 = open('c:/temp/circles.txt')
    for line in file1:
        x,y,r = line.split()
        circles.append( [float(x),float(y),float(r)] )

    """
    The code below is finding the circles that is not touching other circles.
    """
    free = []
    for i in range(len(circles)):
        for j in range(i+1, len(circles)):
            dx = circles[i][0] - circles[j][0]
            dy = circles[i][1] - circles[j][1]
            sumr = circles[i][2] + circles[j][2]
            if dx**2 + dy**2 <= sumr**2: break
        else:
            free.append(circles[i])
    for c in free:
        print(c)
    ```
  ],

  box()[
    Using nested list to create matrix\
    If wanting matrix with size $m times n$, then create list A with len(A) equal to m (number of rows) and len(A[0]) = len(A[1]) = ... = len(A[m-1]) = n (number of columns) such as creating matrix $5 times 3$ with every value 0
    ```python
    A = []
    for k in range(5):
        A.append( [0]*3 )
    ```
  ],
  box()[
    ```python
    """
    Example of find summation of matrix A and matrix B
    """
    A = [ [1,2], [1,1] ]
    B = [ [0,1], [4,3] ]
    C = []
    for i in range(len(A):
        C.append([0]*len(A[i]))
        for j in range(len(A[i])):
            C[i][j] = A[i][j] + B[i][j]
    ```
  ],

  box()[
    Using nested list when
    inside of sublist doens't have to be the same size
  ],
  box()[
    ```python
    """
    Using nested list to keep information with username at index 0 and list of usernames that follows this person for news (at index 1 this list doesn't need to be static size) (this example has 3 inner list) such as
    """
    f = [ ['noon',['pat','koi']], ['wii',['noon','koi']],
          ['pat',['koi','noon','wii']], ['koi',[]] ]
    """
    Want to find which username has max followers.
    """
    maxindex = 0
    for k in range(1,len(f)):
        if len(f[k][1]) > len(f[maxindex][1]):
            maxindex = k
    print(f[maxindex][0],'has max.# of followers :', \
          ', '.join(f[maxindex][1]))

    # or
    max_followers = []
    max_username = ''
    for [username, followers] in f:
        if len(followers) > len(max_followers):
            max_username = username
            max_followers = followers
    print(max_username, 'has max.# of followers :',\
          ', '.join(max_followers))
    ```
  ],

  box()[
    Using nested list as a temporary bucket for `sort` according to setted condition by creating new list that have first member as a condition for `sort`

    #sidenote(box()[
      `sort` on nested list will compare which value is smaller by each element from left to right such as
      ```python
      x = [[3,2],[3,1],\
           [9],[2,5],[3]]
      x.sort()
      """
      This will result in x = [[2,5],[3],[3,1],[3,2],[9]]
      therefore
      [2,5] < [3] < [3,1] < ...
      """
      ```
    ])
  ],
  box()[
    ```python
    """
    From previous example, since we already have f then if we want to sort usernames from amount of followers we can use
    """
    c = []
    for [username,followers] in f:
        c.append([len(followers),username])
    c.sort()
    for [x,username] in c:
        print(username)
    """
    From above example we will get
    f = [ ['noon',['pat','koi']],
          ['wii',['noon','koi]],
          ['pat',['koi','noon','wii']],
          ['koi',[]] ]

    we will get c = [[2,'noon'],[2,'wii'],
                     [3,'pat'],[0,'koi']]
    c.sort() will result as [[0,'koi'],[2,'noon'],
                             [2,'wii'],[3,'pat']]

    If we want to sort with more complicate condition such as sorting by the amount of followers in an ascending order but when having the same amount of followers then sort username in an ascending order also this meant we can use sort() directly but if we were to change from sorting followers in decending order and for username we ant it to be in an ascending order we could use a little trick such as make the number of followers to be negative (inverse the number itself) which result in sorting negative number in decending order instead which is the same as sorting positive number in ascending order.
    """
    c = []
    for [username, followers] in f:
        c.append([-len(followers), username])
    c.sort()
    """
    From above example we will get
    f = [ ['noon',['pat','koi']],
          ['wii',['noon','koi]],
          ['pat',['koi','noon','wii']],
          ['koi',[]] ]

    we will get c = [[-2,'noon'],[-2,'wii'],
                     [-3,'pat'],[0,'koi']]
    c.sort() will result as [[-3,'pat'],[-2,'noon'],
                             [-2,'wii'],[0,'koi']]
    """
    ```
  ],
)

== Common Mistake
#table(
  columns: (1.5fr, 2.5fr),
  box()[
    Wanting to insert into sublist a but insert into big list x instead\
    Must use `x.append(a)` not\
    `x = x+a` or `x += a`
  ],
  box()[
    ```python
    """
    x = [[2,3],[3,4]]
    This is a result of appending a with [2,3] and [3,4] to x
    """
    x = []
    x.append( [2,3] )
    x.append( [3,4] )
    # but it's not the same the code below
    x = []
    x = x + [2,3] + [3,4] # results in [2,3,3,4]
    ```
  ],

  box()[
    Do not create nested list with `*` and\
    Do not write `[a]*n` when a is a list
  ],
  box()[
    ```python
    """
    When we want to create nested list to represent matrix 3x3 with every entries are 0
    """
    x = [ [0,0,0] ] * 3
    """
    print(x) will result in [[0,0,0],[0,0,0],[0,0,0]]
    but list above have all 3 entries to be the same list that's mean when calling x[0][1] = 1
    it will cause x to be [[0,1,0],[0,1,0],[0,1,0]]
    When using x= [[0]*3]*3 will cause the same weird behavour just like above
    hence we have to  to create every inner list to be different list by
    """
    x = [[0,0,0],[0,0,0],[0,0,0]]
    # or using loop
    n = 3
    x = []
    for i in range(n):
        x.append( [0]*n )
    """
    That's mean when we wrote [a]*n. We must be cautious when a is a list, we must use loop instead.
    """
    ```
  ],
)

#show: chapter.with(
  name: "Python 101",
  title: "List Comprehension",
  subtitle: "Chapter 6.3",
  author: "Tapaneeya Odmung",
  paper: "a4",
)
= List Comprehension
\<TODO LMAO>

#show: chapter.with(
  name: "Python 101",
  title: "Tuple, Dictionary, and Set",
  subtitle: "Chapter 7",
  author: "Tapaneeya Odmung",
  paper: "a4",
)
= Tuple, Dictionary and Set
== Tuple
#table(
  columns: (1.5fr, 2.5fr),
  box()[
    Creating `tuple` is the same as creating `list` but using normal brackets instead.
  ],
  box()[
    ```py
    my_list = [1, 2.5, 3, 'A'] # get a list
    my_tuple = (1, 2.5, 3, 'A') # get a tuple
    my_tuple_2 = (1,)
    # get tuple that has a single value
    # notice a comma
    not_a_tuple = (1) # get an integer
    # same as
    not_a tuple = 1
    t1 = tuple('abc')
    # create tuple from string
    # get ('a', 'b', 'c')
    t2 = tuple([1,2,3])
    # create tuple from list
    # get (1, 2, 3)
    ```
  ],
  box()[
    Accessing information like list.
  ],
  box()[
    ```py
    my_tuple[0] # get 1
    my_tuple[1:3] # get (2.5, 3)
    my_tuple[-2:-1] # got (3,)
    ```
  ],
  box()[
    `+` symbol uses for appending tuple.\
    `*` symbol uses for appending tuple multiple time.
  ],
  box()[
    ```py
    a = (2, 3, 5)
    b = (7,)
    p = a + b
    # result as (2, 3, 5, 7)
    q = p*2
    # result as
    # (2, 3, 5, 7, 2, 3, 5, 7)
    a += (2,)
    """
    Same as writing a = a + (2,)
    which meant appending original a with (2,) and creating new tuple.
    result as (2, 3, 5, 2) and assign that tuple to a
    """
    ```
  ],
  box()[
    Cannot modify value in tuple (like string)
  ],
  box()[
    ```py
    my_typle[3] = 'B' # this is wrong
    """
    If we want to modify tuple, we must create new one.
    """
    my_tuple = my_tuple[:3] + ('B',) + my_tuple[4:]
    ```
  ],
  box()[
    In python, everything that has comma in between will result in a tuple such as `t = 1,2,3` when print(t) will result as (1, 2, 3)
  ],
  box()[
    ```python
    a,b,c = (1,2,3)
    # get a = 1, b = 2, c = 3
    x,y = 'A', 'Z'
    # get x = 'A', y = 'Z'
    a,x = x,a

    # swapping value between a and x
    ```
  ],
  box()[
    We can create list of tuple.
  ],
  box()[
    ```python
    L = [('A','B'), (1,20,300), (9.9,)]
    # L is a list of tuple
    L[1] # will result as (1,20,300)
    L[1][2] # will result as 300
    ```
  ],
  box()[
    We can create a tuple of list.
  ],
  box()[
    ```py
    T = (['A','B'], [1,20,300], [9.9])
    # T is a tuple of list
    T[1] # get [1,20,300]
    T[1][2] # get 300
    """
    T is a tuple hence we cannot do T[1] = 9 but since T[1] is a list, hence, we can do T[1][2] = 9.
    """
    ```
  ],
  box()[
    We can create tuple of tuple.
  ],
  box()[
    ```py
    T = ((1,2), (3,4))
    # T is a tuple of tuple
    T[1][0] # get 3
    ```
  ],
  box()[
    The difference of
    `tuple1 += (0,)` and `list1 += [0]` is that\ \
    tuple1 += (0,) is the same as
    tuple1 = tuple1 + (0,)\
    which will create a new tuple (this is slow)
    while list1 += [0]\
    is not equalt to list1 = list1 + [0]
    but more similar to list1.append(0)
    which is adding 0 at the end of list not creating new one. Hence, this is faster.
  ],
  box()[
    ```py
    """
    Try to ran this command an see the result of processing time.
    """
    import time
    n = 100000
    
    t0 = time.time()
    list1 = []
    for k in range(n):
        list1 += [0]
    print(time.time()-t0)

    t0 = time.time()
    tuple1 = tuple()
    for k in range(n):
        tuple1 += (0,)
    print(time.time()-t0)
    ```
  ]
)

== Dictionary
- Using for keeping ordered pair like information ie (key, value)
- There will be only one key that pair with only one value (but value can be list, tuple, ...or anything that can contain smaller value)
- If we have key we can access its value extreamly fast.

#table(
  columns: (1.5fr, 2.5fr),
  box()[
    There are multiple way of creating `dict`. We can also identify value that we want to keep too.
  ],
  box()[
    ```py
    # Creating empty dict
    dict1 = {}
    # or
    dict1 = dict()

    # Creating dict with
    # ('Name', 'Tom') and ('Age', 39)
    # ordered pair.
    dict2 = {'Name': 'Tom', 'Age':39}
    ```
  ],
  box()[
    We can modify and adding value by indentifying key.
  ],
  box()[
    ```py
    D = {'Name': 'Sarah'}
    print(D['Name']) # get Sarah
    D['Age'] = 20 # adding ('Age',20)
    D['Name'] = 'Somsri'
    # Modifying information to ('Name', 'Somsri')
    ```
  ],
  box()[
    `key` of a `dict` can also be integer value, real value, string, or even tuple. But, it cannot be list, dict, or set but `value` of a `dict` can be any data types.
  ],
  box()[
    ```py
    my_dict = {}
    my_dict[1] = 8.00
    my_dict[3.75] = [3, 7, 6]
    my_dict['Hello'] = 'World'
    my_dict[(2,99)] = 999
    # but
    my_dict[[1,2,3]] = '123' # This is not allowed.
    # Cannot use list as a key
    ```
  ],
  box()[
    There are `keys()`, `values()`, and `items()` that can be used with `for...in`.
  ],
  box()[
    ```py
    d = {1:7, 2:8, 3:9]
    # accessing each key in d and assign it to e
    for e in d:

    # accessing each key in d and assign it to e
    for e in d.keys():

    # accessing each value in d and assign it to e
    for e in d.values():

    # accessing each pairs in d as a tuple and
    # assign it to e
    # e[0] is key, e[1] is value
    for e in d.items():

    # accessing each key, value of d and
    # assign it to k, v
    for k,v in d.items():
    ```
    #sidenote(
      box()[
        *Prior to Python 3.7*, when looping through dictionary, *it will not be by an insertion order rather it will be by random.* (For technical person, it will be by hash number order).\ \
        *But since Python 3.7*, when looping through dictionary, *it will always be by an insertion order.*\ \
        *Recommendation*, when creating dictionary we should always *keep the insertion order as a separate list* and looping using that instead. (if we want to keep the same behavior accross all version of *Python 3*)
      ]
    )
  ],
  box()[
    Function `keys()`, `values()`, and `items()` will not result in `list` but something similar to `list` which could be used in `for...in` but cannot be accessed via index.
    #technical(box()[It calls an *iterator object* which will always return value until a Stopiteration error occur that's meant we can write any custom object (which will be in detail on last subject) to be used inside of for...in loop. That's also why not every object in python that can be used in for...in but might not be able to access via index.])
  ],
  box()[
    ```py
    d = {
      'aka': 'as known as',
      'so': 'significant other'
    }
    x = d.keys()

    print(x[1])
    # this is wrong because x is not a list

    # If you want to access all key as a list
    # just turn it into a list.
    x = list( d.keys() )
    print(x[1])
    """
    This is allowed because x is now a list so we could use x[1] but the order of a list is depended on Python version.
    """
    ```
  ],
  box()[
    Function `d.update(d1)` means we adding new information from dict d1 into d and if key in d1 is already existed in d, it will update that value instead.
  ],
  box()[
    ```py
    A = {1:'one', 2:'two'}
    B = {1:'nueng', 3:'sarm'}
    A.update(B)
    """
    This will result in A become
    {1: 'nueng', 2:'two', 3:'sarm'}
    but B will stay the same.
    """
    ```
  ],
  box()[
    Function `pop(key)` will remove the pair of data that has a same `key`. but if `key` does not exist, it will cause an error.
  ],
  box()[
    ```py
    C = {1: 'one', 2: 'two', 3:'three'}
    x = C.pop(1)
    """
    This will result in
    x = 'one'
    C = {2: 'two', 3: 'three'}
    """
    y = C.pop(4) # this will cause an error
    ```
  ],
  box()[
    Using `in` to check if `key`, `value` or `(key,value)` pair is in dict or not but checking `value` is slower than the last two.
    #technical(box()[
      Searching by value is using *linear search*. (O(n))\ But others is using a *hash search*. (O(1))
    ])
  ],
  box()[
    ```py
    D = {1: 'one', 2: 'two', 3: 'three'}
    x = 1 in D # x = True
    y = 4 in D.keys() # y = False
    z = 'two' in D.values() # z = True
    w = (2, 'two') in D.items() # w = True
    """
    Searching using keys and items is much faster than searching by values.
    """
    ```
  ]
)
