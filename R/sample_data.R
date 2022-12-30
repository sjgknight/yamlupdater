#create sample data

writeLines(paste0('---\n',
                  'title: Hello world\n',
                  'tags:\n  - mytag1\n  - mytag2\n',
                  'authors: ["Sjgknight", "Bob Bobserlsey"]\n',
                  '---\n',
                  'hello world\n',
                  'With some content here, goodbye world.\n'),
           "inst/extdata/sample.md")

