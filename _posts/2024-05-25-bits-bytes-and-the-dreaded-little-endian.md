---
layout: post
title: Bits, Bytes, and the dreaded little-endian
date: 2024-05-25 11:38 -0300
tags: [computers, bitcoin]
---

There’s a common confusion among new bitcoin protocol developers: little-endian vs. big-endian.

At its core, Bitcoin is a communication protocol.
As such, we should specify how information is to be encoded as bits to be transmitted through a channel.
Let's see how this is done.


## Bits, bytes, and hexadecimal

One bit is the information we provide when asked to choose between two options.
Take, for instance, the question *"Do you want a cup of coffee?"*.
Maybe you're like me and will always answer "Yeah, sure" when asked for coffee.
But maybe you're more into tea and answer "No, thank you. I would prefer some tea instead".
In any case, the information revealed from your answer (yes or no) is a bit.

More formally, a bit is an element of a set with exactly two elements.
We usually represent these elements as $0$ and $1$, but any two different symbols like 👍 and 👎 would suffice.
Although extremely simple, this concept gives rise to almost all computer science.

We use bits to *encode* more complex information by building *strings* of bits.
Take the letters of the English alphabet.
In the [extended ASCII standard](https://en.wikipedia.org/wiki/ASCII), the letter `a` is encoded as the binary string `01100001`, the letter `b` as `01100010`, the letter `c` as `01100011`, and so on according to the encoding table.
This encoding is fairly arbitrary and, indeed, [many others have been proposed](https://www.youtube.com/watch?v=_mZBa3sqTrI).

Writing binary information in bits is quite inconvenient for humans to read since the strings involved get quite large very quickly.
For example, the previous phrase would be encoded in ASCII as the binary string 
```
0101011101110010011010010111010001101001011011100110011101000000110001001101001011011100110000101110010011110010100000011010010110111001100110011011110111001001101101011000010111010001101001011011110110111001000000110100101101110010000001100010011010010111010001110011010000001101001011100110100000011100010111010101101001011101000110010101000000110100101101110011000110110111101101110011101100110010101101110011010010110010101101110011101000100000011001100110111101110010010000001101000011101010110110101100001011011100111001101000000111001101101001011011100110001101100101010000001110100011010000110010101000000111001101110100011100100110100101101110011001110111001101000000110100101101110011101100110111101101100011101100110010101100100010000001100111011001010111010001000000111000101110101011010010111010001100101010000001101100011000010111001001100111011001010100000011101100110010101110010011110010100000011100010111010101101001011000110110101101101100011110010101110.
```

That’s why we use hexadecimal digits: they compress binary strings but they still are quite easy to read on you get used to it.
We group 4-bits together and associate the group to one of 16 different symbols.
Conventionally, this is the mapping:
```
0000 = 0      0100 = 4      1000 = 8      1100 = c
0001 = 1      0101 = 5      1001 = 9      1101 = d
0010 = 2      0110 = 6      1010 = a      1110 = e
0011 = 3      0111 = 7      1011 = b      1111 = f
```

So, instead of writing that long string of bits we would write 
```
57726974696e672062696e61727920696e666f726d6174696f6e20696e206269747320697320717569746520696e636f6e76656e69656e7420666f722068756d616e732073696e63652074686520737472696e677320696e766f6c76656420676574207175697465206c61726765207665727920717569636b6c792e
``` 
in hexadecimal notation.
Still pretty long, but definitely an improvement.

But make no mistake: internally, computers still deal with those bits.
They are binary machines, not base-16 machines.
The hexadecimal notation is a form of abstraction so that humans interact with less symbols at a time.


## Storing bits in the computer

The computer memory can be understood as a two-column table, the first being an *address* and the second the information stored in that address.
In memory diagrams, it's conventional to represent lower addresses below.
```
| address | data |
| —------ | —--- |
| ...     | ...  |
| 3       |      |
| 2       |      |
| 1       |      |
| 0       |      | 
| ------- | ---- |

```

For efficiency reasons, the computer will not access individual bytes in memory.
Instead, we design it to read or write a string of bits we call a *word*.
The machine you are using to read this probably implement a 64-bit word size, meaning it will read or write 64-bits each time it access the memory.
And since bits in memory will never be accessed individually, we organize the memory to store more information at each address.
Historically, the memory has been organized in bytes.
Thus, to store a 64-bit word in memory, we need to organize the bits in 8-bit slots.

We have essentially two options[^1] when doing so.
The first is to **store less significant bytes in lower addresses**.
We call this scheme *little-endian* (the end of the string is in the "little" address).
That is, the word `0123456789abcdef`[^2] would be stored like so in memory.
```
| address | data |
| —------ | —--- |
| ...     |      |
| 8       |      |
| 7       | 01   |
| 6       | 23   |
| 5       | 45   |
| 4       | 67   |
| 3       | 89   |
| 2       | ab   |
| 1       | cd   |
| 0       | ef   | 
| ------- | ---- |
```

[^1]: In fact, we have many more since this organization is arbitrary; but engineers tend to design logical rules to follow during the design of complex systems instead of doing too much ad hoc solutions.

[^2]: `0000 00001 0010 0011 0100 0101 0110 0111 1000 1001 1010 1011 1100 1101 1110 1111` in binary.

The alternative scheme is called *big-endian* in which we **store most significant bytes in lower addresses** in memory.
The same word would be stored like so.
```
| address | data |
| —------ | —--- |
| ...     |      |
| 8       |      |
| 7       | ef   |
| 6       | cd   |
| 5       | ab   |
| 4       | 89   |
| 3       | 67   |
| 2       | 45   |
| 1       | 23   |
| 0       | 01   | 
| ------- | ---- |
```

## The conventional Positional number system is little-endian

Little-endian memory organization is more common in hardware architecture ([x86](https://en.wikipedia.org/wiki/X86), [ARM](https://en.wikipedia.org/wiki/ARM_architecture_family), and [RISC-V](https://en.wikipedia.org/wiki/RISC-V) are little-endian).
It makes more sense in my mind to be little endian because it is closer to how we conventionally write numbers.
Let me explain.

We are so used with reading numbers that we look at, e.g., $$5375$$ and we immediately associate a meaning to it.
But we forget that $$5375$$ is a string of symbols that have to be interpreted in some way.
The interpretation is based on the position of each digit in the string so that the digit $$5$$ mean different things depending on where it appears on the string.
When we write $$5375$$, what we mean is
\\[
5 \times 10^3 + 3 \times 10^2 + 7 \times 10^1 + 5 \times 10^0.
\\]
We call the leftmost $$5$$ the *most significant digit* and the rightmost $$5$$ the *least significant digit*.

We can think of the exponents associated with the position of each digit as indices (or addresses) of an array.
Under this interpretation **the conventional positional number system is little-endian** since the least significant digit is in the lower address.
A little-endian computer would store it like the following.
```
| address | data |
| —------ | —--- |
| ...     |      |
| 4       |      |
| 3       | 5    |
| 2       | 3    |
| 1       | 7    |
| 0       | 5    | 
| ------- | ---- |
```

## The source of confusion

We have established that the conventional positional number system is little-endian and we already had a perfectly convenient notation to represent strings of digits in it: the most significant digit on the leftmost position and the least significant digit in the rightmost position.

The problem lies in how the designers of the first computer systems decided to represent arrays of memory in text-based terminals.
Since we usually want to scan memory from lower addresses up, they decided to show lower addresses content on the left position since this is how we read text in the western languages.
That is, in mathematics we write the number $$5375$$ as the string of digits
```
array: [5, 3, 7, 5]
index:  ^3 ^2 ^1 ^0
```
But computer scientists decided to show lower indices on the left.
```
array: [5, 7, 3, 5]
index:  ^0 ^1 ^2 ^3
```

Note that we changed nothing except for the order we write stuff on the screen.
Each digit still keep the same index as before, they all mean the same thing.
But while in math (and in English) we write $$5375$$, the computer would show it as the array `[5, 7, 3, 5]` if we just scan the digits in order.
Of course we design programming languages with this in mind and, when we ask it show show something as a number (e.g. by saying something has the type `unsigned int`) it will print the digits in the conventional order we expect.
But when we print raw bytes from memory, the computer will show them starting from the one in the lower address.
And since it will print from left to right, we end up seeing the most significant byte in the rightmost position.

That's why people usually say little-endian is "inverted" and [big-endian is how we write numbers in math](https://en.wikipedia.org/wiki/Endianness)[^3].

[^3]: Quoting [Wikipedia](https://en.wikipedia.org/wiki/Endianness): "A big-endian system stores the most significant byte of a word at the smallest memory address and the least significant byte at the largest. A little-endian system, in contrast, stores the least-significant byte at the smallest address. **Of the two, big-endian is thus closer to the way the digits of numbers are written left-to-right in English, comparing digits to bytes**."


## What about Bitcoin?

Remember, Bitcoin is a communication protocol.
Bits are transmitted in a certain order that has to be agreed between the sender and the receiver in advance.
In the case of Bitcoin, bytes are transmitted in little-endian order.
That means the least significant byte is sent first and the most significant last.

This is quite unusual.
Since 1994, [RFC 1700](https://www.rfc-editor.org/rfc/rfc1700) is considered the de facto standard for data representation in the Internet community.
It established that we should "express numbers in decimal and to picture data in big-endian order. That is, fields are described left to right, with the most significant octet on the left and the least significant octet on the right."
There's even a very instructive diagram reproduced below to explain what it calls big-endian.
```
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|       1       |       2       |       3       |       4       |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|       5       |       6       |       7       |       8       |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|       9       |      10       |      11       |      12       |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```
That is, the word `0123456789abcdef` in our previous example is to be interpreted as the decimal number $$81985529216486895$$ and is to be transmitted `01` first, then `23`, and so on.

Satoshi decided to do the opposite.
In the Bitcoin protocol, the word `0123456789abcdef` is to be transmitted `ef` first, then `cd`, and so on.
I can only speculate why he decided so, I have not talked to him or seem the original source code.

If I was to prototype[^4] this in C[^5], I would start with something in the lines of:
```c
#include <stdio.h>

typedef struct Type_t {
  unsigned long field_0;
  unsigned char field_1;
  unsigned int  field_2;
} Type_t;

int main(void) {

  Type_t data = {
    .field_0 = 81985529216486895, // 0x0123456789abcdef
    .field_1 = 'a',
    .field_2 = 0x12345678
  };

  unsigned char *buffer = (unsigned char*) &data;

  for (unsigned int count = 0; count < sizeof(Type_t); count++) {
    printf("%02x ", *buffer);
    buffer++;
  }

  printf("\n");
  return 0;
}
```

[^4]: Not the safest code, I admit... But it's not as bad as a starter to get stuff running for later refactoring and optimization.

[^5]: Satoshi client was written in C++, but the principle still applies. I believe he chose C++ to use the Windows API.

Structs would be used to model the basic data structures, i.e., transactions and blocks.
Then, it's pretty easy to "serialize" them in bytes by declaring a pointer to the structure and iterate.
Since my machine architecture is little-endian (and probably Satoshi's was too), the output of this program is (slightly modified with the interpretation of the bytes):
```
| ef cd ab 89 67 45 23 01 | 61 00 00 00 | 78 56 34 12 |
|    81985529216486895    |     'a'     | 0x12345678  |
|         field_0         |   field_1   |   field_2   |
```

We see that the decimal number $$81985529216486895$$ is encoded as `0x0123456789abcdef` in binary as we saw in the beginning of this essay but was transmitted `ef` first since this is the bytes that lies in the lower memory address.
Note `field_2` that I initialized using hexadecimal notation, it appears to be inverted.
But this is only a illusion caused by the way we iterated over the memory to transmit (print) the bytes.

I added `field_1` on purpose to show why this is not what's actually done in practice.
To codify the character `'a'` we need only 1 byte, but instead we used 4 bytes in the actual memory representation.
This has to do with the memory alignment C will guarantee since it optimizes memory access in most hardware architectures.
It is a waste, though, to transmit those `00` bytes over the wire and the actual implementation would have to account for this.

Nothing of this would be confusing if the software would be done by humans for computers.
But **software is primarily done by humans to humans**.

The Bitcoin client has means of printing raw transaction bytes.
This is useful for troubleshooting, but also to integrate the client with other tools in the proven [UNIX style](https://en.wikipedia.org/wiki/Pipeline_(Unix)).

A Bitcoin transaction is a structure with four fields as you can see in the [source code](https://github.com/bitcoin/bitcoin/blame/327f08bb0cd91a22249395adeb34549e3c86ca76/src/primitives/transaction.h#L295) below:
1. a vector of inputs;
2. a vector of outputs;
3. a version number (as of 2024, version 2 as the default value);
4. a locktime field.

```cpp
/** The basic transaction that is broadcasted on the network and contained in
 * blocks.  A transaction can contain multiple inputs and outputs.
 */
class CTransaction
{
public:
    // Default transaction version.
    static const int32_t CURRENT_VERSION=2;

    const std::vector<CTxIn> vin;
    const std::vector<CTxOut> vout;
    const int32_t nVersion;
    const uint32_t nLockTime;
...
```

Transaction serialization is a bit messy (but very compact indeed).
Please refer to this picture from the excellent book Mastering Bitcoin.

![Schematic view of transactions serialization on the Bitcoin protocol](https://raw.githubusercontent.com/bitcoinbook/bitcoinbook/6d1c26e1640ae32b28389d5ae4caf1214c2be7db/images/mbc3_0601.png){: width="60%" style="padding:20px" }

The protocol establishes that the version number is to be transmitted first.

This is how Bitcoin Core would print an [arbitrary transaction](https://mempool.space/tx/6058da307336ec3bb68995cf219be46ddfe6677a4b129ce7d4039ee750597819):
<div class="language-plaintext highlighter-rouge">
<div class="highlight">
<pre class="highlight">
<code><strong>02000000</strong>000103568dd1825592685e1d935a72ad010a2016dd2c1685a09ea42ab49f0ff7b627d5000000001716001416d9eb9dffdfeb73ff44f6ffa58e1b5ee5cc6d1bfeffffff6b291b4bf55d2be2e92f4039c02468bbdfd0062cbbb0efe808f00db42567ea110100000017160014c6ea53f427c4164b3f237fd927cb2b9e93a02c7efeffffff40dff6f939ea18bdcfce7880c5fca1e262f29b50562698544c5777021640588a00000000171600149922b1ab7b311ed179dcda2ab00f462f47f1e545feffffff026fb706000000000017a91422251663a65443999aac3d6c6b2e90a21599bb1c8710720d000000000017a91443cebfeae33b728056f07ef9efcd1bcdda26e6c18702473044022029438a447eab2053b30d7f9367e095873a4ccc548bfbc87bc970892dde73fbee022023f0a75cf0e8fdfc470f4ec0a7cba3891c02c6a4044898d2b5a8b0a32db5377e0121032e65155f2275b807885a65bdb6e5bd4e87146bb6d2ad0244a4e48271d87b58ba0247304402200b29cfd2a087ed6da90eae65b3e4728f0308aabe141bccb3c1b4abeb1476c13a02202cb3f08a092e89e6e75481513a9749ab5017c1e2650b78ec8d349715d80fec62012103d1eeb2591c9a9a5da2fa7741ed4e8a9483670e640f581177096950f25e9da2860247304402200d552df608a7ad48fd356f25c64cd687233e7d0b0cac76cffacd81c4c0546a0d02203eb5029d54c9dd6aedd19a9f79d2e89e4461a0a32206b43bce3dae10caac8c9e012102ed6b608a14e982e87c7329793479c7de803960ee3f05887f5e9bf31c6280042722e20c00
</code></pre></div></div>

I emphasized the first four bytes of the version field.
It prints in the order the bytes are to be transmitted, when read from left to right.
Since this is little-endian, it is supposed to be read as `00000002` as we saw before, which translates to the integer $$2$$.


## Conclusion

I hope this essay made sense for you and helped you understand better what we mean by little and big-endian.
I see little-endian representation as a more natural choice than big-endian.
Not only it aligns with what's happening in most hardware around, but it also makes sense in a mathematical perspective.
The only quirk is the order we chose to display arrays in memory long time ago.

<hr>
