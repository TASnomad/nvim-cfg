local utils = require("utils")

-- Use short names for common plugin manager commands to simplify typing.
-- To use these shortcuts: first activate command line with `:`, then input the
-- short alias, e.g., `pi`, then press <space>, the alias will be expanded to
-- the full command automatically.
utils.cabbrev('pi', 'Lazy install')
utils.cabbrev('pud', 'Lazy update')
utils.cabbrev('pc', 'Lazy clean')
utils.cabbrev('ps', 'Lazy sync')
