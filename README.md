# BMW/BMM Ripper

This tool rips a massive amount of bmw/bmm files from a website I found.

It will generate 1000s of files, however they are all very small and shouldn't cause any issues in terms of storage. 

## Requirements 
- Any version of linux/unix (makes system calls that will not work on Win/OSX)
- ruby

## Usage
Invoke the script with 

```
ruby bmw-ripper.rb
```

It will create a directory called 'tunes' in the current directory where all of the bmw files will be placed.
