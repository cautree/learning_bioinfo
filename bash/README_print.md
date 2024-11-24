

```
printf "%s\\n" $input_list | tr -d '[],' | sort -V > all_files.txt

```

Bottom line: it's a stylistic decision. There's no functional difference between:
```
printf '%s\n' 'No input entered'
printf 'No input entered\n'

```