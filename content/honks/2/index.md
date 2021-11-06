+++
date = "2021-10-25 21:28:00"
+++

Stack Overflow answers for `bash` problems seem way code golfier than other languages. Look at [this function to check if an array contains an element](https://stackoverflow.com/a/8574392/3920202):

```bash
containsElement () {
    local e match="$1"
    shift
    for e; do [[ "$e" == "$match" ]] && return 0; done
    return 1
}
```

I don't know about you but it took me more than a couple glances to see what's happening here. An annotated version:

```bash
containsElement () {
    # Declare e and match as local variables. Initialize match.
    local e match="$1"

    # Shift all positional parameters. $1 gets set to $2, etc...
    shift

    # This is the same as for e in "$@" (who knew in was optional!)
    for e; do
        # If [[ ... ]] return 0
        [[ "$e" == "$match" ]] && return 0
    done

    return 1
}
```
