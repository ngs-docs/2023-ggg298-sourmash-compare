#! /usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

cat(args, sep="\n")

input_file <- args[1]

cat(input_file)

output_format = "html_document"
if (length(args)==3) {
  output_format = args[2]
}

rmarkdown::render(input_file, output_format=output_format)
