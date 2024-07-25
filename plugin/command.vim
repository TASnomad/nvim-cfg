command! -bar -bang -nargs=+ -complete=file Edit call utils#MultiEdit([<f-args>])
call utils#Cabbrev('edit', 'Edit')

call utils#Cabbrev('man', 'Man')

" show current date & time
command! -nargs=? Datetime echo utils#iso_time(<q-args>)
