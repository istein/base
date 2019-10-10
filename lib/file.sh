##
## file related functions
##

dirname2() {
  local path=$1
  [[ $path =~ ^[^/]+$ ]] && dir=. || {              # if path has no slashes, set dir to .
    [[ $path =~ ^/+$ ]]  && dir=/ || {              # if path has only slashes, set dir to /
      local IFS=/ dir_a i
      read -ra dir_a <<< "$path"                    # read the components of path into an array
      dir="${dir_a[0]}"
      for ((i=1; i < ${#dir_a[@]}; i++)); do        # strip out any repeating slashes
        [[ ${dir_a[i]} ]] && dir="$dir/${dir_a[i]}" # append unless it is an empty element
      done
    }
  }

  [[ $dir ]] && printf '%s\n' "$dir"                # print only if not empty
}

#
# Attempt to create a list of directories; throw fatal error lazily in case any mkdir fails
#
base_mkdir() {
    local dir fails=0 failed_dirs=()
    for dir; do
        mkdir -p -- "$dir"
        if (($? != 0)); then
            ((fails++))
            failed_dirs+=("$dir")
        fi
    done
    if ((fails == 1)); then
        fatal_error "Couldn't create directory '${failed_dirs[0]}'"
    elif ((fails > 1)); then
        fatal_error "Couldn't create these directories: ${failed_dirs[@]}"
    fi
    return 0
}
