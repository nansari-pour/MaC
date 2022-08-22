# Get name of the sample for analysis
Args=commandArgs(TRUE)
TUMOURNAME=toString(Args[1])

# Set the working directory
WORKDIR="/path/to/your/allelecounts/and/alleles/files"
setwd(WORKDIR)
print(getwd())

# Read in the MaC function
source("MaC.R")

# Run MaC function; change prefixes and suffixes as required 
MaC(samplename=TUMOURNAME,
    allelecount.prefix = NULL,
    allelecount.suffix = "_ac.txt",
    allelesfile.prefix = NULL,
    allelesfile.suffix = "_alleles.txt",
    output.suffix = "_mac.txt",
    remove.na = TRUE)
