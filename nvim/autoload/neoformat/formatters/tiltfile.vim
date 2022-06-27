function! neoformat#formatters#tiltfile#enabled() abort
    return ['buildifier', 'black']
endfunction

function! neoformat#formatters#tiltfile#buildifier() abort
    return {
        \ 'exe': 'buildifier',
        \ 'args': ['-path', expand('%:p')],
        \ 'stdin': 1,
        \ 'stderr': 1,
        \ 'try_node_exe': 1,
        \ }
endfunction

function! neoformat#formatters#tiltfile#black() abort
    return {
        \ 'exe': 'black',
        \ 'stdin': 1,
        \ 'stderr': 1,
        \ 'args': ['-q', '-'],
        \ }
endfunction
