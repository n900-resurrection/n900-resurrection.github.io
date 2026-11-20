---
layout: post
title: "A language model on the N900: 3 tokens per second, and why not bigger"
author: elPytel
tags: [n900, maemo, ai, llm, llama2c]
---
After [TINY]({{ site.baseurl }}{% post_url 2026-11-18-tiny-a-neural-network-on-the-n900 %}), a quiz robot with 367,000 weights, the obvious question was how much *bigger* a model an N900 can run. This is what we tried and what we decided, with
the numbers.

## The idea

Two links started it. EXO Labs ran a Llama model [on a Windows 98 Pentium II](https://blog.exolabs.net/day-4/) with 128 MB of RAM ([llama98.c](https://github.com/exo-explore/llama98.c)), and they did it with
[llama2.c](https://github.com/karpathy/llama2.c), Andrej Karpathy's inference engine for the Llama 2 architecture: **one C file of about 970 lines, no dependencies**. EXO measured **39 tokens per second for a 260 thousand
weight model and 1.03 tokens per second for stories15M** (15 million weights). The N900 is a 600 MHz ARM Cortex-A8 with 256 MB of RAM, a better machine than that Pentium II on paper, so it should do at least as well.

## What we measured

`run.c` compiled for the phone **without a change** (the cross compiler of [the development kit]({{ '/guide/developing/' | relative_url }}) targets ARMv7 with NEON; `-O3 -ffast-math`, and `-lrt` for the clock on the old glibc).
The models are the TinyStories models of Karpathy, which tell very simple children's stories:

| Model | Weights | File (fp32) | N900 |
|---|---|---|---|
| TINY 2.1 (for comparison) | 0.37 M | 0.4 MB (8 bit) | about 5 to 17 letters per second, a different kind of network |
| stories260K | 0.26 M | 1 MB | (not measured, it would be fast) |
| **stories15M** | 15 M | 61 MB | **2.95 tokens per second** |
| stories42M | 42 M | 167 MB | **0.03 tokens per second** (31 seconds per token) |
| stories110M | 110 M | 438 MB | not tried, it cannot be better |

The prompt "One day, a little robot" continued, in the first try with stories15M, to "named Tim was playing in the park. He liked to slide down the big slide, and he would laugh and have fun. Tim saw his friend, a little girl named Sue,
playing nearby.". About three times the speed of the Pentium II, and readable as it comes.

## Why not bigger

stories42M is only three times larger than 15M and 100 times slower. The reason is memory, not the processor. `llama2.c` maps the weights from the file (`mmap`), and for every token it has to read **all** of them.
15M fits in RAM (61 MB), 42M (167 MB) does not: the phone has 245 MB, and the system and the running applications already use almost all of it (a few megabytes were free when I measured). So every token is read again from
the flash memory of the phone.

## The decision: models that fit in RAM, and no swapping

Reading from the flash is slow, but the thing that mattered more to us is **wearing it out**. The N900 has a swap partition of 768 MB on the same flash, and writing to it is what kills a flash chip over time. So the rule is:

- **The model has to fit in RAM comfortably.** About 160 MB would be the ceiling for a model, and in practice less, because the system lives there too.
- **The weights are only mapped for reading** (`mmap`, read only). Such pages are clean: when the kernel needs the memory, it drops them and reads them again from the file, and **never writes them to the swap**.
  I checked it: the swap in use was 157 to 160 MB before and after the runs with the 42M model, and it did not move. (That swap is occupied by other applications, which is a reason to close the browser before an experiment.)
- What `llama2.c` allocates itself is the state of the run, mostly the cache of the context: about 3.5 MB for stories15M (context 256), and about 33 MB for stories42M (context 1024), which is more than it sounds.

So we like **small models**, and stories15M at 3 tokens per second is a speed we find acceptable: a sentence takes a few seconds, and you can read as it is written.

## What it is good for

The TinyStories models do one thing: they **continue a text** the way a child's story goes. They do not answer questions (that is why TINY, with its facts, is a different toy), they do not know the world and they do not hold a conversation.
It is a pocket story teller. Its charm is that a language model with real attention layers works on a phone from 2009 at all.

## Install it

Both packages are in the repository of this project: [llama2c]({{ '/packages/llama2c/' | relative_url }}) (the engine and the terminal launcher) and [llama-chat]({{ '/packages/llama-chat/' | relative_url }}) (the chat window).
After [adding the repository]({{ '/guide/software-setup/' | relative_url }}), on the phone as root:

```bash
apt-get install llama-chat      # brings llama2c with it
```

The package has the tiny 1 MB model, so it works at once. In the terminal, `llama-story` asks before it downloads stories15M (61 MB, checked by SHA-256) to `~/llama2c`; `man llama-story` and `man llama2c` explain the switches.

## The chat window

The terminal launcher was the first step; the second is **Story teller** in the menu. The main view is a chat: write the first words of a story, tap **Send**, and the text is written token by token while you read it
(**Stop** cuts it short, an empty field and Send means "go on"). The menu of the title bar has the settings: the temperature, top-p, the length of a turn and how many words of the story the model remembers, and a list of **models**.
Tap a model to see its size, its speed on the N900 and its licence, and to use, download (checked by SHA-256) or delete it. You can add your own models in `~/.llama-chat/models.json`.

The list has a second model besides stories15M: **TinyStories 25M**, a Llama of 25 million weights from Hugging Face. It is not in the format of `llama2.c`, so the application downloads the checkpoint (98 MB) and **converts it on the phone** with a small
Python program that needs no numpy or PyTorch (it reads the safetensors file one tensor at a time, 80 MB at most). It writes 2.45 tokens per second here, slightly slower than 15M and a little more fluent. Its author did not state a licence, so we only link to it and do not
put it in the repository: the application downloads it from Hugging Face when you ask.

## What next

- An **int8 quantized** 42M (about 45 MB) would be interesting; the conversion that `llama2.c` offers needs PyTorch on the computer, so it needs a converter of our own first.
- Other pocket models with a clear licence: the list in the application is a JSON file, new ones are easy to add.
- The whole point of this exercise is that "small" is a feature.
