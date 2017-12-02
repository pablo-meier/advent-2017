! FACTOR FACTOR FACTOR

USING: combinators io strings math kernel sequences math.parser
       io.encodings.utf8 io.files namespaces ;
IN: captcha-calculate

  
! Reads the file at the parameterized name and pushes an array of text lines
: read-input-file ( -- x ) "../input.txt" utf8 file-lines ;

! given a 1 element array, take the first element
: get-first-line ( arr -- elt ) 0 swap nth ;

! Leave the top of the stack with the length of the sequence
: copy-with-length ( seq -- seq len ) dup length ;


! We abuse dynamic variables to create a 'mappable' word. It feels like cheating.
SYMBOL: entire-list
SYMBOL: offset
SYMBOL: total-length

: with-index ( elt index -- sum )
    offset get + total-length get mod
    entire-list get nth
    over = [ 1string string>number ] [ drop 0 ] if ;


! The meat
: solve ( length offset seq -- int )
    entire-list set
    offset set
    total-length set
    entire-list get [ with-index ] map-index
    0 [ + ] reduce ;

: part-one ( seq -- soln ) copy-with-length 1 rot solve ;
: part-two ( seq -- soln ) copy-with-length dup 2 / rot solve ;

! HERE WE GO!

read-input-file
get-first-line

dup
part-one
swap

part-two
swap

"Part 1: CAPTCHA IS " write number>string write "\n" write
"Part 2: CAPTCHA IS " write number>string write "\n" write
flush
