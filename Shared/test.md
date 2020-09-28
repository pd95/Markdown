# Markdown test file

## Headline H2

H2 with underline
--

Plain text with Emoji 😃

HTML entities: &ge; &copy;

*bold* **emphasis** `code` _underline_
\&\

### Lists

1. Item 1
2. Item 2
    - Unordered Items
    - Another unordered item

4) Item 4

5) Item 5

### Quotes

   > [link](/u "t")
   >
   > - [footnote]
   > - ![image link](/u "t")
   >
   >> FTP: <ftp://hh>  
   >> Mail: <u@hh>

### Code blocks

```swift
let x = 12.9
var aString = "Hello world!"
// Comment bla
```

~~~
cb Framed code block
~~~

    c1 A code block...
    c2 by intending

### Separator line

***

### Embedded HTML block

<div>
<b>x</b>
</div>

### Table

| a | b |
| --- | --- |
| c | `d|` \| e |

### Strikethrough

google ~~yahoo~~


### Autolinking

google.com http://google.com google@google.com

### Embedded HTML custom tags

Disallowed `xmp` tag should be filtered <xmp> but custom `surewhynot` should be rendered

<surewhynot>
sure
</surewhynot>

see [GitHub Flavored Markdown Spec](https://github.github.com/gfm/#disallowed-raw-html-extension-)

### Footnote definition

Nothing should follow this line.

[footnote]: /u "t"
