# Headers

# Header 1
## Header 2
### Header 3
#### Header 4
##### Header 5
###### Header 6

## Font Styles

- **加粗 bold**

- _xieti_ or *Italic* 注意文字和星号紧邻处不能空格，必须紧贴

- ~~删除线 Strikethrough Text~~

- ==高亮文本 Highlight Text==

## Ordered List

1. one
	1. one
	2. two
		1. one
		2. two
3. two
	- one
	- two
5. three
6. four

## Unordered List

* Edward
* Lin
* Amons
	* one
	* two
		* three
		* four

* Edward
* Lin
* Amons
	* one
	* two
		* three
		* four

## Block Quote 引用块

> Block quotes are written like so.
> They can span multiple paragraphs, if you like.
>> You can also have a nested block quote

## Inline URL Links

This is an inline link, <http://www.google.com>.

URL embedded, [Google](http://www.google.com).

## Image

![alt words](Image Link)

## Table | 表格

第一行为表头
第二行是暗示这是表格
从第三行开始就是正式的表格内容

- Example

| 列名1 | 列明2 |
| -     | -     |
| Data1 | Data2 |

## Code block

```
public class Markdown {
	public static void main(String [] args) {
		System.out.println("Markdown is simple!");
	}
}
```

You can specifiy which programming language you are using with delimited blocks if you wish

```c
#include <stdio.h>
int main()
{
   printf("Remarkable markdown editor");
   return 0;
}
```

## Math
You can specify an inline MathJax equation like so $x^2+y^2=z^2$

Or a block level equation with two dollar signs on both sides of the equation:
$$\sum_{i=0}^n i^2 = \frac{(n^2+n)(2n+1)}{6}$$
