# Video 1 | Intro and Setup

LLVM is actually a typed language. It needs to know the type to understand how much memory to allocate and what operations to perform.

This project uses llvm 14. I could not find it on pacman or the arch user repository. I will try running a docker image of ubuntu and install it there.

I've uploaded the Dockerfile and the corresponding script to run it on my github:
https://github.com/FaiqAbdullah2B/eva-llvm-fake

You can use `clang++-14 -S -emit-llvm test.cpp` to emit the `.ll` file, containing the LLVM IR for test.cpp.

a simple LLVM IR looks like 
```
define i32 @main() {
	ret i32 42
}
```

you can use llvm-as to convert the human readable IR to the bitcode format and llvm-dis to convert it back.
# Video 2 | Module

Just need 3 components to start building the compiler.

The **Context** contains **Modules**.
**Modules** contain target information, function definitions and declarations, and global variables.
We use the **IR Builder** to emit the IR data.

We created the compiler as a different class which will accept a program string and generate the IR for it.

Again, we initialize the 3 main components in the file. As we only need one instance of each we initialize them using std::unique_ptr. Then we add some helper functions.

The **Context** is the global LLVM context and manages the core global data structures of LLVM's core infrastructure, include type and constant unique tables.

**Modules** are the top level container of all other LLVM IR objects

It contains a GlobalList object that is used to hold the constant references to all the global variables in the module.

# Video 3 | Basic Numbers & Main Function

We start by writing a scrip hours now with added time from the evening.t to compile and run the file, which again can be found on my github.

Setup some functions in the code to make up our main function in the IR. It's the first thing the lli (llvm IR interpreter) searches for in the .ll file and throws an error if it can't find it.

Functions in llvm contain
1) Parameter Types, Return Types and Varargs flag
2) Entry Basic Block
3) May contain Branch instructions
4) To more basic blocks
5) Basic blocks contain terminator instructions

We created a main function by specifying it's name and return type, Search for a prototype and if it doesn't exist, then define one in the module and attach an entry basic block to the function.

To this function we then add a return statement to return 42 just to see if our code works.

# Video 4 | Strings & Extern Calls

@ prefix used for global symbols
llvm treats strings as character arrays 

easy to create strings, just use the builder.

You can make LLVM use extern libc functions by just calling get or insert function and pass the C function name. What you do is declare the function only and at link time the linker searches for the function in the libc family if it wasn't defined in your file.

# Video 5 | Parsing & S-expression

We tokenize the code of our language using a Lexer, and below is an ai-generated overview of how the lexer works. This is necesaary because the instructor explains this in a different class so additional context is needed.

A lexer (or tokenizer) takes a raw stream of text (like source code) and breaks it down into meaningful chunks called **tokens**, while ignoring things the computer doesn't need to parse (like whitespace and comments).

## Part 1: Decoding the Lex Syntax Structure

Here is how to read the structure of the block:

- **`%lex` and `/lex`**: These declare the boundary of the lexer section. Everything inside is treated as lexer configuration and rules.
    
- **`%%`**: This is the separator. Anything above `%%` would be lexer options (like case-insensitivity configurations). Anything below `%%` is a list of **lexical rules**.
    
- **The Rules Structure**: Each line below `%%` follows a simple pattern:
    
    $$\text{[Regular Expression Pattern]} \quad \text{[Action / Token Name]}$$
    
    - If the match results in **`%empty`**, the lexer simply throws that text away (ignores it).
        
    - If it results in a name like **`STRING`** or **`NUMBER`**, the lexer packages that text up as a "token" of that type and hands it to the parser.
        

## Part 2: The Regular Expressions (Step-by-Step)

Let's break down exactly what each of those regex patterns is searching for.

### 1. Single-Line Comments

Code snippet

```
\/\/.* %empty
```

- `\/`: Escapes the forward slash. Because `/` is often a delimiter in regex, we write `\/` to mean a literal `/`. Thus, `\/\/` matches `//`.
    
- `.`: Matches any single character _except_ a newline.
    
- `*`: Matches the previous character (any non-newline character) zero or more times.
    
- **What it does:** Matches a literal `//` and everything after it on that same line.
    
- **Action:** `%empty` (ignores single-line comments).
    

### 2. Multi-Line Comments

Code snippet

```
\/\*[\s\S]*?\*\/    %empty
```

- `\/\*`: Matches the literal starting characters `/*` of a block comment.
    
- `[\s\S]`: This is a clever regex trick. `\s` matches any whitespace (spaces, tabs, newlines), and `\S` matches any non-whitespace. Putting them together in a bracket `[\s\S]` means **"absolutely any character, including newlines."** (This is used because the standard dot `.` doesn't match newlines).
    
- `*?`: Matches zero or more of those characters, but **non-greedily**. The `?` tells the regex engine to stop at the _first_ possible closing match, rather than swallowing the whole file.
    
- `\*\/`: Matches the literal closing characters `*/`.
    
- **What it does:** Matches any comment block that starts with `/*` and ends with `*/`, even if it spans multiple lines.
    
- **Action:** `%empty` (ignores block comments).
    

### 3. Whitespace

Code snippet

```
\s+                 %empty
```

- `\s`: Matches any whitespace character (spaces, tabs, vertical tabs, form feeds, and newlines).
    
- `+`: Matches the previous character one or more times.
    
- **What it does:** Matches any sequence of spaces, tabs, or newlines.
    
- **Action:** `%empty` (ignores whitespace so the parser doesn't have to deal with it).
    

### 4. String Literals

Code snippet

```
\"[^\"]*\"          STRING
```

- `\"`: Matches a literal double-quote character `"`.
    
- `[^ ... ]`: This is a negated character class. It means "match any character _except_ the ones inside."
    
- `[^\"]*`: Matches zero or more characters that are **not** double-quotes. This keeps the match inside the boundaries of the string.
    
- `\"`: Matches the closing double-quote.
    
- **What it does:** Matches double-quoted string literals, like `"hello world"`.
    
- **Action:** Returns a `STRING` token.
    

### 5. Numbers

Code snippet

```
\d+                 NUMBER
```

- `\d`: Matches any digit from `0` to `9`.
    
- `+`: Matches one or more digits.
    
- **What it does:** Matches positive whole numbers (integers) like `42` or `1009`. _(Note: This simple regex won't match decimals like `3.14` or negative numbers like `-5` unless they are handled by other rules)._
    
- **Action:** Returns a `NUMBER` token.
    

### 6. Symbols and Identifiers

Code snippet

```
[\w\-+*=!<>/]+      SYMBOL
```

- `[...]`: A character class matching any single character listed inside the brackets.
    
- `\w`: Matches any "word" character (equivalent to `[a-zA-Z0-9_]`).
    
- `\-`: Matches a literal hyphen `-`. (It is escaped with a backslash so the regex doesn't think it's defining a range, like `a-z`).
    
- `+*=!<>/`: Matches any of these literal characters: `+`, `*`, `=`, `!`, `<`, `>`, `/`.
    
- `+`: Matches one or more of any of the characters listed above.
    
- **What it does:** This is a catch-all rule. It bundles variable names, math operators, comparison operators, and boolean operators into a single category. For example, `x`, `count`, `==`, `>=`, and `tmp-value` will all match this.
    
- **Action:** Returns a `SYMBOL` token.

---

Here's an overview of the syntactic grammar, which is essential the **parser** for the language:

## Part 1: The C++ Helper Code (`%{ ... %}`)

The code block wrapped in `%{` and `%}` is pure C++ that is injected directly into the final parser's generated file. It defines the data structure that will hold your parsed code: the **Abstract Syntax Tree (AST)**.

### 1. The Expression Types (`enum class ExpType`)

C++

```
enum class ExpType {
  NUMBER,
  STRING,
  SYMBOL,
  LIST,
};
```

This defines the four physical forms any parsed expression can take in this language:

- `NUMBER`: A plain integer (e.g., `123`).
    
- `STRING`: Text wrapped in quotes (e.g., `"hello"`).
    
- `SYMBOL`: Variable names, functions, or operators (e.g., `+`, `myVar`, `print`).
    
- `LIST`: A grouped series of expressions wrapped in parentheses (e.g., `(foo 1 2)`).
    

### 2. The Expression Struct (`struct Exp`)

This is the core data structure. Think of it as a multi-tool container. It has fields for all possible value types, but it only uses the ones relevant to its current `type`:

C++

```
struct Exp {
  ExpType type;

  int number;                  // Holds the value if it's a NUMBER
  std::string string;          // Holds the value if it's a STRING or SYMBOL
  std::vector<Exp> list;       // Holds child expressions if it's a LIST (Recursive!)
```

> **Note the Recursion:** Because a `LIST` contains a vector of `Exp` objects, and those `Exp` objects can be _other_ lists, this single struct can represent infinitely deep, nested trees of code.

#### The Constructors

To make creating these nodes easy, there are three constructor overloads:

- **For Numbers:**
    
    C++
    
    ```
    Exp(int number) : type(ExpType::NUMBER), number(number) {}
    ```
    
    Sets the type to `NUMBER` and saves the integer.
    
- **For Strings and Symbols:**
    
    C++
    
    ```
    Exp(std::string& strVal) {
      if (strVal[0] == '"') {
        type = ExpType::STRING;
        // Strip the outer double quotes: "hello" -> hello
        string = strVal.substr(1, strVal.size() - 2);
      } else {
        type = ExpType::SYMBOL;
        string = strVal;
      }
    }
    ```
    
    If the string starts with a double-quote (`"`), it strips the quotes off and marks it as a `STRING`. Otherwise, it treats it as a raw identifier (`SYMBOL`).
    
- **For Lists:**
    
    C++
    
    ```
    Exp(std::vector<Exp> list) : type(ExpType::LIST), list(list) {}
    ```
    
    Packages a vector of other expressions together and marks it as a `LIST`.
    

### 3. The Value Directive

C++

```
using Value = Exp;
```

This tells the parser generator that every time it matches a grammar rule, the resulting semantic value returned by that rule (represented by `$$`) should be of type `Exp`.

## Part 2: The Syntactic Grammar (`%% ...`)

This section defines the rules of the language. In parser rules:

- `$$` represents the output value of the current rule.
    
- `$1`, `$2`, `$3` represent the values of the components on the right-hand side, from left to right.
    

### 1. The Entry Point (`Exp`)

Code snippet

```
Exp
  : Atom
  | List
  ;
```

**An expression is either an Atom (a single, basic unit) or a List (parenthesized grouping).** This is the master rule that drives the entire parser.

### 2. Parsing Atoms (`Atom`)

Code snippet

```
Atom
  : NUMBER { $$ = Exp(std::stoi($1)) }
  | STRING { $$ = Exp($1) }
  | SYMBOL { $$ = Exp($1) }
  ;
```

This rule takes the individual tokens matched by your lexer and transforms them into our C++ `Exp` struct:

- **`NUMBER`**: The lexer returns a string of digits (like `"42"`). `$1` is that string. `std::stoi($1)` converts it to an actual integer `42`, which is then passed to our C++ `Exp` constructor.
    
- **`STRING` & `SYMBOL`**: Their token strings are passed directly into the string constructor, which automatically decides whether to strip the quotes or treat them as identifiers.
    

### 3. Parsing Lists (`List`)

Code snippet

```
List
  : '(' ListEntries ')' { $$ = $2 }
  ;
```

A `List` is physically represented as an opening parenthesis `(`, followed by a sequence of expressions (`ListEntries`), followed by a closing parenthesis `)`.

- `$1` is `(`, `$2` is `ListEntries`, and `$3` is `)`.
    
- `{ $$ = $2 }` tells the parser: "The value of this entire list is simply the vector of entries inside the parentheses."
    

### 4. Accumulating Entries (`ListEntries`)

Code snippet

```
ListEntries
  : %empty          { $$ = Exp(std::vector<Exp>{}) }
  | ListEntries Exp { $1.list.push_back($2); $$ = $1 }
  ;
```

This is a standard **left-recursive accumulator pattern**. It defines how to collect zero-or-more expressions inside your parentheses:

- **Base Case (`%empty`):** If there is absolutely nothing between the parentheses (like `()`), it returns an empty `Exp` containing an empty `std::vector<Exp>`.
    
- **Recursive Case (`ListEntries Exp`):** If we already have a list of entries (`$1`) and the parser encounters _another_ expression (`$2`), it appends the new expression to the existing list: `$1.list.push_back($2)` It then sets the current rule's output (`$$`) to this updated list (`$$ = $1`), propagating it up.

___

Now that the parser is done, we move on to using it in our code. We create a pointer on it and call tha parse method giving to it our program string from the driver code, which generates the AST. The AST has the type Exp (expression) which we move on to our compile function, which calls the gen function which returns the llvm value and emits the required IR. After setting it up for the different exp types we can run the program and see that it works, but there is just a bug in the string output. This is because there is no newline at the end of the string output from printf and due to that the return value gets jumbled up with the string output.

