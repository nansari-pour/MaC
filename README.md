# Match alleles with Counts

Matching alleles with raw nucleotide counts to call SNV/SNP and calculate VAF/BAF respectively

This method is dependent on
1) An 'alleleCounter' output (this contains the number of reads supporting each nucleotide at a given position on a particular chromosome)
2) An alleles file (four column file containing the chromosome, position and ref and alt nucleotides of each SNV/SNP per row; tab delimited)

To run this analysis, simply execute the following:

module load R

Rscript run_MaC.R "TUMOURNAME"


## How to get alleleCounter output

To get an alleleCounter output, you would need to 

### 1) generate a loci file (this is a two column file with no header which has the chromosome and position of each SNV/SNP)

For this it is essential to know:

a) the genome build of your bams. Are they hg19 or hg38?

You can look at the header of your BAM file to find out (look for the bwa mem command run):

samtools view -H TUMOURNAME.bam

This is important because the genomic coordinates of the SNV/SNP must match the build of the BAM file.

b) the chromosome notation in your bams. Is it e.g. chr2 or 2. You can do this by looking at the chromosome column (usually the 3rd column) in the first few lines of your bam: 

samtools view TUMOURNAME.bam | head

This is important because if the chromosome notation (with or without 'chr') isn't a match, counts will not be generated and the output will be a file of zeros. Essentially, the notation in your loci file must match that of the BAM file.

### 2) Run alleleCounter on the loci file and the BAM file

alleleCounter -l TUMOURNAME_loci.txt -b TUMOURNAME.bam -o TUMOURNAME_ac.txt

NOTE: alleleCounter can be obtained from https://github.com/cancerit/alleleCount
