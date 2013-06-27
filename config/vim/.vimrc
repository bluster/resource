set nocompatible
syntax on
set background=light

set showmatch
set ignorecase
set showmode
set ts=4
set sw=4
set tw=80
set wrap
set nolist
set formatoptions+=cr
set autoindent
set smartindent
set autowrite

set smarttab
set expandtab
set softtabstop=4

set tags=./tags;/


augroup binary
    au!
    " No trailing newline, etc
    au BufReadPre   *.bin{,.*},*.img,*.exe  set bin
    " Convert bin to readable on load
    au BufReadPost  *.bin{,.*},*.img,*.exe  %!xxd
    au BufReadPost  *.bin{,.*},*.img,*.exe  set ft=xxd
    " Convert back to bin before write
    au BufWritePre  *.bin{,.*},*.img,*.exe  %!xxd -r
    " Undo conversion after write
    au BufWritePost *.bin{,.*},*.img,*.exe  u
    " Don't show buffer as modified
    au BufWritePost *.bin{,.*},*.img,*.exe  set nomod
augroup END

filetype plugin indent on

function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction
command! PrettyXML call DoPrettyXML()

" ex command for toggling hex mode - define mapping if desired
command -bar Hexmode call ToggleHex()

" helper function to toggle hex mode
function ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editHex") || !b:editHex
    " save old options
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary " make sure it overrides any textwidth, etc.
    let &ft="xxd"
    " set status
    let b:editHex=1
    " switch to hex editor
    %!xxd
  else
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editHex=0
    " return to normal editing
    %!xxd -r
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction

