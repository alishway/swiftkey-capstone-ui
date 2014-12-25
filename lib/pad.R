
#
# pads a vector out to a given length
#
pad <- function (x, n, pad_with = 0) {
    
    if (n > length (x)) {
        xx <- rep (x, length.out = n)
        xx [(length (x)+1):n] <- pad_with
    } else
        xx <- x

    xx
}
